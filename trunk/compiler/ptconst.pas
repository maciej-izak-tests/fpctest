{
    Copyright (c) 1998-2002 by Florian Klaempfl

    Reads typed constants

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

 ****************************************************************************
}
unit ptconst;

{$i fpcdefs.inc}

interface

   uses symtype,symsym,aasmdata;

    { this procedure reads typed constants }
    { sym is only needed for ansi strings  }
    { the assembler label is in the middle (PM) }
    procedure readtypedconst(list:tasmlist;def:tdef;sym : ttypedconstsym;writable : boolean);

implementation

    uses
       strings,
       globtype,systems,tokens,verbose,
       cutils,globals,widestr,scanner,
       symconst,symbase,symdef,symtable,
       aasmbase,aasmtai,aasmcpu,defutil,defcmp,
       { pass 1 }
       node,htypechk,procinfo,
       nmat,nadd,ncal,nmem,nset,ncnv,ninl,ncon,nld,nflw,
       { parser specific stuff }
       pbase,pexpr,
       { codegen }
       cpuinfo,cgbase,dbgbase
       ;

{$maxfpuregisters 0}

    { this procedure reads typed constants }
    procedure readtypedconst(list:tasmlist;def:tdef;sym : ttypedconstsym;writable : boolean);
      label
         myexit;
      type
         setbytes = array[0..31] of byte;
         Psetbytes = ^setbytes;
      var
         len,base  : longint;
         p,hp      : tnode;
         i,j,l     : longint;
         varalign  : shortint;
         offset,
         strlength : aint;
         ll        : tasmlabel;
         c_name,
         s,sorg    : string;
         c         : char;
         ca        : pchar;
         tmpguid   : tguid;
         aktpos    : longint;
         obj       : tobjectdef;
         recsym,
         srsym     : tsym;
         symt      : tsymtable;
         value     : bestreal;
         intvalue  : tconstexprint;
         strval    : pchar;
         pw        : pcompilerwidestring;
         error     : boolean;
         old_block_type : tblock_type;
         storefilepos : tfileposinfo;
         cursectype : TAsmSectiontype;
         datalist : tasmlist;

         procedure check_range(def:torddef);
           begin
              if ((tordconstnode(p).value>def.high) or
                  (tordconstnode(p).value<def.low)) then
                begin
                   if (cs_check_range in aktlocalswitches) then
                     Message(parser_e_range_check_error)
                   else
                     Message(parser_w_range_check_error);
                end;
           end;

      begin
         old_block_type:=block_type;
         block_type:=bt_const;
         datalist:=tasmlist.create;

         case def.deftype of
            orddef:
              begin
                 p:=comp_expr(true);
                 case torddef(def).typ of
                    bool8bit :
                      begin
                         if is_constboolnode(p) then
                           datalist.concat(Tai_const.Create_8bit(byte(tordconstnode(p).value)))
                         else
                           Message(parser_e_illegal_expression);
                      end;
                    bool16bit :
                      begin
                         if is_constboolnode(p) then
                           datalist.concat(Tai_const.Create_16bit(word(tordconstnode(p).value)))
                         else
                           Message(parser_e_illegal_expression);
                      end;
                    bool32bit :
                      begin
                         if is_constboolnode(p) then
                           datalist.concat(Tai_const.Create_32bit(longint(tordconstnode(p).value)))
                         else
                           Message(parser_e_illegal_expression);
                      end;
                    bool64bit :
                      begin
                         if is_constboolnode(p) then
                           datalist.concat(Tai_const.Create_64bit(int64(tordconstnode(p).value)))
                         else
                           Message(parser_e_illegal_expression);
                      end;
                    uchar :
                      begin
                         if is_constcharnode(p) then
                           datalist.concat(Tai_const.Create_8bit(byte(tordconstnode(p).value)))
                         else
                           Message(parser_e_illegal_expression);
                      end;
                    uwidechar :
                      begin
                         if is_constcharnode(p) then
                           inserttypeconv(p,cwidechartype);
                         if is_constwidecharnode(p) then
                           datalist.concat(Tai_const.Create_16bit(word(tordconstnode(p).value)))
                         else
                           Message(parser_e_illegal_expression);
                      end;
                    s8bit,
                    u8bit :
                      begin
                         if is_constintnode(p) then
                           begin
                              datalist.concat(Tai_const.Create_8bit(byte(tordconstnode(p).value)));
                              check_range(torddef(def));
                           end
                         else
                           Message(parser_e_illegal_expression);
                      end;
                    u16bit,
                    s16bit :
                      begin
                         if is_constintnode(p) then
                           begin
                             datalist.concat(Tai_const.Create_16bit(word(tordconstnode(p).value)));
                             check_range(torddef(def));
                           end
                         else
                           Message(parser_e_illegal_expression);
                     end;
                    s32bit,
                    u32bit :
                      begin
                         if is_constintnode(p) then
                           begin
                              datalist.concat(Tai_const.Create_32bit(longint(tordconstnode(p).value)));
                              if torddef(def).typ<>u32bit then
                               check_range(torddef(def));
                           end
                         else
                           Message(parser_e_illegal_expression);
                      end;
                    s64bit,
                    u64bit,
                    scurrency:
                      begin
                         if is_constintnode(p) then
                           intvalue := tordconstnode(p).value
                         else if is_constrealnode(p) and
                                 (torddef(def).typ=scurrency)
                           { allow bootstrapping }
                           then
                             begin
                               intvalue:=round(trealconstnode(p).value_real*10000);
                             end
                         else
                           begin
                             intvalue:=0;
                             Message(parser_e_illegal_expression);
                           end;
                        datalist.concat(Tai_const.Create_64bit(intvalue));
                      end;
                    else
                      internalerror(3799);
                 end;
                 p.free;
              end;
         floatdef:
           begin
              p:=comp_expr(true);
              if is_constrealnode(p) then
                value:=trealconstnode(p).value_real
              else if is_constintnode(p) then
                value:=tordconstnode(p).value
              else
                Message(parser_e_illegal_expression);

              case tfloatdef(def).typ of
                 s32real :
                   datalist.concat(Tai_real_32bit.Create(ts32real(value)));
                 s64real :
{$ifdef ARM}
                   if aktfputype in [fpu_fpa,fpu_fpa10,fpu_fpa11] then
                     datalist.concat(Tai_real_64bit.Create_hiloswapped(ts64real(value)))
                   else
{$endif ARM}
                     datalist.concat(Tai_real_64bit.Create(ts64real(value)));
                 s80real :
                   datalist.concat(Tai_real_80bit.Create(value));

                 { the round is necessary for native compilers where comp isn't a float }
                 s64comp :
                   datalist.concat(Tai_comp_64bit.Create(round(value)));
                 s64currency:
                   datalist.concat(Tai_comp_64bit.Create(round(value*10000)));
                 s128real:
                   datalist.concat(Tai_real_128bit.Create(value));
                 else
                   internalerror(18);
              end;
              p.free;
           end;
         classrefdef:
           begin
              p:=comp_expr(true);
              case p.nodetype of
                 loadvmtaddrn:
                   with Tclassrefdef(p.resultdef) do
                     begin
                        if not Tobjectdef(pointeddef).is_related(Tobjectdef(tclassrefdef(def).pointeddef)) then
                          message(parser_e_illegal_expression);
                        datalist.concat(Tai_const.Create_sym(current_asmdata.RefAsmSymbol(
                          Tobjectdef(pointeddef).vmt_mangledname)));
                     end;
                 niln:
                   datalist.concat(Tai_const.Create_sym(nil));
                 else Message(parser_e_illegal_expression);
              end;
              p.free;
           end;
         pointerdef:
           begin
              p:=comp_expr(true);
              if (p.nodetype=typeconvn) then
                with Ttypeconvnode(p) do
                  if (left.nodetype in [addrn,niln]) and equal_defs(def,p.resultdef) then
                    begin
                      hp:=left;
                      left:=nil;
                      p.free;
                      p:=hp;
                    end;
              { allows horrible ofs(typeof(TButton)^) code !! }
              if (p.nodetype=addrn) then
                with Taddrnode(p) do
                  if left.nodetype=derefn then
                    begin
                      hp:=tderefnode(left).left;
                      tderefnode(left).left:=nil;
                      p.free;
                      p:=hp;
                   end;
              { const pointer ? }
              if (p.nodetype = pointerconstn) then
                begin
                  if sizeof(TConstPtrUInt)=8 then
                    datalist.concat(Tai_const.Create_64bit(TConstPtrUInt(tpointerconstnode(p).value)))
                  else
                    if sizeof(TConstPtrUInt)=4 then
                      datalist.concat(Tai_const.Create_32bit(TConstPtrUInt(tpointerconstnode(p).value)))
                  else
                    internalerror(200404122);
                end
              { nil pointer ? }
              else if p.nodetype=niln then
                datalist.concat(Tai_const.Create_sym(nil))
              { maybe pchar ? }
              else
                if is_char(tpointerdef(def).pointeddef) and
                   (p.nodetype<>addrn) then
                  begin
                    current_asmdata.getdatalabel(ll);
                    datalist.concat(Tai_const.Create_sym(ll));
                    if p.nodetype=stringconstn then
                     varalign:=size_2_align(tstringconstnode(p).len)
                    else
                     varalign:=0;
                    varalign:=const_align(varalign);
                    current_asmdata.asmlists[al_const].concat(Tai_align.Create(varalign));
                    current_asmdata.asmlists[al_const].concat(Tai_label.Create(ll));
                    if p.nodetype=stringconstn then
                      begin
                        len:=tstringconstnode(p).len;
                        { For tp7 the maximum lentgh can be 255 }
                        if (m_tp7 in aktmodeswitches) and
                           (len>255) then
                         len:=255;
                        getmem(ca,len+2);
                        move(tstringconstnode(p).value_str^,ca^,len+1);
                        current_asmdata.asmlists[al_const].concat(Tai_string.Create_pchar(ca,len+1));
                      end
                    else
                      if is_constcharnode(p) then
                        current_asmdata.asmlists[al_const].concat(Tai_string.Create(char(byte(tordconstnode(p).value))+#0))
                    else
                      message(parser_e_illegal_expression);
                end
              { maybe pwidechar ? }
              else
                if is_widechar(tpointerdef(def).pointeddef) and
                   (p.nodetype<>addrn) then
                  begin
                    current_asmdata.getdatalabel(ll);
                    datalist.concat(Tai_const.Create_sym(ll));
                    current_asmdata.asmlists[al_typedconsts].concat(tai_align.create(const_align(sizeof(aint))));
                    current_asmdata.asmlists[al_typedconsts].concat(Tai_label.Create(ll));
                    if (p.nodetype in [stringconstn,ordconstn]) then
                      begin
                        { convert to widestring stringconstn }
                        inserttypeconv(p,cwidestringtype);
                        if (p.nodetype=stringconstn) and
                           (tstringconstnode(p).cst_type=cst_widestring) then
                         begin
                           pw:=pcompilerwidestring(tstringconstnode(p).value_str);
                           for i:=0 to tstringconstnode(p).len-1 do
                             current_asmdata.asmlists[al_typedconsts].concat(Tai_const.Create_16bit(pw^.data[i]));
                           { ending #0 }
                           current_asmdata.asmlists[al_typedconsts].concat(Tai_const.Create_16bit(0))
                         end;
                      end
                    else
                      Message(parser_e_illegal_expression);
                end
              else
                if (p.nodetype=addrn) or
                   is_procvar_load(p) then
                  begin
                    { insert typeconv }
                    inserttypeconv(p,def);
                    hp:=p;
                    while assigned(hp) and (hp.nodetype in [addrn,typeconvn,subscriptn,vecn]) do
                      hp:=tunarynode(hp).left;
                    if (hp.nodetype=loadn) then
                      begin
                        hp:=p;
                        offset:=0;
                        while assigned(hp) and (hp.nodetype<>loadn) do
                          begin
                             case hp.nodetype of
                               vecn :
                                 begin
                                   case tvecnode(hp).left.resultdef.deftype of
                                     stringdef :
                                       begin
                                          { this seems OK for shortstring and ansistrings PM }
                                          { it is wrong for widestrings !! }
                                          len:=1;
                                          base:=0;
                                       end;
                                     arraydef :
                                       begin
                                          if not is_packed_array(tvecnode(hp).left.resultdef) then
                                            begin
                                              len:=tarraydef(tvecnode(hp).left.resultdef).elesize;
                                              base:=tarraydef(tvecnode(hp).left.resultdef).lowrange;
                                            end
                                          else
                                            begin
                                              Message(parser_e_packed_dynamic_open_array);
                                              len:=1;
                                              base:=0;
                                            end;
                                       end
                                     else
                                       Message(parser_e_illegal_expression);
                                   end;
                                   if is_constintnode(tvecnode(hp).right) then
                                     inc(offset,len*(get_ordinal_value(tvecnode(hp).right)-base))
                                   else
                                     Message(parser_e_illegal_expression);
                                 end;
                               subscriptn :
                                 inc(offset,tsubscriptnode(hp).vs.fieldoffset);
                               typeconvn :
                                 begin
                                   if not(ttypeconvnode(hp).convtype in [tc_equal,tc_proc_2_procvar]) then
                                     Message(parser_e_illegal_expression);
                                 end;
                               addrn :
                                 ;
                               else
                                 Message(parser_e_illegal_expression);
                             end;
                             hp:=tunarynode(hp).left;
                          end;
                        srsym:=tloadnode(hp).symtableentry;
                        case srsym.typ of
                          procsym :
                            begin
                              if Tprocsym(srsym).procdef_count>1 then
                                Message(parser_e_no_overloaded_procvars);
                              if po_abstractmethod in tprocsym(srsym).first_procdef.procoptions then
                                Message(type_e_cant_take_address_of_abstract_method)
                              else
                                datalist.concat(Tai_const.Createname(tprocsym(srsym).first_procdef.mangledname,offset));
                            end;
                          globalvarsym :
                            datalist.concat(Tai_const.Createname(tglobalvarsym(srsym).mangledname,offset));
                          typedconstsym :
                            datalist.concat(Tai_const.Createname(ttypedconstsym(srsym).mangledname,offset));
                          labelsym :
                            datalist.concat(Tai_const.Createname(tlabelsym(srsym).mangledname,offset));
                          constsym :
                            if tconstsym(srsym).consttyp=constresourcestring then
                              datalist.concat(Tai_const.Createname(make_mangledname('RESOURCESTRINGLIST',tconstsym(srsym).owner,''),tconstsym(srsym).resstrindex*(4+sizeof(aint)*3)+4+sizeof(aint)))
                            else
                              Message(type_e_variable_id_expected);
                          else
                            Message(type_e_variable_id_expected);
                        end;
                      end
                    else
                      Message(parser_e_illegal_expression);
                  end
              else
              { allow typeof(Object type)}
                if (p.nodetype=inlinen) and
                   (tinlinenode(p).inlinenumber=in_typeof_x) then
                  begin
                    if (tinlinenode(p).left.nodetype=typen) then
                      begin
                        datalist.concat(Tai_const.createname(
                          tobjectdef(tinlinenode(p).left.resultdef).vmt_mangledname,0));
                      end
                    else
                      Message(parser_e_illegal_expression);
                  end
              else
                Message(parser_e_illegal_expression);
              p.free;
           end;
         setdef:
           begin
              p:=comp_expr(true);
              if p.nodetype=setconstn then
                begin
                   { be sure to convert to the correct result, else
                     it can generate smallset data instead of normalset (PFV) }
                   inserttypeconv(p,def);
                   { we only allow const sets }
                   if assigned(tsetconstnode(p).left) then
                     Message(parser_e_illegal_expression)
                   else
                     begin
                        { this writing is endian independant   }
                        { untrue - because they are considered }
                        { arrays of 32-bit values CEC          }

                        if source_info.endian = target_info.endian then
                          begin
                            for l:=0 to p.resultdef.size-1 do
                              datalist.concat(tai_const.create_8bit(Psetbytes(tsetconstnode(p).value_set)^[l]));
                          end
                        else
                          begin
                            { store as longint values in swaped format }
                            j:=0;
                            for l:=0 to ((p.resultdef.size-1) div 4) do
                              begin
                                datalist.concat(tai_const.create_8bit(Psetbytes(tsetconstnode(p).value_set)^[j+3]));
                                datalist.concat(tai_const.create_8bit(Psetbytes(tsetconstnode(p).value_set)^[j+2]));
                                datalist.concat(tai_const.create_8bit(Psetbytes(tsetconstnode(p).value_set)^[j+1]));
                                datalist.concat(tai_const.create_8bit(Psetbytes(tsetconstnode(p).value_set)^[j]));
                                Inc(j,4);
                              end;
                          end;
                     end;
                end
              else
                Message(parser_e_illegal_expression);
              p.free;
           end;
         enumdef:
           begin
              p:=comp_expr(true);
              if p.nodetype=ordconstn then
                begin
                  if equal_defs(p.resultdef,def) or
                     is_subequal(p.resultdef,def) then
                   begin
                     case longint(p.resultdef.size) of
                       1 : datalist.concat(Tai_const.Create_8bit(Byte(tordconstnode(p).value)));
                       2 : datalist.concat(Tai_const.Create_16bit(Word(tordconstnode(p).value)));
                       4 : datalist.concat(Tai_const.Create_32bit(Longint(tordconstnode(p).value)));
                     end;
                   end
                  else
                   IncompatibleTypes(p.resultdef,def);
                end
              else
                Message(parser_e_illegal_expression);
              p.free;
           end;
         stringdef:
           begin
              p:=comp_expr(true);
              { load strval and strlength of the constant tree }
              if (p.nodetype=stringconstn) or is_widestring(def) then
                begin
                  { convert to the expected string type so that
                    for widestrings strval is a pcompilerwidestring }
                  inserttypeconv(p,def);
                  strlength:=tstringconstnode(p).len;
                  strval:=tstringconstnode(p).value_str;
                end
              else if is_constcharnode(p) then
                begin
                  { strval:=pchar(@tordconstnode(p).value);
                    THIS FAIL on BIG_ENDIAN MACHINES PM }
                  c:=chr(tordconstnode(p).value and $ff);
                  strval:=@c;
                  strlength:=1
                end
              else if is_constresourcestringnode(p) then
                begin
                  strval:=pchar(tconstsym(tloadnode(p).symtableentry).value.valueptr);
                  strlength:=tconstsym(tloadnode(p).symtableentry).value.len;
                end
              else
                begin
                  Message(parser_e_illegal_expression);
                  strlength:=-1;
                end;
              if strlength>=0 then
               begin
                 case tstringdef(def).string_typ of
                   st_shortstring:
                     begin
                       if strlength>=def.size then
                        begin
                          message2(parser_w_string_too_long,strpas(strval),tostr(def.size-1));
                          strlength:=def.size-1;
                        end;
                       datalist.concat(Tai_const.Create_8bit(strlength));
                       { this can also handle longer strings }
                       getmem(ca,strlength+1);
                       move(strval^,ca^,strlength);
                       ca[strlength]:=#0;
                       datalist.concat(Tai_string.Create_pchar(ca,strlength));
                       { fillup with spaces if size is shorter }
                       if def.size>strlength then
                        begin
                          getmem(ca,def.size-strlength);
                          { def.size contains also the leading length, so we }
                          { we have to subtract one                       }
                          fillchar(ca[0],def.size-strlength-1,' ');
                          ca[def.size-strlength-1]:=#0;
                          { this can also handle longer strings }
                          datalist.concat(Tai_string.Create_pchar(ca,def.size-strlength-1));
                        end;
                     end;
                   st_ansistring:
                     begin
                        { an empty ansi string is nil! }
                        if (strlength=0) then
                          datalist.concat(Tai_const.Create_sym(nil))
                        else
                          begin
                            current_asmdata.getdatalabel(ll);
                            datalist.concat(Tai_const.Create_sym(ll));
                            current_asmdata.asmlists[al_const].concat(tai_align.create(const_align(sizeof(aint))));
                            current_asmdata.asmlists[al_const].concat(Tai_const.Create_aint(-1));
                            current_asmdata.asmlists[al_const].concat(Tai_const.Create_aint(strlength));
                            current_asmdata.asmlists[al_const].concat(Tai_label.Create(ll));
                            getmem(ca,strlength+1);
                            move(strval^,ca^,strlength);
                            { The terminating #0 to be stored in the .data section (JM) }
                            ca[strlength]:=#0;
                            current_asmdata.asmlists[al_const].concat(Tai_string.Create_pchar(ca,strlength+1));
                          end;
                     end;
                   st_widestring:
                     begin
                        { an empty ansi string is nil! }
                        if (strlength=0) then
                          datalist.concat(Tai_const.Create_sym(nil))
                        else
                          begin
                            current_asmdata.getdatalabel(ll);
                            datalist.concat(Tai_const.Create_sym(ll));
                            current_asmdata.asmlists[al_const].concat(tai_align.create(const_align(sizeof(aint))));
                            if tf_winlikewidestring in target_info.flags then
                              current_asmdata.asmlists[al_const].concat(Tai_const.Create_32bit(strlength*cwidechartype.size))
                            else
                              begin
                                current_asmdata.asmlists[al_const].concat(Tai_const.Create_aint(-1));
                                current_asmdata.asmlists[al_const].concat(Tai_const.Create_aint(strlength*cwidechartype.size));
                              end;
                            current_asmdata.asmlists[al_const].concat(Tai_label.Create(ll));
                            for i:=0 to strlength-1 do
                              current_asmdata.asmlists[al_const].concat(Tai_const.Create_16bit(pcompilerwidestring(strval)^.data[i]));
                            { ending #0 }
                            current_asmdata.asmlists[al_const].concat(Tai_const.Create_16bit(0))
                          end;
                     end;
                   st_longstring:
                     begin
                       internalerror(200107081);
                     end;
                 end;
               end;
              p.free;
           end;
         arraydef:
           begin
              { dynamic array nil }
               if is_dynamic_array(def) then
                begin
                  { Only allow nil initialization }
                  consume(_NIL);
                  datalist.concat(Tai_const.Create_sym(nil));
                end
               { no packed array constants supported }
               else if is_packed_array(def) then
                 begin
                   Message(type_e_no_const_packed_array);
                   consume_all_until(_RKLAMMER);
                 end
              else
              if try_to_consume(_LKLAMMER) then
                begin
                  for l:=tarraydef(def).lowrange to tarraydef(def).highrange-1 do
                    begin
                      readtypedconst(datalist,tarraydef(def).elementdef,nil,writable);
                      consume(_COMMA);
                    end;
                  readtypedconst(datalist,tarraydef(def).elementdef,nil,writable);
                  consume(_RKLAMMER);
                end
              else
              { if array of char then we allow also a string }
               if is_char(tarraydef(def).elementdef) then
                begin
                   p:=comp_expr(true);
                   if p.nodetype=stringconstn then
                    begin
                      len:=tstringconstnode(p).len;
                      { For tp7 the maximum lentgh can be 255 }
                      if (m_tp7 in aktmodeswitches) and
                         (len>255) then
                       len:=255;
                      ca:=tstringconstnode(p).value_str;
                    end
                   else
                     if is_constcharnode(p) then
                      begin
                        c:=chr(tordconstnode(p).value and $ff);
                        ca:=@c;
                        len:=1;
                      end
                   else
                     begin
                       Message(parser_e_illegal_expression);
                       len:=0;
                     end;
                   if len>(tarraydef(def).highrange-tarraydef(def).lowrange+1) then
                     Message(parser_e_string_larger_array);
                   for i:=tarraydef(def).lowrange to tarraydef(def).highrange do
                     begin
                        if i+1-tarraydef(def).lowrange<=len then
                          begin
                             datalist.concat(Tai_const.Create_8bit(byte(ca^)));
                             inc(ca);
                          end
                        else
                          {Fill the remaining positions with #0.}
                          datalist.concat(Tai_const.Create_8bit(0));
                     end;
                   p.free;
                end
              else
                begin
                  { we want the ( }
                  consume(_LKLAMMER);
                end;
           end;
         procvardef:
           begin
              { Procvars and pointers are no longer compatible.  }
              { under tp:  =nil or =var under fpc: =nil or =@var }
              if token=_NIL then
                begin
                   datalist.concat(Tai_const.Create_sym(nil));
                   if (po_methodpointer in tprocvardef(def).procoptions) then
                     datalist.concat(Tai_const.Create_sym(nil));
                   consume(_NIL);
                   goto myexit;
                end;
              { you can't assign a value other than NIL to a typed constant  }
              { which is a "procedure of object", because this also requires }
              { address of an object/class instance, which is not known at   }
              { compile time (JM)                                            }
              if (po_methodpointer in tprocvardef(def).procoptions) then
                Message(parser_e_no_procvarobj_const);
                { parse the rest too, so we can continue with error checking }
              getprocvardef:=tprocvardef(def);
              p:=comp_expr(true);
              getprocvardef:=nil;
              if codegenerror then
               begin
                 p.free;
                 goto myexit;
               end;
              { let type conversion check everything needed }
              inserttypeconv(p,def);
              if codegenerror then
               begin
                 p.free;
                 goto myexit;
               end;
              { remove typeconvs, that will normally insert a lea
                instruction which is not necessary for us }
              while p.nodetype=typeconvn do
               begin
                 hp:=ttypeconvnode(p).left;
                 ttypeconvnode(p).left:=nil;
                 p.free;
                 p:=hp;
               end;
              { remove addrn which we also don't need here }
              if p.nodetype=addrn then
               begin
                 hp:=taddrnode(p).left;
                 taddrnode(p).left:=nil;
                 p.free;
                 p:=hp;
               end;
              { we now need to have a loadn with a procsym }
              if (p.nodetype=loadn) and
                 (tloadnode(p).symtableentry.typ=procsym) then
               begin
                 datalist.concat(Tai_const.createname(
                   tprocsym(tloadnode(p).symtableentry).first_procdef.mangledname,0));
               end
              else
               Message(parser_e_illegal_expression);
              p.free;
           end;
         { reads a typed constant record }
         recorddef:
           begin
              { packed record }
              if is_packed_record_or_object(def) then
                Message(type_e_no_const_packed_record)
              { KAZ }
              else if (trecorddef(def)=rec_tguid) and
                 ((token=_CSTRING) or (token=_CCHAR) or (token=_ID)) then
                begin
                  p:=comp_expr(true);
                  inserttypeconv(p,cshortstringtype);
                  if p.nodetype=stringconstn then
                    begin
                      s:=strpas(tstringconstnode(p).value_str);
                      p.free;
                      if string2guid(s,tmpguid) then
                        begin
                          datalist.concat(Tai_const.Create_32bit(longint(tmpguid.D1)));
                          datalist.concat(Tai_const.Create_16bit(tmpguid.D2));
                          datalist.concat(Tai_const.Create_16bit(tmpguid.D3));
                          for i:=Low(tmpguid.D4) to High(tmpguid.D4) do
                            datalist.concat(Tai_const.Create_8bit(tmpguid.D4[i]));
                        end
                      else
                        Message(parser_e_improper_guid_syntax);
                    end
                  else
                    begin
                      p.free;
                      Message(parser_e_illegal_expression);
                      goto myexit;
                    end;
                end
              else
                begin
                   consume(_LKLAMMER);
                   sorg:='';
                   aktpos:=0;
                   srsym := tsym(trecorddef(def).symtable.symindex.first);
                   recsym := nil;
                   while token<>_RKLAMMER do
                     begin
                        s:=pattern;
                        sorg:=orgpattern;
                        consume(_ID);
                        consume(_COLON);
                        error := false;
                        recsym := tsym(trecorddef(def).symtable.search(s));
                        if not assigned(recsym) then
                          begin
                            Message1(sym_e_illegal_field,sorg);
                            error := true;
                          end;
                        if (not error) and
                           (not assigned(srsym) or
                            (s <> srsym.name)) then
                          { possible variant record (JM) }
                          begin
                            { All parts of a variant start at the same offset      }
                            { Also allow jumping from one variant part to another, }
                            { as long as the offsets match                         }
                            if (assigned(srsym) and
                                (tfieldvarsym(recsym).fieldoffset = tfieldvarsym(srsym).fieldoffset)) or
                               { srsym is not assigned after parsing w2 in the      }
                               { typed const in the next example:                   }
                               {   type tr = record case byte of                    }
                               {          1: (l1,l2: dword);                        }
                               {          2: (w1,w2: word);                         }
                               {        end;                                        }
                               {   const r: tr = (w1:1;w2:1;l2:5);                  }
                               (tfieldvarsym(recsym).fieldoffset = aktpos) then
                              srsym := recsym
                            { going backwards isn't allowed in any mode }
                            else if (tfieldvarsym(recsym).fieldoffset<aktpos) then
                              begin
                                Message(parser_e_invalid_record_const);
                                error := true;
                              end
                            { Delphi allows you to skip fields }
                            else if (m_delphi in aktmodeswitches) then
                              begin
                                Message1(parser_w_skipped_fields_before,sorg);
                                srsym := recsym;
                              end
                            { FPC and TP don't }
                            else
                              begin
                                Message1(parser_e_skipped_fields_before,sorg);
                                error := true;
                              end;
                          end;
                        if error then
                          consume_all_until(_SEMICOLON)
                        else
                          begin

                            { if needed fill (alignment) }
                            if tfieldvarsym(srsym).fieldoffset>aktpos then
                               for i:=1 to tfieldvarsym(srsym).fieldoffset-aktpos do
                                 datalist.concat(Tai_const.Create_8bit(0));

                             { new position }
                             aktpos:=tfieldvarsym(srsym).fieldoffset+tfieldvarsym(srsym).vardef.size;

                             { read the data }
                             readtypedconst(datalist,tfieldvarsym(srsym).vardef,nil,writable);

                             { keep previous field for checking whether whole }
                             { record was initialized (JM)                    }
                             recsym := srsym;
                             { goto next field }
                             srsym := tsym(srsym.indexnext);

                             if token=_SEMICOLON then
                               consume(_SEMICOLON)
                             else break;
                          end;
                   end;

                 { are there any fields left?                            }
                 if assigned(srsym) and
                    { don't complain if there only come other variant parts }
                    { after the last initialized field                      }
                    ((recsym=nil) or
                     (tfieldvarsym(srsym).fieldoffset > tfieldvarsym(recsym).fieldoffset)) then
                   Message1(parser_w_skipped_fields_after,sorg);

                 for i:=1 to def.size-aktpos do
                   datalist.concat(Tai_const.Create_8bit(0));

                 consume(_RKLAMMER);
              end;
           end;
         { reads a typed object }
         objectdef:
           begin
              if is_class_or_interface(def) then
                begin
                  p:=comp_expr(true);
                  if p.nodetype<>niln then
                    begin
                      Message(type_e_no_const_packed_array);
                      consume_all_until(_SEMICOLON);
                    end
                  else
                    begin
                      datalist.concat(Tai_const.Create_sym(nil));
                    end;
                  p.free;
                end
              { for objects we allow it only if it doesn't contain a vmt }
              else if (oo_has_vmt in tobjectdef(def).objectoptions) and
                      (m_fpc in aktmodeswitches) then
                 Message(parser_e_type_const_not_possible)
              { packed object }
              else if is_packed_record_or_object(def) then
                Message(type_e_no_const_packed_record)
              else
                begin
                   consume(_LKLAMMER);
                   aktpos:=0;
                   while token<>_RKLAMMER do
                     begin
                        s:=pattern;
                        sorg:=orgpattern;
                        consume(_ID);
                        consume(_COLON);
                        srsym:=nil;
                        obj:=tobjectdef(def);
                        symt:=obj.symtable;
                        while (srsym=nil) and assigned(symt) do
                          begin
                             srsym:=tsym(symt.search(s));
                             if assigned(obj) then
                               obj:=obj.childof;
                             if assigned(obj) then
                               symt:=obj.symtable
                             else
                               symt:=nil;
                          end;

                        if srsym=nil then
                          begin
                             Message1(sym_e_id_not_found,sorg);
                             consume_all_until(_SEMICOLON);
                          end
                        else
                          with tfieldvarsym(srsym) do
                            begin
                               { check position }
                               if fieldoffset<aktpos then
                                 message(parser_e_invalid_record_const);

                               { check in VMT needs to be added for TP mode }
                               with Tobjectdef(def) do
                                 if not(m_fpc in aktmodeswitches) and
                                    (oo_has_vmt in objectoptions) and
                                    (vmt_offset<fieldoffset) then
                                   begin
                                     for i:=1 to vmt_offset-aktpos do
                                       datalist.concat(tai_const.create_8bit(0));
                                     datalist.concat(tai_const.createname(vmt_mangledname,0));
                                     { this is more general }
                                     aktpos:=vmt_offset + sizeof(aint);
                                   end;

                               { if needed fill }
                               if fieldoffset>aktpos then
                                 for i:=1 to fieldoffset-aktpos do
                                   datalist.concat(Tai_const.Create_8bit(0));

                               { new position }
                               aktpos:=fieldoffset+vardef.size;

                               { read the data }
                               readtypedconst(datalist,vardef,nil,writable);

                               if not try_to_consume(_SEMICOLON) then
                                 break;
                          end;
                     end;
                   if not(m_fpc in aktmodeswitches) and
                      (oo_has_vmt in tobjectdef(def).objectoptions) and
                      (tobjectdef(def).vmt_offset>=aktpos) then
                     begin
                       for i:=1 to tobjectdef(def).vmt_offset-aktpos do
                         datalist.concat(tai_const.create_8bit(0));
                       datalist.concat(tai_const.createname(tobjectdef(def).vmt_mangledname,0));
                       { this is more general }
                       aktpos:=tobjectdef(def).vmt_offset + sizeof(aint);
                     end;
                   for i:=1 to def.size-aktpos do
                     datalist.concat(Tai_const.Create_8bit(0));
                   consume(_RKLAMMER);
                end;
           end;
         errordef:
           begin
              { try to consume something useful }
              if token=_LKLAMMER then
                consume_all_until(_RKLAMMER)
              else
                consume_all_until(_SEMICOLON);
           end;
         else Message(parser_e_type_const_not_possible);
         end;

         { Parse hints and public directive }
         if assigned(sym) then
           begin
             try_consume_hintdirective(sym.symoptions);

             { Support public name directive }
             if try_to_consume(_PUBLIC) then
               begin
                 if try_to_consume(_NAME) then
                   C_name:=get_stringconst
                 else
                   C_name:=sorg;
                 sym.set_mangledname(C_Name);
               end;
           end;

      myexit:
         block_type:=old_block_type;

         { Add symbol name if this is specified. For array
           elements sym=nil and we should skip this }
         if assigned(sym) then
           begin
             storefilepos:=aktfilepos;
             aktfilepos:=sym.fileinfo;
             { insert cut for smartlinking or alignment }
             if writable then
               cursectype:=sec_data
             else
               cursectype:=sec_rodata;
             maybe_new_object_file(list);
             new_section(list,cursectype,lower(sym.mangledname),const_align(def.alignment));
             if (sym.owner.symtabletype=globalsymtable) or
                maybe_smartlink_symbol or
                (assigned(current_procinfo) and
                 (po_inline in current_procinfo.procdef.procoptions)) or
                DLLSource then
               list.concat(Tai_symbol.Createname_global(sym.mangledname,AT_DATA,0))
             else
               list.concat(Tai_symbol.Createname(sym.mangledname,AT_DATA,0));
             list.concatlist(datalist);
             list.concat(tai_symbol_end.Createname(sym.mangledname));
             aktfilepos:=storefilepos;
           end
         else
           list.concatlist(datalist);
         datalist.free;
      end;

{$maxfpuregisters default}

end.

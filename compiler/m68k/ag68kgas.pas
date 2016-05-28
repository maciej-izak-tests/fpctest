{
    Copyright (c) 1998-2006 by the Free Pascal development team

    This unit implements an asmoutput class for m68k GAS syntax

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
unit ag68kgas;

{$i fpcdefs.inc}

interface

    uses
      cclasses,cpubase,systems,
      globals,globtype,
      aasmbase,aasmtai,aasmdata,aasmcpu,assemble,aggas;

    type
      Tm68kGNUAssembler=class(TGNUassembler)
        constructor create(info: pasminfo; smart: boolean); override;
        function MakeCmdLine : TCmdStr; override;
      end;

    type
      Tm68kInstrWriter=class(TCPUInstrWriter)
        procedure WriteInstruction(hp: tai);override;
      end;

    const
      gas_opsize2str : array[topsize] of string[2] =
        ('','.b','.w','.l','.s','.d','.x','');


  implementation

    uses
      cutils,
      cgbase,cgutils,cpuinfo,
      verbose,itcpugas;


 {****************************************************************************}
 {                         GNU m68k Assembler writer                          }
 {****************************************************************************}

 constructor Tm68kGNUAssembler.create(info: pasminfo; smart: boolean);
   begin
     inherited;
     InstrWriter := Tm68kInstrWriter.create(self);
   end;

 function Tm68kGNUAssembler.MakeCmdLine: TCmdStr;
   begin
     result:=inherited MakeCmdLine;
     // Use old -m option for Amiga system
     if target_info.system=system_m68k_amiga then
       Replace(result,'$ARCH','-m'+GasCpuTypeStr[current_settings.cputype])
     else
       Replace(result,'$ARCH','-march='+GasCpuTypeStr[current_settings.cputype]);
   end;

    function getreferencestring(var ref : treference) : string;
      var
         s,basestr,indexstr : string;

      begin
         s:='';
         with ref do
           begin
             basestr:=gas_regname(base);
             indexstr:=gas_regname(index);
             if assigned(symbol) then
               s:=s+symbol.name;

             if offset<0 then s:=s+tostr(offset)
              else if (offset>0) then
                begin
                  if (symbol=nil) then s:=tostr(offset)
                       else s:=s+'+'+tostr(offset);
                    end
                  else if (index=NR_NO) and (base=NR_NO) and not assigned(symbol) then
                    s:=s+'0';

               if (index<>NR_NO) and (base=NR_NO) and (direction=dir_none) then
                begin
                  if (scalefactor = 1) or (scalefactor = 0) then
                    s:=s+'('+indexstr+'.l)'
                  else
                    s:=s+'('+indexstr+'.l*'+tostr(scalefactor)+')'
                end
                else if (index=NR_NO) and (base<>NR_NO) and (direction=dir_inc) then
                begin
                  if (scalefactor = 1) or (scalefactor = 0) then
                      s:=s+'('+basestr+')+'
                  else
                   InternalError(10002);
                end
                else if (index=NR_NO) and (base<>NR_NO) and (direction=dir_dec) then
                begin
                  if (scalefactor = 1) or (scalefactor = 0) then
                      s:=s+'-('+basestr+')'
                  else
                   InternalError(10003);
                end
                  else if (index=NR_NO) and (base<>NR_NO) and (direction=dir_none) then
                begin
                  s:=s+'('+basestr+')'
                end
                  else if (index<>NR_NO) and (base<>NR_NO) and (direction=dir_none) then
                begin
                  if (scalefactor = 1) or (scalefactor = 0) then
                    s:=s+'('+basestr+','+indexstr+'.l)'
                  else
                    s:=s+'('+basestr+','+indexstr+'.l*'+tostr(scalefactor)+')';
                end;
          end;
         getreferencestring:=s;
      end;


    function getopstr(var o:toper) : string;
      var
        i : tsuperregister;
      begin
        case o.typ of
          top_reg:
            getopstr:=gas_regname(o.reg);
          top_ref:
            if o.ref^.refaddr=addr_full then
              begin
                if assigned(o.ref^.symbol) then
                  getopstr:=o.ref^.symbol.name
                else
                  getopstr:='#';
                if o.ref^.offset>0 then
                  getopstr:=getopstr+'+'+tostr(o.ref^.offset)
                else
                  if o.ref^.offset<0 then
                    getopstr:=getopstr+tostr(o.ref^.offset)
                  else
                    if not(assigned(o.ref^.symbol)) then
                      getopstr:=getopstr+'0';
              end
            else
              getopstr:=getreferencestring(o.ref^);
          top_regset:
            begin
              getopstr:='';
              for i:=RS_D0 to RS_D7 do
                begin
                  if i in o.dataregset then
                   getopstr:=getopstr+gas_regname(newreg(R_INTREGISTER,i,R_SUBWHOLE))+'/';
                end;
              for i:=RS_A0 to RS_SP do
                begin
                  if i in o.addrregset then
                   getopstr:=getopstr+gas_regname(newreg(R_ADDRESSREGISTER,i,R_SUBWHOLE))+'/';
                end;
              for i:=RS_FP0 to RS_FP7 do
                begin
                  if i in o.fpuregset then
                   getopstr:=getopstr+gas_regname(newreg(R_FPUREGISTER,i,R_SUBNONE))+'/';
                end;
              delete(getopstr,length(getopstr),1);
            end;
          top_const:
            getopstr:='#'+tostr(longint(o.val));
          top_realconst:
            begin
              str(o.val_real,getopstr);
              if getopstr[1]=' ' then
                getopstr[1]:='+';
              getopstr:='#0d'+getopstr;
            end;
          else internalerror(200405021);
        end;
      end;


    function getopstr_jmp(var o:toper) : string;
      begin
        case o.typ of
          top_reg:
            getopstr_jmp:=gas_regname(o.reg);
          top_ref:
            if o.ref^.refaddr=addr_no then
              getopstr_jmp:=getreferencestring(o.ref^)
            else
              begin
                if assigned(o.ref^.symbol) then
                  getopstr_jmp:=o.ref^.symbol.name
                else
                  getopstr_jmp:='';
                if o.ref^.offset>0 then
                  getopstr_jmp:=getopstr_jmp+'+'+tostr(o.ref^.offset)
                else
                  if o.ref^.offset<0 then
                    getopstr_jmp:=getopstr_jmp+tostr(o.ref^.offset)
                  else
                    if not(assigned(o.ref^.symbol)) then
                      getopstr_jmp:=getopstr_jmp+'0';
              end;
          top_const:
            getopstr_jmp:=tostr(o.val);
          else 
            internalerror(200405022);
        end;
      end;

{****************************************************************************
                            TM68kASMOUTPUT
 ****************************************************************************}

    { returns the opcode string }
    function getopcodestring(hp : tai) : string;
      var
        op : tasmop;
      begin
        op:=taicpu(hp).opcode;
        { old versions of GAS don't like PEA.L and LEA.L }
        if (op in [
          A_LEA,A_PEA,A_ABCD,A_BCHG,A_BCLR,A_BSET,A_BTST,
          A_EXG,A_NBCD,A_SBCD,A_SWAP,A_TAS,A_SCC,A_SCS,
          A_SEQ,A_SGE,A_SGT,A_SHI,A_SLE,A_SLS,A_SLT,A_SMI,
          A_SNE,A_SPL,A_ST,A_SVC,A_SVS,A_SF]) then
          result:=gas_op2str[op]
        else
        { Scc/FScc is always BYTE, DBRA/DBcc is always WORD, doesn't need opsize (KB) }
        if op in [A_SXX, A_FSXX, A_DBXX, A_DBRA] then
          result:=gas_op2str[op]+cond2str[taicpu(hp).condition]
        else
        { fix me: a fugly hack to utilize GNU AS pseudo instructions for more optimal branching }
        if op in [A_JSR] then
          result:='jbsr'
        else
        if op in [A_JMP] then
          result:='jra'
        else
        if op in [A_BXX] then
          result:='j'+cond2str[taicpu(hp).condition]+gas_opsize2str[taicpu(hp).opsize]
        else
        if op in [A_FBXX] then
          result:='fj'+{gas_op2str[op]+}cond2str[taicpu(hp).condition]+gas_opsize2str[taicpu(hp).opsize]
        else
          result:=gas_op2str[op]+gas_opsize2str[taicpu(hp).opsize];
      end;


    procedure Tm68kInstrWriter.WriteInstruction(hp: tai);
      var
        op       : tasmop;
        s        : string;
        sep      : char;
        i        : integer;
       begin
         if hp.typ <> ait_instruction then exit;
         op:=taicpu(hp).opcode;
         { call maybe not translated to call }
         s:=#9+getopcodestring(hp);
         { process operands }
         if taicpu(hp).ops<>0 then
           begin
             { call and jmp need an extra handling                          }
             { this code is only called if jmp isn't a labeled instruction  }
             { quick hack to overcome a problem with manglednames=255 chars }
             if is_calljmp(op) then
                begin
                  s:=s+#9+getopstr_jmp(taicpu(hp).oper[0]^);
                  { dbcc dx,<sym> has two operands! (KB) }
                  if (taicpu(hp).ops>1) then
                    s:=s+','+getopstr_jmp(taicpu(hp).oper[1]^);
                  if (taicpu(hp).ops>2) then
                    internalerror(2006120501);
                end
              else
                begin
                  for i:=0 to taicpu(hp).ops-1 do
                    begin
                      if i=0 then
                        sep:=#9
                      else
                      if (i=2) and
                         (op in [A_DIVSL,A_DIVUL,A_MULS,A_MULU,A_DIVS,A_DIVU,A_REMS,A_REMU]) then
                        sep:=':'
                      else
                        sep:=',';
                      s:=s+sep+getopstr(taicpu(hp).oper[i]^);
                    end;
                end;
           end;
           owner.writer.AsmWriteLn(s);
       end;


{*****************************************************************************
                                  Initialize
*****************************************************************************}

    const
       as_m68k_as_info : tasminfo =
          (
            id     : as_gas;
            idtxt  : 'AS';
            asmbin : 'as';
            asmcmd : '$ARCH -o $OBJ $EXTRAOPT $ASM';
            supported_targets : [system_m68k_Amiga,system_m68k_Atari,system_m68k_Mac,system_m68k_linux,system_m68k_PalmOS,system_m68k_netbsd,system_m68k_openbsd,system_m68k_embedded];
            flags : [af_needar,af_smartlink_sections];
            labelprefix : '.L';
            comment : '# ';
            dollarsign: '$';
          );

initialization
  RegisterAssembler(as_m68k_as_info,Tm68kGNUAssembler);
end.

{
    Copyright (c) 1998-2002 by Peter Vreman

    This unit implements support import,export,link routines
    for the (i386) Linux target

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
unit t_linux;

{$i fpcdefs.inc}

interface

  uses
    symsym,symdef,ppu,
    import,export,link;

  type
    timportliblinux=class(timportlib)
      procedure generatelib;override;
    end;

    texportliblinux=class(texportlib)
      procedure preparelib(const s : string);override;
      procedure exportprocedure(hp : texported_item);override;
      procedure exportvar(hp : texported_item);override;
      procedure generatelib;override;
    end;

    tlinkerlinux=class(texternallinker)
    private
      libctype:(libc5,glibc2,glibc21,uclibc);
      cprtobj,
      gprtobj,
      prtobj  : string[80];
      reorder : boolean;
      linklibc: boolean;
      Function  WriteResponseFile(isdll:boolean) : Boolean;
    public
      constructor Create;override;
      procedure SetDefaultInfo;override;
      procedure InitSysInitUnitName;override;
      function  MakeExecutable:boolean;override;
      function  MakeSharedLibrary:boolean;override;
      function  postprocessexecutable(const fn : string;isdll:boolean):boolean;
      procedure LoadPredefinedLibraryOrder; override;
    end;


implementation

  uses
    SysUtils,
    cutils,cfileutils,cclasses,
    verbose,systems,globtype,globals,
    symconst,script,
    fmodule,
    aasmbase,aasmtai,aasmdata,aasmcpu,cpubase,
    cgbase,cgobj,cgutils,ogbase,
    i_linux
    ;

{*****************************************************************************
                               TIMPORTLIBLINUX
*****************************************************************************}

    procedure timportliblinux.generatelib;
      var
        i : longint;
        ImportLibrary : TImportLibrary;
      begin
        for i:=0 to current_module.ImportLibraryList.Count-1 do
          begin
            ImportLibrary:=TImportLibrary(current_module.ImportLibraryList[i]);
            current_module.linkothersharedlibs.add(ImportLibrary.Name,link_always);
          end;
      end;


{*****************************************************************************
                               TEXPORTLIBLINUX
*****************************************************************************}

procedure texportliblinux.preparelib(const s:string);
begin
end;


procedure texportliblinux.exportprocedure(hp : texported_item);
var
  hp2 : texported_item;
begin
  { first test the index value }
  if (hp.options and eo_index)<>0 then
   begin
     Message1(parser_e_no_export_with_index_for_target,'linux');
     exit;
   end;
  { now place in correct order }
  hp2:=texported_item(current_module._exports.first);
  while assigned(hp2) and
     (hp.name^>hp2.name^) do
    hp2:=texported_item(hp2.next);
  { insert hp there !! }
  if assigned(hp2) and (hp2.name^=hp.name^) then
    begin
      { this is not allowed !! }
      Message1(parser_e_export_name_double,hp.name^);
      exit;
    end;
  if hp2=texported_item(current_module._exports.first) then
    current_module._exports.concat(hp)
  else if assigned(hp2) then
    begin
       hp.next:=hp2;
       hp.previous:=hp2.previous;
       if assigned(hp2.previous) then
         hp2.previous.next:=hp;
       hp2.previous:=hp;
    end
  else
    current_module._exports.concat(hp);
end;


procedure texportliblinux.exportvar(hp : texported_item);
begin
  hp.is_var:=true;
  exportprocedure(hp);
end;


procedure texportliblinux.generatelib;
var
  hp2 : texported_item;
  pd  : tprocdef;
{$ifdef x86}
  sym : tasmsymbol;
  r : treference;
{$endif x86}
begin
  new_section(current_asmdata.asmlists[al_procedures],sec_code,'',0);
  hp2:=texported_item(current_module._exports.first);
  while assigned(hp2) do
   begin
     if (not hp2.is_var) and
        (hp2.sym.typ=procsym) then
      begin
        { the manglednames can already be the same when the procedure
          is declared with cdecl }
        pd:=tprocdef(tprocsym(hp2.sym).ProcdefList[0]);
        if pd.mangledname<>hp2.name^ then
         begin
           { place jump in al_procedures }
           current_asmdata.asmlists[al_procedures].concat(tai_align.create(target_info.alignment.procalign));
           current_asmdata.asmlists[al_procedures].concat(Tai_symbol.Createname_global(hp2.name^,AT_FUNCTION,0));
           if (cs_create_pic in current_settings.moduleswitches) and
             { other targets need to be checked how it works }
             (target_info.system in [system_x86_64_linux,system_i386_linux]) then
             begin
{$ifdef x86}
               sym:=current_asmdata.RefAsmSymbol(pd.mangledname);
               reference_reset_symbol(r,sym,0);
               if cs_create_pic in current_settings.moduleswitches then
                 r.refaddr:=addr_pic
               else
                 r.refaddr:=addr_full;
               current_asmdata.asmlists[al_procedures].concat(taicpu.op_ref(A_JMP,S_NO,r));
{$endif x86}
             end
           else
             cg.a_jmp_name(current_asmdata.asmlists[al_procedures],pd.mangledname);
           current_asmdata.asmlists[al_procedures].concat(Tai_symbol_end.Createname(hp2.name^));
         end;
      end
     else
      message1(parser_e_no_export_of_variables_for_target,'linux');
     hp2:=texported_item(hp2.next);
   end;
end;


{*****************************************************************************
                                  TLINKERLINUX
*****************************************************************************}

Constructor TLinkerLinux.Create;
begin
  Inherited Create;
  if not Dontlinkstdlibpath Then
{$ifdef x86_64}
   LibrarySearchPath.AddPath('/lib64;/usr/lib64;/usr/X11R6/lib64',true);
{$else}
{$ifdef powerpc64}
   LibrarySearchPath.AddPath('/lib64;/usr/lib64;/usr/X11R6/lib64',true);
{$else powerpc64}
   LibrarySearchPath.AddPath('/lib;/usr/lib;/usr/X11R6/lib',true);
{$endif powerpc64}
{$endif x86_64}
end;


procedure TLinkerLinux.SetDefaultInfo;
{
  This will also detect which libc version will be used
}

const
{$ifdef i386}   platform_select='-b elf32-i386 -m elf_i386';{$endif}
{$ifdef x86_64} platform_select='-b elf64-x86-64 -m elf_x86_64';{$endif}
{$ifdef powerpc}platform_select='-b elf32-powerpc -m elf32ppclinux';{$endif}
{$ifdef POWERPC64}  platform_select='-b elf64-powerpc -m elf64ppc';{$endif}
{$ifdef sparc}  platform_select='-b elf32-sparc -m elf32_sparc';{$endif}
{$ifdef arm}    platform_select='';{$endif} {unknown :( }
{$ifdef m68k}    platform_select='';{$endif} {unknown :( }

{$ifdef m68k}
var
  St : TSearchRec;
{$endif m68k}
begin
  with Info do
   begin
     ExeCmd[1]:='ld '+platform_select+' $OPT $DYNLINK $STATIC $GCSECTIONS $STRIP -L. -o $EXE $RES';
     DllCmd[1]:='ld '+platform_select+' $OPT $INIT $FINI $SONAME -shared -L. -o $EXE $RES -E';
     DllCmd[2]:='strip --strip-unneeded $EXE';
{$ifdef m68k}
     libctype:=glibc2;
     if FindFirst('/lib/ld*',faAnyFile+faSymLink,st)<>0 then
       begin
         repeat
            if copy(st.name,1,5)='ld-2.' then
             begin
               DynamicLinker:='/lib/'+St.name;
               if st.name[6]<>'0' then
                 libctype:=glibc21;
               break;
             end;
         until FindNext(St)<>0;
       end;
     FindClose(St);
{$endif m68k}

{$ifdef i386}
     { default is glibc 2.1+ compatible }
     libctype:=glibc21;
     if FileExists('/lib/ld-linux.so.2',false) then
       DynamicLinker:='/lib/ld-linux.so.2'
     else if fileexists('/lib/ld-uClibc.so.0',false) then
       begin
         dynamiclinker:='/lib/ld-uClibc.so.0';
         libctype:=uclibc;
       end
     else if fileexists('/lib/ld-linux.so.1',false) then
       begin
         DynamicLinker:='/lib/ld-linux.so.1';
         libctype:=glibc2;
       end;
{$endif i386}

{$ifdef x86_64}
     DynamicLinker:='/lib64/ld-linux-x86-64.so.2';
     libctype:=glibc2;
{$endif x86_64}

{$ifdef sparc}
     DynamicLinker:='/lib/ld-linux.so.2';
     libctype:=glibc2;
{$endif sparc}

{$ifdef powerpc}
     DynamicLinker:='/lib/ld.so.1';
     libctype:=glibc2;
{$endif powerpc}

{$ifdef powerpc64}
     DynamicLinker:='/lib64/ld64.so.1';
     libctype:=glibc2;
{$endif powerpc64}

{$ifdef arm}
     DynamicLinker:='/lib/ld-linux.so.2';
     libctype:=glibc2;
{$endif arm}
   end;
end;


procedure TLinkerLinux.LoadPredefinedLibraryOrder;
// put your linkorder/linkalias overrides here.
// Note: assumes only called when reordering/aliasing is used.
Begin
   if not (cs_link_no_default_lib_order in  current_settings.globalswitches) Then
        Begin
          LinkLibraryOrder.add('gcc','',15);
          LinkLibraryOrder.add('c','',100);
          LinkLibraryOrder.add('gmon','',120);
          LinkLibraryOrder.add('dl','',140);
          LinkLibraryOrder.add('pthread','',160);
         end;
End;

Procedure TLinkerLinux.InitSysInitUnitName;
var
  csysinitunit,
  gsysinitunit : string[20];
  hp           : tmodule;
begin
  hp:=tmodule(loaded_units.first);
  while assigned(hp) do
   begin
     linklibc := hp.linkothersharedlibs.find('c');
     if linklibc then break;
     hp:=tmodule(hp.next);
   end;
  reorder := linklibc and ReOrderEntries;
  if current_module.islibrary then
   begin
     sysinitunit:='dll';
     csysinitunit:='dll';
     gsysinitunit:='dll';
     prtobj:='dllprt0';
     cprtobj:='dllprt0';
     gprtobj:='dllprt0';
   end
  else
   begin
     prtobj:='prt0';
     sysinitunit:='prc';
     case libctype of
       glibc21:
         begin
           cprtobj:='cprt21';
           gprtobj:='gprt21';
           csysinitunit:='c21';
           gsysinitunit:='c21g';
         end;
       uclibc:
         begin
           cprtobj:='ucprt0';
           gprtobj:='ugprt0';
           csysinitunit:='uc';
           gsysinitunit:='ucg';
         end
       else
         cprtobj:='cprt0';
         gprtobj:='gprt0';
         csysinitunit:='c';
         gsysinitunit:='g';
     end;
   end;
  if cs_profile in current_settings.moduleswitches then
   begin
     prtobj:=gprtobj;
     sysinitunit:=gsysinitunit;
     linklibc:=true;
   end
  else
   begin
     if linklibc then
      begin
       prtobj:=cprtobj;
       sysinitunit:=csysinitunit;
      end;
   end;
  sysinitunit:='si_'+sysinitunit;
end;

Function TLinkerLinux.WriteResponseFile(isdll:boolean) : Boolean;
Var
  linkres      : TLinkRes;
  i            : longint;
  HPath        : TStringListItem;
  s,s1,s2      : string;
  found1,
  found2       : boolean;
begin
  result:=False;
{ set special options for some targets }
  if cs_profile in current_settings.moduleswitches then
   begin
     if not(libctype in [glibc2,glibc21]) then
       AddSharedLibrary('gmon');
     AddSharedLibrary('c');
   end;

  { Open link.res file }
  LinkRes:=TLinkRes.Create(outputexedir+Info.ResName);
  with linkres do
    begin
      { Write path to search libraries }
      HPath:=TStringListItem(current_module.locallibrarysearchpath.First);
      while assigned(HPath) do
       begin
         Add('SEARCH_DIR('+maybequoted(HPath.Str)+')');
         HPath:=TStringListItem(HPath.Next);
       end;
      HPath:=TStringListItem(LibrarySearchPath.First);
      while assigned(HPath) do
       begin
         Add('SEARCH_DIR('+maybequoted(HPath.Str)+')');
         HPath:=TStringListItem(HPath.Next);
       end;

      StartSection('INPUT(');
      { add objectfiles, start with prt0 always }
      if not (target_info.system in system_internal_sysinit) and (prtobj<>'') then
       AddFileName(maybequoted(FindObjectFile(prtobj,'',false)));
      { try to add crti and crtbegin if linking to C }
      if linklibc then
       begin
         if librarysearchpath.FindFile('crtbegin.o',false,s) then
          AddFileName(s);
         if librarysearchpath.FindFile('crti.o',false,s) then
          AddFileName(s);
       end;
      { main objectfiles }
      while not ObjectFiles.Empty do
       begin
         s:=ObjectFiles.GetFirst;
         if s<>'' then
          AddFileName(maybequoted(s));
       end;
      EndSection(')');

      { Write staticlibraries }
      if not StaticLibFiles.Empty then
       begin
         Add('GROUP(');
         While not StaticLibFiles.Empty do
          begin
            S:=StaticLibFiles.GetFirst;
            AddFileName(maybequoted(s))
          end;
         Add(')');
       end;

      // we must reorder here because the result could empty sharedlibfiles
      if reorder Then
        ExpandAndApplyOrder(SharedLibFiles);
      // after this point addition of shared libs not allowed.

      { Write sharedlibraries like -l<lib>, also add the needed dynamic linker
        here to be sure that it gets linked this is needed for glibc2 systems (PFV) }

      if not SharedLibFiles.Empty then
       begin

         Add('INPUT(');
         While not SharedLibFiles.Empty do
          begin
            S:=SharedLibFiles.GetFirst;
            if (s<>'c') or reorder then
             begin
               i:=Pos(target_info.sharedlibext,S);
               if i>0 then
                Delete(S,i,255);
               Add('-l'+s);
             end
            else
             begin
               linklibc:=true;
             end;
          end;
         { be sure that libc is the last lib }
         if linklibc and not reorder then
          Add('-lc');
         { when we have -static for the linker the we also need libgcc }
         if (cs_link_staticflag in current_settings.globalswitches) then
          Add('-lgcc');
         Add(')');
       end;

      { objects which must be at the end }
      if linklibc and (libctype<>uclibc) then
       begin
         found1:=librarysearchpath.FindFile('crtend.o',false,s1);
         found2:=librarysearchpath.FindFile('crtn.o',false,s2);
         if found1 or found2 then
          begin
            Add('INPUT(');
            if found1 then
             AddFileName(s1);
            if found2 then
             AddFileName(s2);
            Add(')');
          end;
       end;

      {Entry point.}
      add('ENTRY(_start)');

{
{$ifdef x86_64}
{$define LINKERSCRIPT_INCLUDED}
      { taken from
        GNU ld version 2.14.90 20040120

        Newly inserted stuff is marked, please take care of it when updating this script
      }

      add('SECTIONS');
      add('{');
      add('  /* Read-only sections, merged into text segment: */');
      add('  PROVIDE (__executable_start = 0x400000); . = 0x400000 + SIZEOF_HEADERS;');
      add('  .interp         : { *(.interp) }');
      add('  .hash           : { *(.hash) }');
      add('  .dynsym         : { *(.dynsym) }');
      add('  .dynstr         : { *(.dynstr) }');
      add('  .gnu.version    : { *(.gnu.version) }');
      add('  .gnu.version_d  : { *(.gnu.version_d) }');
      add('  .gnu.version_r  : { *(.gnu.version_r) }');
      add('  .rel.dyn        :');
      add('    {');
      add('      *(.rel.init)');
      add('      *(.rel.text .rel.text.* .rel.gnu.linkonce.t.*)');
      add('      *(.rel.fini)');
      add('      *(.rel.rodata .rel.rodata.* .rel.gnu.linkonce.r.*)');
      add('      *(.rel.data .rel.data.* .rel.gnu.linkonce.d.*)');
      add('      *(.rel.tdata .rel.tdata.* .rel.gnu.linkonce.td.*)');
      add('      *(.rel.tbss .rel.tbss.* .rel.gnu.linkonce.tb.*)');
      add('      *(.rel.ctors)');
      add('      *(.rel.dtors)');
      add('      *(.rel.got)');
      add('      *(.rel.bss .rel.bss.* .rel.gnu.linkonce.b.*)');
      add('    }');
      add('  .rela.dyn       :');
      add('    {');
      add('      *(.rela.init)');
      add('      *(.rela.text .rela.text.* .rela.gnu.linkonce.t.*)');
      add('      *(.rela.fini)');
      add('      *(.rela.rodata .rela.rodata.* .rela.gnu.linkonce.r.*)');
      add('      *(.rela.data .rela.data.* .rela.gnu.linkonce.d.*)');
      add('      *(.rela.tdata .rela.tdata.* .rela.gnu.linkonce.td.*)');
      add('      *(.rela.tbss .rela.tbss.* .rela.gnu.linkonce.tb.*)');
      add('      *(.rela.ctors)');
      add('      *(.rela.dtors)');
      add('      *(.rela.got)');
      add('      *(.rela.bss .rela.bss.* .rela.gnu.linkonce.b.*)');
      add('    }');
      add('  .rel.plt        : { *(.rel.plt) }');
      add('  .rela.plt       : { *(.rela.plt) }');
      add('  .init           :');
      add('  {');
      add('    KEEP (*(.init))');
      add('  } =0x90909090');
      add('  .plt            : { *(.plt) }');
      add('  .text           :');
      add('  {');
      add('    *(.text .stub .text.* .gnu.linkonce.t.*)');
      add('    /* .gnu.warning sections are handled specially by elf32.em.  */');
      add('    *(.gnu.warning)');
      add('  } =0x90909090');
      add('  .fini           :');
      add('  {');
      add('    KEEP (*(.fini))');
      add('  } =0x90909090');
      add('  PROVIDE (__etext = .);');
      add('  PROVIDE (_etext = .);');
      add('  PROVIDE (etext = .);');
      add('  .rodata         : { *(.rodata .rodata.* .gnu.linkonce.r.*) }');
      add('  .rodata1        : { *(.rodata1) }');
      add('  .eh_frame_hdr : { *(.eh_frame_hdr) }');
      add('  /* Adjust the address for the data segment.  We want to adjust up to');
      add('     the same address within the page on the next page up.  */');
      add('  . = ALIGN (0x100000) - ((0x100000 - .) & (0x100000 - 1));');
      //  was: add('  . = ALIGN (0x100000) - ((0x100000 - .) & (0x100000 - 1)); . = DATA_SEGMENT_ALIGN (0x100000, 0x1000);');
      add('  /* Ensure the __preinit_array_start label is properly aligned.  We');
      add('     could instead move the label definition inside the section, but');
      add('     the linker would then create the section even if it turns out to');
      add('     be empty, which isn''t pretty.  */');
      add('  . = ALIGN(64 / 8);');
      add('  PROVIDE (__preinit_array_start = .);');
      add('  .preinit_array     : { *(.preinit_array) }');
      add('  PROVIDE (__preinit_array_end = .);');
      add('  PROVIDE (__init_array_start = .);');
      add('  .init_array     : { *(.init_array) }');
      add('  PROVIDE (__init_array_end = .);');
      add('  PROVIDE (__fini_array_start = .);');
      add('  .fini_array     : { *(.fini_array) }');
      add('  PROVIDE (__fini_array_end = .);');
      add('  .data           :');
      add('  {');
      add('    *(.data .data.* .gnu.linkonce.d.*)');
{ inserted }
      add('    KEEP (*(.fpc .fpc.version .fpc.links))');
{ end of insert }
      add('    SORT(CONSTRUCTORS)');
      add('  }');
      add('  .data1          : { *(.data1) }');
      add('  .tdata	  : { *(.tdata .tdata.* .gnu.linkonce.td.*) }');
      add('  .tbss		  : { *(.tbss .tbss.* .gnu.linkonce.tb.*) *(.tcommon) }');
      add('  .eh_frame       : { KEEP (*(.eh_frame)) }');
      add('  .gcc_except_table   : { *(.gcc_except_table) }');
      add('  .dynamic        : { *(.dynamic) }');
      add('  .ctors          :');
      add('  {');
      add('    /* gcc uses crtbegin.o to find the start of');
      add('       the constructors, so we make sure it is');
      add('       first.  Because this is a wildcard, it');
      add('       doesn''t matter if the user does not');
      add('       actually link against crtbegin.o; the');
      add('       linker won''t look for a file to match a');
      add('       wildcard.  The wildcard also means that it');
      add('       doesn''t matter which directory crtbegin.o');
      add('       is in.  */');
      add('    KEEP (*crtbegin*.o(.ctors))');
      add('    /* We don''t want to include the .ctor section from');
      add('       from the crtend.o file until after the sorted ctors.');
      add('       The .ctor section from the crtend file contains the');
      add('       end of ctors marker and it must be last */');
      add('    KEEP (*(EXCLUDE_FILE (*crtend*.o ) .ctors))');
      add('    KEEP (*(SORT(.ctors.*)))');
      add('    KEEP (*(.ctors))');
      add('  }');
      add('  .dtors          :');
      add('  {');
      add('    KEEP (*crtbegin*.o(.dtors))');
      add('    KEEP (*(EXCLUDE_FILE (*crtend*.o ) .dtors))');
      add('    KEEP (*(SORT(.dtors.*)))');
      add('    KEEP (*(.dtors))');
      add('  }');
      add('  .jcr            : { KEEP (*(.jcr)) }');
      add('  .got            : { *(.got.plt) *(.got) }');
      add('  _edata = .;');
      add('  PROVIDE (edata = .);');
{ inserted }
      add('  .threadvar : { *(.threadvar .threadvar.* .gnu.linkonce.tv.*) }');
{ end of insert }
      add('  __bss_start = .;');
      add('  .bss            :');
      add('  {');
      add('   *(.dynbss)');
      add('   *(.bss .bss.* .gnu.linkonce.b.*)');
      add('   *(COMMON)');
      add('   /* Align here to ensure that the .bss section occupies space up to');
      add('      _end.  Align after .bss to ensure correct alignment even if the');
      add('      .bss section disappears because there are no input sections.  */');
      add('   . = ALIGN(64 / 8);');
      add('  }');
      add('  . = ALIGN(64 / 8);');
      add('  _end = .;');
      add('  PROVIDE (end = .);');
//      add('  . = DATA_SEGMENT_END (.);');
      add('  /* Stabs debugging sections.  */');
      add('  .stab          0 : { *(.stab) }');
      add('  .stabstr       0 : { *(.stabstr) }');
      add('  .stab.excl     0 : { *(.stab.excl) }');
      add('  .stab.exclstr  0 : { *(.stab.exclstr) }');
      add('  .stab.index    0 : { *(.stab.index) }');
      add('  .stab.indexstr 0 : { *(.stab.indexstr) }');
      add('  .comment       0 : { *(.comment) }');
      add('  /* DWARF debug sections.');
      add('     Symbols in the DWARF debugging sections are relative to the beginning');
      add('     of the section so we begin them at 0.  */');
      add('  /* DWARF 1 */');
      add('  .debug          0 : { *(.debug) }');
      add('  .line           0 : { *(.line) }');
      add('  /* GNU DWARF 1 extensions */');
      add('  .debug_srcinfo  0 : { *(.debug_srcinfo) }');
      add('  .debug_sfnames  0 : { *(.debug_sfnames) }');
      add('  /* DWARF 1.1 and DWARF 2 */');
      add('  .debug_aranges  0 : { *(.debug_aranges) }');
      add('  .debug_pubnames 0 : { *(.debug_pubnames) }');
      add('  /* DWARF 2 */');
      add('  .debug_info     0 : { *(.debug_info .gnu.linkonce.wi.*) }');
      add('  .debug_abbrev   0 : { *(.debug_abbrev) }');
      add('  .debug_line     0 : { *(.debug_line) }');
      add('  .debug_frame    0 : { *(.debug_frame) }');
      add('  .debug_str      0 : { *(.debug_str) }');
      add('  .debug_loc      0 : { *(.debug_loc) }');
      add('  .debug_macinfo  0 : { *(.debug_macinfo) }');
      add('  /* SGI/MIPS DWARF 2 extensions */');
      add('  .debug_weaknames 0 : { *(.debug_weaknames) }');
      add('  .debug_funcnames 0 : { *(.debug_funcnames) }');
      add('  .debug_typenames 0 : { *(.debug_typenames) }');
      add('  .debug_varnames  0 : { *(.debug_varnames) }');
      add('  /DISCARD/ : { *(.note.GNU-stack) }');
      add('}');

{ from GNU ld version 2.16.91 20060118 Debian GNU/Linux,
  unused because not usable with older LDs
      add('SECTIONS');
      add('{');
      add('  /* Read-only sections, merged into text segment: */');
      add('  PROVIDE (__executable_start = 0x400000); . = 0x400000 + SIZEOF_HEADERS;');
      add('  .interp         : { *(.interp) }');
      add('  .hash           : { *(.hash) }');
      add('  .dynsym         : { *(.dynsym) }');
      add('  .dynstr         : { *(.dynstr) }');
      add('  .gnu.version    : { *(.gnu.version) }');
      add('  .gnu.version_d  : { *(.gnu.version_d) }');
      add('  .gnu.version_r  : { *(.gnu.version_r) }');
      add('  .rel.dyn        :');
      add('    {');
      add('      *(.rel.init)');
      add('      *(.rel.text .rel.text.* .rel.gnu.linkonce.t.*)');
      add('      *(.rel.fini)');
      add('      *(.rel.rodata .rel.rodata.* .rel.gnu.linkonce.r.*)');
      add('      *(.rel.data.rel.ro* .rel.gnu.linkonce.d.rel.ro.*)');
      add('      *(.rel.data .rel.data.* .rel.gnu.linkonce.d.*)');
      add('      *(.rel.tdata .rel.tdata.* .rel.gnu.linkonce.td.*)');
      add('      *(.rel.tbss .rel.tbss.* .rel.gnu.linkonce.tb.*)');
      add('      *(.rel.ctors)');
      add('      *(.rel.dtors)');
      add('      *(.rel.got)');
      add('      *(.rel.bss .rel.bss.* .rel.gnu.linkonce.b.*)');
      add('      *(.rel.ldata .rel.ldata.* .rel.gnu.linkonce.l.*)');
      add('      *(.rel.lbss .rel.lbss.* .rel.gnu.linkonce.lb.*)');
      add('      *(.rel.lrodata .rel.lrodata.* .rel.gnu.linkonce.lr.*)');
      add('    }');
      add('  .rela.dyn       :');
      add('    {');
      add('      *(.rela.init)');
      add('      *(.rela.text .rela.text.* .rela.gnu.linkonce.t.*)');
      add('      *(.rela.fini)');
      add('      *(.rela.rodata .rela.rodata.* .rela.gnu.linkonce.r.*)');
      add('      *(.rela.data .rela.data.* .rela.gnu.linkonce.d.*)');
      add('      *(.rela.tdata .rela.tdata.* .rela.gnu.linkonce.td.*)');
      add('      *(.rela.tbss .rela.tbss.* .rela.gnu.linkonce.tb.*)');
      add('      *(.rela.ctors)');
      add('      *(.rela.dtors)');
      add('      *(.rela.got)');
      add('      *(.rela.bss .rela.bss.* .rela.gnu.linkonce.b.*)');
      add('      *(.rela.ldata .rela.ldata.* .rela.gnu.linkonce.l.*)');
      add('      *(.rela.lbss .rela.lbss.* .rela.gnu.linkonce.lb.*)');
      add('      *(.rela.lrodata .rela.lrodata.* .rela.gnu.linkonce.lr.*)');
      add('    }');
      add('  .rel.plt        : { *(.rel.plt) }');
      add('  .rela.plt       : { *(.rela.plt) }');
      add('  .init           :');
      add('  {');
      add('    KEEP (*(.init))');
      add('  } =0x90909090');
      add('  .plt            : { *(.plt) }');
      add('  .text           :');
      add('  {');
      add('    *(.text .stub .text.* .gnu.linkonce.t.*)');
      add('    KEEP (*(.text.*personality*))');
      add('    /* .gnu.warning sections are handled specially by elf32.em.  */');
      add('    *(.gnu.warning)');
      add('  } =0x90909090');
      add('  .fini           :');
      add('  {');
      add('    KEEP (*(.fini))');
      add('  } =0x90909090');
      add('  PROVIDE (__etext = .);');
      add('  PROVIDE (_etext = .);');
      add('  PROVIDE (etext = .);');
      add('  .rodata         : { *(.rodata .rodata.* .gnu.linkonce.r.*) }');
      add('  .rodata1        : { *(.rodata1) }');
      add('  .eh_frame_hdr : { *(.eh_frame_hdr) }');
      add('  .eh_frame       : ONLY_IF_RO { KEEP (*(.eh_frame)) }');
      add('  .gcc_except_table   : ONLY_IF_RO { *(.gcc_except_table .gcc_except_table.*) }');
      add('  /* Adjust the address for the data segment.  We want to adjust up to');
      add('     the same address within the page on the next page up.  */');
      add('  . = ALIGN (0x100000) - ((0x100000 - .) & (0x100000 - 1));'); // . = DATA_SEGMENT_ALIGN (0x100000, 0x1000);');
      add('  /* Exception handling  */');
      add('  .eh_frame       : ONLY_IF_RW { KEEP (*(.eh_frame)) }');
      add('  .gcc_except_table   : ONLY_IF_RW { *(.gcc_except_table .gcc_except_table.*) }');
      add('  /* Thread Local Storage sections  */');
      add('  .tdata          : { *(.tdata .tdata.* .gnu.linkonce.td.*) }');
      add('  .tbss           : { *(.tbss .tbss.* .gnu.linkonce.tb.*) *(.tcommon) }');
      add('  .preinit_array     :');
      add('  {');
      add('    PROVIDE_HIDDEN (__preinit_array_start = .);');
      add('    KEEP (*(.preinit_array))');
      add('    PROVIDE_HIDDEN (__preinit_array_end = .);');
      add('  }');
      add('  .init_array     :');
      add('  {');
      add('     PROVIDE_HIDDEN (__init_array_start = .);');
      add('     KEEP (*(SORT(.init_array.*)))');
      add('     KEEP (*(.init_array))');
      add('     PROVIDE_HIDDEN (__init_array_end = .);');
      add('  }');
      add('  .fini_array     :');
      add('  {');
      add('    PROVIDE_HIDDEN (__fini_array_start = .);');
      add('    KEEP (*(.fini_array))');
      add('    KEEP (*(SORT(.fini_array.*)))');
      add('    PROVIDE_HIDDEN (__fini_array_end = .);');
      add('  }');
      add('  .ctors          :');
      add('  {');
      add('    /* gcc uses crtbegin.o to find the start of');
      add('       the constructors, so we make sure it is');
      add('       first.  Because this is a wildcard, it');
      add('       doesn''t matter if the user does not');
      add('       actually link against crtbegin.o; the');
      add('       linker won''t look for a file to match a');
      add('       wildcard.  The wildcard also means that it');
      add('       doesn''t matter which directory crtbegin.o');
      add('       is in.  */');
      add('    KEEP (*crtbegin*.o(.ctors))');
      add('    /* We don''t want to include the .ctor section from');
      add('       the crtend.o file until after the sorted ctors.');
      add('       The .ctor section from the crtend file contains the');
      add('       end of ctors marker and it must be last */');
      add('    KEEP (*(EXCLUDE_FILE (*crtend*.o ) .ctors))');
      add('    KEEP (*(SORT(.ctors.*)))');
      add('    KEEP (*(.ctors))');
      add('  }');
      add('  .dtors          :');
      add('  {');
      add('    KEEP (*crtbegin*.o(.dtors))');
      add('    KEEP (*(EXCLUDE_FILE (*crtend*.o ) .dtors))');
      add('    KEEP (*(SORT(.dtors.*)))');
      add('    KEEP (*(.dtors))');
      add('  }');
      add('  .jcr            : { KEEP (*(.jcr)) }');
      add('  .data.rel.ro : { *(.data.rel.ro.local* .gnu.linkonce.d.rel.ro.local.*) *(.data.rel.ro* .gnu.linkonce.d.rel.ro.*) }');
      add('  .dynamic        : { *(.dynamic) }');
      add('  .got            : { *(.got) }');
      add('  . = DATA_SEGMENT_RELRO_END (24, .);');
      add('  .got.plt        : { *(.got.plt) }');
      add('  .data           :');
      add('  {');
      add('    *(.data .data.* .gnu.linkonce.d.*)');
{ inserted }
      add('    KEEP (*(.fpc .fpc.version .fpc.links))');
{ end of insert }
      add('    KEEP (*(.gnu.linkonce.d.*personality*))');
      add('    SORT(CONSTRUCTORS)');
      add('  }');
      add('  .data1          : { *(.data1) }');
      add('  _edata = .; PROVIDE (edata = .);');
{ inserted }
      add('  .threadvar : { *(.threadvar .threadvar.* .gnu.linkonce.tv.*) }');
{ end of insert }
      add('  __bss_start = .;');
      add('  .bss            :');
      add('  {');
      add('   *(.dynbss)');
      add('   *(.bss .bss.* .gnu.linkonce.b.*)');
      add('   *(COMMON)');
      add('   /* Align here to ensure that the .bss section occupies space up to');
      add('      _end.  Align after .bss to ensure correct alignment even if the');
      add('      .bss section disappears because there are no input sections.');
      add('      FIXME: Why do we need it? When there is no .bss section, we don''t');
      add('      pad the .data section.  */');
      add('   . = ALIGN(. != 0 ? 64 / 8 : 1);');
      add('  }');
      add('  . = ALIGN(64 / 8);');
      add('  .lbss   :');
      add('  {');
      add('    *(.dynlbss)');
      add('    *(.lbss .lbss.* .gnu.linkonce.lb.*)');
      add('    *(LARGE_COMMON)');
      add('  }');
      add('  .lrodata   ALIGN(0x100000) + (. & (0x100000 - 1)) :');
      add('  {');
      add('    *(.lrodata .lrodata.* .gnu.linkonce.lr.*)');
      add('  }');
      add('  .ldata   ALIGN(0x100000) + (. & (0x100000 - 1)) :');
      add('  {');
      add('    *(.ldata .ldata.* .gnu.linkonce.l.*)');
      add('    . = ALIGN(. != 0 ? 64 / 8 : 1);');
      add('  }');
      add('  . = ALIGN(64 / 8);');
      add('  _end = .; PROVIDE (end = .);');
      add('  . = DATA_SEGMENT_END (.);');
      add('  /* Stabs debugging sections.  */');
      add('  .stab          0 : { *(.stab) }');
      add('  .stabstr       0 : { *(.stabstr) }');
      add('  .stab.excl     0 : { *(.stab.excl) }');
      add('  .stab.exclstr  0 : { *(.stab.exclstr) }');
      add('  .stab.index    0 : { *(.stab.index) }');
      add('  .stab.indexstr 0 : { *(.stab.indexstr) }');
      add('  .comment       0 : { *(.comment) }');
      add('  /* DWARF debug sections.');
      add('     Symbols in the DWARF debugging sections are relative to the beginning');
      add('     of the section so we begin them at 0.  */');
      add('  /* DWARF 1 */');
      add('  .debug          0 : { *(.debug) }');
      add('  .line           0 : { *(.line) }');
      add('  /* GNU DWARF 1 extensions */');
      add('  .debug_srcinfo  0 : { *(.debug_srcinfo) }');
      add('  .debug_sfnames  0 : { *(.debug_sfnames) }');
      add('  /* DWARF 1.1 and DWARF 2 */');
      add('  .debug_aranges  0 : { *(.debug_aranges) }');
      add('  .debug_pubnames 0 : { *(.debug_pubnames) }');
      add('  /* DWARF 2 */');
      add('  .debug_info     0 : { *(.debug_info .gnu.linkonce.wi.*) }');
      add('  .debug_abbrev   0 : { *(.debug_abbrev) }');
      add('  .debug_line     0 : { *(.debug_line) }');
      add('  .debug_frame    0 : { *(.debug_frame) }');
      add('  .debug_str      0 : { *(.debug_str) }');
      add('  .debug_loc      0 : { *(.debug_loc) }');
      add('  .debug_macinfo  0 : { *(.debug_macinfo) }');
      add('  /* SGI/MIPS DWARF 2 extensions */');
      add('  .debug_weaknames 0 : { *(.debug_weaknames) }');
      add('  .debug_funcnames 0 : { *(.debug_funcnames) }');
      add('  .debug_typenames 0 : { *(.debug_typenames) }');
      add('  .debug_varnames  0 : { *(.debug_varnames) }');
      add('  /DISCARD/ : { *(.note.GNU-stack) }');
      add('}');
}
{$endif x86_64}
}

{$ifndef LINKERSCRIPT_INCLUDED}
      {Sections.}
      add('SECTIONS');
      add('{');
      {Read-only sections, merged into text segment:}
      add('  PROVIDE (__executable_start = 0x010000); . = 0x010000 +0x100;');
      add('  .interp         : { *(.interp) }');
      add('  .hash           : { *(.hash) }');
      add('  .dynsym         : { *(.dynsym) }');
      add('  .dynstr         : { *(.dynstr) }');
      add('  .gnu.version    : { *(.gnu.version) }');
      add('  .gnu.version_d  : { *(.gnu.version_d) }');
      add('  .gnu.version_r  : { *(.gnu.version_r) }');
      add('  .rel.dyn        :');
      add('    {');
      add('      *(.rel.init)');
      add('      *(.rel.text .rel.text.* .rel.gnu.linkonce.t.*)');
      add('      *(.rel.fini)');
      add('      *(.rel.rodata .rel.rodata.* .rel.gnu.linkonce.r.*)');
      add('      *(.rel.data.rel.ro*)');
      add('      *(.rel.data .rel.data.* .rel.gnu.linkonce.d.*)');
      add('      *(.rel.tdata .rel.tdata.* .rel.gnu.linkonce.td.*)');
      add('      *(.rel.tbss .rel.tbss.* .rel.gnu.linkonce.tb.*)');
      add('      *(.rel.got)');
      add('      *(.rel.bss .rel.bss.* .rel.gnu.linkonce.b.*)');
      add('    }');
      add('  .rela.dyn       :');
      add('    {');
      add('      *(.rela.init)');
      add('      *(.rela.text .rela.text.* .rela.gnu.linkonce.t.*)');
      add('      *(.rela.fini)');
      add('      *(.rela.rodata .rela.rodata.* .rela.gnu.linkonce.r.*)');
      add('      *(.rela.data .rela.data.* .rela.gnu.linkonce.d.*)');
      add('      *(.rela.tdata .rela.tdata.* .rela.gnu.linkonce.td.*)');
      add('      *(.rela.tbss .rela.tbss.* .rela.gnu.linkonce.tb.*)');
      add('      *(.rela.got)');
      add('      *(.rela.bss .rela.bss.* .rela.gnu.linkonce.b.*)');
      add('    }');
      add('  .rel.plt        : { *(.rel.plt) }');
      add('  .rela.plt       : { *(.rela.plt) }');
      add('  .init           :');
      add('  {');
      add('    KEEP (*(.init))');
      add('  } =0x90909090');
      add('  .plt            : { *(.plt) }');
      add('  .text           :');
      add('  {');
      add('    *(.text .stub .text.* .gnu.linkonce.t.*)');
      add('    KEEP (*(.text.*personality*))');
      {.gnu.warning sections are handled specially by elf32.em.}
      add('    *(.gnu.warning)');
      add('  } =0x90909090');
      add('  .fini           :');
      add('  {');
      add('    KEEP (*(.fini))');
      add('  } =0x90909090');
      add('  PROVIDE (_etext = .);');
      add('  .rodata         :');
      add('  {');
      add('    *(.rodata .rodata.* .gnu.linkonce.r.*)');
      add('  }');
      {Adjust the address for the data segment.  We want to adjust up to
       the same address within the page on the next page up.}
      add('  . = ALIGN (0x1000) - ((0x1000 - .) & (0x1000 - 1));');
      add('  .dynamic        : { *(.dynamic) }');
      add('  .got            : { *(.got) }');
      add('  .got.plt        : { *(.got.plt) }');
      add('  .data           :');
      add('  {');
      add('    *(.data .data.* .gnu.linkonce.d.*)');
      add('    KEEP (*(.fpc .fpc.version .fpc.links))');
      add('    KEEP (*(.gnu.linkonce.d.*personality*))');
      add('  }');
      add('  _edata = .;');
      add('  PROVIDE (edata = .);');
    {$ifdef zsegment_threadvars}
      add('  _z = .;');
      add('  .threadvar 0 : AT (_z) { *(.threadvar .threadvar.* .gnu.linkonce.tv.*) }');
      add('  PROVIDE (_threadvar_size = SIZEOF(.threadvar));');
      add('  . = _z + SIZEOF (.threadvar);');
    {$else}
      add('  .threadvar : { *(.threadvar .threadvar.* .gnu.linkonce.tv.*) }');
    {$endif}
      add('  __bss_start = .;');
      add('  .bss            :');
      add('  {');
      add('   *(.dynbss)');
      add('   *(.bss .bss.* .gnu.linkonce.b.*)');
      add('   *(COMMON)');
      {Align here to ensure that the .bss section occupies space up to
       _end.  Align after .bss to ensure correct alignment even if the
       .bss section disappears because there are no input sections.}
      add('   . = ALIGN(32 / 8);');
      add('  }');
      add('  . = ALIGN(32 / 8);');
      add('  _end = .;');
      add('  PROVIDE (end = .);');
      {Stabs debugging sections.}
      add('  .stab          0 : { *(.stab) }');
      add('  .stabstr       0 : { *(.stabstr) }');
      add('}');
{$endif LINKERSCRIPT_INCLUDED}
      { Write and Close response }
      writetodisk;
      Free;
    end;

  WriteResponseFile:=True;
end;


function TLinkerLinux.MakeExecutable:boolean;
var
  binstr : String;
  cmdstr  : TCmdStr;
  success : boolean;
  DynLinkStr : string[60];
  GCSectionsStr,
  StaticStr,
  StripStr   : string[40];
begin
  if not(cs_link_nolink in current_settings.globalswitches) then
   Message1(exec_i_linking,current_module.exefilename^);

{ Create some replacements }
  StaticStr:='';
  StripStr:='';
  GCSectionsStr:='';
  DynLinkStr:='';
  if (cs_link_staticflag in current_settings.globalswitches) then
   StaticStr:='-static';
  if (cs_link_strip in current_settings.globalswitches) then
   StripStr:='-s';
  if (cs_link_map in current_settings.globalswitches) then
   StripStr:='-Map '+maybequoted(ChangeFileExt(current_module.exefilename^,'.map'));
  if use_smartlink_section then
   GCSectionsStr:='--gc-sections';
  If (cs_profile in current_settings.moduleswitches) or
     ((Info.DynamicLinker<>'') and (not SharedLibFiles.Empty)) then
   begin
     DynLinkStr:='-dynamic-linker='+Info.DynamicLinker;
     if cshared Then
       DynLinkStr:='--shared ' + DynLinkStr;
     if rlinkpath<>'' Then
       DynLinkStr:='--rpath-link '+rlinkpath + ' '+ DynLinkStr;
   End;

{ Write used files and libraries }
  WriteResponseFile(false);

{ Call linker }
  SplitBinCmd(Info.ExeCmd[1],binstr,cmdstr);
  Replace(cmdstr,'$EXE',maybequoted(current_module.exefilename^));
  Replace(cmdstr,'$OPT',Info.ExtraOptions);
  Replace(cmdstr,'$RES',maybequoted(outputexedir+Info.ResName));
  Replace(cmdstr,'$STATIC',StaticStr);
  Replace(cmdstr,'$STRIP',StripStr);
  Replace(cmdstr,'$GCSECTIONS',GCSectionsStr);
  Replace(cmdstr,'$DYNLINK',DynLinkStr);

  { create dynamic symbol table? }
  if HasExports then
    cmdstr:=cmdstr+' -E';

  success:=DoExec(FindUtil(utilsprefix+BinStr),CmdStr,true,false);

{ Remove ReponseFile }
  if (success) and not(cs_link_nolink in current_settings.globalswitches) then
   DeleteFile(outputexedir+Info.ResName);

  if (success) then
    success:=PostProcessExecutable(current_module.exefilename^,false);


  MakeExecutable:=success;   { otherwise a recursive call to link method }
end;


Function TLinkerLinux.MakeSharedLibrary:boolean;
var
  InitStr,
  FiniStr,
  SoNameStr : string[80];
  binstr : String;
  cmdstr  : TCmdStr;
  success : boolean;
begin
  MakeSharedLibrary:=false;
  if not(cs_link_nolink in current_settings.globalswitches) then
   Message1(exec_i_linking,current_module.sharedlibfilename^);

{ Write used files and libraries }
  WriteResponseFile(true);

 { Create some replacements }
  InitStr:='-init FPC_LIB_START';
  FiniStr:='-fini FPC_LIB_EXIT';
  SoNameStr:='-soname '+ExtractFileName(current_module.sharedlibfilename^);

{ Call linker }
  SplitBinCmd(Info.DllCmd[1],binstr,cmdstr);
  Replace(cmdstr,'$EXE',maybequoted(current_module.sharedlibfilename^));
  Replace(cmdstr,'$OPT',Info.ExtraOptions);
  Replace(cmdstr,'$RES',maybequoted(outputexedir+Info.ResName));
  Replace(cmdstr,'$INIT',InitStr);
  Replace(cmdstr,'$FINI',FiniStr);
  Replace(cmdstr,'$SONAME',SoNameStr);
  success:=DoExec(FindUtil(utilsprefix+binstr),cmdstr,true,false);

{ Strip the library ? }
  if success and (cs_link_strip in current_settings.globalswitches) then
   begin
     { only remove non global symbols and debugging info for a library }
     Info.DllCmd[2]:='strip --discard-all --strip-debug $EXE';
     SplitBinCmd(Info.DllCmd[2],binstr,cmdstr);
     Replace(cmdstr,'$EXE',maybequoted(current_module.sharedlibfilename^));
     success:=DoExec(FindUtil(utilsprefix+binstr),cmdstr,true,false);
   end;

{ Remove ReponseFile }
  if (success) and not(cs_link_nolink in current_settings.globalswitches) then
   DeleteFile(outputexedir+Info.ResName);

  MakeSharedLibrary:=success;   { otherwise a recursive call to link method }
end;


function tlinkerLinux.postprocessexecutable(const fn : string;isdll:boolean):boolean;
var
  cmdstr: string;
begin
  result:=True;
  if HasResources and
     (target_res.id=res_elf) then
    begin
      cmdstr:=' -f -i '+maybequoted(fn);
      result:=DoExec(FindUtil(utilsprefix+'fpcres'),cmdstr,false,false);
    end;
end;


{*****************************************************************************
                                  Initialize
*****************************************************************************}

initialization
{$ifdef i386}
  RegisterExternalLinker(system_i386_linux_info,TLinkerLinux);
  RegisterImport(system_i386_linux,timportliblinux);
  RegisterExport(system_i386_linux,texportliblinux);
  RegisterTarget(system_i386_linux_info);
  RegisterRes(res_elf32_info);

  RegisterExternalLinker(system_x86_6432_linux_info,TLinkerLinux);
  RegisterImport(system_x86_6432_linux,timportliblinux);
  RegisterExport(system_x86_6432_linux,texportliblinux);
  RegisterTarget(system_x86_6432_linux_info);
{$endif i386}
{$ifdef m68k}
  RegisterExternalLinker(system_m68k_linux_info,TLinkerLinux);
  RegisterImport(system_m68k_linux,timportliblinux);
  RegisterExport(system_m68k_linux,texportliblinux);
  RegisterTarget(system_m68k_linux_info);
{$endif m68k}
{$ifdef powerpc}
  RegisterExternalLinker(system_powerpc_linux_info,TLinkerLinux);
  RegisterImport(system_powerpc_linux,timportliblinux);
  RegisterExport(system_powerpc_linux,texportliblinux);
  RegisterTarget(system_powerpc_linux_info);
{$endif powerpc}
{$ifdef powerpc64}
  RegisterExternalLinker(system_powerpc64_linux_info,TLinkerLinux);
  RegisterImport(system_powerpc64_linux,timportliblinux);
  RegisterExport(system_powerpc64_linux,texportliblinux);
  RegisterTarget(system_powerpc64_linux_info);
{$endif powerpc64}
{$ifdef alpha}
  RegisterExternalLinker(system_alpha_linux_info,TLinkerLinux);
  RegisterImport(system_alpha_linux,timportliblinux);
  RegisterExport(system_alpha_linux,texportliblinux);
  RegisterTarget(system_alpha_linux_info);
{$endif alpha}
{$ifdef x86_64}
  RegisterExternalLinker(system_x86_64_linux_info,TLinkerLinux);
  RegisterImport(system_x86_64_linux,timportliblinux);
  RegisterExport(system_x86_64_linux,texportliblinux);
  RegisterTarget(system_x86_64_linux_info);
  RegisterRes(res_elf64_info);
{$endif x86_64}
{$ifdef SPARC}
  RegisterExternalLinker(system_sparc_linux_info,TLinkerLinux);
  RegisterImport(system_SPARC_linux,timportliblinux);
  RegisterExport(system_SPARC_linux,texportliblinux);
  RegisterTarget(system_SPARC_linux_info);
{$endif SPARC}
{$ifdef ARM}
  RegisterExternalLinker(system_arm_linux_info,TLinkerLinux);
  RegisterImport(system_arm_linux,timportliblinux);
  RegisterExport(system_arm_linux,texportliblinux);
  RegisterTarget(system_arm_linux_info);
{$endif ARM}
end.

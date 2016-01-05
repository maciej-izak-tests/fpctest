{
    This file is part of the Free Pascal run time library.
    Copyright (c) 1999-2000 by Florian Klaempfl

    This unit contains some routines to get informations about the
    processor

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
{$mode objfpc}
unit cpu;

  interface

    uses
      sysutils;

    { returns true, if the processor supports the cpuid instruction }
    function cpuid_support : boolean;

    { returns true, if floating point is done by an emulator }
    function floating_point_emulation : boolean;

    { returns the contents of the cr0 register }
    function cr0 : longint;

    function InterlockedCompareExchange128Support : boolean;
    function AESSupport : boolean;inline;
    function AVXSupport: boolean;inline;
    function AVX2Support: boolean;inline;
    function FMASupport: boolean;inline;

    var
      is_sse3_cpu : boolean = false;

    function InterlockedCompareExchange128(var Target: Int128Rec; NewValue: Int128Rec; Comperand: Int128Rec): Int128Rec;

  implementation

{$ASMMODE INTEL}
    var
      _AVXSupport,
      _AVX2Support,
      _AESSupport,
      _FMASupport : boolean;


    function InterlockedCompareExchange128(var Target: Int128Rec; NewValue: Int128Rec; Comperand: Int128Rec): Int128Rec;
      begin
        RunError(217);
      end;


    function cpuid_support : boolean;assembler;
      {
        Check if the ID-flag can be changed, if changed then CpuID is supported.
        Tested under go32v1 and Linux on c6x86 with CpuID enabled and disabled (PFV)
      }
      asm
         push    ebx
         pushfd
         pushfd
         pop     eax
         mov     ebx,eax
         xor     eax,200000h
         push    eax
         popfd
         pushfd
         pop     eax
         popfd
         and     eax,200000h
         and     ebx,200000h
         cmp     eax,ebx
         setnz   al
         pop     ebx
      end;


    function cr0 : longint;assembler;
      asm
         DB 0Fh,20h,0C0h
         { mov eax,cr0
           special registers are not allowed in the assembler
                parsers }
      end;


    function floating_point_emulation : boolean;
      begin
         {!!!! I don't know currently the position of the EM flag }
         { $4 after Ralf Brown's list }
         floating_point_emulation:=(cr0 and $4)<>0;
      end;


{$ASMMODE ATT}
    function XGETBV(i : dword) : int64;assembler;
      asm
        movl %eax,%ecx
        // older FPCs don't know the xgetbv opcode
        .byte 0x0f,0x01,0xd0
      end;


    procedure SetupSupport;
      var
         _ecx,_ebx : longint;
      begin
        is_sse3_cpu:=false;
         if cpuid_support then
           begin
              asm
                 pushl %ebx
                 movl $1,%eax
                 cpuid
                 movl %ecx,_ecx
                 popl %ebx
              end;
              _AESSupport:=(_ecx and $2000000)<>0;

              _AVXSupport:=
                { XGETBV suspport? }
                ((_ecx and $08000000)<>0) and
                { xmm and ymm state enabled? }
                ((XGETBV(0) and %110)=%110) and
                { avx supported? }
                ((_ecx and $10000000)<>0);

              is_sse3_cpu:=(_ecx and $1)<>0;

              _FMASupport:=_AVXSupport and ((_ecx and $1000)<>0);

              asm
                 pushl %ebx
                 movl $7,%eax
                 movl $0,%ecx
                 cpuid
                 movl %ebx,_ebx
                 popl %ebx
              end;
              _AVX2Support:=_AVXSupport and ((_ebx and $20)<>0);
           end;
      end;


    function InterlockedCompareExchange128Support : boolean;
      begin
        { 32 Bit CPUs have no 128 Bit interlocked exchange support }
        result:=false;
      end;


    function AESSupport : boolean;
      begin
        result:=_AESSupport;
      end;


    function AVXSupport: boolean;inline;
      begin
        result:=_AVXSupport;
      end;


    function AVX2Support: boolean;inline;
      begin
        result:=_AVX2Support;
      end;


    function FMASupport: boolean;inline;
      begin
        result:=_FMASupport;
      end;

begin
  SetupSupport;
end.

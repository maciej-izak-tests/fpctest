{
    $Id: cpuinfo.pas,v 1.28 2005/02/14 17:13:09 peter Exp $
    Copyright (c) 1998-2004 by Florian Klaempfl

    Basic Processor information

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
Unit cpuinfo;

{$i fpcdefs.inc}

Interface

  uses
    globtype;

Type
   bestreal = extended;
   ts32real = single;
   ts64real = double;
   ts80real = extended;
   ts128real = type extended;
   ts64comp = type extended;

   pbestreal=^bestreal;

   { possible supported processors for this target }
   tprocessors =
      (no_processor,
       Class386,
       ClassPentium,
       ClassPentium2,
       ClassPentium3,
       ClassPentium4
      );

   tfputype =
     (no_fpuprocessor,
      fpu_soft,
      fpu_x87,
      fpu_sse,
      fpu_sse2
     );


Const
   { calling conventions supported by the code generator }
   supported_calling_conventions : tproccalloptions = [
     pocall_internproc,
     pocall_compilerproc,
     pocall_inline,
     pocall_register,
     pocall_safecall,
     pocall_stdcall,
     pocall_cdecl,
     pocall_cppdecl,
     pocall_far16,
     pocall_pascal,
     pocall_oldfpccall
   ];

   processorsstr : array[tprocessors] of string[10] = ('',
     '386',
     'PENTIUM',
     'PENTIUM2',
     'PENTIUM3',
     'PENTIUM4'
   );

   fputypestr : array[tfputype] of string[6] = ('',
     'SOFT',
     'X87',
     'SSE',
     'SSE2'
   );

   sse_singlescalar : set of tfputype = [fpu_sse,fpu_sse2];
   sse_doublescalar : set of tfputype = [fpu_sse2];

Implementation

end.
{
  $Log: cpuinfo.pas,v $
  Revision 1.28  2005/02/14 17:13:09  peter
    * truncate log

}

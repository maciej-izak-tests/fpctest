{
    $Id: utility.pp,v 1.2 2005/02/14 17:13:30 peter Exp $
    This file is part of the Free Pascal run time library.
    Copyright (c) 2004 Karoly Balogh for Genesi S.a.r.l. <www.genesi.lu>

    utility.library interface unit for MorphOS/PowerPC

    MorphOS port was done on a free Pegasos II/G4 machine
    provided by Genesi S.a.r.l. <www.genesi.lu>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

unit utility;

interface

uses
  exec;

var
  UtilityBase: Pointer;

{$include utild1.inc}
{$include utild2.inc}
{$include utilf.inc}

implementation

begin
  UtilityBase:=MOS_UtilityBase;
end.

{
  $Log: utility.pp,v $
  Revision 1.2  2005/02/14 17:13:30  peter
    * truncate log

}

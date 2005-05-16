{
    $Id: cputarg.pas,v 1.10 2005/02/26 01:27:00 jonas Exp $
    Copyright (c) 2001-2002 by Peter Vreman

    Includes the powerpc dependent target units

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
unit cputarg;

{$i fpcdefs.inc}

interface


implementation

    uses
      systems { prevent a syntax error when nothing is included }

{**************************************
             Targets
**************************************}

    {$ifndef NOTARGETLINUX}
      ,t_linux
    {$endif}
    {$ifndef NOTARGETMACOS}
      ,t_macos
    {$endif}
    {$ifndef NOTARGETDARWIN}
      ,t_bsd
    {$endif}
    {$ifndef NOTARGETMORPHOS}
      ,t_morph
    {$endif}

{**************************************
             Assemblers
**************************************}

    {$ifndef NOAGPPCGAS}
      ,agppcgas
    {$endif}
    {$ifndef NOAGPPPCMPW}
      ,agppcmpw
    {$endif}
    
    
{**************************************
             Optimizer
**************************************}

    {$ifndef NOOPT}
      , aoptcpu
    {$endif NOOPT}
      ;

end.
{
  $Log: cputarg.pas,v $
  Revision 1.10  2005/02/26 01:27:00  jonas
    * fixed generic jumps optimizer and enabled it for ppc (the label table
      was not being initialised -> getfinaldestination always failed, which
      caused wrong optimizations in some cases)
    * changed the inverse_cond into a function, because tasmcond is a record
      on ppc
    + added a compare_conditions() function for the same reason

  Revision 1.9  2005/02/14 17:13:10  peter
    * truncate log

}

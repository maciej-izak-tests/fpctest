{
    $Id: iom.pas,v 1.3 2005/02/14 17:13:21 peter Exp $
    This file is part of the Numlib package.
    Copyright (c) 1986-2000 by
     Kees van Ginneken, Wil Kortsmit and Loek van Reij of the
     Computational centre of the Eindhoven University of Technology

    FPC port Code          by Marco van de Voort (marco@freepascal.org)
             documentation by Michael van Canneyt (Michael@freepascal.org)

    Basic In and output of matrix and vector types. Maybe too simple for
    your application, but still handy for logging and debugging.

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit iom;

interface
{$I direct.inc}

uses typ;

const
    npos  : ArbInt = 78;

{Read a n-dimensional vector v from textfile}
procedure iomrev(var inp: text; var v: ArbFloat; n: ArbInt);

{Read a m x n-dimensional matrix a from textfile}
procedure iomrem(var inp: text; var a: ArbFloat; m, n, rwidth: ArbInt);

{Write a n-dimensional vectorv v to textfile}
procedure iomwrv(var out: text; var v: ArbFloat; n, form: ArbInt);

{Write a m x n-dimensional matrix a to textfile}
procedure iomwrm(var out: text; var a: ArbFloat; m, n, rwidth, form: ArbInt);

implementation

procedure iomrev(var inp: text; var v: ArbFloat; n: ArbInt);

var pv : ^arfloat1;
     i : ArbInt;

BEGIN
  pv:=@v; for i:=1 to n do read(inp, pv^[i])
END {iomrev};

procedure iomrem(var inp: text; var a: ArbFloat; m, n, rwidth: ArbInt);

var    pa : ^arfloat1;
     i, k : ArbInt;

BEGIN
  pa:=@a; k:=1;
  for i:=1 to m do
    BEGIN
      iomrev(inp, pa^[k], n); Inc(k, rwidth)
    END
END {iomrem};

procedure iomwrv(var out: text; var v: ArbFloat; n, form: ArbInt);

var  pv     : arfloat1 absolute v;
     i, i1  : ArbInt;
BEGIN
  if form>maxform then form:=maxform  else
  if form<minform then form:=minform;
  i1:=npos div (form+2);
  for i:=1 to n do
  if ((i mod i1)=0) or (i=n) then writeln(out, pv[i]:form)
                             else write(out, pv[i]:form, '':2)
END {iomwrv};

procedure iomwrm(var out: text; var a: ArbFloat; m, n, rwidth, form: ArbInt);

var  pa                            : ^arfloat1;
     i, k, nb, i1, l, j, r, l1, kk : ArbInt;

BEGIN
  if (n<1) or (m<1) then exit;
  pa:=@a;
  if form>maxform then form:=maxform else
  if form<minform then form:=minform;
  i1:=npos div (form+2); l1:=0;
  nb:=n div i1; r:=n mod i1;
  if r>0 then Inc(nb);
  for l:=1 to nb do
    BEGIN
      k:=l1+1; if (r>0) and (l=nb) then i1:=r;
      for i:=1 to m do
        BEGIN
          kk:=k;
          for j:=1 to i1-1 do
            BEGIN
              write(out, pa^[kk]:form, '':2); Inc(kk)
            END;
          writeln(out, pa^[kk]:form); Inc(k, rwidth)
        END;
      Inc(l1, i1); if l<nb then writeln(out)
    END;
END {iomwrm};

END.

{
  $Log: iom.pas,v $
  Revision 1.3  2005/02/14 17:13:21  peter
    * truncate log

}

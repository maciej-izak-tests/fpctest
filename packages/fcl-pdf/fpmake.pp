{$ifndef ALLPACKAGES}
{$mode objfpc}{$H+}
program fpmake;

uses fpmkunit;

Var
  P : TPackage;
  T : TTarget;
begin
  With Installer do
    begin
{$endif ALLPACKAGES}
    P:=AddPackage('fcl-pdf');
    P.ShortName:='fcpd';

{$ifdef ALLPACKAGES}
    P.Directory:=ADirectory;
{$endif ALLPACKAGES}

    P.Author := 'Michael Van Canneyt & Graeme Geldenhuys';
    P.License := 'LGPL with modification, ';
    P.HomepageURL := 'www.freepascal.org';
    P.Email := '';
    P.Description := 'PDF generating and TTF file info library';
    P.NeedLibC:= false;
    P.OSes:=P.OSes-[embedded,win16,msdos,nativent];
    P.Dependencies.Add('rtl-objpas');
    P.Dependencies.Add('fcl-base');
    P.Dependencies.Add('fcl-image');
    P.Dependencies.Add('paszlib');
    P.Version:='3.1.1';
    T:=P.Targets.AddUnit('src/fpttfencodings.pp');
    T:=P.Targets.AddUnit('src/fpparsettf.pp');
    With T do
      Dependencies.AddUnit('fpttfencodings');
    T:=P.Targets.AddUnit('src/fpttf.pp');
    T:=P.Targets.AddUnit('src/fppdf.pp');
    With T do
      begin
      Dependencies.AddUnit('fpparsettf');
      end;
    
    // md5.ref
{$ifndef ALLPACKAGES}
    Run;
    end;
end.
{$endif ALLPACKAGES}

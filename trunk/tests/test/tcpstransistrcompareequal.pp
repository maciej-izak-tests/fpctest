uses
{$ifdef unix}
  cwstring,
{$endif unix}
  SysUtils;
  
type
  ts1252 = type AnsiString(1252);
  ts1251 = type AnsiString(1251);
var
  s1 : ts1252;
  s2 : ts1251;
  au : unicodestring;
begin
  au := #$20AC; // Euro symbol
  s1 := au;
  s2 := au;
  if (s1<>s2) then
    halt(1);
  writeln('ok');
end.

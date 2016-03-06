{ %CPU=i386,x86_64 }
{ %OPT=-Cfavx2 -Cpcoreavx2 }
uses
  cpu;

{$i tfma1.inc}  
  
begin
  if AVXSupport and FMASupport then
    begin
      d1:=2;
      d2:=3;
      d3:=4;
      d0:=FMADouble(d1,d2,d3);
      writeln(d0);
      if d0<>10.0 then
        halt(1);

      s1:=2;
      s2:=3;
      s3:=4;
      s0:=FMASingle(s1,s2,s3);
      writeln(s0);
      if s0<>10.0 then
        halt(1);

      testsingle;
      testdouble;

      writeln('ok');
    end
  else
    writeln('Skipped because not supported by the CPU');
end.

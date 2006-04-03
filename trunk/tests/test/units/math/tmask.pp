program fpu;

{$mode delphi}

uses SysUtils,Math;

var
  f1,f2 : double;
  caught: boolean;

begin
f1:=1.0;
f2:=0.0;
caught := false;
try
  writeln('dividing by zero without having disabled FPU Exceptions...');
  writeln(f1/f2);
  writeln('no exception was raised');
except on E:Exception do
  begin
    writeln('Exception occured:',E.Message);
    caught := true;
  end;
end;

if not caught then
  halt(1);

writeln('Masking exceptions');

writeln(integer(SetExceptionMask([exDenormalized,exInvalidOp,exOverflow,exPrecision,exUnderflow,exZeroDivide])));  //Returns 61, as expected
writeln(integer(GetExceptionMask));  //Returns 4 - unexpected???
writeln(integer([exZeroDivide]));    //Returns 4

caught := false;
try
  writeln('dividing by zero with FPU Exceptions disabled...');
  writeln(f1/f2);
  writeln('no exception was raised');
except on E:Exception do
  begin
    writeln('Exception occured:',E.Message);
    caught := true;
  end;
end;

if caught then
  halt(2);

writeln(integer(SetExceptionMask([exDenormalized,exInvalidOp,exOverflow,exPrecision,exUnderflow])));  //Returns 61, as expected
writeln(integer(GetExceptionMask));  //Returns 4 - unexpected???
writeln(integer([exZeroDivide]));    //Returns 4

caught := false;

try
  writeln('dividing by zero without having disabled FPU Exceptions...');
  writeln(f1/f2);
  writeln('no exception was raised');
except on E:Exception do
  begin
    writeln('Exception occured:',E.Message);
    caught := true;
  end;
end;

if not caught then
  halt(0);

end.

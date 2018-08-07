unit MathHelper_u;

interface

function math_sin(f:extended):extended;
function math_cos(f:extended):extended;

implementation

uses generation_obsh;

var sin_table:ar_double;
i:integer;

function math_sin(f:extended):extended;
begin
  result:=SIN_TABLE[trunc(f * 10430.38) and $ffff];
end;

function math_cos(f:extended):extended;
begin
  result:=SIN_TABLE[trunc(f * 10430.38 + 16384) and $ffff];
end;

initialization

setlength(sin_table,65536);
for i:=0 to 65535 do
  sin_table[i]:=sin((i * 3.1415926535897931 * 2) / 65536);

finalization

setlength(sin_table,0);

end.

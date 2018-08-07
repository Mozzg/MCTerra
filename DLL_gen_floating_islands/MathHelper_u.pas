unit MathHelper_u;

interface

function floor_double_long(d:extended):int64;
function floor_double(d:double):integer;
function math_sin(f:double):double;
function math_cos(f:double):double;

implementation

var SIN_TABLE:array[0..65535] of double;
i:integer;

function floor_double_long(d:extended):int64;
var t:int64;
begin
  t:=trunc(d);
  if d>=t then result:=t
  else result:=t-1;
end;

function floor_double(d:double):integer;
var t:integer;
begin
  t:=trunc(d);
  if d>=t then result:=t
  else result:=t-1;
end;

function math_sin(f:double):double;
begin
  result:=SIN_TABLE[trunc(f * 10430.38) and $ffff];
end;

function math_cos(f:double):double;
begin
  result:=SIN_TABLE[trunc(f * 10430.38 + 16384) and $ffff];
end;

initialization

for i:=0 to 65535 do
  SIN_TABLE[i]:=sin((i * 3.1415926535897931 * 2) / 65536);

end.

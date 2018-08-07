unit LayerIsland_u;

interface

uses GenLayer_u, generation_obsh;

type  LayerIsland=class(GenLayer)
      public
        function func_35500_a(i,j,k,l:integer):ar_int; override;
      end;

implementation

uses IntCache_u;

function LayerIsland.func_35500_a(i,j,k,l:integer):ar_int;
var i1,j1:integer;
ai:par_int;
begin
  ai:=IntCache_u.getIntCache(k * l);
  for i1:=0 to l-1 do
    for j1:=0 to k-1 do
    begin
      func_35499_a(i + j1, j + i1);
      if nextInt(10)<>0 then ai^[j1 + i1 * k]:=0
      else ai^[j1 + i1 * k]:=1;
    end;

  if (i>-k)and(i<=0)and(j>-l)and(j<=0) then
    ai^[-i + -j * k]:= 1;

  result:=ai^;
end;

end.

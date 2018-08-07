unit GenLayerRiverInit_u;

interface

uses GenLayer_u, generation_obsh;

type  GenLayerRiverInit=class(GenLayer)
      public
        constructor Create(l:int64; gen:GenLayer);
        function func_35500_a(i,j,k,l:integer):ar_int; override;
      end;

implementation

uses IntCache_u;

constructor GenLayerRiverInit.Create(l:int64; gen:GenLayer);
begin
  inherited Create(l);
  parent:=gen;
end;

function GenLayerRiverInit.func_35500_a(i,j,k,l:integer):ar_int;
var i1,j1:integer;
ai:ar_int;
ai1:par_int;
begin
  ai:=parent.func_35500_a(i, j, k, l);    
  ai1:=IntCache_u.getIntCache(k * l);
  for i1:=0 to l-1 do
    for j1:=0 to k-1 do
    begin
      func_35499_a(j1 + i, i1 + j);
      if (ai[j1 + i1 * k] <= 0) then ai1^[j1 + i1 * k]:=0
      else ai1^[j1 + i1 * k]:=nextInt(2) + 2;
    end;

  //setlength(ai,0);
  result:=ai1^;
end;

end.

unit LayerIsland_u;

interface

uses GenLayer_u, generation;

type LayerIsland=class(GenLayer)
     public
       function getInts(i,j,k,l:integer):ar_int; override;
     end;

implementation

uses IntCache_u;

function LayerIsland.getInts(i,j,k,l:integer):ar_int;
var ai:par_int;
i1,j1:integer;
begin    
  ai:=getIntCache(k * l);
  for i1:=0 to l-1 do
    for j1:=0 to k-1 do
    begin
      initChunkSeed(i + j1, j + i1);
      if nextInt(10)<>0 then ai^[j1 + i1 * k]:=0
      else ai^[j1 + i1 * k]:=1;
    end;
  if (i>-k)and(i<=0)and(j>-l)and(j<=0) then
    ai^[-i + -j * k]:=1;

  result:=ai^;
end;

end.

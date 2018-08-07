unit GenLayerSwampRivers_u;

interface

uses GenLayer_u, generation;

type GenLayerSwampRivers=class(GenLayer)
     public
       constructor Create(l:int64; gen:GenLayer);
       destructor Destroy; override;
       function getInts(i,j,k,l:integer):ar_int; override;
     end;

implementation

uses IntCache_u, BiomeGenBase_u;

constructor GenLayerSwampRivers.Create(l:int64; gen:GenLayer);
begin
  inherited Create(l);
  parent:=gen;
end;

destructor GenLayerSwampRivers.Destroy;
begin
  //if parent<>nil then parent.Free;
  //parent:=nil;
  inherited;
end;

function GenLayerSwampRivers.getInts(i,j,k,l:integer):ar_int;
var ai:ar_int;
ai1:par_int;
i1,j1,k1:integer;
begin
  ai:=parent.getInts(i - 1, j - 1, k + 2, l + 2);
  ai1:=IntCache_u.getIntCache(k * l);
  for i1:=0 to l-1 do
    for j1:=0 to k-1 do
    begin
      initChunkSeed(j1 + i, i1 + j);
      k1:=ai[j1 + 1 + (i1 + 1) * (k + 2)];
      if (k1 = BiomeGenBase_u.swampland_b.biomeID)and(nextInt(6) = 0)then
        ai1^[j1 + i1 * k]:=BiomeGenBase_u.river_b.biomeID
      else
        ai1^[j1 + i1 * k]:=k1;
    end;

  result:=ai1^;
end;

end.

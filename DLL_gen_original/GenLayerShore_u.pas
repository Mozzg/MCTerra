unit GenLayerShore_u;

interface

uses GenLayer_u, generation;

type GenLayerShore=class(GenLayer)
     public
       constructor Create(l:int64; gen:GenLayer);
       destructor Destroy; override;
       function getInts(i,j,k,l:integer):ar_int; override;
     end;

implementation

uses IntCache_u, BiomeGenBase_u;

constructor GenLayerShore.Create(l:int64; gen:GenLayer);
begin
  inherited Create(l);
  parent:=gen;
end;

destructor GenLayerShore.Destroy;
begin
  //if parent<>nil then parent.Free;
  //parent:=nil;
  inherited;
end;

function GenLayerShore.getInts(i,j,k,l:integer):ar_int;
var ai:ar_int;
ai1:par_int;
i1,j1,k1,l1,k2,j3,i4,i2,l2,k3,j4,j2,i3,l3,k4:integer;
begin
  ai:=parent.getInts(i - 1, j - 1, k + 2, l + 2);
  ai1:=IntCache_u.getIntCache(k * l);
  for i1:=0 to l-1 do
    for j1:=0 to k-1 do
    begin
      initChunkSeed(j1 + i, i1 + j);
      k1:=ai[j1 + 1 + (i1 + 1) * (k + 2)];
      if (k1 = BiomeGenBase_u.mushroomIsland_b.biomeID)then
      begin
        l1:=ai[j1 + 1 + ((i1 + 1) - 1) * (k + 2)];
        k2:=ai[j1 + 1 + 1 + (i1 + 1) * (k + 2)];
        j3:=ai[((j1 + 1) - 1) + (i1 + 1) * (k + 2)];
        i4:=ai[j1 + 1 + (i1 + 1 + 1) * (k + 2)];
        if (l1 = BiomeGenBase_u.ocean_b.biomeID)or(k2 = BiomeGenBase_u.ocean_b.biomeID)or(j3 = BiomeGenBase_u.ocean_b.biomeID)or(i4 = BiomeGenBase_u.ocean_b.biomeID)then
          ai1^[j1 + i1 * k]:=BiomeGenBase_u.mushroomIslandShore_b.biomeID
        else
          ai1^[j1 + i1 * k]:=k1;
        continue;
      end;
      if (k1 <> BiomeGenBase_u.ocean_b.biomeID)and(k1 <> BiomeGenBase_u.river_b.biomeID)and(k1 <> BiomeGenBase_u.swampland_b.biomeID)and(k1 <> BiomeGenBase_u.extremeHills_b.biomeID)then
      begin
        i2:=ai[j1 + 1 + ((i1 + 1) - 1) * (k + 2)];
        l2:=ai[j1 + 1 + 1 + (i1 + 1) * (k + 2)];
        k3:=ai[((j1 + 1) - 1) + (i1 + 1) * (k + 2)];
        j4:=ai[j1 + 1 + (i1 + 1 + 1) * (k + 2)];
        if (i2 = BiomeGenBase_u.ocean_b.biomeID)or(l2 = BiomeGenBase_u.ocean_b.biomeID)or(k3 = BiomeGenBase_u.ocean_b.biomeID)or(j4 = BiomeGenBase_u.ocean_b.biomeID)then
          ai1^[j1 + i1 * k]:=BiomeGenBase_u.beach_b.biomeID
        else
          ai1^[j1 + i1 * k]:=k1;
        continue;
      end;
      if (k1 = BiomeGenBase_u.extremeHills_b.biomeID)then
      begin
        j2:=ai[j1 + 1 + ((i1 + 1) - 1) * (k + 2)];
        i3:=ai[j1 + 1 + 1 + (i1 + 1) * (k + 2)];
        l3:=ai[((j1 + 1) - 1) + (i1 + 1) * (k + 2)];
        k4:=ai[j1 + 1 + (i1 + 1 + 1) * (k + 2)];
        if (j2 <> BiomeGenBase_u.extremeHills_b.biomeID)or(i3 <> BiomeGenBase_u.extremeHills_b.biomeID)or(l3 <> BiomeGenBase_u.extremeHills_b.biomeID)or(k4 <> BiomeGenBase_u.extremeHills_b.biomeID)then
          ai1^[j1 + i1 * k]:=BiomeGenBase_u.extremeHillsEdge_b.biomeID
        else
          ai1^[j1 + i1 * k]:=k1;
      end
      else
        ai1^[j1 + i1 * k]:=k1;
    end;

  result:=ai1^;
end;

end.

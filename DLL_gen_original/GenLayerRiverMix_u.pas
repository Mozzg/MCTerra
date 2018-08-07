unit GenLayerRiverMix_u;

interface

uses GenLayer_u, generation;

type GenLayerRiverMix=class(GenLayer)
     private
       field_35512_b,field_35513_c:GenLayer;
     public
       constructor Create(l:int64; gen,gen1:GenLayer);
       destructor Destroy; override;
       procedure initWorldGenSeed(l:int64); override;
       function getInts(i,j,k,l:integer):ar_int; override;
     end;

implementation

uses IntCache_u, BiomeGenBase_u;

constructor GenLayerRiverMix.Create(l:int64; gen,gen1:GenLayer);
begin
  inherited Create(l);
  field_35512_b:=gen;
  field_35513_c:=gen1;
end;

destructor GenLayerRiverMix.Destroy;
begin
  {if field_35512_b<>nil then field_35512_b.Free;
  field_35512_b:=nil;
  if field_35513_c<>nil then field_35513_c.Free;
  field_35513_c:=nil;
  if parent<>nil then parent.Free;
  parent:=nil;  }
  inherited;
end;

procedure GenLayerRiverMix.initWorldGenSeed(l:int64);
begin
  field_35512_b.initWorldGenSeed(l);
  field_35513_c.initWorldGenSeed(l);
  inherited initWorldGenSeed(l);
end;

function GenLayerRiverMix.getInts(i,j,k,l:integer):ar_int;
var ai,ai1:ar_int;
ai2:par_int;
i1:integer;
begin
  ai:=field_35512_b.getInts(i, j, k, l);
  ai1:=field_35513_c.getInts(i, j, k, l);
  ai2:=IntCache_u.getIntCache(k * l);
  for i1:=0 to k*l-1 do
  begin
    if (ai[i1] = BiomeGenBase_u.ocean_b.biomeID)then
    begin
      ai2^[i1]:=ai[i1];
      continue;
    end;
    if (ai1[i1] >= 0)then
    begin
      if (ai[i1] = BiomeGenBase_u.icePlains_b.biomeID)then
      begin
        ai2^[i1]:=BiomeGenBase_u.frozenRiver_b.biomeID;
        continue;
      end;
      if (ai[i1] = BiomeGenBase_u.mushroomIsland_b.biomeID)or(ai[i1] = BiomeGenBase_u.mushroomIslandShore_b.biomeID)then
        ai2^[i1]:=BiomeGenBase_u.mushroomIslandShore_b.biomeID
      else
        ai2^[i1]:=ai1[i1];
    end
    else
      ai2^[i1]:=ai[i1];
  end;

  result:=ai2^;
end;

end.

unit GenLayerHills_u;

interface

uses GenLayer_u, generation;

type GenLayerHills=class(GenLayer)
     public
       constructor Create(l:int64; gen:GenLayer);
       destructor Destroy; override;
       function getInts(i,j,k,l:integer):ar_int; override;
     end;

implementation

uses IntCache_u, BiomeGenBase_u;

constructor GenLayerHills.Create(l:int64; gen:GenLayer);
begin
  inherited Create(l);
  parent:=gen;
end;

destructor GenLayerHills.Destroy;
begin
  //if parent<>nil then parent.Free;
  //parent:=nil;
  inherited;
end;

function GenLayerHills.getInts(i,j,k,l:integer):ar_int;
var ai:ar_int;
ai1:par_int;
i1,j1,k1,l1,i2,j2,k2,l2:integer;
begin
  ai:=parent.getInts(i - 1, j - 1, k + 2, l + 2);
  ai1:=IntCache_u.getIntCache(k * l);
  for i1:=0 to l-1 do
    for j1:=0 to k-1 do
    begin
      initChunkSeed(j1 + i, i1 + j);
      k1:=ai[j1 + 1 + (i1 + 1) * (k + 2)];
      if (nextInt(3) = 0)then
      begin
        l1:=k1;
        if (k1 = BiomeGenBase_u.desert_b.biomeID)then
          l1:=BiomeGenBase_u.desertHills_b.biomeID
        else if (k1 = BiomeGenBase_u.forest_b.biomeID)then
          l1:=BiomeGenBase_u.forestHills_b.biomeID
        else if (k1 = BiomeGenBase_u.taiga_b.biomeID)then
          l1:=BiomeGenBase_u.taigaHills_b.biomeID
        else if (k1 = BiomeGenBase_u.plains_b.biomeID)then
          l1:=BiomeGenBase_u.forest_b.biomeID
        else if (k1 = BiomeGenBase_u.icePlains_b.biomeID)then
          l1:=BiomeGenBase_u.iceMountains_b.biomeID;

        if (l1 <> k1)then
        begin
          i2:=ai[j1 + 1 + ((i1 + 1) - 1) * (k + 2)];
          j2:=ai[j1 + 1 + 1 + (i1 + 1) * (k + 2)];
          k2:=ai[((j1 + 1) - 1) + (i1 + 1) * (k + 2)];
          l2:=ai[j1 + 1 + (i1 + 1 + 1) * (k + 2)];
          if (i2 = k1)and(j2 = k1)and(k2 = k1)and(l2 = k1)then
            ai1^[j1 + i1 * k]:=l1
          else
            ai1^[j1 + i1 * k]:=k1;
        end
        else
          ai1^[j1 + i1 * k]:=k1;
      end
      else
        ai1^[j1 + i1 * k]:=k1;
    end;

  result:=ai1^;
end;



end.

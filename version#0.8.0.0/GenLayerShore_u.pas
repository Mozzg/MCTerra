unit GenLayerShore_u;

interface

uses GenLayer_u, generation_obsh;

type  GenLayerShore=class(GenLayer)
      public
        constructor Create(l:int64; gen:GenLayer);
        function func_35500_a(i,j,k,l:integer):ar_int; override;
      end;

implementation

uses IntCache_u, BiomeGenBase_u;

constructor GenLayerShore.Create(l:int64; gen:GenLayer);
begin
  inherited Create(l);
  parent:=gen;
end;

function GenLayerShore.func_35500_a(i,j,k,l:integer):ar_int;
var ai:ar_int;
ai1:par_int;
i1,j1,k1,l1,i2,j2,k2,t:integer;
begin
  ai:=parent.func_35500_a(i - 1, j - 1, k + 2, l + 2);
  ai1:=IntCache_u.getIntCache(k * l);
  for i1:=0 to l-1 do
    for j1:=0 to k-1 do
    begin
      func_35499_a(j1 + i, i1 + j);
      k1:=ai[j1 + 1 + (i1 + 1) * (k + 2)];
      if k1=BiomeGenBase_u.mushroomIsland_b.biomeID then
      begin
        l1:=ai[j1 + 1 + ((i1 + 1) - 1) * (k + 2)];
        i2:=ai[j1 + 1 + 1 + (i1 + 1) * (k + 2)];
        j2:=ai[((j1 + 1) - 1) + (i1 + 1) * (k + 2)];
        k2:=ai[j1 + 1 + (i1 + 1 + 1) * (k + 2)];
        t:=BiomeGenBase_u.ocean_b.biomeID;
        if (l1=t)or(i2=t)or(j2=t)or(k2=t) then
          ai1^[j1 + i1 * k]:=BiomeGenBase_u.mushroomIslandShore_b.biomeID
        else
          ai1^[j1 + i1 * k]:=k1;
      end
      else
        ai1^[j1 + i1 * k]:=k1;
    end;

  result:=ai1^;
end;

end.

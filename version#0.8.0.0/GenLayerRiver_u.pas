unit GenLayerRiver_u;

interface

uses GenLayer_u, generation_obsh;

type  GenLayerRiver=class(GenLayer)
      public
        constructor Create(l:int64; gen:GenLayer);
        function func_35500_a(i,j,k,l:integer):ar_int; override;
      end;

implementation

uses BiomeGenBase_u, IntCache_u;

constructor GenLayerRiver.Create(l:int64; gen:GenLayer);
begin
  inherited Create(l);
  parent:=gen;
end;

function GenLayerRiver.func_35500_a(i,j,k,l:integer):ar_int;
var i1,j1,k1,l1,i2,j2,k2,l2,i3,j3,k3:integer;
ai:ar_int;
ai1:par_int;
begin
  i1:=i-1;
  j1:=j-1;
  k1:=k+2;
  l1:=l+2;
  ai:=parent.func_35500_a(i1, j1, k1, l1);  
  ai1:=IntCache_u.getIntCache(k * l);
  for i2:=0 to l-1 do
    for j2:=0 to k-1 do
    begin
      k2:=ai[j2 + 0 + (i2 + 1) * k1];
      l2:=ai[j2 + 2 + (i2 + 1) * k1];
      i3:=ai[j2 + 1 + (i2 + 0) * k1];
      j3:=ai[j2 + 1 + (i2 + 2) * k1];
      k3:=ai[j2 + 1 + (i2 + 1) * k1];
      //if(k3 == 0 || k2 == 0 || l2 == 0 || i3 == 0 || j3 == 0)
      if(k3=0)or(k2=0)or(l2=0)or(i3=0)or(j3=0) then
      begin
        ai1^[j2 + i2 * k]:=BiomeGenBase_u.river_b.biomeID;
        continue;
      end;
      //if(k3 != k2 || k3 != i3 || k3 != l2 || k3 != j3)
      if(k3<>k2)or(k3<>i3)or(k3<>l2)or(k3<>j3) then
        ai1^[j2 + i2 * k]:=BiomeGenBase_u.river_b.biomeID
      else
        ai1^[j2 + i2 * k]:=-1;
    end;

  //setlength(ai,0);
  result:=ai1^;
end;

end.

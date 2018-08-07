unit GenLayerIsland_u;

interface

uses GenLayer_u, generation_obsh;

type  GenLayerIsland=class(GenLayer)
      public
        constructor Create(l:int64; gen:GenLayer);
        function func_35500_a(i,j,k,l:integer):ar_int; override;
      end;

implementation

uses IntCache_u, BiomeGenBase_u;

constructor GenLayerIsland.Create(l:int64; gen:GenLayer);
begin
  inherited Create(l);
  parent:=gen;
end;

function GenLayerIsland.func_35500_a(i,j,k,l:integer):ar_int;
var i1,j1,k1,l1,i2,j2,k2,l2,i3,j3,k3,l3,i4:integer;
ai:ar_int;
ai1:par_int;
begin
  i1:=i-1;
  j1:=j-1;
  k1:=k+2;
  l1:=l+2;
  ai:=parent.func_35500_a(i1,j1,k1,l1);
  ai1:=IntCache_u.getIntCache(k * l);
  for i2:=0 to l-1 do
    for j2:=0 to k-1 do
    begin
      k2:=ai[j2 + 0 + (i2 + 0) * k1];
      l2:=ai[j2 + 2 + (i2 + 0) * k1];
      i3:=ai[j2 + 0 + (i2 + 2) * k1];
      j3:=ai[j2 + 2 + (i2 + 2) * k1];
      k3:=ai[j2 + 1 + (i2 + 1) * k1];
      func_35499_a(j2 + i, i2 + j);

      if(k3=0)and((k2<>0)or(l2<>0)or(i3<>0)or(j3<>0)) then
      begin
        l3:=1;
        i4:=1;
        if(k2<>0)and(nextInt(l3)=0) then i4:= k2;
        inc(l3);
        if(l2<>0)and(nextInt(l3)=0) then i4:= l2;
        inc(l3);
        if(i3<>0)and(nextInt(l3)=0) then i4:= i3;
        inc(l3);
        if(j3<>0)and(nextInt(l3)=0) then i4:= j3;
        inc(l3);
        if(nextInt(3)=0) then
        begin
          ai1^[j2 + i2 * k]:= i4;
          continue;
        end;
        if(i4=BiomeGenBase_u.icePlains_b.biomeID) then
          ai1^[j2 + i2 * k]:= BiomeGenBase_u.frozenOcean_b.biomeID
        else
          ai1^[j2 + i2 * k]:= 0;
        continue;
      end;

      if(k3>0)and((k2=0)or(l2=0)or(i3=0)or(j3=0)) then
      begin
        if(nextInt(5)=0) then
        begin
          if(k3 = BiomeGenBase_u.icePlains_b.biomeID) then
            ai1^[j2 + i2 * k]:= BiomeGenBase_u.frozenOcean_b.biomeID
          else
            ai1^[j2 + i2 * k]:= 0;
        end
        else
          ai1^[j2 + i2 * k]:= k3;
      end
      else
        ai1^[j2 + i2 * k]:= k3;

      (*//if(k3 == 0 && (k2 != 0 || l2 != 0 || i3 != 0 || j3 != 0))
      if ((k3=0)and((k2<>0)or(l2<>0)or(i3<>0)or(j3<>0))) then
      begin
        ai1^[j2 + i2 * k]:= func_35498_a(3) div 2;
        continue;
      end;
      //if(k3 == 1 && (k2 != 1 || l2 != 1 || i3 != 1 || j3 != 1))
      if(k3=1)and((k2<>1)or(l2<>1)or(i3<>1)or(j3<>1)) then
        ai1^[j2 + i2 * k]:=1 - (func_35498_a(5) div 4)
      else
        ai1^[j2 + i2 * k]:= k3;  *)
    end;

  //setlength(ai,0);
  result:=ai1^;
end;

end.

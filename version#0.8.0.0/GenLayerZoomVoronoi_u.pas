unit GenLayerZoomVoronoi_u;

interface

uses GenLayer_u, generation_obsh;

type  GenLayerZoomVoronoi=class(GenLayer)
      public
        constructor Create(l:int64; gen:GenLayer);
        function func_35500_a(i,j,k,l:integer):ar_int; override;
      end;

implementation

uses IntCache_u;

constructor GenLayerZoomVoronoi.Create(l:int64; gen:GenLayer);
begin
  inherited Create(l);
  parent:=gen;
end;

function GenLayerZoomVoronoi.func_35500_a(i,j,k,l:integer):ar_int;
const byte0=2;
var i1,j1,k1,l1,i2,j2,k2,l2,i3,j3,k3,l3,i4,j4,k4,l4,i5:integer;
d,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12:extended;
ai,ait:ar_int;
ai1,ai2:par_int;
begin
  i:=i-2;
  j:=j-2;
  {i1:= 1 shl byte0;
  j1:= i shr byte0;
  k1:= j shr byte0;
  l1:= (k shr byte0) + 3;
  i2:= (l shr byte0) + 3;   }
  i1:= shll(1,byte0);
  j1:= shrr(i,byte0);
  k1:= shrr(j,byte0);
  l1:= shrr(k,byte0) + 3;
  i2:= shrr(l,byte0) + 3;
  ai:=parent.func_35500_a(j1, k1, l1, i2);
  {j2:=l1 shl byte0;
  k2:=i2 shl byte0;   }
  j2:=shll(l1,byte0);
  k2:=shll(i2,byte0);
  ai1:=IntCache_u.getIntCache(j2 * k2);
  for l2:=0 to i2-2 do
  begin
    i3:=ai[0 + (l2 + 0) * l1];
    k3:=ai[0 + (l2 + 1) * l1];
    for l3:=0 to l1-2 do
    begin
      d:= i1 * 0.90000000000000002;
      //func_35499_a(l3 + j1 shl byte0, l2 + k1 shl byte0);
      func_35499_a(shll(l3+j1,byte0), shll(l2+k1,byte0));
      d1:= (nextInt(1024) / 1024 - 0.5) * d;
      d2:= (nextInt(1024) / 1024 - 0.5) * d;
      //func_35499_a(l3 + j1 + 1 shl byte0, l2 + k1 shl byte0);
      func_35499_a(shll(l3+j1+1,byte0), shll(l2+k1,byte0));
      d3:= (nextInt(1024) / 1024 - 0.5) * d + i1;
      d4:= (nextInt(1024) / 1024 - 0.5) * d;
      //func_35499_a(l3 + j1 shl byte0, l2 + k1 + 1 shl byte0);
      func_35499_a(shll(l3+j1,byte0), shll(l2+k1+1,byte0));
      d5:= (nextInt(1024) / 1024 - 0.5) * d;
      d6:= (nextInt(1024) / 1024 - 0.5) * d + i1;
      //func_35499_a(l3 + j1 + 1 shl byte0, l2 + k1 + 1 shl byte0);
      func_35499_a(shll(l3+j1+1,byte0), shll(l2+k1+1,byte0));
      d7:= (nextInt(1024) / 1024 - 0.5) * d + i1;
      d8:= (nextInt(1024) / 1024 - 0.5) * d + i1;
      i4:= ai[l3 + 1 + (l2 + 0) * l1];
      j4:= ai[l3 + 1 + (l2 + 1) * l1];
      for k4:=0 to i1-1 do
      begin
        //l4:= ((l2 shl byte0) + k4) * j2 + (l3 shl byte0);
        l4:= (shll(l2,byte0) + k4) * j2 + shll(l3,byte0);
        for i5:=0 to i1-1 do
        begin
          d9:= (k4 - d2) * (k4 - d2) + (i5 - d1) * (i5 - d1);
          d10:= (k4 - d4) * (k4 - d4) + (i5 - d3) * (i5 - d3);
          d11:= (k4 - d6) * (k4 - d6) + (i5 - d5) * (i5 - d5);
          d12:= (k4 - d8) * (k4 - d8) + (i5 - d7) * (i5 - d7);
          if(d9<d10)and(d9<d11)and(d9<d12) then
          begin
            ai1^[l4]:=i3;
            inc(l4);
            continue;
          end;
          if(d10<d9)and(d10<d11)and(d10<d12) then
          begin
            ai1^[l4]:= i4;
            inc(l4);
            continue;
          end;
          if(d11<d9)and(d11<d10)and(d11<d12) then
          begin
            ai1^[l4]:= k3;
            inc(l4);
          end
          else
          begin
            ai1^[l4]:= j4;
            inc(l4);
          end;
        end;
      end;
      i3:= i4;
      k3:= j4;
    end;
  end;

  setlength(ait,length(ai1^));
  move(ai1^[0],ait[0],length(ai1^)*sizeof(integer));

  ai2:=IntCache_u.getIntCache(k * l);
  for j3:=0 to l-1 do
    //System.arraycopy(ai1, (j3 + (j & i1 - 1)) * (l1 << byte0) + (i & i1 - 1), ai2, j3 * k, k);
    //move(ai1[(j3 + (j and i1 - 1)) * (l1 shl byte0) + (i and i1 - 1)],ai2[j3 * k],k*sizeof(integer));
    move(ait[(j3 + (j and (i1 - 1))) * (shll(l1,byte0)) + (i and (i1 - 1))],ai2^[j3 * k],k*sizeof(integer));

  //setlength(ai,0);
  //setlength(ai1,0);
  setlength(ait,0);
  result:=ai2^;
end;

end.

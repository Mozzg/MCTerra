unit GenLayerZoomFuzzy_u;

interface

uses GenLayer_u, generation;

type GenLayerZoomFuzzy=class(GenLayer)
     protected
       function choose(i,j:integer):integer; overload;
       function choose(i,j,k,l:integer):integer; overload;
     public
       constructor Create(l:int64; gen:GenLayer);
       destructor Destroy; override;
       function getInts(i,j,k,l:integer):ar_int; override;
     end;

implementation

uses IntCache_u;

constructor GenLayerZoomFuzzy.Create(l:int64; gen:GenLayer);
begin
  inherited Create(l);
  parent:=gen;
end;

destructor GenLayerZoomFuzzy.Destroy;
begin
  //if parent<>nil then parent.Free;
  //parent:=nil;
  inherited;
end;

function GenLayerZoomFuzzy.choose(i,j:integer):integer;
begin
  if nextInt(2)<>0 then result:=j
  else result:=i;
end;

function GenLayerZoomFuzzy.choose(i,j,k,l:integer):integer;
var i1:integer;
begin
  i1:=nextInt(4);
  case i1 of
    0:result:=i;
    1:result:=j;
    2:result:=k
    else result:=l;
  end; 
end;

function GenLayerZoomFuzzy.getInts(i,j,k,l:integer):ar_int;
var i1,j1,k1,l1,i2,j2,k2,i3,j3,k3,l3,i4,j4,l2:integer;
ai,ait:ar_int;
ai1,ai2:par_int;
begin
  i1:=shrr(i,1);
  j1:=shrr(j,1);
  k1:=shrr(k,1)+3;
  l1:=shrr(l,1)+3;
  ai:=parent.getInts(i1, j1, k1, l1);
  ai1:=getIntCache(k1 * 2 * (l1 * 2));
  i2:=shll(k1,1);
  for j2:=0 to l1-2 do
  begin
    k2:=shll(j2,1);
    i3:=k2 * i2;
    j3:=ai[0 + (j2 + 0) * k1];
    k3:=ai[0 + (j2 + 1) * k1];
    for l3:=0 to k1-2 do
    begin
      initChunkSeed(shll(l3+i1,1), shll(j2 + j1,1));
      i4:=ai[l3 + 1 + (j2 + 0) * k1];
      j4:=ai[l3 + 1 + (j2 + 1) * k1];
      ai1^[i3]:=j3;
      ai1^[i3 + i2]:=choose(j3, k3);
      inc(i3);
      ai1^[i3]:=choose(j3, i4);
      ai1^[i3 + i2]:=choose(j3, i4, k3, j4);
      inc(i3);
      j3:=i4;
      k3:=j4;
    end;
  end;

  setlength(ait,length(ai1^));
  move(ai1^[0],ait[0],length(ai1^)*sizeof(integer));

  ai2:=getIntCache(k * l);
  for l2:=0 to l-1 do
    //System.arraycopy(ai1, (l2 + (j & 1)) * (k1 << 1) + (i & 1), ai2, l2 * k, k);
    //move(ai1^[(l2 + (j and 1)) * (shll(k1,1)) + (i and 1)],ai2^[l2 * k],k*sizeof(integer));
    move(ait[(l2 + (j and 1)) * (shll(k1,1)) + (i and 1)],ai2^[l2 * k],k*sizeof(integer));

  setlength(ait,0);

  result:=ai2^;
end;

end.

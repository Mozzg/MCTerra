unit WorldGenBigTree_u;

interface

uses WorldGenerator_u,RandomMCT,generation_obsh;

type  WorldGenBigTree=class(WorldGenerator)
      private
        rr:rnd;
        basepos:array[0..2] of integer;
        otherCoordPairs:array[0..5] of byte;
        heightLimit,height,trunkSize,heightLimitLimit,leafDistanceLimit:integer;
        leafNodes:array of array of integer;
        field_874_i,field_873_j,field_872_k,heightAttenuation:extended;
        function validTreeLocation(map:region; xreg,yreg:integer):boolean;
        function checkBlockLine(map:region; xreg,yreg:integer; ai,ai1:array of integer):integer;
        procedure generateLeafNodeList(map:region; xreg,yreg:integer);
        function func_528_a(i:integer):double;
        function func_526_b(i:integer):double;
        procedure func_523_a(map:region; xreg,yreg,i,j,k:integer; f:double; byte0:byte; l:integer);
        procedure generateLeaves(map:region; xreg,yreg:integer);
        procedure generateLeafNode(map:region; xreg,yreg,i,j,k:integer);
        procedure placeBlockLine(map:region; xreg,yreg:integer; ai,ai1:array of integer; i:integer);
        procedure generateTrunk(map:region; xreg,yreg:integer);
        function leafNodeNeedsBase(i:integer):boolean;
        procedure generateLeafNodeBases(map:region;xreg,yreg:integer);
      public
        constructor Create; override;
        destructor Destroy; override;
        function generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean; override;
        procedure func_517_a(d,d1,d2:double); override;
      end;

implementation

uses math,generation_spec;

constructor WorldGenBigTree.Create;
begin
  rr:=rnd.Create;
  heightLimit:=0;
  heightAttenuation:=0.61799999999999999;
  field_874_i:=0.38100000000000001;
  field_873_j:=1;
  field_872_k:=1;
  trunkSize:=1;
  heightLimitLimit:=12;
  leafDistanceLimit:=4;
end;

destructor WorldGenBigTree.Destroy;
var i:integer;
begin
  rr.Free;

  for i:=0 to length(leafNodes)-1 do
    setlength(leafNodes[i],0);
  setlength(leafNodes,0);
end;

procedure WorldGenBigTree.func_517_a(d,d1,d2:double);
begin
  heightLimitLimit:=trunc(d*12);
  if d>0.5 then leafDistanceLimit:=5;
  field_873_j:=d1;
  field_872_k:=d2;
end;

function WorldGenBigTree.leafNodeNeedsBase(i:integer):boolean;
begin
  result:=(i>=(heightLimit * 0.20000000000000001));
end;

procedure WorldGenBigTree.generateLeafNodeBases(map:region;xreg,yreg:integer);
var i:integer;
ai,ai2:array[0..2]of integer;
begin
  for i:=0 to 2 do
    ai[i]:=basepos[i];

  for i:=0 to length(leafNodes)-1 do
  begin
    ai2[0]:=leafNodes[i][0];
    ai2[1]:=leafNodes[i][1];
    ai2[2]:=leafNodes[i][2];

    ai[1]:=leafNodes[i][3];
    if leafNodeNeedsBase(ai[1]-basePos[1]) then placeBlockLine(map,xreg,yreg,ai,ai2,17);
  end;
end;

procedure WorldGenBigTree.placeBlockLine(map:region; xreg,yreg:integer; ai,ai1:array of integer; i:integer);
var ai2,ai3:array[0..2]of integer;
byte0,byte1,byte2:byte;
byte3,j,k:integer;
d,d1:double;
begin
  j:=0;
  for byte0:=0 to 2 do
  begin
    ai2[byte0]:=ai1[byte0]-ai[byte0];
    if abs(ai2[byte0])>abs(ai2[j]) then j:=byte0;
  end;

  if ai2[j]=0 then exit;

  byte1:=otherCoordPairs[j];
  byte2:=otherCoordPairs[j+3];
  if(ai2[j]>0) then byte3:=1
  else byte3:=-1;

  d:=ai2[byte1]/ai2[j];
  d1:=ai2[byte2]/ai2[j];

  k:=0;
  while k<>(ai2[j]+byte3) do
  begin
    ai3[j]:=trunc(ai[j]+k+0.5);
    ai3[byte1]:=trunc(ai[byte1]+k*d+0.5);
    ai3[byte2]:=trunc(ai[byte2]+k*d1+0.5);
    set_block_id(map,xreg,yreg,ai3[0],ai3[1],ai3[2],i);

    k:=k+byte3;
  end;
end;

procedure WorldGenBigTree.generateTrunk(map:region; xreg,yreg:integer);
var ai,ai1:array[0..2]of integer;
i,j,k,l:integer;
begin
  i:=basePos[0];
  j:=basePos[1];
  k:=basePos[1]+height;
  l:=basePos[2];

  ai[0]:=i;
  ai[1]:=j;
  ai[2]:=l;

  ai1[0]:=i;
  ai1[1]:=k;
  ai1[2]:=l;

  placeBlockLine(map,xreg,yreg,ai,ai1,17);

  if trunkSize=2 then
  begin
    inc(ai[0]);
    inc(ai1[0]);
    placeBlockLine(map,xreg,yreg,ai, ai1, 17);
    inc(ai[2]);
    inc(ai1[2]);
    placeBlockLine(map,xreg,yreg,ai, ai1, 17);
    dec(ai[0]);
    dec(ai1[0]);
    placeBlockLine(map,xreg,yreg,ai, ai1, 17);
  end;
end;

function WorldGenBigTree.func_528_a(i:integer):double;
var f,f1,f2:double;
begin
  if i<(heightlimit*0.29999999999999999) then
  begin
    result:=-1.618;
    exit;
  end;

  f:=heightlimit/2;
  f1:=heightlimit/2-i;
  if f1=0 then f2:=f
  else if abs(f1)>=f then f2:=0
  else f2:=sqrt(sqr(f)-sqr(f1));

  f2:=f2*0.5;
  result:=f2;
end;

procedure WorldGenBigTree.func_523_a(map:region; xreg,yreg,i,j,k:integer; f:double; byte0:byte; l:integer);
var i1,j1,l1,i2:integer;
byte1,byte2:byte;
ai,ai1:array[0..2]of integer;
d:extended;
begin
  i1:=trunc(f+0.61799999999999999);
  byte1:=otherCoordPairs[byte0];
  byte2:=otherCoordPairs[byte0+3];

  ai[0]:=i;
  ai[1]:=j;
  ai[2]:=k;

  ai1[0]:=0;
  ai1[1]:=0;
  ai1[2]:=0;

  j1:=-i1;
  ai1[byte0]:=ai[byte0];

  while j1<=i1 do
  begin
    ai1[byte1]:=ai[byte1]+j1;

    l1:=-i1;
    while l1<=i1 do
    begin
      d:=sqrt(sqr(abs(j1)+0.5)+sqr(abs(l1)+0.5));
      if d>f then inc(l1)
      else
      begin
        ai1[byte2]:=ai[byte2]+l1;
        i2:=get_block_id(map,xreg,yreg,ai1[0],ai1[1],ai1[2]);
        if (i2<>0)and(i2<>18) then inc(l1)
        else
        begin
          set_block_id(map,xreg,yreg,ai1[0],ai1[1],ai1[2],l);
          inc(l1);
        end;
      end;
    end;

    inc(j1);
  end;
end;

function WorldGenBigTree.func_526_b(i:integer):double;
begin
  if (i<0)or(i>leafDistanceLimit) then
  begin
    result:=-1;
    exit;
  end;

  if (i<>0)and(i<>(leafDistanceLimit-1)) then result:=3
  else result:=2;
end;

procedure WorldGenBigTree.generateLeafNode(map:region; xreg,yreg,i,j,k:integer);
var l:integer;
begin
  for l:=j to j+leafDistanceLimit-1 do
    func_523_a(map,xreg,yreg,i,l,k,func_526_b(l-j),1,18);
end;

procedure WorldGenBigTree.generateLeaves(map:region; xreg,yreg:integer);
var i:integer;
begin
  for i:=0 to length(leafNodes)-1 do
    generateLeafNode(map,xreg,yreg,leafNodes[i][0],leafNodes[i][1],leafNodes[i][2]);
end;

procedure WorldGenBigTree.generateLeafNodeList(map:region; xreg,yreg:integer);
var i,j,k,l,i1,j1,k1,l1:integer;
ai:array of array of integer;
ai1,ai2,ai3:array[0..2]of integer;
f,d1,d2,d4:double;
begin
  height:=trunc(heightlimit*heightAttenuation);
  if height>=heightlimit then height:=height-heightlimit;

  i:=trunc(1.3819999999999999+power((field_872_k*heightlimit)/13,2));
  if i<1 then i:=1;

  setlength(ai,i*heightlimit);
  for j:=0 to length(ai)-1 do
    setlength(ai[j],4);

  j:=(basepos[1]+heightlimit)-leafDistanceLimit;
  k:=1;
  l:=basepos[1]+height;
  i1:=j-basepos[1];
  ai[0][0]:=basepos[0];
  ai[0][1]:=j;
  ai[0][2]:=basepos[2];
  ai[0][3]:=l;
  dec(j);

  while i1>=0 do
  begin
    j1:=0;
    f:=func_528_a(i1);
    if f<0 then
    begin
      dec(j);
      dec(i1);
    end
    else
    begin
      while j1<i do
      begin
        d1:=field_873_j*(f*(rr.nextDouble+0.32800000000000001));
        d2:=rr.nextDouble*2*3.1415899999999999;

        k1:=round(d1*sin(d2)+basepos[0]+0.5);
        l1:=round(d1*cos(d2)+basepos[2]+0.5);

        ai1[0]:=k1;
        ai1[1]:=j;
        ai1[2]:=l1;

        ai2[0]:=k1;
        ai2[1]:=j+leafDistanceLimit;
        ai2[2]:=l1;

        if checkBlockLine(map,xreg,yreg,ai1,ai2)<>-1 then
        begin
          inc(j1);
          continue;
        end;

        ai3[0]:=basepos[0];
        ai3[1]:=basepos[1];
        ai3[2]:=basepos[2];

        d4:=sqrt(sqr(basepos[0]-ai1[0])+sqr(basepos[2]-ai1[2]))*field_874_i;

        if(ai1[1]-d4)>l then ai3[1]:=l
        else ai3[1]:=trunc(ai1[1]-d4);

        if checkBlockLine(map,xreg,yreg,ai3,ai1)=-1 then
        begin
          ai[k][0]:=k1;
          ai[k][1]:=j;
          ai[k][2]:=l1;
          ai[k][3]:=ai3[1];
          inc(k);
        end;

        inc(j1);
      end;
      dec(j);
      dec(i1);
    end;
  end;

  setlength(leafNodes,k);
  for j1:=0 to k-1 do
    setlength(leafNodes[j1],4);

  for j1:=0 to k-1 do
    for k1:=0 to 3 do
      leafNodes[j1][k1]:=ai[j1][k1];

  for j1:=0 to length(ai)-1 do
    setlength(ai[j1],0);
  setlength(ai,0);
end;

function WorldGenBigTree.checkBlockLine(map:region; xreg,yreg:integer; ai,ai1:array of integer):integer;
var ai2,ai3:array[0..2]of integer;
i,t,j,k,l,byte3:integer;
byte1,byte2:byte;
d,d1:double;
begin
  t:=0;
  for i:=0 to 2 do
  begin
    ai2[i]:=ai1[i]-ai[i];
    if abs(ai2[i])>abs(ai2[t]) then t:=i;
  end;

  if ai2[t]=0 then
  begin
    result:=-1;
    exit;
  end;

  byte1:=otherCoordPairs[t];
  byte2:=otherCoordPairs[t+3];
  if (ai2[t]>0) then byte3:=1 else byte3:=-1;

  d:=ai2[byte1]/ai2[t];
  d1:=ai2[byte2]/ai2[t];

  j:=0;
  k:=ai2[t]+byte3;

  repeat
    if j=k then break;

    ai3[t]:=ai[t]+j;
    ai3[byte1]:=round(ai[byte1]+j*d);
    ai3[byte2]:=round(ai[byte2]+j*d1);
    l:=get_block_id(map,xreg,yreg,ai3[0],ai3[1],ai3[2]);

    if(l<>0)and(l<>18) then break;
    j:=j+byte3;
  until false;

  if (j=k) then
    result:=-1
  else
    result:=abs(j);
end;

function WorldGenBigTree.validTreeLocation(map:region; xreg,yreg:integer):boolean;
var ai,ai1:array[0..2] of integer;
i:integer;
begin
  for i:=0 to 2 do
  begin
    ai[i]:=basepos[i];
    if i=1 then ai1[i]:=basepos[i]+heightlimit-1
    else ai1[i]:=basepos[i];
  end;
  i:=get_block_id(map,xreg,yreg,basepos[0],basepos[1]-1,basepos[2]);
  if (i<>2)and(i<>3) then
  begin
    result:=false;
    exit;
  end;
  i:=checkBlockLine(map,xreg,yreg,ai,ai1);

  if i=-1 then
  begin
    result:=true;
    exit;
  end;
  if (i<6) then
    result:=false
  else
  begin
    heightlimit:=i;
    result:=true;
  end;
end;

function WorldGenBigTree.generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean;
begin
  rr.SetSeed(r.nextLong);
  basepos[0]:=x;
  basepos[1]:=y;
  basepos[2]:=z;

  if heightlimit=0 then heightlimit:=5+r.nextInt(heightlimitlimit);

  if validTreeLocation(map,xreg,yreg)=false then
  begin
    result:=false;
    exit;
  end
  else
  begin
    generateLeafNodeList(map,xreg,yreg);
    generateLeaves(map,xreg,yreg);
    generateTrunk(map,xreg,yreg);
    generateLeafNodeBases(map,xreg,yreg);
    result:=true;
  end;
end;

end.

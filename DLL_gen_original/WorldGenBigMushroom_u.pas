unit WorldGenBigMushroom_u;

interface

uses WorldGenerator_u, generation, RandomMCT;

type WorldGenBigMushroom=class(WorldGenerator)
     private
       mushroomType:integer;
     public
       constructor Create(i:integer); overload;
       constructor Create; overload;
       function generate(xreg,yreg:integer; map:region; rand:rnd; i,j,k:integer):boolean; override;
     end;

implementation

constructor WorldGenBigMushroom.Create(i:integer);
begin
  mushroomType:=i;
end;

constructor WorldGenBigMushroom.Create;
begin
  mushroomType:=-1;
end;

function WorldGenBigMushroom.generate(xreg,yreg:integer; map:region; rand:rnd; i,j,k:integer):boolean;
var l,i1,j1,byte0,i2,l2,k3,k1,l1,t,j2,i3,l3,i4,j4,k2,j3:integer;
flag:boolean;
begin
  l:=rand.nextInt(2);
  if (mushroomType >= 0) then
    l:=mushroomType;
  i1:=rand.nextInt(3) + 4;
  flag:=true;
  if (j < 1)or(j + i1 + 1 > 128) then
  begin
    result:=false;
    exit;
  end;
  for j1:=j to j+1+i1 do
  begin
    byte0:=3;
    if (j1 = j)then byte0:=0;

    for i2:=i-byte0 to i+byte0 do
    begin
      if flag=false then break;
      for l2:=k-byte0 to k+byte0 do
      begin
        if (j1 >= 0)and(j1 < 128) then
        begin
          k3:=get_block_id(map,xreg,yreg,i2, j1, l2);
          if (k3 <> 0)and(k3 <> 18)then flag:=false;
        end
        else flag:=false;
      end;
    end;
  end;

  if not(flag) then
  begin
    result:=false;
    exit;
  end;

  k1:=get_block_id(map,xreg,yreg,i, j - 1, k);
  if (k1 <> 3)and(k1 <> 2)and(k1 <> 110) then
  begin
    result:=false;
    exit;
  end;
  t:=get_block_id(map,xreg,yreg,i,j,k);
  if (t<>0)and(t<>106)and(t<>78)then
  begin
    result:=false;
    exit;
  end;
  set_block_id(map,xreg,yreg,i, j - 1, k, 3);
  l1:=j + i1;
  if (l = 1)then l1:=(j + i1) - 3;

  for j2:=l1 to j+i1 do
  begin
    i3:=1;
    if (j2 < j + i1) then inc(i3);
    if (l = 0) then i3:=3;
    for l3:=i-i3 to i+i3 do
      for i4:=k-i3 to k+i3 do
      begin
        j4:=5;
        if (l3 = i - i3) then dec(j4);
        if (l3 = i + i3) then inc(j4);
        if (i4 = k - i3) then dec(j4,3);
        if (i4 = k + i3) then inc(j4,3);
        if (l = 0)or(j2 < j + i1) then
        begin
          if (((l3 = i - i3)or(l3 = i + i3))and((i4 = k - i3)or(i4 = k + i3))) then continue;
          if (l3 = i - (i3 - 1))and(i4 = k - i3)then j4:=1;
          if (l3 = i - i3)and(i4 = k - (i3 - 1))then j4:=1;
          if (l3 = i + (i3 - 1))and(i4 = k - i3)then j4:=3;
          if (l3 = i + i3)and(i4 = k - (i3 - 1))then j4:=3;
          if (l3 = i - (i3 - 1))and(i4 = k + i3)then j4:=7;
          if (l3 = i - i3)and(i4 = k + (i3 - 1))then j4:=7;
          if (l3 = i + (i3 - 1))and(i4 = k + i3)then j4:=9;
          if (l3 = i + i3)and(i4 = k + (i3 - 1))then j4:=9;
        end;
        if (j4 = 5)and(j2 < j + i1)then j4:=0;
        t:=get_block_id(map,xreg,yreg,l3, j2, i4);
        if ((j4 <> 0)or(j >= (j + i1) - 1))and(t in trans_bl)then
          set_block_id_data(map,xreg,yreg,l3, j2, i4, 99 + l, j4);
      end;
  end;

  for k2:=0 to i1-1 do
  begin
    j3:=get_block_id(map,xreg,yreg,i, j + k2, k);
    if (j3 in trans_bl) then
      set_block_id_data(map,xreg,yreg,i, j + k2, k, 99 + l, 10);
  end;

  result:=true;
end;

end.

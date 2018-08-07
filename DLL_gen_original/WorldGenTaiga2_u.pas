unit WorldGenTaiga2_u;

interface

uses WorldGenerator_u, generation, RandomMCT;

type WorldGenTaiga2=class(WorldGenerator)
     public
       function generate(xreg,yreg:integer; map:region; rand:rnd; i,j,k:integer):boolean; override;
     end;

implementation

function WorldGenTaiga2.generate(xreg,yreg:integer; map:region; rand:rnd; i,j,k:integer):boolean;
var l,i1,j1,k1,l1,j2,l2,j3,k3,i2,k2,i3,l3,j4,l4,j5,k5,l5,i4,k4,i5:integer;
flag,flag1:boolean;
begin
  l:=rand.nextInt(4) + 6;
  i1:=1 + rand.nextInt(2);
  j1:=l - i1;
  k1:=2 + rand.nextInt(2);
  flag:=true;
  if (j < 1)or(j + l + 1 > 128)then
  begin
    result:=false;
    exit;
  end;
  for l1:=j to j+1+l do
  begin
    if flag=false then break;
    j2:=1;
    if (l1 - j < i1) then j2:=0
    else j2:=k1;
    for l2:=i-j2 to i+j2 do
    begin
      if flag=false then break;
      for j3:=k-j2 to k+j2 do
      begin
        if flag=false then break;
        if (l1 >= 0)and(l1 < 128)then
        begin
          k3:=get_block_id(map,xreg,yreg,l2, l1, j3);
          if (k3 <> 0)and(k3 <> 18) then flag:=false;
        end
        else flag:=false;
      end;
    end;
  end;

  if flag=false then
  begin
    result:=false;
    exit;
  end;
  i2:=get_block_id(map,xreg,yreg,i, j - 1, k);
  if (i2 <> 2)and(i2 <> 3)or(j >= 128 - l - 1) then
  begin
    result:=false;
    exit;
  end;
  set_block_id(map,xreg,yreg,i, j - 1, k, 3);
  k2:=rand.nextInt(2);
  i3:=1;
  flag1:=false;

  for l3:=0 to j1 do
  begin
    j4:=(j + l) - l3;
    for l4:=i-k2 to i+k2 do
    begin
      j5:=l4 - i;
      for k5:=k-k2 to k+k2 do
      begin
        l5:=k5 - k;
        if (((abs(j5) <> k2)or(abs(l5) <> k2)or(k2 <= 0))and(get_block_id(map,xreg,yreg,l4, j4, k5)in trans_bl))then
          set_block_id_data(map,xreg,yreg, l4, j4, k5, 18, 1);
      end;
    end;

    if (k2 >= i3)then
    begin
      if flag1 then k2:=1
      else k2:=0;
      flag1:=true;
      inc(i3);
      if (i3 > k1) then i3:=k1;
    end
    else inc(k2);
  end;

  i4:=rand.nextInt(3);
  for k4:=0 to l-i4-1 do
  begin
    i5:=get_block_id(map,xreg,yreg,i, j + k4, k);
    if (i5 = 0)or(i5 = 18) then
      set_block_id_data(map,xreg,yreg, i, j + k4, k, 17, 1);
  end;

  result:=true;
end;

end.

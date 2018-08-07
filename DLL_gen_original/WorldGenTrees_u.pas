unit WorldGenTrees_u;

interface

uses WorldGenerator_u, generation, RandomMCT;

type WorldGenTrees=class(WorldGenerator)
     public
       function generate(xreg,yreg:integer; map:region; rand:rnd; i,j,k:integer):boolean; override;
     end;

implementation

function WorldGenTrees.generate(xreg,yreg:integer; map:region; rand:rnd; i,j,k:integer):boolean;
var l,i1,i2,l2,j3,byte0,j1,k1,j2,i3,k3,l3,i4,j4,l1,k2:integer;
flag:boolean;
begin
  l:=rand.nextInt(3) + 4;
  flag:=true;
  if (j < 1)or(j + l + 1 > 128)then
  begin
    result:=false;
    exit;
  end;
  for i1:=j to j+1+l do
  begin
    byte0:=1;
    if (i1 = j)then byte0:=0;
    if (i1 >= (j + 1 + l) - 2)then byte0:=2;
    for i2:=i-byte0 to i+byte0 do
    begin
      if flag=false then break;
      for l2:=k-byte0 to k+byte0 do
      begin
        if flag=false then break;
        if (i1 >= 0)and(i1 < 128) then
        begin
          j3:=get_block_id(map,xreg,yreg,i2, i1, l2);
          if (j3 <> 0)and(j3 <> 18) then flag:=false;
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

  j1:=get_block_id(map,xreg,yreg,i, j - 1, k);
  if ((j1 <> 2)and(j1 <> 3))or(j >= 128 - l - 1)then
  begin
    result:=false;
    exit;
  end;
  set_block_id(map,xreg,yreg,i, j - 1, k, 3);
  for k1:=(j-3)+l to j+l do
  begin
    j2:=k1 - (j + l);
    i3:=1 - j2 div 2;
    for k3:=i-i3 to i+i3 do
    begin
      l3:=k3 - i;
      for i4:=k-i3 to k+i3 do
      begin
        j4:=i4 - k;
        if (((abs(l3) <> i3)or(abs(j4) <> i3)or(rand.nextInt(2) <> 0)and(j2 <> 0)) and (get_block_id(map,xreg,yreg,k3, k1, i4)in trans_bl)) then
          set_block_id_data(map,xreg,yreg, k3, k1, i4, 18, 0);
      end;
    end;
  end;

  for l1:=0 to l-1 do
  begin
    k2:=get_block_id(map,xreg,yreg,i, j + l1, k);
    if (k2 = 0)or(k2 = 18) then
      set_block_id_data(map,xreg,yreg, i, j + l1, k, 17, 0);
  end;

  result:=true;
end;

end.

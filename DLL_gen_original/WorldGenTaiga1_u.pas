unit WorldGenTaiga1_u;

interface

uses WorldGenerator_u, generation, RandomMCT;

type WorldGenTaiga1=class(WorldGenerator)
     public
       function generate(xreg,yreg:integer; map:region; rand:rnd; i,j,k:integer):boolean; override;
     end;

implementation

function WorldGenTaiga1.generate(xreg,yreg:integer; map:region; rand:rnd; i,j,k:integer):boolean;
var l,i1,j1,k1,l1,j2,l2,k3,j4,i2,k2,i3,l3,k4,l4,i5,j3,i4:integer;
flag:boolean;
begin
  l:=rand.nextInt(5) + 7;
  i1:=l - rand.nextInt(2) - 3;
  j1:=l - i1;
  k1:=1 + rand.nextInt(j1 + 1);
  flag:=true;
  if (j < 1)or(j + l + 1 > 128) then
  begin
    result:=false;
    exit;
  end;
  for l1:=j to j+1+l do
  begin
    if flag=false then break;
    j2:= 1;
    if (l1 - j < i1)then j2:=0
    else j2:=k1;
    for l2:=i-j2 to i+j2 do
    begin
      if flag=false then break;
      for k3:=k-j2 to k+j2 do
      begin
        if flag=false then break;
        if (l1 >= 0)and(l1 < 128)then
        begin
          j4:=get_block_id(map,xreg,yreg,l2, l1, k3);
          if (j4 <> 0)and(j4 <> 18)then
            flag:=false;
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
  if (i2 <> 2)and(i2 <> 3)or(j >= 128 - l - 1)then
  begin
    result:=false;
    exit;
  end;
  set_block_id(map,xreg,yreg,i, j - 1, k, 3);
  k2:=0;

  for i3:=j+l downto j+i1 do
  begin
    for l3:=i-k2 to i+k2 do
    begin
      k4:=l3 - i;
      for l4:=k-k2 to k+k2 do
      begin
        i5:=l4 - k;
        if (((abs(k4) <> k2)or(abs(i5) <> k2)or(k2 <= 0))and(get_block_id(map,xreg,yreg,l3, i3, l4)in trans_bl)) then
          set_block_id_data(map,xreg,yreg,l3, i3, l4, 18, 1);
      end;
    end;

    if (k2 >= 1)and(i3 = j + i1 + 1)then
    begin
      dec(k2);
      continue;
    end;
    if (k2 < k1) then inc(k2);
  end;

  for j3:=0 to l-2 do
  begin
    i4:=get_block_id(map,xreg,yreg,i, j + j3, k);
    if (i4 = 0)or(i4 = 18) then
      set_block_id_data(map,xreg,yreg,i, j + j3, k, 17, 1);  
  end;

  result:=true;
end;

end.

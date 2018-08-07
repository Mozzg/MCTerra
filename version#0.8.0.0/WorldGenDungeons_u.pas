unit WorldGenDungeons_u;

interface

uses WorldGenerator_u, generation_obsh, RandomMCT;

type  WorldGenDungeons=class(WorldGenerator)
      private
        function pickCheckLootItem(rand:Rnd):integer;
        function pickMobSpawner(rand:Rnd):string;
      public
        constructor Create; override;
        function generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean; override;
      end;

implementation

uses generation_spec;

constructor WorldGenDungeons.Create;
begin
end;

function WorldGenDungeons.generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean;
var byte0:byte;
i,j,k,l,i1,j1,k1,j2,i3,t,l1,k2,j3,i2,l2,k3,l3,i4,j4,k4:integer;
label label0;
begin
  i:=x;
  j:=y;
  k:=z;
  byte0:=3;
  l:= r.nextInt(2) + 2;
  i1:= r.nextInt(2) + 2;
  j1:= 0;
  for k1:=i-l-1 to i+l+1 do
    for j2:=j-1 to j+byte0+1 do
      for i3:=k-i1-1 to k+i1+1 do
      begin
        t:=get_block_id(map,xreg,yreg,k1, j2, i3);
        if(j2 = j - 1)and(not(t in solid_bl)) then
        begin
          result:=false;
          exit;
        end;
        if(j2 = j + byte0 + 1)and(not(t in solid_bl)) then
        begin
          result:=false;
          exit;
        end;
        if((k1 = i - l - 1)or(k1 = i + l + 1)or(i3 = k - i1 - 1)or(i3 = k + i1 + 1))and(j2 = j)and(get_block_id(map,xreg,yreg,k1, j2, i3)=0)and(get_block_id(map,xreg,yreg,k1, j2 + 1, i3)=0)then
          inc(j1);
      end;

  if (j1<1)or(j1>5) then
  begin
    result:=false;
    exit;
  end;

  for l1:=i-l-1 to i+l+1 do
    for k2:=j+byte0 downto j-1 do
      for j3:=k-i1-1 to k+i1+1 do
        if(l1 = i - l - 1)or(k2 = j - 1)or(j3 = k - i1 - 1)or(l1 = i + l + 1)or(k2 = j + byte0 + 1)or(j3 = k + i1 + 1) then
        begin
          if(k2 >= 0)and(not(get_Block_id(map,xreg,yreg,l1, k2 - 1, j3) in solid_bl))then
          begin
            set_block_id(map,xreg,yreg,l1, k2, j3, 0);
            continue;
          end;
          if(not(get_Block_id(map,xreg,yreg,l1, k2, j3) in solid_bl)) then
            continue;
          if(k2 = j - 1)and(r.nextInt(4) <> 0) then
            set_block_id(map,xreg,yreg,l1, k2, j3, 48)
          else
            set_block_id(map,xreg,yreg,l1, k2, j3, 4);
        end
        else
          set_block_id(map,xreg,yreg,l1, k2, j3, 0);

  for i2:=0 to 1 do
  begin
    for l2:=0 to 2 do
    begin
      k3:= (i + r.nextInt(l * 2 + 1)) - l;
      l3:= j;
      i4:= (k + r.nextInt(i1 * 2 + 1)) - i1;
      if(not(get_block_id(map,xreg,yreg,k3, l3, i4)=0)) then continue;
      j4:= 0;
      if(get_block_id(map,xreg,yreg,k3 - 1, l3, i4) in solid_bl) then inc(j4);
      if(get_block_id(map,xreg,yreg,k3 + 1, l3, i4) in solid_bl) then inc(j4);
      if(get_block_id(map,xreg,yreg,k3, l3, i4-1) in solid_bl) then inc(j4);
      if(get_block_id(map,xreg,yreg,k3, l3, i4+1) in solid_bl) then inc(j4);
      if(j4<>1) then continue;

      set_block_id(map,xreg,yreg,k3, l3, i4,50);

      k4:=0;
      repeat
        if(k4 >= 8) then goto label0;
        pickCheckLootItem(r);
        //if(itemstack != null)
          r.nextInt(27);
        inc(k4);
      until false;
    end;
  label0:
  end;

  set_block_id(map,xreg,yreg,i, j, k,30);
  pickMobSpawner(r);

  result:=true;
end;

function WorldGenDungeons.pickCheckLootItem(rand:Rnd):integer;
var i:integer;
begin
  i:=rand.nextInt(11);

  if(i = 0) then
  begin
    result:=0;
    exit;
  end;
  if(i = 1) then
  begin
    result:=rand.nextint(4)+1;
    exit;
  end;
  if(i = 2) then
  begin
    result:=0;
    exit;
  end;
  if(i = 3) then
  begin
    result:=rand.nextint(4)+1;
    exit;
  end;
  if(i = 4) then
  begin
    result:=rand.nextint(4)+1;
    exit;
  end;
  if(i = 5) then
  begin
    result:=rand.nextint(4)+1;
    exit;
  end;
  if(i = 6) then
  begin
    result:=0;
    exit;
  end;
  if(i = 7)and(rand.nextInt(100) = 0) then
  begin
    result:=0;
    exit;
  end;
  if(i = 8)and(rand.nextInt(2) = 0) then
  begin
    result:=rand.nextint(4)+1;
    exit;
  end;
  if(i = 9)and(rand.nextInt(10) = 0) then
  begin
    result:=rand.nextint(2);
    exit;
  end;
  if(i = 10) then
    result:=0
  else
    result:=0;

  //result:=0;
end;

function WorldGenDungeons.pickMobSpawner(rand:Rnd):string;
var i:integer;
begin
  i:=rand.nextInt(4);

  if(i=0) then
  begin
    result:='Skeleton';
    exit;
  end;
  if(i=1) then
  begin
    result:='Zombie';
    exit;
  end;
  if(i=2) then
  begin
    result:='Zombie';
    exit;
  end;
  if(i=3) then
    result:='Spider'
  else
    result:='';
end;

end.

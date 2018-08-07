unit WorldGenLakes_u;

interface

uses WorldGenerator_u, generation_obsh, RandomMCT, WorldChunkManager_u;

type  WorldGenLakes=class(WorldGenerator)
      private
        blockIndex:integer;
        manager:WorldChunkManager;
      public
        constructor Create(i:integer; man:WorldChunkManager); reintroduce;
        function generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean; override;
      end;

implementation

uses generation_spec, BiomeGenBase_u;

function temp_func_genlakes(map:region; xreg,yreg,i,j,k:integer; man:WorldChunkManager):boolean;
var f:extended;
l:integer;
begin
  f:=man.func_35554_b(i, j, k);
  if f>0.15 then
  begin
    result:=false;
    exit;
  end;

  if(j >= 0)and(j < 128)and(get_blocklight(map,xreg,yreg, i, j, k) < 10) then
  begin
    l:=get_block_id(map,xreg,yreg,i,j,k);
    if(((l = 8)or(l = 9)) and (get_Block_data(map,xreg,yreg,i, j, k) = 0)) then
    begin
      result:=true;
      exit;
    end;
  end;
  result:=false;
end;

constructor WorldGenLakes.Create(i:integer; man:WorldChunkManager);
begin
  blockIndex:=i;
  manager:=man;
end;

function WorldGenLakes.generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean;
var aflag:array of boolean;
l,i1,l4,i5,j5,j1,k2,l3,k1,l2,i4,l1,i3,j4,i2,j3,k4,j2,k3,t:integer;
d,d1,d2,d3,d4,d5,d6,d7,d8,d9:extended;
flag,flag1:boolean;
genbase:BiomeGenBase;
byte0:byte;
begin
  setlength(aflag,2048);
  x:=x-8;
  z:=z-8;
  while (y>0)and(get_block_id(map,xreg,yreg,x,y,z)=0) do
    dec(y);
  y:=y-4;
  l:=r.nextInt(4)+4;
  for i1:=0 to l-1 do
  begin
    d:= r.nextDouble * 6 + 3;
    d1:= r.nextDouble * 4 + 2;
    d2:= r.nextDouble * 6 + 3;
    d3:= r.nextDouble * (16 - d - 2) + 1 + d / 2;
    d4:= r.nextDouble * (8 - d1 - 4) + 2 + d1 / 2;
    d5:= r.nextDouble * (16 - d2 - 2) + 1 + d2 / 2;
    for l4:=1 to 14 do
      for i5:=1 to 14 do
        for j5:=1 to 6 do
        begin
          d6:= (l4 - d3) / (d / 2);
          d7:= (j5 - d4) / (d1 / 2);
          d8:= (i5 - d5) / (d2 / 2);
          d9:= d6 * d6 + d7 * d7 + d8 * d8;
          if(d9 < 1) then aflag[(l4 * 16 + i5) * 8 + j5]:= true;
        end;
  end;

  for j1:=0 to 15 do
    for k2:=0 to 15 do
      for l3:=0 to 7 do
      begin
        flag:= not(aflag[(j1 * 16 + k2) * 8 + l3])and(((j1 < 15) and aflag[((j1 + 1) * 16 + k2) * 8 + l3]) or ((j1 > 0) and aflag[((j1 - 1) * 16 + k2) * 8 + l3])or((k2 < 15) and aflag[(j1 * 16 + (k2 + 1)) * 8 + l3])or((k2 > 0) and aflag[(j1 * 16 + (k2 - 1)) * 8 + l3])or((l3 < 7) and aflag[(j1 * 16 + k2) * 8 + (l3 + 1)])or((l3 > 0) and aflag[(j1 * 16 + k2) * 8 + (l3 - 1)]));
        if(not(flag)) then continue;
        t:=get_block_id(map,xreg,yreg,x + j1, y + l3, z + k2);
        //Material material = world.getBlockMaterial(i + j1, j + l3, k + k2);
        if(l3 >= 4 )and((t=8)or(t=9)or(t=10)or(t=11)) then
        begin
          result:=false;
          setlength(aflag,0);
          exit;
        end;
        if(l3 < 4)and(not(t in solid_bl))and(get_Block_Id(map,xreg,yreg,x + j1, y + l3, z + k2) <> blockIndex) then
        begin
          result:=false;
          setlength(aflag,0);
          exit;
        end;
      end;

  for k1:=0 to 15 do
    for l2:=0 to 15 do
      for i4:=0 to 7 do
        if(aflag[(k1 * 16 + l2) * 8 + i4]) then
        begin
          if i4<4 then set_block_id(map,xreg,yreg,x + k1, y + i4, z + l2,blockIndex)
          else set_block_id(map,xreg,yreg,x + k1, y + i4, z + l2,0);
        end;

  for l1:=0 to 15 do
    for i3:=0 to 15 do
      for j4:=4 to 7 do
      begin
        if(not(aflag[(l1 * 16 + i3) * 8 + j4]))or(get_Block_Id(map,xreg,yreg,x + l1, (y + j4) - 1, z + i3) <> 3)or(get_skylight(map,xreg,yreg, x + l1, y + j4, z + i3)  <= 0) then
          continue;
        genbase:=manager.getBiomeGenAt(x + l1, z + i3);
        if(genbase.topBlock = 110) then
          set_block_id(map,xreg,yreg,x + l1, (y + j4) - 1, z + i3, 110)
        else
          set_block_id(map,xreg,yreg,x + l1, (y + j4) - 1, z + i3, 2);
      end;

  if (blockIndex=10)or(blockIndex=11) then
    for i2:=0 to 15 do
      for j3:=0 to 15 do
        for k4:=0 to 7 do
        begin
          flag1:=(not(aflag[(i2 * 16 + j3) * 8 + k4]))and((i2 < 15) and aflag[((i2 + 1) * 16 + j3) * 8 + k4])or((i2 > 0) and aflag[((i2 - 1) * 16 + j3) * 8 + k4])or((j3 < 15) and aflag[(i2 * 16 + (j3 + 1)) * 8 + k4])or((j3 > 0) and aflag[(i2 * 16 + (j3 - 1)) * 8 + k4])or((k4 < 7) and aflag[(i2 * 16 + j3) * 8 + (k4 + 1)])or((k4 > 0) and aflag[(i2 * 16 + j3) * 8 + (k4 - 1)]);
          if(flag1)and((k4 < 4) or (r.nextInt(2) <> 0)) and (get_block_id(map,xreg,yreg,x + i2, y + k4, z + j3) in solid_bl) then
            set_block_id(map,xreg,yreg,x + i2, y + k4, z + j3, 1);
        end;

  if (blockIndex=8)or(blockIndex=9) then
    for j2:=0 to 15 do
      for k3:=0 to 15 do
      begin
        byte0:=4;
        if(temp_func_genlakes(map,xreg,yreg,x + j2, y + byte0, z + k3,manager)) then
          set_block_id(map,xreg,yreg,x + j2, y + byte0, z + k3, 79);
      end;

  setlength(aflag,0);
  result:=true;
end;

end.

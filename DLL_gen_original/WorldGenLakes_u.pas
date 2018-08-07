unit WorldGenLakes_u;

interface

uses WorldGenerator_u, generation, RandomMCT, WorldChunkManager_u;

type WorldGenLakes=class(WorldGenerator)
     private
       blockIndex:integer;
       manager_save:WorldChunkManager;
       function func_40471_p(map:region; xreg,yreg,i,j,k:integer):boolean;
     public
       constructor Create(i:integer; man:WorldChunkManager);
       function generate(xreg,yreg:integer; map:region; rand:rnd; i,j,k:integer):boolean; override;
     end;

implementation

uses BiomeGenBase_u;

constructor WorldGenLakes.Create(i:integer; man:WorldChunkManager);
begin
  blockIndex:=i;
  manager_save:=man;
end;

function WorldGenLakes.func_40471_p(map:region; xreg,yreg,i,j,k:integer):boolean;
var f:double;
t:integer;
begin
  f:=manager_save.getTemperature(i, j, k);
  if f>0.15 then
  begin
    result:=false;
    exit;
  end;

  t:=get_block_id(map,xreg,yreg,i,j,k);
  if (t=8)or(t=9) then result:=true
  else result:=false;
end;

function WorldGenLakes.generate(xreg,yreg:integer; map:region; rand:rnd; i,j,k:integer):boolean;
var l,i1,l4,i5,j5,j1,k2,l3,t,k1,l2,i4,l1,i3,j4,i2,j3,k4,j2,k3,byte0:integer;
aflag:ar_boolean;
d,d1,d2,d3,d4,d5,d6,d7,d8,d9:double;
flag,flag1,tf:boolean;
genbase:BiomeGenBase;
begin
  i:=i-8;
  k:=k-8;
  while (j>0)and(get_block_id(map,xreg,yreg,i,j,k)=0) do
    dec(j);
  j:=j-4;
  setlength(aflag,2048);
  l:=rand.nextInt(4) + 4;

  for i1:=0 to l-1 do
  begin
    d:=rand.nextDouble() * 6 + 3;
    d1:=rand.nextDouble() * 4 + 2;
    d2:=rand.nextDouble() * 6 + 3;
    d3:=rand.nextDouble() * (16 - d - 2) + 1 + d / 2;
    d4:=rand.nextDouble() * (8 - d1 - 4) + 2 + d1 / 2;
    d5:=rand.nextDouble() * (16 - d2 - 2) + 1 + d2 / 2;
    for l4:=1 to 14 do
      for i5:=1 to 14 do
        for j5:=1 to 6 do
        begin
          d6:=(l4 - d3) / (d / 2);
          d7:=(j5 - d4) / (d1 / 2);
          d8:=(i5 - d5) / (d2 / 2);
          d9:=d6 * d6 + d7 * d7 + d8 * d8;
          if (d9 < 1)then aflag[(l4 * 16 + i5) * 8 + j5]:=true;
        end;
  end;

  for j1:=0 to 15 do
    for k2:=0 to 15 do
      for l3:=0 to 7 do
      begin
        //?????????????
        //flag:=not(aflag[(j1 * 16 + k2) * 8 + l3])and((j1 < 15) and aflag[((j1 + 1) * 16 + k2) * 8 + l3] or (j1 > 0) and aflag[((j1 - 1) * 16 + k2) * 8 + l3] or (k2 < 15) and aflag[(j1 * 16 + (k2 + 1)) * 8 + l3] or (k2 > 0) and aflag[(j1 * 16 + (k2 - 1)) * 8 + l3] or (l3 < 7) and aflag[(j1 * 16 + k2) * 8 + (l3 + 1)] or (l3 > 0) and aflag[(j1 * 16 + k2) * 8 + (l3 - 1)]);
        flag:=not(aflag[(j1 * 16 + k2) * 8 + l3]);
        if (j1<15) then tf:=aflag[((j1 + 1) * 16 + k2) * 8 + l3]
        else tf:=false;
        if j1>0 then tf:=tf or aflag[((j1 - 1) * 16 + k2) * 8 + l3];
        if k2<15 then tf:=tf or aflag[(j1 * 16 + (k2 + 1)) * 8 + l3];
        if k2>0 then tf:=tf or aflag[(j1 * 16 + (k2 - 1)) * 8 + l3];
        if l3<7 then tf:=tf or aflag[(j1 * 16 + k2) * 8 + (l3 + 1)];
        if l3>0 then tf:=tf or aflag[(j1 * 16 + k2) * 8 + (l3 - 1)];

        flag:=flag and tf;
        //flag:= not(aflag[(j1 * 16 + k2) * 8 + l3])and(((j1 < 15) and aflag[((j1 + 1) * 16 + k2) * 8 + l3]) or ((j1 > 0) and aflag[((j1 - 1) * 16 + k2) * 8 + l3])or((k2 < 15) and aflag[(j1 * 16 + (k2 + 1)) * 8 + l3])or((k2 > 0) and aflag[(j1 * 16 + (k2 - 1)) * 8 + l3])or((l3 < 7) and aflag[(j1 * 16 + k2) * 8 + (l3 + 1)])or((l3 > 0) and aflag[(j1 * 16 + k2) * 8 + (l3 - 1)]));
        if not(flag)then continue;
        t:=get_block_id(map,xreg,yreg,i + j1, j + l3, k + k2);
        if (l3 >= 4)and((t=8)or(t=9))then
        begin
          setlength(aflag,0);
          result:=false;
          exit;
        end;
        if (l3 < 4)and(not(t in solid_bl))and(t <> blockIndex)then
        begin
          setlength(aflag,0);
          result:=false;
          exit;
        end;
      end;

  for k1:=0 to 15 do
    for l2:=0 to 15 do
      for i4:=0 to 7 do
      begin
        if (aflag[(k1 * 16 + l2) * 8 + i4])then
          if i4<4 then set_block_id(map,xreg,yreg,i + k1, j + i4, k + l2,blockIndex)
          else set_block_id(map,xreg,yreg,i + k1, j + i4, k + l2,0);
      end;

  for l1:=0 to 15 do
    for i3:=0 to 15 do
      for j4:=4 to 7 do
      begin
        if ((not (aflag[(l1 * 16 + i3) * 8 + j4]))or(get_Block_Id(map,xreg,yreg,i + l1, (j + j4) - 1, k + i3) <> 3)) then
          continue;
        genbase:=manager_save.getBiomeGenAt(i + l1, k + i3);
        if (genbase.topBlock = 110) then
          set_block_id(map,xreg,yreg,i + l1, (j + j4) - 1, k + i3,110)
        else
          set_block_id(map,xreg,yreg,i + l1, (j + j4) - 1, k + i3,2);
      end;

  if (blockIndex=10)or(blockIndex=11) then
    for i2:=0 to 15 do
      for j3:=0 to 15 do
        for k4:=0 to 7 do
        begin
          //???????????????????????????
          //flag1:=not(aflag[(i2 * 16 + j3) * 8 + k4])and((i2 < 15)and aflag[((i2 + 1) * 16 + j3) * 8 + k4] or (i2 > 0)and aflag[((i2 - 1) * 16 + j3) * 8 + k4] or (j3 < 15)and aflag[(i2 * 16 + (j3 + 1)) * 8 + k4] or (j3 > 0)and aflag[(i2 * 16 + (j3 - 1)) * 8 + k4] or (k4 < 7)and aflag[(i2 * 16 + j3) * 8 + (k4 + 1)] or (k4 > 0)and aflag[(i2 * 16 + j3) * 8 + (k4 - 1)]);
          //flag1:=(not(aflag[(i2 * 16 + j3) * 8 + k4]))and((i2 < 15) and aflag[((i2 + 1) * 16 + j3) * 8 + k4])or((i2 > 0) and aflag[((i2 - 1) * 16 + j3) * 8 + k4])or((j3 < 15) and aflag[(i2 * 16 + (j3 + 1)) * 8 + k4])or((j3 > 0) and aflag[(i2 * 16 + (j3 - 1)) * 8 + k4])or((k4 < 7) and aflag[(i2 * 16 + j3) * 8 + (k4 + 1)])or((k4 > 0) and aflag[(i2 * 16 + j3) * 8 + (k4 - 1)]);
          flag1:=not(aflag[(i2 * 16 + j3) * 8 + k4]);
          if i2<15 then tf:=aflag[((i2 + 1) * 16 + j3) * 8 + k4]
          else tf:=false;
          if i2>0 then tf:=tf or aflag[((i2 - 1) * 16 + j3) * 8 + k4];
          if j3<15 then tf:=tf or aflag[(i2 * 16 + (j3 + 1)) * 8 + k4];
          if j3>0 then tf:=tf or aflag[(i2 * 16 + (j3 - 1)) * 8 + k4];
          if k4<7 then tf:=tf or aflag[(i2 * 16 + j3) * 8 + (k4 + 1)];
          if k4>0 then tf:=tf or aflag[(i2 * 16 + j3) * 8 + (k4 - 1)];

          flag1:=flag1 and tf;
          if (flag1)and((k4 < 4)or(rand.nextInt(2) <> 0)) and (get_block_id(map,xreg,yreg,i + i2, j + k4, k + j3)in solid_bl)then
            set_block_id(map,xreg,yreg,i + i2, j + k4, k + j3,1);
        end;

  if (blockIndex=8)or(blockIndex=9) then
    for j2:=0 to 15 do
      for k3:=0 to 15 do
      begin
        byte0:=4;
        if (func_40471_p(map,xreg,yreg,i + j2, j + byte0, k + k3))then
          set_block_id(map,xreg,yreg,i + j2, j + byte0, k + k3,79);
      end;

  setlength(aflag,0);
  result:=true;
end;

end.

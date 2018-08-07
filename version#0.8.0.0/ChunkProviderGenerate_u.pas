unit ChunkProviderGenerate_u;

interface

uses IChunkProvider_u, generation_obsh, NoiseGeneratorOctaves_u,
RandomMCT, BiomeGenBase_u, WorldChunkManager_u, NBT, MapGenBase_u,
MapGenCaves_u, MapGenRavine_u;

type  ChunkProviderGenerate=class(IChunkProvider)
      private
        rand:rnd;
        mapFeaturesEnabled:boolean;
        noiseGen1,noiseGen2,noiseGen3,noiseGen4,noiseGen5,
        noiseGen6:NoiseGeneratorOctaves;
        manager:WorldChunkManager;
        caveGenerator:MapGenCaves;
        ravineGenerator:MapGenRavine;
        field_4180_q,stoneNoise:ar_double;
        world_sid:int64;
        function initializeNoiseField(ad:ar_double; i,j,k,l,i1,j1:integer):ar_double;
      public
        noise1,noise2,noise3,noise5,noise6:ar_double;
        biomesForGeneration:ar_BiomeGenBase;
        field_35388_l:ar_double;
        constructor Create(l:int64; flag:boolean);
        destructor Destroy; reintroduce;
        function provideChunk(abyte:ar_type; i,j:integer):ar_BiomeGenBase; override;
        procedure generateTerrain(i,j:integer; abyte0:ar_type);
        procedure replaceBlocksForBiome(i,j:integer; abyte0:ar_type; abiomegenbase:ar_BiomeGenBase);
        procedure populate(map:region; xreg,yreg,i,j:integer); override;
        procedure Clear;
      end;

implementation

uses WorldGenLakes_u, generation_spec, WorldGenDungeons_u;

constructor ChunkProviderGenerate.Create(l:int64; flag:boolean);
begin
  mapFeaturesEnabled:=flag;
  rand:=rnd.Create(l);
  noiseGen1:=NoiseGeneratorOctaves.Create(rand, 16);
  noiseGen2:=NoiseGeneratorOctaves.Create(rand, 16);
  noiseGen3:=NoiseGeneratorOctaves.Create(rand, 8);
  noiseGen4:=NoiseGeneratorOctaves.Create(rand, 4);
  noiseGen5:=NoiseGeneratorOctaves.Create(rand, 10);
  noiseGen6:=NoiseGeneratorOctaves.Create(rand, 16);

  manager:=WorldChunkManager.Create(l);
  caveGenerator:=MapGenCaves.Create(manager);
  ravineGenerator:=MapGenRavine.Create(manager);

  world_sid:=l;
end;

destructor ChunkProviderGenerate.Destroy;
begin
  rand.Free;
  noiseGen1.Free;
  noiseGen2.Free;
  noiseGen3.Free;
  noiseGen4.Free;
  noiseGen5.Free;
  noiseGen6.Free;

  manager.Free;
  caveGenerator.Free;
  ravineGenerator.Free;

  setlength(noise1,0);
  setlength(noise2,0);
  setlength(noise3,0);
  setlength(noise5,0);
  setlength(noise6,0);
  setlength(stoneNoise,0);
end;

procedure ChunkProviderGenerate.generateTerrain(i,j:integer; abyte0:ar_type);
var byte0:byte;
k,l,i1,j1,k1,l1,i2,j2,k2,l2,i3,j3,k3:integer;
d,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,d15,d16:extended;
begin
  byte0:= 4;
  k:= 128 div 8;
  l:= 63;
  i1:= byte0 + 1;
  j1:= 128 div 8 + 1;
  k1:= byte0 + 1;
  biomesForGeneration:= manager.func_35557_b(biomesForGeneration, i * 4 - 2, j * 4 - 2, i1 + 5, k1 + 5);
  field_4180_q:=initializeNoiseField(field_4180_q, i * byte0, 0, j * byte0, i1, j1, k1);
  for l1:=0 to byte0-1 do
    for i2:=0 to byte0-1 do
      for j2:=0 to k-1 do
      begin
        d:= 0.125;
        d1:= field_4180_q[((l1 + 0) * k1 + (i2 + 0)) * j1 + (j2 + 0)];
        d2:= field_4180_q[((l1 + 0) * k1 + (i2 + 1)) * j1 + (j2 + 0)];
        d3:= field_4180_q[((l1 + 1) * k1 + (i2 + 0)) * j1 + (j2 + 0)];
        d4:= field_4180_q[((l1 + 1) * k1 + (i2 + 1)) * j1 + (j2 + 0)];
        d5:= (field_4180_q[((l1 + 0) * k1 + (i2 + 0)) * j1 + (j2 + 1)] - d1) * d;
        d6:= (field_4180_q[((l1 + 0) * k1 + (i2 + 1)) * j1 + (j2 + 1)] - d2) * d;
        d7:= (field_4180_q[((l1 + 1) * k1 + (i2 + 0)) * j1 + (j2 + 1)] - d3) * d;
        d8:= (field_4180_q[((l1 + 1) * k1 + (i2 + 1)) * j1 + (j2 + 1)] - d4) * d;
        for k2:=0 to 7 do
        begin
          d9:= 0.25;
          d10:= d1;
          d11:= d2;
          d12:= (d3 - d1) * d9;
          d13:= (d4 - d2) * d9;
          for l2:=0 to 3 do
          begin
            i3:= ((l2 + l1 * 4)shl 11)or((0 + i2 * 4)shl 7)or(j2 * 8 + k2);
            j3:= 1 shl 7;
            i3:=i3-j3;
            d14:=0.25;
            d15:=d10;
            d16:=(d11 - d10) * d14;
            d15:=d15-d16;
            for k3:=0 to 3 do
            begin
              d15:=d15+d16;
              if(d15 > 0) then
              begin
                i3:=i3+j3;
                abyte0[i3]:=1;
                continue;
              end;
              i3:=i3+j3;
              if((j2 * 8 + k2) < l) then
                abyte0[i3]:=9
              else
                abyte0[i3]:= 0;
            end;
            d10:=d10+d12;
            d11:=d11+d13;
          end;
          d1:=d1+d5;
          d2:=d2+d6;
          d3:=d3+d7;
          d4:=d4+d8;
        end;
      end;
end;

procedure ChunkProviderGenerate.replaceBlocksForBiome(i,j:integer; abyte0:ar_type; abiomegenbase:ar_BiomeGenBase);
var k,l,i1,j1,k1,l1,i2:integer;
d,f:extended;
af:ar_double;
byte0,byte1,byte2:byte;
genbase:BiomeGenBase;
begin
  k:=63;
  d:=0.03125;
  stoneNoise:=noiseGen4.generateNoiseOctaves(stoneNoise, i * 16, j * 16, 0, 16, 16, 1, d * 2, d * 2, d * 2,false);
  af:=manager.func_40539_b(i * 16, j * 16, 16, 16);
  for l:=0 to 15 do
    for i1:=0 to 15 do
    begin
      f:=af[i1 + l * 16];
      genbase:=abiomegenbase[i1 + l * 16];
      j1:=trunc(stoneNoise[l + i1 * 16] / 3 + 3 + rand.nextDouble * 0.25);
      k1:=-1;
      byte0:=genbase.topBlock;
      byte1:=genbase.fillerBlock;
      for l1:=127 downto 0 do
      begin
        i2:=(i1 * 16 + l) * 128 + l1;
        if l1<=rand.nextInt(5) then
        begin
          abyte0[i2]:=7;
          continue;
        end;
        byte2:=abyte0[i2];
        if byte2=0 then
        begin
          k1:=-1;
          continue;
        end;
        if byte2<>1 then continue;

        if k1=-1 then
        begin
          if j1<=0 then
          begin
            byte0:= 0;
            byte1:= 1;
          end
          else if (l1 >= k - 4) and (l1 <= k + 1) then
          begin
            byte0:= genbase.topBlock;
            byte1:= genbase.fillerBlock;
          end;
          if(l1 < k) and (byte0 = 0) then
          begin
            if(f < 0.15) then
              byte0:=79
            else
              byte0:=9;
          end;
          k1:=j1;
          if(l1 >= k - 1) then
            abyte0[i2]:= byte0
          else
            abyte0[i2]:= byte1;
          continue;
        end;
        if k1<=0 then continue;
        dec(k1);
        abyte0[i2]:=byte1;
        if(k1 = 0) and (byte1 = 12) then
        begin
          k1:= rand.nextInt(4);
          byte1:= 24;
        end;
      end;
    end;
end;

function ChunkProviderGenerate.provideChunk(abyte:ar_type; i,j:integer):ar_BiomeGenBase;
begin
  //delaem unikal'niy sid dla proceduri zapolneniya blokov dla bioma
  rand.SetSeed(i * $4f9939f508 + j * $1ef1565bd5);
  //generaciya landshafta
  generateTerrain(i,j,abyte);
  //todo:
  biomesForGeneration:=manager.loadBlockGeneratorData(biomesForGeneration, i * 16, j * 16, 16, 16);
  replaceBlocksForBiome(i, j, abyte, biomesForGeneration);
  caveGenerator.generate(Self,world_sid,i,j,abyte);
  ravineGenerator.generate(Self,world_sid,i,j,abyte);

  result:=biomesForGeneration;
end;

function ChunkProviderGenerate.initializeNoiseField(ad:ar_double; i,j,k,l,i1,j1:integer):ar_double;
var k1,l1:integer;
d,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,f1,f2,f3,f4:extended;
i2,j2,k2,l2,i3,j3,k3:integer;
genbase,genbase1:BiomeGenBase;
begin
  if length(ad)=0 then setlength(ad,l*i1*j1);

  if length(field_35388_l)=0 then
  begin
    setlength(field_35388_l,25);
    for k1:=-2 to 2 do
      for l1:=-2 to 2 do
        field_35388_l[k1 + 2 + (l1 + 2) * 5]:=10 / sqrt((k1 * k1 + l1 * l1) + 0.2);
  end;

  d:= 684.41200000000003;
  d1:= 684.41200000000003;
  noise5:= noiseGen5.func_4109_a(noise5, i, k, l, j1, 1.121, 1.121, 0.5);
  noise6:= noiseGen6.func_4109_a(noise6, i, k, l, j1, 200, 200, 0.5);
  noise3:= noiseGen3.generateNoiseOctaves(noise3, i, j, k, l, i1, j1, d / 80, d1 / 160, d / 80,false);
  noise1:= noiseGen1.generateNoiseOctaves(noise1, i, j, k, l, i1, j1, d, d1, d,false);
  noise2:= noiseGen2.generateNoiseOctaves(noise2, i, j, k, l, i1, j1, d, d1, d,false);
  i2:=0;
  j2:=0;
  for k2:=0 to l-1 do
    for l2:=0 to j1-1 do
    begin
      f1:=0;
      f2:=0;
      f3:=0;
      genbase:=biomesForGeneration[k2 + 2 + (l2 + 2) * (l + 5)];
      for i3:=-2 to 2 do
        for j3:=-2 to 2 do
        begin
          genbase1:= biomesForGeneration[k2 + i3 + 2 + (l2 + j3 + 2) * (l + 5)];
          f4:=field_35388_l[i3 + 2 + (j3 + 2) * 5] / (genbase1.minHeight + 2.0);
          if(genbase1.minHeight > genbase.minHeight) then f4:=f4/2;
          f1:=f1+genbase1.maxHeight * f4;
          f2:=f2+genbase1.minHeight * f4;
          f3:=f3+f4;
        end;
      f1:=f1/f3;
      f2:=f2/f3;
      f1:=f1 * 0.9 + 0.1;
      f2:= (f2 * 4 - 1) / 8;
      d2:= noise6[j2] / 8000;
      if d2<0 then d2:= -d2 * 0.29999999999999999;
      d2:= d2 * 3 - 2;
      if d2<0 then
      begin
        d2:=d2/2;
        if(d2 < -1) then d2:= -1;
        d2:=d2/ 1.3999999999999999;
        d2:=d2/ 2;
      end
      else
      begin
        if(d2 > 1) then d2:=1;
        d2:=d2/8;
      end;
      inc(j2);
      for k3:=0 to i1-1 do
      begin
        d3:= f2;
        d4:= f1;
        d3:=d3+(d2 * 0.20000000000000001);
        d3:= (d3 * i1) / 16;
        d5:= i1 / 2 + d3 * 4;
        d6:= 0;
        d7:= ((k3 - d5) * 12 * 128) / 128 / d4;
        if(d7 < 0) then d7:=d7*4;
        d8:= noise1[i2] / 512;
        d9:= noise2[i2] / 512;
        d10:= (noise3[i2] / 10 + 1) / 2;
        if(d10 < 0) then d6:= d8
        else if(d10 > 1) then d6:= d9
        else d6:= d8 + (d9 - d8) * d10;
        d6:=d6-d7;
        if(k3 > i1 - 4) then
        begin
          d11:= (k3 - (i1 - 4)) / 3;
          d6:= d6 * (1 - d11) + -10 * d11;
        end;
        ad[i2]:= d6;
        inc(i2);
      end;
    end;
  result:=ad;
end;

function func_40471_p(map:region; xreg,yreg,i,j,k:integer; man:WorldChunkManager):boolean;
var l:integer;
begin
  if man.func_35554_b(i, j, k)>0.15 then
  begin
    result:=false;
    exit;
  end;

  if(j >= 0)and(j < 128)and(get_blocklight(map,xreg,yreg, i, j, k) < 10) then
  begin
    l:=get_block_id(map,xreg,yreg,i, j, k);
    if(((l = 8) or (l = 9)) and (get_block_data(map,xreg,yreg,i, j, k) = 0)) then
    begin
      result:=true;
      exit;
    end;
  end;
  result:=false;
end;

function func_40478_r(map:region; xreg,yreg,i,j,k:integer; man:WorldChunkManager):boolean;
var l,i1:integer;
begin
  if man.func_35554_b(i, j, k)>0.15 then
  begin
    result:=false;
    exit;
  end;

  if(j >= 0)and(j < 128)and(get_blocklight(map,xreg,yreg, i, j, k) < 10) then
  begin
    l:= get_Block_Id(map,xreg,yreg,i, j - 1, k);
    i1:= get_Block_Id(map,xreg,yreg,i, j, k);
    if(i1 = 0)and(not(l in trans_bl))and(l<>0)and(l<>79)and(l in solid_bl) then
    begin
      result:=true;
      exit;
    end;
  end;
  result:=false;
end;

procedure ChunkProviderGenerate.populate(map:region; xreg,yreg,i,j:integer);
var k,l,i1,j2,k3,j1,k2,l3,k1,i3,i4,k4,i2,j3,j4,t,t1:integer;
l1,l2:int64;
genbase:BiomeGenBase;
flag:boolean;
lakes:WorldGenLakes;
dungGen:WorldGenDungeons;
begin
  k:= i * 16;
  l:= j * 16;
  genbase:= manager.getBiomeGenAt(k + 16, l + 16);
  rand.setSeed(world_sid);
  l1:= (rand.nextLong div 2) * 2 + 1;
  l2:= (rand.nextLong div 2) * 2 + 1;
  rand.setSeed((i * l1 + (j * l2)) xor world_sid);
  flag:= false; 

  if(not(flag))and(rand.nextInt(4) = 0) then
  begin
    lakes:=WorldGenLakes.Create(8,manager);
    i1:= k + rand.nextInt(16) + 8;
    j2:= rand.nextInt(128);
    k3:= l + rand.nextInt(16) + 8;
    lakes.generate(map,xreg,yreg,rand,i1, j2, k3);
    lakes.Free;
  end;

  if(not(flag))and(rand.nextInt(8) = 0) then
  begin
    lakes:=WorldGenLakes.Create(10,manager);
    j1:= k + rand.nextInt(16) + 8;
    k2:= rand.nextInt(rand.nextInt(128 - 8) + 8);
    l3:= l + rand.nextInt(16) + 8;
    if(k2 < 63)or(rand.nextInt(10)=0) then
      lakes.generate(map,xreg,yreg,rand,j1, k2, l3);
    lakes.Free;
  end;

  dungGen:=WorldGenDungeons.Create;

  for k1:=0 to 7 do
  begin
    i3:= k + rand.nextInt(16) + 8;
    i4:= rand.nextInt(128);
    k4:= l + rand.nextInt(16) + 8;
    dungGen.generate(map,xreg,yreg,rand,i3, i4, k4);
  end;

  dungGen.Free;

  genbase.func_35477_a(map,xreg,yreg, rand, k, l);

  for i2:=0 to 15 do
    for j3:=0 to 15 do
    begin
      t:=127;
      while t>0 do
      begin
        t1:=get_block_id(map,xreg,yreg,k + i2,t,l + j3);
        if (t1 in solid_bl)or(t1=8)or(t1=9)or(t1=10)or(t1=11) then
        begin
          inc(t);
          break;
        end
        else
          dec(t);
      end;

      j4:=t;

      if (func_40471_p(map,xreg,yreg,i2 + k, j4 - 1, j3 + l,manager)) then
        set_block_id(map,xreg,yreg,i2 + k, j4 - 1, j3 + l, 79);
      if(func_40478_r(map,xreg,yreg,i2 + k, j4, j3 + l,manager)) then
        set_block_id(map,xreg,yreg,i2 + k, j4, j3 + l, 78);
    end;
end;

procedure ChunkProviderGenerate.Clear;
begin
  setlength(noise1,0);
  setlength(noise2,0);
  setlength(noise3,0);
  setlength(noise5,0);
  setlength(noise6,0);
  setlength(stoneNoise,0);
  setlength(biomesForGeneration,0);
end;

end.

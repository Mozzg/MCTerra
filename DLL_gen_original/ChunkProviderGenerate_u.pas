unit ChunkProviderGenerate_u;

interface

uses generation, IChunkProvider_u, RandomMCT, NoiseGeneratorOctaves_u,
BiomeGenBase_u, WorldChunkManager_u, MapGenCaves_u, MapGenRavine_u;

type ChunkProviderGenerate=class(IChunkProvider)
     private
       rand:rnd;
       noiseGen1,noiseGen2,noiseGen3,noiseGen4,noiseGen5,noiseGen6:NoiseGeneratorOctaves;
       biomesForGeneration:ar_BiomeGenBase;
       field_4180_q,stoneNoise:ar_double;
       caveGenerator:MapGenCaves;
       ravineGenerator:MapGenRavine;
       world_sid:int64;
       //temp_ar:ar_byte;
       function initializeNoiseField(ad:ar_double; i,j,k,l,i1,j1:integer):ar_double;
       function getPrecipitationHeight(xreg,yreg,i,j:integer; map:region):integer;
       function func_40471_p(xreg,yreg,i,j,k:integer; map:region):boolean;
       function canSnowAt(xreg,yreg,i,j,k:integer; map:region):boolean;
       procedure process_gravity(xreg,yreg:integer; map:region; i,j:integer);
     public
       noise1,noise2,noise3,noise5,noise6:ar_double;
       field_35388_l:ar_double;
       manager:WorldChunkManager;
       constructor Create(l:int64; flag:boolean);
       destructor Destroy; override;
       procedure replaceBlocksForBiome(i,j:integer; abyte0:ar_byte; abiomegenbase:ar_BiomeGenBase);
       function provideChunk(abyte0:ar_byte; i,j:integer; biomes:ar_byte):boolean; override;
       procedure generateTerrain(i,j:integer; abyte0:ar_byte);
       procedure populate(xreg,yreg,i,j:integer; map:region);
       procedure Clear;
     end;

implementation

uses windows, IntCache_u, WorldGenLakes_u, WorldGenDungeons_u;

constructor ChunkProviderGenerate.Create(l:int64; flag:boolean);
begin
  setlength(stoneNoise,256);    

  //rand.Create(l);
  rand:=rnd.Create(l);
  noiseGen1:=NoiseGeneratorOctaves.Create(rand,16);
  noiseGen2:=NoiseGeneratorOctaves.Create(rand,16);
  noiseGen3:=NoiseGeneratorOctaves.Create(rand,8);
  noiseGen4:=NoiseGeneratorOctaves.Create(rand,4);
  noiseGen5:=NoiseGeneratorOctaves.Create(rand,10);
  noiseGen6:=NoiseGeneratorOctaves.Create(rand,16);

  manager:=WorldChunkManager.Create(l);
  caveGenerator:=MapGenCaves.Create(manager);
  ravineGenerator:=MapGenRavine.Create(manager);
  //setlength(temp_ar,16*128*16);

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
  setlength(biomesForGeneration,0);
  setlength(field_4180_q,0);
  setlength(noise1,0);
  setlength(noise2,0);
  setlength(noise3,0);
  setlength(noise5,0);
  setlength(noise6,0);
  setlength(field_35388_l,0);
  setlength(stoneNoise,0);

  ravineGenerator.Free;
  caveGenerator.Free;
  manager.Free;
  //setlength(temp_ar,0);

  IntCache_u.Clear_int_cache;

  inherited;
end;

procedure ChunkProviderGenerate.generateTerrain(i,j:integer; abyte0:ar_byte);
var byte0,k,l,i1,j1,k1,zz,l1,i2,j2,k2,l2,i3,j3,k3,xx,yy:integer;
d,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,d15,d16:double;
begin
  //WORLDHEIGHT
  byte0:=4;
  k:=128 div 8;
  l:=63;
  i1:=byte0 + 1;
  j1:=128 div 8 + 1;
  k1:=byte0 + 1;
  //WORLDHEIGHT END

  biomesForGeneration:=manager.func_35557_b(biomesForGeneration, i * 4 - 2, j * 4 - 2, i1 + 5, k1 + 5);
  {setlength(biomesForGeneration,((i1 + 5)*(k1 + 5)));
  for zz:=0 to length(biomesForGeneration)-1 do
    //biomesForGeneration[zz]:=forest_b;
    biomesForGeneration[zz]:=extremeHills_b; }

  field_4180_q:=initializeNoiseField(field_4180_q, i * byte0, 0, j * byte0, i1, j1, k1);
  for l1:=0 to byte0-1 do
    for i2:=0 to byte0-1 do   
      for j2:=0 to k-1 do
      begin
        d:=0.125;
        d1:=field_4180_q[((l1 + 0) * k1 + (i2 + 0)) * j1 + (j2 + 0)];
        d2:=field_4180_q[((l1 + 0) * k1 + (i2 + 1)) * j1 + (j2 + 0)];
        d3:=field_4180_q[((l1 + 1) * k1 + (i2 + 0)) * j1 + (j2 + 0)];
        d4:=field_4180_q[((l1 + 1) * k1 + (i2 + 1)) * j1 + (j2 + 0)];
        d5:=(field_4180_q[((l1 + 0) * k1 + (i2 + 0)) * j1 + (j2 + 1)] - d1) * d;
        d6:=(field_4180_q[((l1 + 0) * k1 + (i2 + 1)) * j1 + (j2 + 1)] - d2) * d;
        d7:=(field_4180_q[((l1 + 1) * k1 + (i2 + 0)) * j1 + (j2 + 1)] - d3) * d;
        d8:=(field_4180_q[((l1 + 1) * k1 + (i2 + 1)) * j1 + (j2 + 1)] - d4) * d;
        for k2:=0 to 7 do
        begin
          d9:= 0.25;
          d10:= d1;
          d11:= d2;
          d12:= (d3 - d1) * d9;
          d13:= (d4 - d2) * d9;
          for l2:=0 to 3 do
          begin
            i3:=((l2 + l1 * 4)shl 11)or((0 + i2 * 4)shl 7)or(j2 * 8 + k2);
            j3:= 1 shl 7;
            i3:=i3-j3;
            d14:=0.25;
            d15:=d10;
            d16:=(d11 - d10) * d14;
            d15:=d15-d16;
            for k3:=0 to 3 do
            begin
              d15:=d15+d16;
              if (d15 > 0)then
              begin
                i3:=i3+j3;  
                xx:=i3 shr 11;
                zz:=(i3-xx*2048)shr 7;
                yy:=(i3-xx*2048-zz*128);
                abyte0[xx+zz*16+yy*256]:=1;
                //abyte0[i3]:=1;
                continue;
              end;
              i3:=i3+j3;
              if ((j2 * 8 + k2) < l)then
              begin
                xx:=i3 shr 11;
                zz:=(i3-xx*2048)shr 7;
                yy:=(i3-xx*2048-zz*128);
                abyte0[xx+zz*16+yy*256]:=9;
                //abyte0[i3]:=9;
              end
              else
              begin
                xx:=i3 shr 11;
                zz:=(i3-xx*2048)shr 7;
                yy:=(i3-xx*2048-zz*128);
                abyte0[xx+zz*16+yy*256]:=0;
                //abyte0[i3]:=0;
              end;
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

procedure ChunkProviderGenerate.replaceBlocksForBiome(i,j:integer; abyte0:ar_byte; abiomegenbase:ar_BiomeGenBase);
var k,j1,k1,byte0,byte1,l,i1,l1,i2,byte2:integer;
d,f:double;
af:ar_double;
genbase:BiomeGenBase;
begin
  k:=63;        //worldobj
  d:=0.03125;
  stoneNoise:=noiseGen4.generateNoiseOctaves(stoneNoise, i * 16, j * 16, 0, 16, 16, 1, d * 2, d * 2, d * 2);
  af:=manager.initTemperatureCache(i * 16, j * 16, 16, 16);
  for l:=0 to 15 do    //Z
    for i1:=0 to 15 do    //X
    begin
      f:=af[i1 + l * 16];
      genbase:=abiomegenbase[i1 + l * 16];
      j1:=trunc(stoneNoise[l + i1 * 16] / 3 + 3 + rand.nextDouble * 0.25);
      k1:=-1;
      byte0:=genbase.topBlock;
      byte1:=genbase.fillerBlock;
      for l1:=127 downto 0 do  //Y
      begin
        //i2 = (i1 * 16 + l) * worldObj.worldHeight + l1;
        i2:=i1+l*16+l1*256;
        if (l1 <= 0 + rand.nextInt(5))then
        begin
          abyte0[i2]:=7;
          continue;
        end;
        byte2:=abyte0[i2];
        if (byte2 = 0)then
        begin
          k1:=-1;
          continue;
        end;
        if (byte2 <> 1)then continue;
        if (k1=-1) then
        begin
          if (j1 <= 0)then
          begin
            byte0:=0;
            byte1:=1;
          end
          else if (l1 >= k - 4)and(l1 <= k + 1)then
          begin
            byte0:=genbase.topBlock;
            byte1:=genbase.fillerBlock;
          end;
          if (l1 < k)and(byte0 = 0)then
          begin
            if (f < 0.15)then byte0:=79
            else byte0:=9;
          end;
          k1:=j1;
          if (l1 >= k - 1)then abyte0[i2]:=byte0
          else abyte0[i2]:=byte1;
          continue;
        end;
        if (k1 <= 0)then continue;
        dec(k1);
        abyte0[i2]:=byte1;
        if (k1 = 0)and(byte1 = 12)then
        begin
          k1:=rand.nextInt(4);
          byte1:=24;
        end;
      end;
    end;
end;

function ChunkProviderGenerate.provideChunk(abyte0:ar_byte; i,j:integer; biomes:ar_byte):boolean;
//var x,y,z:integer;
var t:integer;
begin
  if length(abyte0)<>(16*16*256) then
  begin
    result:=false;
    exit;
  end;
  if length(biomes)<>(16*16)then
  begin
    result:=false;
    exit;
  end;
  rand.setSeed(i * $4f9939f508 + j * $1ef1565bd5);

  zeromemory(abyte0,length(abyte0));

  generateTerrain(i,j,abyte0);
  biomesForGeneration:=manager.loadBlockGeneratorData(biomesForGeneration, i * 16, j * 16, 16, 16);
  for t:=0 to length(biomesForGeneration)-1 do
    biomes[t]:=biomesForGeneration[t].biomeID;
  replaceBlocksForBiome(i, j, abyte0, biomesForGeneration);

  caveGenerator.generate(world_sid,i,j,abyte0);
  ravineGenerator.generate(world_sid,i,j,abyte0);

  setlength(biomesForGeneration,0);
  result:=true;
end;

function ChunkProviderGenerate.getPrecipitationHeight(xreg,yreg,i,j:integer; map:region):integer;
var t,t1:integer;
begin
  t:=127;
  while t>=0 do
  begin
    t1:=get_block_id(map,xreg,yreg,i,t,j);

    if (t1 in solid_bl)or(t1=8)or(t1=9)or(t1=10)or(t1=11) then
    begin
      result:=t+1;
      exit;
    end;

    dec(t);
  end;

  result:=-1;
end;

function ChunkProviderGenerate.func_40471_p(xreg,yreg,i,j,k:integer; map:region):boolean;
var f:double;
t,t1:integer;
begin
  f:=manager.getTemperature(i,j,k);
  if f>0.15 then
  begin
    result:=false;
    exit;
  end;

  t:=get_block_id(map,xreg,yreg,i,j,k);
  t1:=get_block_data(map,xreg,yreg,i,j,k);
  if ((t=8)or(t=9))and(t1=0) then
    result:=true
  else result:=false;
end;

function ChunkProviderGenerate.canSnowAt(xreg,yreg,i,j,k:integer; map:region):boolean;
var f:double;
t,t1:integer;
begin
  f:=manager.getTemperature(i,j,k);
  if f>0.15 then
  begin
    result:=false;
    exit;
  end;

  t:=get_block_id(map,xreg,yreg,i,j,k);
  t1:=get_block_id(map,xreg,yreg,i,j-1,k);
  if (t=0)and(t1<>0)and(t1<>79)and(t1 in solid_bl) then
    result:=true
  else result:=false;
end;

procedure ChunkProviderGenerate.process_gravity(xreg,yreg:integer; map:region; i,j:integer);
var tempxot,tempxdo,tempyot,tempydo,chx,chy:integer;
x,z,t,t1:integer;
xx,yy,zz,yy_t:integer;
begin
  x:=i*16;
  z:=j*16;

  //schitaem koordinati nachalnih i konechnih chankov v regione
    if xreg<0 then
    begin
      tempxot:=(xreg+1)*32-32;
      tempxdo:=(xreg+1)*32+3;
    end
    else
    begin
      tempxot:=xreg*32;
      tempxdo:=(xreg*32)+35;
    end;

    if yreg<0 then
    begin
      tempyot:=(yreg+1)*32-32;
      tempydo:=(yreg+1)*32+3;
    end
    else
    begin
      tempyot:=yreg*32;
      tempydo:=(yreg*32)+35;
    end;

    dec(tempxot,2);
    dec(tempxdo,2);
    dec(tempyot,2);
    dec(tempydo,2);

    //opredelaem, k kakomu chanku otnositsa
    chx:=x;
    chy:=z;

    if chx<0 then inc(chx);
    if chy<0 then inc(chy);

    chx:=chx div 16;
    chy:=chy div 16;

    if (chx<=0)and(x<0) then dec(chx);
    if (chy<=0)and(z<0) then dec(chy);

    //uslovie
    if (chx>=tempxot)and(chx<=tempxdo)and(chy>=tempyot)and(chy<=tempydo) then
    begin
      chx:=chx-tempxot;
      chy:=chy-tempyot;


      for xx:=0 to 15 do
        for zz:=0 to 15 do
          for yy:=0 to 127 do
          begin
            t:=map[chx][chy].blocks[xx+zz*16+yy*256];
            //gravity
            if (t=13)then
            begin
              yy_t:=yy-1;
              t1:=map[chx][chy].blocks[xx+zz*16+yy_t*256];
              while not(t1 in solid_bl)do
              begin
                dec(yy_t);
                t1:=map[chx][chy].blocks[xx+zz*16+yy_t*256];
              end;
              //proverka, est' li voobshe pod blokom osnovanie
              if yy_t<>(yy-1) then
              begin
                map[chx][chy].blocks[xx+zz*16+yy*256]:=0;
                t1:=map[chx][chy].blocks[xx+zz*16+(yy_t+1)*256];
                if (t1=8)or(t1=9)or(t1=10)or(t1=11)or(t1=0)then
                  map[chx][chy].blocks[xx+zz*16+(yy_t+1)*256]:=t;
              end;
            end;

            //floating water
            if t=9 then
            begin
              t1:=0;
              //po X v -
              if xx=0 then yy_t:=map[chx-1][chy].blocks[15+zz*16+yy*256]
              else yy_t:=map[chx][chy].blocks[(xx-1)+zz*16+yy*256];
              if (not(yy_t in solid_bl))and(yy_t<>8)and(yy_t<>9) then inc(t1);

              //po X v +
              if t1=0 then
              begin
                if xx=15 then yy_t:=map[chx+1][chy].blocks[0+zz*16+yy*256]
                else yy_t:=map[chx][chy].blocks[(xx+1)+zz*16+yy*256];
                if (not(yy_t in solid_bl))and(yy_t<>8)and(yy_t<>9) then inc(t1);
              end;

              //po Z v -
              if t1=0 then
              begin
                if zz=0 then yy_t:=map[chx][chy-1].blocks[xx+15*16+yy*256]
                else yy_t:=map[chx][chy].blocks[xx+(zz-1)*16+yy*256];
                if (not(yy_t in solid_bl))and(yy_t<>8)and(yy_t<>9) then inc(t1);
              end;

              //po Z v +
              if t1=0 then
              begin
                if zz=15 then yy_t:=map[chx][chy+1].blocks[xx+yy*256]
                else yy_t:=map[chx][chy].blocks[xx+(zz+1)*16+yy*256];
                if (not(yy_t in solid_bl))and(yy_t<>8)and(yy_t<>9) then inc(t1);
              end;

              //po Y v -
              if t1=0 then
              begin
                yy_t:=map[chx][chy].blocks[xx+zz*16+(yy-1)*256];
                if (not(yy_t in solid_bl))and(yy_t<>8)and(yy_t<>9) then inc(t1);
              end;

              if t1<>0 then map[chx][chy].blocks[xx+zz*16+yy*256]:=8;
            end;
          end;
    end;
end;

procedure ChunkProviderGenerate.populate(xreg,yreg,i,j:integer; map:region);
var k,l,i1,j2,k3,j1,k2,l3,k1,i3,i4,k4,i2,j3,j4:integer;
genbase:BiomeGenBase;
l1,l2:int64;
flag:boolean;
GenLakes:WorldGenLakes;
GenDung:WorldGenDungeons;
begin
  k:=i * 16;
  l:=j * 16;
  genbase:=manager.getBiomeGenAt(k + 16, l + 16);
  rand.setSeed(world_sid);
  l1:=(rand.nextLong() div 2) * 2 + 1;
  l2:=(rand.nextLong() div 2) * 2 + 1;
  rand.setSeed((i * l1 + j * l2) xor world_sid);
  flag:=false;

  //MAPFEATURES

  if (not(flag))and (rand.nextInt(4) = 0) then
  begin
    i1:=k + rand.nextInt(16) + 8;
    j2:=rand.nextInt(128);
    k3:=l + rand.nextInt(16) + 8;
    GenLakes:=WorldGenLakes.Create(9,manager);
    GenLakes.generate(xreg,yreg,map,rand,i1, j2, k3);
    GenLakes.Free;
  end;
  if (not(flag))and(rand.nextInt(8) = 0)then
  begin
    j1:=k + rand.nextInt(16) + 8;
    k2:=rand.nextInt(rand.nextInt(128 - 8) + 8);
    l3:=l + rand.nextInt(16) + 8;
    if (k2 < 63)or(rand.nextInt(10) = 0)then  //WORLDOBJ
    begin
      GenLakes:=WorldGenLakes.Create(11,manager);
      GenLakes.generate(xreg,yreg,map,rand,j1, k2, l3);
      GenLakes.Free;
    end;
  end;
  for k1:=0 to 7 do
  begin
    i3:=k + rand.nextInt(16) + 8;
    i4:=rand.nextInt(128);
    k4:=l + rand.nextInt(16) + 8;
    GenDung:=WorldGenDungeons.Create;
    GenDung.generate(xreg,yreg,map,rand,i3, i4, k4);
    GenDung.Free;
  end;

  //decorate
  genbase.func_35477_a(xreg,yreg,map, rand, k, l);

  //k:=k+8;
  //l:=l+8;
  for i2:=0 to 15 do
    for j3:=0 to 15 do
    begin
      j4:=getPrecipitationHeight(xreg,yreg,k + i2, l + j3,map);
      if func_40471_p(xreg,yreg,i2 + k, j4 - 1, j3 + l,map) then
      begin
        set_block_id(map,xreg,yreg,i2 + k, j4 - 1, j3 + l,79);
      end;
      if canSnowAt(xreg,yreg,i2 + k, j4, j3 + l,map) then
      begin
        set_block_id(map,xreg,yreg,i2 + k, j4, j3 + l,78);
      end;
    end;

  process_gravity(xreg,yreg,map,i,j);
end;

function ChunkProviderGenerate.initializeNoiseField(ad:ar_double; i,j,k,l,i1,j1:integer):ar_double;
var k1,l1,i2,j2,k2,l2,byte0,i3,j3,k3:integer;
f,d,d1,f1,f2,f3,f4,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11:double;
biome,biome1:BiomeGenBase;
begin
  if length(ad)=0 then setlength(ad,l*i1*j1);
  if length(field_35388_l)=0 then
  begin
    setlength(field_35388_l,25);
    for k1:=-2 to 2 do
      for l1:=-2 to 2 do
      begin
        f:=10/sqrt((k1 * k1 + l1 * l1) + 0.2);
        field_35388_l[k1+2+(l1+2)*5]:=f;
      end;
  end;

  d:=684.41200000000003;
  d1:=684.41200000000003;
  noise5:=noiseGen5.func_4109_a(noise5, i, k, l, j1, 1.121, 1.121, 0.5);
  noise6:=noiseGen6.func_4109_a(noise6, i, k, l, j1, 200, 200, 0.5);
  noise3:=noiseGen3.generateNoiseOctaves(noise3, i, j, k, l, i1, j1, d / 80, d1 / 160, d / 80);
  noise1:=noiseGen1.generateNoiseOctaves(noise1, i, j, k, l, i1, j1, d, d1, d);
  noise2:=noiseGen2.generateNoiseOctaves(noise2, i, j, k, l, i1, j1, d, d1, d);

  i:=0;
  k:=0;
  i2:=0;
  j2:=0;
  for k2:=0 to l-1 do
    for l2:=0 to j1-1 do
    begin
      f1:=0;
      f2:=0;
      f3:=0;
      byte0:=2;
      biome:=biomesForGeneration[k2 + 2 + (l2 + 2) * (l + 5)];
      for i3:=-byte0 to byte0 do
        for j3:=-byte0 to byte0 do
        begin
          biome1:=biomesForGeneration[k2 + i3 + 2 + (l2 + j3 + 2) * (l + 5)];
          f4:=field_35388_l[i3 + 2 + (j3 + 2) * 5] / (biome1.minHeight + 2);
          if (biome1.minHeight > biome.minHeight) then f4:=f4/2;
          f1:=f1+biome1.maxHeight * f4;
          f2:=f2+biome1.minHeight * f4;
          f3:=f3+f4;
        end;
      f1:=f1/f3;
      f2:=f2/f3;
      f1:=f1 * 0.9 + 0.1;
      f2:=(f2 * 4 - 1) / 8;
      d2:=noise6[j2] / 8000;
      if (d2 < 0)then d2:= -d2 * 0.29999999999999999;
      d2:=d2 * 3 - 2;
      if (d2 < 0)then
      begin
        d2:=d2/2;
        if (d2 < -1)then d2:=-1;
        d2:=d2/1.3999999999999999;
        d2:=d2/2;
      end
      else
      begin
        if (d2 > 1)then d2:=1;
        d2:=d2/8;
      end;
      inc(j2);
      for k3:=0 to i1-1 do
      begin
        d3:=f2;
        d4:=f1;
        d3:=d3+(d2 * 0.20000000000000001);
        d3:=(d3 * i1) / 16;
        d5:=i1 / 2 + d3 * 4;
        d6:=0;
        d7:=((k3 - d5) * 12 * 128) / 128 / d4;   //WORLDHEIGHT
        if (d7 < 0) then d7:=d7*4;
        d8:=noise1[i2] / 512;
        d9:=noise2[i2] / 512;
        d10:=(noise3[i2] / 10 + 1) / 2;
        if (d10 < 0)then d6:=d8
        else if (d10 > 1)then d6:=d9
        else d6:=d8 + (d9 - d8) * d10;
        d6:=d6-d7;
        if (k3 > i1 - 4)then
        begin
          d11:=(k3 - (i1 - 4)) / 3;
          d6:=d6 * (1 - d11) + -10 * d11;
        end;
        ad[i2]:=d6;
        inc(i2);
      end;
    end;

  result:=ad;
end;

procedure ChunkProviderGenerate.Clear;
begin
  setlength(noise1,0);
  setlength(noise2,0);
  setlength(noise3,0);
  setlength(noise5,0);
  setlength(noise6,0);
  setlength(biomesForGeneration,0);
end;

end.

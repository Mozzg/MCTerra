unit BiomeDecorator_u;

interface

uses RandomMCT, generation_obsh, WorldGenerator_u;

type  BiomeDecorator=class(TObject)
      protected
        biome:TObject;
        clayGen,sandGen,gravelAsSandGen,dirtGen,gravelGen,
        coalGen,ironGen,goldGen,redstoneGen,diamondGen,
        lapisGen,plantYellowGen,plantRedGen,mushroomBrownGen,
        mushroomRedGen,field_40720_u,reedGen,cactusGen,
        waterlilyGen,tallGrassGen,deadBushGen,pumpkinGen,
        liquidsWaterGen,liquidsLavaGen:WorldGenerator;
        procedure genStandardOre1(i:integer; generator:WorldGenerator; map:region; xreg,yreg,j,k:integer);
        procedure genStandardOre2(i:integer; generator:WorldGenerator; map:region; xreg,yreg,j,k:integer);
        procedure generateOres(map:region; xreg,yreg:integer);
        procedure decorate_do(map:region; xreg,yreg:integer);
        procedure make_fall(map:region; xreg,yreg:integer);
      public
        decoRNG:rnd;
        chunk_X,chunk_Z:integer;
        waterlilyPerChunk,treesPerChunk,flowersPerChunk,grassPerChunk,
        reedsPerChunk,deadBushPerChunk,mushroomsPerChunk,
        cactiPerChunk,sandPerChunk,sandPerChunk2,clayPerChunk,
        field_40718_J:integer;
        generateFluid:boolean;
        constructor Create(biomegen:TObject); virtual;
        destructor Destroy; override;
        procedure decorate(map:region; xreg,yreg:integer; rand:rnd; i,j:integer);
      end;

implementation

uses WorldGenClay_u, WorldGenSand_u, WorldGenMinable_u,
WorldGenFlowers_u, WorldGenBigMushroom_u, WorldGenReed_u,
WorldGenCactus_u, MapGenWaterlily_u, WorldGenTallGrass_u,
WorldGenDeadBush_u, WorldGenPumpkin_u, WorldGenLiquids_u,
generation_spec, BiomeGenBase_u;

constructor BiomeDecorator.Create(biomegen:TObject);
begin
  clayGen:=WorldGenClay.Create(4);
  sandGen:=WorldGenSand.Create(7, 12);
  gravelAsSandGen:=WorldGenSand.Create(6, 13);
  dirtGen:=WorldGenMinable.Create(3, 32);
  gravelGen:=WorldGenMinable.Create(13, 32);
  coalGen:=WorldGenMinable.Create(16, 16);
  ironGen:=WorldGenMinable.Create(15, 8);
  goldGen:=WorldGenMinable.Create(14, 8);
  redstoneGen:=WorldGenMinable.Create(73, 7);
  diamondGen:=WorldGenMinable.Create(56, 7);
  lapisGen:=WorldGenMinable.Create(21, 6);
  plantYellowGen:=WorldGenFlowers.Create(37);
  plantRedGen:=WorldGenFlowers.Create(38);
  mushroomBrownGen:=WorldGenFlowers.Create(39);
  mushroomRedGen:=WorldGenFlowers.Create(40);
  field_40720_u:=WorldGenBigMushroom.Create;
  reedGen:=WorldGenReed.Create;
  cactusGen:=WorldGenCactus.Create;
  waterlilyGen:=MapGenWaterlily.Create;
  tallGrassGen:=WorldGenTallGrass.Create(31,1);
  deadBushGen:=WorldGenDeadBush.Create(32);
  pumpkinGen:=WorldGenPumpkin.Create;
  liquidsWaterGen:=WorldGenLiquids.Create(8);
  liquidsLavaGen:=WorldGenLiquids.Create(10);
  waterlilyPerChunk:= 0;
  treesPerChunk:= 0;
  flowersPerChunk:= 2;
  grassPerChunk:= 1;
  deadBushPerChunk:= 0;
  mushroomsPerChunk:= 0;
  reedsPerChunk:= 0;
  cactiPerChunk:= 0;
  sandPerChunk:= 1;
  sandPerChunk2:= 3;
  clayPerChunk:= 1;
  field_40718_J:= 0;
  generateFluid:= true;
  biome:= biomegen;
end;

destructor BiomeDecorator.Destroy;
begin
  clayGen.Free;
  sandGen.Free;
  gravelAsSandGen.Free;
  dirtGen.Free;
  gravelGen.Free;
  coalGen.Free;
  ironGen.Free;
  goldGen.Free;
  redstoneGen.Free;
  diamondGen.Free;
  lapisGen.Free;
  plantYellowGen.Free;
  plantRedGen.Free;
  mushroomBrownGen.Free;
  mushroomRedGen.Free;
  field_40720_u.Free;
  reedGen.Free;
  cactusGen.Free;
  waterlilyGen.Free;
  tallGrassGen.Free;
  deadBushGen.Free;
  pumpkinGen.Free;
  liquidsWaterGen.Free;
  liquidsLavaGen.Free;
end;

procedure BiomeDecorator.decorate(map:region; xreg,yreg:integer; rand:rnd; i,j:integer);
begin
  chunk_X:=i;
  chunk_Z:=j;
  decoRNG:=rand;
  decorate_do(map,xreg,yreg);
end;

procedure BiomeDecorator.decorate_do(map:region; xreg,yreg:integer);
var trees:WorldGenerator;
t,l:integer;
xx,yy,zz:integer;
begin
  generateores(map,xreg,yreg);

  make_fall(map,xreg,yreg);

  for t:=0 to sandPerChunk2-1 do
  begin
    xx:=chunk_X + decoRNG.nextInt(16) + 8;
    zz:=chunk_Z + decoRNG.nextInt(16) + 8;
    yy:=get_top_solid(map,xreg,yreg,xx,zz);
    sandGen.generate(map,xreg,yreg,decoRNG,xx,yy,zz);
  end;

  for t:=0 to clayPerChunk-1 do
  begin
    xx:=chunk_X + decoRNG.nextInt(16) + 8;
    zz:=chunk_Z + decoRNG.nextInt(16) + 8;
    yy:=get_top_solid(map,xreg,yreg,xx,zz);
    clayGen.generate(map,xreg,yreg,decoRNG,xx,yy,zz);
  end;

  for t:=0 to sandPerChunk-1 do
  begin
    xx:=chunk_X + decoRNG.nextInt(16) + 8;
    zz:=chunk_Z + decoRNG.nextInt(16) + 8;
    yy:=get_top_solid(map,xreg,yreg,xx,zz);
    sandGen.generate(map,xreg,yreg,decoRNG,xx,yy,zz);
  end;

  l:=treesPerChunk;
  if(decoRNG.nextInt(10) = 0) then inc(l);

  for t:=0 to l-1 do
  begin
    xx:= chunk_X + decoRNG.nextInt(16) + 8;
    zz:= chunk_Z + decoRNG.nextInt(16) + 8;
    yy:=get_heightmap(map,xreg,yreg,xx,zz);
    trees:=BiomeGenBase(biome).getRandomWorldGenForTrees(decoRNG);
    trees.func_517_a(1, 1, 1);
    trees.generate(map,xreg,yreg, decoRNG, xx, yy, zz);
  end;

  for t:=0 to field_40718_J-1 do
  begin
    xx:=chunk_X + decoRNG.nextInt(16) + 8;
    zz:=chunk_Z + decoRNG.nextInt(16) + 8;
    yy:=get_heightmap(map,xreg,yreg,xx,zz);
    field_40720_u.generate(map,xreg,yreg,decoRNG,xx,yy,zz);
  end;

  for t:=0 to flowersPerChunk-1 do
  begin
    xx:=chunk_X + decoRNG.nextInt(16) + 8;
    yy:=decoRNG.nextInt(128);
    zz:=chunk_Z + decoRNG.nextInt(16) + 8;
    plantYellowGen.generate(map,xreg,yreg,decoRNG,xx,yy,zz);
    if(decoRNG.nextInt(4) = 0) then
    begin
      xx:=chunk_X + decoRNG.nextInt(16) + 8;
      yy:=decoRNG.nextInt(128);
      zz:=chunk_Z + decoRNG.nextInt(16) + 8;
      plantRedGen.generate(map,xreg,yreg,decoRNG,xx,yy,zz);
    end;
  end;

  for t:=0 to grassPerChunk-1 do
  begin
    xx:=chunk_X + decoRNG.nextInt(16) + 8;
    yy:=decoRNG.nextInt(128);
    zz:=chunk_Z + decoRNG.nextInt(16) + 8;
    tallGrassGen.generate(map,xreg,yreg,decoRNG,xx,yy,zz);
  end;

  for t:=0 to deadBushPerChunk-1 do
  begin
    xx:=chunk_X + decoRNG.nextInt(16) + 8;
    yy:=decoRNG.nextInt(128);
    zz:=chunk_Z + decoRNG.nextInt(16) + 8;
    deadBushGen.generate(map,xreg,yreg,decoRNG,xx,yy,zz);
  end;

  for t:=0 to waterlilyPerChunk-1 do
  begin
    xx:=chunk_X + decoRNG.nextInt(16) + 8;
    zz:=chunk_Z + decoRNG.nextInt(16) + 8;
    yy:=decoRNG.nextInt(128);
    while (yy > 0)and(get_Block_Id(map,xreg,yreg,xx, yy - 1, zz) = 0) do
      dec(yy);
    waterlilyGen.generate(map,xreg,yreg,decoRNG,xx,yy,zz);
  end;

  for t:=0 to mushroomsPerChunk-1 do
  begin
    if decoRNG.nextInt(4) = 0  then
    begin
      xx:=chunk_X + decoRNG.nextInt(16) + 8;
      yy:=get_heightmap(map,xreg,yreg,xx,zz);
      zz:=chunk_Z + decoRNG.nextInt(16) + 8;
      mushroomBrownGen.generate(map,xreg,yreg,decoRNG,xx,yy,zz);
    end;
    if decoRNG.nextInt(8) = 0  then
    begin
      xx:=chunk_X + decoRNG.nextInt(16) + 8;
      yy:=get_heightmap(map,xreg,yreg,xx,zz);
      zz:=chunk_Z + decoRNG.nextInt(16) + 8;
      mushroomRedGen.generate(map,xreg,yreg,decoRNG,xx,yy,zz);
    end;
  end;

  if(decoRNG.nextInt(4) = 0) then
  begin
    xx:=chunk_X + decoRNG.nextInt(16) + 8;
    yy:=decoRNG.nextInt(128);
    zz:=chunk_Z + decoRNG.nextInt(16) + 8;
    mushroomBrownGen.generate(map,xreg,yreg,decoRNG,xx,yy,zz);
  end;

  if decoRNG.nextInt(8) = 0  then
  begin
    xx:=chunk_X + decoRNG.nextInt(16) + 8;
    yy:=decoRNG.nextInt(128);
    zz:=chunk_Z + decoRNG.nextInt(16) + 8;
    mushroomRedGen.generate(map,xreg,yreg,decoRNG,xx,yy,zz);
  end;

  for t:=0 to reedsPerChunk-1 do
  begin
    xx:=chunk_X + decoRNG.nextInt(16) + 8;
    yy:=decoRNG.nextInt(128);
    zz:=chunk_Z + decoRNG.nextInt(16) + 8;
    reedGen.generate(map,xreg,yreg,decoRNG,xx,yy,zz);
  end;

  for t:=0 to 9 do
  begin
    xx:=chunk_X + decoRNG.nextInt(16) + 8;
    yy:=decoRNG.nextInt(128);
    zz:=chunk_Z + decoRNG.nextInt(16) + 8;
    reedGen.generate(map,xreg,yreg,decoRNG,xx,yy,zz);
  end;

  if(decoRNG.nextInt(32) = 0) then
  begin
    xx:=chunk_X + decoRNG.nextInt(16) + 8;
    yy:=decoRNG.nextInt(128);
    zz:=chunk_Z + decoRNG.nextInt(16) + 8;
    pumpkinGen.generate(map,xreg,yreg,decoRNG,xx,yy,zz);
  end;

  for t:=0 to cactiPerChunk-1 do
  begin
    xx:=chunk_X + decoRNG.nextInt(16) + 8;
    yy:=decoRNG.nextInt(128);
    zz:=chunk_Z + decoRNG.nextInt(16) + 8;
    cactusGen.generate(map,xreg,yreg,decoRNG,xx,yy,zz);
  end;

  if(generateFluid) then
  begin
    for t:=0 to 49 do
    begin
      xx:=chunk_X + decoRNG.nextInt(16) + 8;
      yy:=decoRNG.nextInt(decoRNG.nextInt(128 - 8) + 8);
      zz:=chunk_Z + decoRNG.nextInt(16) + 8;
      liquidsWaterGen.generate(map,xreg,yreg,decoRNG,xx,yy,zz);
    end;

    for t:=0 to 19 do
    begin
      xx:=chunk_X + decoRNG.nextInt(16) + 8;
      yy:=decoRNG.nextInt(decoRNG.nextInt(decoRNG.nextInt(128 - 16) + 8) + 8);
      zz:=chunk_Z + decoRNG.nextInt(16) + 8;
      liquidsLavaGen.generate(map,xreg,yreg,decoRNG,xx,yy,zz);
    end; 
  end;
end;

procedure BiomeDecorator.make_fall(map:region; xreg,yreg:integer);
var tempxot,tempxdo,tempyot,tempydo:integer;
chxot,chxdo,chyot,chydo:integer;
x,y,z,tx,ty,t,t1,tt:integer;
b:boolean;
begin
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

  chxot:=chunk_X div 16;
  chyot:=chunk_Z div 16;
  if chxot=tempxdo then chxdo:=chxot-tempxot
  else chxdo:=chxot+1-tempxot;
  if chyot=tempydo then chydo:=chyot-tempyot
  else chydo:=chyot+1-tempyot;

  chxot:=chxot-tempxot;
  chyot:=chyot-tempyot;

  for tx:=chxot to chxdo do
    for ty:=chyot to chydo do
      for x:=0 to 15 do
        for z:=0 to 15 do
          for y:=2 to 127 do
          begin
            t:=map[tx][ty].blocks[y+(z*128+(x*2048))];
            case t of
            12,13:begin
                    if (map[tx][ty].blocks[y-1+(z*128+(x*2048))] in trans_bl) then
                    begin
                      t1:=y-2;
                      tt:=map[tx][ty].blocks[t1+(z*128+(x*2048))];
                      while (t1>0)and(tt in trans_bl) do
                      begin
                        dec(t1);
                        tt:=map[tx][ty].blocks[t1+(z*128+(x*2048))];
                      end;
                      if t1=0 then map[tx][ty].blocks[y+(z*128+(x*2048))]:=0
                      else
                      begin
                        map[tx][ty].blocks[t1+1+(z*128+(x*2048))]:=map[tx][ty].blocks[y+(z*128+(x*2048))];
                        map[tx][ty].blocks[y+(z*128+(x*2048))]:=0;
                      end;
                    end;
                  end;
            9:begin
                b:=false;
                //levo
                if (x=0) then
                begin
                  if tx<>0 then t1:=map[tx-1][ty].blocks[y+(z*128+(15*2048))]
                  else t1:=1;
                end
                else
                  t1:=map[tx][ty].blocks[y+(z*128+((x-1)*2048))];
                if t1=0 then b:=true;

                //pravo
                if b=false then
                begin
                  if x=15 then
                  begin
                    if tx<>35 then t1:=map[tx+1][ty].blocks[y+(z*128)]
                    else t1:=1;
                  end
                  else
                    t1:=map[tx][ty].blocks[y+(z*128+((x+1)*2048))];
                  if t1=0 then b:=true;
                end;

                //pered
                if b=false then
                begin
                  if z=15 then
                  begin
                    if ty<>35 then t1:=map[tx][ty+1].blocks[y+(x*2048)]
                    else t1:=1;
                  end
                  else
                    t1:=map[tx][ty].blocks[y+((z+1)*128+(x*2048))];
                  if t1=0 then b:=true;
                end;

                //zad
                if b=false then
                begin
                  if z=0 then
                  begin
                    if ty<>0 then t1:=map[tx][ty-1].blocks[y+(x*2048)]
                    else t1:=1;
                  end
                  else
                    t1:=map[tx][ty].blocks[y+((z-1)*128+(x*2048))];
                  if t1=0 then b:=true;
                end;

                //niz
                if map[tx][ty].blocks[y-1+(z*128+(x*2048))]=0 then b:=true;

                if b=true then map[tx][ty].blocks[y+(z*128+(x*2048))]:=8;
              end;
            end;
          end;
end;

procedure BiomeDecorator.genStandardOre1(i:integer; generator:WorldGenerator; map:region; xreg,yreg,j,k:integer);
var l,i1,j1,k1:integer;
begin
  for l:=0 to i-1 do
  begin
    i1:= chunk_X + decoRNG.nextInt(16);
    j1:= decoRNG.nextInt(k - j) + j;
    k1:= chunk_Z + decoRNG.nextInt(16);
    generator.generate(map,xreg,yreg, decoRNG, i1, j1, k1);
  end;
end;

procedure BiomeDecorator.genStandardOre2(i:integer; generator:WorldGenerator; map:region; xreg,yreg,j,k:integer);
var l,i1,j1,k1:integer;
begin
  for l:=0 to i-1 do
  begin
    i1:= chunk_X + decoRNG.nextInt(16);
    j1:= decoRNG.nextInt(k) + decoRNG.nextInt(k) + (j - k);
    k1:= chunk_Z + decoRNG.nextInt(16);
    generator.generate(map,xreg,yreg, decoRNG, i1, j1, k1);
  end;
end;

procedure BiomeDecorator.generateOres(map:region; xreg,yreg:integer);
begin
  genStandardOre1(20, dirtGen,map,xreg,yreg, 0, 128);
  genStandardOre1(10, gravelGen,map,xreg,yreg, 0, 128);
  genStandardOre1(20, coalGen,map,xreg,yreg, 0, 128);
  genStandardOre1(20, ironGen,map,xreg,yreg, 0, 128 div 2);
  genStandardOre1(2, goldGen,map,xreg,yreg, 0, 128 div 4);
  genStandardOre1(8, redstoneGen,map,xreg,yreg, 0, 128 div 8);
  genStandardOre1(1, diamondGen,map,xreg,yreg, 0, 128 div 8);
  genStandardOre2(1, lapisGen,map,xreg,yreg, 128 div 8, 128 div 8);
end;

end.

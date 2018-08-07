unit BiomeGenBase_u;

interface

uses WorldGenTrees_u, WorldGenForest_u, WorldGenBigTree_u,
WorldGenSwamp_u, BiomeDecorator_u, WorldGenTaiga1_u, WorldGenTaiga2_u,
RandomMCT, WorldGenerator_u, generation_obsh;

type  BiomeGenBase=class(TObject)
      private
        //enableSnow,enableRain:boolean;
        function createBiomeDecorator:BiomeDecorator;
        procedure setTemperatureRainfall(f,f1:extended);
        procedure setMinMaxHeight(f,f1:extended);
        procedure setDisableRain;
        procedure setBiomeName(name:string);
        procedure func_4124_a(i:integer);
        procedure setColor(i:integer);
      protected
        enableSnow,enableRain:boolean;
      public
        biomeName:string;
        color:integer;
        topBlock,fillerBlock:byte;
        field_6502_q:integer;
        minHeight,maxHeight,temperature,rainfall:extended;
        field_40256_A:integer;
        decorator:BiomeDecorator;
        biomeID:integer;
        GenTrees:WorldGenTrees;
        GenForest:WorldGenForest;
        GenSwamp:WorldGenSwamp;
        GenBigTree:WorldGenBigTree;
        GenTaiga1:WorldGenTaiga1;
        GenTaiga2:WorldGenTaiga2;
        constructor Create(i:integer); virtual;
        destructor Destroy;  reintroduce; virtual;
        function getRandomWorldGenForTrees(rand:rnd):WorldGenerator; virtual;
        function getEnableSnow:boolean;
        function func_35476_e:integer;
        function func_35474_f:integer;
        procedure func_35477_a(map:region; xreg,yreg:integer; rand:rnd; i,j:integer);
      end;

      ar_BiomeGenBase=array of BiomeGenBase;

var biomeList:array[0..255]of BiomeGenBase;
ocean_b,plains_b,desert_b,hills_b,forest_b,taiga_b,swampland_b,river_b,
hell_b,sky_b,frozenOcean_b,frozenRiver_b,icePlains_b,iceMountains_b,
mushroomIsland_b,mushroomIslandShore_b:BiomeGenBase;

implementation

uses SysUtils, BiomeGenOcean_u, BiomeGenPlains_u, BiomeGenDesert_u,
BiomeGenHills_u, BiomeGenForest_u, BiomeGenTaiga_u, BiomeGenSwamp_u,
BiomeGenRiver_u, BiomeGenHell_u, BiomeGenEnd_u, BiomeGenSnow_u,
BiomeGenMushroomIsland_u;

constructor BiomeGenBase.Create(i:integer);
begin
  topBlock:=2;
  fillerBlock:=3;
  field_6502_q:=$4ee031;
  minHeight:=0.1;
  maxHeight:=0.3;
  temperature:=0.5;
  rainfall:=0.5;
  field_40256_A:=$ffffff;
  enableRain:=true;
  GenTrees:=WorldGenTrees.Create;
  GenForest:=WorldGenForest.Create;
  GenBigTree:=WorldGenBigTree.Create;
  GenSwamp:=WorldGenSwamp.Create;
  GenTaiga1:=WorldGenTaiga1.Create;
  GenTaiga2:=WorldGenTaiga2.Create;
  biomeID:=i;
  biomeList[i]:=Self;
  decorator:=createBiomeDecorator;
end;

destructor BiomeGenBase.Destroy;
begin
  GenTrees.Free;
  GenForest.Free;
  GenBigTree.Free;
  GenSwamp.Free;
  GenTaiga1.Free;
  GenTaiga2.Free;

  decorator.Free;
  biomename:='';
end;

function BiomeGenBase.createBiomeDecorator:BiomeDecorator;
begin
  result:=BiomeDecorator.Create(Self);
end;

procedure BiomeGenBase.setTemperatureRainfall(f,f1:extended);
begin
  if (f>0.1)and(f<0.2) then
    raise Exception.Create('Avoid temperatures in range 0.1 and 0.2 because of snow') at @BiomeGenBase.Create;

  temperature:=f;
  rainfall:=f1;
end;

procedure BiomeGenBase.setMinMaxHeight(f,f1:extended);
begin
  minHeight:=f;
  maxHeight:=f1;
end;

procedure BiomeGenBase.setDisableRain;
begin
  enableRain:=false;
end;

function BiomeGenBase.getRandomWorldGenForTrees(rand:rnd):WorldGenerator;
begin
  if rand.nextInt(10)=0 then
    result:=GenBigTree
  else
    result:=GenTrees;
end;

procedure BiomeGenBase.setBiomeName(name:string);
begin
  biomeName:=name;
end;

procedure BiomeGenBase.func_4124_a(i:integer);
begin
  field_6502_q:=i;
end;

procedure BiomeGenBase.setColor(i:integer);
begin
  color:=i;
end;

function BiomeGenBase.getEnableSnow:boolean;
begin
  result:=enableSnow;
end;

function BiomeGenBase.func_35476_e:integer;
begin
  result:=trunc(rainfall * 65536);
end;

function BiomeGenBase.func_35474_f:integer;
begin
  result:=trunc(temperature * 65536);
end;

procedure BiomeGenBase.func_35477_a(map:region; xreg,yreg:integer; rand:rnd; i,j:integer);
begin
  decorator.decorate(map,xreg,yreg,rand,i,j);
end;

initialization

//ocean biome
ocean_b:=BiomeGenOcean.Create(0);
ocean_b.setColor(112);
ocean_b.setBiomeName('Ocean');
ocean_b.setMinMaxHeight(-1,0.4);
ocean_b.setMinMaxHeight(-1,0.4);
//plains biome
plains_b:=BiomeGenPlains.Create(1);
plains_b.setColor($8db360);
plains_b.setBiomeName('Plains');
plains_b.setTemperatureRainfall(0.8,0.4);
//desert biome
desert_b:=BiomeGenDesert.Create(2);
desert_b.setColor($fa9418);
desert_b.setBiomeName('Desert');
desert_b.setDisableRain;
desert_b.setTemperatureRainfall(2,0);
desert_b.setMinMaxHeight(0.1,0.2);
//Extreme hills biome
hills_b:=BiomeGenHills.Create(3);
hills_b.setColor($606060);
hills_b.setBiomeName('Extreme Hills');
hills_b.setMinMaxHeight(0.2,1.8);
hills_b.setTemperatureRainfall(0.2,0.3);
//forest biome
forest_b:=BiomeGenForest.Create(4);
forest_b.setColor($56621);
forest_b.setBiomeName('Forest');
forest_b.func_4124_a($4eba31);
forest_b.setTemperatureRainfall(0.7,0.8);
//taiga biome
taiga_b:=BiomeGenTaiga.Create(5);
taiga_b.setColor($b6659);
taiga_b.setBiomeName('Taiga');
taiga_b.func_4124_a($4eba31);
taiga_b.setTemperatureRainfall(0.3,0.8);
taiga_b.setMinMaxHeight(0.1,0.4);
//swamp biome
swampland_b:=BiomeGenSwamp.Create(6);
swampland_b.setColor($7f9b2);
swampland_b.setBiomeName('Swampland');
swampland_b.func_4124_a($8baf48);
swampland_b.setMinMaxHeight(-0.2,0.1);
swampland_b.setTemperatureRainfall(0.8,0.9);
//river biome
river_b:=BiomeGenRiver.Create(7);
river_b.setColor(255);
river_b.setBiomeName('River');
river_b.setMinMaxHeight(-0.5,0);
//nether biome
hell_b:=BiomeGenHell.Create(8);
hell_b.setColor($ff0000);
hell_b.setBiomeName('Hell');
hell_b.setDisableRain;
hell_b.setTemperatureRainfall(2,0);
//sky biome (End)
sky_b:=BiomeGenEnd.Create(9);
sky_b.setColor($8080ff);
sky_b.setBiomeName('Sky');
sky_b.setDisableRain;
//frozen ocean biome
frozenOcean_b:=BiomeGenOcean.Create(10);
frozenOcean_b.setColor($9090a0);
frozenOcean_b.setBiomeName('FrozenOcean');
frozenOcean_b.setMinMaxHeight(-1,0.5);
frozenOcean_b.setTemperatureRainfall(0,0.5);
//frozen river biome
frozenRiver_b:=BiomeGenRiver.Create(11);
frozenRiver_b.setColor($a0a0ff);
frozenRiver_b.setBiomeName('FrozenRiver');
frozenRiver_b.setMinMaxHeight(-0.5,0);
frozenRiver_b.setTemperatureRainfall(0,0.5);
//snow plains biome
icePlains_b:=BiomeGenSnow.Create(12);
icePlains_b.setColor($ffffff);
icePlains_b.setBiomeName('Ice Plains');
icePlains_b.setTemperatureRainfall(0,0.5);
//snow mountains biome
iceMountains_b:=BiomeGenSnow.Create(13);
iceMountains_b.setColor($a0a0a0);
iceMountains_b.setBiomeName('Ice Mountains');
iceMountains_b.setMinMaxHeight(0.2,1.8);
iceMountains_b.setTemperatureRainfall(0,0.5);
//mushroom biome
mushroomIsland_b:=BiomeGenMushroomIsland.Create(14);
mushroomIsland_b.setColor($ff00ff);
mushroomIsland_b.setBiomeName('MushroomIsland');
mushroomIsland_b.setTemperatureRainfall(0.9,1);
mushroomIsland_b.setMinMaxHeight(0.2,1);
//mushroom shore biome
mushroomIslandShore_b:=BiomeGenMushroomIsland.Create(15);
mushroomIslandShore_b.setColor($a000ff);
mushroomIslandShore_b.setBiomeName('MushroomIslandShore');
mushroomIslandShore_b.setTemperatureRainfall(0.9,1);
mushroomIslandShore_b.setMinMaxHeight(-1,0.1);

finalization

ocean_b.Free;
plains_b.Free;
desert_b.Free;
hills_b.Free;
forest_b.Free;
taiga_b.Free;
swampland_b.Free;
river_b.Free;
hell_b.Free;
sky_b.Free;
frozenOcean_b.Free;
frozenRiver_b.Free;
icePlains_b.Free;
iceMountains_b.Free;
mushroomIsland_b.Free;
mushroomIslandShore_b.Free;

end.

unit BiomeCacheBlock_u;

interface

uses BiomeGenBase_u, generation;

type BiomeCacheBlock=class(TObject)
     public
       temperatureValues,rainfallValues:ar_double;
       biomes:ar_BiomeGenBase;
       xPosition,zPosition:integer;
       lastAccessTime:int64;
       constructor Create(cache:TObject; i,j:integer);
       destructor Destroy; override;
       function getBiomeGenAt(i,j:integer):BiomeGenBase;
       function getTemperature(i,j:integer):double;
       function getRainfall(i,j:integer):double;
     end;

     ar_BiomeCacheBlock = array of BiomeCacheBlock;

implementation

uses BiomeCache_u, SysUtils;

constructor BiomeCacheBlock.Create(cache:TObject; i,j:integer);
begin
  if not(cache is BiomeCache) then
  begin
    raise Exception.Create('Parameter "obj" is not an instance of BiomeCache') at @BiomeCacheBlock.Create;
  end;

  setlength(temperatureValues,256);
  setlength(rainfallValues,256);
  setlength(biomes,256);
  xPosition:=i;
  zPosition:=j;
  (BiomeCache(Cache).getWorldChunkManager(BiomeCache(Cache))).getTemperatures(temperatureValues, shll(i,4), shll(j,4), 16, 16);
  (BiomeCache(Cache).getWorldChunkManager(BiomeCache(Cache))).getRainfall(rainfallValues, shll(i,4), shll(j,4), 16, 16);
  (BiomeCache(Cache).getWorldChunkManager(BiomeCache(Cache))).getBiomeGenAt(biomes, shll(i,4), shll(j,4), 16, 16, false);
end;

destructor BiomeCacheBlock.Destroy;
begin
  setlength(temperatureValues,0);
  setlength(rainfallValues,0);
  setlength(biomes,0);
end;

function BiomeCacheBlock.getBiomeGenAt(i,j:integer):BiomeGenBase;
begin
  result:=biomes[(i and $f) or shll((j and $f),4)];
end;

function BiomeCacheBlock.getTemperature(i,j:integer):double;
begin
  result:=temperatureValues[(i and $f) or shll((j and $f),4)];
end;

function BiomeCacheBlock.getRainfall(i,j:integer):double;
begin
  result:=rainfallValues[(i and $f) or shll((j and $f),4)];
end;

end.

unit BiomeGenSwamp_u;

interface

uses BiomeGenBase_u, RandomMCT, WorldGenerator_u;

type  BiomeGenSwamp=class(BiomeGenBase)
      public
        constructor Create(i:integer); override;
        function getRandomWorldGenForTrees(rand:rnd):WorldGenerator; override;
      end;

implementation

constructor BiomeGenSwamp.Create(i:integer);
begin
  inherited Create(i);
  Decorator.treesPerChunk:=2;
  Decorator.flowersPerChunk:=-999;
  Decorator.deadBushPerChunk:=1;
  Decorator.mushroomsPerChunk:=8;
  Decorator.reedsPerChunk:=10;
  Decorator.clayPerChunk:=1;
  Decorator.waterlilyPerChunk:=4;
  field_40256_A:=$e0ff70;
end;

function BiomeGenSwamp.getRandomWorldGenForTrees(rand:rnd):WorldGenerator;
begin
  result:=GenSwamp;
end;

end.

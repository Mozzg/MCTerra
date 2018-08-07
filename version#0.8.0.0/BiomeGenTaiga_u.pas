unit BiomeGenTaiga_u;

interface

uses BiomeGenBase_u, RandomMCT, WorldGenerator_u;

type  BiomeGenTaiga=class(BiomeGenBase)
      public
        constructor Create(i:integer); override;
        function getRandomWorldGenForTrees(rand:rnd):WorldGenerator; override;
      end;

implementation

constructor BiomeGenTaiga.Create(i:integer);
begin
  inherited Create(i);
  decorator.treesPerChunk:=10;
  decorator.grassPerChunk:=1;
end;

function BiomeGenTaiga.getRandomWorldGenForTrees(rand:rnd):WorldGenerator;
begin
  if rand.nextInt(3)=0 then
    result:=GenTaiga1
  else
    result:=GenTaiga2;
end;

end.

unit BiomeGenForest_u;

interface

uses BiomeGenBase_u, WorldGenerator_u, RandomMCT;

type  BiomeGenForest=class(BiomeGenBase)
      public
        constructor Create(i:integer); override;
        function getRandomWorldGenForTrees(rand:rnd):WorldGenerator; override;
      end;

implementation

constructor BiomeGenForest.Create(i:integer);
begin
  inherited Create(i);
  decorator.treesPerChunk:=10;
  decorator.grassPerChunk:=2;
end;

function BiomeGenForest.getRandomWorldGenForTrees(rand:rnd):WorldGenerator;
begin
  if rand.nextInt(5)=0 then
  begin
    result:=GenForest;
    exit;
  end;
  if rand.nextInt(10)=0 then
    result:=GenBigTree
  else
    result:=GenTrees;
end;

end.

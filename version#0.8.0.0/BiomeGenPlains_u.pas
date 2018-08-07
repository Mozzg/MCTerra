unit BiomeGenPlains_u;

interface

uses BiomeGenBase_u;

type  BiomeGenPlains=class(BiomeGenBase)
      public
        constructor Create(i:integer); override;
      end;

implementation

constructor BiomeGenPlains.Create(i:integer);
begin
  inherited Create(i);
  decorator.treesPerChunk:=-999;
  decorator.flowersPerChunk:=4;
  decorator.grassPerChunk:=10;
end;

end.

unit BiomeGenPlains_u;

interface

uses BiomeGenBase_u;

type BiomeGenPlains=class(BiomeGenBase)
     public
       constructor Create(i:integer); override;
     end;

implementation

constructor BiomeGenPlains.Create(i:integer);
begin
  inherited Create(i);
  Decorator.treesPerChunk:=-999;
  Decorator.flowersPerChunk:=4;
  Decorator.grassPerChunk:=10;
end;

end.

unit BiomeGenBeach_u;

interface

uses BiomeGenBase_u;

type BiomeGenBeach=class(BiomeGenBase)
     public
       constructor Create(i:integer); override;
     end;

implementation

constructor BiomeGenBeach.Create(i:integer);
begin
  inherited Create(i);
  topBlock:=12;  //sand
  fillerBlock:=12;  //sand
  
  Decorator.treesPerChunk:=-999;
  Decorator.deadBushPerChunk:=0;
  Decorator.reedsPerChunk:=0;
  Decorator.cactiPerChunk:=0;
end;

end.

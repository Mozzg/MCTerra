unit BiomeGenDesert_u;

interface

uses BiomeGenBase_u;

type BiomeGenDesert=class(BiomeGenBase)
     public
       constructor Create(i:integer); override;
     end;

implementation

constructor BiomeGenDesert.Create(i:integer);
begin
  inherited Create(i);
  topBlock:=12; //sand
  fillerBlock:=12; //sand

  Decorator.treesPerChunk:=-999;
  Decorator.deadBushPerChunk:=2;
  Decorator.reedsPerChunk:=50;
  Decorator.cactiPerChunk:=10;
end;

end.

unit BiomeGenDesert_u;

interface

uses BiomeGenBase_u;

type  BiomeGenDesert=class(BiomeGenBase)
      public
        constructor Create(i:integer); override;
      end;

implementation

constructor BiomeGenDesert.Create(i:integer);
begin
  inherited Create(i);
  topblock:=12;
  fillerblock:=12;
  decorator.treesPerChunk:=-999;
  decorator.deadBushPerChunk:=2;
  Decorator.reedsPerChunk:=50;
  Decorator.cactiPerChunk:=10;
end;

end.

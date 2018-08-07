unit BiomeGenMushroomIsland_u;

interface

uses BiomeGenBase_u;

type  BiomeGenMushroomIsland=class(BiomeGenBase)
      public
        constructor Create(i:integer); override;
      end;

implementation

constructor BiomeGenMushroomIsland.Create(i:integer);
begin
  inherited Create(i);
  Decorator.treesPerChunk:=-100;
  Decorator.flowersPerChunk:=-100;
  Decorator.grassPerChunk:=-100;
  Decorator.mushroomsPerChunk:=1;
  Decorator.field_40718_J:=1;
  topblock:=110;
end;

end.

unit BiomeGenRiver_u;

interface

uses BiomeGenBase_u;

type BiomeGenRiver=class(BiomeGenBase)
     public
       constructor Create(i:integer); override;
     end;

implementation

constructor BiomeGenRiver.Create(i:integer);
begin
  inherited Create(i);
  //todo: dopisat' biome decorator
end;

end.

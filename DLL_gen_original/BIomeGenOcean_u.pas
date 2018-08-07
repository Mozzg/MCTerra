unit BIomeGenOcean_u;

interface

uses BiomeGenBase_u;

type BiomeGenOcean=class(BiomeGenBase)
     public
       constructor Create(i:integer); override;
     end;

implementation

constructor BiomeGenOcean.Create(i:integer);
begin
  inherited Create(i);
end;

end.

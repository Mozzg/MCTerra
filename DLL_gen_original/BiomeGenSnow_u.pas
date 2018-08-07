unit BiomeGenSnow_u;

interface

uses BiomeGenBase_u;

type BiomeGenSnow=class(BiomeGenBase)
     public
       constructor Create(i:integer); override;
     end;

implementation

constructor BiomeGenSnow.Create(i:integer);
begin
  inherited Create(i); 
end;

end.

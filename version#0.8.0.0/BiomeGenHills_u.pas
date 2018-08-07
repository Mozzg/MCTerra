unit BiomeGenHills_u;

interface

uses BiomeGenBase_u;

type  BiomeGenHills=class(BiomeGenBase)
      public
        constructor Create(i:integer); override;
      end;

implementation

constructor BiomeGenHills.Create(i:integer);
begin
  inherited Create(i);
end;

end.

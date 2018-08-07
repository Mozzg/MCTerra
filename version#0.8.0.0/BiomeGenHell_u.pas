unit BiomeGenHell_u;

interface

uses BiomeGenBase_u;

type  BiomeGenHell=class(BiomeGenBase)
      public
        constructor Create(i:integer); override;
      end;

implementation

constructor BiomeGenHell.Create(i:integer);
begin
  inherited Create(i);
end;

end.

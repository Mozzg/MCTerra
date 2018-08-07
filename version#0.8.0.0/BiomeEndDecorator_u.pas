unit BiomeEndDecorator_u;

interface

uses BiomeDecorator_u, WorldGenSpikes_u;

type  BiomeEndDecorator=class(BiomeDecorator)
      private
        spikeGen:WorldGenSpikes;
      public
        constructor Create(biomegen:TObject); override;
        destructor Destroy;
      end;

implementation

constructor BiomeEndDecorator.Create(biomegen:TObject);
begin
  inherited Create(biomegen);
  spikeGen:=WorldGenSpikes.Create(121);
end;

destructor BiomeEndDecorator.Destroy;
begin
  spikeGen.Free;
end;

end.

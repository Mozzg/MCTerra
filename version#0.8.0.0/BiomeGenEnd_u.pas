unit BiomeGenEnd_u;

interface

uses BiomeGenBase_u;

type  BiomeGenEnd=class(BiomeGenBase)
      public
        constructor Create(i:integer); override;
        destructor Destroy; override;
      end;

implementation

uses BiomeEndDecorator_u, WorldGenTrees_u, WorldGenForest_u,
WorldGenBigTree_u, WorldGenSwamp_u, WorldGenTaiga1_u, WorldGenTaiga2_u;

constructor BiomeGenEnd.Create(i:integer);
begin
  topBlock:=3;
  fillerBlock:=3;
  field_6502_q:=$4ee031;
  minHeight:=0.1;
  maxHeight:=0.3;
  temperature:=0.5;
  rainfall:=0.5;
  field_40256_A:=$ffffff;
  enableRain:=true;
  GenTrees:=WorldGenTrees.Create;
  GenForest:=WorldGenForest.Create;
  GenBigTree:=WorldGenBigTree.Create;
  GenSwamp:=WorldGenSwamp.Create;
  GenTaiga1:=WorldGenTaiga1.Create;
  GenTaiga2:=WorldGenTaiga2.Create;
  biomeID:=i;
  biomeList[i]:=Self;
  decorator:=BiomeEndDecorator.Create(@Self);
end;

destructor BiomeGenEnd.Destroy;
begin
  GenTrees.Free;
  GenForest.Free;
  GenBigTree.Free;
  GenSwamp.Free;
  GenTaiga1.Free;
  GenTaiga2.Free;

  decorator.Free;
  biomeName:='';
end;

end.

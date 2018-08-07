unit GenLayerTemperatureMix_u;

interface

uses GenLayer_u, generation;

type GenLayerTemperatureMix=class(GenLayer)
     private
       field_35505_b:GenLayer;
       field_35506_c:integer;
     public
       constructor Create(gen,gen1:GenLayer; i:integer);
       destructor Destroy; override;
       function getInts(i,j,k,l:integer):ar_int; override;
     end;

implementation

uses IntCache_u, BiomeGenBase_u;

constructor GenLayerTemperatureMix.Create(gen,gen1:GenLayer; i:integer);
begin
  inherited Create(0);
  parent:=gen1;
  field_35505_b:=gen;
  field_35506_c:=i;
end;

destructor GenLayerTemperatureMix.Destroy;
begin
  {if field_35505_b<>nil then field_35505_b.Free;
  field_35505_b:=nil;
  if parent<>nil then parent.Free;
  parent:=nil; }
  inherited;
end;

function GenLayerTemperatureMix.getInts(i,j,k,l:integer):ar_int;
var ai,ai1:ar_int;
ai2:par_int;
i1:integer;
begin
  ai:=parent.getInts(i, j, k, l);
  ai1:=field_35505_b.getInts(i, j, k, l);
  ai2:=IntCache_u.getIntCache(k * l);
  for i1:=0 to k*l-1 do
    ai2^[i1]:=(ai1[i1] + (BiomeGenBase_u.biomeList[ai[i1]].getIntTemperature() - ai1[i1]) div (field_35506_c * 2 + 1));

  result:=ai2^;
end;

end.

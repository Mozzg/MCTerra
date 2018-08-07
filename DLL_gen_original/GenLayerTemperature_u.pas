unit GenLayerTemperature_u;

interface

uses GenLayer_u, generation;

type GenLayerTemperature=class(GenLayer)
     public
       constructor Create(gen:GenLayer);
       destructor Destroy; override;
       function getInts(i,j,k,l:integer):ar_int; override;
     end;

implementation

uses IntCache_u, BiomeGenBase_u;

constructor GenLayerTemperature.Create(gen:GenLayer);
begin
  inherited Create(0);
  parent:=gen;
end;

destructor GenLayerTemperature.Destroy;
begin
  //if parent<>nil then parent.Free;
  //parent:=nil;
  inherited;
end;

function GenLayerTemperature.getInts(i,j,k,l:integer):ar_int;
var ai:ar_int;
ai1:par_int;
i1:integer;
begin
  ai:=parent.getInts(i, j, k, l);
  ai1:=IntCache_u.getIntCache(k * l);
  for i1:=0 to k*l-1 do
    ai1^[i1]:=BiomeGenBase_u.biomeList[ai[i1]].getIntTemperature;

  result:=ai1^;
end;

end.

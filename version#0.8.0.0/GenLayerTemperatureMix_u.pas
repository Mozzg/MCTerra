unit GenLayerTemperatureMix_u;

interface

uses GenLayer_u, generation_obsh;

type  GenLayerTemperatureMix=class(GenLayer)
      private
        field_35505_b:GenLayer;
        field_35506_c:integer;
      public
        constructor Create(gen,gen1:GenLayer; i:integer);
        destructor Destroy; override;
        function func_35500_a(i,j,k,l:integer):ar_int; override;
      end;

implementation

uses BiomeGenBase_u, IntCache_u;

constructor GenLayerTemperatureMix.Create(gen,gen1:GenLayer; i:integer);
begin
  inherited Create(0);
  parent:=gen1;
  field_35505_b:=gen;
  field_35506_c:=i;
end;

destructor GenLayerTemperatureMix.Destroy;
begin
  inherited;
  field_35505_b.Free;
end;

function GenLayerTemperatureMix.func_35500_a(i,j,k,l:integer):ar_int;
var ai,ai1:ar_int;
ai2:par_int;
i1:integer;
begin
  ai:=parent.func_35500_a(i, j, k, l);
  ai1:=field_35505_b.func_35500_a(i, j, k, l);
  ai2:=IntCache_u.getIntCache(k * l);
  for i1:=0 to k*l-1 do
    ai2^[i1]:=trunc(ai1[i1] + (BiomeGenBase_u.BiomeList[ai[i1]].func_35474_f() - ai1[i1]) / (field_35506_c * 2 + 1));

  //setlength(ai,0);
  //setlength(ai1,0);
  result:=ai2^;
end;

end.

unit WorldChunkManager_u;

interface

uses GenLayer_u, BiomeGenBase_u, generation_obsh;

type  WorldChunkManager=class(TObject)
      private
        field_34903_b,field_34902_c,temperatureLayer,rainfallLayer:GenLayer;
        cache:TObject;
      public
        field_40541_b:ar_double;
        function func_35557_b(abiomegenbase:ar_BiomeGenBase; i,j,k,l:integer):ar_BiomeGenBase;
        constructor Create; overload;
        constructor Create(l:int64); overload;
        destructor Destroy; reintroduce;
        function loadBlockGeneratorData(abiomegenbase:ar_BiomeGenBase; i,j,k,l:integer):ar_BiomeGenBase;
        function func_35555_a(abiomegenbase:ar_BiomeGenBase; i,j,k,l:integer; flag:boolean):ar_BiomeGenBase;
        function getTemperatures(af:ar_double; i,j,k,l:integer):ar_double;
        function func_40539_b(i,j,k,l:integer):ar_double;
        function getBiomeGenAt(i,j:integer):BiomeGenBase;
        function func_35554_b(i,j,k:integer):extended;
      end;

implementation

uses IntCache_u, BiomeCache_u;

constructor WorldChunkManager.Create;
begin
  cache:=BiomeCache.Create(Self);
end;

constructor WorldChunkManager.Create(l:int64);
var mas:ar_GenLayer;
Layer:GenLayer;
begin
  Self.Create;
  mas:=Layer.func_35497_a(l);
  field_34903_b:=mas[0];
  field_34902_c:=mas[1];
  temperatureLayer:=mas[2];
  rainfallLayer:=mas[3];
end;

destructor WorldChunkManager.Destroy;
begin
  field_34903_b.Free;
  field_34902_c.Free;
  temperatureLayer.Free;
  rainfallLayer.Free;
end;

function WorldChunkManager.func_35554_b(i,j,k:integer):extended;
begin
  result:=BiomeCache(cache).func_35722_b(i,k);
end;

function WorldChunkManager.func_40539_b(i,j,k,l:integer):ar_double;
begin
  field_40541_b:= getTemperatures(field_40541_b, i, j, k, l);
  result:=field_40541_b;
end;

function WorldChunkManager.getBiomeGenAt(i,j:integer):BiomeGenBase;
begin
  result:=BiomeCache(Cache).func_35725_a(i, j);
end;

function WorldChunkManager.getTemperatures(af:ar_double; i,j,k,l:integer):ar_double;
var t:integer;
ai:ar_int;
f:extended;
begin
  IntCache_u.func_35268_a;
  t:=length(af);
  if (t=0)or(t<(k*l)) then setlength(af,k*l);

  ai:=temperatureLayer.func_35500_a(i, j, k, l);
  for t:=0 to k*l-1 do
  begin
    f:=ai[t]/65536;
    if f>1 then f:=1;
    af[t]:=f
  end;

  result:=af;
end;

function WorldChunkManager.func_35557_b(abiomegenbase:ar_BiomeGenBase; i,j,k,l:integer):ar_BiomeGenBase;
var t:integer;
ai:ar_int;
begin
  IntCache_u.func_35268_a;
  t:=length(abiomegenbase);
  if (t=0)or(t<(k*l)) then setlength(abiomegenbase,k*l);
  ai:=field_34903_b.func_35500_a(i, j, k, l);
  for t:=0 to k*l-1 do
    abiomegenbase[t]:=BiomeGenBase_u.biomeList[ai[t]];

  result:=abiomegenbase;
end;

function WorldChunkManager.loadBlockGeneratorData(abiomegenbase:ar_BiomeGenBase; i,j,k,l:integer):ar_BiomeGenBase;
begin
  result:=func_35555_a(abiomegenbase, i, j, k, l, true);
end;

function WorldChunkManager.func_35555_a(abiomegenbase:ar_BiomeGenBase; i,j,k,l:integer; flag:boolean):ar_BiomeGenBase;
var t:integer;
ai:ar_int;
begin
  IntCache_u.func_35268_a;
  t:=length(abiomegenbase);
  if (t=0)or(t<(k*l)) then setlength(abiomegenbase,k*l);

  if (flag)and(k=16)and(l=16)and((i and $F)=0)and((j and $F)=0) then
  begin
    result:=BiomeCache(Cache).func_35723_d(i, j);
    exit;
  end;

  ai:=field_34902_c.func_35500_a(i, j, k, l);
  for t:=0 to k*l-1 do
    abiomegenbase[t]:= BiomeGenBase_u.biomelist[ai[t]];
  result:=abiomegenbase;
end;

end.

unit BiomeCacheBlock_u;

interface

uses generation_obsh, BiomeGenBase_u;

type  BiomeCacheBlock=class(TObject)
      public
        field_35659_a,field_35657_b:ar_double;
        field_35658_c:ar_BiomeGenBase;
        field_35653_f:int64;
        field_35655_d,field_35656_e:integer;
        constructor Create(cache:TObject; i,j:integer);
        destructor Destroy; override;
        function func_35651_a(i,j:integer):BiomeGenBase;
        function func_35650_b(i,j:integer):extended;
        function func_35652_c(i,j:integer):extended;
      end;

implementation

uses BiomeCache_u, WorldChunkManager_u, SysUtils;

constructor BiomeCacheBlock.Create(cache:TObject; i,j:integer);
var manager:WorldChunkManager;
begin
  if not(cache is BiomeCache) then
  begin
    raise Exception.Create('Parameter "obj" is not an instance of BiomeCache') at @BiomeCacheBlock.Create;
  end;

  setlength(field_35659_a,256);
  setlength(field_35657_b,256);
  setlength(field_35658_c,256);
  field_35655_d:= i;
  field_35656_e:= j;
  manager:=BiomeCache_u.getWorldChunkManager(BiomeCache(cache));
  field_35659_a:=manager.getTemperatures(field_35659_a, shll(i,4), shll(j,4), 16, 16);
  //field_35657_b:=manager.getRainfall(field_35657_b, shll(i,4), shll(j,4), 16, 16);
  field_35658_c:=manager.func_35555_a(field_35658_c, shll(i,4), shll(j,4), 16, 16,false);
end;

destructor BiomeCacheBlock.Destroy;
begin
  setlength(field_35659_a,0);
  setlength(field_35657_b,0);
  setlength(field_35658_c,0);
end;

function BiomeCacheBlock.func_35651_a(i,j:integer):BiomeGenBase;
begin
  result:=field_35658_c[(i and $f) or shll((j and $f),4)];
end;

function BiomeCacheBlock.func_35650_b(i,j:integer):extended;
begin
  result:=field_35659_a[(i and $f) or shll((j and $f),4)];
end;

function BiomeCacheBlock.func_35652_c(i,j:integer):extended;
begin
  result:=field_35657_b[(i and $f) or shll((j and $f),4)];
end;

end.

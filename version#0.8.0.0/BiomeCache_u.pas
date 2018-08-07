unit BiomeCache_u;

interface

uses WorldChunkManager_u, LongHashMap_u, BiomeCacheBlock_u,
BiomeGenBase_u;

type  BiomeCache=class(TObject)
      private
        chunkmanager:WorldChunkManager;
        field_35729_b:int64;
        field_35730_c:LongHashMap;
      public
        constructor Create(man:WorldChunkManager);
        destructor Destroy; override;
        function getBiomeCacheBlock(i,j:integer):BiomeCacheBlock;
        function func_35725_a(i,j:integer):BiomeGenBase;
        function func_35722_b(i,j:integer):extended;
        function func_35727_c(i,j:integer):extended;  
        function func_35723_d(i,j:integer):ar_BiomeGenBase;
      end;

function getWorldChunkManager(cache:BiomeCache):WorldChunkManager;

implementation

uses generation_obsh, Windows;

constructor BiomeCache.Create(man:WorldChunkManager);
begin
  field_35729_b:=0;
  field_35730_c:=LongHashMap.Create;
  chunkmanager:=man;
end;

destructor BiomeCache.Destroy;
begin
  field_35730_c.Free;
end;

function BiomeCache.getBiomeCacheBlock(i,j:integer):BiomeCacheBlock;
var l:int64;
CacheBlock:BiomeCacheBlock;
begin
  i:=shrr(i,4);
  j:=shrr(j,4);
  l:=(i and $ffffffff)or(shll_l(j and $ffffffff,32));
  CacheBlock:=BiomeCacheBlock(field_35730_c.getValueByKey(l));
  if CacheBlock=nil then
  begin
    CacheBlock:=BiomeCacheBlock.Create(Self,i,j);
    field_35730_c.add(l,cacheblock);
  end;
  cacheblock.field_35653_f:=gettickcount;
  result:=CacheBlock;
end;

function BiomeCache.func_35725_a(i,j:integer):BiomeGenBase;
var cache:BiomeCacheBlock;
begin
  cache:=getBiomeCacheBlock(i, j);
  result:=cache.func_35651_a(i, j);
end;

function BiomeCache.func_35722_b(i,j:integer):extended;
var cache:BiomeCacheBlock;
begin
  cache:=getBiomeCacheBlock(i, j);
  result:=cache.func_35650_b(i, j);
end;

function BiomeCache.func_35727_c(i,j:integer):extended;
var cache:BiomeCacheBlock;
begin
  cache:=getBiomeCacheBlock(i, j);
  result:=cache.func_35652_c(i, j);
end;

function BiomeCache.func_35723_d(i,j:integer):ar_BiomeGenBase;
var cache:BiomeCacheBlock;
begin
  cache:=getBiomeCacheBlock(i, j);
  result:=cache.field_35658_c;
end;

//------------------------
function getWorldChunkManager(cache:BiomeCache):WorldChunkManager;
begin
  result:=cache.chunkmanager;
end;

end.

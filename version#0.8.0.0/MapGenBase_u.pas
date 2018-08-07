unit MapGenBase_u;

interface

uses RandomMCT, IChunkProvider_u, NBT, WorldChunkManager_u;

type  MapGenBase=class(TObject)
      protected
        manager:WorldChunkManager;
        field_1306_a:integer;
        rand:rnd;
        procedure recursiveGenerate(i,j,k,l:integer; abyte0:ar_type); virtual;
      public     
        constructor Create(man:WorldChunkManager); reintroduce; virtual;
        destructor Destroy; override;
        procedure generate(chunkprovider:IChunkProvider; sid:int64; i,j:integer; abyte0:ar_type);
      end;

implementation

constructor MapGenBase.Create(man:WorldChunkManager);
begin
  field_1306_a:=8;
  rand:=rnd.Create;
  manager:=man;
end;

destructor MapGenBase.Destroy;
begin
  rand.Free;
end;

procedure MapGenBase.generate(chunkprovider:IChunkProvider; sid:int64; i,j:integer; abyte0:ar_type);
var k,i1,j1:integer;
l,l1,l2,l3:int64;
begin
  k:=field_1306_a;
  rand.setSeed(sid);
  l:=rand.nextLong;
  l1:=rand.nextLong;
  for i1:=i-k to i+k do
    for j1:=j-k to j+k do
    begin
      l2:=i1 * l;
      l3:=j1 * l1;
      rand.setSeed(l2 xor l3 xor sid);
      recursiveGenerate(i1, j1, i, j, abyte0);
    end;
end;

procedure MapGenBase.recursiveGenerate(i,j,k,l:integer; abyte0:ar_type);
begin
end;

end.

unit MapGenBase_u;

interface

//uses RandomMCT, generation, WorldChunkManager_u;
uses RandomMCT, generation;

type MapGenBase=class(TObject)
     protected
       range:integer;
       rand:rnd;
       world_sid:int64;
       //manager:WorldChunkManager;
     public
       constructor Create; virtual;
       destructor Destroy; override;
       procedure generate(sid:int64; i,j:integer; abyte0:ar_byte);
       procedure recursiveGenerate(sid:int64; i,j,k,l:integer; abyte0:ar_byte); virtual;
     end;

implementation

constructor MapGenBase.Create;
begin
  range:=8;
  rand:=rnd.Create;
  //manager:=man;
end;

destructor MapGenBase.Destroy;
begin
  rand.Free;
  inherited;
end;

procedure MapGenBase.generate(sid:int64; i,j:integer; abyte0:ar_byte);
var k,i1,j1:integer;
l,l1,l2,l3:int64;
begin
  k:=range;
  world_sid:=sid;
  rand.setSeed(world_sid);
  l:=rand.nextLong();
  l1:=rand.nextLong();
  for i1:=i-k to i+k do
    for j1:=j-k to j+k do
    begin
      l2:=i1 * l;
      l3:=j1 * l1;
      rand.setSeed(l2 xor l3 xor world_sid);
      recursiveGenerate(world_sid, i1, j1, i, j, abyte0);
    end;
end;

procedure MapGenBase.recursiveGenerate(sid:int64; i,j,k,l:integer; abyte0:ar_byte);
begin
end;

end.

unit WorldGenDeadBush_u;

interface

uses WorldGenerator_u, generation, RandomMCT;

type WorldGenDeadBush=class(WorldGenerator)
     private
       deadBushID:integer;
     public
       constructor Create(i:integer);
       function generate(xreg,yreg:integer; map:region; rand:rnd; i,j,k:integer):boolean; override;
     end;

implementation

constructor WorldGenDeadBush.Create(i:integer);
begin
  deadBushID:=i;
end;

function WorldGenDeadBush.generate(xreg,yreg:integer; map:region; rand:rnd; i,j,k:integer):boolean;
var l,i1,j1,k1,l1,t:integer;
begin
  while j>0 do
  begin
    l:=get_block_id(map,xreg,yreg,i,j,k);
    if (l<>0)and(l<>18) then break;
    dec(j);
  end;

  for i1:=0 to 3 do
  begin
    j1:=(i + rand.nextInt(8)) - rand.nextInt(8);
    k1:=(j + rand.nextInt(4)) - rand.nextInt(4);
    l1:=(k + rand.nextInt(8)) - rand.nextInt(8);
    l:=get_block_id(map,xreg,yreg,j1,k1,l1);
    t:=get_block_id(map,xreg,yreg,j1,k1-1,l1);
    if (l=0)and(t=12) then
      set_block_id(map,xreg,yreg,j1, k1, l1, deadBushID);
  end;

  result:=true;
end;

end.

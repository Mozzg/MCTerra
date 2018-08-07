unit WorldGenPumpkin_u;

interface

uses WorldGenerator_u, generation, RandomMCT;

type WorldGenPumpkin=class(WorldGenerator)
     public
       function generate(xreg,yreg:integer; map:region; rand:rnd; i,j,k:integer):boolean; override;
     end;

implementation

function WorldGenPumpkin.generate(xreg,yreg:integer; map:region; rand:rnd; i,j,k:integer):boolean;
var l,i1,j1,k1:integer;
begin
  for l:=0 to 63 do
  begin
    i1:=(i + rand.nextInt(8)) - rand.nextInt(8);
    j1:=(j + rand.nextInt(4)) - rand.nextInt(4);
    k1:=(k + rand.nextInt(8)) - rand.nextInt(8);
    if (get_block_id(map,xreg,yreg,i1, j1, k1)=0)and(get_block_id(map,xreg,yreg,i1, j1 - 1, k1) = 2)then
      set_block_id_data(map,xreg,yreg,i1, j1, k1, 86, rand.nextInt(4));
  end;

  result:=true;
end;

end.

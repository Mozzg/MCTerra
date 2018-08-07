unit WorldGenSand_u;

interface

uses WorldGenerator_u, generation, RandomMCT;

type WorldGenSand=class(WorldGenerator)
     private
       sandID,field_35263_b:integer;
     public
       constructor Create(i,j:integer);
       function generate(xreg,yreg:integer; map:region; rand:rnd; i,j,k:integer):boolean; override;
     end;

implementation

constructor WorldGenSand.Create(i,j:integer);
begin
  sandID:=j;
  field_35263_b:=i;
end;

function WorldGenSand.generate(xreg,yreg:integer; map:region; rand:rnd; i,j,k:integer):boolean;
var t,l,byte0,i1,j1,k1,l1,i2,j2:integer;
begin
  t:=get_block_id(map,xreg,yreg,i,j,k);
  if (t<>8)and(t<>9) then
  begin
    result:=false;
    exit;
  end;

  l:=rand.nextInt(field_35263_b - 2) + 2;
  byte0:=2;
  for i1:=i-l to i+l do
    for j1:=k-l to k+l do
    begin
      k1:=i1 - i;
      l1:=j1 - k;
      if (k1 * k1 + l1 * l1) > (l * l) then continue;
      for i2:=j-byte0 to j+byte0 do
      begin
        j2:=get_block_id(map,xreg,yreg,i1, i2, j1);
        if (j2 = 3)or(j2 = 2)then
          set_block_id(map,xreg,yreg,i1, i2, j1, sandID);
      end;
    end;

  result:=true;
end;

end.

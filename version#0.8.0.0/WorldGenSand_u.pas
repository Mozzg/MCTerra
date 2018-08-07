unit WorldGenSand_u;

interface

uses WorldGenerator_u, generation_obsh, RandomMCT;

type  WorldGenSand=class(WorldGenerator)
      private
        sandID,field_35263_b:integer;
      public
        constructor Create(i,j:integer); reintroduce;
        function generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean; override;
      end; 

implementation

uses generation_spec;

constructor WorldGenSand.Create(i,j:integer);
begin
  sandID:= j;
  field_35263_b:= i;
end;

function WorldGenSand.generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean;
var t,l,i1,j1,k1,l1,i2,j2:integer;
byte0:byte;
begin
  t:=get_block_id(map,xreg,yreg,x,y,z);
  if (t<>8)and(t<>9) then
  begin
    result:=false;
    exit;
  end;

  l:=r.nextInt(field_35263_b - 2) + 2;
  byte0:=2;
  for i1:=x-l to x+l do
    for j1:=z-l to z+l do
    begin
      k1:= i1 - x;
      l1:= j1 - z;
      if(k1 * k1 + l1 * l1 > l * l) then continue;
      for i2:=y-byte0 to y+byte0 do
      begin
        j2:=get_Block_Id(map,xreg,yreg,i1, i2, j1);
        if(j2 = 3)or(j2 = 2) then
          set_block_id(map,xreg,yreg,i1, i2, j1, sandID);
      end;
    end;

  result:=true;
end;

end.

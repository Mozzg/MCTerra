unit WorldGenPumpkin_u;

interface

uses WorldGenerator_u, generation_obsh, RandomMCT;

type  WorldGenPumpkin=class(WorldGenerator)
      public
        constructor Create; override;
        function generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean; override;
      end;

implementation

uses generation_spec;

constructor WorldGenPumpkin.Create;
begin
end;

function WorldGenPumpkin.generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean;
var l,i1,j1,k1:integer;
begin
  for l:=0 to 63 do
  begin
    i1:= (x + r.nextInt(8)) - r.nextInt(8);
    j1:= (y + r.nextInt(4)) - r.nextInt(4);
    k1:= (z + r.nextInt(8)) - r.nextInt(8);
    if(get_block_id(map,xreg,yreg,x,y,z)=0)and(get_block_id(map,xreg,yreg,x,y-1,z)=2) then
      set_block_id_data(map,xreg,yreg,x,y,z,86,r.nextInt(4));
  end;

  result:=true;
end;

end.

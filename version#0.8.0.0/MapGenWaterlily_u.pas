unit MapGenWaterlily_u;

interface

uses WorldGenerator_u, generation_obsh, RandomMCT;

type  MapGenWaterlily=class(WorldGenerator)
      public
        constructor Create; override;
        function generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean; override;
      end;

implementation

uses generation_spec;

constructor MapGenWaterlily.Create;
begin
end;

function MapGenWaterlily.generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean;
var l,i1,j1,k1:integer;
begin
  for l:=0 to 9 do
  begin
    i1:= (x + r.nextInt(8)) - r.nextInt(8);
    j1:= (y + r.nextInt(4)) - r.nextInt(4);
    k1:= (z + r.nextInt(8)) - r.nextInt(8);
    if(get_block_id(map,xreg,yreg,i1,j1,k1)=0)and(get_block_id(map,xreg,yreg,i1,j1-1,k1)=9) then
      set_block_id(map,xreg,yreg,i1, j1, k1, 111);
  end;
end;

end.

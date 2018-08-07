unit WorldGenFlowers_u;


interface

uses WorldGenerator_u, generation_obsh, RandomMCT;

type  WorldGenFlowers=class(WorldGenerator)
      private
        blockid:integer;
      public
        constructor Create(i:integer); reintroduce;
        function generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean; override;
      end;

implementation

uses generation_spec;

constructor WorldGenFlowers.Create(i:integer);
begin
  blockid:=i;
end;

function WorldGenFlowers.generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean;
var i,x1,y1,z1,t:integer;
begin
  for i:=0 to 63 do
  begin
    x1:=(x+r.nextInt(8))-r.nextInt(8);
    y1:=(y+r.nextInt(4))-r.nextInt(4);
    z1:=(z+r.nextInt(8))-r.nextInt(8);

    if get_block_id(map,xreg,yreg,x1,y1,z1)=0 then
    begin
      t:=get_block_id(map,xreg,yreg,x1,y1-1,z1);
      if (t=2)or(t=3)or(t=60) then set_block_id(map,xreg,yreg,x1,y1,z1,blockid);
    end;
  end;

  result:=true;
end;

end.

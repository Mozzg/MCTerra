unit WorldGenCactus_u;

interface

uses WorldGenerator_u, generation_obsh, RandomMCT;

type  WorldGenCactus=class(WorldGenerator)
      public
        constructor Create; override;
        function generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean; override;
      end;

implementation

uses generation_spec;

constructor WorldGenCactus.Create;
begin
end;

function WorldGenCactus.generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean;
var i,j,x1,y1,z1,t1,t2,t3,t4,l:integer;
begin
  for i:=0 to 9 do
  begin
    x1:=(x+r.nextInt(8))-r.nextInt(8);
    y1:=(y+r.nextInt(4))-r.nextInt(4);
    z1:=(z+r.nextInt(8))-r.nextInt(8);

    if get_block_id(map,xreg,yreg,x1,y1-1,z1)<>0 then continue;

    t1:=get_block_id(map,xreg,yreg,x1-1,y1,z1);
    t2:=get_block_id(map,xreg,yreg,x1+1,y1,z1);
    t3:=get_block_id(map,xreg,yreg,x1,y1,z1-1);
    t4:=get_block_id(map,xreg,yreg,x1,y1,z1+1);

    if not((t1 in solid_bl)and
    (t2 in solid_bl)and
    (t3 in solid_bl)and
    (t4 in solid_bl)) then continue;

    l:=1+r.nextInt(r.nextInt(3)+1);
    for j:=0 to l-1 do
      set_block_id(map,xreg,yreg,x1,y1+j,z1,81);
  end;

  result:=true;
end;

end.

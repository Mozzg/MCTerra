unit WorldGenReed_u;


interface

uses WorldGenerator_u, generation_obsh, RandomMCT;

type  WorldGenReed=class(WorldGenerator)
      public
        constructor Create; override;
        function generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean; override;
      end;

implementation

uses generation_spec;

constructor WorldGenReed.Create;
begin
end;

function WorldGenReed.generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean;
var i,j,x1,y1,z1,t,t1,t2,t3,t4,l:integer;
begin
  for i:=0 to 19 do
  begin
    x1:=(x+r.nextInt(4))-r.nextInt(4);
    y1:=y;
    z1:=(z+r.nextInt(4))-r.nextInt(4);

    t:=get_block_id(map,xreg,yreg,x1,y1,z1);
    t1:=get_block_id(map,xreg,yreg,x1-1,y1-1,z1);
    t2:=get_block_id(map,xreg,yreg,x1+1,y1-1,z1);
    t3:=get_block_id(map,xreg,yreg,x1,y1-1,z1-1);
    t4:=get_block_id(map,xreg,yreg,x1,y1-1,z1+1);

    if (t<>0)or((t1<>8)and(t1<>9))or
    ((t2<>8)and(t2<>9))or
    ((t3<>8)and(t3<>9))or
    ((t4<>8)and(t4<>9)) then continue;

    t:=get_block_id(map,xreg,yreg,x1,y1-1,z1);

    if (t<>2)and(t<>3)and(t<>12) then continue;

    l:=2+r.nextInt(r.nextInt(3)+1);
    for j:=0 to l-1 do
      set_block_id(map,xreg,yreg,x1,y1+j,z1,83);
  end;

  result:=true;
end;

end.

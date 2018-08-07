unit WorldGenClay_u;

interface

uses WorldGenerator_u, RandomMCT, generation_obsh;

type  WorldGenClay=class(WorldGenerator)
      private
        clayBlockId,numberOfBlocks:integer;
      public
        constructor Create(i:integer); reintroduce;
        function generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean; override;
      end;

implementation

uses generation_spec;

constructor WorldGenClay.Create(i:integer);
begin
  clayBlockId:=82;
  numberOfBlocks:=i;
end;

function WorldGenClay.generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean;
var t,l,i,j,k,l1,i2:integer;
begin
  t:=get_block_id(map,xreg,yreg,x,y,z);
  if (t=8)or(t=9) then
  begin
    result:=false;
    exit;
  end;

  l:=r.nextInt(numberOfBlocks-2)+2;

  for i:=x-l to x+l do
    for j:=z-l to z+l do
    begin
      l1:=i-x;
      i2:=j-z;
      if (l1*l1+i2*i2)>(l*l) then continue;

      for k:=y-1 to y+1 do
      begin
        t:=get_block_id(map,xreg,yreg,i,k,j);
        if t=3 then set_block_id(map,xreg,yreg,i,k,j,clayBlockId);
      end;
    end;

  result:=true;
end;

end.

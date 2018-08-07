unit WorldGenLiquids_u;

interface

uses WorldGenerator_u, generation_obsh, RandomMCT;

type  WorldGenLiquids=class(WorldGenerator)
      private
        liquidBlockId:integer;
      public
        constructor Create(i:integer); reintroduce;
        function generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean; override;
      end;

implementation

uses generation_spec;

constructor WorldGenLiquids.Create(i:integer);
begin
  liquidBlockId:=i;
end;

function WorldGenLiquids.generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean;
var levo,pravo,pered,zad,l,i1:integer;
begin
  if (get_block_id(map,xreg,yreg,x, y + 1, z)<>1)or(get_block_id(map,xreg,yreg,x, y - 1, z)<>1) then
  begin
    result:=false;
    exit;
  end;

  levo:=get_block_id(map,xreg,yreg,x,y,z);
  if(levo<>0)and(levo<>1)then
  begin
    result:=false;
    exit;
  end;

  levo:=get_block_id(map,xreg,yreg,x-1,y,z);
  pravo:=get_block_id(map,xreg,yreg,x+1,y,z);
  pered:=get_block_id(map,xreg,yreg,x,y,z+1);
  zad:=get_block_id(map,xreg,yreg,x,y,z-1);

  l:=0;
  i1:=0;

  if levo=1 then inc(l);
  if pravo=1 then inc(l);
  if pered=1 then inc(l);
  if zad=1 then inc(l);

  if levo=0 then inc(i1);
  if pravo=0 then inc(i1);
  if pered=0 then inc(i1);
  if zad=0 then inc(i1);

  if (l=3)and(i1=1) then
  begin
    set_block_id_data(map,xreg,yreg,x,y,z,liquidBlockId,0);
  end;

  result:=true;
end;

end.

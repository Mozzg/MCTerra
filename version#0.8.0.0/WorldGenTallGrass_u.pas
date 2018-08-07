unit WorldGenTallGrass_u;

interface

uses WorldGenerator_u, generation_obsh, RandomMCT;

type  WorldGenTallGrass=class(WorldGenerator)
      private
        tallGrassID,tallGrassMetadata:integer;
      public
        constructor Create(i,j:integer); reintroduce;
        function generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean; override;
      end;

implementation

uses generation_spec;

constructor WorldGenTallGrass.Create(i,j:integer);
begin
  tallGrassID:=i;
  tallGrassMetadata:=j;
end;

function WorldGenTallGrass.generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean;
var t,i,j,k,i1,j1,k1,l1:integer;
begin
  i:=x;
  j:=y;
  k:=z;

  t:=get_block_id(map,xreg,yreg,x,y,z);
  while ((t=0)or(t=18))and(y>0) do
  begin
    dec(y);
    t:=get_block_id(map,xreg,yreg,x,y,z);
  end;

  for i1:=0 to 127 do
  begin
    j1:= (i + r.nextInt(8)) - r.nextInt(8);
    k1:= (j + r.nextInt(4)) - r.nextInt(4);
    l1:= (k + r.nextInt(8)) - r.nextInt(8);
    t:=get_block_id(map,xreg,yreg,j1,k1-1,l1);
    if (get_block_id(map,xreg,yreg,j1,k1,l1)=0)and((t=2)or(t=3)or(t=60)) then
      set_block_id_data(map,xreg,yreg,j1, k1, l1, tallGrassID, tallGrassMetadata);
  end;

  result:=true;
end;

end.

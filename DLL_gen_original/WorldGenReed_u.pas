unit WorldGenReed_u;

interface

uses WorldGenerator_u, generation, RandomMCT;

type WorldGenReed=class(WorldGenerator)
     public
       function generate(xreg,yreg:integer; map:region; rand:rnd; i,j,k:integer):boolean; override;
     end;

implementation

function WorldGenReed.generate(xreg,yreg:integer; map:region; rand:rnd; i,j,k:integer):boolean;
var l,i1,j1,k1,l1,i2,t1,t2,t3,t4:integer;
begin
  for l:=0 to 19 do
  begin
    i1:=(i + rand.nextInt(4)) - rand.nextInt(4);
    j1:=j;
    k1:=(k + rand.nextInt(4)) - rand.nextInt(4);

    t1:=get_block_id(map,xreg,yreg,i1-1,j1-1,k1);
    t2:=get_block_id(map,xreg,yreg,i1+1,j1-1,k1);
    t3:=get_block_id(map,xreg,yreg,i1,j1-1,k1-1);
    t4:=get_block_id(map,xreg,yreg,i1,j1-1,k1+1);
    if (get_block_id(map,xreg,yreg,i1, j1, k1)<>0)or((t1<>8)and(t1<>9)and(t2<>8)and(t2<>9)and(t3<>8)and(t3<>9)and(t4<>8)and(t4<>9))then continue;

    l1:=2 + rand.nextInt(rand.nextInt(3) + 1);
    for i2:=0 to l1-1 do
    begin
      t1:=get_block_id(map,xreg,yreg,i1, j1 + i2 - 1, k1);
      if (t1=83)or(t1=2)or(t1=3)or(t1=12) then
        set_block_id(map,xreg,yreg,i1, j1 + i2, k1, 83); 
    end;
  end;

  result:=true;
end;

end.

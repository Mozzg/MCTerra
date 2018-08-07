unit WorldGenForest_u;


interface

uses WorldGenerator_u, generation_obsh, RandomMCT;

type   WorldGenForest=class(WorldGenerator)
       public
         constructor Create; override;
         function generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean; override;
       end;

implementation

uses generation_spec;

constructor WorldGenForest.Create;
begin
end;

function WorldGenForest.generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean;
var len:integer;
i,j,k,t,t1,l3,j4:integer;
flag:boolean;
byte0:byte;
begin
  len:=r.nextInt(3)+5;
  if (y<1)or((y+len+1)>128) then
  begin
    result:=false;
    exit;
  end;

  flag:=true;
  for i:=y to y+len+1 do
  begin
    if flag=false then break;

    if i=y then byte0:=0
    else if i<(y+len-1) then byte0:=2
    else byte0:=1;

    for j:=x-byte0 to x+byte0 do
    begin
      if flag=false then break;

      for k:=z-byte0 to z+byte0 do
      begin
        if flag=false then break;

        t:=get_block_id(map,xreg,yreg,j,i,k);
        if (t<>0)and(t<>18)and(t<>255) then flag:=false;
      end;
    end;
  end;

  if flag=false then
  begin
    result:=false;
    exit;
  end;

  t:=get_block_id(map,xreg,yreg,x,y-1,z);
  if(t<>2)and(t<>3) then
  begin
    result:=false;
    exit;
  end
  else
    set_block_id(map,xreg,yreg,x,y-1,z,3);

  for i:=(y-3+len) to y+len do
  begin
    t:=i-(y+len);
    t1:=trunc(1-t/2);
    for j:=x-t1 to x+t1 do
    begin
      l3:=j-x;
      for k:=z-t1 to z+t1 do
      begin
        j4:=k-z;
        if (abs(l3)<>t1)or(abs(j4)<>t1)or(r.nextInt(2)<>0)and(t<>0) then
          set_block_id_data(map,xreg,yreg,j,i,k,18,2);
      end;
    end;
  end;

  for i:=0 to len-1 do
  begin
    t:=get_block_id(map,xreg,yreg,x,y+i,z);
    if (t=0)or(t=18) then
      set_block_id_data(map,xreg,yreg,x,y+i,z,17,2);
  end;

  result:=true;
end;

end.

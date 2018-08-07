unit WorldGenSwamp_u;


interface

uses WorldGenerator_u, RandomMCT, generation_obsh;

type  WorldGenSwamp=class(WorldGenerator)
      private
        procedure func_35265_a(map:region; xreg,yreg,x,y,z,data:integer);
      public
        constructor Create; override;
        function generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean; override;
      end;

implementation

uses generation_spec;

constructor WorldGenSwamp.Create;
begin
end;

procedure WorldGenSwamp.func_35265_a(map:region; xreg,yreg,x,y,z,data:integer);
var i:integer;
begin
  for i:=y downto y-5 do
    if get_block_id(map,xreg,yreg,x,i,z)=0 then set_block_id_data(map,xreg,yreg,x,i,z,106,data)
    else break;
end;

function WorldGenSwamp.generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean;
var yy,len,t,i,j,k:integer;
i1,i2,i3:integer;
flag:boolean;
byte0:byte;
begin
  len:=r.nextInt(4)+5;

  yy:=y;
  t:=get_block_id(map,xreg,yreg,x,yy-1,z);
  while ((t=8)or(t=9))and(t<>255) do
  begin
    dec(yy);
    t:=get_block_id(map,xreg,yreg,x,yy-1,z);
  end;

  if (yy<1)or((yy+len+1)>128) then
  begin
    result:=false;
    exit;
  end;

  flag:=true;
  for i:=yy to yy+len+1 do
  begin
    if flag=false then break;

    if i=yy then byte0:=0
    else if i<(yy+len-2) then byte0:=3
    else byte0:=1;

    for j:=x-byte0 to x+byte0 do
    begin
      if flag=false then break;

      for k:=z-byte0 to z+byte0 do
      begin
        if flag=false then break;

        t:=get_block_id(map,xreg,yreg,j,i,k);
        if (t=0)or(t=18) then continue;
        if (t=8)or(t=9) then
        begin
          if i>yy then flag:=false else continue;
        end
        else flag:=false;
      end;
    end;
  end;

  if flag=false then
  begin
    result:=false;
    exit;
  end;

  t:=get_block_id(map,xreg,yreg,x,yy-1,z);
  if(t<>2)and(t<>3) then
  begin
    result:=false;
    exit;
  end
  else
    set_block_id(map,xreg,yreg,x,yy-1,z,3);

  for i:=yy-3+len to yy+len do
  begin
    t:=i-(yy+len);
    i1:=trunc(2-t/2);
    for j:=x-i1 to x+i1 do
    begin
      i2:=j-x;
      for k:=z-i1 to z+i1 do
      begin
        i3:=k-z;
        if(abs(i2)<>i1)or(abs(i3)<>i1)or(r.nextInt(2)<>0)and(t<>0) then set_block_id(map,xreg,yreg,j,i,k,18);
      end;
    end;
  end;

  for i:=0 to len-1 do
  begin
    t:=get_block_id(map,xreg,yreg,x,yy+i,z);
    if (t=0)or(t=18)or(t=8)or(t=9) then set_block_id(map,xreg,yreg,x,yy+i,z,17);
  end;

  for i:=yy-3+len to yy+len do
  begin
    t:=i-(yy+len);
    i1:=trunc(2-t/2);
    for j:=x-i1 to x+i1 do
      for k:=z-i1 to z+i1 do
      begin
        if get_block_id(map,xreg,yreg,j,i,k)<>18 then continue;

        if(r.nextInt(4)=0)and(get_block_id(map,xreg,yreg,j-1,i,k)=0) then func_35265_a(map,xreg,yreg,j-1,i,k,8);
        if(r.nextInt(4)=0)and(get_block_id(map,xreg,yreg,j+1,i,k)=0) then func_35265_a(map,xreg,yreg,j+1,i,k,2);
        if(r.nextInt(4)=0)and(get_block_id(map,xreg,yreg,j,i,k-1)=0) then func_35265_a(map,xreg,yreg,j,i,k-1,1);
        if(r.nextInt(4)=0)and(get_block_id(map,xreg,yreg,j,i,k+1)=0) then func_35265_a(map,xreg,yreg,j,i,k+1,4);
      end;
  end;

  result:=true;
end;

end.

unit WorldGenTaiga2_u;


interface

uses generation_obsh, WorldGenerator_u, RandomMCT;

type  WorldGenTaiga2=class(WorldGenerator)
      public
        constructor Create; override;
        function generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean; override;
      end;

implementation

uses generation_spec;

constructor WorldGenTaiga2.Create;
begin
end;

function WorldGenTaiga2.generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean;
var l,i1,j1,k1,i,j,k,j2,t,k2,i3,j4,j5,l5:integer;
flag,flag1:boolean;
begin
  l:=r.nextInt(4)+6;
  if(y<1)or((y+l+1)>128) then
  begin
    result:=false;
    exit;
  end;
  i1:=1+r.nextInt(2);
  j1:=l-i1;
  k1:=2+r.nextInt(2);
  flag:=true;

  for i:=y to y+1+l do
  begin
    if flag=false then break;

    if(i-y)<i1 then j2:=0
    else j2:=k1;
    for j:=x-j2 to x+j2 do
      for k:=z-j2 to z+j2 do
      begin
        if flag=false then break;

        t:=get_block_id(map,xreg,yreg,j,i,k);
        if (t<>0)and(t<>18) then flag:=false;
      end;
  end;

  if flag=false then
  begin
    result:=false;
    exit;
  end;

  t:=get_block_id(map,xreg,yreg,x,y-1,z);
  if(t=2)or(t=3) then
    set_block_id(map,xreg,yreg,x,y-1,z,3)
  else
  begin
    result:=false;
    exit;
  end;

  k2:=r.nextInt(2);
  i3:=1;
  flag1:=false;
  for i:=0 to j1 do
  begin
    j4:=(y+l)-i;
    for j:=x-k2 to x+k2 do
    begin
      j5:=j-x;
      for k:=z-k2 to z+k2 do
      begin
        l5:=k-z;
        if (abs(j5)<>k2)or(abs(l5)<>k2)or(k2<=0) then
          set_block_id_data(map,xreg,yreg,j,j4,k,18,1);
      end;
    end;

    if(k2>=i3) then
    begin
      if flag1 then k2:=1 else k2:=0;
      flag1:=true;
      inc(i3);
      if(i3>k1) then i3:=k1;
    end
    else inc(k2);
  end;

  i3:=r.nextInt(3);
  for i:=0 to l-i3-1 do
  begin
    t:=get_block_id(map,xreg,yreg,x,y+i,z);
    if(t=0)or(t=18) then set_block_id_data(map,xreg,yreg,x,y+i,z,17,1);
  end;

  result:=true;
end;

end.

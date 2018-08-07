unit WorldGenTaiga1_u;


interface

uses WorldGenerator_u, generation_obsh, RandomMCT;

type  WorldGenTaiga1=class(WorldGenerator)
      public
        constructor Create; override;
        function generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean; override;
      end;

implementation

uses generation_spec;

constructor WorldGenTaiga1.Create;
begin
end;

function WorldGenTaiga1.generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean;
var len:integer;
i1,j1,k1,l1,j2,l2,k3,t,k4,i5:integer;
flag:boolean;
begin
  len:=r.nextInt(5)+7;
  i1:=len-r.nextInt(2)-3;
  j1:=len-i1;
  k1:=1+r.nextInt(j1+1);
  flag:=true;

  if (y<1)or((y+len+1)>128) then
  begin
    result:=false;
    exit;
  end;

  for l1:=y to y+1+len do
  begin
    if flag=false then break;

    if (l1-y)<i1 then j2:=0
    else j2:=k1;

    for l2:=x-j2 to x+j2 do
      for k3:=z-j2 to z+j2 do
      begin
        if flag=false then break;

        t:=get_block_id(map,xreg,yreg,l2,l1,k3);
        if(t<>0)and(t<>18) then flag:=false;
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

  j2:=0;
  for l1:=y+len downto y+i1 do
  begin
    for l2:=x-j2 to x+j2 do
    begin
      k4:=l2-x;
      for k3:=z-j2 to z+j2 do
      begin
        i5:=k3-z;
        if (abs(k4)<>j2)or(abs(i5)<>j2)or(j2<=0) then
          set_block_id_data(map,xreg,yreg,l2,l1,k3,18,1);
      end;
    end;

    if(j2>=1)and(l1=y+i1+1) then
    begin
      dec(j2);
      continue;
    end;
    if(j2<k1) then inc(j2);
  end;

  for l1:=0 to len-2 do
  begin
    t:=get_block_id(map,xreg,yreg,x,y+l1,z);
    if(t=0)or(t=18) then set_block_id_data(map,xreg,yreg,x,y+l1,z,17,1);
  end;

  result:=true;
end;

end.

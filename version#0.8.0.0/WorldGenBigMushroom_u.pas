unit WorldGenBigMushroom_u;

interface

uses WorldGenerator_u, generation_obsh, RandomMCT;

type  WorldGenBigMushroom=class(WorldGenerator)
      private
        field_35266_a:integer;
      public
        constructor Create(i:integer); reintroduce; overload;
        constructor Create; overload; override;
        function generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean; override;
      end;

implementation

uses generation_spec;

constructor WorldGenBigMushroom.Create(i:integer);
begin
  field_35266_a:=i;
end;

constructor WorldGenBigMushroom.Create;
begin
  field_35266_a:=-1;
end;

function WorldGenBigMushroom.generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean;
var i,j,k,l,i1,j1,i2,l2,k3,k1,l1,j2,i3,l3,i4,j4,k2,j3:integer;
flag:boolean;
byte0:byte;
begin
  i:=x;
  j:=y;
  k:=z;
  l:= r.nextInt(2);
  if(field_35266_a >= 0) then l:= field_35266_a;
  i1:= r.nextInt(3) + 4;
  flag:= true;
  if(j < 1)or(j + i1 + 1 > 128) then
  begin
    result:=false;
    exit;
  end;
  for j1:=j to j+1+i1 do
  begin
    byte0:=3;
    if j1=j then byte0:=0;
    for i2:=i-byte0 to i+byte0 do
    begin
      if flag=false then break;
      for l2:=k-byte0 to k+byte0 do
      begin
        if flag=false then break;
        if(j1 >= 0)and(j1 < 128) then
        begin
          k3:=get_Block_Id(map,xreg,yreg,i2, j1, l2);
          if(k3 <> 0)and(k3<>18) then
            flag:= false;
        end
        else
          flag:= false;
      end;
    end;
  end;

  if flag=false then
  begin
    result:=false;
    exit;
  end;

  k1:=get_Block_Id(map,xreg,yreg,i, j - 1, k);
  if(k1 <> 3)and(k1<>2)and(k1<>110) then
  begin
    result:=false;
    exit;
  end;
  if (get_block_id(map,xreg,yreg,i,j-1,k) in trans_bl) then
  begin
    result:=false;
    exit;
  end;

  set_Block_id(map,xreg,yreg,i, j - 1, k, 3);
  l1:= j + i1;
  if(l = 1) then l1:= (j + i1) - 3;

  for j2:=l1 to j+i1 do
  begin
    i3:=1;
    if(j2 < j + i1) then inc(i3);
    if(l = 0) then i3:= 3;
    for l3:=i-i3 to i+i3 do
      for i4:=k-i3 to k+i3 do
      begin
        j4:= 5;
        if(l3 = i - i3) then dec(j4);
        if(l3 = i + i3) then inc(j4);
        if(i4 = k - i3) then j4:=j4-3;
        if(i4 = k + i3) then j4:=j4+3;
        if(l = 0)or(j2 < j + i1) then
        begin
          if(((l3 = i - i3)or(l3 = i + i3))and((i4 = k - i3)or(i4 = k + i3))) then continue;
          if((l3 = i - (i3 - 1))and(i4 = k - i3)) then j4:= 1;
          if((l3 = i - i3)and(i4 = k - (i3 - 1))) then j4:= 1;
          if((l3 = i + (i3 - 1))and(i4 = k - i3)) then j4:= 3;
          if((l3 = i + i3)and(i4 = k - (i3 - 1))) then j4:= 3;
          if((l3 = i - (i3 - 1))and(i4 = k + i3)) then j4:= 7;
          if((l3 = i - i3)and(i4 = k + (i3 - 1))) then j4:= 7;
          if((l3 = i + (i3 - 1))and(i4 = k + i3)) then j4:= 9;
          if((l3 = i + i3)and(i4 = k + (i3 - 1))) then j4:= 9;
        end;
        if(j4 = 5)and(j2 < j + i1) then j4:= 0;
        if((j4 <> 0)or(j >= (j + i1) - 1))and(not(get_Block_Id(map,xreg,yreg,l3, j2, i4) in trans_bl)) then
          set_Block_id_data(map,xreg,yreg,l3, j2, i4, 99 + l, j4);
      end;
  end;

  for k2:=0 to i1-1 do
  begin
    j3:=get_Block_Id(map,xreg,yreg,i, j + k2, k);
    if not(j3 in trans_bl) then
      set_block_id_data(map,xreg,yreg,i, j + k2, k, 99 + l, 10);
  end;

  result:=true;
end;

end.

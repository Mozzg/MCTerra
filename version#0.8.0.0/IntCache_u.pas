unit IntCache_u;
//todo: peredelat' spiski v vide massivov ukazayteley, chtobi v pamati sohranalis' izmenennie elementi massivov

interface

uses generation_obsh;

type ar_list=array of ar_int;

function getIntCache(i:integer):par_int;
procedure func_35268_a;

var field_35273_a:integer=256;
field_35271_b,field_35272_c,field_35269_d,field_35270_e:ar_list; 

implementation

var z:integer;

function getIntCache(i:integer):par_int;
var ai:ar_int;
t,t1,t2:integer;
begin
  if i<=256 then
  begin
    if length(field_35271_b)=0 then
    begin
      {setlength(ai,256);
      t:=length(field_35272_c);
      setlength(field_35272_c,t+1);
      setlength(field_35272_c[t],256);
      move(field_35272_c[t][0],ai[0],length(ai)*sizeof(integer));
      result:=ai;
      exit;  }
      t:=length(field_35272_c);
      setlength(field_35272_c,t+1);
      setlength(field_35272_c[t],256);
      result:=@field_35272_c[t];
      exit;
    end
    else
    begin
      t:=length(field_35271_b);
      t1:=length(field_35271_b[t-1]);
      //setlength(ai,t1);
      //move(field_35271_b[t-1][0],ai[0],t1*sizeof(integer));
      t2:=length(field_35272_c);
      setlength(field_35272_c,t2+1);
      setlength(field_35272_c[t2],t1);
      move(field_35271_b[t-1][0],field_35272_c[t2][0],t1*sizeof(integer));
      setlength(field_35271_b,t-1);
      result:=@field_35272_c[t2];
      //move(ai[0],field_35272_c[t2][0],t1*sizeof(integer));
      //setlength(field_35271_b,t-1);
      //result:=ai;
      exit;
    end;
  end;
  if (i>field_35273_a) then
  begin
    field_35273_a:=i;
    for t:=0 to length(field_35269_d)-1 do
      setlength(field_35269_d[t],0);
    setlength(field_35269_d,0);
    for t:=0 to length(field_35270_e)-1 do
      setlength(field_35270_e[t],0);
    setlength(field_35270_e,1);
    setlength(field_35270_e[0],field_35273_a);
    //setlength(field_35270_e[0],field_35273_a);
    //move(ai[0],field_35270_e[0][0],field_35273_a*sizeof(integer));
    //result:=ai;
    result:=@field_35270_e[0];
    exit;
  end;
  if length(field_35269_d)=0 then
  begin
    //setlength(ai,field_35273_a);
    t:=length(field_35270_e);
    setlength(field_35270_e,t+1);
    setlength(field_35270_e[t],field_35273_a);
    //move(ai[0],field_35270_e[t][0],field_35273_a*sizeof(integer));
    //result:=ai;
    result:=@field_35270_e[t];
  end
  else
  begin
    t:=length(field_35269_d);
    t1:=length(field_35269_d[t-1]);
    //setlength(ai,t1);
    //move(field_35269_d[t-1][0],ai[0],t1*sizeof(integer));
    t2:=length(field_35270_e);
    setlength(field_35270_e,t2+1);
    setlength(field_35270_e[t2],t1);
    move(field_35269_d[t-1][0],field_35270_e[t2][0],t1*sizeof(integer));
    setlength(field_35269_d,t-1);
    //result:=ai;
    result:=@field_35270_e[t2];
  end;
end;

procedure func_35268_a;
var t,t1,t2,i:integer;
a1,a2:integer;
begin
  t:=length(field_35269_d);
  if t>0 then setlength(field_35269_d,t-1);
  t:=length(field_35271_b);
  if t>0 then setlength(field_35271_b,t-1);

  {t:=length(field_35269_d);
  t1:=length(field_35270_e);
  setlength(field_35269_d,t+t1);
  for i:=0 to t1-1 do
  begin
    t2:=length(field_35270_e[i]);
    setlength(field_35269_d[t+i],t2);
    move(field_35270_e[i][0],field_35269_d[t+i],t2*sizeof(integer));
  end;

  t:=length(field_35271_b);
  t1:=length(field_35272_c);
  setlength(field_35271_b,t+t1);
  for i:=0 to t1-1 do
  begin
    t2:=length(field_35272_c[i]);
    setlength(field_35271_b[t+i],t2);
    move(field_35272_c[i][0],field_35271_b[t+i],t2*sizeof(integer));
  end;}

  //field_35269_d:=field_35270_e;
  //field_35271_b:=field_35272_c;

  a1:=length(field_35269_d);
  a2:=length(field_35271_b);

  setlength(field_35269_d,a1+length(field_35270_e));
  setlength(field_35271_b,a2+length(field_35272_c));

  {for i:=0 to length(field_35269_d)-1 do
    setlength(field_35269_d[i],length(field_35270_e[i]));
  for i:=0 to length(field_35271_b)-1 do
    setlength(field_35271_b[i],length(field_35272_c[i])); }

  for i:=0 to length(field_35270_e)-1 do
  begin
    t:=length(field_35270_e[i]);
    setlength(field_35269_d[a1+i],t);
    move(field_35270_e[i][0],field_35269_d[a1+i][0],t*sizeof(integer));
  end;
  for i:=0 to length(field_35272_c)-1 do
  begin
    t:=length(field_35272_c[i]);
    setlength(field_35271_b[a2+i],t);
    move(field_35272_c[i][0],field_35271_b[a2+i][0],t*sizeof(integer));
  end;

  for i:=0 to length(field_35270_e)-1 do
    setlength(field_35270_e[i],0);
  setlength(field_35270_e,0);
  for i:=0 to length(field_35272_c)-1 do
    setlength(field_35272_c[i],0);
  setlength(field_35272_c,0);
end;

initialization

begin
  setlength(field_35271_b,0);
  setlength(field_35272_c,0);
  setlength(field_35269_d,0);
  setlength(field_35270_e,0);
end;

finalization

begin
  for z:=0 to length(field_35271_b)-1 do
    setlength(field_35271_b[z],0);
  setlength(field_35271_b,0);
  for z:=0 to length(field_35272_c)-1 do
    setlength(field_35272_c[z],0);
  setlength(field_35272_c,0);
  for z:=0 to length(field_35269_d)-1 do
    setlength(field_35269_d[z],0);
  setlength(field_35269_d,0);
  for z:=0 to length(field_35270_e)-1 do
    setlength(field_35270_e[z],0);
  setlength(field_35270_e,0);
end;

end.

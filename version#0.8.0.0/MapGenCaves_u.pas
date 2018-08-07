unit MapGenCaves_u;

interface

uses MapGenBase_u, NBT;

type  MapGenCaves=class(MapGenBase)
      protected
        procedure recursiveGenerate(i,j,k,l:integer; abyte0:ar_type); override;
      public
        procedure generateCaveNode(l:int64; i,j:integer; abyte0:ar_type; d,d1,d2,f,f1,f2:extended; k,i1:integer; d3:extended);
        procedure generateLargeCaveNode(l:int64; i,j:integer; abyte0:ar_type; d,d1,d2:extended);
      end;

implementation

uses RandomMCT, MathHelper_u;

procedure MapGenCaves.generateLargeCaveNode(l:int64; i,j:integer; abyte0:ar_type; d,d1,d2:extended);
begin
  generateCaveNode(l, i, j, abyte0, d, d1, d2, 1 + rand.nextFloat * 6, 0, 0, -1, -1, 0.5);
end;

procedure MapGenCaves.generateCaveNode(l:int64; i,j:integer; abyte0:ar_type; d,d1,d2,f,f1,f2:extended; k,i1:integer; d3:extended);
var d4,d5,f3,f4,d6,d7,f5,f6,d8a,d9a,d10a,d11,d12,d13,d14:extended;
j1,k1,d8,l1,d9,i2,d10,j2,k2,i3,j3,k3,l2,l3,i4,j4:integer;
random1:rnd;
flag,flag1,flag2,flag3:boolean;
byte0:byte;
label label0;
begin
  d4:= i * 16 + 8;
  d5:= j * 16 + 8;
  f3:= 0;
  f4:= 0;
  random1:=rnd.Create(l);
  if(i1 <= 0) then
  begin
    j1:= field_1306_a * 16 - 16;
    i1:= j1 - random1.nextInt(j1 div 4);
  end;
  flag:=false;
  if(k=-1) then
  begin
    k:= i1 div 2;
    flag:= true;
  end;
  k1:= random1.nextInt(i1 div 2) + i1 div 4;
  flag1:= random1.nextInt(6) = 0;
  while k<i1 do
  begin
    d6:=1.5 + (MathHelper_u.math_sin((k * 3.141593) / i1) * f * 1);
    d7:=d6 * d3;
    f5:=MathHelper_u.math_cos(f2);
    f6:=MathHelper_u.math_sin(f2);
    d:=d+(MathHelper_u.math_cos(f1) * f5);
    d1:=d1+f6;
    d2:=d2+(MathHelper_u.math_sin(f1) * f5);
    if flag1 then f2:=f2*0.92
    else f2:=f2*0.7;
    f2:=f2+(f4 * 0.1);
    f1:=f1+(f3 * 0.1);
    f4:=f4*0.9;
    f3:=f3* 0.75;
    f4:=f4+((random1.nextFloat - random1.nextFloat) * random1.nextFloat * 2);
    f3:=f3+((random1.nextFloat - random1.nextFloat) * random1.nextFloat * 4);
    if(not(flag))and(k=k1)and(f > 1)and(i1 > 0) then
    begin
      generateCaveNode(random1.nextLong, i, j, abyte0, d, d1, d2, random1.nextFloat * 0.5 + 0.5, f1 - 1.570796, f2 / 3, k, i1, 1);
      generateCaveNode(random1.nextLong, i, j, abyte0, d, d1, d2, random1.nextFloat * 0.5 + 0.5, f1 + 1.570796, f2 / 3, k, i1, 1);
      exit;
    end;
    if(not(flag))and(random1.nextInt(4)=0) then
    begin
      inc(k);
      continue;
    end;
    d8a:= d - d4;
    d9a:= d2 - d5;
    d10a:= i1 - k;
    d11:= f + 2 + 16;
    if(((d8a * d8a + d9a * d9a) - d10a * d10a) > (d11 * d11)) then
      exit;
    if(d < d4 - 16 - d6 * 2)or(d2 < d5 - 16 - d6 * 2)or(d > d4 + 16 + d6 * 2)or(d2 > d5 + 16 + d6 * 2) then
    begin
      inc(k);
      continue;
    end;
    d8:= trunc(d - d6) - i * 16 - 1;
    l1:= (trunc(d + d6) - i * 16) + 1;
    d9:= trunc(d1 - d7) - 1;
    i2:= trunc(d1 + d7) + 1;
    d10:= trunc(d2 - d6) - j * 16 - 1;
    j2:= (trunc(d2 + d6) - j * 16) + 1;
    if(d8 < 0) then d8:= 0;
    if(l1 > 16) then l1:= 16;
    if(d9 < 1) then d9:= 1;
    if(i2 > 128 - 8) then i2:= 128 - 8;
    if(d10 < 0) then d10:= 0;
    if(j2 > 16) then j2:= 16;
    flag2:=false;

    for k2:=d8 to l1-1 do
    begin
      if flag2=true then break;
      for i3:=d10 to j2-1 do
      begin
        if flag2=true then break;
        j3:=i2+1;
        while (flag2=false)and(j3>=d9-1) do
        begin
          k3:= (k2 * 16 + i3) * 128 + j3;
          if(j3 < 0)or(j3 >= 128) then
          begin
            dec(j3);
            continue;
          end;
          if(abyte0[k3]=8)or(abyte0[k3]=9) then flag2:=true;
          if(j3 <> d9 - 1)and(k2 <> d8)and(k2 <> l1 - 1)and(i3 <> d10)and(i3 <> j2 - 1) then j3:=d9;
          dec(j3);
        end;
      end;
    end;

    if flag2 then
    begin
      inc(k);
      continue;
    end;

    for l2:=d8 to l1-1 do
    begin
      d12:= (((l2 + i * 16) + 0.5) - d) / d6;
      l3:=d10-1;
    label0:
      inc(l3);
      //for l3:=d10 to j2-1 do
      while l3<j2 do
      begin
        d13:= (((l3 + j * 16) + 0.5) - d2) / d6;
        i4:= (l2 * 16 + l3) * 128 + i2;
        if i4<1 then i4:=1;
        flag3:= false;
        if(d12 * d12 + d13 * d13 >= 1) then
        begin
          inc(l3);
          continue;
        end;
        j4:= i2 - 1;
        repeat
          if(j4 < d9) then goto label0;
          d14:= ((j4 + 0.5) - d1) / d7;
          if(d14 > -0.69999999999999996)and(d12 * d12 + d14 * d14 + d13 * d13 < 1) then
          begin
            byte0:= abyte0[i4];
            if(byte0=2) then flag3:=true;
            if(byte0=1)or(byte0=3)or(byte0=2) then
            begin
              if(j4 < 10) then
                abyte0[i4]:=10
              else
              begin
                abyte0[i4]:= 0;
                if(flag3)and(abyte0[i4 - 1]=3) then
                  abyte0[i4 - 1]:=manager.getBiomeGenAt(l2 + i * 16, l3 + j * 16).topBlock;
              end;
            end;
          end;
          dec(i4);
          dec(j4);
        until false;
      end;
    end;

    if flag then break;

    inc(k);
  end;
end;

procedure MapGenCaves.recursiveGenerate(i,j,k,l:integer; abyte0:ar_type);
var i1,j1,k1,l1:integer;
d,d1,d2,f,f1,f2:extended;
begin
  i1:=rand.nextInt(rand.nextInt(rand.nextInt(40) + 1) + 1);
  if rand.nextInt(15)<>0 then i1:=0;

  for j1:=0 to i1-1 do
  begin
    d:= i * 16 + rand.nextInt(16);
    d1:= rand.nextInt(rand.nextInt(128 - 8) + 8);
    d2:= j * 16 + rand.nextInt(16);
    k1:= 1;
    if(rand.nextInt(4)=0) then
    begin
      generateLargeCaveNode(rand.nextLong, k, l, abyte0, d, d1, d2);
      k1:=k1+rand.nextInt(4);
    end;
    for l1:=0 to k1-1 do
    begin
      f:= rand.nextFloat * 3.141593 * 2;
      f1:= ((rand.nextFloat - 0.5) * 2) / 8;
      f2:= rand.nextFloat * 2 + rand.nextFloat;
      if(rand.nextInt(10)=0) then f2:=f2*(rand.nextFloat * rand.nextFloat * 3 + 1);
      generateCaveNode(rand.nextLong, k, l, abyte0, d, d1, d2, f2, f, f1, 0, 0, 1);
    end;
  end;
end;

end.

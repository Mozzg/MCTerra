unit NoiseGeneratorPerlin_u;

interface

uses NoiseGenerator_u,RandomMCT, generation_obsh;

type NoiseGeneratorPerlin=class(NoiseGenerator)
     private
       permutations:array of integer;
     public
       xCoord,yCoord,zCoord:double;
       constructor Create(random:rnd); overload; override;
       constructor Create; overload; override;
       destructor Destroy; reintroduce;
       function generateNoise(d,d1,d2:double):double;
       function lerp(d,d1,d2:double):double;
       function grad(i:integer;d,d1,d2:double):double;
       function func_4110_a(i:integer;d,d1:double):double;
       function func_801_a(d,d1:double):double;
       procedure func_805_a(var ad:ar_double; d,d1,d2:double; i,j,k:integer; d3,d4,d5,d6:double);
     end;

implementation

constructor NoiseGeneratorPerlin.Create(random:rnd);
var i,k,l:integer;
begin
  setlength(permutations,512);
  xCoord:=random.nextDouble*256;
  yCoord:=random.nextDouble*256;
  zCoord:=random.nextDouble*256;

  for i:=0 to 255 do
    permutations[i]:=i;

  for i:=0 to 255 do  //j
  begin
    k:=random.nextInt(256 - i) + i;
    l:=permutations[i];
    permutations[i]:=permutations[k];
    permutations[k]:=l;
    permutations[i + 256]:=permutations[i];
  end;
end;

constructor NoiseGeneratorPerlin.Create;
begin
  Create(Rnd.Create);
end;

destructor NoiseGeneratorPerlin.Destroy;
begin
  setlength(permutations,0);
end;

function NoiseGeneratorPerlin.generateNoise(d,d1,d2:double):double;
var d3,d4,d5,d6,d7,d8:double;
i,j,k,l,i1,j1:integer;
k1,l1,i2,j2,k2,l2:integer;
begin
  d3:=d+xCoord;
  d4:=d1+yCoord;
  d5:=d2+zCoord;

  i:=trunc(d3);
  j:=trunc(d4);
  k:=trunc(d5);

  if d3<i then
    dec(i);
  if d4<j then
    dec(j);
  if d5<k then
    dec(k);

  l:=i and $FF;
  i1:=j and $FF;
  j1:=k and $FF;

  d3:=d3-i;
  d4:=d4-j;
  d5:=d5-k;

  {double d6 = d3 * d3 * d3 * (d3 * (d3 * 6D - 15D) + 10D);
  double d7 = d4 * d4 * d4 * (d4 * (d4 * 6D - 15D) + 10D);
  double d8 = d5 * d5 * d5 * (d5 * (d5 * 6D - 15D) + 10D); }
  d6:=d3*d3*d3*(d3*(d3*6-15)+10);
  d7:=d4*d4*d4*(d4*(d4*6-15)+10);
  d8:=d5*d5*d5*(d5*(d5*6-15)+10);

  {int k1 = permutations[l] + i1;
  int l1 = permutations[k1] + j1;
  int i2 = permutations[k1 + 1] + j1;
  int j2 = permutations[l + 1] + i1;
  int k2 = permutations[j2] + j1;
  int l2 = permutations[j2 + 1] + j1;}
  k1:=permutations[l] + i1;
  l1:=permutations[k1] + j1;
  i2:=permutations[k1 + 1] + j1;
  j2:=permutations[l + 1] + i1;
  k2:=permutations[j2] + j1;
  l2:=permutations[j2 + 1] + j1;  

  //return lerp(d8, lerp(d7, lerp(d6, grad(permutations[l1], d3, d4, d5), grad(permutations[k2], d3 - 1.0D, d4, d5)), lerp(d6, grad(permutations[i2], d3, d4 - 1.0D, d5), grad(permutations[l2], d3 - 1.0D, d4 - 1.0D, d5))), lerp(d7, lerp(d6, grad(permutations[l1 + 1], d3, d4, d5 - 1.0D), grad(permutations[k2 + 1], d3 - 1.0D, d4, d5 - 1.0D)), lerp(d6, grad(permutations[i2 + 1], d3, d4 - 1.0D, d5 - 1.0D), grad(permutations[l2 + 1], d3 - 1.0D, d4 - 1.0D, d5 - 1.0D))));

  result:=lerp(d8, lerp(d7, lerp(d6, grad(permutations[l1], d3, d4, d5), grad(permutations[k2], d3 - 1, d4, d5)), lerp(d6, grad(permutations[i2], d3, d4 - 1.0, d5), grad(permutations[l2], d3 - 1, d4 - 1, d5))), lerp(d7, lerp(d6, grad(permutations[l1 + 1], d3, d4, d5 - 1), grad(permutations[k2 + 1], d3 - 1, d4, d5 - 1)), lerp(d6, grad(permutations[i2 + 1], d3, d4 - 1, d5 - 1), grad(permutations[l2 + 1], d3 - 1, d4 - 1, d5 - 1))));
end;

function NoiseGeneratorPerlin.lerp(d,d1,d2:double):double;
begin
  result:=d1 + d * (d2 - d1);
end;

function NoiseGeneratorPerlin.grad(i:integer;d,d1,d2:double):double;
var j:integer;
d3,d4:double;
temp:double;
begin
  j:=i and $F;

  if j>=8 then d3:=d1
  else d3:=d;

  if j>=4 then          //d4 = j >= 4 ? j != 12 && j != 14 ? d2 : d : d1;
    if (j<>12)and(j<>14) then d4:=d2
      else d4:=d
  else
    d4:=d1;


  //return ((j & 1) != 0 ? -d3 : d3) + ((j & 2) != 0 ? -d4 : d4);
  if (j and 1)<>0 then temp:=-d3
    else temp:=d3;
  if (j and 2)<>0 then temp:=temp-d4
    else temp:=temp+d4;

  result:=temp;
end;

function NoiseGeneratorPerlin.func_4110_a(i:integer;d,d1:double):double;
var j:integer;
d2,d3,temp:double;
begin
  j:=i and $F;

  //double d2 = (double)(1 - ((j & 8) >> 3)) * d;
  d2:=(1-((j and 8) shr 3))*d;

  //double d3 = j >= 4 ? j != 12 && j != 14 ? d1 : d : 0.0D;
  if j>=4 then
    if (j<>12)and(j<>14) then d3:=d1
      else d3:=d
  else
    d3:=0;

  //return ((j & 1) != 0 ? -d2 : d2) + ((j & 2) != 0 ? -d3 : d3);
  if (j and 1)<>0 then temp:=-d2
    else temp:=d2;
  if (j and 2)<>0 then temp:=temp-d3
    else temp:=temp+d3;

  result:=temp;
end;

function NoiseGeneratorPerlin.func_801_a(d,d1:double):double;
begin
  result:=generateNoise(d, d1, 0);
end;

procedure NoiseGeneratorPerlin.func_805_a(var ad:ar_double; d,d1,d2:double; i,j,k:integer; d3,d4,d5,d6:double);
var //flag,flag1,flag2,flag3,flag4,flag5,flag6,flag7,flag8,flag9:boolean;
d8,d10,d12,d14,d17,d19,d21,d9,d11,d23,d7,d13,d15,d16,d18,d20,d22,d26,d27,d24,d25,d28,d29,d30:double;
j3,i4,j4,k4,l4,j5,l5,l,j1,k1,l1,i1,i2,i5,k5,i6,j6,j7,k7,j2,k2,l2,i3,k3,l3,k6,l6,i7:integer;
begin
  if j=1 then
  begin
    {flag:=false;    //ToDo: vozmozhno ne ispolzuyutsa. Posmotret' esli mozhno ubrat'
    flag1:=false;
    flag2:=false;
    flag3:=false; }

    d8:=0;
    d10:=0;
    j3:=0;
    //double d12 = 1.0D / d6;
    d12:=1/d6;
    for i4:=0 to i-1 do
    begin
      //double d14 = (d + (double)i4) * d3 + xCoord;
      d14:=d+i4*d3+xCoord;
      j4:=trunc(d14);
      if d14<j4 then inc(j4,-1);
      k4:=j4 and $FF;
      d14:=d14-j4;
      //double d17 = d14 * d14 * d14 * (d14 * (d14 * 6D - 15D) + 10D);
      d17:=d14*d14*d14*(d14*(d14*6-15)+10);
      for l4:=0 to k-1 do
      begin
        //double d19 = (d2 + (double)l4) * d5 + zCoord;
        d19:=d2+l4*d5+zCoord;
        j5:=trunc(d19);
        if d19<j5 then inc(j5,-1);
        l5:=j5 and $FF;
        d19:=d19-j5;
        //double d21 = d19 * d19 * d19 * (d19 * (d19 * 6D - 15D) + 10D);
        d21:=d19*d19*d19*(d19*(d19*6-15)+10);
        {int l = permutations[k4] + 0;
        int j1 = permutations[l] + l5;
        int k1 = permutations[k4 + 1] + 0;
        int l1 = permutations[k1] + l5;}
        l:=permutations[k4] + 0;
        j1:=permutations[l] + l5;
        k1:=permutations[k4 + 1] + 0;
        l1:=permutations[k1] + l5;
        {double d9 = lerp(d17, func_4110_a(permutations[j1], d14, d19), grad(permutations[l1], d14 - 1.0D, 0.0D, d19));
        double d11 = lerp(d17, grad(permutations[j1 + 1], d14, 0.0D, d19 - 1.0D), grad(permutations[l1 + 1], d14 - 1.0D, 0.0D, d19 - 1.0D));
        double d23 = lerp(d21, d9, d11);}
        d9:=lerp(d17, func_4110_a(permutations[j1], d14, d19), grad(permutations[l1], d14 - 1, 0, d19));
        d11:=lerp(d17, grad(permutations[j1 + 1], d14, 0, d19 - 1), grad(permutations[l1 + 1], d14 - 1, 0, d19 - 1));
        d23:=lerp(d21, d9, d11);

        ad[j3]:=ad[j3]+(d23 * d12);
        inc(j3);
      end;
    end;
    exit;
  end;

  i1:=0;
  d7:=1/d6;
  i2:=-1;
  {flag4:=false; //ToDO: vozmozhno ubrat'
  flag5:=false;
  flag6:=false;
  flag7:=false;
  flag8:=false;
  flag9:=false; }

  d13:=0;
  d15:=0;
  d16:=0;
  d18:=0;
  for i5:=0 to i-1 do
  begin
    //double d20 = (d + (double)i5) * d3 + xCoord;
    d20:=d+i5*d3+xCoord;
    k5:=trunc(d20);
    if d20<k5 then inc(k5,-1);
    i6:=k5 and $FF;
    d20:=d20-k5;
    //double d22 = d20 * d20 * d20 * (d20 * (d20 * 6D - 15D) + 10D);
    d22:=d20*d20*d20*(d20*(d20*6-15)+10);
    for j6:=0 to k-1 do
    begin
      //double d24 = (d2 + (double)j6) * d5 + zCoord;
      d24:=d2+j6*d5+zCoord;
      k6:=trunc(d24);
      if d24<k6 then inc(k6,-1);
      l6:=k6 and $FF;
      d24:=d24-k6;
      //double d25 = d24 * d24 * d24 * (d24 * (d24 * 6D - 15D) + 10D);
      d25:=d24*d24*d24*(d24*(d24*6-15)+10);
      for i7:=0 to j-1 do
      begin
        //double d26 = (d1 + (double)i7) * d4 + yCoord;
        d26:=d1+i7*d4+yCoord;
        j7:=trunc(d26);
        if d26<j7 then inc(j7,-1);
        k7:=j7 and $FF;
        d26:=d26-j7;
        //double d27 = d26 * d26 * d26 * (d26 * (d26 * 6D - 15D) + 10D);
        d27:=d26*d26*d26*(d26*(d26*6-15)+10);
        if ((i7=0)or(k7<>i2)) then
        begin
          i2:=k7;
          {int j2 = permutations[i6] + k7;
          int k2 = permutations[j2] + l6;
          int l2 = permutations[j2 + 1] + l6;
          int i3 = permutations[i6 + 1] + k7;
          int k3 = permutations[i3] + l6;
          int l3 = permutations[i3 + 1] + l6;}
          j2:=permutations[i6] + k7;
          k2:=permutations[j2] + l6;
          l2:=permutations[j2 + 1] + l6;
          i3:=permutations[i6 + 1] + k7;
          k3:=permutations[i3] + l6;
          l3:=permutations[i3 + 1] + l6;
          {d13 = lerp(d22, grad(permutations[k2], d20, d26, d24), grad(permutations[k3], d20 - 1.0D, d26, d24));
          d15 = lerp(d22, grad(permutations[l2], d20, d26 - 1.0D, d24), grad(permutations[l3], d20 - 1.0D, d26 - 1.0D, d24));
          d16 = lerp(d22, grad(permutations[k2 + 1], d20, d26, d24 - 1.0D), grad(permutations[k3 + 1], d20 - 1.0D, d26, d24 - 1.0D));
          d18 = lerp(d22, grad(permutations[l2 + 1], d20, d26 - 1.0D, d24 - 1.0D), grad(permutations[l3 + 1], d20 - 1.0D, d26 - 1.0D, d24 - 1.0D));}
          d13:=lerp(d22, grad(permutations[k2], d20, d26, d24), grad(permutations[k3], d20 - 1, d26, d24));
          d15:=lerp(d22, grad(permutations[l2], d20, d26 - 1, d24), grad(permutations[l3], d20 - 1, d26 - 1, d24));
          d16:=lerp(d22, grad(permutations[k2 + 1], d20, d26, d24 - 1), grad(permutations[k3 + 1], d20 - 1, d26, d24 - 1));
          d18:=lerp(d22, grad(permutations[l2 + 1], d20, d26 - 1, d24 - 1), grad(permutations[l3 + 1], d20 - 1, d26 - 1, d24 - 1));
        end;
        {double d28 = lerp(d27, d13, d15);
        double d29 = lerp(d27, d16, d18);
        double d30 = lerp(d25, d28, d29);
        ad[i1++] += d30 * d7;}
        d28:=lerp(d27, d13, d15);
        d29:=lerp(d27, d16, d18);
        d30:=lerp(d25, d28, d29);

        ad[i1]:=ad[i1]+(d30*d7);
        inc(i1);
      end;
    end;
  end;
end;

end.

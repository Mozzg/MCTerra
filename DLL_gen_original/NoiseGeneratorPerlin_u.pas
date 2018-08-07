unit NoiseGeneratorPerlin_u;

interface

uses NoiseGenerator_u, RandomMCT, generation;

type NoiseGeneratorPerlin=class(NoiseGenerator)
     private
       permutations:ar_int;
     public
       xcoord,ycoord,zcoord:double;
       constructor Create(rand:rnd); overload; override;
       constructor Create; overload; override;
       destructor Destroy; override;
       function lerp(d,d1,d2:double):double;
       function func_4110_a(i:integer; d,d1:double):double;
       function grad(i:integer; d,d1,d2:double):double;
       procedure func_805_a(var ad:ar_double; d,d1,d2:double; i,j,k:integer; d3,d4,d5,d6:double);
     end;

     ar_NoiseGeneratorPerlin = array of NoiseGeneratorPerlin;

implementation

constructor NoiseGeneratorPerlin.Create(rand:rnd);
var i,j,l,k:integer;
begin
  setlength(permutations,512);
  xcoord:=rand.nextDouble*256;
  ycoord:=rand.nextDouble*256;
  zcoord:=rand.nextDouble*256;  
  for i:=0 to 255 do
    permutations[i]:=i;
  for j:=0 to 255 do
  begin
    k:=rand.nextInt(256 - j) + j;
    l:=permutations[j];
    permutations[j]:=permutations[k];
    permutations[k]:=l;
    permutations[j + 256]:=permutations[j];
  end;
end;

constructor NoiseGeneratorPerlin.Create;
begin
  Self.Create(rnd.Create);
end;

destructor NoiseGeneratorPerlin.Destroy;
begin
  setlength(permutations,0);
  inherited;
end;

function NoiseGeneratorPerlin.lerp(d,d1,d2:double):double;
begin
  result:=d1+d*(d2-d1);
end;

function NoiseGeneratorPerlin.func_4110_a(i:integer; d,d1:double):double;
var j:integer;
d2,d3,temp:double;
begin
  {int j = i & 0xf;
  double d2 = (double)(1 - ((j & 8) >> 3)) * d;
  double d3 = j >= 4 ? j != 12 && j != 14 ? d1 : d : 0.0D;
  return ((j & 1) != 0 ? -d2 : d2) + ((j & 2) != 0 ? -d3 : d3);}
  j:=i and $F;
  d2:=(1-((j and 8) shr 3))*d;
  if j>=4 then
    if (j<>12)and(j<>14) then d3:=d1
      else d3:=d
  else
    d3:=0;
  if (j and 1)<>0 then temp:=-d2
    else temp:=d2;
  if (j and 2)<>0 then temp:=temp-d3
    else temp:=temp+d3;

  result:=temp;
end;

function NoiseGeneratorPerlin.grad(i:integer; d,d1,d2:double):double;
var j:integer;
d3,d4,temp:double;
begin
  {int j = i & 0xf;
  double d3 = j >= 8 ? d1 : d;
  double d4 = j >= 4 ? j != 12 && j != 14 ? d2 : d : d1;
  return ((j & 1) != 0 ? -d3 : d3) + ((j & 2) != 0 ? -d4 : d4);}
  j:=i and $F;
  if j>=8 then d3:=d1
  else d3:=d;

  if j>=4 then
    if (j<>12)and(j<>14) then d4:=d2
    else d4:=d
  else d4:=d1;

  if (j and 1)<>0 then temp:=-d3
  else temp:=d3;
  if (j and 2)<>0 then temp:=temp-d4
  else temp:=temp+d4;

  result:=temp;
end;

procedure NoiseGeneratorPerlin.func_805_a(var ad:ar_double; d,d1,d2:double; i,j,k:integer; d3,d4,d5,d6:double);
var d8,d10,d12,d14,d17,d19,d21,d9,d11,d23,d7,d13,d15,d16,d18,d20,d22,d24,d25,d26,d27,d28,d29,d30:double;
j3,i4,j4,k4,l4,j5,l5,l,j1,k1,l1,i1,i2,i5,k5,i6,j6,k6,l6,i7,j7,k7,j2,k2,l2,i3,k3,l3:integer;
begin
  if (j=1) then
  begin
    d8:=0;
    d10:=0;
    j3:=0;
    d12:=1/d6;
    for i4:=0 to i-1 do
    begin
      d14:=d+i4*d3+xCoord;
      j4:=trunc(d14);
      if (d14<j4) then dec(j4);
      k4:=j4 and $FF;
      d14:=d14-j4;
      d17:=d14*d14*d14*(d14*(d14*6-15)+10);
      for l4:=0 to k-1 do
      begin
        d19:=d2+l4*d5+zCoord;
        j5:=trunc(d19);
        if (d19<j5) then dec(j5);
        l5:=j5 and $FF;
        d19:=d19-j5;
        d21:=d19*d19*d19*(d19*(d19*6-15)+10);
        l:=permutations[k4] + 0;
        j1:=permutations[l] + l5;
        k1:=permutations[k4 + 1] + 0;
        l1:=permutations[k1] + l5;
        d9:=lerp(d17, func_4110_a(permutations[j1], d14, d19), grad(permutations[l1], d14 - 1, 0, d19));
        d11:=lerp(d17, grad(permutations[j1 + 1], d14, 0, d19 - 1), grad(permutations[l1 + 1], d14 - 1, 0, d19 - 1));
        d23:=lerp(d21, d9, d11);
        ad[j3]:=ad[j3]+(d23*d12);
        inc(j3);
      end;
    end;
    exit;
  end;

  i1:=0;
  d7:=1/d6;
  i2:=-1;
  d13:=0;
  d15:=0;
  d16:=0;
  d18:=0;
  for i5:=0 to i-1 do
  begin
    d20:=d+i5*d3+xCoord;
    k5:=trunc(d20);
    if (d20<k5) then dec(k5);
    i6:=k5 and $FF;
    d20:=d20-k5;
    d22:=d20*d20*d20*(d20*(d20*6-15)+10);
    for j6:=0 to k-1 do
    begin
      d24:=d2+j6*d5+zCoord;
      k6:=trunc(d24);
      if (d24<k6) then dec(k6);
      l6:=k6 and $FF;
      d24:=d24-k6;
      d25:=d24*d24*d24*(d24*(d24*6-15)+10);
      for i7:=0 to j-1 do
      begin
        d26:=d1+i7*d4+yCoord;
        j7:=trunc(d26);
        if (d26<j7) then dec(j7);
        k7:=j7 and $FF;
        d26:=d26-j7;
        d27:=d26*d26*d26*(d26*(d26*6-15)+10);
        if((i7=0)or(k7<>i2))then
        begin
          i2:=k7;
          j2:=permutations[i6] + k7;
          k2:=permutations[j2] + l6;
          l2:=permutations[j2 + 1] + l6;
          i3:=permutations[i6 + 1] + k7;
          k3:=permutations[i3] + l6;
          l3:=permutations[i3 + 1] + l6;
          d13:=lerp(d22, grad(permutations[k2], d20, d26, d24), grad(permutations[k3], d20 - 1, d26, d24));
          d15:=lerp(d22, grad(permutations[l2], d20, d26 - 1, d24), grad(permutations[l3], d20 - 1, d26 - 1, d24));
          d16:=lerp(d22, grad(permutations[k2 + 1], d20, d26, d24 - 1), grad(permutations[k3 + 1], d20 - 1, d26, d24 - 1));
          d18:=lerp(d22, grad(permutations[l2 + 1], d20, d26 - 1, d24 - 1), grad(permutations[l3 + 1], d20 - 1, d26 - 1, d24 - 1));
        end;
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

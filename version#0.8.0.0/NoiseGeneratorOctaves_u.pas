unit NoiseGeneratorOctaves_u;

interface

uses NoiseGenerator_u, NoiseGeneratorPerlin_u,RandomMCT,generation_obsh;

type
     NoiseGeneratorOctaves=class(NoiseGenerator)
     private
       generatorCollection:array of NoiseGeneratorPerlin;
       field_1191_b:integer;
     public
       constructor create(rand:rnd; i:integer);
       destructor destroy; override;
       function func_806_a(d,d1:extended):extended;
       //function generateNoiseOctaves(ad:ar_double; d,d1,d2:extended; i,j,k:integer; d3,d4,d5:extended; flat:boolean):ar_double;
       function generateNoiseOctaves(ad:ar_double; i,j,k,l,i1,j1:integer; d,d1,d2:extended; flat:boolean):ar_double;
       function func_4109_a(ad:ar_double; i,j,k,l:integer; d,d1,d2:extended):ar_double;
     end;

implementation

constructor NoiseGeneratorOctaves.create(rand:rnd; i:integer);
var j:integer;
begin
  field_1191_b:=i;
  setlength(generatorCollection,i);
  for j:=0 to i-1 do
    generatorCollection[j]:=NoiseGeneratorPerlin.Create(rand);
end;

destructor NoiseGeneratorOctaves.destroy;
var i:integer;
begin
  for i:=0 to field_1191_b-1 do
    generatorCollection[i].Free;
  setlength(generatorCollection,0);
end;

function NoiseGeneratorOctaves.func_806_a(d,d1:extended):extended;
var i:integer;
d2,d3:extended;
begin
  d2:=0;
  d3:=1;
  for i:=0 to field_1191_b-1 do
  begin
    d2:=d2+generatorCollection[i].func_801_a(d*d3,d1*d3)/d3;
    d3:=d3/2;
  end;
  result:=d2;
end;

//function NoiseGeneratorOctaves.generateNoiseOctaves(ad:ar_double; d,d1,d2:extended; i,j,k:integer; d3,d4,d5:extended; flat:boolean):ar_double;
function NoiseGeneratorOctaves.generateNoiseOctaves(ad:ar_double; i,j,k,l,i1,j1:integer; d,d1,d2:extended; flat:boolean):ar_double;
var l1,t:integer;
d3,d4,d5,d6:extended;
l2,l3:int64;
begin
  if length(ad)=0 then setlength(ad,l*i1*j1)
  else
    for t:=0 to length(ad)-1 do
      ad[t]:=0;

  if flat=false then
  begin
    {d6:=1;
    for l:=0 to field_1191_b-1 do
    begin
      generatorCollection[l].func_805_a(ad, d, d1, d2, i, j, k, d3 * d6, d4 * d6, d5 * d6, d6);
      d6:=d6/2;
    end;  }
    (*double d3 = 1.0D;
        for(int l1 = 0; l1 < field_1191_b; l1++)
        {
            double d4 = (double)i * d3 * d;
            double d5 = (double)j * d3 * d1;
            double d6 = (double)k * d3 * d2;
            long l2 = MathHelper.func_35599_c(d4);
            long l3 = MathHelper.func_35599_c(d6);
            d4 -= l2;
            d6 -= l3;
            l2 %= 0x1000000L;
            l3 %= 0x1000000L;
            d4 += l2;
            d6 += l3;
            generatorCollection[l1].func_805_a(ad, d4, d5, d6, l, i1, j1, d * d3, d1 * d3, d2 * d3, d3);
            d3 /= 2D;
        }    *)
    d3:=1;
    for l1:=0 to field_1191_b-1 do
    begin
      d4:=i*d3*d;
      d5:=j*d3*d1;
      d6:=k*d3*d2;
      l2:=trunc(d4);
      if d4<l2 then l2:=l2-1;
      l3:=trunc(d6);
      if d6<l3 then l3:=l3-1;
      d4:=d4-l2;
      d6:=d6-l3;
      l2:=l2 mod 1000000;
      l3:=l3 mod 1000000;
      d4:=d4+l2;
      d6:=d6+l3;
      generatorCollection[l1].func_805_a(ad, d4, d5, d6, l, i1, j1, d * d3, d1 * d3, d2 * d3, d3);
      d3:=d3/2;
    end;
  end;

  result:=ad;
end;

function NoiseGeneratorOctaves.func_4109_a(ad:ar_double; i,j,k,l:integer; d,d1,d2:extended):ar_double;
begin    
  result:=generateNoiseOctaves(ad,i,10,j,k,1,l,d,1,d1,false);
end;

end.

unit ChunkProviderTest_u;

interface

uses generation, NoiseGeneratorOctaves_u, RandomMCT;

type ChunkProviderTest=class(TObject)
     private
       densities,field_40387_c,field_40384_d,field_40385_e,field_40382_f,field_40383_g:ar_double;
       field_40393_j,field_40394_k,field_40391_l,field_40388_a,field_40386_b:NoiseGeneratorOctaves;
       rand:rnd;
     public
       constructor Create(l:int64);
       destructor Destroy; override;
       procedure generateTerrain(i,j:integer; abyte0:ar_byte);
       function ProvideChunk(i,j:integer; abyte0:ar_byte):boolean;
       function initializeNoiseField(ad:ar_double; i,j,k,l,i1,j1:integer):ar_double;

       procedure generateTerrain_prev(i,j:integer; abyte0:ar_byte);
       function ProvideChunk_prev(i,j:integer; abyte0:ar_byte):boolean;  
     end;

implementation

uses windows;

constructor ChunkProviderTest.Create(l:int64);
begin
  rand:=rnd.Create(l);
  field_40393_j:=NoiseGeneratorOctaves.Create(rand, 16);
  field_40394_k:=NoiseGeneratorOctaves.Create(rand, 16);
  field_40391_l:=NoiseGeneratorOctaves.Create(rand, 8);
  field_40388_a:=NoiseGeneratorOctaves.Create(rand, 10);
  field_40386_b:=NoiseGeneratorOctaves.Create(rand, 16);
end;

destructor ChunkProviderTest.Destroy;
begin
  rand.Free;
  setlength(densities,0);
  setlength(field_40387_c,0);
  setlength(field_40384_d,0);
  setlength(field_40385_e,0);
  setlength(field_40382_f,0);
  setlength(field_40383_g,0);
  field_40393_j.Free;
  field_40394_k.Free;
  field_40391_l.Free;
  field_40388_a.Free;
  field_40386_b.Free;
  inherited;
end;

procedure ChunkProviderTest.generateTerrain(i,j:integer; abyte0:ar_byte);
var byte0,byte1,k,l,i1,j1,k1,l1,i2,j2,c,k2,l2,i3,j3:integer;
d,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,d15,d16:double;
xx,zz,yy:integer;
begin
  (*byte0:=2;
  k:=byte0 + 1;
  byte1:=33;
  l:=byte0 + 1;
  noise6:=initializeNoiseField(noise6, i * byte0, 0, j * byte0, k, byte1, l);
  for i1:=0 to byte0-1 do
    for j1:=0 to byte0-1 do
      for k1:=0 to 31 do
      begin
        d:=0.25;
        d1:=noise6[(((i1 + 0) * l + (j1 + 0)) * byte1 + (k1 + 0))];
        d2:=noise6[(((i1 + 0) * l + (j1 + 1)) * byte1 + (k1 + 0))];
        d3:=noise6[(((i1 + 1) * l + (j1 + 0)) * byte1 + (k1 + 0))];
        d4:=noise6[(((i1 + 1) * l + (j1 + 1)) * byte1 + (k1 + 0))];
        d5:=(noise6[(((i1 + 0) * l + (j1 + 0)) * byte1 + (k1 + 1))] - d1) * d;
        d6:=(noise6[(((i1 + 0) * l + (j1 + 1)) * byte1 + (k1 + 1))] - d2) * d;
        d7:=(noise6[(((i1 + 1) * l + (j1 + 0)) * byte1 + (k1 + 1))] - d3) * d;
        d8:=(noise6[(((i1 + 1) * l + (j1 + 1)) * byte1 + (k1 + 1))] - d4) * d;
        for l1:=0 to 3 do
        begin
          d9:=0.125;
          d10:=d1;
          d11:=d2;
          d12:=(d3 - d1) * d9;
          d13:=(d4 - d2) * d9;
          for i2:=0 to 7 do
          begin
            j2:=((i2 + i1 * 8)shl 11)or((0 + j1 * 8)shl 7)or(k1 * 4 + l1);
            //c:=256;
            c:=128;
            d14:=0.125;
            d15:=d10;
            d16:=(d11 - d10) * d14;
            for k2:=0 to 7 do
            begin
              l2:=0;
              if (d15 > 0) then l2:=1;
              
              xx:=j2 shr 11;
              zz:=(j2-xx*2048)shr 7;
              yy:=(j2-xx*2048-zz*128);
              abyte0[xx+zz*16+yy*256]:=l2;
              //abyte0[j2]:=l2;
              j2:=j2+c;
              d15:=d15+d16;
            end;

            d10:=d10+d12;
            d11:=d11+d13;
          end;

          d1:=d1+d5;
          d2:=d2+d6;
          d3:=d3+d7;
          d4:=d4+d8;
        end;
      end;  *)

  byte0:=2;
  k:= byte0 + 1;
  l:= 128 div 4 + 1;
  i1:= byte0 + 1;
  densities:= initializeNoiseField(densities, i * byte0, 0, j * byte0, k, l, i1);
  for j1:=0 to byte0-1 do
    for k1:=0 to byte0-1 do
      for l1:=0 to 31 do
      begin
        d:= 0.25;
        d1:= densities[((j1 + 0) * i1 + (k1 + 0)) * l + (l1 + 0)];
        d2:= densities[((j1 + 0) * i1 + (k1 + 1)) * l + (l1 + 0)];
        d3:= densities[((j1 + 1) * i1 + (k1 + 0)) * l + (l1 + 0)];
        d4:= densities[((j1 + 1) * i1 + (k1 + 1)) * l + (l1 + 0)];
        d5:= (densities[((j1 + 0) * i1 + (k1 + 0)) * l + (l1 + 1)] - d1) * d;
        d6:= (densities[((j1 + 0) * i1 + (k1 + 1)) * l + (l1 + 1)] - d2) * d;
        d7:= (densities[((j1 + 1) * i1 + (k1 + 0)) * l + (l1 + 1)] - d3) * d;
        d8:= (densities[((j1 + 1) * i1 + (k1 + 1)) * l + (l1 + 1)] - d4) * d;
        for i2:=0 to 3 do
        begin
          d9:= 0.125;
          d10:= d1;
          d11:= d2;
          d12:= (d3 - d1) * d9;
          d13:= (d4 - d2) * d9;
          for j2:=0 to 7 do
          begin
            k2:=((j2 + j1 * 8)shl 11)or((0 + k1 * 8)shl 7)or(l1 * 4 + i2);
            //k2:=((j2 + j1 * 4)shl 11)or((0 + k1 * 4)shl 7)or(l1 * 4 + i2);
            l2:=1 shl 7;
            d14:=0.125;
            d15:=d10;
            d16:=(d11 - d10) * d14;
            for i3:=0 to 7 do
            begin
              j3:=0;
              if (d15 > 0) then j3:=1;

              xx:=k2 shr 11;
              zz:=(k2-xx*2048)shr 7;
              yy:=(k2-xx*2048-zz*128);
              abyte0[xx+zz*16+yy*256]:=j3;
              //abyte0[k2]:=j3;
              k2:=k2+l2;
              d15:=d15+d16;
            end;

            d10:=d10+d12;
            d11:=d11+d13;
          end;

          d1:=d1+d5;
          d2:=d2+d6;
          d3:=d3+d7;
          d4:=d4+d8;
        end;
      end;
end;

function ChunkProviderTest.ProvideChunk(i,j:integer; abyte0:ar_byte):boolean;
begin
  if length(abyte0)<>(16*16*256) then
  begin
    result:=false;
    exit;
  end;

  //i:=i+600;
  //j:=j+600;

  rand.SetSeed(i * 341873128712 + j * 132897987541);

  //zeromemory(abyte0,length(abyte0));

  generateTerrain(i, j, abyte0);

  result:=true;
end;

function ChunkProviderTest.initializeNoiseField(ad:ar_double; i,j,k,l,i1,j1:integer):ar_double;
var d,d1,d8,d10,d11,d12,d13,d14:double;
//d5,d6,d7,d9:double;
//l1,i2:integer;
//f,f1,f2:double;
k1,j2,l2,j3,k3:integer;
begin
  if length(ad)=0 then setlength(ad,l*i1*j1);
  (*
  //Twist gen
  d:=684.41200000000003;
  d1:=684.41200000000003;
  //biome....
  ad1:=1 + rand.nextFloat() * 2;
  ad2:=2 + rand.nextFloat() * 2;
  noise4:=noiseGen6.func_4109_a(noise4, i, k, l, j1, 112.1, 112.1, 4.5);
  noise5:=noiseGen7.func_4109_a(noise5, i, k, l, j1, 600, 280, 4.5);
  //noise5:=noiseGen7.func_4109_a(noise5, i, k, l, j1, 600, 600, 4.5);
  d:=d*2;
  noise1:=noiseGen3.generateNoiseOctaves(noise1, i, j, k, l, i1, j1, d / 60, d1 / 260, d / 80);
  noise2:=noiseGen1.generateNoiseOctaves(noise2, i, j, k, l, i1, j1, d, d1, d);
  noise3:=noiseGen2.generateNoiseOctaves(noise3, i, j, k, l, i1, j1, d, d1, d);
  k1:=0;
  l1:=0;
  i2:=16 div l;
  for j2:=0 to l-1 do
  begin
    k2:=j2 * i2 + i2 div 2;
    for l2:=0 to j1-1 do
    begin
      i3:=l2 * i2 + i2 div 2;
      d2:=ad1;
      d3:=ad2;
      d4:=1 - d3;
      d4:=d4*d4;
      d4:=d4*d4;
      d4:=1 - d4;
      d5:=(noise4[l1] + 256) / 512;
      d5:=d5*d4;
      if (d5 > 1) then d5:=1;
      d6:=noise5[l1] / 9250;
      if (d6 < 0) then d6:=-d6*0.5;
      d6:=d6 * 3 - 2;
      if (d6 > 1)then d6:=1;
      d6:=d6/8;
      d6:=0;
      if (d5 < 0) then d5:=0;
      d5:=d5+0.5;
      d6:=d6 * i1 / 16;
      inc(l1);
      d7:=i1 / 4;
      for j3:=0 to i1-1 do
      begin
        d8:=0;
        d9:=(j3 - d7) * 8 / d5;
        if (d9 < 0) then d9:=d9*-1;
        d10:=noise2[k1] / 128;
        d11:=noise3[k1] / 256;
        d12:=(noise1[k1] / 10 + 1) / 2;
        if (d12 < 0) then d8:=d10
        else if (d12 > 1) then d8:=d11
        else d8:=d10 + (d11 - d10) * d12;
        d8:=d8-8;
        k3:=32;
        if (j3 > i1 - k3) then
        begin
          d13:=(j3 - (i1 - k3)) / (k3 - 1);
          d8:=d8 * (1 - d13) + -28 * d13;
        end;
        k3:=8;
        if (j3 < k3) then
        begin
          d14:=(k3 - j3) / (k3 - 1);
          d8:=d8 * (1 - d14) + -30 * d14;
        end;
        ad[k1]:=d8;
        inc(k1);
      end;
    end;
  end;   *)


  //original end gen
  (*d:=684.41200000000003;
  d1:=684.41200000000003;
  field_40382_f:=field_40388_a.func_4109_a(field_40382_f, i, k, l, j1, 1.121, 1.121, 0.5);
  field_40383_g:=field_40386_b.func_4109_a(field_40383_g, i, k, l, j1, 200, 200, 0.5);
  d:=d*2;
  field_40387_c:=field_40391_l.generateNoiseOctaves(field_40387_c, i, j, k, l, i1, j1, d / 80, d1 / 160, d / 80);
  field_40384_d:=field_40393_j.generateNoiseOctaves(field_40384_d, i, j, k, l, i1, j1, d, d1, d);
  field_40385_e:=field_40394_k.generateNoiseOctaves(field_40385_e, i, j, k, l, i1, j1, d, d1, d);
  k1:=0;
  l1:=0;
  for i2:=0 to l-1 do
    for j2:=0 to j1-1 do
    begin
      d2:=(field_40382_f[l1] + 256) / 512;
      if (d2 > 1) then d2:=1;
      d3:=field_40383_g[l1] / 8000;
      if (d3 < 0) then d3:=-d3*0.29999999999999999;
      d3:=d3 * 3 - 2;
      f:=((i2 + i) - 0) / 1;
      f1:=((j2 + k) - 0) / 1;
      f2:=100 - sqrt(f * f + f1 * f1) * 8;
      if (f2 > 80) then f2:=80;
      if (f2 < -100) then f2:=-100;
      if (d3 > 1) then d3:=1;
      d3:=d3/8;
      d3:=0;
      if (d2 < 0) then d2:=0;
      d2:=d2+0.5;
      d3:=(d3 * i1) / 16;
      inc(l1);
      d4:=i1 / 2;
      for k2:=0 to i1-1 do
      begin
        d5:=0;
        d6:=((k2 - d4) * 8) / d2;
        if (d6 < 0) then d6:=d6*-1;
        d7:=field_40384_d[k1] / 512;
        d8:=field_40385_e[k1] / 512;
        d9:=(field_40387_c[k1] / 10 + 1) / 2;
        if (d9 < 0) then d5:=d7
        else if (d9 > 1) then d5:=d8
        else d5:=d7 + (d8 - d7) * d9;
        d5:=d5-8;
        d5:=d5+f2;
        l2:=2;
        if (k2 > (i1 div 2 - l2)) then
        begin
          d10:=(k2 - (i1 / 2 - l2)) / 64;
          if (d10 < 0) then d10:=0;
          if (d10 > 1) then d10:=1;
          d5:=d5 * (1 - d10) + -3000 * d10;
        end;
        l2:=8;
        if (k2 < l2) then
        begin
          d11:=(l2 - k2) / (l2 - 1);
          d5:=d5 * (1 - d11) + -30 * d11;
        end;
        ad[k1]:=d5;
        inc(k1);
      end;
    end;   *)

  d:=684.41200000000003;
  d1:=684.41200000000003;
  //ad1:=2 + rand.nextFloat() * 2;
  //ad2:=2 + rand.nextFloat() * 2;
  field_40382_f:=field_40388_a.func_4109_a(field_40382_f, i, k, l, j1, 1.121, 1.121, 0.5);
  field_40383_g:=field_40386_b.func_4109_a(field_40383_g, i, k, l, j1, 200, 200, 0.5);     //-------???
  d:=d*2*1.25;
  field_40387_c:=field_40391_l.generateNoiseOctaves(field_40387_c, i, j, k, l, i1, j1, d / 80, d1 / 260, d / 80);   //------???
  field_40384_d:=field_40393_j.generateNoiseOctaves(field_40384_d, i, j, k, l, i1, j1, d, d1, d);
  field_40385_e:=field_40394_k.generateNoiseOctaves(field_40385_e, i, j, k, l, i1, j1, d, d1, d);
  k1 := 0;
  //l1 := 0;
  //i2 := 16 div l;
  for j2:=0 to l-1 do
  begin
    //k2:=j2 * i2 + i2 div 2;
    for l2:=0 to j1-1 do
    begin
      //i3:=l2 * i2 + i2 div 2;
      //d5:=(field_40382_f[l1] + 256) / 512;
      //d5:=d5*d4;
      //if(d5 > 1) then d5:=1;
      //d6:=field_40383_g[l1] / 8000;    //----------+
      //if(d6 < 0) then d6:=-d6 * 0.29999999999999999;     //----------+
      //d6:=d6 * 3 - 2;
      //if(d6 > 1) then d6:=1;
      //d6:=d6/8;
      //d6:=0;
      //if(d5 < 0) then d5:=0;
      //d5:=d5+0.5;
      //d6:=(d6 * i1) / 16;
      //inc(l1);
      //d7:=i1 / 2;          //-------+
      for j3:=0 to i1-1 do
      begin
        //d8:=0;
        //d9:=((j3 - d7) * 8) / d5;
        //if(d9 < 0) then d9:=d9*-1;
        d10:=field_40384_d[k1] / 512;      //---------+  shum po visote
        d11:=field_40385_e[k1] / 640;      //---------+  shum po gorizontali
        d12:=(field_40387_c[k1] / 10 + 1) / 2;
        if(d12 < 0) then d8:=d10
        else if(d12 > 1) then d8:=d11
        else d8:=d10 + (d11 - d10) * d12;
        d8:=d8-8;
        //eto pohozhe dla zakrugleniya ostrovov sverhu
        k3:=32;
        if(j3 > i1 - k3) then
        begin
          d13:=(j3 - (i1 - k3)) / (k3 - 1);
          d8:=d8 * (1 - d13) + -34 * d13;      //---------
        end;
        //eto pohozhe dla zakrugleniya ostrovov snizu
        k3:=8;
        if(j3 < k3) then
        begin
          d14:=(k3 - j3) / (k3 - 1);
          d8:=d8 * (1 - d14) + -34 * d14;      //---------
        end;
        ad[k1]:=d8;
        inc(k1);
      end;
    end;
  end;

  result:=ad;
end;

function ChunkProviderTest.ProvideChunk_prev(i,j:integer; abyte0:ar_byte):boolean;
begin
  if length(abyte0)<>(16*16*128) then
  begin
    result:=false;
    exit;
  end;

  //i:=i+600;
  //j:=j+600;

  rand.SetSeed(i * 341873128712 + j * 132897987541);

  //zeromemory(abyte0,length(abyte0));

  generateTerrain_prev(i, j, abyte0);

  result:=true;
end;

procedure ChunkProviderTest.generateTerrain_prev(i,j:integer; abyte0:ar_byte);
var byte0,k,l,i1,j1,k1,l1,i2,j2,k2,l2,i3,j3:integer;
d,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,d15,d16:double;
begin
  byte0:=2;
  k:= byte0 + 1;
  l:= 128 div 4 + 1;
  i1:= byte0 + 1;
  densities:= initializeNoiseField(densities, i * byte0, 0, j * byte0, k, l, i1);
  for j1:=0 to byte0-1 do
    for k1:=0 to byte0-1 do
      for l1:=0 to 31 do
      begin
        d:= 0.25;
        d1:= densities[((j1 + 0) * i1 + (k1 + 0)) * l + (l1 + 0)];
        d2:= densities[((j1 + 0) * i1 + (k1 + 1)) * l + (l1 + 0)];
        d3:= densities[((j1 + 1) * i1 + (k1 + 0)) * l + (l1 + 0)];
        d4:= densities[((j1 + 1) * i1 + (k1 + 1)) * l + (l1 + 0)];
        d5:= (densities[((j1 + 0) * i1 + (k1 + 0)) * l + (l1 + 1)] - d1) * d;
        d6:= (densities[((j1 + 0) * i1 + (k1 + 1)) * l + (l1 + 1)] - d2) * d;
        d7:= (densities[((j1 + 1) * i1 + (k1 + 0)) * l + (l1 + 1)] - d3) * d;
        d8:= (densities[((j1 + 1) * i1 + (k1 + 1)) * l + (l1 + 1)] - d4) * d;
        for i2:=0 to 3 do
        begin
          d9:= 0.125;
          d10:= d1;
          d11:= d2;
          d12:= (d3 - d1) * d9;
          d13:= (d4 - d2) * d9;
          for j2:=0 to 7 do
          begin
            k2:=((j2 + j1 * 8)shl 11)or((0 + k1 * 8)shl 7)or(l1 * 4 + i2);
            //k2:=((j2 + j1 * 4)shl 11)or((0 + k1 * 4)shl 7)or(l1 * 4 + i2);
            l2:=1 shl 7;
            d14:=0.125;
            d15:=d10;
            d16:=(d11 - d10) * d14;
            for i3:=0 to 7 do
            begin
              j3:=0;
              if (d15 > 0) then j3:=1; 
              {xx:=k2 shr 11;
              zz:=(k2-xx*2048)shr 7;
              yy:=(k2-xx*2048-zz*128);
              abyte0[xx+zz*16+yy*256]:=j3; }
              abyte0[k2]:=j3;
              k2:=k2+l2;
              d15:=d15+d16;
            end;

            d10:=d10+d12;
            d11:=d11+d13;
          end;

          d1:=d1+d5;
          d2:=d2+d6;
          d3:=d3+d7;
          d4:=d4+d8;
        end;
      end;
end;

end.

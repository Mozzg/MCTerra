unit generation_biome_desert;

interface

uses generation_obsh, NBT, generation_spec, windows, zlibex, NoiseGeneratorOctaves_u, sysutils, RandomMCT, math;

function gen_biome_desert_thread(Parameter:pointer):integer;

implementation

var village_counter:integer;

procedure gen_ellipse(xkoord,ykoord:integer; var blocks:array of byte; var sferi:ar_elipse_settings; obj:par_tlights_koord; populated:boolean; sfere_type:integer);
var i,j,k,z,l,f,r:integer;
x1,y1,z1,r_x,r_y,r_z,z11,z22:integer;
b:boolean;
temp:extended;
begin
  for k:=0 to length(sferi)-1 do
  begin
    b:=true;
    for i:=0 to length(sferi[k].chunks)-1 do
    if (sferi[k].chunks[i].x=xkoord)and(sferi[k].chunks[i].y=ykoord) then
    begin
      b:=false;
      break;
    end;

    if b=true then continue;

    x1:=xkoord*16;
    z1:=ykoord*16;
    x1:=sferi[k].x-x1;
    z1:=sferi[k].z-z1;
    y1:=sferi[k].y;
    r_x:=sferi[k].radius_x;
    r_z:=sferi[k].radius_z;
    r_y:=sferi[k].radius_vert;

    for i:=0 to 15 do  //Z        //levo pravo
      for j:=y1-round((r_y/3)*2.5) to y1+round((r_y/3)*2.5) do   //Y
      begin
        if (j<0)or(j>127) then continue;
        temp:=sqr(r_x)*(1-sqr((j-y1)/r_y)-sqr((i-z1)/r_z));
        if temp<0 then continue;
        z11:=x1+round(sqrt(temp));
        z22:=x1-round(sqrt(temp));
        for l:=z22 to z11 do
          if (l>=0)and(l<=15) then
          begin
            if sfere_type=0 then
            begin
              if (j<=sferi[k].waterlevel)and(sferi[k].flooded=true) then f:=9
              else f:=sferi[k].fill_material;
            end
            else if sfere_type=1 then
            begin
              if sferi[k].fill_material=0 then
              begin
                f:=blocks[j+(i*128+(l*2048))];
                if (f=9)or(f=0) then continue;

                if blocks[j+1+(i*128+(l*2048))]=0 then f:=2
                else f:=3;
              end
              else if (sferi[k].fill_material=1)or(sferi[k].fill_material=2) then
              begin
                f:=blocks[j+(i*128+(l*2048))];
                if (f=9)or(f=0) then continue;
                f:=12
              end
              else f:=12;
            end;

            blocks[j+(i*128+(l*2048))]:=f;
          end;
      end;

    for i:=0 to 15 do  //X        //pered zad
      for j:=y1-round((r_y/3)*2.5) to y1+round((r_y/3)*2.5) do   //Y
      begin
        if (j<0)or(j>127) then continue;
        temp:=sqr(r_z)*(1-sqr((i-x1)/r_x)-sqr((j-y1)/r_y));
        if temp<0 then continue;
        z11:=z1+round(sqrt(temp));
        z22:=z1-round(sqrt(temp));
        for l:=z22 to z11 do
          if (l>=0)and(l<=15) then
          begin
            if sfere_type=0 then
            begin
              if (j<=sferi[k].waterlevel)and(sferi[k].flooded=true) then f:=9
              else f:=sferi[k].fill_material;
            end
            else if sfere_type=1 then
            begin
              if sferi[k].fill_material=0 then
              begin
                f:=blocks[j+(l*128+(i*2048))];
                if (f=9)or(f=0) then continue;

                if blocks[j+1+(l*128+(i*2048))]=0 then f:=2
                else f:=3;
              end
              else if (sferi[k].fill_material=1)or(sferi[k].fill_material=2) then
              begin
                f:=blocks[j+(l*128+(i*2048))];
                if (f=9)or(f=0) then continue;
                f:=12
              end
              else f:=12;
            end;

            blocks[j+(l*128+(i*2048))]:=f;
          end;
      end;

    for i:=0 to 15 do  //X               verh niz
      for j:=0 to 15 do //Z
      begin
        temp:=sqr(r_y)*(1-sqr((i-x1)/r_x)-sqr((j-z1)/r_z));
        if temp<0 then continue;
        z11:=y1+round(sqrt(temp));
        z22:=y1-round(sqrt(temp));
        for l:=z22 to z11 do
          if (l>=1)and(l<=126) then
          begin
            if sfere_type=0 then
            begin
              if (l<=sferi[k].waterlevel)and(sferi[k].flooded=true) then f:=9
              else f:=sferi[k].fill_material;
            end
            else if sfere_type=1 then
            begin
              z:=blocks[l+(j*128+(i*2048))];

              if (z=0)or(z=9)or(z=8) then f:=z
              else
                case sferi[k].fill_material of
                0:if (blocks[l+1+(j*128+(i*2048))]=0) then f:=2
                  else f:=3;
                1,2:f:=12;
                end;   

              //zapolnenie ob'ektov
              if (l=117) then
              begin
                r:=random(100);
                if populated=false then
                case sferi[k].fill_material of
                0:begin   //grass oasis
                    case r of
                      0..4:begin   //pal'ma
                             z:=length(obj^);
                             setlength(obj^,z+1);
                             obj^[z].x:=xkoord*16+i;
                             obj^[z].y:=l+1;
                             obj^[z].z:=ykoord*16+j;
                             obj^[z].id:=2;
                           end;
                      5..6:begin   //vipuklost'
                             z:=length(obj^);
                             setlength(obj^,z+1);
                             obj^[z].x:=xkoord*16+i;
                             obj^[z].y:=l+1;
                             obj^[z].z:=ykoord*16+j;
                             obj^[z].id:=4;
                           end;
                      7..18:begin   //trava
                               z:=length(obj^);
                               setlength(obj^,z+1);
                               obj^[z].x:=xkoord*16+i;
                               obj^[z].y:=l+1;
                               obj^[z].z:=ykoord*16+j;
                               obj^[z].id:=3;
                             end;
                    end;
                    //delaem trostnik
                    if (i>0)and(i<15)and(j>0)and(j<15) then
                      if ((blocks[l+((j-1)*128+((i)*2048))]=9)or(blocks[l+((j+1)*128+((i)*2048))]=9)or
                      (blocks[l+((j)*128+((i-1)*2048))]=9)or(blocks[l+((j)*128+((i+1)*2048))]=9))
                      and(random<0.35) then
                      begin
                        z:=length(obj^);
                        setlength(obj^,z+1);
                        obj^[z].x:=xkoord*16+i;
                        obj^[z].y:=l+1;
                        obj^[z].z:=ykoord*16+j;
                        obj^[z].id:=1;           //trostnik
                      end;
                  end;
                1:begin   //sand oasis
                    case r of
                      0..8:begin   //suhaya trava
                             z:=length(obj^);
                             setlength(obj^,z+1);
                             obj^[z].x:=xkoord*16+i;
                             obj^[z].y:=l+1;
                             obj^[z].z:=ykoord*16+j;
                             obj^[z].id:=7;
                           end;
                    end;
                    //delaem trostnik
                    if (i>0)and(i<15)and(j>0)and(j<15) then
                      if ((blocks[l+((j-1)*128+((i)*2048))]=9)or(blocks[l+((j+1)*128+((i)*2048))]=9)or
                      (blocks[l+((j)*128+((i-1)*2048))]=9)or(blocks[l+((j)*128+((i+1)*2048))]=9))
                      and(random<0.48) then
                      begin
                        z:=length(obj^);
                        setlength(obj^,z+1);
                        obj^[z].x:=xkoord*16+i;
                        obj^[z].y:=l+1;
                        obj^[z].z:=ykoord*16+j;
                        obj^[z].id:=1;           //trostnik
                      end;
                  end;
                2:begin   //fake oasis
                    case r of
                      0..3:begin   //mertvaya pal'ma
                             z:=length(obj^);
                             setlength(obj^,z+1);
                             obj^[z].x:=xkoord*16+i;
                             obj^[z].y:=l+1;
                             obj^[z].z:=ykoord*16+j;
                             obj^[z].id:=6;
                           end;
                      4..10:begin   //visohshaya trava
                             z:=length(obj^);
                             setlength(obj^,z+1);
                             obj^[z].x:=xkoord*16+i;
                             obj^[z].y:=l+1;
                             obj^[z].z:=ykoord*16+j;
                             obj^[z].id:=0;
                           end;
                    end;
                  end;
                end;
              end;  
            end;

            blocks[l+(j*128+(i*2048))]:=f;
          end;
      end;
  end;
end;

function get_coord_alt(x,z:integer; sid1,sid2:int64; par1,par2,mul1:extended):integer;
var noise_mas,noise_mas1:ar_double;
octaves,octaves1:NoiseGeneratorOctaves;
rand,rand1:rnd;
e1:extended;
chx,chy,xx,zz,i:integer;
begin
  rand:=rnd.Create(sid1);
  octaves:=NoiseGeneratorOctaves.create(rand,4);
  setlength(noise_mas,256);

  rand1:=rnd.Create(sid2);
  octaves1:=NoiseGeneratorOctaves.create(rand1,4);
  setlength(noise_mas1,256);

  //opredelaem koordinati chanka
  chx:=x;
  chy:=z;
  if chx<0 then inc(chx);
  if chy<0 then inc(chy);
  chx:=chx div 16;
  chy:=chy div 16;
  if (chx<=0)and(x<0) then dec(chx);
  if (chy<=0)and(z<0) then dec(chy);
  //opredelaem koordinati bloka v chanke
  xx:=x mod 16;
  zz:=z mod 16;
  if xx<0 then inc(xx,16);
  if zz<0 then inc(zz,16);

  noise_mas:=octaves.generateNoiseOctaves(noise_mas,(chx)*16,0,(chy)*16,16,1,16,par1,1,par1,false);
  noise_mas1:=octaves1.generateNoiseOctaves(noise_mas1,(chx)*16,0,(chy)*16,16,1,16,par2,1,par2,false);

  for i:=0 to length(noise_mas)-1 do
  begin
    if noise_mas[i]<0 then e1:=-noise_mas[i]
    else e1:=noise_mas[i];

    noise_mas[i]:=64+noise_mas[i]*mul1+noise_mas1[i]*(7-e1);
    if noise_mas[i]<10 then noise_mas[i]:=10;
    if noise_mas[i]>117 then noise_mas[i]:=117;
  end;

  result:=round(noise_mas[z+x*16]);

  rand.Free;
  octaves.Free;
  setlength(noise_mas,0);

  rand1.Free;
  octaves1.Free;
  setlength(noise_mas1,0);
end;

procedure gen_vil1_house1(var map:region; xreg,yreg,x,y,z:integer);
var i,j:integer;
begin
  //delaem pol
  for i:=x-2 to x+2 do
    for j:=z-2 to z+2 do
      set_block_id(map,xreg,yreg,i,y,j,5);

  //delaem stenu
  for i:=x to x+2 do
    for j:=y+1 to y+3 do
      set_block_id(map,xreg,yreg,i,j,z+2,24);

  //delaem ostavshiesa bloki sten
  set_block_id(map,xreg,yreg,x-2,y+1,z+2,24);
  set_block_id(map,xreg,yreg,x-1,y+1,z+2,24);
  set_block_id(map,xreg,yreg,x-1,y+2,z+2,24);
  set_block_id(map,xreg,yreg,x-2,y+1,z+1,24);
  set_block_id(map,xreg,yreg,x-2,y+2,z+1,24);
  set_block_id(map,xreg,yreg,x-1,y+3,z+1,24);
  set_block_id(map,xreg,yreg,x+2,y+1,z+1,24);
  set_block_id(map,xreg,yreg,x+2,y+2,z+1,24);
  set_block_id(map,xreg,yreg,x+2,y+1,z,24);
  set_block_id(map,xreg,yreg,x+2,y+2,z,24);
  set_block_id(map,xreg,yreg,x+2,y+3,z,24);
  for i:=x to x+2 do
    for j:=z-2 to z-1 do
      set_block_id(map,xreg,yreg,i,y+3,j,24);
  set_block_id(map,xreg,yreg,x+1,y+1,z-2,24);
  set_block_id(map,xreg,yreg,x+2,y+1,z-2,24);
  set_block_id(map,xreg,yreg,x+1,y+2,z-2,24);
  set_block_id(map,xreg,yreg,x+2,y+2,z-2,24);
  set_block_id(map,xreg,yreg,x-1,y+1,z-2,24);
  set_block_id(map,xreg,yreg,x-2,y+1,z-2,24);
  set_block_id(map,xreg,yreg,x-2,y+2,z-2,24);
  set_block_id(map,xreg,yreg,x-2,y+3,z-2,24);
  set_block_id(map,xreg,yreg,x-1,y+3,z-2,24);
  set_block_id(map,xreg,yreg,x-2,y+3,z-1,24);

  //delem pautinu
  set_block_id(map,xreg,yreg,x+2,y+3,z+1,30);
  set_block_id(map,xreg,yreg,x-1,y+3,z-1,30);
  set_block_id(map,xreg,yreg,x,y+1,z-2,30);
  set_block_id(map,xreg,yreg,x-1,y+2,z-2,30);

  //delaem dver'
  set_block_id_data(map,xreg,yreg,x-2,y+1,z,64,7);
  set_block_id_data(map,xreg,yreg,x-2,y+2,z,64,15);

  //delaem pesok
  for j:=y+1 to y+2 do
  begin
    set_block_id(map,xreg,yreg,x+1,j,z+1,12);
    set_block_id(map,xreg,yreg,x+1,j,z,12);
    set_block_id(map,xreg,yreg,x,j,z+1,12);
  end;
  set_block_id(map,xreg,yreg,x+1,y+3,z+1,12);
  set_block_id(map,xreg,yreg,x,y+1,z,12);
  set_block_id(map,xreg,yreg,x-1,y+1,z+1,12);
  set_block_id(map,xreg,yreg,x+1,y+1,z-1,12);
  set_block_id(map,xreg,yreg,x+2,y+1,z-1,12);

  //delaem fakel
  set_block_id_data(map,xreg,yreg,x+2,y+2,z-1,50,5);
end;

procedure gen_vil1_house2(var map:region; xreg,yreg,x,y,z:integer);
var i,j:integer;
begin
  //delaem pol
  for i:=x-2 to x+2 do
    for j:=z-2 to z+2 do
      set_block_id(map,xreg,yreg,i,y,j,5);

  //delaem vertikalnie steni
  for i:=y+1 to y+3 do
    for j:=z-2 to z+2 do
    begin
      set_block_id(map,xreg,yreg,x-2,i,j,24);
      set_block_id(map,xreg,yreg,x+2,i,j,24);
    end;
  set_block_id(map,xreg,yreg,x-2,y+1,z,0);
  set_block_id(map,xreg,yreg,x-2,y+2,z,0);
  set_block_id(map,xreg,yreg,x+2,y+3,z,0);
  set_block_id(map,xreg,yreg,x+2,y+2,z,12);
  set_block_id(map,xreg,yreg,x+2,y+3,z-1,30);

  //delaem drugie steni
  set_block_id(map,xreg,yreg,x-1,y+1,z+2,24);
  set_block_id(map,xreg,yreg,x-1,y+2,z+2,24);
  set_block_id(map,xreg,yreg,x,y+1,z+2,24);
  set_block_id(map,xreg,yreg,x+1,y+1,z+2,24);
  set_block_id(map,xreg,yreg,x+1,y+2,z+2,24);
  set_block_id(map,xreg,yreg,x+1,y+3,z+2,24);
  set_block_id(map,xreg,yreg,x-1,y+1,z-2,24);
  set_block_id(map,xreg,yreg,x-1,y+2,z-2,24);
  set_block_id(map,xreg,yreg,x,y+1,z-2,24);
  set_block_id(map,xreg,yreg,x+1,y+1,z-2,24);
  set_block_id(map,xreg,yreg,x+1,y+2,z-2,24);
  set_block_id(map,xreg,yreg,x+1,y+3,z-2,30);

  //delaem pesok
  for j:=z-1 to z+1 do
  begin
    set_block_id(map,xreg,yreg,x,y+1,j,12);
    set_block_id(map,xreg,yreg,x+1,y+1,j,12);
    set_block_id(map,xreg,yreg,x+1,y+2,j,12);
    set_block_id(map,xreg,yreg,x+3,y+1,j,12);
  end;

  //delaem fakel
  set_block_id_data(map,xreg,yreg,x+1,y+3,z+1,50,2);
end;

procedure gen_vil1_house3(var map:region; xreg,yreg,x,y,z:integer);
var i,j:integer;
begin
  //delaem pol
  for i:=x-4 to x+4 do
    for j:=z-3 to z+3 do
      set_block_id(map,xreg,yreg,i,y,j,5);

  //delaem bloki sten
  set_block_id(map,xreg,yreg,x-3,y+1,z-3,24);
  set_block_id(map,xreg,yreg,x-4,y+1,z-3,24);
  set_block_id(map,xreg,yreg,x-4,y+1,z-2,24);
  set_block_id(map,xreg,yreg,x-4,y+1,z,24);
  set_block_id(map,xreg,yreg,x-4,y+1,z+1,24);
  set_block_id(map,xreg,yreg,x-4,y+1,z+2,24);
  set_block_id(map,xreg,yreg,x-3,y+1,z+3,24);
  set_block_id(map,xreg,yreg,x-2,y+1,z+3,24);
  set_block_id(map,xreg,yreg,x-1,y+1,z+3,24);
  set_block_id(map,xreg,yreg,x+1,y+1,z+3,24);
  set_block_id(map,xreg,yreg,x+3,y+1,z+3,24);
  set_block_id(map,xreg,yreg,x+4,y+1,z+3,24);
  set_block_id(map,xreg,yreg,x+4,y+1,z+2,24);
  set_block_id(map,xreg,yreg,x+4,y+1,z-1,24);
  set_block_id(map,xreg,yreg,x+4,y+1,z-2,24);
  set_block_id(map,xreg,yreg,x+4,y+1,z-3,24);
  set_block_id(map,xreg,yreg,x+4,y+2,z-3,24);
  set_block_id(map,xreg,yreg,x+3,y+1,z-3,24);
  set_block_id(map,xreg,yreg,x+3,y+2,z-3,24);
  set_block_id(map,xreg,yreg,x+1,y+1,z-3,24);
  set_block_id(map,xreg,yreg,x+2,y+1,z-3,24);
  set_block_id(map,xreg,yreg,x,y+1,z-3,24);
  set_block_id(map,xreg,yreg,x,y+2,z-3,24);
  set_block_id(map,xreg,yreg,x-1,y+1,z-3,24);
  set_block_id(map,xreg,yreg,x-1,y+2,z-3,24);

  //delaem dver'
  set_block_id_data(map,xreg,yreg,x-2,y+1,z-3,64,1);
  set_block_id_data(map,xreg,yreg,x-2,y+2,z-3,64,9);

  //delaem pesok
  set_block_id(map,xreg,yreg,x-3,y+1,z+1,12);
  set_block_id(map,xreg,yreg,x-3,y+1,z+2,12);
  set_block_id(map,xreg,yreg,x-2,y+1,z+2,12);
  set_block_id(map,xreg,yreg,x-3,y+2,z+2,12);

  //delaem fakel
  set_block_id_data(map,xreg,yreg,x-2,y+1,z+1,50,5);
end;

procedure gen_vil1_house4(var map:region; xreg,yreg,x,y,z:integer);
var i,j:integer;
begin
  //delaem osnovanie
  for i:=x-2 to x+2 do
    for j:=z-2 to z+2 do
    begin
      if (i=x-2)or(i=x+2)or(j=z-2)or(j=z+2) then set_block_id(map,xreg,yreg,i,y+1,j,24)
      else set_block_id(map,xreg,yreg,i,y+1,j,12);
    end;
  set_block_id(map,xreg,yreg,x-1,y+2,z-2,24);
  set_block_id(map,xreg,yreg,x,y+2,z-2,24);
  for i:=z to z+2 do
    for j:=y+2 to y+3 do
      set_block_id(map,xreg,yreg,x-2,j,i,24);
  set_block_id(map,xreg,yreg,x-2,y+2,z-1,24);

  //delaem pesok
  set_block_id(map,xreg,yreg,x-1,y+1,z+3,12);
  set_block_id(map,xreg,yreg,x-1,y+1,z+2,12);
  set_block_id(map,xreg,yreg,x,y+1,z+2,12);
  set_block_id(map,xreg,yreg,x+2,y+1,z,12);
  set_block_id(map,xreg,yreg,x,y+2,z-1,12);
  set_block_id(map,xreg,yreg,x,y+2,z,12);
  set_block_id(map,xreg,yreg,x,y+2,z+1,12);
  set_block_id(map,xreg,yreg,x-1,y+2,z,12);
  set_block_id(map,xreg,yreg,x-1,y+2,z+1,12);
  set_block_id(map,xreg,yreg,x-1,y+2,z+2,12);
  set_block_id(map,xreg,yreg,x-1,y+3,z,12);
  set_block_id(map,xreg,yreg,x-1,y+3,z+1,12);

  //delaem pautinu
  set_block_id(map,xreg,yreg,x-1,y+3,z-2,30);
  set_block_id(map,xreg,yreg,x-2,y+3,z-1,30);

  //delaem fakel
  set_block_id_data(map,xreg,yreg,x+1,y+2,z-2,50,5);
end;

procedure gen_vil1_house5(var map:region; xreg,yreg,x,y,z:integer);
var i,j:integer;
begin
  //delaem steni
  for i:=x-2 to x+2 do
  begin
    for j:=y+1 to y+3 do
      set_block_id(map,xreg,yreg,i,j,z+2,24);
    set_block_id(map,xreg,yreg,i,y+1,z-2,24);
  end;
  for j:=z-1 to z+1 do
    for i:=y+1 to y+2 do
      set_block_id(map,xreg,yreg,x-2,i,j,24);
  set_block_id(map,xreg,yreg,x-2,y+3,z+1,24);
  set_block_id(map,xreg,yreg,x-1,y+2,z-2,24);
  set_block_id(map,xreg,yreg,x-2,y+2,z-2,24);
  set_block_id(map,xreg,yreg,x-2,y+3,z-2,24);
  set_block_id(map,xreg,yreg,x+2,y+2,z-1,24);
  set_block_id(map,xreg,yreg,x+2,y+2,z-2,24);
  set_block_id(map,xreg,yreg,x+2,y+3,z-2,24); 
  set_block_id(map,xreg,yreg,x+2,y+1,z-1,24);
  set_block_id(map,xreg,yreg,x+2,y+1,z+1,24);

  //delaem pesok
  for i:=x-1 to x+1 do
    for j:=z-1 to z+1 do
    begin
      if (i=x-1)and(j=z) then continue;
      set_block_id(map,xreg,yreg,i,y+1,j,12);
    end;
  set_block_id(map,xreg,yreg,x-1,y+2,z-1,12);
  set_block_id(map,xreg,yreg,x-2,y+3,z-1,12);

  //delaem pautinu
  set_block_id(map,xreg,yreg,x+2,y+3,z-1,30);
  set_block_id(map,xreg,yreg,x+1,y+2,z-2,30);
  set_block_id(map,xreg,yreg,x+1,y+3,z-2,30);
  set_block_id(map,xreg,yreg,x,y+2,z-2,30);

  //delaem dver'
  set_block_id_data(map,xreg,yreg,x+2,y+1,z,64,5);
  set_block_id_data(map,xreg,yreg,x+2,y+2,z,64,13);

  //delaem fakel
  set_block_id_data(map,xreg,yreg,x-1,y+2,z+1,50,1);  
end;

procedure gen_vil2_house1(var map:region; xreg,yreg,x,y,z:integer);
var i,j,k:integer;
begin
  //delaem pol, steni i potolok
  for i:=x-2 to x+2 do
    for j:=z-2 to z+2 do
    begin
      set_block_id(map,xreg,yreg,i,y,j,5);
      for k:=y+1 to y+3 do
        if (i=x-2)or(i=x+2)or(j=z-2)or(j=z+2)or(k=y+3) then set_block_id(map,xreg,yreg,i,k,j,24);
    end;

  //virezaem dirki v stenah i stavim pautinu
  set_block_id(map,xreg,yreg,x-2,y+3,z+1,30);
  set_block_id(map,xreg,yreg,x+1,y+3,z,30);
  set_block_id(map,xreg,yreg,x+2,y+3,z,0);
  set_block_id(map,xreg,yreg,x-2,y+1,z,0);
  set_block_id(map,xreg,yreg,x-2,y+1,z+1,0);
  set_block_id(map,xreg,yreg,x-2,y+2,z,0);
  set_block_id(map,xreg,yreg,x-2,y+2,z+1,0);
  set_block_id(map,xreg,yreg,x+2,y+1,z+1,0);
  set_block_id(map,xreg,yreg,x+2,y+2,z-1,30);  
  set_block_id(map,xreg,yreg,x,y+1,z-2,0);
  set_block_id(map,xreg,yreg,x,y+2,z-2,0);
  set_block_id(map,xreg,yreg,x+1,y+2,z-2,30);

  //delaem pesok vmesto pola
  set_block_id(map,xreg,yreg,x-2,y,z,12);
  set_block_id(map,xreg,yreg,x-1,y,z,12);
  set_block_id(map,xreg,yreg,x-2,y,z+1,12);

  //delaem krishu
  for i:=x-2 to x+2 do
    for j:=z-2 to z+2 do
      if (i=x-2)or(i=x+2)or(j=z-2)or(j=z+2) then set_block_id_data(map,xreg,yreg,i,y+4,j,44,1);
  //delaem probeli v krishe
  set_block_id(map,xreg,yreg,x-2,y+4,z+1,0);
  set_block_id(map,xreg,yreg,x,y+4,z-2,0);
  set_block_id(map,xreg,yreg,x+2,y+4,z,0);

  //delaem fakel
  set_block_id_data(map,xreg,yreg,x+1,y+1,z,50,2);
end;

procedure gen_vil2_house2(var map:region; xreg,yreg,x,y,z:integer);
var i,j,k:integer;
begin
  //delaem pol
  for i:=x-2 to x+2 do
    for j:=z-3 to z+2 do
      for k:=y+1 to y+3 do
        if (i=x-2)or(i=x+2)or(j=z-3)or(j=z+2)or(k=y+3) then set_block_id(map,xreg,yreg,i,k,j,24);

  //delaem dirki v dome
  set_block_id(map,xreg,yreg,x-2,y+3,z,30);
  set_block_id(map,xreg,yreg,x-1,y+3,z,0);
  set_block_id(map,xreg,yreg,x-1,y+3,z-1,0);
  set_block_id(map,xreg,yreg,x,y+3,z-1,0);
  set_block_id(map,xreg,yreg,x,y+3,z-2,0);
  set_block_id(map,xreg,yreg,x,y+1,z+2,30);
  set_block_id(map,xreg,yreg,x+1,y+1,z+2,0);
  set_block_id(map,xreg,yreg,x+1,y+2,z+2,0);
  set_block_id(map,xreg,yreg,x+1,y+3,z+2,0);
  set_block_id(map,xreg,yreg,x-2,y+2,z+1,30);
  set_block_id(map,xreg,yreg,x-2,y+1,z-1,0);
  set_block_id(map,xreg,yreg,x-2,y+2,z-1,0); 
  set_block_id(map,xreg,yreg,x-2,y+1,z-2,64);
  set_block_id_data(map,xreg,yreg,x-2,y+2,z-2,64,8); 
  set_block_id(map,xreg,yreg,x+1,y,z,0);
  set_block_id(map,xreg,yreg,x+2,y,z,0);
  set_block_id(map,xreg,yreg,x+2,y+1,z,0);
  set_block_id(map,xreg,yreg,x+2,y+1,z-1,0);
  set_block_id(map,xreg,yreg,x+2,y+2,z-1,0);
end;

procedure gen_vil2_house3(var map:region; xreg,yreg,x,y,z:integer);
var i,j,k:Integer;
begin
  //delaem korobku
  for i:=x-3 to x+2 do
    for j:=z-2 to z+2 do
      for k:=y to y+3 do
        if (i=x-3)or(i=x+2)or(j=z-2)or(j=z+2)or(k=y)or(k=y+3) then set_block_id(map,xreg,yreg,i,k,j,24);
  //delaem arku na vhode
  for k:=y+1 to y+3 do
    if k=y+3 then
    begin
      set_block_id(map,xreg,yreg,x-1,k,z-3,24);
      set_block_id(map,xreg,yreg,x,k,z-3,24);
    end
    else
    begin
      set_block_id(map,xreg,yreg,x-2,k,z-3,24);
      set_block_id(map,xreg,yreg,x+1,k,z-3,24);
      set_block_id(map,xreg,yreg,x-1,k,z-2,0);
      set_block_id(map,xreg,yreg,x,k,z-2,0);
    end;
  set_block_id(map,xreg,yreg,x,y,z-3,24);
  set_block_id(map,xreg,yreg,x-1,y,z-3,24);

  //delaem dirki
  set_block_id(map,xreg,yreg,x,y+3,z-1,0);
  set_block_id(map,xreg,yreg,x+2,y+1,z+2,0);
  set_block_id(map,xreg,yreg,x+2,y+2,z+2,0);
  set_block_id(map,xreg,yreg,x+2,y+3,z+2,0);
  set_block_id(map,xreg,yreg,x,y,z+2,0);
  set_block_id(map,xreg,yreg,x,y+1,z+2,0);
  set_block_id(map,xreg,yreg,x,y+2,z+2,0);
  set_block_id(map,xreg,yreg,x-1,y+2,z+2,0);
  set_block_id(map,xreg,yreg,x-1,y+3,z+2,0);
  set_block_id(map,xreg,yreg,x-2,y+1,z+2,0);
  set_block_id(map,xreg,yreg,x-2,y+2,z+2,0);
  set_block_id(map,xreg,yreg,x-2,y+3,z+2,0);
  set_block_id(map,xreg,yreg,x-2,y+3,z+1,0);
  set_block_id(map,xreg,yreg,x-3,y+2,z+2,0);
  set_block_id(map,xreg,yreg,x-3,y+3,z+2,0);
  set_block_id(map,xreg,yreg,x-3,y+1,z,0);
  set_block_id(map,xreg,yreg,x-3,y+2,z,0);
  set_block_id(map,xreg,yreg,x-3,y+2,z-1,0);
  set_block_id(map,xreg,yreg,x+2,y+1,z-1,0);
  set_block_id(map,xreg,yreg,x+2,y+2,z,0);
  set_block_id(map,xreg,yreg,x+2,y+2,z-1,0);
  set_block_id(map,xreg,yreg,x+1,y+1,z+1,30);
  set_block_id(map,xreg,yreg,x,y,z,0);
  set_block_id(map,xreg,yreg,x,y,z+1,0);
  set_block_id(map,xreg,yreg,x-1,y,z+1,0); 
  set_block_id(map,xreg,yreg,x-2,y,z,0);
  set_block_id(map,xreg,yreg,x-2,y,z-1,0);
end;

procedure gen_vil2_house4(var map:region; xreg,yreg,x,y,z:integer);
var i,j,k:integer;
begin
  //delaem pol
  for i:=x-2 to x+1 do
    for j:=z-2 to z+2 do
      set_block_id(map,xreg,yreg,i,y,j,5);

  //delaem korobku
  for i:=x-2 to x+1 do
    for j:=z-2 to z+2 do
      for k:=y+1 to y+3 do
        if (i=x-2)or(i=z+1)or(j=z-2)or(j=z+2)or(k=y+3) then set_block_id(map,xreg,yreg,i,k,j,24);

  //delaem dirki
  set_block_id(map,xreg,yreg,x,y+3,z-1,0);
  set_block_id(map,xreg,yreg,x+1,y+1,z-1,0);
  set_block_id(map,xreg,yreg,x+1,y+2,z-1,0);
  set_block_id(map,xreg,yreg,x+1,y+3,z-1,0);
  set_block_id(map,xreg,yreg,x+1,y+1,z,0);
  set_block_id(map,xreg,yreg,x+1,y+2,z,0);
  set_block_id(map,xreg,yreg,x+1,y+3,z,0);
  set_block_id(map,xreg,yreg,x+1,y+2,z+1,30);
  set_block_id_data(map,xreg,yreg,x-2,y+2,z+1,50,5);
  set_block_id(map,xreg,yreg,x-2,y+1,z,0);

  //delaem krovat'
  set_block_id(map,xreg,yreg,x-1,y+1,z,26);
  set_block_id_data(map,xreg,yreg,x-1,y+1,z+1,26,8);
end;

procedure gen_vil2_house5(var map:region; xreg,yreg,x,y,z:integer);
begin
  //generim postroyku poblochno
  set_block_id(map,xreg,yreg,x+1,y+3,z,24);
  set_block_id(map,xreg,yreg,x+1,y+3,z-1,24);
  set_block_id(map,xreg,yreg,x,y+3,z-1,24);
  set_block_id(map,xreg,yreg,x-1,y+3,z-1,24);
  set_block_id(map,xreg,yreg,x-1,y+3,z,24);
  set_block_id(map,xreg,yreg,x-1,y+3,z+1,24);
  set_block_id(map,xreg,yreg,x,y+3,z+1,24);

  set_block_id(map,xreg,yreg,x+1,y+1,z+1,24);
  set_block_id(map,xreg,yreg,x+1,y+2,z+1,24);

  set_block_id(map,xreg,yreg,x+1,y+1,z-2,24);
  set_block_id(map,xreg,yreg,x-1,y+1,z-2,24);

  set_block_id(map,xreg,yreg,x-1,y+2,z-1,24);
  set_block_id(map,xreg,yreg,x-1,y+1,z-1,24);
  set_block_id(map,xreg,yreg,x-1,y+1,z,24);
  set_block_id(map,xreg,yreg,x-1,y+1,z+1,24);
  set_block_id(map,xreg,yreg,x-1,y+2,z+1,24);

  //generim dveri
  set_block_id_data(map,xreg,yreg,x+1,y+1,z,64,6);
  set_block_id_data(map,xreg,yreg,x+1,y+2,z,64,14);

  set_block_id_data(map,xreg,yreg,x+1,y+1,z-1,64,5);
  set_block_id_data(map,xreg,yreg,x+1,y+2,z-1,64,13);
end;

procedure gen_salt(var map:region; xreg,yreg,x,y,z:integer; sid:int64);
var rand:rnd;
tempxot,tempxdo,tempyot,tempydo:integer;
chx,chy:integer;
xx,zz:integer;
begin
  rand:=rnd.Create(sid);

    if xreg<0 then
    begin
      tempxot:=(xreg+1)*32-32;
      tempxdo:=(xreg+1)*32+3;
    end
    else
    begin
      tempxot:=xreg*32;
      tempxdo:=(xreg*32)+35;
    end;

    if yreg<0 then
    begin
      tempyot:=(yreg+1)*32-32;
      tempydo:=(yreg+1)*32+3;
    end
    else
    begin
      tempyot:=yreg*32;
      tempydo:=(yreg*32)+35;
    end;

    dec(tempxot);
    dec(tempxdo,3);
    dec(tempyot);
    dec(tempydo,3);

    //opredelaem, k kakomu chanku otnositsa
    chx:=x;
    chy:=z;

    if chx<0 then inc(chx);
    if chy<0 then inc(chy);

    chx:=chx div 16;
    chy:=chy div 16;

    if (chx<=0)and(x<0) then dec(chx);
    if (chy<=0)and(z<0) then dec(chy);

    //uslovie
    if (chx>=tempxot)and(chx<=tempxdo)and(chy>=tempyot)and(chy<=tempydo) then
    begin
      //perevodim v koordinati chanka
      xx:=x mod 16;
      zz:=z mod 16;
      if xx<0 then inc(xx,16);
      if zz<0 then inc(zz,16);

      chx:=chx-tempxot;
      chy:=chy-tempyot;

      if map[chx][chy].blocks[y+(zz*128+(xx*2048))]=12 then
        gen_recur(2,map,chx,chy,xx,y,zz,13,0,25,rand,12);
    end;

  rand.Free;
end;

procedure gen_vil1(var map:region; xreg,yreg,x,y,z:integer);
var i,j,k:integer;
begin
  //gorizontalnie dorogi
  for i:=x-6 to x+6 do  //X
  begin
    if i>(x-6) then set_block_id(map,xreg,yreg,i,y,z+1,24);
    if (i<(x-2))or(i>(x+3)) then set_block_id(map,xreg,yreg,i,y,z-5,24);
  end;

  //vertikalnaya doroga
  for j:=z-10 to z+3 do
    if (j<(z-6))or(j>(z+1)) then set_block_id(map,xreg,yreg,x-1,y,j,24);

  //kolodec
  //osnovanie kolodca
  for i:=x-3 to x+1 do
    for j:=z-4 to z do
      set_block_id(map,xreg,yreg,i,y,j,24);
  set_block_id_data(map,xreg,yreg,x-2,y,z-2,50,1);

  //ograda kolodca
  for j:=z-4 to z do
    set_block_id(map,xreg,yreg,x+1,y+1,j,24);
  set_block_id(map,xreg,yreg,x,y+1,z,24);
  set_block_id(map,xreg,yreg,x,y+1,z-4,24);
  set_block_id(map,xreg,yreg,x-2,y+1,z-4,24);
  set_block_id(map,xreg,yreg,x-3,y+1,z-4,24);
  set_block_id(map,xreg,yreg,x-3,y+1,z-3,24);
  set_block_id(map,xreg,yreg,x-3,y+1,z,24);
  set_block_id(map,xreg,yreg,x-2,y+1,z,30);
  set_block_id(map,xreg,yreg,x-3,y+1,z-1,30);
  //pesok na ograde
  for i:=x-1 to x+2 do
    set_block_id(map,xreg,yreg,i,y+1,z-5,12);
  for j:=z-4 to z-2 do
    set_block_id(map,xreg,yreg,x+2,y+1,j,12);
  set_block_id(map,xreg,yreg,x-1,y+1,z-4,12);
  set_block_id(map,xreg,yreg,x,y+1,z-3,12);
  set_block_id(map,xreg,yreg,x,y+2,z-4,12);
  set_block_id(map,xreg,yreg,x+1,y+2,z-4,12);
  set_block_id(map,xreg,yreg,x+1,y+2,z-3,12);

  //dirka v kolodce
  for i:=y-4 to y do
    if i=y-1 then set_block_id(map,xreg,yreg,x-1,i,z-2,30)
    else set_block_id(map,xreg,yreg,x-1,i,z-2,0);

  //komnata vnutri kolodca
  for i:=x-2 to x do
    for j:=z-3 to z-1 do
      for k:=y-6 to y-5 do
        set_block_id(map,xreg,yreg,i,k,j,0);
  set_block_id(map,xreg,yreg,x-1,y-5,z,0);
  set_block_id(map,xreg,yreg,x-1,y-6,z,0);
  set_block_id(map,xreg,yreg,x-2,y-6,z,0);
  set_block_id(map,xreg,yreg,x-3,y-6,z-1,0);
  set_block_id(map,xreg,yreg,x-3,y-6,z-2,0);
  set_block_id(map,xreg,yreg,x-3,y-6,z-3,0);
  set_block_id(map,xreg,yreg,x-3,y-6,z-4,0);
  set_block_id(map,xreg,yreg,x-4,y-6,z-3,0);
  set_block_id(map,xreg,yreg,x-2,y-6,z-4,0);
  set_block_id(map,xreg,yreg,x-1,y-6,z-4,0);
  set_block_id(map,xreg,yreg,x,y-6,z-4,0);
  set_block_id(map,xreg,yreg,x+1,y-6,z-3,0);
  set_block_id(map,xreg,yreg,x+1,y-6,z-2,0);
  set_block_id(map,xreg,yreg,x+1,y-6,z-1,0);
  set_block_id(map,xreg,yreg,x+1,y-7,z-1,0);
  set_block_id(map,xreg,yreg,x+2,y-6,z-3,0); 
  set_block_id(map,xreg,yreg,x-1,y-7,z-1,9);
  set_block_id(map,xreg,yreg,x-1,y-7,z-2,9);
  set_block_id(map,xreg,yreg,x,y-7,z-2,9);
  set_block_id(map,xreg,yreg,x,y-7,z-3,9);

  //stavim vorota
  for k:=y to y+3 do
  begin
    set_block_id(map,xreg,yreg,x,k,z-10,24);
    set_block_id(map,xreg,yreg,x-2,k,z-10,24);
  end;
  set_block_id(map,xreg,yreg,x-1,y+3,z-10,24);
  set_block_id(map,xreg,yreg,x-2,y+1,z-9,24);
  set_block_id(map,xreg,yreg,x-3,y+1,z-10,24);
  set_block_id(map,xreg,yreg,x-2,y+1,z-11,24);
  set_block_id(map,xreg,yreg,x,y+1,z-9,24);
  set_block_id(map,xreg,yreg,x+1,y+1,z-10,24);
  set_block_id(map,xreg,yreg,x,y+1,z-11,24);
  set_block_id_data(map,xreg,yreg,x,y+2,z-11,50,4);
  set_block_id_data(map,xreg,yreg,x-2,y+2,z-11,50,4); 

  //stavim doma
  gen_vil1_house1(map,xreg,yreg,x+9,y,z-5);
  gen_vil1_house2(map,xreg,yreg,x+9,y,z+1);
  gen_vil1_house3(map,xreg,yreg,x+1,y,z+7);
  gen_vil1_house4(map,xreg,yreg,x-9,y,z+1);
  gen_vil1_house5(map,xreg,yreg,x-9,y,z-5);

  //stavim sawner
  place_spawner(map,xreg,yreg,x-1,y-8,z-3,'Zombie');
end;

procedure gen_vil2(var map:region; xreg,yreg,x,y,z:integer);
var i,j,k:integer;
begin
  //delaem dorogi
  for i:=x-8 to x+7 do
    for j:=z-11 to z+3 do
      if (i=x-1)or(i=x)or(j=z-4)or(j=z-5) then set_block_id(map,xreg,yreg,i,y,j,24);
  set_block_id_data(map,xreg,yreg,x,y,z,44,1);
  set_block_id_data(map,xreg,yreg,x-1,y,z+1,44,1);
  set_block_id_data(map,xreg,yreg,x,y,z+3,44,1);
  set_block_id_data(map,xreg,yreg,x-4,y,z-4,44,1);
  set_block_id_data(map,xreg,yreg,x+2,y,z-5,44,1);
  set_block_id_data(map,xreg,yreg,x+3,y,z-4,44,1);
  set_block_id_data(map,xreg,yreg,x+6,y,z-4,44,1);
  set_block_id_data(map,xreg,yreg,x+7,y,z-5,44,1);
  set_block_id_data(map,xreg,yreg,x-1,y,z-11,44,1);
  //delaem kolodec
  //delaem ogradu
  for i:=x-2 to x+1 do
    for j:=z-6 to z-3 do
      if (i=x-2)or(i=x+1)or(j=z-6)or(j=z-3) then set_block_id(map,xreg,yreg,i,y+1,j,24);
  //delaem dirku
  for k:=y-6 to y do
    for i:=x-1 to x do
      for j:=z-5 to z-4 do
        if (k=y) and(i=x)and(j=z-4) then set_block_id(map,xreg,yreg,i,k,j,0)
        else if k=y then set_block_id(map,xreg,yreg,i,k,j,30)
        else set_block_id(map,xreg,yreg,i,k,j,0);
  set_block_id(map,xreg,yreg,x-1,y+1,z-5,30);
  set_block_id(map,xreg,yreg,x,y-5,z-3,0);
  set_block_id(map,xreg,yreg,x,y-6,z-3,0);
  set_block_id(map,xreg,yreg,x-1,y-6,z-3,0);
  set_block_id(map,xreg,yreg,x-2,y-6,z-4,0);
  set_block_id(map,xreg,yreg,x+1,y-5,z-5,0);
  set_block_id(map,xreg,yreg,x+1,y-5,z-4,0);
  set_block_id(map,xreg,yreg,x+1,y-6,z-5,0);
  set_block_id(map,xreg,yreg,x+1,y-6,z-4,0);
  set_block_id(map,xreg,yreg,x-2,y-5,z-5,0);
  set_block_id(map,xreg,yreg,x-2,y-5,z-4,0);
  set_block_id(map,xreg,yreg,x-2,y-6,z-5,0);
  set_block_id(map,xreg,yreg,x-2,y-6,z-4,0);
  set_block_id(map,xreg,yreg,x-3,y-5,z-4,0);
  set_block_id(map,xreg,yreg,x-3,y-6,z-4,0);
  set_block_id(map,xreg,yreg,x-1,y-5,z-6,0);
  set_block_id(map,xreg,yreg,x,y-5,z-6,0);
  set_block_id(map,xreg,yreg,x,y-6,z-6,0);
  set_block_id(map,xreg,yreg,x,y-5,z-7,0);
  set_block_id(map,xreg,yreg,x,y-6,z-7,0);
  //delaem vodu
  set_block_id(map,xreg,yreg,x,y-7,z-5,9);
  //delaem fakeli
  set_block_id_data(map,xreg,yreg,x-2,y+2,z-3,50,5);
  set_block_id_data(map,xreg,yreg,x+1,y+2,z-3,50,5);
  set_block_id_data(map,xreg,yreg,x-2,y+2,z-6,50,5);
  set_block_id_data(map,xreg,yreg,x+1,y+2,z-6,50,5);

  //delaem vorota
  for k:=y-1 to y+3 do
    for i:=x-2 to x+1 do
      if (k=y-1)or(k=y+3)or(i=x-2)or(i=x+1) then set_block_id(map,xreg,yreg,i,k,z-11,24);
  set_block_id(map,xreg,yreg,x-2,y+1,z-10,24);
  set_block_id(map,xreg,yreg,x-3,y+1,z-11,24);
  set_block_id(map,xreg,yreg,x-2,y+1,z-12,24);
  set_block_id(map,xreg,yreg,x+1,y+1,z-10,24);
  set_block_id(map,xreg,yreg,x+2,y+1,z-11,24);
  set_block_id(map,xreg,yreg,x+1,y+1,z-12,24);
  set_block_id_data(map,xreg,yreg,x-2,y+2,z-12,50,4);
  set_block_id_data(map,xreg,yreg,x+1,y+2,z-12,50,4);

  //delaem doma
  gen_vil2_house1(map,xreg,yreg,x+10,y,z-5);
  gen_vil2_house2(map,xreg,yreg,x+10,y,z+2);
  gen_vil2_house3(map,xreg,yreg,x,y,z+7);
  gen_vil2_house4(map,xreg,yreg,x-10,y,z+1);
  gen_vil2_house5(map,xreg,yreg,x-10,y,z-4);

  //stavim sawner
  place_spawner(map,xreg,yreg,x-1,y-8,z-4,'CaveSpider');
end;

procedure gen_camp(var map:region; xreg,yreg,x,y,z:integer);
var i,j:integer;
begin
  //delaem ogon'
  set_block_id(map,xreg,yreg,x,y,z,87);
  set_block_id_data(map,xreg,yreg,x,y+1,z,51,15);

  //delaem ogradu
  for i:=x-3 to x+3 do
    for j:=z-3 to z+3 do
      if (i=x-3)or(i=x+3)or(j=z-3)or(j=z+3) then set_block_id(map,xreg,yreg,i,y+1,j,85);

  //delaem krovati
  set_block_id_data(map,xreg,yreg,x-2,y+1,z+2,26,9);
  set_block_id_data(map,xreg,yreg,x-1,y+1,z+2,26,1);
  set_block_id_data(map,xreg,yreg,x+1,y+1,z+2,26,3);
  set_block_id_data(map,xreg,yreg,x+2,y+1,z+2,26,11);

  //delaem dirki v ograde
  set_block_id(map,xreg,yreg,x,y+1,z-3,0);
  set_block_id(map,xreg,yreg,x+2,y+1,z-3,0);
  set_block_id(map,xreg,yreg,x+3,y+1,z-2,0);
  set_block_id(map,xreg,yreg,x-3,y+1,z+1,0);
  set_block_id(map,xreg,yreg,x,y+1,z+3,0);
  set_block_id(map,xreg,yreg,x+3,y+1,z+2,0);
end;

procedure gen_tochn_oblasti(var bit:karta_type; obl:ar_oblast; oasis_ar:par_int; sid,sid2:int64; par1,par2,mul1:extended; hndl:cardinal; tip_obl:integer);
var rand,rand1:rnd;
octaves,octaves1:NoiseGeneratorOctaves;
mas,mas1:ar_double;
i,j,k,z,smesh,i1,j1,t,m,i2,j2,x,y,x1,y1,k1,z1,col:integer;
e1,e2:extended;
minim:integer;
//r,g,b:byte;
b1:boolean;
begin
  rand:=rnd.Create(sid);
  octaves:=NoiseGeneratorOctaves.create(rand,4);
  setlength(mas,16*16);

  rand1:=rnd.Create(sid2);
  octaves1:=NoiseGeneratorOctaves.create(rand1,4);
  setlength(mas1,16*16); 

  if tip_obl=0 then col:=palettergb(255,24,24)
  else col:=palettergb(24,24,255);

  smesh:=0;

  for k:=0 to length(oasis_ar^)-1 do
  begin
    postmessage(hndl,WM_USER+305,k,length(oasis_ar^)-1);

    for i:=0 to obl[oasis_ar^[k]].r*2-1 do
      for j:=0 to obl[oasis_ar^[k]].r*2-1 do
      begin
        mas:=octaves.generateNoiseOctaves(mas,(obl[oasis_ar^[k]].x-obl[oasis_ar^[k]].r+i)*16,0,(obl[oasis_ar^[k]].y-obl[oasis_ar^[k]].r+j)*16,16,1,16,par1,1,par1,false);
        mas1:=octaves1.generateNoiseOctaves(mas1,(obl[oasis_ar^[k]].x-obl[oasis_ar^[k]].r+i)*16,0,(obl[oasis_ar^[k]].y-obl[oasis_ar^[k]].r+j)*16,16,1,16,par2,1,par2,false);

        for i1:=0 to 15 do  //X
          for j1:=0 to 15 do  //Y
          begin
            if mas[i1*16+j1]<0 then e1:=-mas[i1*16+j1]
            else e1:=mas[i1*16+j1];
            mas[i1*16+j1]:=64+mas[i1*16+j1]*mul1+mas1[i1*16+j1]*(7-e1);
            if mas[i1*16+j1]<10 then mas[i1*16+j1]:=10;
            if mas[i1*16+j1]>117 then mas[i1*16+j1]:=117;

            t:=round(mas[i1*16+j1]);
            if t=117 then bit[smesh+i*16+i1,j*16+j1]:=palettergb(255,24,24)
            else if t=10 then bit[smesh+i*16+i1,j*16+j1]:=palettergb(24,24,255)
            else bit[smesh+i*16+i1,j*16+j1]:=palettergb(t*2,t*2,t*2);
          end;
      end;

    //izmenaem oblasti
    m:=0;
  for x:=10 to obl[oasis_ar^[k]].r*32-11 do
    for y:=10 to obl[oasis_ar^[k]].r*32-11 do
    begin
    //i1:=obl[oasis_ar[k]].r*16;
    //j1:=i1;

    i1:=x;
    j1:=y;

    i:=bit[smesh+i1,j1];

    {r:=byte(i);
    g:=byte(i shr 8);
    b:=byte(i shr 16);  }

    if {(r=255)and(g=24)and(b=24)}i=col then
    begin
      //t:=i1-5;
      //i:=abs(obl[oasis_ar[k]].r*16-x);
      //j:=abs(obl[oasis_ar[k]].r*16-y);
      if x<obl[oasis_ar^[k]].r*16 then i:=x
      else i:=obl[oasis_ar^[k]].r*32-x;
      if y<obl[oasis_ar^[k]].r*16 then j:=y
      else j:=obl[oasis_ar^[k]].r*32-y;
      t:=min(i,j)-5;

      if tip_obl=0 then minim:=10
      else minim:=16;

      for i:=minim to t do
        for j:=minim to t do
        begin
          if (i*j)<m then continue;

          b1:=true;

          //tochki uglov
          {if not((byte(bit[smesh+(i1-i),j1-j])=255)and(byte(bit[smesh+(i1-i),j1-i] shr 8)=24)and(byte(bit[smesh+(i1-i),j1-j] shr 16)=24)and
          (byte(bit[smesh+(i1+i),j1-j])=255)and(byte(bit[smesh+(i1+i),j1-j] shr 8)=24)and(byte(bit[smesh+(i1+i),j1-j] shr 16)=24)and
          (byte(bit[smesh+(i1-i),j1+j])=255)and(byte(bit[smesh+(i1-i),j1+j] shr 8)=24)and(byte(bit[smesh+(i1-i),j1+j] shr 16)=24)and
          (byte(bit[smesh+(i1+i),j1+j])=255)and(byte(bit[smesh+(i1+i),j1+j] shr 8)=24)and(byte(bit[smesh+(i1+i),j1+j] shr 16)=24)) then
            b1:=false;  }
          if (bit[smesh+(i1-i),j1-j]<>col)or(bit[smesh+(i1+i),j1-j]<>col)or(bit[smesh+(i1-i),j1+j]<>col)or(bit[smesh+(i1+i),j1+j]<>col) then
            b1:=false;

          //gorizontalnaya liniya
          for k1:=smesh+i1-i to smesh+i1+i do
          begin
            if b1=false then break;
            z:=bit[k1,j1];
            //if not((byte(z)=255)and(byte(z shr 8)=24)and(byte(z shr 16)=24)) then
            if z<>col then
              b1:=false;
          end;

          //vertikalnaya liniya
          for k1:=j1-j to j1+j do
          begin
            if b1=false then break;
            z:=bit[smesh+i1,k1];
            //if not((byte(z)=255)and(byte(z shr 8)=24)and(byte(z shr 16)=24)) then
            if z<>col then
              b1:=false;
          end;

          e1:=j1-j;
          e2:=j/i;
          //liniya sleva snizu do prava verha
          for k1:=smesh+i1-i to smesh+i1+i do
          begin
            if b1=false then break;
            z:=bit[k1,round(e1)];
            e1:=e1+e2;
            //if not((byte(z)=255)and(byte(z shr 8)=24)and(byte(z shr 16)=24)) then
            if z<>col then
              b1:=false;
          end;

          e1:=j1+j;
          e2:=j/i;
          //liniya sleva sverhu do prava niza
          for k1:=smesh+i1-i to smesh+i1+i do
          begin
            if b1=false then break;
            z:=bit[k1,round(e1)];
            e1:=e1-e2;
            //if not((byte(z)=255)and(byte(z shr 8)=24)and(byte(z shr 16)=24)) then
            if z<>col then
              b1:=false;
          end;

          //gorizontalnie linii sverhu i snizu po granice
          for k1:=smesh+i1-i to smesh+i1+i do
          begin
            if b1=false then break;
            z:=bit[k1,j1-j];
            if z<>col then
              b1:=false;
            z:=bit[k1,j1+j];
            if z<>col then
              b1:=false;
          end;

          //vertikalnie linii sleva i sprava po granice
          for k1:=j1-j to j1+j do
          begin
            if b1=false then break;
            z:=bit[smesh+i1-i,k1];
            if z<>col then
              b1:=false;
            z:=bit[smesh+i1+i,k1];
            if z<>col then
              b1:=false;
          end;

          {if (byte(bit[smesh+(i1-i),j1-j])=255)and(byte(bit[smesh+(i1-i),j1-i] shr 8)=24)and(byte(bit[smesh+(i1-i),j1-j] shr 16)=24)and
          (byte(bit[smesh+(i1+i),j1-j])=255)and(byte(bit[smesh+(i1+i),j1-j] shr 8)=24)and(byte(bit[smesh+(i1+i),j1-j] shr 16)=24)and
          (byte(bit[smesh+(i1-i),j1+j])=255)and(byte(bit[smesh+(i1-i),j1+j] shr 8)=24)and(byte(bit[smesh+(i1-i),j1+j] shr 16)=24)and
          (byte(bit[smesh+(i1+i),j1+j])=255)and(byte(bit[smesh+(i1+i),j1+j] shr 8)=24)and(byte(bit[smesh+(i1+i),j1+j] shr 16)=24) then}
          if b1=true then
          begin
            z:=i*j;
            if z>m then
            begin
              i2:=i;
              j2:=j;
              x1:=x;
              y1:=y;
              m:=z;
            end;
          end;
        end;
    end;

    end;

    if m<>0 then
    begin
      if tip_obl=0 then z:=palettergb(0,0,0)
      else z:=palettergb(255,255,255);

      for i:=x1-i2 to x1+i2 do
        for j:=y1-j2 to y1+j2 do
          if (i=x1-i2)or(i=x1+i2)or(j=y1-j2)or(j=y1+j2) then bit[smesh+i,j]:=z;

      smesh:=smesh+obl[oasis_ar^[k]].r*32;

      obl[oasis_ar^[k]].x:=(obl[oasis_ar^[k]].x-obl[oasis_ar^[k]].r)*16+x1;
      obl[oasis_ar^[k]].y:=(obl[oasis_ar^[k]].y-obl[oasis_ar^[k]].r)*16+y1;
      obl[oasis_ar^[k]].r:=i2;
      obl[oasis_ar^[k]].r1:=j2;
    end
    else
    begin
      if tip_obl=0 then
        for i:=0 to obl[oasis_ar^[k]].r*32-1 do
        begin
          bit[smesh+i,i]:=palettergb(0,0,0);
          bit[smesh+i,obl[oasis_ar^[k]].r*32-1-i]:=palettergb(0,0,0);
        end
      else
        for i:=0 to obl[oasis_ar^[k]].r*32-1 do
        begin
          bit[smesh+i,i]:=palettergb(255,255,255);
          bit[smesh+i,obl[oasis_ar^[k]].r*32-1-i]:=palettergb(255,255,255);
        end;

      smesh:=smesh+obl[oasis_ar^[k]].r*32;

      oasis_ar^[k]:=-1;
    end;
  end;

  //udalaem nevernie oblasti
  k:=0;
      if length(oasis_ar^)<>0 then
      repeat
        if oasis_ar^[k]=-1 then
        begin
          if k<>(length(oasis_ar^)-1) then
            move(oasis_ar^[k+1],oasis_ar^[k],(length(oasis_ar^)-k-1)*sizeof(integer));
          setlength(oasis_ar^,length(oasis_ar^)-1);
        end
        else
          inc(k);
      until k>(length(oasis_ar^)-1);

  rand.Free;
  octaves.Free;
  setlength(mas,0);
  rand1.Free;
  octaves1.Free;
  setlength(mas1,0);
end;

procedure gen_oblasti(var bit:karta_type; oasis_col,vil_col, oasis_ras,vil_ras:integer; sid:int64; obl:par_oblast; oasis_ar,vil_ar:par_int);
var i,j,k,z,col,col1:integer;
otx,dox,oty,doy:integer;
r,g,b:byte;
//obl:ar_oblast;
temp_obl:oblast_type;
boo:boolean;
rasst,maxim:extended;
//oasis_ar,vil_ar:array of integer;
rand:rnd;
have_oasis,have_vil:boolean;

  function izmen_obl(var obl:oblast_type; var bit:karta_type):boolean;
  var xmin,xmax,ymin,ymax:integer;
  otx,dox,oty,doy:integer;
  i,j:integer;
  r,g,b:byte;
  temp_obl:oblast_type;
  begin
    xmin:=obl.x;
    xmax:=obl.x;
    ymin:=obl.y;
    ymax:=obl.y;

    otx:=obl.x-obl.r;
    dox:=obl.x+obl.r;
    oty:=obl.y-obl.r;
    doy:=obl.y+obl.r;

    if otx<0 then otx:=0;
    if oty<0 then oty:=0;
    if dox>length(bit)-1 then dox:=length(bit)-1;
    if doy>length(bit[0])-1 then doy:=length(bit[0])-1;

    for i:=otx to dox do
      for j:=oty to doy do
      begin
        r:=byte(bit[i,j]);
        g:=byte(bit[i,j] shr 8);
        b:=byte(bit[i,j] shr 16);
        if (r=255)and(g=24)and(b=24)and(obl.tip=0) then
        begin
          if i<xmin then xmin:=i;
          if i>xmax then xmax:=i;
          if j<ymin then ymin:=j;
          if j>ymax then ymax:=j;
        end
        else if (r=24)and(g=24)and(b=255)and(obl.tip=1) then
        begin
          if i<xmin then xmin:=i;
          if i>xmax then xmax:=i;
          if j<ymin then ymin:=j;
          if j>ymax then ymax:=j;
        end;
      end;


    temp_obl.x:=xmin+((xmax-xmin) div 2);
    temp_obl.y:=ymin+((ymax-ymin) div 2);
    temp_obl.r:=max(((xmax-xmin) div 2),((ymax-ymin) div 2))+3;
    temp_obl.tip:=obl.tip;

    if (obl.x=temp_obl.x)and(obl.y=temp_obl.y)and(obl.r=temp_obl.r) then
      result:=false
    else
    begin
      obl:=temp_obl;
      //inc(obl.x);
      //inc(obl.y);
      result:=true;
    end;
  end;

begin
  //col1:=palettergb(24,255,24);
  rand:=rnd.Create(sid);

  for i:=0 to length(bit)-1 do
    for j:=0 to length(bit[i])-1 do
    begin
      col:=bit[i,j];
      r:=byte(col);
      g:=byte(col shr 8);
      b:=byte(col shr 16);
      if (r=255)and(g=24)and(b=24) then
      begin
        boo:=false;
        for k:=0 to length(obl^)-1 do
          if (i>(obl^[k].x-obl^[k].r))and(i<(obl^[k].x+obl^[k].r))and
          (j>(obl^[k].y-obl^[k].r))and(j<(obl^[k].y+obl^[k].r))and(obl^[k].tip=0) then
          begin
            boo:=true;
            break;
          end;

        if boo=true then continue;

        z:=length(obl^);
        setlength(obl^,z+1);

        obl^[z].x:=i;
        obl^[z].y:=j;
        obl^[z].r:=3;
        obl^[z].tip:=0;

        while izmen_obl(obl^[z],bit)=true do ;
      end;
      if (r=24)and(g=24)and(b=255) then
      begin
        boo:=false;
        for k:=0 to length(obl^)-1 do
          if (i>(obl^[k].x-obl^[k].r))and(i<(obl^[k].x+obl^[k].r))and
          (j>(obl^[k].y-obl^[k].r))and(j<(obl^[k].y+obl^[k].r))and(obl^[k].tip=1) then
          begin
            boo:=true;
            break;
          end;

        if boo=true then continue;

        z:=length(obl^);
        setlength(obl^,z+1);

        obl^[z].x:=i;
        obl^[z].y:=j;
        obl^[z].r:=3;
        obl^[z].tip:=1;

        while izmen_obl(obl^[z],bit)=true do ;
      end;
    end;

  //ubiraem oblasti, nahodashiesa na granice karti
  for k:=0 to length(obl^)-1 do
    if (obl^[k].x-obl^[k].r<0)or(obl^[k].x+obl^[k].r>length(bit)-1)or
    (obl^[k].y-obl^[k].r<0)or(obl^[k].y+obl^[k].r>length(bit[0])-1) then
      obl^[k].x:=-1000;

  //ubiraem oblasti, v kotorih slishkom malo poverhnosti
  for k:=0 to length(obl^)-1 do
  begin
    if obl^[k].x=-1000 then continue;
    if obl^[k].r<5 then
    begin
      obl^[k].x:=-1000;
      continue;
    end;

    otx:=obl^[k].x-obl^[k].r;
    dox:=obl^[k].x+obl^[k].r;
    oty:=obl^[k].y-obl^[k].r;
    doy:=obl^[k].y+obl^[k].r;

    z:=0;
    for i:=otx to dox do
      for j:=oty to doy do
      begin
        col:=bit[i,j];
        r:=byte(col);
        g:=byte(col shr 8);
        b:=byte(col shr 16);
        if (r=255)and(g=24)and(b=24)and(obl^[k].tip=0) then inc(z)
        else if (r=24)and(g=24)and(b=255)and(obl^[k].tip=1) then inc(z);
      end;

    if z<=14 then obl^[k].x:=-1000;
  end;

  //ubiraem oblasti, kotorie nahodatsa odni v drugom
  for i:=0 to length(obl^)-2 do
  begin
    if obl^[i].x=-1000 then continue;
    for j:=i+1 to length(obl^)-1 do
    begin
      if obl^[j].x=-1000 then continue;
      if obl^[i].x=-1000 then break;
      if ((obl^[i].x<(obl^[j].x+obl^[j].r))and(obl^[i].x>(obl^[j].x-obl^[j].r))and
      (obl^[i].y<(obl^[j].y+obl^[j].r))and(obl^[i].y>(obl^[j].y-obl^[j].r)))or
      ((obl^[j].x<(obl^[i].x+obl^[i].r))and(obl^[j].x>(obl^[i].x-obl^[i].r))and
      (obl^[j].y<(obl^[i].y+obl^[i].r))and(obl^[j].y>(obl^[i].y-obl^[i].r))) then
        if obl^[i].r>obl^[j].r then
          obl^[j].x:=-1000
        else
          obl^[i].x:=-1000;
    end;
  end;     

  //udalaem brakovannie oblasti
  k:=0;
  if length(obl^)<>0 then
  repeat
    if obl^[k].x=-1000 then
    begin
      if k<>(length(obl^)-1) then
        move(obl^[k+1],obl^[k],(length(obl^)-k-1)*sizeof(oblast_type));
      setlength(obl^,length(obl^)-1);
    end
    else
      inc(k);
  until k>(length(obl^)-1);

  //meshaem massiv
  if length(obl^)<>0 then
  for i:=0 to length(obl^)*5 do
  begin
    otx:=rand.nextInt(length(obl^));
    oty:=rand.nextInt(length(obl^));

    temp_obl:=obl^[otx];

    obl^[otx]:=obl^[oty];

    obl^[oty]:=temp_obl;
  end;

  have_oasis:=false;
  have_vil:=false;

  for i:=0 to length(obl^)-1 do
  begin
    if (have_oasis=true)and(have_vil=true) then break;
    if obl^[i].tip=0 then have_oasis:=true;
    if obl^[i].tip=1 then have_vil:=true;
  end;

  if (oasis_col>0)and(have_oasis=true) then
  begin
    setlength(oasis_ar^,oasis_col);

    for i:=0 to oasis_col-1 do
      oasis_ar^[i]:=-1;

    repeat
      i:=rand.nextInt(length(obl^));
    until (obl^[i].x<>-1000)and(obl^[i].tip<>1);
    oasis_ar^[0]:=i;

    for i:=1 to oasis_col-1 do
    begin
      if i>(length(oasis_ar^)-1) then break;
      j:=-1;
      maxim:=0;
      for k:=0 to length(obl^)-1 do
      begin
        rasst:=0;
        if (obl^[k].x=-1000)or(obl^[k].tip=1) then continue;

        for z:=0 to i-1 do
        begin
          if (obl^[oasis_ar^[z]].x=obl^[k].x)and(obl^[oasis_ar^[z]].y=obl^[k].y) then
          begin
            //j:=-1;
            //maxim:=0;
            rasst:=0;
            break;
          end;
          rasst:=rasst+sqrt(sqr(obl^[oasis_ar^[z]].x-obl^[k].x)+sqr(obl^[oasis_ar^[z]].y-obl^[k].y));
        end;
        rasst:=rasst/i;
        if rasst=0 then continue;
        if rasst>maxim then
        begin
          j:=k;
          maxim:=rasst;
          if maxim>oasis_ras then break;
        end;
      end;
      if j=-1 then
      begin
        setlength(oasis_ar^,i);
      end
      else
      begin
        oasis_ar^[i]:=j;
      end;
    end;
  end
  else
    setlength(oasis_ar^,0);


  if (vil_col>0)and(have_vil=true) then
  begin
    setlength(vil_ar^,vil_col);

    for i:=0 to vil_col-1 do
      vil_ar^[i]:=-1;

    repeat
      i:=rand.nextInt(length(obl^));
    until (obl^[i].x<>-1000)and(obl^[i].tip<>0);
    vil_ar^[0]:=i;

    for i:=1 to vil_col-1 do
    begin
      if i>(length(vil_ar^)-1) then break;
      j:=-1;
      maxim:=0;
      for k:=0 to length(obl^)-1 do
      begin
        rasst:=0;
        if (obl^[k].x=-1000)or(obl^[k].tip=0) then continue;

        for z:=0 to i-1 do
        begin
          if (obl^[vil_ar^[z]].x=obl^[k].x)and(obl^[vil_ar^[z]].y=obl^[k].y) then
          begin
            //j:=-1;
            //maxim:=0;
            rasst:=0;
            break;
          end;
          rasst:=rasst+sqrt(sqr(obl^[vil_ar^[z]].x-obl^[k].x)+sqr(obl^[vil_ar^[z]].y-obl^[k].y));
        end;
        rasst:=rasst/i;
        if rasst=0 then continue;
        if rasst>maxim then
        begin
          j:=k;
          maxim:=rasst;
          if maxim>vil_ras then break;
        end;
      end;
      if j=-1 then
      begin
        setlength(vil_ar^,i);
      end
      else
      begin
        vil_ar^[i]:=j;
      end;
    end;
  end
  else
    setlength(vil_ar^,0);


   for k:=0 to length(obl^)-1 do
   begin
     if obl^[k].x=-1000 then continue;

     if obl^[k].tip=0 then
     begin
       boo:=false;
       for i:=0 to length(oasis_ar^)-1 do
         if oasis_ar^[i]=k then
         begin
           boo:=true;
           break;
         end;
       if boo=true then col1:=palettergb(0,0,255)
       else col1:=palettergb(24,255,24);
     end
     else if obl^[k].tip=1 then
     begin
       boo:=false;
       for i:=0 to length(vil_ar^)-1 do
         if vil_ar^[i]=k then
         begin
           boo:=true;
           break;
         end;
       if boo=true then col1:=palettergb(255,128,64)
       else col1:=palettergb(255,255,24);

       //col1:=palettergb(255,255,24);
     end;

     otx:=obl^[k].x-obl^[k].r;
     dox:=obl^[k].x+obl^[k].r;
     oty:=obl^[k].y-obl^[k].r;
     doy:=obl^[k].y+obl^[k].r;

     if otx<0 then otx:=0;
     if oty<0 then oty:=0;
     if dox>length(bit) then dox:=length(bit);
     if doy>length(bit[0]) then doy:=length(bit[0]);

     for i:=otx to dox do
       for j:=oty to doy do
       begin
         if (i=otx)or(i=dox)or
         (j=oty)or(j=doy) then
         //if (i=(obl[k].x-obl[k].r)) then
           bit[i,j]:=col1;
       end;
   end;

  rand.Free;
end;

procedure gen_karta(par:biomes_desert_settings_type; sid,sid2:int64; par1,par2,mul1:extended; full:boolean; var output:karta_type);
var i,j,k,k1,t,co,tempx:integer;
rand,rand1:rnd;
octaves,octaves1:NoiseGeneratorOctaves;
mas,mas1:ar_double;
e,e1:extended;
col:cardinal;
begin
  rand:=rnd.Create(sid);
  octaves:=NoiseGeneratorOctaves.create(rand,4);
  setlength(mas,16*16);

  rand1:=rnd.Create(sid2);
  octaves1:=NoiseGeneratorOctaves.create(rand1,4);
  setlength(mas1,16*16);

  if full=false then
  begin
    setlength(output,par.width);
    for i:=0 to par.width-1 do
      setlength(output[i],par.len);
    //output.Width:=par.width;
    //output.Height:=par.len;
    //postmessage(par.handle,WM_USER+320,par.width,par.len);
  end
  else
  begin
    setlength(output,par.width*16);
    for i:=0 to par.width-1 do
      setlength(output[i],par.len*16);
    //output.Width:=par.width*16;
    //output.Height:=par.len*16;
    //postmessage(par.handle,WM_USER+320,par.width*16,par.len*16);
  end;

  postmessage(par.handle,WM_USER+316,par.width*par.len,0);

  postmessage(par.handle,WM_USER+300,1,0);

  postmessage(par.handle,WM_USER+325,0,0);

  //postmessage(par.handle,WM_USER+321,0,0);

  //postmessage(par.handle,WM_USER+323,0,0);

  co:=0;

  for i:=0 to par.width-1 do
    for j:=0 to par.len-1 do
    begin
      mas:=octaves.generateNoiseOctaves(mas,(i-(par.width div 2))*16,0,(j-(par.len div 2))*16,16,1,16,par1,1,par1,false);
      mas1:=octaves1.generateNoiseOctaves(mas1,(i-(par.width div 2))*16,0,(j-(par.len div 2))*16,16,1,16,par2,1,par2,false);

      e:=0;
      for k:=0 to 15 do  //X
        for k1:=0 to 15 do  //Y
        begin
          if mas[k*16+k1]<0 then e1:=-mas[k*16+k1]
          else e1:=mas[k*16+k1];
          mas[k*16+k1]:=64+mas[k*16+k1]*mul1+mas1[k*16+k1]*(7-e1);
          if mas[k*16+k1]<10 then mas[k*16+k1]:=10;
          if mas[k*16+k1]>117 then mas[k*16+k1]:=117;

          if full=true then
          begin
            t:=round(mas[k*16+k1]);
            if t>115 then output[i*16+k,j*16+k1]:=palettergb(255,24,24)
            else if t<12 then output[i*16+k,j*16+k1]:=palettergb(24,24,255)
            else output[i*16+k,j*16+k1]:=palettergb(t*2,t*2,t*2);
          end;

          e:=e+mas[k*16+k1];
        end;
      e:=e/length(mas);

      if full=false then
      begin
        t:=round(e);
        if e>115 then col:=palettergb(255,24,24)
        else if e<12 then col:=palettergb(24,24,255)
        else col:=palettergb(t*2,t*2,t*2);
        {if e>120 then output.Canvas.Pen.Color:=palettergb(t*2,t div 2,t div 2)
        else if e<7 then output.Canvas.Pen.Color:=palettergb(25,25,255)
        else output.Canvas.Pen.Color:=palettergb(t*2,t*2,t*2);
        output.Canvas.MoveTo(i,j);
        output.Canvas.LineTo(i,j);   }

        output[i,j]:=col;

        {tempx:=0;
        tempx:=(i shl 16)+j;
        postmessage(par.handle,WM_USER+322,tempx,col);   }
      end;

      //output.Canvas.Pixels[i,j]:=palettergb(i*2,j*2,i*j);
      inc(co);
      if (co mod 20)=0 then postmessage(par.handle,WM_USER+303,1,co);
    end;

  rand.Free;
  octaves.Free;
  setlength(mas,0);
  rand1.Free;
  octaves1.Free;
  setlength(mas1,0);

  //postmessage(par.handle,WM_USER+324,0,0);

  //postmessage(par.handle,WM_USER+321,0,0);

  //output.Canvas.CopyRect(r,temp_bit.Canvas,r);
end;

procedure gen_desert_chunk(xkoord,ykoord:integer; var blocks:ar_type; sid,sid2:int64; par1,par2,mul1:extended; obj:par_tlights_koord; pop:boolean; par:biomes_desert_settings_type);
var noise_mas,noise_mas1:ar_double;
octaves,octaves1:NoiseGeneratorOctaves;
rand,rand1:rnd;
e1:extended;
i,j,count,count2,len,bl:integer;
begin
  rand:=rnd.Create(sid);
  octaves:=NoiseGeneratorOctaves.create(rand,4);
  setlength(noise_mas,256);

  rand1:=rnd.Create(sid2);
  octaves1:=NoiseGeneratorOctaves.create(rand1,4);
  setlength(noise_mas1,256);

  bl:=par.under_block;

  noise_mas:=octaves.generateNoiseOctaves(noise_mas,(xkoord)*16,0,(ykoord)*16,16,1,16,par1,1,par1,false);
  noise_mas1:=octaves1.generateNoiseOctaves(noise_mas1,(xkoord)*16,0,(ykoord)*16,16,1,16,par2,1,par2,false);

  for i:=0 to length(noise_mas)-1 do
  begin
    if noise_mas[i]<0 then e1:=-noise_mas[i]
    else e1:=noise_mas[i];

    noise_mas[i]:=64+noise_mas[i]*mul1+noise_mas1[i]*(7-e1);
    if noise_mas[i]<10 then noise_mas[i]:=10;
    if noise_mas[i]>117 then noise_mas[i]:=117;
  end;

  for i:=0 to 15 do  //Z
    for j:=0 to 15 do  //X                
    begin
      count:=round(noise_mas[i+j*16]);
      count2:=count;

      //oblast' primeneniya ob'ektov
      if (pop=false)and(random<0.002)and(par.gen_shrubs=true) then
      begin
        len:=length(obj^);
        setlength(obj^,len+1);
        obj^[len].x:=j+xkoord*16;
        obj^[len].y:=count2+1;
        obj^[len].z:=i+ykoord*16;
        obj^[len].id:=0;                //visohshiy kust
      end;

      if (pop=false)and(random<0.001)and((count2=10)or(count2=117)) then
      begin
        len:=length(obj^);
        setlength(obj^,len+1);
        obj^[len].x:=j+xkoord*16;
        obj^[len].y:=count2;
        obj^[len].z:=i+ykoord*16;
        obj^[len].id:=5;                //zalezhi soli
      end;

      if (pop=false)and(random<0.0012)and(par.gen_cactus=true) then
      begin
        len:=length(obj^);
        setlength(obj^,len+1);
        obj^[len].x:=j+xkoord*16;
        obj^[len].y:=count2+1;
        obj^[len].z:=i+ykoord*16;
        obj^[len].id:=12;                //kaktus
      end;


      while count>(count2-3) do
      begin
        blocks[count+(i*128+(j*2048))]:=12;
        dec(count);
      end;
      while count>0 do
      begin
        blocks[count+(i*128+(j*2048))]:=bl;
        dec(count);
      end;
      blocks[0+(i*128+(j*2048))]:=7;
    end;

  rand.Free;
  octaves.Free;
  setlength(noise_mas,0);

  rand1.Free;
  octaves1.Free;
  setlength(noise_mas1,0);
end;

function gen_biome_desert_thread(Parameter:pointer):integer;
label exit_label;
var i,j,k,z:integer;     //peremennie dla regulirovaniya ciklov po regionam i chankam
kol:integer;
id:byte;
tempx,tempy,tempk,tempz,tempj:integer;     //peremennie dla lubih nuzhd
otx,dox,oty,doy:integer;   //granici chankov
regx,regy:integer;   //kol-vo region faylov
regx_nach,regy_nach:integer;  //nachalniy region (menshiy), s kotorogo nachinaetsa generaciya
param:ptparam_biomes_desert;
par:tparam_biomes_desert;
str,strcompress:string;
rez:ar_type;
head:mcheader;
map:region;
fdata:array of byte;
co:longword;
hndl:cardinal;
count,count2:dword;
obj:ar_tlights_koord;
pop_koord:ar_tkoord;
b1:boolean;
karta_mas,karta_tochn_mas,karta_tochn2_mas:karta_type;

oasis_sferi_obsh,oasis_sferi:ar_elipse_settings;

oblast:ar_oblast;
oasis_ar,vil_ar:ar_int;
sign_ar:ar_tlights_koord;

sid1,sid2:int64;
s_rand:rnd;

procedure thread_exit(p:ptparam_biomes_desert);
var i,j:integer;
begin
  if p^.desert_par^.potok_exit=true then
  begin
    //ochishaem pamat ot karti
  for i:=0 to 35 do
    for j:=0 to 35 do
    begin
      clear_all_entities(@map[i][j].entities,@map[i][j].tile_entities);
      setlength(map[i][j].blocks,0);
      setlength(map[i][j].data,0);
      setlength(map[i][j].light,0);
      setlength(map[i][j].skylight,0);
      setlength(map[i][j].heightmap,0);
    end;

  for i:=0 to 35 do
    setlength(map[i],0);

  setlength(map,0);

  setlength(rez,0);

  setlength(obj,0);
  setlength(pop_koord,0);

  postmessage(par.handle,WM_USER+301,par.id,0);
  endthread(0);
  end;
end;

begin
  param:=parameter;
  par:=param^;

  //vichislaem kol-vo chankov
  case par.border_par^.border_type of
  1:if par.border_par^.wall_void=true then i:=((par.tox+par.border_par^.wall_void_thickness)-(par.fromx-par.border_par^.wall_void_thickness)+1)*((par.toy+par.border_par^.wall_void_thickness)-(par.fromy-par.border_par^.wall_void_thickness)+1)
      else i:=(par.tox-par.fromx+1)*(par.toy-par.fromy+1);
  2:i:=((par.tox+par.border_par^.void_thickness)-(par.fromx-par.border_par^.void_thickness)+1)*((par.toy+par.border_par^.void_thickness)-(par.fromy-par.border_par^.void_thickness)+1);
  3:if par.border_par^.cwall_gen_void=true then i:=((par.tox+par.border_par^.cwall_void_width)-(par.fromx-par.border_par^.cwall_void_width)+1)*((par.toy+par.border_par^.cwall_void_width)-(par.fromy-par.border_par^.cwall_void_width)+1)
      else i:=(par.tox-par.fromx+1)*(par.toy-par.fromy+1);
  else
    i:=(par.tox-par.fromx+1)*(par.toy-par.fromy+1);
  end;
  //peredaem kol-vo chankov vmeste v border v osnovnuyu formu
  postmessage(par.handle,WM_USER+302,par.id,i);

  //videlaem pamat pod kartu
  setlength(map,36);
  for i:=0 to 35 do
    setlength(map[i],36);

  for i:=0 to 35 do
    for j:=0 to 35 do
    begin
      setlength(map[i][j].blocks,32768);
      setlength(map[i][j].data,32768);
      setlength(map[i][j].light,32768);
      setlength(map[i][j].skylight,32768);
      setlength(map[i][j].heightmap,256);
    end;

  setlength(obj,0);
  setlength(pop_koord,0);

  kol:=0;

  //inicilializiruem random
  Randseed:=par.sid;

  sid1:=par.sid;
  s_rand:=rnd.Create(sid1);
  sid2:=s_rand.nextLong;
  s_rand.Free;

/////////////////////////////////
                                    

  //sozdaem izobrazhenie karti
  //gen_karta(par.desert_par^,-282261449315523383,123519723383,0.0229125,0.0229125,9,false,karta_mas);
  gen_karta(par.desert_par^,sid1,sid2,0.0229125,0.0229125,9,false,karta_mas);

  //rabota s kartoy
  if par.desert_par^.gen_oasises=true then tempx:=par.desert_par^.oasis_count
  else tempx:=0;
  if par.desert_par^.gen_vil=true then tempy:=par.desert_par^.vil_count
  else tempy:=0;

  //todo: peredelat' proceduru tak, chtobi vosprinimala 2 vida znacheniy (v % i v kol-ve)
  //takzhe sdelat' opcii na forme nastroek dla rasstoyaniya mezhdu ob'ektami
  gen_oblasti(karta_mas,tempx,tempy,200,200,sid1,@oblast,@oasis_ar,@vil_ar);

  //vichislaem dlinnu i shirinu tochnoy karti oblastey oazisov
  j:=0;
  k:=0;
  for i:=0 to length(oasis_ar)-1 do
  begin
    tempx:=oblast[oasis_ar[i]].r*2;
    if tempx>j then j:=tempx;
    k:=k+tempx;

    oblast[oasis_ar[i]].x:=oblast[oasis_ar[i]].x-(par.desert_par^.width div 2);
    oblast[oasis_ar[i]].y:=oblast[oasis_ar[i]].y-(par.desert_par^.len div 2);
  end;

  k:=(k)*16;
  j:=(j)*16;

  setlength(karta_tochn_mas,k);
  for i:=0 to k-1 do
    setlength(karta_tochn_mas[i],j);

  //generaciya tochnih heightmap
  postmessage(par.handle,WM_USER+326,0,0);
  //gen_tochn_oblasti(karta_tochn_mas,oblast,@oasis_ar,-282261449315523383,123519723383,0.0229125,0.0229125,9,par.handle,0);
  gen_tochn_oblasti(karta_tochn_mas,oblast,@oasis_ar,sid1,sid2,0.0229125,0.0229125,9,par.handle,0);

  {//udalaem nevernie oblasti
  k:=0;
      repeat
        if oasis_ar[k]=-1 then
        begin
          if k<>(length(oasis_ar)-1) then
            move(oasis_ar[k+1],oasis_ar[k],(length(oasis_ar)-k-1)*sizeof(integer));
          setlength(oasis_ar,length(oasis_ar)-1);
        end
        else
          inc(k);
      until k>(length(oasis_ar)-1);  }

  //vichislaem dlinnu i shirinu tochnoy karti oblastey dereven'
  j:=0;
  k:=0;
  for i:=0 to length(vil_ar)-1 do
  begin
    tempx:=oblast[vil_ar[i]].r*2;
    if tempx>j then j:=tempx;
    k:=k+tempx;

    oblast[vil_ar[i]].x:=oblast[vil_ar[i]].x-(par.desert_par^.width div 2);
    oblast[vil_ar[i]].y:=oblast[vil_ar[i]].y-(par.desert_par^.len div 2);
  end;

  k:=(k)*16;
  j:=(j)*16;

  setlength(karta_tochn2_mas,k);
  for i:=0 to k-1 do
    setlength(karta_tochn2_mas[i],j);

  //generaciya tochnih heightmap
  postmessage(par.handle,WM_USER+327,0,0);
  //gen_tochn_oblasti(karta_tochn2_mas,oblast,@vil_ar,-282261449315523383,123519723383,0.0229125,0.0229125,9,par.handle,1);
  gen_tochn_oblasti(karta_tochn2_mas,oblast,@vil_ar,sid1,sid2,0.0229125,0.0229125,9,par.handle,1);


  if par.desert_par^.gen_preview=true then
  begin
    postmessage(par.handle,WM_USER+328,0,0);

  tempy:=length(karta_mas);
  if par.desert_par^.gen_prev_oasis=true then tempy:=max(tempy,length(karta_tochn_mas));
  if par.desert_par^.gen_prev_vil=true then tempy:=max(tempy,length(karta_tochn2_mas));

  tempx:=length(karta_mas[0]);
  if (length(karta_tochn_mas)<>0)and(par.desert_par^.gen_prev_oasis=true) then tempx:=tempx+length(karta_tochn_mas[0]);
  if (length(karta_tochn2_mas)<>0)and(par.desert_par^.gen_prev_vil=true) then tempx:=tempx+length(karta_tochn2_mas[0]);

  postmessage(par.handle,WM_USER+320,tempy,tempx);
  //postmessage(par.handle,WM_USER+320,max(length(karta_mas),length(karta_tochn_mas)),length(karta_mas[0])+length(karta_tochn_mas[0]));
  //postmessage(par.handle,WM_USER+320,length(karta_mas),length(karta_mas[0]));

  k:=0;

  //postmessage(par.handle,WM_USER+321,0,0);

  for i:=0 to length(karta_mas)-1 do
    for j:=0 to length(karta_mas[i])-1 do
    begin
      tempx:=(i shl 16)+j;
      postmessage(par.handle,WM_USER+322,tempx,karta_mas[i,j]);
      inc(k);
      if (k mod 3000)=0 then sleep(100);
    end;

  if par.desert_par^.gen_prev_oasis=true then
  for i:=0 to length(karta_tochn_mas)-1 do
    for j:=0 to length(karta_tochn_mas[i])-1 do
    begin
      tempx:=((i) shl 16)+(length(karta_tochn_mas[i])-1-j)+length(karta_mas[0]);
      postmessage(par.handle,WM_USER+322,tempx,karta_tochn_mas[i,j]);
      inc(k);
      if (k mod 3000)=0 then sleep(100);
    end;

  if length(karta_tochn_mas)<>0 then tempk:=length(karta_tochn_mas[0])
  else tempk:=0;

  if par.desert_par^.gen_prev_vil=true then
  for i:=0 to length(karta_tochn2_mas)-1 do
    for j:=0 to length(karta_tochn2_mas[i])-1 do
    begin
      tempx:=((i) shl 16)+(length(karta_tochn2_mas[i])-1-j)+length(karta_mas[0])+tempk;
      postmessage(par.handle,WM_USER+322,tempx,karta_tochn2_mas[i,j]);
      inc(k);
      if (k mod 3000)=0 then sleep(100);
    end;

    postmessage(par.handle,WM_USER+321,0,0);
  end;

  if par.desert_par^.gen_only_prev then goto exit_label;

  //delaem oazisi
  //for k:=0 to length(oblast)-1 do
  for j:=0 to length(oasis_ar)-1 do
  begin
    k:=oasis_ar[j];

    if oblast[k].tip=1 then continue;

    if (oblast[k].r<10)or(oblast[k].r1<10) then continue;

    tempx:=random(11)+10;  //radius oazisa po X
    tempz:=random(11)+11;  //radius oazisa po Z
    tempy:=random(5)+2;    //radius oazisov po Y
    tempk:=random(4)+3;    //raznica radiusov dvuh elipsov

    tempx:=tempx+tempk;
    tempz:=tempz+tempk;

    if tempx>oblast[k].r then tempx:=oblast[k].r;
    if tempz>oblast[k].r1 then tempz:=oblast[k].r1;

    i:=random(100);

    case i of
    0..33:begin  //green oasis
            z:=length(oasis_sferi_obsh);
            setlength(oasis_sferi_obsh,z+1);
            oasis_sferi_obsh[z].x:=oblast[k].x;
            oasis_sferi_obsh[z].y:=117;
            oasis_sferi_obsh[z].z:=oblast[k].y;
            oasis_sferi_obsh[z].radius_x:=tempx;
            oasis_sferi_obsh[z].radius_z:=tempz;
            oasis_sferi_obsh[z].radius_vert:=tempy;
            oasis_sferi_obsh[z].fill_material:=0; //trava

            z:=length(oasis_sferi);
            setlength(oasis_sferi,z+1);
            oasis_sferi[z].x:=oblast[k].x;
            oasis_sferi[z].y:=117;
            oasis_sferi[z].z:=oblast[k].y;
            oasis_sferi[z].radius_x:=tempx-tempk;
            oasis_sferi[z].radius_z:=tempz-tempk;
            oasis_sferi[z].radius_vert:=tempy-2;
            oasis_sferi[z].fill_material:=0;
            oasis_sferi[z].waterlevel:=117;
            oasis_sferi[z].flooded:=true;
          end;
    34..66:begin  //sand oasis
             z:=length(oasis_sferi_obsh);
             setlength(oasis_sferi_obsh,z+1);
             oasis_sferi_obsh[z].x:=oblast[k].x;
             oasis_sferi_obsh[z].y:=117;
             oasis_sferi_obsh[z].z:=oblast[k].y;
             oasis_sferi_obsh[z].radius_x:=tempx;
             oasis_sferi_obsh[z].radius_z:=tempz;
             oasis_sferi_obsh[z].radius_vert:=tempy;
             oasis_sferi_obsh[z].fill_material:=1; //pesok oasis

             z:=length(oasis_sferi);
             setlength(oasis_sferi,z+1);
             oasis_sferi[z].x:=oblast[k].x;
             oasis_sferi[z].y:=117;
             oasis_sferi[z].z:=oblast[k].y;
             oasis_sferi[z].radius_x:=tempx-tempk;
             oasis_sferi[z].radius_z:=tempz-tempk;
             oasis_sferi[z].radius_vert:=tempy-2;
             oasis_sferi[z].fill_material:=0;
             oasis_sferi[z].waterlevel:=117;
             oasis_sferi[z].flooded:=true;
           end;
    67..99:begin  //fake oasis
             z:=length(oasis_sferi_obsh);
             setlength(oasis_sferi_obsh,z+1);
             oasis_sferi_obsh[z].x:=oblast[k].x;
             oasis_sferi_obsh[z].y:=117;
             oasis_sferi_obsh[z].z:=oblast[k].y;
             oasis_sferi_obsh[z].radius_x:=tempx;
             oasis_sferi_obsh[z].radius_z:=tempz;
             oasis_sferi_obsh[z].radius_vert:=tempy;
             oasis_sferi_obsh[z].fill_material:=2; //pesok fake oasis

             z:=length(oasis_sferi);
             setlength(oasis_sferi,z+1);
             oasis_sferi[z].x:=oblast[k].x;
             oasis_sferi[z].y:=117;
             oasis_sferi[z].z:=oblast[k].y;
             oasis_sferi[z].radius_x:=tempx-tempk;
             oasis_sferi[z].radius_z:=tempz-tempk;
             oasis_sferi[z].radius_vert:=tempy-2;
             oasis_sferi[z].fill_material:=0;
             oasis_sferi[z].flooded:=false;
           end;
    end;
  end;

  fill_el_chunks(oasis_sferi_obsh);
  fill_el_chunks(oasis_sferi);

  village_counter:=0;

  //delaem derevni
  //for k:=0 to length(oblast)-1 do
  for j:=0 to length(vil_ar)-1 do
  begin
    k:=vil_ar[j];

    if oblast[k].tip=0 then continue;   

    if random<0.5 then
    begin
      z:=length(obj);
      setlength(obj,z+1);
      obj[z].x:=oblast[k].x;
      obj[z].y:=10;
      obj[z].z:=oblast[k].y;
      obj[z].id:=9;

      z:=length(sign_ar);
      setlength(sign_ar,z+1);
      sign_ar[z].x:=oblast[k].x-1;
      sign_ar[z].y:=13;
      sign_ar[z].z:=oblast[k].y-12;
      sign_ar[z].id:=village_counter;

      inc(village_counter);
    end
    else
    begin
      z:=length(obj);
      setlength(obj,z+1);
      obj[z].x:=oblast[k].x;
      obj[z].y:=10;
      obj[z].z:=oblast[k].y;
      obj[z].id:=8;

      z:=length(sign_ar);
      setlength(sign_ar,z+1);
      sign_ar[z].x:=oblast[k].x-1;
      sign_ar[z].y:=13;
      sign_ar[z].z:=oblast[k].y-11;
      sign_ar[z].id:=village_counter;

      inc(village_counter);
    end;
  end;


//////////////////////

  //peredaem koordinati spavna
  postmessage(par.handle,WM_USER+308,1,0);
  postmessage(par.handle,WM_USER+308,2,get_coord_alt(0,0,sid1,sid2,0.0229125,0.0229125,9)+1);
  postmessage(par.handle,WM_USER+308,3,0);


  //pereschitivaem nachalo i konec regionov i chankov, dla generacii granici karti
 // if par.border_par^.border_type<>0 then
  begin
    case par.border_par^.border_type of
    1:if par.border_par^.wall_void=true then
        begin
          par.fromx:=par.fromx-par.border_par^.wall_void_thickness;
          par.tox:=par.tox+par.border_par^.wall_void_thickness;
          par.fromy:=par.fromy-par.border_par^.wall_void_thickness;
          par.toy:=par.toy+par.border_par^.wall_void_thickness;
        end;
    2:begin
        par.fromx:=par.fromx-par.border_par^.void_thickness;
        par.tox:=par.tox+par.border_par^.void_thickness;
        par.fromy:=par.fromy-par.border_par^.void_thickness;
        par.toy:=par.toy+par.border_par^.void_thickness;
      end;
    3:if par.border_par^.cwall_gen_void=true then
      begin
        par.fromx:=par.fromx-par.border_par^.cwall_void_width;
        par.tox:=par.tox+par.border_par^.cwall_void_width;
        par.fromy:=par.fromy-par.border_par^.cwall_void_width;
        par.toy:=par.toy+par.border_par^.cwall_void_width;
      end;
    end;

    //opredelaem kol-vo region faylov, kotoroe sozdavat
    tempx:=(par.tox-par.fromx+1);      //kol-vo chankov po osam
    tempy:=(par.toy-par.fromy+1);

    if (par.fromx+par.tox+1)=0 then  //tolko po X, t.k. nuzhno razdelit raznie osi
    begin
      regx:=(tempx div 2) div 32;
      if ((tempx div 2) mod 32)<>0 then inc(regx);
      regx_nach:=-regx;
      regx:=regx*2;
    end
    else
    begin
      regx:= tempx div 32;
      if (tempx mod 32)<>0 then inc(regx);
      if par.fromx<0 then regx_nach:=-regx
      else regx_nach:=0;
    end;

    if (par.fromy+par.toy+1)=0 then  //tolko po Y
    begin
      regy:=(tempy div 2) div 32;
      if ((tempy div 2) mod 32)<>0 then inc(regy);
      regy_nach:=-regy;
      regy:=regy*2;
    end
    else
    begin
      regy:= tempy div 32;
      if (tempy mod 32)<>0 then inc(regy);
      if par.fromy<0 then regy_nach:=-regy
      else regy_nach:=0;
    end;
  end;

  //schetchik chankov
  co:=0;

  postmessage(par.handle,WM_USER+316,tempx*tempy,0);

  postmessage(par.handle,WM_USER+300,1,0);

  //postmessage(par.handle,WM_USER+316,0,0);

  //ochishaem massiv dla zapisi v fayl na vsakiy sluchay
  setlength(fdata,0);

  //osnovnie cikli generacii
  for i:=regx_nach to regx_nach+regx-1 do
    for j:=regy_nach to regy_nach+regy-1 do
  //i:=1;
  //j:=-3;
    begin
      thread_exit(param);

      //opredelaem nachalnie i konechnie chanki
      id:=1;
      if (i<0)and(j>=0) then id:=2
      else if (i<0)and(j<0) then id:=3
      else if (i>=0)and(j<0) then id:=4;

      if id=1 then
      begin
        //po osi X
        if i=regx_nach+regx-1 then
        begin
          otx:=0;
          dox:=par.tox mod 32;
        end
        else
        begin
          otx:=0;
          dox:=31;
        end;
        //po osi Y
        if j=regy_nach+regy-1 then
        begin
          oty:=0;
          doy:=par.toy mod 32;
        end
        else
        begin
          oty:=0;
          doy:=31;
        end;
      end;
      if id=2 then
      begin
        //po osi X
        if (i=regx_nach)and((par.fromx mod 32)<>0) then
        begin
          otx:=32+(par.fromx mod 32);
          dox:=31;
        end
        else
        begin
          otx:=0;
          dox:=31;
        end;
        //po osi Y
        if j=regy_nach+regy-1 then
        begin
          oty:=0;
          doy:=par.toy mod 32;
        end
        else
        begin
          oty:=0;
          doy:=31;
        end;
      end;
      if id=3 then
      begin
        //po osi X
        if (i=regx_nach)and((par.fromx mod 32)<>0) then
        begin
          otx:=32+(par.fromx mod 32);
          dox:=31;
        end
        else
        begin
          otx:=0;
          dox:=31;
        end;
        //po osi Y
        if (j=regy_nach)and((par.fromy mod 32)<>0) then
        begin
          oty:=32+(par.fromy mod 32);
          doy:=31;
        end
        else
        begin
          oty:=0;
          doy:=31;
        end;
      end;
      if id=4 then
      begin
        //po osi X
        if i=regx_nach+regx-1 then
        begin
          otx:=0;
          dox:=par.tox mod 32;
        end
        else
        begin
          otx:=0;
          dox:=31;
        end;
        //po osi Y
        if (j=regy_nach)and((par.fromy mod 32)<>0) then
        begin
          oty:=32+(par.fromy mod 32);
          doy:=31;
        end
        else
        begin
          oty:=0;
          doy:=31;
        end;
      end;

      //ochishaem kartu
      for k:=0 to 35 do
        for z:=0 to 35 do
        begin
          zeromemory(map[k][z].blocks,length(map[k][z].blocks));
          zeromemory(map[k][z].data,length(map[k][z].data));
          zeromemory(map[k][z].light,length(map[k][z].light));
          zeromemory(map[k][z].skylight,length(map[k][z].skylight));
          zeromemory(map[k][z].heightmap,length(map[k][z].heightmap));
          clear_all_entities(@map[k][z].entities,@map[k][z].tile_entities);
        end;

      //ochishaem head
      zeromemory(@head,sizeof(head));

      //peredaem soobshenie o nachale zapisi sfer v chanki
      postmessage(par.handle,WM_USER+309,i,j);

      //generiruem bloki
      for k:=0 to 35 do
        for z:=0 to 35 do
        begin
          thread_exit(param);

          if i<0 then tempx:=((i+1)*32-(32-k))
          else tempx:=(i*32)+k;

          if j<0 then  tempy:=((j*32)+z)
          else tempy:=(j+1)*32-(32-z);

          b1:=false;
          for tempz:=0 to length(pop_koord)-1 do
            if (pop_koord[tempz].x=(tempx-2))and
            (pop_koord[tempz].y=(tempy-2)) then
            begin
              b1:=true;
              break;
            end;

          if b1=false then
          begin
            tempz:=length(pop_koord);
            setlength(pop_koord,tempz+1);
            pop_koord[tempz].x:=tempx-2;
            pop_koord[tempz].y:=tempy-2;
          end;

          gen_desert_chunk(tempx-2,tempy-2,map[k][z].blocks,sid1,sid2,0.0229125,0.0229125,9,@obj,b1,par.desert_par^);

          //virezaem dirki
          gen_ellipse(tempx-2,tempy-2,map[k][z].blocks,oasis_sferi,@obj,b1,0);
          //zamenaem beraga i delaem rastitelnost'
          gen_ellipse(tempx-2,tempy-2,map[k][z].blocks,oasis_sferi_obsh,@obj,b1,1);

          gen_border(tempx-2,tempy-2,par.tox-par.fromx+1,par.toy-par.fromy+1,par.border_par^,map[k][z].blocks,map[k][z].data,@map[k][z].entities,@map[k][z].tile_entities);

          //generim heightmap
          calc_heightmap(map[k][z].blocks,map[k][z].heightmap);
        end;

      for k:=0 to length(obj)-1 do
      begin
        tempx:=get_block_id(map,i,j,obj[k].x,obj[k].y,obj[k].z);
        if tempx=255 then continue;
        case obj[k].id of
        250:begin   //kolonna dla testa
             for z:=1 to 127 do
               set_block_id(map,i,j,obj[k].x,z,obj[k].z,4);
           end;
        0:begin     //mertviy kust
            if (tempx=0)and(get_block_id(map,i,j,obj[k].x,obj[k].y-1,obj[k].z)=12) then
              set_block_id(map,i,j,obj[k].x,obj[k].y,obj[k].z,32);
          end;
        1:begin     //trostnik
            gen_reed(map,i,j,obj[k].x,obj[k].y,obj[k].z,sid1+k);
          end;
        2:begin     //pal'ma
            gen_palm(map,i,j,obj[k].x,obj[k].y,obj[k].z,0,sid1+k);
          end;
        3:begin     //trava
            tempk:=get_block_id(map,i,j,obj[k].x,obj[k].y-1,obj[k].z);
            if (tempk=2)or(tempk=3) then
              set_block_id_data(map,i,j,obj[k].x,obj[k].y,obj[k].z,31,1);
          end;
        4:begin     //vipuklost'
            gen_vipuklost(map,i,j,obj[k].x,obj[k].y,obj[k].z);
          end;
        5:begin     //zalezhi soli (graviy)
            gen_salt(map,i,j,obj[k].x,obj[k].y,obj[k].z,sid1+k);
          end;
        6:begin     //pal'ma bez list'ev
            gen_palm(map,i,j,obj[k].x,obj[k].y,obj[k].z,1,sid1+k);
          end;
        7:begin     //podsohshaya trava
            if (tempx=0)and(get_block_id(map,i,j,obj[k].x,obj[k].y-1,obj[k].z)=12) then
              set_block_id(map,i,j,obj[k].x,obj[k].y,obj[k].z,31);
          end;
        8:begin    //derevna nomer 1
            gen_vil1(map,i,j,obj[k].x,obj[k].y,obj[k].z);
          end;
        9:begin    //derevna nomer 2
            gen_vil2(map,i,j,obj[k].x,obj[k].y,obj[k].z);
          end;
        10:begin   //znak (stoyachiy)
             //place_sign(map,i,j,obj[k].x,obj[k].y,obj[k].z,0,'Welcome to','',village_names[1],'',true);
           end;
        11:begin  //znak (na stene)
             //place_sign(map,i,j,obj[k].x,obj[k].y,obj[k].z,2,'Welcome to','',village_names[1],'',false);
             //place_sign(map,i,j,obj[k].x,obj[k].y,obj[k].z,2,'Welcome to','',par.desert_par^.vil_names[village_counter],'',false);
           end;
        12:begin  //kaktus
             gen_cactus(map,i,j,obj[k].x,obj[k].y,obj[k].z,sid1+k);
           end;
        end;
      end;

      for k:=0 to length(sign_ar)-1 do
      begin
        tempx:=get_block_id(map,i,j,sign_ar[k].x,sign_ar[k].y,sign_ar[k].z);
        if tempx=255 then continue;

        place_sign(map,i,j,sign_ar[k].x,sign_ar[k].y,sign_ar[k].z,0,'Welcome to','',par.desert_par^.vil_names[sign_ar[k].id],'',false);
      end;

      //peredaem soobshenie o nachale proscheta sveta
      postmessage(par.handle,WM_USER+310,i,j);

      //schitaem skylight srazu dla vsego regiona
      calc_skylight(map,otx,oty,dox,doy);

      //schitaem blocklight
      calc_blocklight(map,otx,oty,dox,doy);

      //ispolzuem massiv dla hraneniya informacii, kotoruyu budem zapisivat' v fayl
      //setlength(fdata,0);

      //peredaem soobshenie o nachale zapisi chankov na disk
      postmessage(par.handle,WM_USER+306,i,j);

      tempk:=2;
      for k:=otx to dox do
        for z:=oty to doy do
        begin
          thread_exit(param);

          //opredelaem obshie koordinati chanka
          if i<0 then tempx:=((i+1)*32-(32-k))
          else tempx:=(i*32)+k;

          if j<0 then  tempy:=((j*32)+z)
          else tempy:=(j+1)*32-(32-z);


          nbtcompress2(tempx,tempy,map[k+2][z+2].blocks,map[k+2][z+2].data,map[k+2][z+2].skylight,map[k+2][z+2].light,map[k+2][z+2].heightmap,map[k+2][z+2].entities,map[k+2][z+2].tile_entities,not(par.desert_par^.pop_chunks),@rez);
          //else nbtcompress2(tempx,tempy,map[k+2][z+2].blocks,map[k+2][z+2].data,map[k+2][z+2].skylight,map[k+2][z+2].light,map[k+2][z+2].heightmap,nil,nil,true,@rez);


          //ToDO: poprobovat' druguyu funkciyu szhatiya, chtobi ne ispol'zovat' stroki
          setlength(str,length(rez));
          move(rez[0],str[1],length(rez));

          strcompress:=zcompressstr(str);

          tempx:=length(strcompress)+1;
          str:=inttohex(tempx,8);
          str:=chr(bintoint(hextobin(copy(str,1,2))))+chr(bintoint(hextobin(copy(str,3,2))))+
            chr(bintoint(hextobin(copy(str,5,2))))+chr(bintoint(hextobin(copy(str,7,2))));
          str:=str+#2;
          str:=str+strcompress;
          while (length(str) mod 4096)<>0 do
            str:=str+#0;

          //dobavlaem blok dannih v obshiy massiv
          tempx:=length(fdata);
          setlength(fdata,length(fdata)+length(str));

          move(str[1],fdata[tempx],length(str));

          //izmenaem head
          tempx:=length(str) div 4096;
          //if tempx>1 then
            str:=inttohex(tempk,6)+inttohex(tempx,2);
            tempy:=bintoint(hextobin(str));
            btolendian(tempy);
            head.mclocations[(k+(z*32))+1]:=tempy;
            if tempx>1 then
              inc(tempk,tempx-1);

          inc(tempk);
          inc(co);
          postmessage(par.handle,WM_USER+303,par.id,co);
        end;

      hndl:=createfile(pchar('r.'+inttostr(i)+'.'+inttostr(j)+'.mcr'),
      GENERIC_WRITE,
      0,
      nil,
      CREATE_ALWAYS,
      FILE_ATTRIBUTE_NORMAL,
      0);

      if hndl=INVALID_HANDLE_VALUE then
        postmessage(par.handle,WM_USER+304,300,-2000);

      writefile(hndl,head,sizeof(head),count,nil);
        //postmessage(par.handle,WM_USER+304,300,-4000);

      writefile(hndl,fdata[0],length(fdata),count,nil);

      closehandle(hndl);

      postmessage(par.handle,WM_USER+319,0,length(fdata));

      setlength(fdata,0);

      thread_exit(param);
    end;

  exit_label:

  //ochishaem pamat ot karti
  for i:=0 to 35 do
    for j:=0 to 35 do
    begin
      clear_all_entities(@map[i][j].entities,@map[i][j].tile_entities);
      setlength(map[i][j].blocks,0);
      setlength(map[i][j].data,0);
      setlength(map[i][j].light,0);
      setlength(map[i][j].skylight,0);
      setlength(map[i][j].heightmap,0);
    end;

  for i:=0 to 35 do
    setlength(map[i],0);

  setlength(map,0);

  setlength(rez,0);

  setlength(obj,0);
  setlength(pop_koord,0);

  setlength(sign_ar,0);

  setlength(oasis_sferi_obsh,0);
  setlength(oasis_sferi,0);

  postmessage(par.handle,WM_USER+301,par.id,0);
  endthread(0);
end;

end.

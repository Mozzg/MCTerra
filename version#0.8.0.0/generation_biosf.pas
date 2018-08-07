unit generation_biosf;

interface

function gen_biosphere_thread(Parameter:pointer):integer;

implementation

uses Windows, Math, NoiseGeneratorOctaves_u, generation_obsh, generation_spec, NBT, RandomMCT, zlibex, sysutils;

procedure gen_bio_skyholes(var map:region; xreg,yreg,x,y,z:integer; par:bio_settings_type);
var chx,chy:integer;
xx,zz,k,t,z1:integer;
tempxot,tempxdo,tempyot,tempydo:integer;
b:boolean;
begin
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

    dec(tempxot,2);
    dec(tempxdo,2);
    dec(tempyot,2);
    dec(tempydo,2);

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

      b:=false;
      for k:=y to 127 do
      begin
        z1:=map[chx][chy].blocks[k+(zz*128+(xx*2048))];
        if (z1=par.sphere_material)or(z1=20) then
        begin
          b:=true;
          t:=k;
          break;
        end;
      end;

      if b=true then
        for k:=127 downto t do
          map[chx][chy].blocks[k+(zz*128+(xx*2048))]:=20;

    end;
end;

function place_bio_spawners(var map:region; xreg,yreg,x,y,z,tip:integer; sid:int64):boolean;
var tempxot,tempxdo,tempyot,tempydo:integer;
chx,chy,xx,yy,zz,t:integer;
begin
    if (y<0)or(y>127) then
    begin
      result:=false;
      exit;
    end;

    //schitaem koordinati nachalnih i konechnih chankov v regione
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

    dec(tempxot,2);
    dec(tempxdo,2);
    dec(tempyot,2);
    dec(tempydo,2);

    //opredelaem, k kakomu chanku otnositsa
    chx:=x;
    chy:=z;

    if chx<0 then inc(chx);
    if chy<0 then inc(chy);

    chx:=chx div 16;
    chy:=chy div 16;

    if (chx<=0)and(x<0) then dec(chx);
    if (chy<=0)and(z<0) then dec(chy);

    if (chx>=tempxot)and(chx<=tempxdo)and(chy>=tempyot)and(chy<=tempydo) then
    begin
      //perevodim v koordinati chanka
      xx:=x mod 16;
      zz:=z mod 16;
      if xx<0 then inc(xx,16);
      if zz<0 then inc(zz,16);
      yy:=y;

      chx:=chx-tempxot;
      chy:=chy-tempyot;

      map[chx][chy].blocks[yy+(zz*128+(xx*2048))]:=52;

      //dobavlaem tileentity
      t:=length(map[chx][chy].tile_entities);
      setlength(map[chx][chy].tile_entities,t+1);
      map[chx][chy].tile_entities[t].id:='MobSpawner';
      map[chx][chy].tile_entities[t].x:=x;
      map[chx][chy].tile_entities[t].y:=y;
      map[chx][chy].tile_entities[t].z:=z;
      new(pmon_spawn_tile_entity_data(map[chx][chy].tile_entities[t].dannie));
      if tip=0 then
        pmon_spawn_tile_entity_data(map[chx][chy].tile_entities[t].dannie)^.entityid:='Ghast'
      else
        pmon_spawn_tile_entity_data(map[chx][chy].tile_entities[t].dannie)^.entityid:='PigZombie';
      pmon_spawn_tile_entity_data(map[chx][chy].tile_entities[t].dannie)^.delay:=100;

      result:=true;
    end
    else result:=false;
end;

procedure clear_bio_leaves2(xkoord,ykoord,width,len:integer; var blocks:array of byte; par:bio_settings_type; border:border_settings_type);
var i,j,k,t:integer;
tempx,tempy:integer;
begin
  tempx:=-(width div 2);
  tempy:=-(len div 2);

  //esli nahodimsa za granicey karti
  if (xkoord<tempx)or
  (xkoord>(width div 2)-1)or
  (ykoord<tempy)or
  (ykoord>(len div 2)-1) then exit;

  if border.border_type=1 then
  begin
    if border.wall_void=true then
    begin
      tempx:=-(width div 2)+border.wall_void_thickness;
      tempy:=-(len div 2)+border.wall_void_thickness;

      if (xkoord<=tempx)or(xkoord>=(width div 2)-1-border.wall_void_thickness)or
      (ykoord<=tempy)or(ykoord>=(len div 2)-1-border.wall_void_thickness) then exit;
    end
    else
    begin
      tempx:=-(width div 2);
      tempy:=-(len div 2);

      if (xkoord<=tempx)or(xkoord>=(width div 2)-1)or
      (ykoord<=tempy)or(ykoord>=(len div 2)-1) then exit;
    end;
  end
  else if border.border_type=2 then
  begin
    tempx:=-(width div 2)+border.void_thickness;
    tempy:=-(len div 2)+border.void_thickness;

    if (xkoord<=tempx)or(xkoord>=(width div 2)-1-border.void_thickness)or
    (ykoord<=tempy)or(ykoord>=(len div 2)-1-border.void_thickness) then exit;
  end
  else if border.border_type=3 then
  begin
    if border.cwall_gen_void=true then
    begin
      tempx:=-(width div 2)+border.cwall_void_width;
      tempy:=-(len div 2)+border.cwall_void_width;

      if (xkoord<=tempx)or(xkoord>=(width div 2)-1-border.cwall_void_width)or
      (ykoord<=tempy)or(ykoord>=(len div 2)-1-border.cwall_void_width) then exit;
    end
    else
    begin
      tempx:=-(width div 2);
      tempy:=-(len div 2);

      if (xkoord<=tempx)or(xkoord>=(width div 2)-1)or
      (ykoord<=tempy)or(ykoord>=(len div 2)-1) then exit;
    end;
  end;

      for i:=0 to 15 do //x
        for j:=0 to 15 do  //z
        begin
          for k:=127 downto 1 do //y
          begin
            t:=blocks[k+(j*128+(i*2048))];
            //if (t=par.sphere_material)or(t=1)or(t=20)or(t=16)or(t=14)or(t=15)or(t=par.bridge_material)or(t=par.bridge_rail_material) then break;

            if (t<>0)and(t<>17)and(t<>18) then break;
            //if (t=18)or(t=17) then
              if par.underwater=true then
              begin
                if blocks[k-1+(j*128+(i*2048))]<>0 then blocks[k+(j*128+(i*2048))]:=8
                else blocks[k+(j*128+(i*2048))]:=9;
              end
              else blocks[k+(j*128+(i*2048))]:=0;
          end;
          for k:=0 to 127 do //y
          begin
            t:=blocks[k+(j*128+(i*2048))];
            //if (t=par.sphere_material)or(t=1)or(t=20)or(t=16)or(t=par.bridge_material)or(t=par.bridge_rail_material) then break;

            if (t<>0)and(t<>17)and(t<>18) then break;
            //if (t=18)or(t=17) then
              if par.underwater=true then blocks[k+(j*128+(i*2048))]:=9
              else blocks[k+(j*128+(i*2048))]:=0;
          end;
        end;
end;

procedure calc_bio_lakes_alt(var lakes:ar_elipse_settings; sid:int64; flat:boolean);
var rand:rnd;
noise:NoiseGeneratorOctaves;
noise_mas:ar_double;
k,i,j,min:integer;
begin
  setlength(noise_mas,256);
  rand:=rnd.Create(sid);
  noise:=NoiseGeneratorOctaves.create(rand,4);

  for k:=0 to length(lakes)-1 do
  begin
    min:=128;
    for i:=0 to length(lakes[k].chunks)-1 do
    begin
      noise_mas:=noise.generateNoiseOctaves(noise_mas,(lakes[k].chunks[i].x)*16,0,(lakes[k].chunks[i].y)*16,16,1,16,0.0075625,1,0.0075625, flat);
      for j:=0 to 255 do
      begin
        noise_mas[j]:=64+noise_mas[j]*8;
        if noise_mas[j]<1 then noise_mas[j]:=1;
        if noise_mas[j]>120 then noise_mas[j]:=120;

        if round(noise_mas[j])<min then min:=round(noise_mas[j]);
      end;
    end;
    lakes[k].y:=min;
    dec(lakes[k].radius_x,2);
    dec(lakes[k].radius_z,2);
    dec(lakes[k].radius_vert,2);
  end;

  setlength(noise_mas,0);
  noise.Free;
  rand.Free;
end;

procedure gen_bio_lakes(xkoord,ykoord:integer;var blocks:array of byte; var sferi:ar_elipse_settings; sid:int64);
var i,j,k,l,f:integer;
vih:boolean;
x1,z1,y1,r_x,r_y,r_z,z11,z22:integer;
temp:extended;
begin
  for k:=0 to length(sferi)-1 do
  begin
    vih:=true;
    for l:=0 to length(sferi[k].chunks)-1 do
      if (sferi[k].chunks[l].x=xkoord)and(sferi[k].chunks[l].y=ykoord) then
      begin
        vih:=false;
      end;

    if vih=true then continue;

    x1:=xkoord*16;
    z1:=ykoord*16;
    x1:=sferi[k].x-x1;
    z1:=sferi[k].z-z1;
    y1:=sferi[k].y;
    r_x:=sferi[k].radius_x;
    r_z:=sferi[k].radius_z;
    r_y:=sferi[k].radius_vert;

    for i:=0 to 15 do  //Z        //levo pravo
      for j:=y1-round((r_y/3)*2) to y1+round((r_y/3)*2) do   //Y
      begin
        if (j<0)or(j>127) then continue;
        temp:=sqr(r_x)*(1-sqr((j-y1)/r_y)-sqr((i-z1)/r_z));
        if temp<0 then continue;
        z11:=x1+round(sqrt(temp));
        z22:=x1-round(sqrt(temp));
        for l:=z22 to z11 do
          if (l>=0)and(l<=15) then
          begin
            if j>y1 then f:=0
            else
            begin
              if (sferi[k].fill_material=0) then
                if (sferi[k].flooded=true)and(j=y1) then f:=79
                else f:=8;
              if (sferi[k].fill_material=1) then f:=10;
            end;
            blocks[j+(i*128+(l*2048))]:=f;
          end;
      end;

    for i:=0 to 15 do  //X        //pered zad
      for j:=y1-round((r_y/3)*2) to y1+round((r_y/3)*2) do   //Y
      begin
        if (j<0)or(j>127) then continue;
        temp:=sqr(r_z)*(1-sqr((i-x1)/r_x)-sqr((j-y1)/r_y));
        if temp<0 then continue;
        z11:=z1+round(sqrt(temp));
        z22:=z1-round(sqrt(temp));
        for l:=z22 to z11 do
          if (l>=0)and(l<=15) then
          begin
            if j>y1 then f:=0
            else
            begin
              if (sferi[k].fill_material=0) then
                if (sferi[k].flooded=true)and(j=y1) then f:=79
                else f:=8;
              if (sferi[k].fill_material=1) then f:=10;
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
          if (l>=1)and(l<=127) then
          begin
            if l>y1 then f:=0
            else
            begin
              if (sferi[k].fill_material=0) then
                if (sferi[k].flooded=true)and(l=y1) then f:=79
                else f:=8;
              if (sferi[k].fill_material=1) then f:=10;
            end;
            blocks[l+(j*128+(i*2048))]:=f;
          end;
      end;

  end;

  //ubiraem visashiy sneg
  for i:=0 to 15 do //X
    for j:=0 to 15 do //Z
      for k:=1 to 127 do //Y
        if (blocks[k+(j*128+(i*2048))]=78)and
        (blocks[(k-1)+(j*128+(i*2048))]=0) then
          blocks[k+(j*128+(i*2048))]:=0;
          
end;

procedure gen_bio_bridge(xkoord,ykoord:integer;var blocks:array of byte;var tun:array of tunnels_settings; map_type:byte; sid:int64; par:bio_settings_type; ar_res:par_tlights_koord);
var i,j,k,z,t,h:integer;
dl1:extended;
vih,b:boolean;
x1,z1,y1:integer;
xx,yy,zz:extended;
rand:rnd;
noise:NoiseGeneratorOctaves;
noise_mas:ar_double;
begin
  setlength(noise_mas,256);
  rand:=rnd.Create(sid);
  noise:=NoiseGeneratorOctaves.create(rand,4);

  noise_mas:=noise.generateNoiseOctaves(noise_mas,(xkoord)*16,0,(ykoord)*16,16,1,16,0.0075625,1,0.0075625,not(par.gen_noise));
  for k:=0 to 255 do
  begin
    noise_mas[k]:=64+noise_mas[k]*8;
    if noise_mas[k]<1 then noise_mas[k]:=1;
    if noise_mas[k]>120 then noise_mas[k]:=120;
  end;

  for k:=0 to length(tun)-1 do
  begin
    vih:=true;
    for t:=0 to length(tun[k].chunks)-1 do
      if (tun[k].chunks[t].x=xkoord)and(tun[k].chunks[t].y=ykoord) then
      begin
        vih:=false;
        break;
      end;

    if vih=true then continue;

    //vichisaem otnositelnie koordinati
    x1:=xkoord*16;
    z1:=ykoord*16;

    x1:=tun[k].x1-x1;
    z1:=tun[k].z1-z1;
    y1:=tun[k].y1;

    dl1:=sqrt(sqr(tun[k].x2-tun[k].x1)+sqr(tun[k].y2-tun[k].y1)+sqr(tun[k].z2-tun[k].z1));

    for z:=62 to 66 do  //Y
    //z:=64;
      for i:=0 to 15 do  //X
        for j:=0 to 15 do  //Z
        begin
          xx:=(i-x1)*tun[k].c2x+(z-y1)*tun[k].c2y+(j-z1)*tun[k].c2z;
          yy:=(i-x1)*tun[k].c1x+(z-y1)*tun[k].c1y+(j-z1)*tun[k].c1z;
          zz:=(i-x1)*tun[k].c3x+(z-y1)*tun[k].c3y+(j-z1)*tun[k].c3z;

          if (zz>=-0.5)and(zz<=0.5)and(xx<=((par.bridge_width div 2)+1))and(xx>=((par.bridge_width div 2)+1)*-1)and(yy>=0)and(yy<=dl1) then
          begin
            h:=round(noise_mas[j+i*16]);

            //uznaem, est' li nad nami blok sferi
            b:=false;
            for t:=h+1 to h+5 do
              if blocks[t+(j*128+(i*2048))]=par.sphere_material then
              begin
                b:=true;
                break;
              end;

            //if (blocks[h+(j*128+(i*2048))]=0)or(blocks[h+(j*128+(i*2048))]=1)or(blocks[h+(j*128+(i*2048))]=par.bridge_material) then
            for t:=h+1 to h+4 do
              if (blocks[t+(j*128+(i*2048))]<>78) then
                blocks[t+(j*128+(i*2048))]:=0;     

            t:=blocks[h+(j*128+(i*2048))];
            if ((t=0)or(t=1)or(b=true))and(t<>par.bridge_material) then
            begin
              blocks[h+(j*128+(i*2048))]:=par.bridge_material;
              if par.underwater=true then blocks[h+5+(j*128+(i*2048))]:=20;
              if ((xx<=((par.bridge_width div 2)+1))and(xx>(par.bridge_width div 2))or((xx>=((par.bridge_width div 2)+1)*-1)and(xx<((par.bridge_width div 2)*-1)))) then
              begin
                blocks[h+1+(j*128+(i*2048))]:=par.bridge_rail_material;
                if (par.underwater=true) then
                begin
                  for t:=h+2 to h+5 do blocks[t+(j*128+(i*2048))]:=20;
                  if((round(yy) mod 10)=0) then
                    if par.gen_skyholes=false then blocks[h+1+(j*128+(i*2048))]:=89
                    else
                    begin
                      t:=length(ar_res^);
                      setlength(ar_res^,t+1);
                      ar_res^[t].x:=i+xkoord*16;
                      ar_res^[t].y:=h+1;
                      ar_res^[t].z:=j+ykoord*16;
                      ar_res^[t].id:=14;
                    end;
                end;
              end;
            end;
          end;
        end;
  end;

  setlength(noise_mas,0);
  noise.Free;
  rand.Free;
end;

procedure gen_bio_ellipse(xkoord,ykoord:integer;var blocks:array of byte;var sferi:ar_elipse_settings; trees:par_tlights_koord; map_type:byte; sid:int64; populated:boolean; par:bio_settings_type);
var rand:rnd;
noise:NoiseGeneratorOctaves;
noise_mas:ar_double;
i,j,k,l,t,f,len:integer;
vih:boolean;
x1,y1,z1,r_x,r_y,r_z,z11,z22:integer;
temp:extended;
begin
  setlength(noise_mas,256);
  rand:=rnd.Create(sid);
  noise:=NoiseGeneratorOctaves.create(rand,4);

  noise_mas:=noise.generateNoiseOctaves(noise_mas,(xkoord)*16,0,(ykoord)*16,16,1,16,0.0075625,1,0.0075625,not(par.gen_noise));
  for k:=0 to 255 do
  begin
    noise_mas[k]:=64+noise_mas[k]*8;
    if noise_mas[k]<1 then noise_mas[k]:=1;
    if noise_mas[k]>120 then noise_mas[k]:=120;
  end;

  //perechislaem vse sferi
  for k:=0 to length(sferi)-1 do
  begin
    vih:=true;
    for l:=0 to length(sferi[k].chunks)-1 do
      if (sferi[k].chunks[l].x=xkoord)and(sferi[k].chunks[l].y=ykoord) then
      begin
        vih:=false;
      end;

    if vih=true then continue;

    rand.SetSeed(sferi[k].x*3467+sferi[k].y*7601+sferi[k].z*3971+xkoord*1346+ykoord*4671);

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
            if (map_type=2)or(map_type=3) then
            begin
              f:=1;
              blocks[j+(i*128+(l*2048))]:=f;
            end
            else if (map_type=0)or(map_type=1) then
            begin
            t:=round(noise_mas[i+l*16]);

            if (l=z22)or(l=z11) then
            begin
              if j<=t then f:=1
              else f:=par.sphere_material;
            end
            else if j<=t then
            begin
              //generim osveshenie esli nuzhno
              if ((par.underwater=true)or(par.sphere_material=79)or(not(par.sphere_material in trans_bl)))and
              (j=t)and(populated=false)and(rand.nextDouble<0.02)and(par.gen_skyholes=false) then
              begin
                len:=length(trees^);
                setlength(trees^,len+1);
                trees^[len].x:=l+xkoord*16;
                trees^[len].y:=j+1;
                trees^[len].z:=i+ykoord*16;
                trees^[len].id:=13;
              end;
              //generim skyholes esli nuzhno
              if (par.gen_skyholes=true)and(j=t)and
              (populated=false)and(rand.nextDouble<0.01) then
              begin
                len:=length(trees^);
                setlength(trees^,len+1);
                trees^[len].x:=l+xkoord*16;
                trees^[len].y:=j+1;
                trees^[len].z:=i+ykoord*16;
                trees^[len].id:=14;
              end;
              case sferi[k].fill_material of
              0,1,3:begin
                      if (j<t)and(j>=t-2) then f:=3
                      else if j=t then
                      begin
                        f:=2;
                        if (rand.nextDouble<0.02)and(populated=false)and
                        (sferi[k].fill_material<>3) then
                        begin
                          len:=length(trees^);
                          setlength(trees^,len+1);
                          trees^[len].x:=l+xkoord*16;
                          trees^[len].y:=j+1;
                          trees^[len].z:=i+ykoord*16;
                          if (rand.nextDouble<0.2)or(sferi[k].fill_material=1) then trees^[len].id:=1
                          else if rand.nextDouble<0.07 then trees^[len].id:=7
                          else trees^[len].id:=0;
                        end
                        else if (rand.nextDouble<0.08)and(populated=false)then
                        begin
                          len:=length(trees^);
                          setlength(trees^,len+1);
                          trees^[len].x:=l+xkoord*16;
                          trees^[len].y:=j+1;
                          trees^[len].z:=i+ykoord*16;
                          if (rand.nextDouble<0.1)and
                          (sferi[k].fill_material<>1) then trees^[len].id:=3
                          else trees^[len].id:=2;
                        end;
                      end
                      else f:=1;
                    end;
              2:begin
                  if (j<=t)and(j>=t-2) then
                  begin
                    f:=12;
                    if j=t then
                      if (rand.nextDouble<0.008)and(populated=false) then
                      begin
                        len:=length(trees^);
                        setlength(trees^,len+1);
                        trees^[len].x:=l+xkoord*16;
                        trees^[len].y:=j+1;
                        trees^[len].z:=i+ykoord*16;
                        trees^[len].id:=5;
                      end
                      else if (rand.nextDouble<0.002)and(populated=false) then
                      begin
                        len:=length(trees^);
                        setlength(trees^,len+1);
                        trees^[len].x:=l+xkoord*16;
                        trees^[len].y:=j+1;
                        trees^[len].z:=i+ykoord*16;
                        trees^[len].id:=6;
                      end;
                  end
                  else f:=1;
                end;
              4,6:begin
                    if (j<t)and(j>=t-2) then f:=3
                    else if j=t then
                    begin
                      f:=2;
                      if (rand.nextDouble<0.02)and(populated=false)and
                      (sferi[k].fill_material=4) then
                      begin
                        len:=length(trees^);
                        setlength(trees^,len+1);
                        trees^[len].x:=l+xkoord*16;
                        trees^[len].y:=j+1;
                        trees^[len].z:=i+ykoord*16;
                        if rand.nextDouble<0.333333 then trees^[len].id:=8
                        else trees^[len].id:=9;
                      end
                      else if (rand.nextDouble<0.008)and(populated=false)and
                      (sferi[k].fill_material=4) then
                      begin
                        len:=length(trees^);
                        setlength(trees^,len+1);
                        trees^[len].x:=l+xkoord*16;
                        trees^[len].y:=j+1;
                        trees^[len].z:=i+ykoord*16;
                        trees^[len].id:=4;
                      end;
                    end
                    else f:=1;
                  end;
              5:begin
                  if (j<=t)and(j>=t-2) then f:=12
                  else f:=1;
                end;
              7:begin
                  if (j<=t)and(j>=t-2) then
                  begin
                    f:=87;
                    if (j=t)and(rand.nextDouble<0.013)and(populated=false) then
                    begin
                      len:=length(trees^);
                      setlength(trees^,len+1);
                      trees^[len].x:=l+xkoord*16;
                      trees^[len].y:=j+1;
                      trees^[len].z:=i+ykoord*16;
                      if rand.nextDouble<0.3 then trees^[len].id:=11
                      else trees^[len].id:=10;
                    end;
                    if (j=t)and(rand.nextDouble<0.01)and(populated=false) then
                    begin
                      len:=length(trees^);
                      setlength(trees^,len+1);
                      trees^[len].x:=l+xkoord*16;
                      trees^[len].y:=j+1;
                      trees^[len].z:=i+ykoord*16;
                      trees^[len].id:=12;
                    end;
                  end
                  else f:=1;
                end;
              end;
            end
            else if (j=t+1)and
            ((sferi[k].fill_material=4)or
            (sferi[k].fill_material=5)or
            (sferi[k].fill_material=6)) then f:=78
            else f:=0;

            blocks[j+(i*128+(l*2048))]:=f;
            end;
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
            if (map_type=2)or(map_type=3) then
            begin
              f:=1;
              blocks[j+(l*128+(i*2048))]:=f;
            end
            else if (map_type=0)or(map_type=1) then
            begin
            t:=round(noise_mas[l+i*16]);

            if (l=z22)or(l=z11) then
            begin
              if j<=t then f:=1
              else f:=par.sphere_material;
            end
            else f:=0;

            if (f<>0) then
              blocks[j+(l*128+(i*2048))]:=f;
            end;
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
          if (l>=1)and(l<=127) then
          begin
            if (map_type=2)or(map_type=3) then
            begin
              t:=rand.nextInt(1000);
              case t of
                0..806:f:=1;  //stone
                807..861:f:=14; //gold
                862..916:f:=15; //iron
                917..939:f:=21; //lapis
                940..964:f:=56; //diamond
                965..999:f:=73; //redstone
              end;
              blocks[l+(j*128+(i*2048))]:=f;
            end
            else if (map_type=0)or(map_type=1) then
            begin
            t:=round(noise_mas[j+i*16]);

            if blocks[l+(j*128+(i*2048))]=0 then
            begin
              if (l=z22)or(l=z11) then
              begin
                if l<=t then f:=1
                else f:=par.sphere_material;
              end
              else if (l<t) then f:=1
              else f:=0;

              if (f<>0) then
                blocks[l+(j*128+(i*2048))]:=f;
              end;
            end;
          end;
      end;
  end;


  setlength(noise_mas,0);
  noise.Free;
  rand.Free;
end;

procedure gen_bio_biomes(sf:ar_elipse_settings; par:bio_settings_type);
var i,k:integer;
biomes:set_trans_blocks;
r:rnd;
begin
  //formiruem biomi
  biomes:=[];
  if par.biomes.forest then biomes:=biomes+[0];
  if par.biomes.rainforest then biomes:=biomes+[1];
  if par.biomes.desert then biomes:=biomes+[2];
  if par.biomes.plains then biomes:=biomes+[3];
  if par.biomes.taiga then biomes:=biomes+[4];
  if par.biomes.ice_desert then biomes:=biomes+[5];
  if par.biomes.tundra then biomes:=biomes+[6];
  if par.biomes.hell then biomes:=biomes+[7];

  r:=rnd.Create;

  for i:=0 to length(sf)-1 do
  begin
    r.SetSeed(sf[i].x*1468+sf[i].y*2471+sf[i].z*4687);
    repeat       
      k:=round(r.nextDouble*7);
      //k:=random(8);
    until (k in biomes);
    if i=0 then k:=0;
    sf[i].fill_material:=k;
  end;

  r.Free;
end;

function tunnel_intersection_sphere(ar_tun:array of tunnels_settings; indeks:integer; ar_sf:ar_elipse_settings; iskl:array of integer):boolean;
var b_ind, b_var:boolean;
fromind,toind:integer;
i,j:integer;
x1,y1,z1,x2,y2,z2,d:extended;
begin
  //opredelenie osi, po kotoroy budem idti
  if abs(ar_tun[indeks].x1-ar_tun[indeks].x2)<abs(ar_tun[indeks].z1-ar_tun[indeks].z2) then
  begin
    b_ind:=true;
    fromind:=min(ar_tun[indeks].z1,ar_tun[indeks].z2);
    toind:=max(ar_tun[indeks].z1,ar_tun[indeks].z2);
  end
  else
  begin
    b_ind:=false;
    fromind:=min(ar_tun[indeks].x1,ar_tun[indeks].x2);
    toind:=max(ar_tun[indeks].x1,ar_tun[indeks].x2);
  end;

  for i:=0 to length(ar_sf)-1 do
  begin
    b_var:=false;
    for j:=0 to length(iskl)-1 do
      if iskl[j]=i then b_var:=true;

    if b_var=true then continue;

    for j:=fromind to toind do
    begin
      //schitaem koordinati tochki v tunele
      if b_ind=true then
        begin
          z1:=j;
          x1:=ar_tun[indeks].x1+(ar_tun[indeks].x2-ar_tun[indeks].x1)*((z1-ar_tun[indeks].z1)/(ar_tun[indeks].z2-ar_tun[indeks].z1));
          y1:=ar_tun[indeks].y1+(ar_tun[indeks].y2-ar_tun[indeks].y1)*((z1-ar_tun[indeks].z1)/(ar_tun[indeks].z2-ar_tun[indeks].z1));
        end
        else
        begin
          x1:=j;
          y1:=ar_tun[indeks].y1+(ar_tun[indeks].y2-ar_tun[indeks].y1)*((x1-ar_tun[indeks].x1)/(ar_tun[indeks].x2-ar_tun[indeks].x1));
          z1:=ar_tun[indeks].z1+(ar_tun[indeks].z2-ar_tun[indeks].z1)*((x1-ar_tun[indeks].x1)/(ar_tun[indeks].x2-ar_tun[indeks].x1));
        end;

      //prisvaivaem vtoruyu koordinatu iz sferi
      x2:=ar_sf[i].x;
      y2:=ar_sf[i].y;
      z2:=ar_sf[i].z;

      //vichislaem rasstoyanie
      d:=sqrt(sqr(x2-x1)+sqr(y2-y1)+sqr(z2-z1));

      if d<(ar_tun[indeks].radius_horiz+max(ar_sf[i].radius_x,ar_sf[i].radius_z)+10) then
      begin
        result:=true;
        exit;
      end;
    end;
  end;
  result:=false;
end;

function gen_biosphere_thread(Parameter:pointer):integer;
var i,j,k,z:integer;     //peremennie dla regulirovaniya ciklov po regionam i chankam
kol:integer;
id:byte;    //peremennaya dla opredeleniya chetverti tekushego regiona
tempx,tempy,tempk,tempz:integer;     //peremennie dla lubih nuzhd
otx,dox,oty,doy:integer;   //granici chankov
regx,regy:integer;   //kol-vo region faylov
regx_nach,regy_nach:integer;  //nachalniy region (menshiy), s kotorogo nachinaetsa generaciya
param:ptparam_biosphere;
par:tparam_biosphere;
str,strcompress:string;
rez:ar_type;
head:mcheader;
map:region;
fdata:array of byte;
co:longword;
hndl:cardinal;
count:dword;
b1,sp:boolean;
b_spheres,ozera,sf_res:ar_elipse_settings;
ar_tun:array of tunnels_settings;
ar_ind,iskluch:array of integer;
ar_rasten:ar_tlights_koord;
ar_pop:ar_tkoord;
ar_res:ar_tprostr_koord;
temp:extended;

rand:rnd;
//noise:NoiseGeneratorOctaves;
//noise_mas:ar_double;

procedure thread_exit(p:ptparam_biosphere);
var i,j:integer;
begin
  if p^.bio_par^.potok_exit=true then
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
  setlength(ar_rasten,0);
  setlength(ar_pop,0);
  setlength(ozera,0);
  setlength(sf_res,0);
  rand.Free;

  postmessage(par.handle,WM_USER+301,par.id,0);
  endthread(0);
  end;
end;

begin
  param:=parameter;
  par:=param^;

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

  setlength(ar_rasten,0);
  setlength(ar_pop,0);
  setlength(ozera,0);
  setlength(sf_res,0);

  rand:=rnd.Create;

  thread_exit(param);

  //inicilializiruem random
  Randseed:=par.sid;

  kol:=0;

  //soobshenie o nachale generacii biosfer
  postmessage(par.handle,WM_USER+318,0,0);

  //peresmatrivaem granicu karti v sootvetstvii s nastroykami granici
  case par.border_par^.border_type of
  1,3:begin
        inc(par.fromx);
        inc(par.fromy);
        dec(par.tox);
        dec(par.toy);
      end;
  end;

  {//opredelaem kol-vo region faylov, kotoroe sozdavat
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
    end;     }

  if par.bio_par^.original_gen=false then
  begin
  //generim sferi
  //vichislaem kol-vo sfer
  kol:=(par.tox-par.fromx+1)*(par.toy-par.fromy+1);
  setlength(b_spheres,kol);

  //sozdaem sferi
  for i:=0 to length(b_spheres)-1 do
  begin
    b_spheres[i].x:=random((par.tox-par.fromx+1)*16)+(par.fromx*16);
    b_spheres[i].z:=random((par.toy-par.fromy+1)*16)+(par.fromy*16);
    k:=get_noise_koord(b_spheres[i].x,b_spheres[i].z,par.bio_par^.sid,not(par.bio_par^.gen_noise));
    b_spheres[i].y:=k;
    if (k>77)and(k<105) then
      b_spheres[i].radius_x:=15+random(110-k)
    else if k<=77 then
    begin
      if k<13 then
      begin
        b_spheres[i].radius_x:=16;
        b_spheres[i].y:=1000;
      end else
      b_spheres[i].radius_x:=16+random(33);
    end
    else
    begin
      b_spheres[i].radius_x:=16;
      b_spheres[i].y:=1000;
    end;
    b_spheres[i].radius_z:=b_spheres[i].radius_x;
    b_spheres[i].radius_vert:=b_spheres[i].radius_x;
  end;

  //ishem peresechenie
  for i:=0 to length(b_spheres)-2 do
  begin
    if b_spheres[i].y=1000 then continue;
    for j:=i+1 to length(b_spheres)-1 do
    begin
      if b_spheres[j].y=1000 then continue;
      if ((b_spheres[i].x+b_spheres[i].radius_x+b_spheres[j].radius_x+par.bio_par^.sphere_distance)>b_spheres[j].x)and
      ((b_spheres[i].x-b_spheres[i].radius_x-b_spheres[j].radius_x-par.bio_par^.sphere_distance)<b_spheres[j].x)and
      ((b_spheres[i].z+b_spheres[i].radius_x+b_spheres[j].radius_x+par.bio_par^.sphere_distance)>b_spheres[j].z)and
      ((b_spheres[i].z-b_spheres[i].radius_x-b_spheres[j].radius_x-par.bio_par^.sphere_distance)<b_spheres[j].z)then
        if b_spheres[i].radius_x<b_spheres[j].radius_x then
          b_spheres[i].y:=1000
        else
          b_spheres[j].y:=1000;
    end;
  end;

  {//udalaem sferi
  k:=0;
      repeat
        if b_spheres[k].y=1000 then
        begin
          if k<>(length(b_spheres)-1) then
          move(b_spheres[k+1],b_spheres[k],(length(b_spheres)-k-1)*sizeof(elipse_settings));
          setlength(b_spheres,length(b_spheres)-1);
        end
        else
          inc(k);
      until k>(length(b_spheres)-1);   }
  end
  else
  begin

  //kod dla generirovaniya sfer po setke
  setlength(b_spheres,0);
  for i:=(par.fromx*16)to par.tox*16 do
    for j:=(par.fromy*16) to par.toy*16 do
      if ((abs(i) mod (par.bio_par^.sphere_distance+44))=0)and((abs(j) mod (par.bio_par^.sphere_distance+44))=0) then
      begin
        z:=length(b_spheres);
        setlength(b_spheres,z+1);
        b_spheres[z].x:=i;
        b_spheres[z].z:=j;
        k:=get_noise_koord(b_spheres[z].x,b_spheres[z].z,par.bio_par^.sid,not(par.bio_par^.gen_noise));
        b_spheres[z].y:=k;
        if (k>77)and(k<105) then
          b_spheres[z].radius_x:=15+random(110-k)
        else if k<=77 then
        begin
          if k<13 then
          begin
            b_spheres[i].radius_x:=16;
            b_spheres[i].y:=1000;
          end else
          b_spheres[z].radius_x:=16+random(33);
        end
        else
        begin
          b_spheres[z].radius_x:=16;
          b_spheres[z].y:=1000;
        end;
        b_spheres[z].radius_z:=b_spheres[z].radius_x;
        b_spheres[z].radius_vert:=b_spheres[z].radius_x;
      end;

  end;
  {setlength(b_spheres,4);

  b_spheres[0].x:=-100;
  b_spheres[0].z:=-50;
  b_spheres[0].y:=get_noise_koord(b_spheres[0].x,b_spheres[0].z,par.bio_par^.sid);
  b_spheres[0].radius_x:=20;
  b_spheres[0].radius_z:=20;
  b_spheres[0].radius_vert:=20;

  b_spheres[1].x:=-100;
  b_spheres[1].z:=50;
  b_spheres[1].y:=get_noise_koord(b_spheres[1].x,b_spheres[1].z,par.bio_par^.sid);
  b_spheres[1].radius_x:=30;
  b_spheres[1].radius_z:=30;
  b_spheres[1].radius_vert:=20;

  b_spheres[2].x:=0;
  b_spheres[2].z:=50;
  b_spheres[2].y:=get_noise_koord(b_spheres[2].x,b_spheres[2].z,par.bio_par^.sid);
  b_spheres[2].radius_x:=30;
  b_spheres[2].radius_z:=30;
  b_spheres[2].radius_vert:=30;

  b_spheres[3].x:=0;
  b_spheres[3].z:=-50;
  b_spheres[3].y:=get_noise_koord(b_spheres[3].x,b_spheres[3].z,par.bio_par^.sid);
  b_spheres[3].radius_x:=20;
  b_spheres[3].radius_z:=20;
  b_spheres[3].radius_vert:=20;   }

  thread_exit(param);

  //ishem peresechenie biosfer s granicami karti
  //vichislaem koordinati granici karti
  tempx:=par.fromx*16;
  tempy:=par.fromy*16;
  tempk:=(par.tox+1)*16-1;
  tempz:=(par.toy+1)*16-1;

  for i:=0 to length(b_spheres)-1 do
  begin
    if b_spheres[i].y=1000 then continue;
    if ((b_spheres[i].x-b_spheres[i].radius_x-10)<tempx)or
    ((b_spheres[i].x+b_spheres[i].radius_x+10)>tempk)or
    ((b_spheres[i].z-b_spheres[i].radius_z-10)<tempy)or
    ((b_spheres[i].z+b_spheres[i].radius_x+10)>tempz) then
      b_spheres[i].y:=1000;
  end;

  //udalaem sferi
  k:=0;
      repeat
        if b_spheres[k].y=1000 then
        begin
          if k<>(length(b_spheres)-1) then
          move(b_spheres[k+1],b_spheres[k],(length(b_spheres)-k-1)*sizeof(elipse_settings));
          setlength(b_spheres,length(b_spheres)-1);
        end
        else
          inc(k);
      until k>(length(b_spheres)-1);

  thread_exit(param);

  //splushivaem sferi esli vibrana opciya i esli popal random
  if par.bio_par^.sphere_ellipse=true then
    for i:=0 to length(b_spheres)-1 do
    begin
      temp:=random;
      if temp<0.45 then b_spheres[i].radius_vert:=round((1-temp)*b_spheres[i].radius_vert);
    end;
    

  //delaem mosti
  if par.bio_par^.gen_bridges=true then
  begin
  
  for i:=0 to length(b_spheres)-1 do
  begin
    thread_exit(param);
    setlength(ar_ind,0);
    //smotrim po X vpravo
    for j:=0 to length(b_spheres)-1 do
      if (b_spheres[j].x>b_spheres[i].x)and
      ((b_spheres[j].x-b_spheres[i].x)>=(b_spheres[j].z-b_spheres[i].z)) then
      begin
        k:=length(ar_ind);
        setlength(ar_ind,k+1);
        ar_ind[k]:=j;
      end;

    k:=5000;
    tempx:=-1;
    for j:=0 to length(ar_ind)-1 do
    begin
      z:=round(sqrt(sqr(b_spheres[ar_ind[j]].x-b_spheres[i].x)+sqr(b_spheres[ar_ind[j]].z-b_spheres[i].z)));
      if z<k then
      begin
        k:=z;
        tempx:=ar_ind[j];
      end;
    end;

    if tempx<>-1 then
    begin
      k:=length(ar_tun);
      setlength(ar_tun,k+1);
      ar_tun[k].x1:=b_spheres[i].x;
      ar_tun[k].y1:=64;
      ar_tun[k].z1:=b_spheres[i].z;

      ar_tun[k].x2:=b_spheres[tempx].x;
      ar_tun[k].y2:=64;
      ar_tun[k].z2:=b_spheres[tempx].z;

      ar_tun[k].radius_horiz:=par.bio_par^.bridge_width;
      ar_tun[k].radius_vert:=par.bio_par^.bridge_width;

      j:=length(b_spheres[i].svazi_tun);
      setlength(b_spheres[i].svazi_tun,j+1);
      b_spheres[i].svazi_tun[j]:=@ar_tun[k];
    end;

    setlength(ar_ind,0);
    //smotrim po X vlevo
    for j:=0 to length(b_spheres)-1 do
      if (b_spheres[j].x<b_spheres[i].x)and
      ((b_spheres[i].x-b_spheres[j].x)>=(b_spheres[i].z-b_spheres[j].z)) then
      begin
        k:=length(ar_ind);
        setlength(ar_ind,k+1);
        ar_ind[k]:=j;
      end;

    k:=5000;
    tempx:=-1;
    for j:=0 to length(ar_ind)-1 do
    begin
      z:=round(sqrt(sqr(b_spheres[i].x-b_spheres[ar_ind[j]].x)+sqr(b_spheres[i].z-b_spheres[ar_ind[j]].z)));
      if z<k then
      begin
        k:=z;
        tempx:=ar_ind[j];
      end;
    end;

    if tempx<>-1 then
    begin
      k:=length(ar_tun);
      setlength(ar_tun,k+1);
      ar_tun[k].x1:=b_spheres[tempx].x;
      ar_tun[k].y1:=64;
      ar_tun[k].z1:=b_spheres[tempx].z;

      ar_tun[k].x2:=b_spheres[i].x;
      ar_tun[k].y2:=64;
      ar_tun[k].z2:=b_spheres[i].z;

      ar_tun[k].radius_horiz:=par.bio_par^.bridge_width;
      ar_tun[k].radius_vert:=par.bio_par^.bridge_width;

      j:=length(b_spheres[i].svazi_tun);
      setlength(b_spheres[i].svazi_tun,j+1);
      b_spheres[i].svazi_tun[j]:=@ar_tun[k];
    end;

    setlength(ar_ind,0);
    //smotrim po Z vpered
    for j:=0 to length(b_spheres)-1 do
      if (b_spheres[j].z>b_spheres[i].z)and
      ((b_spheres[j].z-b_spheres[i].z)>=(b_spheres[j].x-b_spheres[i].x)) then
      begin
        k:=length(ar_ind);
        setlength(ar_ind,k+1);
        ar_ind[k]:=j;
      end;

    k:=5000;
    tempx:=-1;
    for j:=0 to length(ar_ind)-1 do
    begin
      z:=round(sqrt(sqr(b_spheres[ar_ind[j]].x-b_spheres[i].x)+sqr(b_spheres[ar_ind[j]].z-b_spheres[i].z)));
      if z<k then
      begin
        k:=z;
        tempx:=ar_ind[j];
      end;
    end;

    if tempx<>-1 then
    begin
      k:=length(ar_tun);
      setlength(ar_tun,k+1);
      ar_tun[k].x1:=b_spheres[i].x;
      ar_tun[k].y1:=64;
      ar_tun[k].z1:=b_spheres[i].z;

      ar_tun[k].x2:=b_spheres[tempx].x;
      ar_tun[k].y2:=64;
      ar_tun[k].z2:=b_spheres[tempx].z;

      ar_tun[k].radius_horiz:=par.bio_par^.bridge_width;
      ar_tun[k].radius_vert:=par.bio_par^.bridge_width;

      j:=length(b_spheres[i].svazi_tun);
      setlength(b_spheres[i].svazi_tun,j+1);
      b_spheres[i].svazi_tun[j]:=@ar_tun[k];
    end;

    setlength(ar_ind,0);
    //smotrim po Z vniz
    for j:=0 to length(b_spheres)-1 do
      if (b_spheres[j].z<b_spheres[i].z)and
      ((b_spheres[i].z-b_spheres[j].z)>=(b_spheres[i].x-b_spheres[j].x)) then
      begin
        k:=length(ar_ind);
        setlength(ar_ind,k+1);
        ar_ind[k]:=j;
      end;

    k:=5000;
    tempx:=-1;
    for j:=0 to length(ar_ind)-1 do
    begin
      z:=round(sqrt(sqr(b_spheres[i].x-b_spheres[ar_ind[j]].x)+sqr(b_spheres[i].z-b_spheres[ar_ind[j]].z)));
      if z<k then
      begin
        k:=z;
        tempx:=ar_ind[j];
      end;
    end;

    if tempx<>-1 then
    begin
      k:=length(ar_tun);
      setlength(ar_tun,k+1);
      ar_tun[k].x1:=b_spheres[tempx].x;
      ar_tun[k].y1:=64;
      ar_tun[k].z1:=b_spheres[tempx].z;

      ar_tun[k].x2:=b_spheres[i].x;
      ar_tun[k].y2:=64;
      ar_tun[k].z2:=b_spheres[i].z;

      ar_tun[k].radius_horiz:=par.bio_par^.bridge_width;
      ar_tun[k].radius_vert:=par.bio_par^.bridge_width;

      j:=length(b_spheres[i].svazi_tun);
      setlength(b_spheres[i].svazi_tun,j+1);
      b_spheres[i].svazi_tun[j]:=@ar_tun[k];
    end;
  end;
  setlength(ar_ind,0);

  //ishem sovpadayushie tunneli
  for i:=0 to length(ar_tun)-2 do
  begin
    if ar_tun[i].y1=10000 then continue;
    for j:=i+1 to length(ar_tun)-1 do
    begin
      if ar_tun[j].y1=10000 then continue;
      if ((ar_tun[i].x1=ar_tun[j].x1)and
      (ar_tun[i].z1=ar_tun[j].z1)and
      (ar_tun[i].x2=ar_tun[j].x2)and
      (ar_tun[i].z2=ar_tun[j].z2))or
      ((ar_tun[i].x1=ar_tun[j].x2)and
      (ar_tun[i].z1=ar_tun[j].z2)and
      (ar_tun[i].x2=ar_tun[j].x1)and
      (ar_tun[i].z2=ar_tun[j].z1)) then
        ar_tun[i].y1:=10000;
    end;
  end;

  setlength(iskluch,2);
  //ishem tunneli, peresekayushiesa s biosferami
  for i:=0 to length(ar_tun)-1 do
  begin
    thread_exit(param);
    if ar_tun[i].y1=10000 then continue;
    //ishem 2 biosferi, k kotorim prinadlezhit tunel'     
    //ishem pervuyu
    for j:=0 to length(b_spheres)-1 do
      if (ar_tun[i].x1=b_spheres[j].x)and(ar_tun[i].z1=b_spheres[j].z) then
      begin
        iskluch[0]:=j;
        break;
      end;
    //ishem vtoruyu
    for j:=0 to length(b_spheres)-1 do
      if (ar_tun[i].x2=b_spheres[j].x)and(ar_tun[i].z2=b_spheres[j].z) then
      begin
        iskluch[1]:=j;
        break;
      end;
    //esli tunel' peresekaet kakuyu libo sferu
    if tunnel_intersection_sphere(ar_tun,i,b_spheres,iskluch)=true then
      ar_tun[i].y1:=10000;
  end;

  //udalaem tuneli
  k:=0;
      repeat
        thread_exit(param);
        if ar_tun[k].y1=10000 then
        begin
          if k<>(length(ar_tun)-1) then
          move(ar_tun[k+1],ar_tun[k],(length(ar_tun)-k-1)*sizeof(tunnels_settings));
          setlength(ar_tun,length(ar_tun)-1);
        end
        else
          inc(k);
      until k>(length(ar_tun)-1);

  end;


  //delaem sferi s resursami
  //vichislaem kol-vo sfer
  kol:=(par.tox-par.fromx+1)*(par.toy-par.fromy+1);
  setlength(sf_res,kol);

  //sozdaem sferi
  for i:=0 to length(sf_res)-1 do
  begin
    sf_res[i].x:=random((par.tox-par.fromx+1)*16)+(par.fromx*16);
    sf_res[i].z:=random((par.toy-par.fromy+1)*16)+(par.fromy*16);
    sf_res[i].y:=random(100)+10;
    sf_res[i].radius_x:=5;
    sf_res[i].radius_z:=5;
    sf_res[i].radius_vert:=5;
  end;

  //ishem peresechenie s biosferami
  for i:=0 to length(sf_res)-1 do
  begin
    thread_exit(param);
    if sf_res[i].y=1000 then continue;
    for j:=0 to length(b_spheres)-1 do
    begin
      if sf_res[i].y=1000 then continue;

      temp:=sqrt(sqr(b_spheres[j].x-sf_res[i].x)+sqr(b_spheres[j].z-sf_res[i].z)+sqr(b_spheres[j].y-sf_res[i].y));

      if temp<76 then sf_res[i].y:=1000;
    end;
  end;

  //ishem peresechenie mezhdu sferami resursov
  for i:=0 to length(sf_res)-2 do
  begin
    thread_exit(param);
    if sf_res[i].y=1000 then continue;
    for j:=i+1 to length(sf_res)-1 do
    begin
      if sf_res[j].y=1000 then continue;

      temp:=sqrt(sqr(sf_res[j].x-sf_res[i].x)+sqr(sf_res[j].z-sf_res[i].z)+sqr(sf_res[j].y-sf_res[i].y));

      if temp<100 then
        if random<0.5 then sf_res[i].y:=1000
        else sf_res[j].y:=1000;
    end;
  end;

  //izmenaem radius sfer s resursami po veroyatnostam
  for i:=0 to length(sf_res)-1 do
  begin
    j:=random(100);
    case j of
      0..52:k:=5;
      53..77:k:=6;
      78..89:k:=7;
      90..95:k:=8;
      96..98:k:=9;
      99:k:=10;
    end;
    sf_res[i].radius_x:=k;
    sf_res[i].radius_z:=k;
    sf_res[i].radius_vert:=k;
  end;

  //ishem peresechenie sfer resursov s granicami karti
  //vichislaem koordinati granici karti
  tempx:=par.fromx*16;
  tempy:=par.fromy*16;
  tempk:=(par.tox+1)*16-1;
  tempz:=(par.toy+1)*16-1;

  for i:=0 to length(sf_res)-1 do
  begin
    if sf_res[i].y=1000 then continue;
    if ((sf_res[i].x-sf_res[i].radius_x-5)<tempx)or
    ((sf_res[i].x+sf_res[i].radius_x+5)>tempk)or
    ((sf_res[i].z-sf_res[i].radius_z-5)<tempy)or
    ((sf_res[i].z+sf_res[i].radius_x+5)>tempz) then
      sf_res[i].y:=1000;
  end;

  //udalaem sferi
  k:=0;
      repeat
        thread_exit(param);
        if sf_res[k].y=1000 then
        begin
          if k<>(length(sf_res)-1) then
          move(sf_res[k+1],sf_res[k],(length(sf_res)-k-1)*sizeof(elipse_settings));
          setlength(sf_res,length(sf_res)-1);
        end
        else
          inc(k);
      until k>(length(sf_res)-1);


  for z:=0 to length(ar_tun)-1 do
  begin
    if ar_tun[z].x1=ar_tun[z].x2 then inc(ar_tun[z].x1);
    if ar_tun[z].y1=ar_tun[z].y2 then inc(ar_tun[z].y1);
    if ar_tun[z].z1=ar_tun[z].z2 then inc(ar_tun[z].z1);
  end;

  //delaem biomi
  gen_bio_biomes(b_spheres,par.bio_par^);

  //delaem ozera
  for i:=0 to length(b_spheres)-1 do
  begin
    if b_spheres[i].radius_x<20 then continue;
    case b_spheres[i].fill_material of
    0,1,3:begin
            if random<0.5 then
            begin
              k:=length(ozera);
              setlength(ozera,k+1);
              ozera[k].x:=b_spheres[i].x;
              ozera[k].y:=b_spheres[i].y;
              ozera[k].z:=b_spheres[i].z;
              ozera[k].radius_x:=round(b_spheres[i].radius_x/4)+2;
              ozera[k].radius_z:=round(b_spheres[i].radius_z/4)+2;
              ozera[k].radius_vert:=round(b_spheres[i].radius_vert/4)+2;
              if random<0.1 then
              begin
                ozera[k].fill_material:=1;  //lava
              end
              else
              begin
                ozera[k].fill_material:=0;  //voda
                ozera[k].flooded:=false;  //bez l'da
              end;
            end;
          end;
    4,6:begin
            if random<0.5 then
            begin
              k:=length(ozera);
              setlength(ozera,k+1);
              ozera[k].x:=b_spheres[i].x;
              ozera[k].y:=b_spheres[i].y;
              ozera[k].z:=b_spheres[i].z;
              ozera[k].radius_x:=round(b_spheres[i].radius_x/4)+2;
              ozera[k].radius_z:=round(b_spheres[i].radius_z/4)+2;
              ozera[k].radius_vert:=round(b_spheres[i].radius_vert/4)+2;
              if random<0.1 then
              begin
                ozera[k].fill_material:=1;  //lava
              end
              else
              begin
                ozera[k].fill_material:=0;  //voda
                ozera[k].flooded:=true;  //so l'dom
              end;
            end;
          end;
    7:begin
        k:=length(ozera);
        setlength(ozera,k+1);
        ozera[k].x:=b_spheres[i].x;
        ozera[k].y:=b_spheres[i].y;
        ozera[k].z:=b_spheres[i].z;
        ozera[k].radius_x:=round(b_spheres[i].radius_x/4)+2;
        ozera[k].radius_z:=round(b_spheres[i].radius_z/4)+2;
        ozera[k].radius_vert:=round(b_spheres[i].radius_vert/4)+2;
        ozera[k].fill_material:=1;  //lava
      end;
    end;
  end;

  thread_exit(param);

  calc_cos_tun(ar_tun);
  fill_tun_chunks(ar_tun);

  thread_exit(param);

  //for i:=0 to length(ar_tun)-1 do
  //  ar_tun[i].y1:=64;

  //setlength(b_spheres,0);

  //for i:=0 to length(b_spheres)-1 do
  //  b_spheres[i].y:=get_noise_koord(b_spheres[i].x,b_spheres[i].z,par.bio_par^.sid);

  fill_el_chunks(b_spheres);
  fill_el_chunks(ozera);
  fill_el_chunks(sf_res);

  calc_bio_lakes_alt(ozera,par.bio_par^.sid,not(par.bio_par^.gen_noise));

  thread_exit(param);

  //peresmatrivaem granicu karti v sootvetstvii s nastroykami granici
  case par.border_par^.border_type of
  1,3:begin
        dec(par.fromx);
        dec(par.fromy);
        inc(par.tox);
        inc(par.toy);
      end;
  end;

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
  //peredaem kol-vo chankov vmeste s border v osnovnuyu formu
  postmessage(par.handle,WM_USER+302,par.id,i);      

  //pereschitivaem nachalo i konec regionov i chankov, dla generacii granici karti
  //if par.border_par^.border_type<>0 then
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

  postmessage(par.handle,WM_USER+300,1,0);

  //ochishaem massiv dla zapisi v fayl na vsakiy sluchay
  setlength(fdata,0);

  //ishem blizhayshuyu sferu k centru karti
  j:=0;
  k:=1000000;
  for i:=0 to length(b_spheres)-1 do
  begin
    //if b_spheres[i].fill_material
    z:=round(sqrt(sqr(b_spheres[i].x)+sqr(b_spheres[i].y)+sqr(b_spheres[i].z)));
    if z<k then
    begin
      j:=i;
      k:=z;
    end;
  end;

  //izmenaem spawn
  postmessage(par.bio_par^.handle,WM_USER+308,1,b_spheres[j].x); //x
  postmessage(par.bio_par^.handle,WM_USER+308,2,b_spheres[j].y+1); //y
  postmessage(par.bio_par^.handle,WM_USER+308,3,b_spheres[j].z); //z

  sp:=false;

  //osnovnie cikli generacii
  for i:=regx_nach to regx_nach+regx-1 do
    for j:=regy_nach to regy_nach+regy-1 do
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

      setlength(ar_res,0);

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
          for tempz:=0 to length(ar_pop)-1 do
            if (ar_pop[tempz].x=(tempx-2))and
            (ar_pop[tempz].y=(tempy-2)) then
            begin
              b1:=true;
              break;
            end;

          if b1=false then
          begin
            tempz:=length(ar_pop);
            setlength(ar_pop,tempz+1);
            ar_pop[tempz].x:=tempx-2;
            ar_pop[tempz].y:=tempy-2;
          end;

          rand.SetSeed(par.bio_par^.sid);
          rand.SetSeed(tempx*((rand.nextLong div 2)*2+1)+tempy*((rand.nextLong div 2)*2+1) xor par.bio_par^.sid);
          tempk:=length(ar_res);
          setlength(ar_res,tempk+20);
          for tempz:=tempk to tempk+19 do
          begin
          
            ar_res[tempz].x:=tempx*16+round(rand.nextDouble*16);
            ar_res[tempz].y:=round(rand.nextDouble*128);
            ar_res[tempz].z:=tempy*16+round(rand.nextDouble*16);
          end;

          //gen_sphere(tempx-2,tempy-2,map[k][z].blocks,arobsh,par.planet_par^.groundlevel,par.planet_par^.map_type);
          //gen_flat_surf(tempx-2,tempy-2,par.flatmap_par^,par.border_par^,map[k][z].blocks,map[k][z].data);

          gen_bio_ellipse(tempx-2,tempy-2,map[k][z].blocks,b_spheres,@ar_rasten,0,par.bio_par^.sid,b1,par.bio_par^);
          gen_bio_bridge(tempx-2,tempy-2,map[k][z].blocks,ar_tun,0,par.bio_par^.sid,par.bio_par^,@ar_rasten);

          gen_bio_lakes(tempx-2,tempy-2,map[k][z].blocks,ozera,par.bio_par^.sid);

          gen_bio_ellipse(tempx-2,tempy-2,map[k][z].blocks,sf_res,@ar_rasten,2,par.bio_par^.sid,b1,par.bio_par^);

          gen_border(tempx-2,tempy-2,par.tox-par.fromx+1,par.toy-par.fromy+1,par.border_par^,map[k][z].blocks,map[k][z].data,@map[k][z].entities,@map[k][z].tile_entities);

          //generim heightmap
          calc_heightmap(map[k][z].blocks,map[k][z].heightmap);
        end;

      
      for k:=0 to length(ar_rasten)-1 do
      begin
        case ar_rasten[k].id of
          0:begin  //obichnoe derevo
              //if get_block_id(map,i,j,ar_rasten[k].x,ar_rasten[k].y,ar_rasten[k].z)=31 then
              //  set_block_id(map,i,j,ar_rasten[k].x,ar_rasten[k].y,ar_rasten[k].z,0);

              gen_tree_notch(map,i,j,par.bio_par^.sid+k,ar_rasten[k].x,ar_rasten[k].y,ar_rasten[k].z,sp,0,par.bio_par^.handle,0);
            end;
          1:begin  //bolshoe derevo
              //if get_block_id(map,i,j,ar_rasten[k].x,ar_rasten[k].y,ar_rasten[k].z)=31 then
              //  set_block_id(map,i,j,ar_rasten[k].x,ar_rasten[k].y,ar_rasten[k].z,0);
              
              gen_bigtree_notch(map,i,j,ar_rasten[k].x,ar_rasten[k].y,ar_rasten[k].z,par.bio_par^.sid+k,sp,0,par.bio_par^.handle);
            end;
          2:begin  //obichnaya trava
              if (get_block_id(map,i,j,ar_rasten[k].x,ar_rasten[k].y-1,ar_rasten[k].z)=2)and
              (get_block_id(map,i,j,ar_rasten[k].x,ar_rasten[k].y,ar_rasten[k].z)=0) then
                set_block_id_data(map,i,j,ar_rasten[k].x,ar_rasten[k].y,ar_rasten[k].z,31,1);
                {if random>0.1 then
                  set_block_id_data(map,i,j,ar_rasten[k].x,ar_rasten[k].y,ar_rasten[k].z,31,1)
                else
                  set_block_id(map,i,j,ar_rasten[k].x,ar_rasten[k].y,ar_rasten[k].z,31);}
            end;
          3:begin  //visohshaya trava
              if (get_block_id(map,i,j,ar_rasten[k].x,ar_rasten[k].y-1,ar_rasten[k].z)=2)and
              (get_block_id(map,i,j,ar_rasten[k].x,ar_rasten[k].y,ar_rasten[k].z)=0) then
                set_block_id(map,i,j,ar_rasten[k].x,ar_rasten[k].y,ar_rasten[k].z,31);
            end;
          4:begin  //elka
              if get_block_id(map,i,j,ar_rasten[k].x,ar_rasten[k].y-1,ar_rasten[k].z)=2 then
                set_block_id_data(map,i,j,ar_rasten[k].x,ar_rasten[k].y,ar_rasten[k].z,31,2);
            end;
          5:begin  //kaktus
              gen_cactus(map,i,j,ar_rasten[k].x,ar_rasten[k].y,ar_rasten[k].z,par.bio_par^.sid+k);
            end;
          6:begin  //visohshaya trava otdelnim blokom
              if (par.bio_par^.sphere_material<>get_block_id(map,i,j,ar_rasten[k].x,ar_rasten[k].y,ar_rasten[k].z)) then
                set_block_id(map,i,j,ar_rasten[k].x,ar_rasten[k].y,ar_rasten[k].z,32);
            end;
          7:begin  //bereza
              gen_tree_notch(map,i,j,par.bio_par^.sid+k,ar_rasten[k].x,ar_rasten[k].y,ar_rasten[k].z,sp,0,par.bio_par^.handle,1);
            end;
          8:begin  //derevo-elka 1
              gen_taigatree1_notch(map,i,j,ar_rasten[k].x,ar_rasten[k].y,ar_rasten[k].z,par.bio_par^.sid+k);
            end;
          9:begin  //derevo-elka 2
              gen_taigatree2_notch(map,i,j,ar_rasten[k].x,ar_rasten[k].y,ar_rasten[k].z,par.bio_par^.sid+k);
            end;
          10:begin  //mob spawner pigmen
               // if (i=-1)and(j=-1) then
               if get_block_id(map,i,j,ar_rasten[k].x,ar_rasten[k].y-2,ar_rasten[k].z)=87 then
                 place_bio_spawners(map,i,j,ar_rasten[k].x,ar_rasten[k].y-2,ar_rasten[k].z,1,par.bio_par^.sid+k);
             end;
          11:begin  //mod spawner ghast
               //if (i=-1)and(j=-1) then   
               if get_block_id(map,i,j,ar_rasten[k].x,ar_rasten[k].y-2,ar_rasten[k].z)=87 then
                 place_bio_spawners(map,i,j,ar_rasten[k].x,ar_rasten[k].y-2,ar_rasten[k].z,0,par.bio_par^.sid+k);
             end;
          12:begin  //Fire
               if get_block_id(map,i,j,ar_rasten[k].x,ar_rasten[k].y-1,ar_rasten[k].z)=87 then
                 set_block_id_data(map,i,j,ar_rasten[k].x,ar_rasten[k].y,ar_rasten[k].z,51,15);
             end;
          13:begin  //glowstone dla osvesheniya
               z:=get_block_id(map,i,j,ar_rasten[k].x,ar_rasten[k].y,ar_rasten[k].z);
               tempz:=get_block_id(map,i,j,ar_rasten[k].x,ar_rasten[k].y-1,ar_rasten[k].z);
               if (z<>par.bio_par^.sphere_material)and(z<>17)and(z<>81)and(tempz<>87)and(tempz<>0)and(tempz<>79) then
                 set_block_id(map,i,j,ar_rasten[k].x,ar_rasten[k].y,ar_rasten[k].z,89);
             end;
          14:begin //skyholes
               gen_bio_skyholes(map,i,j,ar_rasten[k].x,ar_rasten[k].y,ar_rasten[k].z,par.bio_par^);
             end;
        end;
      end;

      for k:=0 to length(ar_res)-1 do
        gen_resourses2(map,i,j,ar_res[k].x,ar_res[k].y,ar_res[k].z,16,16);

      //ochishaem vihodashie za sferi list'ya
      //todo: uskorit' putem prohoda tol'ko po chankam, sootvetstvuyushim sferam s derevyami
      //clear_bio_leaves(map,otx,oty,dox,doy,par.bio_par^);

      for k:=0 to 35 do
        for z:=0 to 35 do
        begin
          thread_exit(param);

          if i<0 then tempx:=((i+1)*32-(32-k))
          else tempx:=(i*32)+k;

          if j<0 then  tempy:=((j*32)+z)
          else tempy:=(j+1)*32-(32-z);
                                                                                                         
          clear_bio_leaves2(tempx-2,tempy-2,par.tox-par.fromx+1,par.toy-par.fromy+1,map[k][z].blocks,par.bio_par^,par.border_par^);
        end;

      //peredaem soobshenie o nachale proscheta sveta
      postmessage(par.handle,WM_USER+310,i,j);

      //schitaem skylight srazu dla vsego regiona
      calc_skylight(map,otx,oty,dox,doy);

      //schitaem blocklight
      calc_blocklight(map,otx,oty,dox,doy);

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

          nbtcompress2(tempx,tempy,map[k+2][z+2].blocks,map[k+2][z+2].data,map[k+2][z+2].skylight,map[k+2][z+2].light,map[k+2][z+2].heightmap,map[k+2][z+2].entities,map[k+2][z+2].tile_entities,not(par.bio_par^.pop_chunks),@rez);

          //ToDO: poprobovat' druguyu funkciyu szhatiya, chtobi ne ispol'zovat' stroki
          setlength(str,length(rez));
          move(rez[0],str[1],length(rez));

          {if (tempx=0)and(tempy=0) then
          begin
            assignfile(f,'C:\MinecraftWorlds\error.txt');
            rewrite(f,1);
            blockwrite(f,str[1],length(str));
            closefile(f);
          end;    }

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
  setlength(ar_rasten,0);
  setlength(ar_pop,0);
  setlength(ozera,0);
  setlength(sf_res,0);
  rand.Free;

  postmessage(par.handle,WM_USER+301,par.id,0);
  endthread(0);
end;


end.

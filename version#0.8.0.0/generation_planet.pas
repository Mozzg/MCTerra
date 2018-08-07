unit generation_planet;

interface

function gen_planets_thread(Parameter:pointer):integer;

implementation

uses generation_obsh, NBT, generation_spec, windows, zlibex, sysutils;

procedure gen_planets_snow(xkoord,ykoord,width,len:integer; border_par:border_settings_type; var blocks,data:ar_type);
var otx,dox,oty,doy:integer;
i,j,k,t:integer;
begin
  case border_par.border_type of
  0:begin   //normal
      otx:=-(width div 2);
      oty:=-(len div 2);
      dox:=(width div 2)-1;
      doy:=(len div 2)-1;
    end;
  1:begin    //wall
      if border_par.wall_void=true then
      begin
        otx:=-(width div 2)+border_par.wall_void_thickness+1;
        oty:=-(len div 2)+border_par.wall_void_thickness+1;
        dox:=(width div 2)-2-border_par.wall_void_thickness;
        doy:=(len div 2)-2-border_par.wall_void_thickness;
      end
      else
      begin
        otx:=-(width div 2)+1;
        oty:=-(len div 2)+1;
        dox:=(width div 2)-2;
        doy:=(len div 2)-2;
      end;
    end;
  2:begin    //void
      otx:=-(width div 2)+border_par.void_thickness;
      oty:=-(len div 2)+border_par.void_thickness;
      dox:=(width div 2)-1-border_par.void_thickness;
      doy:=(len div 2)-1-border_par.void_thickness;
    end;
  3:begin    //castle wall
      if border_par.cwall_gen_void=true then
      begin
        otx:=-(width div 2)+border_par.cwall_void_width+1;
        oty:=-(len div 2)+border_par.cwall_void_width+1;
        dox:=(width div 2)-2-border_par.cwall_void_width;
        doy:=(len div 2)-2-border_par.cwall_void_width;
      end
      else
      begin
        otx:=-(width div 2)+1;
        oty:=-(len div 2)+1;
        dox:=(width div 2)-2;
        doy:=(len div 2)-2;
      end;
    end;
  end;

  if (xkoord<=dox)and(xkoord>=otx)and
  (ykoord<=doy)and(ykoord>=oty) then
  begin
    for i:=0 to 15 do
      for j:=0 to 15 do
      begin
        if blocks[127+(i*128+(j*2048))]<>0 then continue;
        k:=127;
        while k>95 do
        begin
          dec(k);
          t:=blocks[k+(i*128+(j*2048))];
          if t<>0 then
          begin
            if (t=8)or(t=9)or(t=10)or(t=11)or(t=31)or(t=32)or
            (t=37)or(t=38)or(t=39)or(t=40)or(t=50)or(t=51)or(t=55)or
            (t=63)or(t=81)or(t=83)or(t=78) then
            begin
              k:=0;
              break;
            end;
            inc(k);
            break;
          end;
        end;
        if (k<>0)and(k<>95) then
          blocks[k+(i*128+(j*2048))]:=78;
      end;
  end;
end;

procedure gen_cube(xkoord,ykoord:integer;var blocks:array of byte;var sferi:array of planets_settings; groundlevel:byte; map_type:byte; obj:par_tlights_koord; pop:boolean);
var i,j,z,k,t,t1,t2,a1:integer;
r,x1,y1,z1:integer;
vih,sand_b:boolean;
begin
  for k:=0 to length(sferi)-1 do
  begin
    vih:=true;
    for t:=0 to length(sferi[k].chunks)-1 do
      if (sferi[k].chunks[t].x=xkoord)and(sferi[k].chunks[t].y=ykoord) then
      begin
        vih:=false;
      end;

    if vih=true then continue;

    if sferi[k].parameter=0 then sand_b:=false
    else if (sferi[k].parameter=1)and(sferi[k].material_shell=12) then sand_b:=true;

    t:=sferi[k].material_shell;
    t1:=sferi[k].material_fill;

    //vichisaem otnositelnie koordinati sferi
    x1:=xkoord*16;
    z1:=ykoord*16;
    x1:=sferi[k].x-x1;
    z1:=sferi[k].z-z1;
    y1:=sferi[k].y;

    r:=sferi[k].radius;

    //delaem obolochku
    for i:=x1-r to x1+r do  //X
    begin
      if (i<0)or(i>15) then continue;
      for z:=z1-r to z1+r do //Z
      begin
        if (z<0)or(z>15) then continue;
        for j:=y1-r to y1+r do  //Y
        begin
          if (j=y1+r)then
          begin
            if (random<0.007)and(t=12)and(pop=false) then
            begin
              a1:=length(obj^);
              setlength(obj^,a1+1);
              obj^[a1].x:=xkoord*16+i;
              obj^[a1].z:=ykoord*16+z;
              obj^[a1].y:=j+1;
              obj^[a1].id:=1;
            end;
            if (random<0.008)and(t=3)and(pop=false) then
            begin
              a1:=length(obj^);
              setlength(obj^,a1+1);
              obj^[a1].x:=xkoord*16+i;
              obj^[a1].z:=ykoord*16+z;
              obj^[a1].y:=j+1;
              obj^[a1].id:=2;
            end;
            if t=3 then blocks[j+(z*128+(i*2048))]:=2
            else blocks[j+(z*128+(i*2048))]:=t;
          end
          else if (j<y1-r+3) then
          begin
            if (t=12)and(sand_b=true)and(j=y1-r) then blocks[j+(z*128+(i*2048))]:=82
            else if (t=20)and(i=x1)and(z=z1) then blocks[j+(z*128+(i*2048))]:=0
            else blocks[j+(z*128+(i*2048))]:=t;
          end
          else blocks[j+(z*128+(i*2048))]:=t;
        end;
      end;
    end;

    t2:=sferi[k].material_thick;

    if (t<>t1)or(t=20) then
    for i:=x1-r+t2 to x1+r-t2 do  //X
    begin
      if (i<0)or(i>15) then continue;
      for z:=z1-r+t2 to z1+r-t2 do //Z
      begin
        if (z<0)or(z>15) then continue;
        if (t1=9)and(t=20) then
        begin 
          for j:=y1-r+t2 to y1+r-t2 do
            blocks[j+(z*128+(i*2048))]:=0;
          vih:=false;
          for j:=y1-r+t2 to y1-r+sferi[k].fill_level do
          begin
            vih:=true;
            if j>(y1+r-t2) then break;
            blocks[j+(z*128+(i*2048))]:=t1;
          end;
          if (vih=true)and(i=x1)and(z=z1) then
            for j:=y1-r-1 to y1-r+t2-1 do
              blocks[j+(z*128+(i*2048))]:=8;
        end
        else
        for j:=y1-r+t2 to y1+r-t2 do  //Y
          blocks[j+(z*128+(i*2048))]:=t1;
      end;
    end;
  end;


  if (map_type>0)and(map_type<3) then
  begin
    //zapolnaem adminiumom vse do groundlevel
    for i:=0 to 15 do
      for j:=0 to 15 do
        for k:=0 to groundlevel do
          blocks[k+(j*128+(i*2048))]:=7;

    for i:=0 to 15 do
      for j:=0 to 15 do
        for k:=groundlevel+1 to groundlevel+3 do
          if map_type=1 then blocks[k+(j*128+(i*2048))]:=9
          else blocks[k+(j*128+(i*2048))]:=11;
  end;
  if map_type=3 then
  begin
  end;
end;

procedure gen_sphere(xkoord,ykoord:integer;var blocks:array of byte;var sferi:array of planets_settings; groundlevel:byte; map_type:byte; obj:par_tlights_koord; pop:boolean);
var r:integer;
x1,y1,z1:integer;
temp:integer;
i,j,k,z,l,t:integer;
sand_b:boolean;
vih:boolean;
begin
  {if map_type=3 then
    fillchar(blocks[0],length(blocks),1);  }

  //perechislaem vse sferi
  for k:=0 to length(sferi)-1 do
  begin
    vih:=true;
    for t:=0 to length(sferi[k].chunks)-1 do
      if (sferi[k].chunks[t].x=xkoord)and(sferi[k].chunks[t].y=ykoord) then
      begin
        vih:=false;
      end;

    if vih=true then continue;

    if sferi[k].parameter=0 then sand_b:=false
    else if (sferi[k].parameter=1)and(sferi[k].material_shell=12) then sand_b:=true;

    //vichisaem otnositelnie koordinati sferi
    x1:=xkoord*16;
    z1:=ykoord*16;
    x1:=sferi[k].x-x1;
    z1:=sferi[k].z-z1;
    y1:=sferi[k].y;

    r:=sferi[k].radius;

    for i:=0 to 15 do     //Z                   //levo pravo
      for j:=y1-round((r/3)*2) to y1+round((r/3)*2) do   //Y
      begin
        temp:=r*r-sqr(i-z1)-sqr(j-y1);
        if temp<0 then continue;
        for l:=0 to sferi[k].material_thick-1 do
        begin
          z:=x1+round(sqrt(temp))-l;
          if (z>=0)and(z<=15) then
            blocks[j+(i*128+(z*2048))]:=sferi[k].material_shell;
          z:=x1-round(sqrt(temp))+l;
          if (z>=0)and(z<=15) then
            blocks[j+(i*128+(z*2048))]:=sferi[k].material_shell;
        end;
      end;

    for i:=0 to 15 do    //X                     //pered zad
      for j:=y1-round((r/3)*2) to y1+round((r/3)*2) do   //Y
      begin
        temp:=r*r-sqr(i-x1)-sqr(j-y1);
        if temp<0 then continue;
        for l:=0 to sferi[k].material_thick-1 do
        begin
          z:=z1+round(sqrt(temp))-l;
          if (z>=0)and(z<=15) then
            blocks[j+(z*128+(i*2048))]:=sferi[k].material_shell;
          z:=z1-round(sqrt(temp))+l;
          if (z>=0)and(z<=15) then
            blocks[j+(z*128+(i*2048))]:=sferi[k].material_shell;  
        end;

      end;

    for i:=0 to 15 do     //X                   //verh niz
      for j:=0 to 15 do     //Z
      begin
        temp:=r*r-sqr(i-x1)-sqr(j-z1);

        if (blocks[y1+(j*128+(i*2048))]=12)and(sand_b=true) then    //zapolnaem glinoy dla vneshney granici sferi, kotoraya bila postroena 2 predidushimi ciklami
        begin
          l:=y1-1;
          while (blocks[l+(j*128+(i*2048))]<>0) do
            inc(l,-1);
          blocks[l+1+(j*128+(i*2048))]:=82;
        end;

        if (blocks[y1+(j*128+(i*2048))]=3) then       //trava na verhu sferi iz zemli
        begin
          l:=y1+1;
          while (blocks[l+(j*128+(i*2048))]<>0) do
            inc(l);
          blocks[l-1+(j*128+(i*2048))]:=2;
        end;

        if temp<0 then continue;
        //z:=y1+round(sqrt(temp));
        //if (y1+round(sqrt(temp)))>(y1+round(r/3)) then     //esli ubrat' kommenti, to budut zapolnatsa tolko 2/3 poverhnosti sferi
        for l:=0 to sferi[k].material_thick-1 do
        begin
          z:=y1+round(sqrt(temp))-l;
          blocks[z+(j*128+(i*2048))]:=sferi[k].material_shell;

          if l=0 then
            if sferi[k].material_shell=12 then
            begin
              if (random<0.017)and(pop=false) then
              begin
                t:=length(obj^);
                setlength(obj^,t+1);
                obj^[t].x:=xkoord*16+i;
                obj^[t].z:=ykoord*16+j;
                obj^[t].y:=z+1;
                obj^[t].id:=1;
              end;
            end
            else if sferi[k].material_shell=3 then
            begin
              if (random<0.009)and(pop=false) then
              begin
                t:=length(obj^);
                setlength(obj^,t+1);
                obj^[t].x:=xkoord*16+i;
                obj^[t].z:=ykoord*16+j;
                obj^[t].y:=z+1;
                obj^[t].id:=2;
              end;
            end;
          z:=y1-round(sqrt(temp))+l;
          blocks[z+(j*128+(i*2048))]:=sferi[k].material_shell;
        end;

        if (sferi[k].material_shell=12)and(sand_b=true) then     //glina vnizu pesochnoy
        begin
          l:=z-1;
          while (blocks[l+(j*128+(i*2048))]<>0) do
            inc(l,-1);
          blocks[l+1+(j*128+(i*2048))]:=82;
        end;

        //v peremennoy z hranitsa visota, na kotoroy zakanchivaetsa vneshniy sloy snizu na koordinatah X,Z = i,j
        //zapolnaem vnutrennuyu ploshad'
        for l:=z+1 to (y1+round(sqrt(temp))-sferi[k].material_thick) do
        begin
          if l>(y1-r+sferi[k].fill_level) then break;
          if (blocks[l+(j*128+(i*2048))]=0)or(map_type=3) then
            blocks[l+(j*128+(i*2048))]:=sferi[k].material_fill;
        end;

        if (blocks[y1+(j*128+(i*2048))]=3) then       //trava na verhu sferi iz zemli
        begin
          l:=z+1;
          while (blocks[l+(j*128+(i*2048))]<>0) do
            inc(l);
          blocks[l-1+(j*128+(i*2048))]:=2;
        end;  

        //delaem dirku v steklannoy sfere s vodoy
        if (i=x1)and(j=z1)and(sferi[k].material_shell=20) then
          for l:=y1-r-1 to y1-r+sferi[k].material_thick-1 do
          begin
            if sferi[k].fill_level<3 then
              blocks[l+(j*128+(i*2048))]:=0
            else
              blocks[l+(j*128+(i*2048))]:=8;
          end;
      end;    
  end;

  if (map_type>0)and(map_type<3) then
  begin
    //zapolnaem adminiumom vse do groundlevel
    for i:=0 to 15 do
      for j:=0 to 15 do
        for k:=0 to groundlevel do
          blocks[k+(j*128+(i*2048))]:=7;

    for i:=0 to 15 do
      for j:=0 to 15 do
        for k:=groundlevel+1 to groundlevel+3 do
          if map_type=1 then blocks[k+(j*128+(i*2048))]:=9
          else blocks[k+(j*128+(i*2048))]:=11;
  end;
  if map_type=3 then
  begin
    {for i:=0 to 15 do
      for j:=0 to 15 do
        for k:=120 to 127 do
          blocks[k+(j*128+(i*2048))]:=0;  }
  end;

end;

function gen_planets_thread(Parameter:pointer):integer;
var param:ptparam_planet;
par:tparam_planet;
otx,oty,dox,doy,id:integer;           //nachanlie i konechnie znacheniya chankov v regione po osam
regx_nach,regy_nach:integer;       //nachalo regionov
tempx,tempy,tempk,tempz,kol:integer;           //dla raznih nuzhd
regx,regy:integer;                 //kol-vo regionov po osam
i,j,k,z:integer;
map:region;                        //karta regiona
ar, arobsh:ar_planets_settings;      //massivi dla sfer
head:mcheader;
str,strcompress:string;
hndl:cardinal;                     
count:dword;
rez,fdata:ar_type;
co:longword;
b,sp,b1:boolean;
temp:extended;
obj:ar_tlights_koord;
pop_koord:ar_tkoord;

procedure thread_exit(p:ptparam_planet);
var i,j,k:integer;
begin
  if p^.planet_par^.potok_exit=true then
  begin
    //ochishaem ot obshego i lokalnogo massiva sfer
  setlength(rez,0);

  for k:=0 to length(arobsh)-1 do
    setlength(arobsh[k].chunks,0);

  setlength(arobsh,0);
  setlength(ar,0);
  setlength(obj,0);
  setlength(pop_koord,0);

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

  postmessage(par.handle,WM_USER+301,par.id,0);
  endthread(0);
  end;
end;

begin   
  //1. Sgenerirovat sferi po regionam v sootvetstvii s nastroykami tox/fromx/toy/fromy (chtobi ne generilis' lishnie)
  //2. Dobavlat sgenerennie sferi v obshiy massiv
  //2.5 Rabota so sferami: vibrat' material, harakteristiki i vozmozhno chanki, k kotorim prinadlezhit sfera, dla bistrogo dostupa.
  //3. Proytis' po regionam fayla:
  //4. Pri risovanii ispolzovat' massiv, korotiy vmeshaet 32*32 chanka + po 2 chanka s kazhdoy storoni (vsego 36*36 chankov)
  //5. Narisovat' sferi na granice i vnutri region fayla, rukovodstvuas obshim massivom sfer
  //6. Vichislit' skylight i blocklight na vsey karte regiona (36*36 chankov)
  //7. Vichislit' heightmap tol'kom dla chankov regiona (chtobi lishnee ne vicheslat'
  //8. Skomponovat' vse massivi v NBT strukturu i pri etom izmenat' zagolovok fayla regionov. Skomponovannie dannie zapisivat' v massiv.
  //9. Zapisat' v fayl pravil'niy zagolovok i skomponovannie dannie dla vseh chankov srazu


  param:=parameter;
  par:=param^;
  //par_pl:=par.planet_par^;
  //par_bor:=par.border_par^;
  postmessage(par.handle,WM_USER+307,0,0);

  if loaded=true then postmessage(par.handle,WM_USER+304,9999,9999);

  //vichislaem kol-vo chankov
  {case par.border_par^.border_type of
  1:if par.border_par^.wall_void=true then i:=((par.tox+par.border_par^.wall_void_thickness)-(par.fromx-par.border_par^.wall_void_thickness)+1)*((par.toy+par.border_par^.wall_void_thickness)-(par.fromy-par.border_par^.wall_void_thickness)+1)
      else i:=(par.tox-par.fromx+1)*(par.toy-par.fromy+1);
  2:i:=((par.tox+par.border_par^.void_thickness)-(par.fromx-par.border_par^.void_thickness)+1)*((par.toy+par.border_par^.void_thickness)-(par.fromy-par.border_par^.void_thickness)+1);
  3:if par.border_par^.cwall_gen_void=true then i:=((par.tox+par.border_par^.cwall_void_width)-(par.fromx-par.border_par^.cwall_void_width)+1)*((par.toy+par.border_par^.cwall_void_width)-(par.fromy-par.border_par^.cwall_void_width)+1)
      else i:=(par.tox-par.fromx+1)*(par.toy-par.fromy+1);
  else
    i:=(par.tox-par.fromx+1)*(par.toy-par.fromy+1);
  end;
  //peredaem kol-vo chankov vmeste s border v osnovnuyu formu
  postmessage(par.handle,WM_USER+302,par.id,i);       }

  //videlaem pamat pod massiv NBT dla generacii
  //ToDO: sdelat' videlenie pamati v procedure komponovki v module NBT
  setlength(rez,82360);

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

  setlength(pop_koord,0);

  kol:=0;
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

  //randomize;
  RandSeed:=par.sid;

  //schetchik chankov
  co:=0;

  //postmessage(par.handle,WM_USER+300,1,0);

  //sozdaem obshiy massiv dla sfer
  setlength(arobsh,0);

  //peredaem soobshenie o nachale generacii sfer
  postmessage(par.handle,WM_USER+307,0,0);

  thread_exit(param);

  //schitaem kol-vo region faylov i inicializiruem progress bar
  postmessage(par.handle,WM_USER+316,regx*regy,0);

  count:=0;

  //generim sferi
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

      //opredelaem kol-vo sfer, kotorie nuzhno generit'
      //100%=15 sfer na chank

      //opredelaem kol-vo chankov v regione
      kol:=(dox-otx+1)*(doy-oty+1);

      case par.planet_par^.planets_type of
      0:kol:=round(((kol*((par.planet_par^.density*14.2-142)/80+0.8))/100)*(par.planet_par^.density/2.5));
      1:kol:=round(((kol*15)/100)*(par.planet_par^.density));
      end;

      if kol=0 then continue;

      //videlaem pamat' pod sferi
      setlength(ar,kol);
      //setlength(ar,5);

      postmessage(par.handle,WM_USER+304,200,kol);

      thread_exit(param);

      //opredelaem koordinati sfer i radiusi sfer
      for k:=0 to length(ar)-1 do
      begin
        //generim v koordinatah, otnositel'no regiona
        ar[k].x:=random((dox-otx)*16)+(otx*16);
        ar[k].y:=random(128-(par.planet_par^.distance*2))+par.planet_par^.distance;
        ar[k].z:=random((doy-oty)*16)+(oty*16);
        ar[k].radius:=random(par.planet_par^.max-par.planet_par^.min)+par.planet_par^.min;
      end;

      //opredelenie sfer, kotorie zadevayut granici regiona
      //sferi, kotorie nahodatsa na granice s regionom, kotoriy sushestvuet ne udalayutsa
      if ((i=regx_nach)or(j=regy_nach)or(i=(regx_nach+regx-1))or(j=(regy_nach+regy-1)))and
      ((par.border_par^.border_type=1)or(par.border_par^.border_type=3)) then
      begin
        inc(otx);
        inc(oty);
        dec(dox);
        dec(doy);
      end;

      for k:=0 to length(ar)-1 do
      begin     
        if ((ar[k].y-ar[k].radius)<par.planet_par^.groundlevel+3+par.planet_par^.distance)or
        ((ar[k].y+ar[k].radius)>127-par.planet_par^.distance)then
        begin
          ar[k].y:=1000;
          continue;
        end;

        if (j=regy_nach)and                           //esli samiy nizhniy region
        ((ar[k].z-ar[k].radius)<(oty*16+par.planet_par^.distance)) then
        begin
          ar[k].y:=1000;
          continue;
        end;

        if (i=regx_nach)and                           //esli saviy leviy region
        ((ar[k].x-ar[k].radius)<(otx*16+par.planet_par^.distance)) then
        begin
          ar[k].y:=1000;
          continue;
        end;

        if (i=(regx_nach+regx-1))and       //esli samiy praviy region, togda ogranichit' sferi
        ((ar[k].x+ar[k].radius)>((dox+1)*16-par.planet_par^.distance)) then
        begin
          ar[k].y:=1000;
          continue;
        end;

        if (j=(regy_nach+regy-1))and       //esli samiy verhniy region, togda ogranichit' sferi
        ((ar[k].z+ar[k].radius)>((doy+1)*16-par.planet_par^.distance)) then
        begin
          ar[k].y:=1000;
          continue;
        end;
      end;

      if ((i=regx_nach)or(j=regy_nach)or(i=(regx_nach+regx-1))or(j=(regy_nach+regy-1)))and
      ((par.border_par^.border_type=1)or(par.border_par^.border_type=3)) then
      begin
        dec(otx);
        dec(oty);
        inc(dox);
        inc(doy);
      end;

      //udalenie sfer
      k:=0;
      repeat
        if ar[k].y=1000 then
        begin
          if k<>(length(ar)-1) then
          move(ar[k+1],ar[k],(length(ar)-k-1)*sizeof(planets_settings));
          setlength(ar,length(ar)-1);
        end
        else
          inc(k);
      until k>(length(ar)-1);

      if length(ar)=0 then continue;

      case par.planet_par^.planets_type of
      0:begin
          //novaya procedura poiska peresecheniy
          fill_planet_chunks(ar);

          for k:=0 to length(ar)-2 do
          begin
            if ar[k].y=1000 then continue;
            for z:=k+1 to length(ar)-1 do
            begin
             if ar[z].y=1000 then continue;
              b:=false;
              for tempx:=0 to length(ar[k].chunks)-1 do
              begin
                if b=true then break;
                for tempy:=0 to length(ar[z].chunks)-1 do
                  if (ar[k].chunks[tempx].x=ar[z].chunks[tempy].x)and
                  (ar[k].chunks[tempx].y=ar[z].chunks[tempy].y) then
                  begin
                    b:=true;
                    break;
                  end;
              end;

              if b=false then continue;

              temp:=sqrt(sqr(ar[k].x-ar[z].x)+sqr(ar[k].y-ar[z].y)+sqr(ar[k].z-ar[z].z));
              temp:=temp-ar[k].radius-ar[z].radius;
              if temp<par.planet_par^.distance then
                ar[z].y:=1000;
                {if random<0.5 then
                  ar[k].y:=1000
                else
                  ar[z].y:=1000; }
            end;
          end;

          for k:=0 to length(ar)-1 do
            setlength(ar[k].chunks,0);
        end;
      1:begin
          //ishem peresekayushie sferi tut, t.k. v obshem masive mozhet bit' slishkom mnogo sfer
          for k:=0 to length(ar)-2 do
          begin
            if ar[k].y=1000 then continue;
            for z:=k+1 to length(ar)-1 do
            begin
              if ar[z].y=1000 then continue;
              //prostoe sravnenie namnogo luchshe po skorosti i proigrivaet ne tak mnogo v opredelenii rasstoyaniya mezhdu sferami
              if ((ar[k].x+ar[k].radius+ar[z].radius+par.planet_par^.distance)>ar[z].x)and
              ((ar[k].x-ar[k].radius-ar[z].radius-par.planet_par^.distance)<ar[z].x)and
              ((ar[k].z+ar[k].radius+ar[z].radius+par.planet_par^.distance)>ar[z].z)and
              ((ar[k].z-ar[k].radius-ar[z].radius-par.planet_par^.distance)<ar[z].z)and
              ((ar[k].y+ar[k].radius+ar[z].radius+par.planet_par^.distance)>ar[z].y)and
              ((ar[k].y-ar[k].radius-ar[z].radius-par.planet_par^.distance)<ar[z].y) then
                if random>=0.5 then
                 ar[k].y:=1000
                else
                  ar[z].y:=1000;
            end;
          end;
        end;
      end;

      //udalenie sfer
      k:=0;
      repeat
        if ar[k].y=1000 then
        begin
          //setlength(ar[k].chunks,0);
          if k<>(length(ar)-1) then
          move(ar[k+1],ar[k],(length(ar)-k-1)*sizeof(planets_settings));
          setlength(ar,length(ar)-1);
        end
        else
          inc(k);
      until k>(length(ar)-1);

      if length(ar)=0 then continue;

      postmessage(par.handle,WM_USER+304,300,length(ar));

      //perevod koordinat i dobavlenie v obshiy massiv
      for k:=0 to length(ar)-1 do
      begin
        if i<0 then ar[k].x:=((i+1)*512-(512-ar[k].x))
        else ar[k].x:=(i*512)+ar[k].x;

        if j<0 then  ar[k].z:=((j*512)+ar[k].z)
        else ar[k].z:=(j+1)*512-(512-ar[k].z);
      end;

      //dobavlaem v obshiy massiv
      //no pered dobavleniem ochishaem chanki
      //for k:=0 to length(ar)-1 do
      //  setlength(ar[k].chunks,0);

      tempx:=length(arobsh);

      setlength(arobsh,length(arobsh)+length(ar));
      move(ar[0],arobsh[tempx],length(ar)*sizeof(planets_settings));


      case par.planet_par^.planets_type of
      0:begin
          //novaya procedura opredeleniya peresecheniya
          fill_planet_chunks(arobsh);

          for k:=0 to length(arobsh)-2 do
          begin
            if arobsh[k].y=1000 then continue;
            for z:=k+1 to length(arobsh)-1 do
            begin
              if arobsh[z].y=1000 then continue;
              b:=false;
              for tempx:=0 to length(arobsh[k].chunks)-1 do
              begin
                if b=true then break;
                for tempy:=0 to length(arobsh[z].chunks)-1 do
                  if (arobsh[k].chunks[tempx].x=arobsh[z].chunks[tempy].x)and
                  (arobsh[k].chunks[tempx].y=arobsh[z].chunks[tempy].y) then
                  begin
                    b:=true;
                    break;
                  end;
              end;

              if b=false then continue;

              temp:=sqrt(sqr(arobsh[k].x-arobsh[z].x)+sqr(arobsh[k].y-arobsh[z].y)+sqr(arobsh[k].z-arobsh[z].z));
              temp:=temp-arobsh[k].radius-arobsh[z].radius;
              if temp<par.planet_par^.distance then
                arobsh[z].y:=1000;
                {if random<0.5 then
                  arobsh[k].y:=1000
                else
                  arobsh[z].y:=1000;}
            end;
          end;

          for k:=0 to length(arobsh)-1 do
            setlength(arobsh[k].chunks,0);
        end;
      1:begin
          //opredelaem peresechenie sfer v obshem massive
          for k:=0 to length(arobsh)-2 do
          begin
            thread_exit(param);
            if arobsh[k].y=1000 then continue;
            for z:=k+1 to length(arobsh)-1 do
            begin
              if arobsh[z].y=1000 then continue;
              //prostoe sravnenie namnogo luchshe po skorosti i proigrivaet ne tak mnogo v opredelenii rasstoyaniya mezhdu sferami
              if ((arobsh[k].x+arobsh[k].radius+arobsh[z].radius+round((par.planet_par^.distance/100)*((100-par.planet_par^.density)*5)))>arobsh[z].x)and
              ((arobsh[k].x-arobsh[k].radius-arobsh[z].radius-round((par.planet_par^.distance/100)*((100-par.planet_par^.density)*5)))<arobsh[z].x)and
              ((arobsh[k].z+arobsh[k].radius+arobsh[z].radius+round((par.planet_par^.distance/100)*((100-par.planet_par^.density)*5)))>arobsh[z].z)and
              ((arobsh[k].z-arobsh[k].radius-arobsh[z].radius-round((par.planet_par^.distance/100)*((100-par.planet_par^.density)*5)))<arobsh[z].z)and
              ((arobsh[k].y+arobsh[k].radius+arobsh[z].radius+round((par.planet_par^.distance/100)*((100-par.planet_par^.density)*5)))>arobsh[z].y)and
              ((arobsh[k].y-arobsh[k].radius-arobsh[z].radius-round((par.planet_par^.distance/100)*((100-par.planet_par^.density)*5)))<arobsh[z].y) then
                if random>=0.5 then
                  arobsh[k].y:=1000
                else
                  arobsh[z].y:=1000;
            end;
          end;
        end;
      end;


      //udalenie sfer v obshem massive
      k:=0;
      repeat
        if arobsh[k].y=1000 then
        begin
          //setlength(arobsh[k].chunks,0);
          if k<>(length(arobsh)-1) then
          move(arobsh[k+1],arobsh[k],(length(arobsh)-k-1)*sizeof(planets_settings));
          setlength(arobsh,length(arobsh)-1);
        end
        else
          inc(k);
      until k>(length(arobsh)-1);

      postmessage(par.handle,WM_USER+304,400,length(arobsh));

      thread_exit(param);

      //obnovlaem progress bar
      inc(count);
      postmessage(par.handle,WM_USER+317,count,0);
    end;

  //v arobsh dolzhni bit' sferi so vseh regionov s normalnimi koordinatami

      //opredelenie materiala sfer i chankov, k kotorim oni prinadlezhat
      for k:=0 to length(arobsh)-1 do
      begin
        z:=random(100);
        case z of
        0..13:begin    //Sand
            arobsh[k].material_shell:=12;
            arobsh[k].material_fill:=12;
            arobsh[k].material_thick:=1;
            arobsh[k].fill_level:=arobsh[k].radius*2-1;
            if random>0.9 then arobsh[k].parameter:=0
            else arobsh[k].parameter:=1;
          end;
        14..42:begin    //Stone
            arobsh[k].material_shell:=1;
            arobsh[k].material_thick:=2;
            arobsh[k].fill_level:=arobsh[k].radius*2-2;
            arobsh[k].material_fill:=random(100);
            case arobsh[k].material_fill of
            0..4:arobsh[k].material_fill:=56;  //Dimond
            5..9:arobsh[k].material_fill:=21;  //Lapis lazuli
            10..16:arobsh[k].material_fill:=48;//Moss cobblestone
            17..24:arobsh[k].material_fill:=14;//Gold ore
            25..33:arobsh[k].material_fill:=13;//Gravel
            34..42:arobsh[k].material_fill:=73;//Redstone;
            43..52:arobsh[k].material_fill:=9; //Water
            53..64:arobsh[k].material_fill:=11;//Lava
            65..78:arobsh[k].material_fill:=15;//Iron
            79..99:arobsh[k].material_fill:=16 //Coal
            else
              postmessage(par.handle,WM_USER+304,200,-2222);
            end;
          end;
        43..54:begin    //Leaves
            arobsh[k].material_shell:=18;
            arobsh[k].material_fill:=17;
            arobsh[k].material_thick:=2;
            arobsh[k].fill_level:=arobsh[k].radius*2-2;
          end;
        55..65:begin    //Glass
            arobsh[k].material_shell:=20;
            arobsh[k].material_fill:=9;
            arobsh[k].material_thick:=3;
            arobsh[k].fill_level:=random(arobsh[k].radius*2);
          end;
        66..77:begin    //Glowstone
            arobsh[k].material_shell:=89;
            arobsh[k].material_fill:=89;
            arobsh[k].material_thick:=1;
            arobsh[k].fill_level:=arobsh[k].radius*2-1;
          end;
        78..99:begin    //Dirt
            arobsh[k].material_shell:=3;
            arobsh[k].material_thick:=1;
            arobsh[k].material_fill:=3;
            arobsh[k].fill_level:=arobsh[k].radius*2-1;
          end
        else
          postmessage(par.handle,WM_USER+304,200,-1111);
        end;

      {//otadka
      arobsh[k].material_shell:=20;
            arobsh[k].material_fill:=9;
            arobsh[k].material_thick:=3;
            arobsh[k].fill_level:=random(arobsh[k].radius*2);}

      //opredelaem kraynie koordinati po dvum osam
      tempx:=arobsh[k].x-arobsh[k].radius;
      tempk:=arobsh[k].x+arobsh[k].radius;
      tempy:=arobsh[k].z-arobsh[k].radius;
      tempz:=arobsh[k].z+arobsh[k].radius;

      //perevodim koordinati v chanki
      if tempx<0 then inc(tempx);
      if tempk<0 then inc(tempk);
      if tempy<0 then inc(tempy);
      if tempz<0 then inc(tempz);

      //zapisivaem koordinati
      tempx:=tempx div 16;
      tempk:=tempk div 16;
      tempy:=tempy div 16;
      tempz:=tempz div 16;

      //popravka na minusovie chanki
      if (tempx<=0)and((arobsh[k].x-arobsh[k].radius)<0) then tempx:=tempx-1;
      if (tempk<=0)and((arobsh[k].x+arobsh[k].radius)<0) then tempk:=tempk-1;
      if (tempy<=0)and((arobsh[k].z-arobsh[k].radius)<0) then tempy:=tempy-1;
      if (tempz<=0)and((arobsh[k].z+arobsh[k].radius)<0) then tempz:=tempz-1;

      //videlaem pamat'
      setlength(arobsh[k].chunks,(tempk-tempx+1)*(tempz-tempy+1));  

      //zapisivaem
      z:=0;
      for i:=tempx to tempk do
        for j:=tempy to tempz do
        begin
          arobsh[k].chunks[z].x:=i;
          arobsh[k].chunks[z].y:=j;
          inc(z);
        end;

      end;

  {//dla otladki
  setlength(arobsh,1);
  arobsh[0].x:=10;
  arobsh[0].y:=14;
  arobsh[0].z:=10;
  arobsh[0].radius:=9;
  arobsh[0].material_shell:=3;
  arobsh[0].material_fill:=3;
  arobsh[0].material_thick:=1;
  arobsh[0].fill_level:=arobsh[0].radius*2-1;
  arobsh[0].parameter:=1;   }


  //opredelenie blizhayshey sferi iz zemli ili listvi k koordinatam 0,0 dla spavna
  i:=round(sqrt(sqr(arobsh[0].x)+sqr(arobsh[0].z)));
  j:=0;

  for k:=1 to length(arobsh)-1 do
  begin
    z:=round(sqrt(sqr(arobsh[k].x)+sqr(arobsh[k].z)));
    if (z<i)and((arobsh[k].material_shell=18)or(arobsh[k].material_shell=3)) then
    begin
      i:=z;
      j:=k;
    end;
  end;

  //peredaem koordinati spavna
  postmessage(par.handle,WM_USER+308,1,arobsh[j].x);
  postmessage(par.handle,WM_USER+308,2,arobsh[j].y+arobsh[j].radius+1);
  postmessage(par.handle,WM_USER+308,3,arobsh[j].z);


  //pereschitivaem nachalo i konec regionov i chankov, dla generacii granici karti
  if par.border_par^.border_type<>0 then
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

  postmessage(par.handle,WM_USER+316,0,0);

  i:=(par.tox-par.fromx+1)*(par.toy-par.fromy+1);
  //peredaem kol-vo chankov vmeste s border v osnovnuyu formu
  postmessage(par.handle,WM_USER+302,par.id,i);

  postmessage(par.handle,WM_USER+300,1,0);

  //ochishaem massiv dla zapisi v fayl na vsakiy sluchay
  setlength(fdata,0);

  sp:=true;

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
          clear_all_entities(@map[k][z].entities,@map[k][z].tile_entities);
          zeromemory(map[k][z].blocks,length(map[k][z].blocks));
          zeromemory(map[k][z].data,length(map[k][z].data));
          zeromemory(map[k][z].light,length(map[k][z].light));
          zeromemory(map[k][z].skylight,length(map[k][z].skylight));
          zeromemory(map[k][z].heightmap,length(map[k][z].heightmap));
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

          case par.planet_par^.planets_type of
          0:gen_sphere(tempx-2,tempy-2,map[k][z].blocks,arobsh,par.planet_par^.groundlevel,par.planet_par^.map_type,@obj,b1);
          1:gen_cube(tempx-2,tempy-2,map[k][z].blocks,arobsh,par.planet_par^.groundlevel,par.planet_par^.map_type,@obj,b1);
          end;

          gen_border(tempx-2,tempy-2,par.tox-par.fromx+1,par.toy-par.fromy+1,par.border_par^,map[k][z].blocks,map[k][z].data,@map[k][z].entities,@map[k][z].tile_entities);

          //generim heightmap
          calc_heightmap(map[k][z].blocks,map[k][z].heightmap);
        end;

      //zapisivaem features
      //if loaded=true then
      //gen_struct(map,otx,oty,dox,doy,nil,nil,5,par.handle);

      for k:=0 to length(obj)-1 do
        case obj[k].id of
        1:begin
            if get_block_id(map,i,j,obj[k].x,obj[k].y,obj[k].z)<>255 then
              gen_cactus(map,i,j,obj[k].x,obj[k].y,obj[k].z,par.planet_par^.sid+k);
          end;
        2:begin
            if obj[k].y>90 then
            begin
              if random<0.5 then gen_taigatree1_notch(map,i,j,obj[k].x,obj[k].y,obj[k].z,par.planet_par^.sid+k)
              else gen_taigatree2_notch(map,i,j,obj[k].x,obj[k].y,obj[k].z,par.planet_par^.sid+k);
            end
            else
              if random<0.2 then gen_bigtree_notch(map,i,j,obj[k].x,obj[k].y,obj[k].z,par.planet_par^.sid+k,sp,0,0)
              else gen_tree_notch(map,i,j,par.planet_par^.sid+k,obj[k].x,obj[k].y,obj[k].z,sp,0,0,0);
          end;
        end;

      for k:=0 to 35 do
        for z:=0 to 35 do
        begin
          if i<0 then tempx:=((i+1)*32-(32-k))
          else tempx:=(i*32)+k;

          if j<0 then  tempy:=((j*32)+z)
          else tempy:=(j+1)*32-(32-z);

          gen_planets_snow(tempx-2,tempy-2,par.tox-par.fromx+1,par.toy-par.fromy+1,par.border_par^,map[k][z].blocks,map[k][z].data);
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

          nbtcompress2(tempx,tempy,map[k+2][z+2].blocks,map[k+2][z+2].data,map[k+2][z+2].skylight,map[k+2][z+2].light,map[k+2][z+2].heightmap,map[k+2][z+2].entities,map[k+2][z+2].tile_entities,not(par.planet_par^.pop_chunks),@rez);

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

  //ochishaem ot obshego i lokalnogo massiva sfer
  setlength(rez,0);

  for k:=0 to length(arobsh)-1 do
    setlength(arobsh[k].chunks,0);

  setlength(arobsh,0);
  setlength(ar,0);
  setlength(obj,0);
  setlength(pop_koord,0);

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

  postmessage(par.handle,WM_USER+301,par.id,0);
  endthread(0);
end;

end.

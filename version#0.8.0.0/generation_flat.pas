unit generation_flat;

interface

function gen_flat_thread(Parameter:pointer):integer;

implementation

uses generation_obsh, NBT, generation_spec, windows, zlibex, sysutils;

procedure gen_flat_surf_proc(par_flat:flatmap_settings_type; var blocks,data:ar_type);
var i,j,k,z:integer;
tempx,tempy,tempz,kol:byte;
begin
  //ochishaem massivi
  zeromemory(blocks,length(blocks));
  zeromemory(data,length(data));

  //cikl po vsem sloam
  for i:=0 to length(par_flat.sloi)-1 do
  begin
    tempx:=par_flat.sloi[i].material;
    tempy:=par_flat.sloi[i].start_alt;
    tempz:=par_flat.sloi[i].material_data;
    kol:=par_flat.sloi[i].width;

    for k:=0 to 15 do
      for z:=0 to 15 do
        for j:=tempy to tempy+kol-1 do
          blocks[j+(k*128+(z*2048))]:=tempx;

    if tempz<>0 then
      for k:=0 to 15 do
        for z:=0 to 15 do
          for j:=tempy to tempy+kol-1 do
            data[j+(k*128+(z*2048))]:=tempz;
  end;

    {//chitaem materiali blokov
    tempx:=par_flat.groundmaterial;
    tempy:=par_flat.dirtmaterial;

    //ochishaem massiv
    zeromemory(blocks,length(blocks));

    //zapolnaem nizhniy (perviy) sloy bedrokom
    for i:=0 to 15 do  //X
      for j:=0 to 15 do //Y
        blocks[(j*128+(i*2048))]:=7;

    //esli est flag dirt_on_top, togda ne zapolnaem ne vse, a tolko do urovna groundlevel-4 (ostaetsa 3 bloka)
    if par_flat.dirt_on_top then
    begin
      kol:=0;
      if par_flat.grass_on_top then    //esli est flag grass_on_top, togda zapolnaem travoy verhniy uroven i stavim smeshenie
      begin
        kol:=1;
        for i:=0 to 15 do //X
          for j:=0 to 15 do //Z
            blocks[(par_flat.groundlevel-1)+(j*128+(i*2048))]:=2; //trava
      end;
      for k:=1 to par_flat.groundlevel-4 do //visota Y
        for i:=0 to 15 do //X
          for j:=0 to 15 do //Z
            blocks[k+(j*128+(i*2048))]:=tempx; //material groundmaterial

      for k:=par_flat.groundlevel-3 to par_flat.groundlevel-1-kol do //visota Y
        for i:=0 to 15 do //X
          for j:=0 to 15 do //Z
            blocks[k+(j*128+(i*2048))]:=tempy; //material dirtmaterial
    end
    else  //esli netu flaga, to zapolnaem vse
    begin
      for k:=1 to par_flat.groundlevel-1 do //visota Y
        for i:=0 to 15 do //X
          for j:=0 to 15 do //Z
            blocks[k+(j*128+(i*2048))]:=tempx; //material groundmaterial
    end;

    //delaem waterlevel
    if par_flat.waterlevel>par_flat.groundlevel then
    begin
      for k:=par_flat.groundlevel to par_flat.waterlevel-1 do //visota Y
        for i:=0 to 15 do //X
          for j:=0 to 15 do //Z
            blocks[k+(j*128+(i*2048))]:=9;

      for k:=par_flat.groundlevel to par_flat.waterlevel-1 do //visota Y
        for i:=0 to 15 do //X
          for j:=0 to 15 do //Z
            blocks[k+(j*128+(i*2048))]:=9;

    end;

    //zapolnaem massiv data
    zeromemory(data,length(data));  }
end;

procedure gen_flat_surf(xkoord,ykoord:integer; par_flat:flatmap_settings_type; par_border:border_settings_type;var blocks,data:ar_type);
{var i,j,k:integer;
tempx,tempy,temp_th:integer;
kol:byte;  }
begin
  gen_flat_surf_proc(par_flat,blocks,data);
  {//proveraem tip granici
  if par_border.border_type=0 then //generim obichniy chank
  begin
    gen_flat_surf_proc(par_flat,blocks,data);
  end
  else if par_border.border_type=1 then
  begin
    kol:=par_border.wall_material;
    tempx:=-(par_flat.width div 2);
    tempy:=-(par_flat.len div 2);
    //opredelaem, chank nahoditsa vnutri karti ili za predelami granici
    if (xkoord>(par_flat.width div 2)-1)or
    (xkoord<tempx)or
    (ykoord>(par_flat.len div 2)-1)or
    (ykoord<tempy) then
    begin
      zeromemory(blocks,length(blocks));
      zeromemory(data,length(data));
    end
    else
    begin
      gen_flat_surf_proc(par_flat,blocks,data);

      temp_th:=par_border.wall_thickness-1;

      if (xkoord=(par_flat.width div 2)-1) then     //esli chank samiy praviy
        for j:=0 to 15 do   //Z
          for i:=15 downto 15-temp_th do  //X
            for k:=0 to 127 do  //Y
              blocks[k+(j*128+(i*2048))]:=kol;

      if (xkoord=tempx) then     //esli chank samiy leviy
        for j:=0 to 15 do //Z
          for i:=0 to temp_th do //X
            for k:=0 to 127 do //Y
              blocks[k+(j*128+(i*2048))]:=kol;

      if (ykoord=(par_flat.len div 2)-1) then       //esli chank samiy verhniy
        for i:=0 to 15 do //X
          for j:=15 downto 15-temp_th do //Z
            for k:=0 to 127 do //Y
              blocks[k+(j*128+(i*2048))]:=kol;

      if (ykoord=tempy) then                      //samiy nizhniy
        for i:=0 to 15 do  //X
          for j:=0 to temp_th do //Z
            for k:=0 to 127 do  //Y
              blocks[k+(j*128+(i*2048))]:=kol;
    end;

  end
  else if par_border.border_type=2 then
  begin
    tempx:=-(par_flat.width div 2);
    tempy:=-(par_flat.len div 2);
    if (xkoord>(par_flat.width div 2)-1)or
    (xkoord<tempx)or
    (ykoord>(par_flat.len div 2)-1)or
    (ykoord<tempy) then
    begin
      zeromemory(blocks,length(blocks));
      zeromemory(data,length(data));
    end
    else
      gen_flat_surf_proc(par_flat,blocks,data);
  end;  }
end;

function gen_flat_thread(Parameter:pointer):integer;
var i,j,k,z:integer;     //peremennie dla regulirovaniya ciklov po regionam i chankam
kol:integer;
id:byte;
tempx,tempy,tempk,tempz:integer;     //peremennie dla lubih nuzhd
otx,dox,oty,doy:integer;   //granici chankov
regx,regy:integer;   //kol-vo region faylov
regx_nach,regy_nach:integer;  //nachalniy region (menshiy), s kotorogo nachinaetsa generaciya
param:ptparam_flat;
par:tparam_flat;
str,strcompress:string;
rez:ar_type;
head:mcheader;
map:region;
fdata:array of byte;
co:longword;
hndl:cardinal;
count:dword;
ar_struct:ar_param_structure;
par_struct:par_param_structure;

procedure thread_exit(p:ptparam_flat);
var i,j:integer;
begin
  if p^.flatmap_par^.potok_exit=true then
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

  postmessage(par.handle,WM_USER+301,par.id,0);
  endthread(0);
  end;
end;

begin
  param:=parameter;
  par:=param^;

  if loaded=true then postmessage(par.handle,WM_USER+304,9999,9999);

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

  //ToDO: sdelat' videlenie pamati v procedure komponovki v module NBT
  //setlength(rez,82360);

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
  
  kol:=0;

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

  //inicilializiruem random
  Randseed:=par.sid;

  //schetchik chankov
  co:=0;

  if loaded=true then
  begin
    par_struct:=@ar_struct;
    //generiruem oblasi
    gen_obl(par.fromx,par.fromy,par.tox,par.toy,@ar_struct);

    postmessage(par.handle,WM_USER+304,9000,length(ar_struct));

    if length(ar_struct)>0 then
    begin
     //ishem peresechenie
     for k:=0 to length(ar_struct)-2 do
     begin
       if ar_struct[k].id=-1 then continue;
       for z:=k+1 to length(ar_struct)-1 do
       begin
         if ar_struct[z].id=-1 then continue;

         if ((ar_struct[k].typ<3)and(ar_struct[z].typ<3)and(ar_struct[k].typ<>ar_struct[k].typ))or
         ((ar_struct[k].typ=3)and(ar_struct[z].typ=2))or
         ((ar_struct[k].typ=4)and(ar_struct[z].typ=0))or
         ((ar_struct[z].typ=3)and(ar_struct[k].typ=2))or
         ((ar_struct[z].typ=4)and(ar_struct[k].typ=0)) then continue;

         if ((ar_struct[k].otx>ar_struct[z].otx)and(ar_struct[k].otx<ar_struct[z].dox)and(ar_struct[k].otz>ar_struct[z].otz)and(ar_struct[k].otz<ar_struct[z].doz))or
         ((ar_struct[k].otx>ar_struct[z].otx)and(ar_struct[k].otx<ar_struct[z].dox)and(ar_struct[k].doz>ar_struct[z].otz)and(ar_struct[k].doz<ar_struct[z].doz))or
         ((ar_struct[k].dox>ar_struct[z].otx)and(ar_struct[k].dox<ar_struct[z].dox)and(ar_struct[k].otz>ar_struct[z].otz)and(ar_struct[k].otz<ar_struct[z].doz))or
         ((ar_struct[k].dox>ar_struct[z].otx)and(ar_struct[k].dox<ar_struct[z].dox)and(ar_struct[k].doz>ar_struct[z].otz)and(ar_struct[k].doz<ar_struct[z].doz)) then
           //potom uchitivat' bolee bol'shie postroyki
           if random>0.5 then
             ar_struct[k].id:=-1
           else
             ar_struct[z].id:=-1;
       end;
     end;

     //udalaem oblasti
     k:=0;
     repeat
       if ar_struct[k].id=-1 then
       begin
         if k<>(length(ar_struct)-1) then
           move(ar_struct[k+1],ar_struct[k],(length(ar_struct)-k-1)*sizeof(tparam_structure));
         setlength(ar_struct,length(ar_struct)-1);
       end
       else
         inc(k);
      until k>(length(ar_struct)-1);

  //opredelaem prinadlezhnost' oblastey opredelennim chankam
  //+ generim chanki i peredaem eto na obrabotku
    for k:=0 to length(ar_struct)-1 do
    begin
      //opredelaem kraynie koordinati po dvum osam
      tempx:=ar_struct[k].otx;
      tempk:=ar_struct[k].dox;
      tempy:=ar_struct[k].otz;
      tempz:=ar_struct[k].doz;

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
      if (tempx<=0)and((ar_struct[k].otx)<0) then tempx:=tempx-1;
      if (tempk<=0)and((ar_struct[k].dox)<0) then tempk:=tempk-1;
      if (tempy<=0)and((ar_struct[k].otz)<0) then tempy:=tempy-1;
      if (tempz<=0)and((ar_struct[k].doz)<0) then tempz:=tempz-1;

      //videlaem pamat'
      setlength(ar_struct[k].chunks,(tempk-tempx+1)*(tempz-tempy+1));

      //zapisivaem
      z:=0;
      for i:=tempx to tempk do
        for j:=tempy to tempz do
        begin
          ar_struct[k].chunks[z].x:=i;
          ar_struct[k].chunks[z].y:=j;
          inc(z);
        end;

      //ochishaem kartu
      for i:=0 to 35 do
        for j:=0 to 35 do
        begin
          zeromemory(map[i][j].blocks,length(map[i][j].blocks));
          zeromemory(map[i][j].data,length(map[i][j].data));
          zeromemory(map[i][j].heightmap,length(map[i][j].heightmap));
        end;

      //generiruem chanki
      for i:=0 to tempk-tempx do
        for j:=0 to tempz-tempy do
        begin
          //gen_sphere(tempx-2,tempy-2,map[k][z].blocks,arobsh,par.planet_par^.groundlevel,par.planet_par^.map_type);
          gen_flat_surf(tempx+i,tempy+j,par.flatmap_par^,par.border_par^,map[i][j].blocks,map[i][j].data);
          gen_border(tempx+i,tempy+j,par.tox-par.fromx+1,par.toy-par.fromy+1,par.border_par^,map[i][j].blocks,map[i][j].data,nil,nil);

          //generim heightmap
          calc_heightmap(map[i][j].blocks,map[i][j].heightmap);
        end;

      //vizivaem proceduru opredeleniya polozheniya postroek
      calc_polozh(map,ar_struct[k]);
    end;

  //opredelaem peresechenie postroek
  //uzhe dolzhni bit' 3D koordinati
    for k:=0 to length(ar_struct)-2 do
    begin
      if ar_struct[k].id=-1 then continue;
      for z:=k+1 to length(ar_struct)-1 do
      begin
        if ar_struct[z].id=-1 then continue;
        if ((ar_struct[k].otx>ar_struct[z].otx)and(ar_struct[k].otx<ar_struct[z].dox)and(ar_struct[k].otz>ar_struct[z].otz)and(ar_struct[k].otz<ar_struct[z].doz)and(ar_struct[k].doy>ar_struct[z].oty)and(ar_struct[k].doy<ar_struct[z].doy))or
        ((ar_struct[k].otx>ar_struct[z].otx)and(ar_struct[k].otx<ar_struct[z].dox)and(ar_struct[k].doz>ar_struct[z].otz)and(ar_struct[k].doz<ar_struct[z].doz)and(ar_struct[k].doy>ar_struct[z].oty)and(ar_struct[k].doy<ar_struct[z].doy))or
        ((ar_struct[k].dox>ar_struct[z].otx)and(ar_struct[k].dox<ar_struct[z].dox)and(ar_struct[k].otz>ar_struct[z].otz)and(ar_struct[k].otz<ar_struct[z].doz)and(ar_struct[k].doy>ar_struct[z].oty)and(ar_struct[k].doy<ar_struct[z].doy))or
        ((ar_struct[k].dox>ar_struct[z].otx)and(ar_struct[k].dox<ar_struct[z].dox)and(ar_struct[k].doz>ar_struct[z].otz)and(ar_struct[k].doz<ar_struct[z].doz)and(ar_struct[k].doy>ar_struct[z].oty)and(ar_struct[k].doy<ar_struct[z].doy))or
        ((ar_struct[k].otx>ar_struct[z].otx)and(ar_struct[k].otx<ar_struct[z].dox)and(ar_struct[k].otz>ar_struct[z].otz)and(ar_struct[k].otz<ar_struct[z].doz)and(ar_struct[k].oty>ar_struct[z].oty)and(ar_struct[k].oty<ar_struct[z].doy))or
        ((ar_struct[k].otx>ar_struct[z].otx)and(ar_struct[k].otx<ar_struct[z].dox)and(ar_struct[k].doz>ar_struct[z].otz)and(ar_struct[k].doz<ar_struct[z].doz)and(ar_struct[k].oty>ar_struct[z].oty)and(ar_struct[k].oty<ar_struct[z].doy))or
        ((ar_struct[k].dox>ar_struct[z].otx)and(ar_struct[k].dox<ar_struct[z].dox)and(ar_struct[k].otz>ar_struct[z].otz)and(ar_struct[k].otz<ar_struct[z].doz)and(ar_struct[k].oty>ar_struct[z].oty)and(ar_struct[k].oty<ar_struct[z].doy))or
        ((ar_struct[k].dox>ar_struct[z].otx)and(ar_struct[k].dox<ar_struct[z].dox)and(ar_struct[k].doz>ar_struct[z].otz)and(ar_struct[k].doz<ar_struct[z].doz)and(ar_struct[k].oty>ar_struct[z].oty)and(ar_struct[k].oty<ar_struct[z].doy)) then
        if random>0.5 then
          ar_struct[k].id:=-1
        else
          ar_struct[z].id:=-1
      end;
    end;

    //udalaem oblasti
     k:=0;
     repeat
      if ar_struct[k].id=-1 then
      begin
        setlength(ar_struct[k].chunks,0);
        if k<>(length(ar_struct)-1) then
          move(ar_struct[k+1],ar_struct[k],(length(ar_struct)-k-1)*sizeof(tparam_structure));
        setlength(ar_struct,length(ar_struct)-1);
      end
      else
        inc(k);
     until k>(length(ar_struct)-1);

     //schitaem opat' k kakim chankam otnosatsa postroyki
     for k:=0 to length(ar_struct)-1 do
    begin
      //opredelaem kraynie koordinati po dvum osam
      tempx:=ar_struct[k].otx;
      tempk:=ar_struct[k].dox;
      tempy:=ar_struct[k].otz;
      tempz:=ar_struct[k].doz;

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
      if (tempx<=0)and((ar_struct[k].otx)<0) then tempx:=tempx-1;
      if (tempk<=0)and((ar_struct[k].dox)<0) then tempk:=tempk-1;
      if (tempy<=0)and((ar_struct[k].otz)<0) then tempy:=tempy-1;
      if (tempz<=0)and((ar_struct[k].doz)<0) then tempz:=tempz-1;

      //videlaem pamat'
      setlength(ar_struct[k].chunks,(tempk-tempx+1)*(tempz-tempy+1));

      //zapisivaem
      z:=0;
      for i:=tempx to tempk do
        for j:=tempy to tempz do
        begin
          ar_struct[k].chunks[z].x:=i;
          ar_struct[k].chunks[z].y:=j;
          inc(z);
        end;

      end;

    end;
  end;


  postmessage(par.handle,WM_USER+300,1,0);

  //ochishaem massiv dla zapisi v fayl na vsakiy sluchay
  setlength(fdata,0);

  //osnovnie cikli generacii
  for i:=regx_nach to regx_nach+regx-1 do
    for j:=regy_nach to regy_nach+regy-1 do
  //i:=0;
  //j:=0;
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

          //gen_sphere(tempx-2,tempy-2,map[k][z].blocks,arobsh,par.planet_par^.groundlevel,par.planet_par^.map_type);
          gen_flat_surf(tempx-2,tempy-2,par.flatmap_par^,par.border_par^,map[k][z].blocks,map[k][z].data);

          gen_border(tempx-2,tempy-2,par.tox-par.fromx+1,par.toy-par.fromy+1,par.border_par^,map[k][z].blocks,map[k][z].data,@map[k][z].entities,@map[k][z].tile_entities);

          //generim heightmap
          calc_heightmap(map[k][z].blocks,map[k][z].heightmap);

          //zapisivaem features
          //peredaem eshe koordinati regiona
          if loaded=true then
          begin
            gen_struct(ar_struct,tempx-2,tempy-2,par.flatmap_par^.len,par.flatmap_par^.width,nil,nil,0,map[k][z].blocks,map[k][z].data,map[k][z].heightmap,par.handle);
          end;
        end;

      //gen_krater(map,i,j);

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


          (*if (tempx=0)and(tempy=0) then
          begin
            //entities
            setlength(map[k+2][z+2].entities,1);
            //for tempz:=0 to 49 do
            tempz:=0;
            begin
            map[k+2][z+2].entities[tempz].id:='Zombie';
            map[k+2][z+2].entities[tempz].pos[0]:=10.5;
            map[k+2][z+2].entities[tempz].pos[1]:=1;
            map[k+2][z+2].entities[tempz].pos[2]:=10.5;
            map[k+2][z+2].entities[tempz].motion[0]:=0;
            map[k+2][z+2].entities[tempz].motion[1]:=0;
            map[k+2][z+2].entities[tempz].motion[2]:=0;
            map[k+2][z+2].entities[tempz].on_ground:=true;
            map[k+2][z+2].entities[tempz].fire:=-1;
            map[k+2][z+2].entities[tempz].fall_distanse:=0;
            map[k+2][z+2].entities[tempz].air:=300;
            map[k+2][z+2].entities[tempz].rotation[0]:=0;
            map[k+2][z+2].entities[tempz].rotation[1]:=0;
            new(pmobs_entity_data(map[k+2][z+2].entities[tempz].dannie));
            pmobs_entity_data(map[k+2][z+2].entities[tempz].dannie)^.attack_time:=0;
            pmobs_entity_data(map[k+2][z+2].entities[tempz].dannie)^.death_time:=0;
            pmobs_entity_data(map[k+2][z+2].entities[tempz].dannie)^.health:=20;
            pmobs_entity_data(map[k+2][z+2].entities[tempz].dannie)^.hurt_time:=0;
            pmobs_entity_data(map[k+2][z+2].entities[tempz].dannie)^.powered:=true;
            end;
            //map[k+2][z+2].blocks[59+(10*128+(10*2048))]:=61;

            setlength(map[k+2][z+2].tile_entities,2);
            //Furnace
            map[k+2][z+2].tile_entities[0].id:='Furnace';
            map[k+2][z+2].tile_entities[0].x:=5;
            map[k+2][z+2].tile_entities[0].y:=1;
            map[k+2][z+2].tile_entities[0].z:=5;
            new(pfurnace_tile_entity_data(map[k+2][z+2].tile_entities[0].dannie));
            setlength(pfurnace_tile_entity_data(map[k+2][z+2].tile_entities[0].dannie)^.items,1);
            pfurnace_tile_entity_data(map[k+2][z+2].tile_entities[0].dannie)^.burn_time:=50;
            pfurnace_tile_entity_data(map[k+2][z+2].tile_entities[0].dannie)^.cook_time:=40;
            pfurnace_tile_entity_data(map[k+2][z+2].tile_entities[0].dannie)^.items[0].id:=54;
            pfurnace_tile_entity_data(map[k+2][z+2].tile_entities[0].dannie)^.items[0].count:=5;
            map[k+2][z+2].blocks[1+(5*128+(5*2048))]:=61;
           //Jukebox
            map[k+2][z+2].tile_entities[1].id:='RecordPlayer';
            map[k+2][z+2].tile_entities[1].x:=1;
            map[k+2][z+2].tile_entities[1].y:=1;
            map[k+2][z+2].tile_entities[1].z:=1;
            new(pjukebox_tile_entity_data(map[k+2][z+2].tile_entities[1].dannie));
            pjukebox_tile_entity_data(map[k+2][z+2].tile_entities[1].dannie)^.rec:=303;
            map[k+2][z+2].blocks[1+(1*128+(1*2048))]:=84;
            map[k+2][z+2].data[1+(1*128+(1*2048))]:=1;

            nbtcompress2(tempx,tempy,map[k+2][z+2].blocks,map[k+2][z+2].data,map[k+2][z+2].skylight,map[k+2][z+2].light,map[k+2][z+2].heightmap,map[k+2][z+2].entities,map[k+2][z+2].tile_entities,true,@rez);
          end; *)
          

            nbtcompress2(tempx,tempy,map[k+2][z+2].blocks,map[k+2][z+2].data,map[k+2][z+2].skylight,map[k+2][z+2].light,map[k+2][z+2].heightmap,map[k+2][z+2].entities,map[k+2][z+2].tile_entities,not(par.flatmap_par^.pop_chunks),@rez);
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

  postmessage(par.handle,WM_USER+301,par.id,0);
  endthread(0);
end;

end.

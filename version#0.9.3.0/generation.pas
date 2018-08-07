unit generation;

interface

uses mainf;

function init_thread(p:pointer):integer;
function wait_init_thread(p:pointer):integer;

implementation

uses Windows, SysUtils, NBT, zlibex, blocks_mct, types_mct;

type pgen_sett_thread_type = ^gen_sett_thread_type;
     gen_sett_thread_type = record
       fromx,fromy,tox,toy:integer;
       border_in,border_out:integer;
       thread_id:integer;
     end;

     gen_sett_thread_type_ar = array of gen_sett_thread_type;

var threads_sett:gen_sett_thread_type_ar;

//raschet heightmap regiona + raschet prisutstvuyushih sekciy v kazhdom chanke
procedure calc_heightmap(var map:region; otx,dox,oty,doy:integer);
var xk,zk,x,y,z,max,t:integer;
begin
  for xk:=otx to dox do
    for zk:=oty to doy do
    begin
      for x:=0 to 15 do
        map[xk][zk].sections[x]:=false;

      for x:=0 to 15 do
        for z:=0 to 15 do
        begin
          max:=0;
          for y:=255 downto 0 do
          begin
            t:=map[xk][zk].Blocks[x+z*16+y*256];
            if t<>0 then
            begin
              if (y+1)>max then max:=y+1;

              map[xk][zk].sections[y div 16]:=true;
            end;
          end;
          map[xk][zk].Heightmap[x+z*16]:=max;
        end;
    end; 
end;

procedure calc_skylight_test(var map:region; otx,dox,oty,doy:integer);
var xk,zk,x,y,z:integer;
begin
  for xk:=otx to dox do
    for zk:=oty to doy do
      for x:=0 to 15 do
        for z:=0 to 15 do
        begin
          for y:=0 to 255 do
          begin
            if map[xk][zk].Blocks[x+z*16+y*256]=0 then
              map[xk][zk].Skylight[x+z*16+y*256]:=15; 
          end;
        end;
end;

procedure calc_skylight(map:region; otx,dox,oty,doy:integer);
type logika_ar = array[0..15] of boolean;
logika_ar_line = array of logika_ar;
logika_ar_region = array of logika_ar_line;

var rx,ry:integer;
x,y,z,k:integer;
time:cardinal;
b,b1:boolean;
temp,temp_u,temp_d,temp_f,temp_b,temp_l,temp_r:byte;
max,max_old:smallint;
min_y,max_y,sect:integer;

svet_ar:logika_ar_region;
label nach;
begin
  //sozdaem massiv dla logiki sveta
  setlength(svet_ar,36);
  for x:=0 to length(svet_ar)-1 do
    setlength(svet_ar[x],36);

  //zapolnaem massiv logiki false
  for x:=0 to 35 do
    for y:=0 to 35 do
      for z:=0 to 15 do
        svet_ar[x][y][z]:=false;

  //zapolnaem nachalnie znacheniya skylight (verhniy sloy)
  for rx:=otx+1 to dox+3 do
    for ry:=oty+1 to doy+3 do
      if map[rx][ry].has_skylight=false then
      for x:=0 to 15 do
        for z:=0 to 15 do
        begin
          if (map[rx][ry].blocks[x+z*16+255*256] in trans_bl) then
            map[rx][ry].Skylight[x+z*16+255*256]:=15;

          //zapolnaem vse bloki, kotorie pramo pod solncem
          for y:=254 downto 0 do
          begin
            temp:=map[rx][ry].blocks[x+z*16+y*256];
            if (temp in trans_bl) then
            begin
              if (temp in diff_bl) then
              begin
                max:=0;
                for k:=0 to length(diffuse_ar)-1 do
                  if temp=diffuse_ar[k].id then
                  begin
                    max:=map[rx][ry].Skylight[x+z*16+(y+1)*256]-1-diffuse_ar[k].data;
                    break;
                  end;
                if max<0 then max:=0;
              end
              else max:=15;

              map[rx][ry].Skylight[x+z*16+y*256]:=max;

              svet_ar[rx][ry][(y shr 4)]:=true;

              if max<>15 then break;
            end
            else break;
          end;
        end;

nach:
  time:=getcurrenttime;
  main.Memo1.Lines.Add('Nachalo rascheta sveta');
  //schitaem skylight
  b:=false;
  for rx:=otx+1 to dox+3 do    //Xch
    for ry:=oty+1 to doy+3 do  //Ych
    begin
      if (map[rx][ry].has_skylight=false)and(map[rx][ry].raschet_skylight=true) then
          for sect:=15 downto 0 do    //obrabativaem tolko suchestvuyushie sekcii
          begin
            if (map[rx][ry].sections[sect]=true)or(svet_ar[rx][ry][sect]=true) then
            //if true then
            begin
              min_y:=sect*16;
              if sect<>15 then max_y:=(sect+1)*16-1
              else max_y:=(sect+1)*16-2;
            end
            else
            begin
              min_y:=10;
              max_y:=8;
            end;

            for y:=max_y downto min_y do    //Y
            for z:=0 to 15 do     //Z
            for x:=0 to 15 do      //X
            begin
              temp:=map[rx][ry].blocks[x+z*16+y*256];
              if (temp in trans_bl) then
              begin
                max:=map[rx][ry].Skylight[x+z*16+y*256];
                max_old:=max;
                //po X+
                if x<>15 then
                  temp_r:=map[rx][ry].Skylight[x+1+z*16+y*256]
                else
                  temp_r:=map[rx+1][ry].Skylight[z*16+y*256];

                //po X-
                if x<>0 then
                  temp_l:=map[rx][ry].Skylight[x-1+z*16+y*256]
                else
                  temp_l:=map[rx-1][ry].Skylight[15+z*16+y*256];

                //po Z+
                if z<>15 then
                  temp_f:=map[rx][ry].Skylight[x+(z+1)*16+y*256]
                else
                  temp_f:=map[rx][ry+1].Skylight[x+y*256];

                //po Z-
                if z<>0 then
                  temp_b:=map[rx][ry].Skylight[x+(z-1)*16+y*256]
                else
                  temp_b:=map[rx][ry-1].Skylight[x+15*16+y*256];

                //po Y
                temp_u:=map[rx][ry].Skylight[x+z*16+(y+1)*256];
                if y<>0 then
                  temp_d:=map[rx][ry].Skylight[x+z*16+(y-1)*256]
                else temp_d:=0;

                if (temp_l-1)>max then max:=temp_l-1;
                if (temp_r-1)>max then max:=temp_r-1;
                if (temp_f-1)>max then max:=temp_f-1;
                if (temp_b-1)>max then max:=temp_b-1;
                if (temp_u-1)>max then max:=temp_u-1;
                if (temp_d-1)>max then max:=temp_d-1;

                //popravka na diffuse block
                if (temp in diff_bl) then
                  for k:=0 to length(diffuse_ar)-1 do
                    if temp=diffuse_ar[k].id then
                    begin
                      dec(max,diffuse_ar[k].data);
                      //if max>(diffuse_ar[k].data) then dec(max,diffuse_ar[k].data)
                      //else max:=0;
                      if max<0 then max:=0;
                      break;
                    end;

                if max_old<max then
                begin
                  map[rx][ry].Skylight[x+z*16+y*256]:=max;
                  b:=true;
                end;
              end;
            end;
          end;
    end;


  for rx:=dox+3 downto otx+1 do    //Xch
    for ry:=doy+3 downto oty+1 do  //Ych
    begin
      b1:=false;
      if (map[rx][ry].has_skylight=false)and(map[rx][ry].raschet_skylight=true) then
          for sect:=0 to 15 do       //obrabativaem tolko suchestvuyushie sekcii
          begin
            if (map[rx][ry].sections[sect]=true)or(svet_ar[rx][ry][sect]=true) then
            //if true then
            begin
              min_y:=sect*16;
              if sect<>15 then max_y:=(sect+1)*16-1
              else max_y:=(sect+1)*16-2;
            end
            else
            begin
              min_y:=10;
              max_y:=8;
            end;

            for y:=min_y to max_y do    //Y
            for z:=15 downto 0 do     //Z
            for x:=15 downto 0 do      //X
            begin
              temp:=map[rx][ry].blocks[x+z*16+y*256];
              if (temp in trans_bl) then
              begin
                max:=map[rx][ry].Skylight[x+z*16+y*256];
                max_old:=max;
                //po X+
                if x<>15 then
                  temp_r:=map[rx][ry].Skylight[x+1+z*16+y*256]
                else
                  temp_r:=map[rx+1][ry].Skylight[z*16+y*256];

                //po X-
                if x<>0 then
                  temp_l:=map[rx][ry].Skylight[x-1+z*16+y*256]
                else
                  temp_l:=map[rx-1][ry].Skylight[15+z*16+y*256];

                //po Z+
                if z<>15 then
                  temp_f:=map[rx][ry].Skylight[x+(z+1)*16+y*256]
                else
                  temp_f:=map[rx][ry+1].Skylight[x+y*256];

                //po Z-
                if z<>0 then
                  temp_b:=map[rx][ry].Skylight[x+(z-1)*16+y*256]
                else
                  temp_b:=map[rx][ry-1].Skylight[x+15*16+y*256];

                //po Y
                temp_u:=map[rx][ry].Skylight[x+z*16+(y+1)*256];
                if y<>0 then
                  temp_d:=map[rx][ry].Skylight[x+z*16+(y-1)*256]
                else temp_d:=0;

                if (temp_l-1)>max then max:=temp_l-1;
                if (temp_r-1)>max then max:=temp_r-1;
                if (temp_f-1)>max then max:=temp_f-1;
                if (temp_b-1)>max then max:=temp_b-1;
                if (temp_u-1)>max then max:=temp_u-1;
                if (temp_d-1)>max then max:=temp_d-1;

                //popravka na vodu
                if (temp in diff_bl) then
                  for k:=0 to length(diffuse_ar)-1 do
                    if temp=diffuse_ar[k].id then
                    begin
                      dec(max,diffuse_ar[k].data);
                      //if max>(diffuse_ar[k].data) then dec(max,diffuse_ar[k].data)
                      //else max:=0;
                      if max<0 then max:=0;
                      break;
                    end;    

                if max_old<max then
                begin
                  map[rx][ry].Skylight[x+z*16+y*256]:=max;
                  b:=true;
                  b1:=true;
                end;
              end;
            end;   
          end;
      if b1=false then map[rx][ry].raschet_skylight:=false;
    end;

  time:=getcurrenttime-time;

  main.Memo1.Lines.Add('Konec rascheta sveta so vremenem: '+inttostr(time)+'ms');

  if b=true then goto nach;

  //udalaem massiv dla logiki sveta
  for x:=0 to length(svet_ar)-1 do
    setlength(svet_ar[x],0);
  setlength(svet_ar,0);   
end;

procedure calc_blocklight(map:region; otx,dox,oty,doy:integer);
var rx,ry,x,y,z,temp,k,k1:integer;
max_y,min_y,sect:integer;
li:shortint;

  procedure recur2(svet:shortint;var map:region;rx,ry,x,z,y:byte);
  var kk:byte;
  begin
    k1:=map[rx][ry].blocks[x+z*16+y*256];
    if (k1 in diff_bl) then
      for kk:=0 to length(diffuse_ar)-1 do
        if diffuse_ar[kk].id=k1 then
        begin
          svet:=svet-diffuse_ar[kk].data;
          break;
        end;
    //svet:=svet-2;
    if svet<0 then svet:=0;

    map[rx][ry].light[x+z*16+y*256]:=svet;

    if svet<=1 then exit;

    //idem vverh
    if y<255 then
      if (map[rx][ry].blocks[x+z*16+(y+1)*256] in trans_bl)and
      (map[rx][ry].light[x+z*16+(y+1)*256]<(svet-1)) then
        recur2(svet-1,map,rx,ry,x,z,y+1);

    //idem vniz
    if y>0 then
      if (map[rx][ry].blocks[x+z*16+(y-1)*256] in trans_bl)and
      (map[rx][ry].light[x+z*16+(y-1)*256]<(svet-1))then
        recur2(svet-1,map,rx,ry,x,z,y-1);

    //idem vlevo
    if x=0 then  //granica chanka
    begin
      if (map[rx-1][ry].blocks[15+z*16+y*256] in trans_bl)and
      (map[rx-1][ry].light[15+z*16+y*256]<(svet-1)) then
        recur2(svet-1,map,rx-1,ry,15,z,y);
    end
    else
      if (map[rx][ry].blocks[x-1+z*16+y*256] in trans_bl)and
      (map[rx][ry].light[x-1+z*16+y*256]<(svet-1)) then
        recur2(svet-1,map,rx,ry,x-1,z,y);

    //idem vpravo
    if x=15 then
    begin
      if (map[rx+1][ry].blocks[z*16+y*256] in trans_bl)and
      (map[rx+1][ry].light[z*16+y*256]<(svet-1)) then
        recur2(svet-1,map,rx+1,ry,0,z,y);
    end
    else
      if (map[rx][ry].blocks[x+1+z*16+y*256] in trans_bl)and
      (map[rx][ry].light[x+1+z*16+y*256]<(svet-1))then
        recur2(svet-1,map,rx,ry,x+1,z,y);

    //idem vpered
    if z=15 then
    begin
      if (map[rx][ry+1].blocks[x+y*256] in trans_bl)and
      (map[rx][ry+1].light[x+y*256]<(svet-1))then
        recur2(svet-1,map,rx,ry+1,x,0,y);
    end
    else
      if (map[rx][ry].blocks[x+(z+1)*16+y*256] in trans_bl)and
      (map[rx][ry].light[x+(z+1)*16+y*256]<(svet-1))then
        recur2(svet-1,map,rx,ry,x,z+1,y);

    //idem nazad
    if z=0 then
    begin
      if (map[rx][ry-1].blocks[x+15*16+y*256] in trans_bl)and
      (map[rx][ry-1].light[x+15*16+y*256]<(svet-1))then
        recur2(svet-1,map,rx,ry-1,x,15,y);
    end
    else
      if (map[rx][ry].blocks[x+(z-1)*16+y*256] in trans_bl)and
      (map[rx][ry].light[x+(z-1)*16+y*256]<(svet-1)) then
        recur2(svet-1,map,rx,ry,x,z-1,y);
  end;

begin    
  for rx:=otx+1 to dox+3 do    //Xch
    for ry:=oty+1 to doy+3 do  //Ych
    begin
      if (map[rx][ry].has_blocklight=false) then
      for z:=0 to 15 do     //Z
        for x:=0 to 15 do      //X
          for sect:=0 to 15 do
          begin
            if map[rx][ry].sections[sect]=true then
            begin
              min_y:=sect*16;
              max_y:=(sect+1)*16-1;
            end
            else
            begin
              min_y:=10;
              max_y:=8;
            end;

            for y:=max_y downto min_y do    //Y
            begin
              temp:=map[rx][ry].blocks[x+z*16+y*256];
              {case temp of
                89,10,11,51,91,95:li:=15;
                50,62:li:=14;
                90:li:=11;
                74:li:=9;
                76,94:li:=7;
                39:li:=1
                else li:=0;
              end;   }
              li:=0;
              if (temp in light_bl) then
                for k:=0 to length(light_ar)-1 do
                  if light_ar[k].id=temp then
                  begin
                    li:=light_ar[k].data;
                    break;
                  end;

              if map[rx][ry].light[x+z*16+y*256]>=li then continue;

              recur2(li,map,rx,ry,x,z,y);
            end;
          end;
    end;
end;

procedure clear_all_entities(entities:par_entity_type; tentities:par_tile_entity_type);
var i,j:integer;
begin
  //ochishaem entities
  if length(entities^)<>0 then
  begin
  end;

  //ochishaem tile_entities
  if length(tentities^)<>0 then
  begin
    for i:=0 to length(tentities^)-1 do
    begin
      if (tentities^[i].id='Furnace') then
      begin
        setlength(pfurnace_tile_entity_data(tentities^[i].data)^.items,0);
        dispose(pfurnace_tile_entity_data(tentities^[i].data));
      end
      else if (tentities^[i].id='Sign') then
      begin
        for j:=1 to 4 do psign_tile_entity_data(tentities^[i].data)^.text[j]:='';
        dispose(psign_tile_entity_data(tentities^[i].data));
      end
      else if (tentities^[i].id='MobSpawner') then
      begin
        pmon_spawn_tile_entity_data(tentities^[i].data)^.entityid:='';
        dispose(pmon_spawn_tile_entity_data(tentities^[i].data));
      end
      else if (tentities^[i].id='Chest') then
      begin
        setlength(pchest_tile_entity_data(tentities^[i].data)^.items,0);
        dispose(pchest_tile_entity_data(tentities^[i].data));
      end
      else if (tentities^[i].id='Music') then dispose(pnote_tile_entity_data(tentities^[i].data))
      else if (tentities^[i].id='Trap') then
      begin
        setlength(pdispenser_tile_entity_data(tentities^[i].data)^.items,0);
        dispose(pdispenser_tile_entity_data(tentities^[i].data));
      end
      else if (tentities^[i].id='RecordPlayer') then dispose(pjukebox_tile_entity_data(tentities^[i].data));

      tentities^[i].data:=nil;
      tentities^[i].Id:='';
    end;
    setlength(tentities^,0);
  end;
end;

function gen_thread(p:pointer):integer;
type TInt_ar = array[0..3] of byte;

var par:gen_sett_thread_type;
thread_sett_point:pgen_sett_thread_type;
i,j,k,z,t1:integer;
tempx,tempy,tempk,tempz:integer;
regx,regy:integer;   //kol-vo region faylov
regx_nach,regy_nach:integer;  //nachalniy region (menshiy), s kotorogo nachinaetsa generaciya
otx,dox,oty,doy:integer;   //granici chankov
map:region;
chunk_plug:TGen_Chunk;
head:mcheader;
rez:byte_ar;
fdata:byte_ar;

authed:boolean;
pop_chunks:boolean;

time_sch:cardinal;

mess,rez_c:pchar;

int_ar:TInt_ar;
p_int:^integer;

kolich:integer;  //kolichestvo sgenerirovannih chankov
id_reg:integer;
hndl:cardinal;
count:dword;

  procedure clear_dynamic;
  var ii,jj:integer;
  begin
    for ii:=0 to length(map)-1 do
      for jj:=0 to length(map[ii])-1 do
      begin
        setlength(map[ii][jj].Biomes,0);
        setlength(map[ii][jj].Blocks,0);
        setlength(map[ii][jj].Data,0);
        setlength(map[ii][jj].Light,0);
        setlength(map[ii][jj].Skylight,0);
        setlength(map[ii][jj].Heightmap,0);
        setlength(map[ii][jj].Add_id,0);
        //clear_entities
        clear_all_entities(@map[ii][jj].entities,@map[ii][jj].tile_entities);
        setlength(map[ii][jj].Entities,0);
        setlength(map[ii][jj].Tile_entities,0);
      end; 

    for ii:=0 to length(map)-1 do
      setlength(map[ii],0);
    setlength(map,0);

    setlength(chunk_plug.Biomes,0);
    setlength(chunk_plug.Blocks,0);
    setlength(chunk_plug.Data,0);
    setlength(chunk_plug.Add_id,0);
    setlength(chunk_plug.Skylight,0);
    setlength(chunk_plug.Light,0);
    //clear_entities
    clear_all_entities(@chunk_plug.entities,@chunk_plug.tile_entities);
    setlength(chunk_plug.Entities,0);
    setlength(chunk_plug.Tile_entities,0);

    setlength(rez,0);
    setlength(fdata,0);

    mess:='';
  end;

  procedure check_stopped;
  begin
    if gen_stopped then
    begin
      clear_dynamic;
      closehandle(hndl);

      main.Memo1.Lines.Add('Thread number '+inttostr(par.thread_id)+' stopping, because of the cancel');

      endthread(2);
    end;
  end;

begin
  thread_sett_point:=p;
  par:=thread_sett_point^;

  //inicializaciya ukazatela i massiva dla kompresii
  p_int:=@int_ar;

  main.Memo1.Lines.Add('Thread number '+inttostr(par.thread_id)+' starting');

  check_stopped;
  //perenosim populate chunks
  pop_chunks:=generation_settings.Populate_chunks;

  //schitaem obshee kol-vo chankov
  tempx:=(par.tox-par.fromx+1)+par.border_out*2;      //kol-vo chankov po osam
  tempy:=(par.toy-par.fromy+1)+par.border_out*2;
  //i:=(par.tox-par.fromx+1)*(par.toy-par.fromy+1);
  i:=tempx*tempy;

  postmessage(main.Handle,WM_USER+307,0,i);

  //izmenaem maksimum progressbara
  postmessage(main.Handle,WM_USER+302,i,0);

  //izmenaem leybli
  mess:=pchar('Generating chunk');
  postmessage(main.Handle,WM_USER+305,integer(mess),1);
  mess:='0';
  postmessage(main.Handle,WM_USER+305,integer(mess),2);
  mess:=pchar('out of '+inttostr(i));
  postmessage(main.Handle,WM_USER+305,integer(mess),3);

  //videlenie pamati pod kartu
  setlength(map,36);
  for i:=0 to 35 do
    setlength(map[i],36);

  check_stopped;

  for i:=0 to 35 do
    for j:=0 to 35 do
    begin
      setlength(map[i][j].Biomes,256);
      setlength(map[i][j].blocks,65536);
      setlength(map[i][j].data,65536);
      check_stopped;
      setlength(map[i][j].light,65536);
      setlength(map[i][j].skylight,65536);
      setlength(map[i][j].heightmap,256);
      setlength(map[i][j].Add_id,0);
      setlength(map[i][j].Entities,0);
      setlength(map[i][j].Tile_Entities,0);
    end;

  check_stopped;
  //opredelaem kol-vo region faylov, kotoroe sozdavat
  //uznaem, skol'ko chetvertey nam dali v potok dla obrabotki
  id_reg:=0;
  k:=par.thread_id;
  for j:=1 to 4 do
  begin
    if (k and 1)=1 then inc(id_reg);
    k:=k shr 1;
  end;

  check_stopped;
  //vichislaem kol-vo region faylov i nachalo otscheta regionov
  //po osi X
  case id_reg of
  1,2:begin
        regx:= tempx div 32;
        if (tempx mod 32)<>0 then inc(regx);
        if par.fromx<0 then regx_nach:=-regx
        else regx_nach:=0;
      end;
  4:begin
      regx:=(tempx div 2) div 32;
      if ((tempx div 2) mod 32)<>0 then inc(regx);
      regx_nach:=-regx;
      regx:=regx*2;
    end;
  end;
  //po osi Y
  case id_reg of
  1:begin
      regy:= tempy div 32;
      if (tempy mod 32)<>0 then inc(regy);
      if par.fromy<0 then regy_nach:=-regy
      else regy_nach:=0;
    end;
  2,4:begin
        regy:=(tempy div 2) div 32;
        if ((tempy div 2) mod 32)<>0 then inc(regy);
        regy_nach:=-regy;
        regy:=regy*2;
      end;
  end;

  check_stopped;
  //peredaem dannie dla loga
  postmessage(main.Handle,WM_USER+307,1,regx_nach);
  postmessage(main.Handle,WM_USER+307,2,regx);
  postmessage(main.Handle,WM_USER+307,3,regy_nach);
  postmessage(main.Handle,WM_USER+307,4,regy);

  //perenosim priznak avtorizacii
  authed:=landscape_plugins[land_sel].auth;

  //obnulaem kol-vo chankov
  kolich:=0;


  //test
  i:=GetThreadPriority(getcurrentthread);
  case i of
    THREAD_PRIORITY_ABOVE_NORMAL:main.Memo1.Lines.Add('Thread priority above normal:'+inttostr(i));
    THREAD_PRIORITY_BELOW_NORMAL:main.Memo1.Lines.Add('Thread priority below normal:'+inttostr(i));
    THREAD_PRIORITY_HIGHEST:main.Memo1.Lines.Add('Thread priority highest:'+inttostr(i));
    THREAD_PRIORITY_IDLE:main.Memo1.Lines.Add('Thread priority IDLE:'+inttostr(i));
    THREAD_PRIORITY_LOWEST:main.Memo1.Lines.Add('Thread priority lowest:'+inttostr(i));
    THREAD_PRIORITY_NORMAL:main.Memo1.Lines.Add('Thread priority normal:'+inttostr(i));
    THREAD_PRIORITY_TIME_CRITICAL:main.Memo1.Lines.Add('Thread priority time critical:'+inttostr(i));
    else
      main.Memo1.Lines.Add('Unknown priority:'+inttostr(i));
  end;
  

  //osnovnie cikli po regionam
  for i:=regx_nach to regx_nach+regx-1 do
    for j:=regy_nach to regy_nach+regy-1 do
  //i:=0;
  //j:=0;
    begin
      check_stopped;

      //peredaem soobshenie o generacii regiona
      mess:=pchar('Generating blocks for region '+inttostr(i)+','+inttostr(j));
      postmessage(main.Handle,WM_USER+305,integer(mess),4);

      //opredelaem nachalnie i konechnie chanki
      k:=1;
      if (i<0)and(j>=0) then k:=2
      else if (i<0)and(j<0) then k:=4
      else if (i>=0)and(j<0) then k:=3;

      if k=1 then
      begin
        //po osi X
        if i=regx_nach+regx-1 then
        begin
          otx:=0;
          dox:=(par.tox+par.border_out) mod 32;
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
          doy:=(par.toy+par.border_out) mod 32;
        end
        else
        begin
          oty:=0;
          doy:=31;
        end;
      end;
      if k=2 then
      begin
        //po osi X
        if (i=regx_nach)and(((par.fromx-par.border_out) mod 32)<>0) then
        begin
          otx:=32+((par.fromx-par.border_out) mod 32);
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
          doy:=(par.toy+par.border_out) mod 32;
        end
        else
        begin
          oty:=0;
          doy:=31;
        end;
      end;
      if k=4 then
      begin
        //po osi X
        if (i=regx_nach)and(((par.fromx-par.border_out) mod 32)<>0) then
        begin
          otx:=32+((par.fromx-par.border_out) mod 32);
          dox:=31;
        end
        else
        begin
          otx:=0;
          dox:=31;
        end;
        //po osi Y
        if (j=regy_nach)and(((par.fromy-par.border_out) mod 32)<>0) then
        begin
          oty:=32+((par.fromy-par.border_out) mod 32);
          doy:=31;
        end
        else
        begin
          oty:=0;
          doy:=31;
        end;
      end;
      if k=3 then
      begin
        //po osi X
        if i=regx_nach+regx-1 then
        begin
          otx:=0;
          dox:=(par.tox+par.border_out) mod 32;
        end
        else
        begin
          otx:=0;
          dox:=31;
        end;
        //po osi Y
        if (j=regy_nach)and(((par.fromy-par.border_out) mod 32)<>0) then
        begin
          oty:=32+((par.fromy-par.border_out) mod 32);
          doy:=31;
        end
        else
        begin
          oty:=0;
          doy:=31;
        end;
      end;

      main.Memo1.Lines.Add('K='+inttostr(k)+'; otx='+inttostr(otx)+'; dox='+inttostr(dox));

      //ochishaem kartu
      for k:=0 to 35 do
        for z:=0 to 35 do
        begin
          zeromemory(map[k][z].Biomes,length(map[k][z].Biomes));
          zeromemory(map[k][z].blocks,length(map[k][z].blocks));
          zeromemory(map[k][z].data,length(map[k][z].data));
          check_stopped;
          zeromemory(map[k][z].light,length(map[k][z].light));
          zeromemory(map[k][z].skylight,length(map[k][z].skylight));
          zeromemory(map[k][z].heightmap,length(map[k][z].heightmap));
          clear_all_entities(@map[k][z].entities,@map[k][z].tile_entities);
          setlength(map[k][z].Add_id,0);
          map[k][z].Has_additional_id:=false;
          {for tempx:=0 to 15 do
            map[k][z].sections[tempx]:=false;  }
          zeromemory(@map[k][z].sections,sizeof(map[k][z].sections));
          map[k][z].has_skylight:=false;
          map[k][z].has_blocklight:=false;
          check_stopped;
        end;

      //ochishaem head
      zeromemory(@head,sizeof(head));

      //generiruem bloki
      for k:=otx to dox+4 do
        for z:=oty to doy+4 do
        begin
          check_stopped;

          tempx:=(i*32)+k-2; //??
          tempy:=(j*32)+z-2; //??

          if (tempx>=par.fromx)and(tempx<=par.tox)and(tempy>=par.fromy)and(tempy<=par.toy) then
          begin
            if authed then chunk_plug:=landscape_plugins[land_sel].gen_chunk2(i,j,tempx,tempy)
            else chunk_plug:=landscape_plugins[land_sel].gen_chunk(tempx,tempy);

            move(chunk_plug.Biomes[0],map[k][z].biomes[0],length(map[k][z].biomes));
            move(chunk_plug.blocks[0],map[k][z].blocks[0],length(map[k][z].blocks));
            move(chunk_plug.data[0],map[k][z].data[0],length(map[k][z].data));

            if (tempx=0)and(tempy=0) then
            begin
            {setlength(map[k][z].Tile_entities,1);

            map[k][z].blocks[2+2*16+65*256]:=117;
            map[k][z].data[2+2*16+65*256]:=7;
            map[k][z].Tile_entities[0].Id:='Cauldron';
            map[k][z].Tile_entities[0].x:=2;
            map[k][z].Tile_entities[0].y:=65;
            map[k][z].Tile_entities[0].z:=2;
            New(pcauldron_tile_entity_data(map[k][z].tile_entities[0].data));
            pcauldron_tile_entity_data(map[k][z].tile_entities[0].data)^.brew_time:=0;
            setlength(pcauldron_tile_entity_data(map[k][z].tile_entities[0].data)^.items,1);
            pcauldron_tile_entity_data(map[k][z].tile_entities[0].data)^.items[0].id:=374;
            pcauldron_tile_entity_data(map[k][z].tile_entities[0].data)^.items[0].damage:=0;
            pcauldron_tile_entity_data(map[k][z].tile_entities[0].data)^.items[0].count:=1;
            pcauldron_tile_entity_data(map[k][z].tile_entities[0].data)^.items[0].slot:=1;


            {map[k][z].blocks[7+7*16+65*256]:=84;
            map[k][z].data[7+7*16+65*256]:=1;
            map[k][z].Tile_entities[1].Id:='RecordPlayer';
            map[k][z].Tile_entities[1].x:=7;
            map[k][z].Tile_entities[1].y:=65;
            map[k][z].Tile_entities[1].z:=7;
            New(pjukebox_tile_entity_data(map[k][z].tile_entities[1].data));
            pjukebox_tile_entity_data(map[k][z].tile_entities[1].data)^.rec:=303;}
            end;

            //vistavlaem priznaki, chto nado raschet sveta
            map[k][z].raschet_skylight:=true;
          end;
        end;

      //post-obrabotka regiona
      landscape_plugins[land_sel].gen_region(i,j,map);

      if border_sel<>0 then
      begin
        //generaciya granici
        for k:=otx to dox+4 do
          for z:=oty to doy+4 do
          begin
            check_stopped;

            tempx:=(i*32)+k-2; //??
            tempy:=(j*32)+z-2; //??

            if not((par.border_in=0)and(par.border_out=0)) then
            begin   
              if ((tempx<=par.tox+par.border_out)and(tempx>par.tox-par.border_in)and(tempy<=par.toy+par.border_out)and(tempy>=par.fromy-par.border_out))or
              ((tempx>=par.fromx-par.border_out)and(tempx<par.fromx+par.border_in)and(tempy<=par.toy+par.border_out)and(tempy>=par.fromy-par.border_out))or
              ((tempy<=par.toy+par.border_out)and(tempy>par.toy-par.border_in)and(tempx<=par.tox+par.border_out)and(tempx>=par.fromx-par.border_out))or
              ((tempy>=par.fromy-par.border_out)and(tempy<par.fromy+par.border_in)and(tempx<=par.tox+par.border_out)and(tempx>=par.fromx-par.border_out)) then
              begin
                border_plugins[border_sel].get_chunk_add(tempx,tempy,map[k][z]);

                //vistavlaem priznaki, chto nado raschet sveta
                map[k][z].raschet_skylight:=true;
              end;
            end;
          end;

        //post obrabotka regiona granici karti
        border_plugins[border_sel].gen_region(i,j,map);
      end;

      //peredaem soobshenie o raschete karti visot
      mess:=pchar('Calculating heightmap for region '+inttostr(i)+','+inttostr(j));
      postmessage(main.Handle,WM_USER+305,integer(mess),4);

      //raschet heightmap
      calc_heightmap(map,otx,dox+4,oty,doy+4);

      check_stopped;
      //raschet sveta
      //peredaem soobshenie o raschete sveta
      mess:=pchar('Calculating light for region '+inttostr(i)+','+inttostr(j));
      postmessage(main.Handle,WM_USER+305,integer(mess),4);

      time_sch:=getcurrenttime;
      //calc_skylight_test(map,otx,dox+4,oty,doy+4);
      calc_skylight(map,otx,dox,oty,doy);
      check_stopped;
      calc_blocklight(map,otx,dox,oty,doy);
      check_stopped;

      time_sch:=getcurrenttime-time_sch;
      main.Memo1.Lines.Add('Overall time spend on light: '+inttostr(time_sch));

      //peredaem soobshenie o zapisi na disk
      mess:=pchar('Writing chunks for region '+inttostr(i)+','+inttostr(j));
      postmessage(main.Handle,WM_USER+305,integer(mess),4);

      tempk:=2;
      for k:=otx to dox do
        for z:=oty to doy do
        begin
          check_stopped;
          //komponovka v NBT
          tempx:=(i*32)+k; //??
          tempy:=(j*32)+z; //??  

          nbtcompress(tempx,tempy,pop_chunks,map[k+2][z+2],@rez);

          //szhimaem massiv
          zcompress(@rez[0],length(rez),pointer(rez_c),tempx);

          p_int^:=tempx+1;    //kol-vo skompressirovannih bayt, kotorie nado zapisat' pered dannimi v obshiy massiv

          tempy:=length(fdata);    //index i dlinna obshego massiva

          if ((tempx+5)and $FFF)=0 then tempz:=(5+tempx)
          else tempz:=(((5+tempx)shr 12)+1)*4096;   //v tempz hranitsa chislo, na kotoroe nuzhno uvelichit obshiy massiv

          setlength(fdata,tempy+tempz);

          for t1:=0 to 3 do
            fdata[tempy+3-t1]:=int_ar[t1];
          fdata[tempy+4]:=2;
          move(rez_c[0],fdata[tempy+5],tempx);

          freemem(rez_c,tempx);

          //izmenaem head
          tempx:=tempz div 4096;
          tempy:=0;
          tempy:=tempy or ((tempk and $FF)shl 16);
          tempy:=tempy or (tempk and $FF00);
          tempy:=tempy or ((tempx and $FF)shl 24);

          head.mclocations[(k+(z*32))+1]:=tempy;
          if tempx>1 then inc(tempk,tempx-1);  

          inc(tempk);

          inc(kolich);
          postmessage(main.Handle,WM_USER+303,kolich,0); //izmenaem progress bar
          postmessage(main.Handle,WM_USER+304,kolich,0); //izmenaem chislovuyu nadpis'
        end;

      hndl:=createfile(pchar('r.'+inttostr(i)+'.'+inttostr(j)+'.mca'),
      GENERIC_WRITE,
      0,
      nil,
      CREATE_ALWAYS,
      FILE_ATTRIBUTE_NORMAL,
      0);

      check_stopped;
      //zapis' zagolovka fayla
      writefile(hndl,head,sizeof(head),count,nil);

      check_stopped;
      //zapis' dannih
      writefile(hndl,fdata[0],length(fdata),count,nil);
      check_stopped;

      closehandle(hndl);

      setlength(fdata,0);
    end;

  clear_dynamic;

  main.Memo1.Lines.Add('Thread number '+inttostr(par.thread_id)+' stopping');

  endthread(2);
end;

function wait_init_thread(p:pointer):integer;
var i:integer;
id:cardinal;
str,str1:string;
begin
  main.Memo1.Lines.Add('Wait for initialization thread enter');

  //beginthread
  for i:=0 to length(init_threads)-1 do
    if init_threads[i]<>0 then
      waitforsingleobject(init_threads[i],infinite);

  for i:=0 to length(init_threads)-1 do
    if init_threads[i]<>0 then
    begin
      getexitcodethread(init_threads[i],id);
      main.Memo1.Lines.Add('Exit code of init thread #'+inttostr(i)+'='+inttostr(id));
      if id=5 then gen_stopped:=true;
    end;

  //izmenaem status generacii
  gen_status:=3;

  setlength(init_threads,0);

  if gen_stopped=true then
  begin
    if stop_thread_hndl=0 then
    begin
      main.Memo1.Lines.Add('Wait for initialization thread exit and stopping due to errors in plugin inicialization');
      stop_thread_hndl:=beginthread(nil,0,@stop_gen_thread,nil,0,id);
    end
    else
    begin
      main.Memo1.Lines.Add('Wait for initialization thread exit and stopping due to user');
      endthread(2);
    end;
  end;

  main.Memo1.Lines.Add('Wait for initialization thread exit');

  //ochishaem panel'
  postmessage(main.Handle,WM_USER+300,0,0);

  //sozdaem direkrotii
  str:=generation_settings.Path;
  str1:=generation_settings.Name;
  str:=str+str1;
  createdirectory(pchar(str),nil);
  str:=str+'\region';
  createdirectory(pchar(str),nil);

  //menaem tekushuyu direktoriyu
  SetCurrentDir(str);

  main.Memo1.Lines.Add('Border in='+inttostr(generation_settings.border_in));
  main.Memo1.Lines.Add('Border out='+inttostr(generation_settings.border_out));

  setlength(gen_threads,1);
  setlength(threads_sett,1);
  threads_sett[0].fromx:=-(generation_settings.Width div 2);
  threads_sett[0].fromy:=-(generation_settings.Length div 2);
  threads_sett[0].tox:=(generation_settings.Width div 2)-1;
  threads_sett[0].toy:=(generation_settings.Length div 2)-1;
  threads_sett[0].border_in:=generation_settings.border_in;
  threads_sett[0].border_out:=generation_settings.border_out;
  threads_sett[0].thread_id:=15;
  //threads_sett[0].thread_id:=4;
  {setlength(gen_threads,2);
  setlength(threads_sett,2);
  threads_sett[0].fromx:=-(generation_settings.Width div 2);
  threads_sett[0].fromy:=-(generation_settings.Length div 2);
  threads_sett[0].tox:=-1;
  threads_sett[0].toy:=(generation_settings.Length div 2)-1;
  threads_sett[0].thread_id:=12;
  threads_sett[1].fromx:=0;
  threads_sett[1].fromy:=-(generation_settings.Length div 2);
  threads_sett[1].tox:=(generation_settings.Width div 2)-1;
  threads_sett[1].toy:=(generation_settings.Length div 2)-1;
  threads_sett[1].thread_id:=3;  }
 { setlength(gen_threads,4);
  setlength(threads_sett,4);
  threads_sett[0].fromx:=-(generation_settings.Width div 2);
  threads_sett[0].fromy:=-(generation_settings.Length div 2);
  threads_sett[0].tox:=-1;
  threads_sett[0].toy:=-1;
  threads_sett[0].thread_id:=8;
  threads_sett[1].fromx:=0;
  threads_sett[1].fromy:=-(generation_settings.Length div 2);
  threads_sett[1].tox:=(generation_settings.Width div 2)-1;
  threads_sett[1].toy:=-1;
  threads_sett[1].thread_id:=4;
  threads_sett[2].fromx:=-(generation_settings.Width div 2);
  threads_sett[2].fromy:=0;
  threads_sett[2].tox:=-1;
  threads_sett[2].toy:=(generation_settings.Length div 2)-1;
  threads_sett[2].thread_id:=2;
  threads_sett[3].fromx:=0;
  threads_sett[3].fromy:=0;
  threads_sett[3].tox:=(generation_settings.Width div 2)-1;
  threads_sett[3].toy:=(generation_settings.Length div 2)-1;
  threads_sett[3].thread_id:=1; }

  Setpriorityclass(getcurrentprocess,HIGH_PRIORITY_CLASS);

  gen_threads[0]:=beginthread(nil,0,@gen_thread,@threads_sett[0],0,id);
  //gen_threads[1]:=beginthread(nil,0,@gen_thread,@threads_sett[1],0,id);
  //gen_threads[2]:=beginthread(nil,0,@gen_thread,@threads_sett[2],0,id);
  //gen_threads[3]:=beginthread(nil,0,@gen_thread,@threads_sett[3],0,id);

  wait_level_thread_hndl:=beginthread(nil,0,@wait_level_thread,nil,0,id);

  //izmenaem prioritet
  //if SetThreadAffinityMask(gen_threads[0],2)=0 then main.Memo1.Lines.Add('Error in set affinity mask1');
  SetThreadPriority(gen_threads[0],THREAD_PRIORITY_HIGHEST);

  {if SetThreadAffinityMask(gen_threads[1],1)=0 then main.Memo1.Lines.Add('Error in set affinity mask2');
  SetThreadPriority(gen_threads[1],THREAD_PRIORITY_HIGHEST);

  {if SetThreadAffinityMask(gen_threads[2],2)=0 then main.Memo1.Lines.Add('Error in set affinity mask3');
  SetThreadPriority(gen_threads[2],THREAD_PRIORITY_HIGHEST);

  if SetThreadAffinityMask(gen_threads[3],1)=0 then main.Memo1.Lines.Add('Error in set affinity mask4');
  SetThreadPriority(gen_threads[3],THREAD_PRIORITY_HIGHEST);  }

  //izmenaem status generacii
  gen_status:=4;

  wait_init_thread_hndl:=0;

  endthread(2);
end;

//potok dla vizova procedur inicializacii
//peredaetsa ukazatel' na proceduru inicializacii
function init_thread(p:pointer):integer;
var //init_proc_temp:TInit_gen;
plug:TPlugin_type;
id:cardinal;
b:boolean;
i,j:integer;
begin
  main.Memo1.Lines.Add('Initialization thread enter');
  //init_proc_temp:=TInit_gen(p);
  plug:=pTPlugin_type(p)^;

  i:=0;
  j:=0;

  if (plug.info.plugin_type and $7)=1 then
    b:=plug.init_gen(generation_settings,generation_settings.border_in,generation_settings.border_out)
  else
    b:=plug.init_gen(generation_settings,i,j);

  if b then
    main.Memo1.Lines.Add('Initialization of plugin '+plug.plug_full_name+' ('+plug.plug_file+') completed sucsessfuly')
  else
  begin
    main.Memo1.Lines.Add('Initialization of plugin '+plug.plug_full_name+' ('+plug.plug_file+') completed with error, stopping');
    endthread(5);
    //beginthread(nil,0,@stop_gen_thread,nil,0,id);
    //todo:
    //sdelat' tak, chtobi potok vernul opredelenniy kod
    //i proanalizirovat' ego v potoke wait_init_thread pri pomoshi funkcii getexitcode ili chto-to tipa etogo
  end;

  endthread(2);
end;

initialization

begin
  {trans_bl:=[0,6,8,9,18,20,26,27,28,   30,31,32,      37,38,39,40,50,51,52,   55,59,63,64,65,66,68,69,70,71,72,75,76,77,78,79,81,83,85,90,92,93,94,96,   101,102,104,105,106,107,111,113,115];
  light_bl:=[10,11,39,50,51,62,74,76,89,90,91,94,95];
  diff_bl:=[8,9,79]; 
  solid_bl:=[1,2,3,4,5,7,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,29,30,33,34,35,36,41,42,43,44,45,46,47,48,49,52,53,54,56,57,58,60,61,62,64,67,71,73,74,79,80,81,82,84,85,86,87,88,89,91,92,95,96,97,98,99,100,101,102,103,107,108,109,110,112,113,114];}
end;

end.


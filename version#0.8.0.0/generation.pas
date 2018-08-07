unit generation;

interface

uses generation_obsh, NBT, zlibex, windows, sysutils,
     generation_flat, generation_biosf, generation_planet,
     generation_tunnel, generation_biome_desert,
     generation_original;

function generate_level(var sett:level_set):integer;
function gen_flat(path,map_name:string; var flat_settings:flatmap_settings_type;var border_set:border_settings_type; level_settings:level_set):integer;
function gen_biosphere(path,map_name:string; var biosf_settings:bio_settings_type;var border_set:border_settings_type; level_settings:level_set):integer;
function gen_planets(path,map_name:string; var pl_set:planetoids_settings_type;var border_set:border_settings_type; level_settings:level_set):integer;
function gen_tunnels(path,map_name:string; var tun_set:tunnels_settings_type; var border_set:border_settings_type; level_settings:level_set):integer;
function gen_biome_desert(path,map_name:string; var biomes_desert_settings:biomes_desert_settings_type;var border_set:border_settings_type; level_settings:level_set):integer;
function gen_original(path,map_name:string; var orig_set:original_settings_type; var border_set:border_settings_type; level_settings:level_set):integer;

implementation

function generate_level(var sett:level_set):integer;
var f:file;
str,strcompress:string;
begin
  result:=-1;

  sett.rain_time:=sett.rain_time*20;
  sett.thunder_time:=sett.thunder_time*20;
  //nbtcompresslevel(sett.spawnx,sett.spawny,sett.spawnz,sett.name,str,sett.sid,sett.size,sett.game_type,sett.map_features,sett.raining,sett.rain_time*20,sett.thundering,sett.thunder_time*20,sett.game_time);
  nbtcompresslevel2(sett,str);

  zcompressstringex(strcompress,str,zcmax);

  str:=copy(strcompress,1,4);
  delete(strcompress,1,4);
  delete(strcompress,1,2);

  strcompress:=strcompress+str;

  strcompress:=#31+#139+#8+#0+#0+#0+#0+#0+#2+#0+strcompress;

  assignfile(f,sett.path+sett.name+'\level.dat');
  rewrite(f,1);

  blockwrite(f,strcompress[1],length(strcompress));
  closefile(f);

  result:=0;
end;

function gen_biosphere(path,map_name:string; var biosf_settings:bio_settings_type;var border_set:border_settings_type; level_settings:level_set):integer;
var param:ptparam_biosphere;
granx,grany:integer;
handle:integer;
id:cardinal;
begin
  //generation started
  postmessage(biosf_settings.handle,WM_USER+306,0,0);
  postmessage(biosf_settings.handle,WM_USER+300,0,0);

  //sozdaem directorii
  createdirectory(pchar(path+map_name),nil);
  createdirectory(pchar(path+map_name+'\region'),nil);

  //sozdanie fayla nastroek
  generate_settings(path,map_name,biosf_settings.sid,border_set,@biosf_settings,6,level_settings);

  //menaem tekushuyu direktoriyu
  if SetCurrentDir(path+map_name+'\region')=false then
  begin
    result:=-1;
    exit;
  end;

  //videlaem pamat pod strukturu dla peredachi parametrov v potok
  new(param);

  //zapolnaem parametri
  param^.id:=1;
  param^.handle:=biosf_settings.handle;
  param^.sid:=biosf_settings.sid;
  param^.bio_par:=@biosf_settings;
  param^.border_par:=@border_set;

  //vichislaem ot i do kuda nado generit
  granx:=biosf_settings.width div 2;
  grany:=biosf_settings.len div 2;

  param^.fromx:=-granx;
  param^.fromy:=-grany;
  param^.tox:=granx-1;
  param^.toy:=grany-1;

  //zapuskaem potoki generacii
  handle:=beginthread(nil,0,@gen_biosphere_thread,param,0,id);
  setpriorityclass(handle,$00008000);
  Setthreadpriority(handle,2);

  result:=handle;
end;

function gen_flat(path,map_name:string; var flat_settings:flatmap_settings_type;var border_set:border_settings_type; level_settings:level_set):integer;
var param:ptparam_flat;
granx,grany:integer;
handle:integer;
id:cardinal;
begin
  //generation started
  postmessage(flat_settings.handle,WM_USER+306,0,0);
  postmessage(flat_settings.handle,WM_USER+300,0,0);

  //sozdaem directorii
  createdirectory(pchar(path+map_name),nil);
  createdirectory(pchar(path+map_name+'\region'),nil);

  //sozdanie fayla nastroek
  generate_settings(path,map_name,flat_settings.sid,border_set,@flat_settings,0,level_settings);

  //menaem tekushuyu direktoriyu
  if SetCurrentDir(path+map_name+'\region')=false then
  begin
    result:=-1;
    exit;
  end;

  //videlaem pamat pod strukturu dla peredachi parametrov v potok
  new(param);

  //zapolnaem parametri
  param^.id:=1;
  param^.handle:=flat_settings.handle;
  param^.sid:=flat_settings.sid;
  param^.flatmap_par:=@flat_settings;
  param^.border_par:=@border_set;

  //vichislaem ot i do kuda nado generit
  granx:=flat_settings.width div 2;
  grany:=flat_settings.len div 2;

  param^.fromx:=-granx;
  param^.fromy:=-grany;
  param^.tox:=granx-1;
  param^.toy:=grany-1;

  //zapuskaem potoki generacii
  handle:=beginthread(nil,0,@gen_flat_thread,param,0,id);
  setpriorityclass(handle,$00008000);
  Setthreadpriority(handle,2);

  result:=handle;
end;

function gen_biome_desert(path,map_name:string; var biomes_desert_settings:biomes_desert_settings_type;var border_set:border_settings_type; level_settings:level_set):integer;
var param:ptparam_biomes_desert;
granx,grany:integer;
handle:integer;
id:cardinal;
begin
  //generation started
  //postmessage(biomes_desert_settings.handle,WM_USER+306,0,0);
  postmessage(biomes_desert_settings.handle,WM_USER+300,0,0);

  //sozdaem directorii
  createdirectory(pchar(path+map_name),nil);
  createdirectory(pchar(path+map_name+'\region'),nil);

  //sozdanie fayla nastroek
  generate_settings(path,map_name,biomes_desert_settings.sid,border_set,@biomes_desert_settings,3,level_settings);

  //menaem tekushuyu direktoriyu
  if SetCurrentDir(path+map_name+'\region')=false then
  begin
    result:=-1;
    exit;
  end;

  //videlaem pamat pod strukturu dla peredachi parametrov v potok
  new(param);

  //zapolnaem parametri
  param^.id:=1;
  param^.handle:=biomes_desert_settings.handle;
  param^.sid:=biomes_desert_settings.sid;
  param^.desert_par:=@biomes_desert_settings;
  param^.border_par:=@border_set;

  //vichislaem ot i do kuda nado generit
  granx:=biomes_desert_settings.width div 2;
  grany:=biomes_desert_settings.len div 2;

  param^.fromx:=-granx;
  param^.fromy:=-grany;
  param^.tox:=granx-1;
  param^.toy:=grany-1;

  param^.path:=path;
  param^.map_name:=map_name;

  //zapuskaem potoki generacii
  handle:=beginthread(nil,0,@gen_biome_desert_thread,param,0,id);
  setpriorityclass(handle,$00008000);
  Setthreadpriority(handle,2);

  result:=handle;
end;

function gen_planets(path,map_name:string; var pl_set:planetoids_settings_type;var border_set:border_settings_type; level_settings:level_set):integer;
var param:ptparam_planet;
granx,grany:integer;
handle:integer;
id:cardinal;
begin
  //generation started
  postmessage(pl_set.handle,WM_USER+306,0,0);
  postmessage(pl_set.handle,WM_USER+300,0,0);

  //sozdaem directorii
  createdirectory(pchar(path+map_name),nil);
  createdirectory(pchar(path+map_name+'\region'),nil);

  //sozdanie fayla nastroek
  generate_settings(path,map_name,pl_set.sid,border_set,@pl_set,5,level_settings);

  //menaem tekushuyu direktoriyu
  if SetCurrentDir(path+map_name+'\region')=false then
  begin
    result:=-1;
    exit;
  end;

  //videlaem pamat pod strukturu dla peredachi parametrov v potok
  new(param);

  //zapolnaem parametri
  param^.id:=1;
  param^.handle:=pl_set.handle;
  param^.sid:=pl_set.sid;
  param^.planet_par:=@pl_set;
  param^.border_par:=@border_set;

  //vichislaem ot i do kuda nado generit
  granx:=pl_set.width div 2;
  grany:=pl_set.len div 2;

  param^.fromx:=-granx;
  param^.fromy:=-grany;
  param^.tox:=granx-1;
  param^.toy:=grany-1;

  //gotovim strukturu dla generacii level.dat
  {a1.spawnx:=0;
  a1.spawnz:=0;
  a1.spawny:=pl_set.groundlevel+1;     //vremenno
  a1.path:=path;
  a1.name:=map_name;  }

  //generim level.dat
  //generate_level(a1);

  //zapuskaem potoki generacii
  handle:=beginthread(nil,0,@gen_planets_thread,param,0,id);
  setpriorityclass(handle,$00008000);
  Setthreadpriority(handle,2);

  result:=handle;
end;

function gen_original(path,map_name:string; var orig_set:original_settings_type; var border_set:border_settings_type; level_settings:level_set):integer;
var param:ptparam_original;
granx,grany:integer;
handle:integer;
id:cardinal;
begin
  //generation started
  //postmessage(tun_set.handle,WM_USER+306,0,0);
  postmessage(orig_set.handle,WM_USER+300,0,0);

  //sozdaem directorii
  createdirectory(pchar(path+map_name),nil);
  createdirectory(pchar(path+map_name+'\region'),nil);

  //ToDo: dobavit' sdes' sozdanie fayla nastroek so vsemi nastroikami karti
  generate_settings(path,map_name,orig_set.sid,border_set,@orig_set,1,level_settings);

  //menaem tekushuyu direktoriyu
  if SetCurrentDir(path+map_name+'\region')=false then
  begin
    result:=-1;
    exit;
  end;

  //videlaem pamat pod strukturu dla peredachi parametrov v potok
  new(param);

  //zapolnaem parametri
  param^.id:=1;
  param^.handle:=orig_set.handle;
  param^.sid:=orig_set.sid;
  param^.original_par:=@orig_set;
  param^.border_par:=@border_set;

  //vichislaem ot i do kuda nado generit
  granx:=orig_set.width div 2;
  grany:=orig_set.len div 2;

  param^.fromx:=-granx;
  param^.fromy:=-grany;
  param^.tox:=granx-1;
  param^.toy:=grany-1;

  //zapuskaem potoki generacii
  handle:=beginthread(nil,0,@gen_original_thread,param,0,id);
  //handle:=beginthread(nil,0,@gen_tunnels_thread,nil,0,id);
  setpriorityclass(handle,$00008000);
  Setthreadpriority(handle,2);

  result:=handle;
end;

function gen_tunnels(path,map_name:string; var tun_set:tunnels_settings_type; var border_set:border_settings_type; level_settings:level_set):integer;
var param:ptparam_tunnel;
granx,grany:integer;
handle:integer;
id:cardinal;
begin
  //generation started
  //postmessage(tun_set.handle,WM_USER+306,0,0);
  postmessage(tun_set.handle,WM_USER+300,0,0);

  //sozdaem directorii
  createdirectory(pchar(path+map_name),nil);
  createdirectory(pchar(path+map_name+'\region'),nil);

  //ToDo: dobavit' sdes' sozdanie fayla nastroek so vsemi nastroikami karti
  generate_settings(path,map_name,tun_set.sid,border_set,@tun_set,7,level_settings);

  //menaem tekushuyu direktoriyu
  if SetCurrentDir(path+map_name+'\region')=false then
  begin
    result:=-1;
    exit;
  end;

  //videlaem pamat pod strukturu dla peredachi parametrov v potok
  new(param);

  //zapolnaem parametri
  param^.id:=1;
  param^.handle:=tun_set.handle;
  param^.sid:=tun_set.sid;
  param^.tunnel_par:=@tun_set;
  param^.border_par:=@border_set;

  //vichislaem ot i do kuda nado generit
  granx:=tun_set.width div 2;
  grany:=tun_set.len div 2;

  param^.fromx:=-granx;
  param^.fromy:=-grany;
  param^.tox:=granx-1;
  param^.toy:=grany-1;

  //zapuskaem potoki generacii
  handle:=beginthread(nil,0,@gen_tunnels_thread,param,0,id);
  //handle:=beginthread(nil,0,@gen_tunnels_thread,nil,0,id);
  setpriorityclass(handle,$00008000);
  Setthreadpriority(handle,2);

  result:=handle;
end;

end.

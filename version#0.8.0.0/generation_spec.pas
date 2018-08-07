unit generation_spec;

interface

uses NBT, generation_obsh, F_Version, SysUtils, RandomMCT, NoiseGeneratorOctaves_u, NoiseGenerator_u, Math, Windows, generation_cwall, zlibex;

procedure clear_all_entities(entities:par_entity_type; tentities:par_tile_entity_type);
function get_noise_koord(x,y:integer; sid:int64; flat:boolean):integer;
procedure calc_cos_tun(var ar_tun:array of tunnels_settings);
procedure fill_tun_chunks(var ar_tun:array of tunnels_settings);
procedure fill_el_chunks(var ar_el:ar_elipse_settings);
procedure gen_border(xkoord,ykoord,width,len:integer; par_border:border_settings_type; var blocks,data:ar_type; entities:par_entity_type; tileentities:par_tile_entity_type);
procedure calc_heightmap(var blocks,heightmap:array of byte);
function gen_tree_notch(var map:region; xreg,yreg:integer; sid:int64; x,y,z:integer;var sp:boolean; waterlevel:integer; hndl:cardinal; treetype:byte):boolean;
function gen_bigtree_notch(var map:region; xreg,yreg,x,y,z:integer; sid:int64;var sp:boolean; waterlevel:integer; hndl:cardinal):boolean;
function get_block_id(map:region; xreg,yreg:integer; x,y,z:integer):byte;
function set_block_id(map:region; xreg,yreg:integer; x,y,z,id:integer):boolean;
function set_block_id_data(map:region; xreg,yreg:integer; x,y,z,id,data:integer):boolean;
function gen_cactus(var map:region; xreg,yreg,x,y,z:integer; sid:int64):boolean;
function gen_taigatree1_notch(var map:region; xreg,yreg,x,y,z:integer; sid:int64):boolean;
function gen_taigatree2_notch(var map:region; xreg,yreg,x,y,z:integer; sid:int64):boolean;
procedure gen_resourses2(var map:region; regx,regy:integer; x,y,z,id:integer; count:integer);
procedure calc_skylight(var map:region; otx,oty,dox,doy:integer);
procedure calc_blocklight(var map:region;otx,oty,dox,doy:integer);
procedure fill_planet_chunks(var ar_el:ar_planets_settings);
procedure gen_resourses3(var map:region; xreg,yreg:integer; pr_res:ar_tlights_koord; tip:byte; sid:int64; zamena_id:byte);
function gen_obsh_sid(sid:int64; bor_set:border_settings_type; par:pointer; map_type:byte; ver:TFileVersionInfo; level_settings:level_set):string;
procedure gen_mushroom(var map:region; xreg,yreg,x,y,z,tip:integer);
function gen_reed(var map:region; xreg,yreg,x,y,z:integer; sid:int64):boolean;
function gen_palm(var map:region; xreg,yreg,x,y,z,tip:integer; sid:int64):boolean;
function gen_vipuklost(var map:region; xreg,yreg,x,y,z:integer):boolean;
function place_sign(var map:region; xreg,yreg,x,y,z,data:integer; text1,text2,text3,text4:string; standing:boolean):boolean;
function gen_recur(napravlenie:byte; var map:region; rx,ry,x,y,z,id,tip:integer; count:integer; var r:rnd; zamena_id:byte):integer;
function place_spawner(var map:region; xreg,yreg,x,y,z:integer; mob:string):boolean;
function get_skylight(map:region; xreg,yreg:integer; x,y,z:integer):byte;
function get_blocklight(map:region; xreg,yreg:integer; x,y,z:integer):byte;
function get_block_data(map:region; xreg,yreg:integer; x,y,z:integer):byte;
function get_top_solid(map:region; xreg,yreg:integer; x,z:integer):byte;
function get_heightmap(map:region; xreg,yreg:integer; x,z:integer):byte;

implementation

function gen_obsh_sid(sid:int64; bor_set:border_settings_type; par:pointer; map_type:byte; ver:TFileVersionInfo; level_settings:level_set):string;
var t:longword;
str,temp,bit:string;
i,j,k:integer;
flat:flatmap_settings_type;
planet:planetoids_settings_type;
tunnel:tunnels_settings_type;
bio:bio_settings_type;
desert:biomes_desert_settings_type;
original:original_settings_type;
flatp:pflatmap_settings_type;
planetp:pplanetoids_settings_type;
tunnelp:ptunnels_settings_type;
biop:pbio_settings_type;
desertp:pbiomes_desert_settings_type;
originalp:poriginal_settings_type;
tunnel_light:array[1..6] of boolean;
begin
  str:='';
  //blok SID
  temp:=inttohex(2,2)+inttohex(8,2)+inttohex(sid,16);
  str:=str+temp;

  //blok versii programmi
  temp:=ver.FileVersion;
  if temp='10.100.1000.0' then temp:='0.0.0.0';
  //major
  bit:=hextobin(inttohex(strtoint(copy(temp,1,pos('.',temp)-1)),1));
  delete(temp,1,pos('.',temp));
  //minor
  bit:=bit+copy(hextobin(inttohex(strtoint(copy(temp,1,pos('.',temp)-1)),2)),3,6);
  delete(temp,1,pos('.',temp));
  //release
  bit:=bit+copy(hextobin(inttohex(strtoint(copy(temp,1,pos('.',temp)-1)),2)),3,6);
  //formiruem blok
  temp:=inttohex(4,2)+inttohex(2,2)+inttohex(bintoint(bit),4);
  str:=str+temp;

  //smotrim dannie karti
  case map_type of
  0:begin  //flatmap
      flatp:=par;
      flat:=flatp^;
      //blok obshih nastroek karti
      i:=flat.width;
      j:=flat.len;
      bit:=hextobin(inttohex(i,3)+inttohex(j,3));
      if i=j then bit:=bit+'1'
      else bit:=bit+'0';
      if flat.pop_chunks then bit:=bit+'1'
      else bit:=bit+'0';
      if level_settings.map_features=0 then bit:=bit+'0'
      else bit:=bit+'1';
      bit:=bit+copy(hextobin(inttohex(level_settings.game_type,1)),2,3);
      if level_settings.raining=0 then bit:=bit+'0'
      else bit:=bit+'1';
      bit:=bit+hextobin(inttohex(level_settings.rain_time,5));
      if level_settings.thundering=0 then bit:=bit+'0'
      else bit:=bit+'1';
      bit:=bit+hextobin(inttohex(level_settings.thunder_time,5));
      temp:=inttohex(3,2)+inttohex(9,2)+inttohex(bintoint(copy(bit,1,36)),9)+inttohex(bintoint(copy(bit,37,36)),9);
      str:=str+temp;

      //blok nastroek karti
      bit:='00000';
      for i:=0 to length(flat.sloi)-1 do
      begin
        bit:=bit+hextobin(inttohex(flat.sloi[i].width,2));
        bit:=bit+hextobin(inttohex(flat.sloi[i].material,2));
        bit:=bit+hextobin(inttohex(flat.sloi[i].material_data,1));
      end;

      j:=length(bit) div 8;
      if (length(bit) mod 8)<>0 then i:=((j+1)*8)-length(bit)
      else i:=0;

      for j:=1 to i do
        bit:=bit+'0';

      j:=length(bit) div 8;

      temp:=inttohex(5,2)+inttohex(j,2);
      for i:=0 to j-1 do
        temp:=temp+inttohex(bintoint(copy(bit,(i*8)+1,8)),2);

      str:=str+temp;

      {bit:='00000';
      bit:=bit+copy(hextobin(inttohex(flat.groundlevel,2)),2,7);
      bit:=bit+copy(hextobin(inttohex(flat.waterlevel,2)),2,7);
      bit:=bit+hextobin(inttohex(flat.groundmaterial,2));
      bit:=bit+hextobin(inttohex(flat.dirtmaterial,2));
      if flat.dirt_on_top then bit:=bit+'1' else bit:=bit+'0';
      if flat.grass_on_top then bit:=bit+'1' else bit:=bit+'0';
      bit:=bit+'000';
      temp:=inttohex(5,2)+inttohex(5,2)+inttohex(bintoint(bit),10);
      str:=str+temp;    }
    end;
  1:begin   //original
      originalp:=par;
      original:=originalp^;
      //blok obshih nastroek karti
      i:=original.width;
      j:=original.len;
      bit:=hextobin(inttohex(i,3)+inttohex(j,3));
      if i=j then bit:=bit+'1'
      else bit:=bit+'0';
      if original.pop_chunks then bit:=bit+'1'
      else bit:=bit+'0';
      if level_settings.map_features=0 then bit:=bit+'0'
      else bit:=bit+'1';
      bit:=bit+copy(hextobin(inttohex(level_settings.game_type,1)),2,3);
      if level_settings.raining=0 then bit:=bit+'0'
      else bit:=bit+'1';
      bit:=bit+hextobin(inttohex(level_settings.rain_time,5));
      if level_settings.thundering=0 then bit:=bit+'0'
      else bit:=bit+'1';
      bit:=bit+hextobin(inttohex(level_settings.thunder_time,5));
      temp:=inttohex(3,2)+inttohex(9,2)+inttohex(bintoint(copy(bit,1,36)),9)+inttohex(bintoint(copy(bit,37,36)),9);
      str:=str+temp;

      //blok nastroek karti
      bit:='00001';
      bit:=bit+'000';
      {bit:=bit+copy(hextobin(inttohex(planet.map_type,1)),2,3);
      bit:=bit+copy(hextobin(inttohex(planet.distance,2)),3,6);
      bit:=bit+copy(hextobin(inttohex(planet.min,2)),3,6);
      bit:=bit+copy(hextobin(inttohex(planet.max,2)),3,6);
      bit:=bit+copy(hextobin(inttohex(planet.density,2)),2,7);
      bit:=bit+copy(hextobin(inttohex(planet.groundlevel,2)),2,7);
      bit:=bit+hextobin(inttohex(planet.planets_type,1));
      bit:=bit+'0000'; }
      temp:=inttohex(5,2)+inttohex(1,2)+inttohex(bintoint(copy(bit,1,8)),2);
      str:=str+temp;
    end;
  3:begin   //desert
      desertp:=par;
      desert:=desertp^;
      //blok obshih nastroek karti
      i:=desert.width;
      j:=desert.len;
      bit:=hextobin(inttohex(i,3)+inttohex(j,3));
      if i=j then bit:=bit+'1'
      else bit:=bit+'0';
      if desert.pop_chunks then bit:=bit+'1'
      else bit:=bit+'0';
      if level_settings.map_features=0 then bit:=bit+'0'
      else bit:=bit+'1';
      bit:=bit+copy(hextobin(inttohex(level_settings.game_type,1)),2,3);
      if level_settings.raining=0 then bit:=bit+'0'
      else bit:=bit+'1';
      bit:=bit+hextobin(inttohex(level_settings.rain_time,5));
      if level_settings.thundering=0 then bit:=bit+'0'
      else bit:=bit+'1';
      bit:=bit+hextobin(inttohex(level_settings.thunder_time,5));
      temp:=inttohex(3,2)+inttohex(9,2)+inttohex(bintoint(copy(bit,1,36)),9)+inttohex(bintoint(copy(bit,37,36)),9);
      str:=str+temp;

      //blok nastroek karti
      bit:='00011';
      if desert.gen_oasises=true then bit:=bit+'1' else bit:=bit+'0';
      bit:=bit+copy(hextobin(inttohex(desert.oasis_count,2)),2,7);
      bit:=bit+hextobin(inttohex(desert.under_block,2));
      if desert.gen_shrubs=true then bit:=bit+'1' else bit:=bit+'0';
      if desert.gen_cactus=true then bit:=bit+'1' else bit:=bit+'0';
      if desert.gen_pyr=true then bit:=bit+'1' else bit:=bit+'0';
      if desert.gen_volcano=true then bit:=bit+'1' else bit:=bit+'0';
      if desert.gen_preview=true then bit:=bit+'1' else bit:=bit+'0';
      if desert.gen_prev_oasis=true then bit:=bit+'1' else bit:=bit+'0';
      if desert.gen_prev_vil=true then bit:=bit+'1' else bit:=bit+'0';
      if desert.gen_only_prev=true then bit:=bit+'1' else bit:=bit+'0';
      if desert.gen_vil=true then bit:=bit+'1' else bit:=bit+'0';
      //delaem tipi dereven'
      if desert.vil_types.ruied=true then bit:=bit+'1' else bit:=bit+'0';
      if desert.vil_types.normal=true then bit:=bit+'1' else bit:=bit+'0';
      if desert.vil_types.normal_veg=true then bit:=bit+'1' else bit:=bit+'0';
      if desert.vil_types.fortif=true then bit:=bit+'1' else bit:=bit+'0';
      if desert.vil_types.hidden=true then bit:=bit+'1' else bit:=bit+'0';

      temp:='';
      for i:=0 to length(desert.vil_names)-1 do
        temp:=temp+desert.vil_names[i]+#0;

      temp:=zcompressstr(temp,zcmax);

      for i:=1 to length(temp) do
        bit:=bit+hextobin(inttohex(ord(temp[i]),2));

      j:=length(bit) div 8;
      if (length(bit) mod 8)<>0 then i:=((j+1)*8)-length(bit)
      else i:=0;

      for j:=1 to i do
        bit:=bit+'0';

      j:=length(bit) div 8;

      temp:=inttohex(5,2)+inttohex(j,2);
      for i:=0 to j-1 do
        temp:=temp+inttohex(bintoint(copy(bit,(i*8)+1,8)),2);

      str:=str+temp;
    end;
  5:begin  //planetoids
      planetp:=par;
      planet:=planetp^;
      //blok obshih nastroek karti
      i:=planet.width;
      j:=planet.len;
      bit:=hextobin(inttohex(i,3)+inttohex(j,3));
      if i=j then bit:=bit+'1'
      else bit:=bit+'0';
      if planet.pop_chunks then bit:=bit+'1'
      else bit:=bit+'0';
      if level_settings.map_features=0 then bit:=bit+'0'
      else bit:=bit+'1';
      bit:=bit+copy(hextobin(inttohex(level_settings.game_type,1)),2,3);
      if level_settings.raining=0 then bit:=bit+'0'
      else bit:=bit+'1';
      bit:=bit+hextobin(inttohex(level_settings.rain_time,5));
      if level_settings.thundering=0 then bit:=bit+'0'
      else bit:=bit+'1';
      bit:=bit+hextobin(inttohex(level_settings.thunder_time,5));
      temp:=inttohex(3,2)+inttohex(9,2)+inttohex(bintoint(copy(bit,1,36)),9)+inttohex(bintoint(copy(bit,37,36)),9);
      str:=str+temp;

      //blok nastroek karti
      bit:='00101';
      bit:=bit+copy(hextobin(inttohex(planet.map_type,1)),2,3);
      bit:=bit+copy(hextobin(inttohex(planet.distance,2)),3,6);
      bit:=bit+copy(hextobin(inttohex(planet.min,2)),3,6);
      bit:=bit+copy(hextobin(inttohex(planet.max,2)),3,6);
      bit:=bit+copy(hextobin(inttohex(planet.density,2)),2,7);
      bit:=bit+copy(hextobin(inttohex(planet.groundlevel,2)),2,7);
      bit:=bit+hextobin(inttohex(planet.planets_type,1));
      bit:=bit+'0000';
      temp:=inttohex(5,2)+inttohex(6,2)+inttohex(bintoint(copy(bit,1,24)),6)+inttohex(bintoint(copy(bit,25,24)),6);
      str:=str+temp;
    end;
  6:begin  //BioSpheres
      biop:=par;
      bio:=biop^;
      //blok obshih nastroek karti
      i:=bio.width;
      j:=bio.len;
      bit:=hextobin(inttohex(i,3)+inttohex(j,3));
      if i=j then bit:=bit+'1'
      else bit:=bit+'0';
      if bio.pop_chunks then bit:=bit+'1'
      else bit:=bit+'0';
      if level_settings.map_features=0 then bit:=bit+'0'
      else bit:=bit+'1';
      bit:=bit+copy(hextobin(inttohex(level_settings.game_type,1)),2,3);
      if level_settings.raining=0 then bit:=bit+'0'
      else bit:=bit+'1';
      bit:=bit+hextobin(inttohex(level_settings.rain_time,5));
      if level_settings.thundering=0 then bit:=bit+'0'
      else bit:=bit+'1';
      bit:=bit+hextobin(inttohex(level_settings.thunder_time,5));
      temp:=inttohex(3,2)+inttohex(9,2)+inttohex(bintoint(copy(bit,1,36)),9)+inttohex(bintoint(copy(bit,37,36)),9);
      str:=str+temp;

      //blok nastroek karti
      bit:='00110';
      if bio.original_gen then bit:=bit+'1' else bit:=bit+'0';
      if bio.underwater then bit:=bit+'1' else bit:=bit+'0';
      if bio.gen_skyholes then bit:=bit+'1' else bit:=bit+'0';
      if bio.gen_noise then bit:=bit+'1' else bit:=bit+'0';
      if bio.gen_bridges then bit:=bit+'1' else bit:=bit+'0';
      bit:=bit+hextobin(inttohex(bio.bridge_material,2));
      bit:=bit+hextobin(inttohex(bio.bridge_rail_material,2));
      bit:=bit+hextobin(inttohex(bio.bridge_width,1));
      bit:=bit+hextobin(inttohex(bio.sphere_material,2));
      bit:=bit+copy(hextobin(inttohex(bio.sphere_distance,3)),4,9);
      if bio.sphere_ellipse then bit:=bit+'1' else bit:=bit+'0';
      //biomi
      if bio.biomes.forest then bit:=bit+'1' else bit:=bit+'0';
      if bio.biomes.rainforest then bit:=bit+'1' else bit:=bit+'0';
      if bio.biomes.desert then bit:=bit+'1' else bit:=bit+'0';
      if bio.biomes.plains then bit:=bit+'1' else bit:=bit+'0';
      if bio.biomes.taiga then bit:=bit+'1' else bit:=bit+'0';
      if bio.biomes.ice_desert then bit:=bit+'1' else bit:=bit+'0';
      if bio.biomes.tundra then bit:=bit+'1' else bit:=bit+'0';
      if bio.biomes.sky then bit:=bit+'1' else bit:=bit+'0';
      if bio.biomes.hell then bit:=bit+'1' else bit:=bit+'0';
      bit:=bit+'0000000';
      temp:=inttohex(5,2)+inttohex(8,2)+inttohex(bintoint(bit),16);
      str:=str+temp;
    end;
  7:begin  //Golden Tunnels
      tunnelp:=par;
      tunnel:=tunnelp^;
      //blok obshih nastroek karti
      i:=tunnel.width;
      j:=tunnel.len;
      bit:=hextobin(inttohex(i,3)+inttohex(j,3));
      if i=j then bit:=bit+'1'
      else bit:=bit+'0';
      if tunnel.pop_chunks then bit:=bit+'1'
      else bit:=bit+'0';
      if level_settings.map_features=0 then bit:=bit+'0'
      else bit:=bit+'1';
      bit:=bit+copy(hextobin(inttohex(level_settings.game_type,1)),2,3);
      if level_settings.raining=0 then bit:=bit+'0'
      else bit:=bit+'1';
      bit:=bit+hextobin(inttohex(level_settings.rain_time,5));
      if level_settings.thundering=0 then bit:=bit+'0'
      else bit:=bit+'1';
      bit:=bit+hextobin(inttohex(level_settings.thunder_time,5));
      temp:=inttohex(3,2)+inttohex(9,2)+inttohex(bintoint(copy(bit,1,36)),9)+inttohex(bintoint(copy(bit,37,36)),9);
      str:=str+temp;

      //blok nastroek karti
      bit:='00111';
      bit:=bit+copy(hextobin(inttohex(tunnel.tun_density,2)),2,7);
      if tunnel.round_tun then bit:=bit+'1' else bit:=bit+'0';
      bit:=bit+copy(hextobin(inttohex(tunnel.r_hor_min,2)),4,5);
      bit:=bit+copy(hextobin(inttohex(tunnel.r_hor_max,2)),4,5);
      bit:=bit+copy(hextobin(inttohex(tunnel.r_vert_min,2)),4,5);
      bit:=bit+copy(hextobin(inttohex(tunnel.r_vert_max,2)),4,5);
      bit:=bit+copy(hextobin(inttohex(tunnel.round_tun_density,2)),2,7);
      if tunnel.gen_tall_grass then bit:=bit+'1' else bit:=bit+'0';
      if tunnel.gen_hub then bit:=bit+'1' else bit:=bit+'0';
      if tunnel.gen_seperate then bit:=bit+'1' else bit:=bit+'0';
      if tunnel.gen_flooded then bit:=bit+'1' else bit:=bit+'0';
      if tunnel.gen_lights then bit:=bit+'1' else bit:=bit+'0';
      bit:=bit+copy(hextobin(inttohex(tunnel.light_density,2)),2,7);
      for i:=1 to 6 do tunnel_light[i]:=false;
      for i:=0 to length(tunnel.light_blocks)-1 do
        case tunnel.light_blocks[i] of
          89:tunnel_light[1]:=true;
          11:tunnel_light[2]:=true;
          91:tunnel_light[3]:=true;
          87:tunnel_light[4]:=true;
          50:tunnel_light[5]:=true;
          74:tunnel_light[6]:=true;
        end;
      for i:=1 to 6 do
        if tunnel_light[i] then bit:=bit+'1' else bit:=bit+'0';
      bit:=bit+copy(hextobin(inttohex(tunnel.light_blocks_type,1)),2,3);
      if tunnel.gen_sun_holes then bit:=bit+'1' else bit:=bit+'0';
      bit:=bit+copy(hextobin(inttohex(tunnel.skyholes_density,2)),2,7);
      bit:=bit+'000';
      temp:=inttohex(5,2)+inttohex(9,2)+inttohex(bintoint(copy(bit,1,36)),9)+inttohex(bintoint(copy(bit,37,36)),9);
      str:=str+temp;
    end;
  end;

  //smotrim border settings
  bit:=hextobin(inttohex(bor_set.border_type,1));
  case bor_set.border_type of
  0:begin
      bit:=bit+'0000';
      temp:=inttohex(6,2)+inttohex(1,2)+inttohex(bintoint(bit),2);
      str:=str+temp;
    end;
  1:begin
      bit:=bit+hextobin(inttohex(bor_set.wall_material,2));
      if bor_set.wall_void then bit:=bit+'1' else bit:=bit+'0';
      bit:=bit+copy(hextobin(inttohex(bor_set.wall_void_thickness,2)),3,6);
      bit:=bit+copy(hextobin(inttohex(bor_set.wall_thickness,2)),4,5);
      temp:=inttohex(6,2)+inttohex(3,2)+inttohex(bintoint(bit),4);
      str:=str+temp;
    end;
  2:begin
      bit:=bit+copy(hextobin(inttohex(bor_set.void_thickness,2)),2,7);
      bit:=bit+'00000';
      temp:=inttohex(6,2)+inttohex(2,2)+inttohex(bintoint(bit),4);
      str:=str+temp;
    end;
  3:begin
      if bor_set.cwall_gen_towers then bit:=bit+'1' else bit:=bit+'0';
      bit:=bit+hextobin(inttohex(bor_set.cwall_towers_type,1));
      if bor_set.cwall_gen_rails then bit:=bit+'1' else bit:=bit+'0';
      if bor_set.cwall_gen_interior then bit:=bit+'1' else bit:=bit+'0';
      if bor_set.cwall_gen_boinici then bit:=bit+'1' else bit:=bit+'0';
      bit:=bit+hextobin(inttohex(bor_set.cwall_boinici_type,1));
      if bor_set.cwall_gen_gates then bit:=bit+'1' else bit:=bit+'0';
      bit:=bit+hextobin(inttohex(bor_set.cwall_gates_type,1));
      if bor_set.cwall_gen_void then bit:=bit+'1' else bit:=bit+'0';
      bit:=bit+copy(hextobin(inttohex(bor_set.cwall_void_width,2)),2,7);
      bit:=bit+'000';
      temp:=inttohex(6,2)+inttohex(4,2)+inttohex(bintoint(bit),8);
      str:=str+temp;
    end;
  end;

  //blok nastroek igroka
  bit:='';
  bit:=bit+copy(hextobin(inttohex(level_settings.player.xplevel,2)),2,7);
  i:=trunc(level_settings.player.xp*10000*100);
  bit:=bit+copy(hextobin(inttohex(i,6)),5,20);
  bit:=bit+copy(hextobin(inttohex(level_settings.player.score,6)),5,20);
  if level_settings.player.overrite_pos=true then bit:=bit+'1'
  else bit:=bit+'0';
  bit:=bit+hextobin(inttohex(integer(trunc(level_settings.player.pos[0])),8));
  //if length(temp)=64 then temp:=copy(temp,33,32);
  //bit:=bit+temp;
  bit:=bit+hextobin(inttohex(trunc(level_settings.player.pos[1]),2));
  bit:=bit+hextobin(inttohex(integer(trunc(level_settings.player.pos[2])),8));
  //if length(temp)=64 then temp:=copy(temp,33,32);
  //bit:=bit+temp;
  bit:=bit+copy(hextobin(inttohex(level_settings.player.health,2)),4,5);
  i:=trunc(level_settings.player.rotation[0]);
  if i<0 then bit:=bit+'1'
  else bit:=bit+'0';
  bit:=bit+copy(hextobin(inttohex(abs(i),3)),4,9);
  i:=trunc(level_settings.player.rotation[1]);
  if i<0 then bit:=bit+'1'
  else bit:=bit+'0';
  bit:=bit+copy(hextobin(inttohex(abs(i),2)),2,7);
  bit:=bit+copy(hextobin(inttohex(level_settings.player.food_level,2)),4,5);
  bit:=bit+'0000';

  j:=length(bit) div 8;

  temp:=inttohex(8,2)+inttohex(j,2);
  for i:=0 to j-1 do
    temp:=temp+inttohex(bintoint(copy(bit,(i*8)+1,8)),2);

  str:=str+temp;


  //blok crc32
  t:=calc_crc32(str);
  temp:=inttohex(1,2)+inttohex(4,2)+inttohex(t,8);
  str:=str+temp;

  result:=str;
end;

function get_block_id(map:region; xreg,yreg:integer; x,y,z:integer):byte;
  var tempxot,tempxdo,tempyot,tempydo:integer;
  chx,chy:integer;
  xx,zz,yy:integer;
  begin
    if (y<0)or(y>127) then
    begin
      result:=255;
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

    //uslovie
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

      result:=map[chx][chy].blocks[yy+(zz*128+(xx*2048))];
    end
    else result:=255;
  end;

function get_top_solid(map:region; xreg,yreg:integer; x,z:integer):byte;
  var tempxot,tempxdo,tempyot,tempydo:integer;
  chx,chy:integer;
  xx,zz,yy:integer;
  begin
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

      yy:=127;

      while yy>0 do
      begin
        if(yy=0)or(map[chx][chy].blocks[yy+(zz*128+(xx*2048))] in solid_bl)or(map[chx][chy].blocks[yy+(zz*128+(xx*2048))]=18) then
          dec(yy)
        else
        begin
          result:=yy+1;
          exit;
        end;
      end;

      result:=255;
      //result:=map[chx][chy].blocks[yy+(zz*128+(xx*2048))];
    end
    else result:=255;
  end;

function get_heightmap(map:region; xreg,yreg:integer; x,z:integer):byte;
  var tempxot,tempxdo,tempyot,tempydo:integer;
  chx,chy:integer;
  xx,zz,yy:integer;
  begin
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

      result:=map[chx][chy].heightmap[zz+(xx*16)];
    end
    else result:=255;
  end;

function get_skylight(map:region; xreg,yreg:integer; x,y,z:integer):byte;
  var tempxot,tempxdo,tempyot,tempydo:integer;
  chx,chy:integer;
  xx,zz,yy:integer;
  begin
    if (y<0)or(y>127) then
    begin
      result:=0;
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

    //uslovie
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

      result:=map[chx][chy].skylight[yy+(zz*128+(xx*2048))];
    end
    else result:=0;
  end;

function get_blocklight(map:region; xreg,yreg:integer; x,y,z:integer):byte;
  var tempxot,tempxdo,tempyot,tempydo:integer;
  chx,chy:integer;
  xx,zz,yy:integer;
  begin
    if (y<0)or(y>127) then
    begin
      result:=0;
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

    //uslovie
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

      result:=map[chx][chy].light[yy+(zz*128+(xx*2048))];
    end
    else result:=0;
  end;

function get_block_data(map:region; xreg,yreg:integer; x,y,z:integer):byte;
  var tempxot,tempxdo,tempyot,tempydo:integer;
  chx,chy:integer;
  xx,zz,yy:integer;
  begin
    if (y<0)or(y>127) then
    begin
      result:=0;
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

    //uslovie
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

      result:=map[chx][chy].data[yy+(zz*128+(xx*2048))];
    end
    else result:=0;
  end;

function set_block_id(map:region; xreg,yreg:integer; x,y,z,id:integer):boolean;
  var tempxot,tempxdo,tempyot,tempydo:integer;
  chx,chy:integer;
  xx,zz,yy:integer;
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

    //uslovie
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

      map[chx][chy].blocks[yy+(zz*128+(xx*2048))]:=id;
      result:=true;
    end
    else result:=false;
  end;

function set_block_id_data(map:region; xreg,yreg:integer; x,y,z,id,data:integer):boolean;
  var tempxot,tempxdo,tempyot,tempydo:integer;
  chx,chy:integer;
  xx,zz,yy:integer;
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

    //uslovie
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

      map[chx][chy].blocks[yy+(zz*128+(xx*2048))]:=id;
      if data<>0 then map[chx][chy].data[yy+(zz*128+(xx*2048))]:=data;
      result:=true;
    end
    else result:=false;
  end;

procedure gen_krater(var map:region; xreg,yreg:integer);
var blocks:ar_tlights_koord;
blocks_temp:tlights_record;
c_x,c_y,c_z,i,j,k1,k2,l,k:integer;
rad_x,rad_y,rad_z:integer;
temp,temp1,min:extended;
dist_x,dist_z:integer;
dist_mag:extended;
throw_distance:extended;
difference_multiple:extended;
offset_x,offset_z:integer;
x,y,z:integer;
random_dist:extended;
x_kick,z_kick:extended;
dist_ratio:extended;
new_x,new_z:extended;
new_y:integer;
size:extended;
id:integer;
polovina:integer;
x_mul,z_mul:extended;

flat_surf,flat_surf1:array of array of double;

  function find_surf(map:region; xreg,yreg,x,z:integer):integer;
  var i:integer;
  begin
    for i:=127 downto 0 do
    begin
      if i<=1 then
      begin
        result:=-1;
        exit;
      end;
      if get_block_id(map,xreg,yreg,x,i,z)<>0 then
      begin
        result:=i+1;
        exit;
      end;
    end;
  end;

begin
  if (xreg=0)and(yreg=0) then
  begin
    x_mul:=3;
    z_mul:=4;
    c_x:=250;
    c_z:=250;
    c_y:=65;
    rad_y:=20;
    rad_x:=round(rad_y*x_mul);
    rad_z:=round(rad_y*z_mul);

    {for i:=c_x-rad_x+1 to c_x+rad_x do   //X
      for j:=c_z-rad_z+1 to c_z+rad_z do   //Z
      begin
        //temp:=sqr(rad)-sqr(i-c_x)-sqr(j-c_z);
        temp:=sqr(rad_y)*(1-(sqr(j-c_z)/sqr(rad_z))-(sqr(i-c_x)/sqr(rad_x)));
        if temp<0 then continue;
        k1:=round(c_y-sqrt(temp));
        k2:=round(c_y+sqrt(temp));  //Y
        for l:=k1 to k2 do
        begin
          id:=get_block_id(map,xreg,yreg,i,l,j);
          if id=0 then continue;
          k:=length(blocks);
          setlength(blocks,k+1);
          blocks[k].x:=i;
          blocks[k].y:=l;
          blocks[k].z:=j;
          if id=2 then blocks[k].id:=3
          else blocks[k].id:=id;
          set_block_id(map,xreg,yreg,i,l,j,0);
        end;
      end; }

    for i:=c_y-rad_y to c_y+rad_y do   //Y
      for j:=c_z-rad_z+1 to c_z+rad_z do   //Z
      begin
        //temp:=sqr(rad)-sqr(i-c_x)-sqr(j-c_z);
        temp:=sqr(rad_x)*(1-(sqr(i-c_y)/sqr(rad_y))-(sqr(j-c_z)/sqr(rad_z)));
        if temp<0 then continue;
        k1:=round(c_x-sqrt(temp));
        k2:=round(c_x+sqrt(temp));  //X
        for l:=k1 to k2 do
        begin
          id:=get_block_id(map,xreg,yreg,l,i,j);
          if id=0 then continue;
          k:=length(blocks);
          setlength(blocks,k+1);
          blocks[k].x:=l;
          blocks[k].y:=i;
          blocks[k].z:=j;
          if id=2 then blocks[k].id:=3
          else blocks[k].id:=id;
          set_block_id(map,xreg,yreg,l,i,j,0);
        end;
      end;

    //perestavlaem bloki v massive
    {if (length(blocks) and 1)=1 then setlength(blocks,length(blocks)-1);

    polovina:=(length(blocks) div 2);
    for i:=0 to polovina-1 do
    begin
      blocks_temp:=blocks[polovina+i];
      blocks[polovina+i]:=blocks[polovina-i];
      blocks[polovina-i]:=blocks_temp;
    end;    }

    for i:=0 to length(blocks)-1 do
    begin
      k1:=random(length(blocks));
      k2:=random(length(blocks));
      if k1<>k2 then
      begin
        blocks_temp:=blocks[k1];
        blocks[k1]:=blocks[k2];
        blocks[k2]:=blocks_temp;
      end;
    end;

    {for i:=0 to length(blocks)-2 do
    begin
      temp:=sqrt(sqr(c_x-blocks[i].x)+sqr(c_z-blocks[i].z));
      min:=temp;
      k:=i;
      for j:=i+1 to length(blocks)-1 do
      begin
        //temp:=sqrt(sqr(c_x-blocks[i].x)+sqr(c_y-blocks[i].y)+sqr(c_z-blocks[i].z));
        temp1:=sqrt(sqr(c_x-blocks[j].x)+sqr(c_z-blocks[j].z));
        if temp1<min then
        begin
          min:=temp1;
          k:=j;
        end;
      end;
      if k<>i then
      begin
        blocks_temp:=blocks[k];
        blocks[k]:=blocks[i];
        blocks[i]:=blocks_temp;
      end;
    end;        }

    {for i:=0 to ((length(blocks)-1)div 4) do
      set_block_id(map,xreg,yreg,blocks[i].x,blocks[i].y,blocks[i].z,blocks[i].id);}  

    size:=rad_z; //radius*miltiplyer

    temp:=40/45;

    c_z:=c_z-round((rad_x/z_mul)*x_mul*temp);
    //c_z:=c_z-(rad_z-rad_x);

    for i:=length(blocks)-1 downto 0 do
    begin
      dist_x:=blocks[i].x-c_x;
      dist_z:=blocks[i].z-c_z;

      if (dist_x=0)and(dist_z=0) then continue;
      dist_mag:=sqrt(dist_x*dist_x+dist_z*dist_z);

      throw_distance:=(size*0.5-dist_mag)*1.7;  //1.1=ejectdistance
      //if throw_distance<1.5 then throw_distance:=random*1.5;

      if throw_distance<0 then throw_distance:=0
      else if throw_distance<1.5 then throw_distance:=random*1.5;

      throw_distance:=throw_distance+random*throw_distance-random*throw_distance*0.5;

      difference_multiple:=(dist_mag+throw_distance)/dist_mag;

      offset_x:=round(dist_x*difference_multiple);
      offset_z:=round(dist_z*difference_multiple);

      x:=c_x+offset_x;
      z:=c_z+offset_z;

      random_dist:=throw_distance*0.7;

      x:=round(x+random*random_dist-random*random_dist);
      z:=round(z+random*random_dist-random*random_dist);

      y:=find_surf(map,xreg,yreg,x,z);

      k1:=max(abs(offset_x),abs(offset_z));

      x_kick:=offset_x/k1;
      z_kick:=offset_z/k1;

      {if dist_x=0 then x_kick:=0
      //else x_kick:=round(dist_x/abs(dist_x));
      else if offset_z=0 then x_kick:=1
      else
      begin
        x_kick:=abs(k1/offset_z);
        x_kick:=x_kick+random*x_kick-random*x_kick;
      end;

      if (offset_x<0)and(x_kick>0) then x_kick:=-x_kick;
      if (offset_x>0)and(x_kick<0) then x_kick:=-x_kick;

      if dist_z=0 then z_kick:=0
      //else z_kick:=round(dist_z/abs(dist_z));
      else if offset_x=0 then z_kick:=1
      else
      begin
        z_kick:=abs(k1/offset_x);
        z_kick:=z_kick+random*z_kick-random*z_kick;
      end;

      if (offset_z<0)and(z_kick>0) then z_kick:=-z_kick;
      if (offset_z>0)and(z_kick<0) then z_kick:=-z_kick;

      temp:=max(abs(x_kick),abs(z_kick));

      x_kick:=x_kick/temp;
      z_kick:=z_kick/temp;}

      {if x_kick>=z_kick then
      begin
        if z_kick<>0 then
        begin
          temp:=x_kick/z_kick;
          temp:=abs(temp - round(temp));
          if temp<0.2 then z_kick:=z_kick-random*z_kick*2;
        end;
      end
      else
      begin
        if x_kick<>0 then
        begin
          temp:=z_kick/x_kick;
          temp:=abs(temp - round(temp));
          if temp<0.2 then x_kick:=x_kick-random*x_kick*2;
        end;
      end;   }

      //dist_ratio:=abs(dist_x/(dist_z+0.001));

      {if dist_ratio>2 then
      begin
        z_kick:=0;
        //if offset_z=0 then z_kick:=0
        //else z_kick:=(max(offset_x,offset_z)/offset_z)+1;
      end
      else if dist_ratio<0.5 then
      begin
        x_kick:=0;
        //if offset_x=0 then x_kick:=0
        //else x_kick:=(max(offset_x,offset_z)/offset_x)+1;
      end;    }

      {if dist_x=0 then x_kick:=0
      else x_kick:=round(dist_x/abs(dist_x));
      if dist_z=0 then z_kick:=0
      else z_kick:=round(dist_z/abs(dist_z)); }

      new_x:=x;
      new_z:=z;

      k2:=0;
      while true do
      begin
        inc(k2);

        new_x:=(new_x+x_kick);
        new_z:=(new_z+z_kick);
        new_y:=find_surf(map,xreg,yreg,round(new_x),round(new_z));

        if new_y>=y then break;

        x:=round(new_x);
        y:=new_y;
        z:=round(new_z);
      end;

      set_block_id(map,xreg,yreg,x,y,z,blocks[i].id);
    end;

  //dec(c_x);

 (* for i:=polovina-1 downto 0 do
    begin
      dist_x:=blocks[i].x-c_x;
      dist_z:=blocks[i].z-c_z;

      if (dist_x=0)and(dist_z=0) then continue;
      dist_mag:=sqrt(dist_x*dist_x+dist_z*dist_z);

      throw_distance:=(size*0.5-dist_mag)*2.3;  //1.1=ejectdistance
      if throw_distance<1.5 then throw_distance:=1+0.5;

      difference_multiple:=(dist_mag+throw_distance)/dist_mag;

      offset_x:=round(dist_x*difference_multiple);
      offset_z:=round(dist_z*difference_multiple);

      x:=c_x+offset_x;
      z:=c_z+offset_z;

      random_dist:=throw_distance;

      x:=round(x+random*random_dist-random*random_dist);
      z:=round(z+random*random_dist-random*random_dist);

      y:=find_surf(map,xreg,yreg,x,z);

      if dist_x=0 then x_kick:=0
      else x_kick:=round(dist_x/abs(dist_x));
      //else x_kick:=(max(offset_x,offset_z)/offset_x)+1;

      if dist_z=0 then z_kick:=0
      else z_kick:=round(dist_z/abs(dist_z));
      //else z_kick:=(max(offset_x,offset_z)/offset_z)+1;

      dist_ratio:=abs(dist_x/(dist_z+0.001));

      if dist_ratio>2 then
      begin
        if offset_z=0 then z_kick:=0
        else z_kick:=(max(offset_x,offset_z)/offset_z)+1;
      end
      else if dist_ratio<0.5 then
      begin
        if offset_x=0 then x_kick:=0
        else x_kick:=(max(offset_x,offset_z)/offset_x)+1;
      end;

      {if dist_x=0 then x_kick:=0
      else x_kick:=round(dist_x/abs(dist_x));
      if dist_z=0 then z_kick:=0
      else z_kick:=round(dist_z/abs(dist_z)); }

      new_x:=x;
      new_z:=z;

      while true do
      begin
        new_x:=(new_x+x_kick);
        new_z:=(new_z+z_kick);
        new_y:=find_surf(map,xreg,yreg,round(new_x),round(new_z));

        if new_y>=y then break;

        x:=round(new_x);
        y:=new_y;
        z:=round(new_z);
      end;

      set_block_id(map,xreg,yreg,x,y,z,blocks[i].id);
    end;   *)

  setlength(blocks,0);

  c_z:=c_z+round((rad_x/z_mul)*x_mul*temp);
  //c_z:=c_z+(rad_z-rad_x);

  for i:=c_x-rad_x to c_x+rad_x do
    for j:=c_z to c_z+rad_z do
      if (get_block_id(map,xreg,yreg,i,63,j)=3)and
      (get_block_id(map,xreg,yreg,i,64,j)=0) then
        set_block_id(map,xreg,yreg,i,63,j,2);

  {setlength(flat_surf,3);
  for i:=0 to 2 do
    setlength(flat_surf[i],3);

  for x:=1 to 318 do
    for z:=1 to 318 do
    begin
      for i:=-1 to 1 do
        for j:=-1 to 1 do
          flat_surf[i+1][j+1]:=find_surf(map,xreg,yreg,x+i,z+j)-1;

      temp:=0;
      for i:=0 to 2 do
        for j:=0 to 2 do
          temp:=temp+flat_surf[i][j];

      k2:=round(temp/9);
      k1:=find_surf(map,xreg,yreg,x,z)-1;

      if (k2+1)<k1 then
      begin
        polovina:=(k2+k1)div 2;
        for i:=k2+1 to k1-polovina+1 do
          set_block_id(map,xreg,yreg,x,i,z,0);
      end
      else if k2>(k1+1) then
      begin
        polovina:=(k2+k1)div 2;
        for i:=k1+1 to k2-polovina+1 do
          set_block_id(map,xreg,yreg,x,i,z,1);
      end;
    end;

  for z:=1 to 318 do
    for x:=1 to 318 do
    begin
      for i:=-1 to 1 do
        for j:=-1 to 1 do
          flat_surf[i+1][j+1]:=find_surf(map,xreg,yreg,x+i,z+j)-1;

      temp:=0;
      for i:=0 to 2 do
        for j:=0 to 2 do
          temp:=temp+flat_surf[i][j];

      k2:=round(temp/9);
      k1:=find_surf(map,xreg,yreg,x,z)-1;

      if (k2+1)<k1 then
      begin
        polovina:=(k2+k1)div 2;
        for i:=k2+1 to k1-polovina+1 do
          set_block_id(map,xreg,yreg,x,i,z,0);
      end
      else if k2>(k1+1) then
      begin
        polovina:=(k2+k1)div 2;
        for i:=k1+1 to k2-polovina+1 do
          set_block_id(map,xreg,yreg,x,i,z,1);
      end;
    end;  }

  {setlength(flat_surf,240);
  for i:=0 to 239 do
    setlength(flat_surf[i],240);

  setlength(flat_surf1,240);
  for i:=0 to 239 do
    setlength(flat_surf1[i],240);

  for i:=0 to 239 do
    for j:=0 to 239 do
    begin
      flat_surf[i][j]:=find_surf(map,xreg,yreg,(c_x-120)+i,(c_z-120)+j);
    end;

  for i:=1 to 238 do
    for j:=1 to 238 do
    begin

      temp:=(flat_surf[i-1][j-1]+flat_surf[i-1][j]+flat_surf[i-1][j+1]+
      flat_surf[i][j-1]+flat_surf[i][j]+flat_surf[i][j+1]+
      flat_surf[i+1][j-1]+flat_surf[i+1][j]+flat_surf[i+1][j+1])/9;

      flat_surf1[i][j]:=temp;
    end;

  for i:=1 to 238 do
    for j:=1 to 238 do
    begin
      k1:=round(flat_surf1[i][j]);
      k2:=find_surf(map,xreg,yreg,(c_x-120)+i,(c_z-120)+j);

      if k1<k2 then
      begin
        for y:=k1 to k2 do
          set_block_id(map,xreg,yreg,(c_x-120)+i,y,(c_z-120)+j,0);
      end
      else
      begin
        for y:=k2 to k1-1 do
          set_block_id(map,xreg,yreg,(c_x-120)+i,y,(c_z-120)+j,1);
      end;
    end;

  for i:=0 to 239 do
  begin
    setlength(flat_surf[i],0);
    setlength(flat_surf1[i],0);
  end;

  setlength(flat_surf,0);
  setlength(flat_surf1,0);        }

  end;
end;

function place_spawner_(var map:region; xreg,yreg,chx,chy,x,y,z:integer; mob:string):boolean;
var t:integer;
begin
  map[chx][chy].blocks[y+(z*128+(x*2048))]:=52;
  map[chx][chy].data[y+(z*128+(x*2048))]:=0;

  t:=length(map[chx][chy].tile_entities);
  setlength(map[chx][chy].tile_entities,t+1);
  map[chx][chy].tile_entities[t].id:='MobSpawner';
  map[chx][chy].tile_entities[t].x:=xreg*512+(chx-2)*16+x;
  map[chx][chy].tile_entities[t].y:=y;
  map[chx][chy].tile_entities[t].z:=yreg*512+(chy-2)*16+z;
  new(pmon_spawn_tile_entity_data(map[chx][chy].tile_entities[t].dannie));
  pmon_spawn_tile_entity_data(map[chx][chy].tile_entities[t].dannie)^.entityid:=mob;
  pmon_spawn_tile_entity_data(map[chx][chy].tile_entities[t].dannie)^.delay:=50;
end;

function place_spawner(var map:region; xreg,yreg,x,y,z:integer; mob:string):boolean;
var tempxot,tempxdo,tempyot,tempydo:integer;
chx,chy,xx,zz:integer;
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

      chx:=chx-tempxot;
      chy:=chy-tempyot;

      result:=place_spawner_(map,xreg,yreg,chx,chy,xx,y,zz,mob);
    end
    else result:=false;
end;

function place_sign_(var map:region; xreg,yreg,chx,chy,x,y,z,data:integer; wall:boolean; text1,text2,text3,text4:string):boolean;
var t:integer;
west,east,north,south:boolean;
data_ch:byte;
begin
  if wall=true then
  begin
    if (chx<1)or(chx>34)or(chy<1)or(chy>34) then
    begin
      result:=false;
      exit;
    end;
    //smotrim sosednie bloki
    //po x
    if x=0 then t:=map[chx-1][chy].blocks[y+(z*128+(15*2048))]
    else t:=map[chx][chy].blocks[y+(z*128+((x-1)*2048))];

    if (t in trans_bl)or(t=255) then south:=false
    else south:=true;

    if x=15 then t:=map[chx+1][chy].blocks[y+(z*128)]
    else t:=map[chx][chy].blocks[y+(z*128+((x+1)*2048))];

    if (t in trans_bl)or(t=255) then north:=false
    else north:=true;

    //po z
    if z=0 then t:=map[chx][chy-1].blocks[y+(15*128+(x*2048))]
    else t:=map[chx][chy].blocks[y+((z-1)*128+(x*2048))];

    if (t in trans_bl)or(t=255) then west:=false
    else west:=true;

    if z=15 then t:=map[chx][chy+1].blocks[y+(x*2048)]
    else t:=map[chx][chy].blocks[y+((z+1)*128+(x*2048))];

    if (t in trans_bl)or(t=255) then east:=false
    else east:=true;

    if (east=false)and(west=false)and(south=false)and(north=false) then
    begin
      if data=2 then data_ch:=8
      else if data=3 then data_ch:=0
      else if data=4 then data_ch:=4
      else data_ch:=12;
      result:=place_sign_(map,xreg,yreg,chx,chy,x,y,z,12,false,text1,text2,text3,text4);
    end
    else
    begin
      data_ch:=0;

      if ((data=2)and(east=true))or
      ((data=3)and(west=true))or
      ((data=4)and(north=true))or
      ((data=5)and(south=true)) then
        data_ch:=data
      else
      begin
        if east=true then data_ch:=2
        else if west=true then data_ch:=3
        else if north=true then data_ch:=4
        else data_ch:=5;
      end;

      map[chx][chy].blocks[y+(z*128+(x*2048))]:=68;
    map[chx][chy].data[y+(z*128+(x*2048))]:=data_ch;

    t:=length(map[chx][chy].tile_entities);
    setlength(map[chx][chy].tile_entities,t+1);
    map[chx][chy].tile_entities[t].id:='Sign';
    map[chx][chy].tile_entities[t].x:=xreg*512+(chx-2)*16+x;
    map[chx][chy].tile_entities[t].y:=y;
    map[chx][chy].tile_entities[t].z:=yreg*512+(chy-2)*16+z;
    new(psign_tile_entity_data(map[chx][chy].tile_entities[t].dannie));
    psign_tile_entity_data(map[chx][chy].tile_entities[t].dannie)^.text[1]:=text1;
    psign_tile_entity_data(map[chx][chy].tile_entities[t].dannie)^.text[2]:=text2;
    psign_tile_entity_data(map[chx][chy].tile_entities[t].dannie)^.text[3]:=text3;
    psign_tile_entity_data(map[chx][chy].tile_entities[t].dannie)^.text[4]:=text4;
    end;
  end
  else
  begin
    if y<1 then
    begin
      result:=false;
      exit;
    end;
    //smotrim nizhniy blok
    t:=map[chx][chy].blocks[y-1+(z*128+(x*2048))];

    if (t in trans_bl) then
    begin
      result:=false;
      exit;
    end;

    map[chx][chy].blocks[y+(z*128+(x*2048))]:=63;
    map[chx][chy].data[y+(z*128+(x*2048))]:=data;

    t:=length(map[chx][chy].tile_entities);
    setlength(map[chx][chy].tile_entities,t+1);
    map[chx][chy].tile_entities[t].id:='Sign';
    map[chx][chy].tile_entities[t].x:=xreg*512+(chx-2)*16+x;
    map[chx][chy].tile_entities[t].y:=y;
    map[chx][chy].tile_entities[t].z:=yreg*512+(chy-2)*16+z;
    new(psign_tile_entity_data(map[chx][chy].tile_entities[t].dannie));
    psign_tile_entity_data(map[chx][chy].tile_entities[t].dannie)^.text[1]:=text1;
    psign_tile_entity_data(map[chx][chy].tile_entities[t].dannie)^.text[2]:=text2;
    psign_tile_entity_data(map[chx][chy].tile_entities[t].dannie)^.text[3]:=text3;
    psign_tile_entity_data(map[chx][chy].tile_entities[t].dannie)^.text[4]:=text4;
  end;
  result:=true;
end;

function place_sign(var map:region; xreg,yreg,x,y,z,data:integer; text1,text2,text3,text4:string; standing:boolean):boolean;
var tempxot,tempxdo,tempyot,tempydo:integer;
chx,chy,xx,yy,zz:integer;
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

      result:=place_sign_(map,xreg,yreg,chx,chy,xx,yy,zz,data,not(standing),text1,text2,text3,text4);
    end
    else result:=false;
end;

function gen_reed(var map:region; xreg,yreg,x,y,z:integer; sid:int64):boolean;
var rand:rnd;
a1,a2,a3,a4:integer;
i,r:integer;
begin
  if (get_block_id(map,xreg,yreg,x,y-1,z) in trans_bl) then
  begin
    result:=false;
    exit;
  end;

  a1:=get_block_id(map,xreg,yreg,x-1,y-1,z);
  a2:=get_block_id(map,xreg,yreg,x+1,y-1,z);
  a3:=get_block_id(map,xreg,yreg,x,y-1,z-1);
  a4:=get_block_id(map,xreg,yreg,x,y-1,z+1);

  if (a1=255)or(a2=255)or(a3=255)or(a4=255) then
  begin
    result:=false;
    exit;
  end;

  if (a1 in diff_bl)or(a2 in diff_bl)or(a3 in diff_bl)or(a4 in diff_bl) then
  begin
    rand:=rnd.Create(sid);
    r:=rand.nextInt(3)+2;
    rand.Free;

    for i:=0 to r-1 do
      if get_block_id(map,xreg,yreg,x,y+i,z)=0 then
        set_block_id(map,xreg,yreg,x,y+i,z,83)
      else break;
  end;
end;

function gen_palm(var map:region; xreg,yreg,x,y,z,tip:integer; sid:int64):boolean;
var rand:rnd;
i,j,k,r,t:integer;
begin
  rand:=rnd.Create(sid);
  r:=rand.nextInt(5)+3;
  rand.Free;

  for i:=x-1 to x+1 do
    for j:=z-1 to z+1 do
      for k:=y to y+r do
      begin
        t:=get_block_id(map,xreg,yreg,i,k,j);
        if (t=17)or(t=255) then
        begin
          result:=false;
          exit;
        end;
      end;

  i:=get_block_id(map,xreg,yreg,x,y-1,z);
  if not((i=3)or(i=2)or(i=12)) then
  begin
    result:=false;
    exit;
  end;

  if (i=3) then set_block_id(map,xreg,yreg,x,y-1,z,3);

  for i:=0 to r-1 do
    set_block_id(map,xreg,yreg,x,y+i,z,17); 

  if tip=0 then //s listyami
  begin
    set_block_id(map,xreg,yreg,x-1,y+r-1,z,18);
    set_block_id(map,xreg,yreg,x+1,y+r-1,z,18);
    set_block_id(map,xreg,yreg,x,y+r-1,z-1,18);
    set_block_id(map,xreg,yreg,x,y+r-1,z+1,18);
    set_block_id(map,xreg,yreg,x,y+r,z,18);
  end;
end;

procedure gen_mushroom(var map:region; xreg,yreg,x,y,z,tip:integer);
var chx,chy,xx,zz,yy:integer;
tempxot,tempxdo,tempyot,tempydo:integer;
begin
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
  //uslovie
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

    if (map[chx][chy].skylight[yy+(zz*128+(xx*2048))]<12)and
    (map[chx][chy].light[yy+(zz*128+(xx*2048))]<12)and
    (map[chx][chy].blocks[yy+(zz*128+(xx*2048))]=0) then
      if tip=2 then
      begin
        map[chx][chy].blocks[yy+(zz*128+(xx*2048))]:=39;
        if map[chx][chy].light[yy+(zz*128+(xx*2048))]=0 then
          map[chx][chy].light[yy+(zz*128+(xx*2048))]:=1;
      end
      else
        map[chx][chy].blocks[yy+(zz*128+(xx*2048))]:=40;
  end;
end;

function gen_schit(same:boolean; napravlenie:byte; map:region; rx,ry,x,y,z,id:byte; var verh,niz,levo,pravo,vpered,nazad:boolean; zamena_id:byte):integer;
  var k,t:integer;
  begin
    //smotrim, kakie sosednie bloki svobodni (gde kamen') i schitaem ih kol-vo
    verh:=false;
    niz:=false;
    levo:=false;
    pravo:=false;
    vpered:=false;
    nazad:=false;
    k:=0;
    case napravlenie of
    1:begin  //vverh
        if y<>127 then
        begin
          t:=map[rx][ry].blocks[y+1+(z*128+(x*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then verh:=true;
        end;

        if x=0 then
        begin
          t:=map[rx-1][ry].blocks[y+(z*128+(15*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then levo:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+(z*128+((x-1)*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then levo:=true;
        end;

        if x=15 then
        begin
          t:=map[rx+1][ry].blocks[y+(z*128)];
          if (t=zamena_id)or((t=id)and(same=true)) then pravo:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+(z*128+((x+1)*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then pravo:=true;
        end;

        if z=0 then
        begin
          t:=map[rx][ry-1].blocks[y+(15*128+(x*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then nazad:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+((z-1)*128+(x*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then nazad:=true;
        end;

        if z=15 then
        begin
          t:=map[rx][ry+1].blocks[y+(x*2048)];
          if (t=zamena_id)or((t=id)and(same=true)) then vpered:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+((z+1)*128+(x*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then vpered:=true;
        end;

        if verh=true then inc(k);
        if levo=true then inc(k);
        if pravo=true then inc(k);
        if vpered=true then inc(k);
        if nazad=true then inc(k);
      end;
    2:begin        //vniz
        if y<>0 then
        begin
          t:=map[rx][ry].blocks[y-1+(z*128+(x*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then niz:=true;
        end;

        if x=0 then
        begin
          t:=map[rx-1][ry].blocks[y+(z*128+(15*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then levo:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+(z*128+((x-1)*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then levo:=true;
        end;

        if x=15 then
        begin
          t:=map[rx+1][ry].blocks[y+(z*128)];
          if (t=zamena_id)or((t=id)and(same=true)) then pravo:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+(z*128+((x+1)*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then pravo:=true;
        end;

        if z=0 then
        begin
          t:=map[rx][ry-1].blocks[y+(15*128+(x*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then nazad:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+((z-1)*128+(x*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then nazad:=true;
        end;

        if z=15 then
        begin
          t:=map[rx][ry+1].blocks[y+(x*2048)];
          if (t=zamena_id)or((t=id)and(same=true)) then vpered:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+((z+1)*128+(x*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then vpered:=true;
        end;

        if niz=true then inc(k);
        if levo=true then inc(k);
        if pravo=true then inc(k);
        if vpered=true then inc(k);
        if nazad=true then inc(k);
      end;
    3:begin        //vlevo
        if y<>0 then
        begin
          t:=map[rx][ry].blocks[y-1+(z*128+(x*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then niz:=true;
        end;

        if y<>127 then
        begin
          t:=map[rx][ry].blocks[y+1+(z*128+(x*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then verh:=true;
        end;

        if x=0 then
        begin
          t:=map[rx-1][ry].blocks[y+(z*128+(15*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then levo:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+(z*128+((x-1)*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then levo:=true;
        end;

        if z=0 then
        begin
          t:=map[rx][ry-1].blocks[y+(15*128+(x*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then nazad:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+((z-1)*128+(x*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then nazad:=true;
        end;

        if z=15 then
        begin
          t:=map[rx][ry+1].blocks[y+(x*2048)];
          if (t=zamena_id)or((t=id)and(same=true)) then vpered:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+((z+1)*128+(x*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then vpered:=true;
        end;

        if verh=true then inc(k);
        if niz=true then inc(k);
        if levo=true then inc(k);
        if vpered=true then inc(k);
        if nazad=true then inc(k);
      end;
    4:begin        //vpravo
        if y<>0 then
        begin
          t:=map[rx][ry].blocks[y-1+(z*128+(x*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then niz:=true;
        end;

        if y<>127 then
        begin
          t:=map[rx][ry].blocks[y+1+(z*128+(x*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then verh:=true;
        end;

        if x=15 then
        begin
          t:=map[rx+1][ry].blocks[y+(z*128)];
          if (t=zamena_id)or((t=id)and(same=true)) then pravo:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+(z*128+((x+1)*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then pravo:=true;
        end;

        if z=0 then
        begin
          t:=map[rx][ry-1].blocks[y+(15*128+(x*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then nazad:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+((z-1)*128+(x*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then nazad:=true;
        end;

        if z=15 then
        begin
          t:=map[rx][ry+1].blocks[y+(x*2048)];
          if (t=zamena_id)or((t=id)and(same=true)) then vpered:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+((z+1)*128+(x*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then vpered:=true;
        end;

        if verh=true then inc(k);
        if niz=true then inc(k);
        if pravo=true then inc(k);
        if vpered=true then inc(k);
        if nazad=true then inc(k);
      end;
    5:begin        //vpered
        if y<>0 then
        begin
          t:=map[rx][ry].blocks[y-1+(z*128+(x*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then niz:=true;
        end;

        if y<>127 then
        begin
          t:=map[rx][ry].blocks[y+1+(z*128+(x*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then verh:=true;
        end;

        if x=0 then
        begin
          t:=map[rx-1][ry].blocks[y+(z*128+(15*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then levo:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+(z*128+((x-1)*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then levo:=true;
        end;

        if x=15 then
        begin
          t:=map[rx+1][ry].blocks[y+(z*128)];
          if (t=zamena_id)or((t=id)and(same=true)) then pravo:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+(z*128+((x+1)*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then pravo:=true;
        end;

        if z=15 then
        begin
          t:=map[rx][ry+1].blocks[y+(x*2048)];
          if (t=zamena_id)or((t=id)and(same=true)) then vpered:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+((z+1)*128+(x*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then vpered:=true;
        end;

        if verh=true then inc(k);
        if niz=true then inc(k);
        if levo=true then inc(k);
        if pravo=true then inc(k);
        if vpered=true then inc(k);
      end;
    6:begin        //nazad
        if y<>0 then
        begin
          t:=map[rx][ry].blocks[y-1+(z*128+(x*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then niz:=true;
        end;

        if y<>127 then
        begin
          t:=map[rx][ry].blocks[y+1+(z*128+(x*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then verh:=true;
        end;

        if x=0 then
        begin
          t:=map[rx-1][ry].blocks[y+(z*128+(15*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then levo:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+(z*128+((x-1)*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then levo:=true;
        end;

        if x=15 then
        begin
          t:=map[rx+1][ry].blocks[y+(z*128)];
          if (t=zamena_id)or((t=id)and(same=true)) then pravo:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+(z*128+((x+1)*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then pravo:=true;
        end;

        if z=0 then
        begin
          t:=map[rx][ry-1].blocks[y+(15*128+(x*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then nazad:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+((z-1)*128+(x*2048))];
          if (t=zamena_id)or((t=id)and(same=true)) then nazad:=true;
        end;

        if verh=true then inc(k);
        if niz=true then inc(k);
        if levo=true then inc(k);
        if pravo=true then inc(k);
        if nazad=true then inc(k);
      end;
    end;
    result:=k;
  end;

  function gen_recur(napravlenie:byte; var map:region; rx,ry,x,y,z,id,tip:integer; count:integer; var r:rnd; zamena_id:byte):integer;
  var verh,niz,levo,pravo,vpered,nazad:boolean;
  i,j,k,xxr,yyr,zzr,xx,yy,zz:integer;
  koef:array[1..6]of double; //verh,niz,levo,pravo,pered,zad
  znach:array[1..6]of double;
  sum:extended;
  b:boolean;
  begin
    case tip of
    0:begin  //obichnoe rasprostranenie
        //uslovie vihoda
        if count<=0 then
        begin
          result:=0;
          exit;
        end;

        if map[rx][ry].blocks[y+(z*128+(x*2048))]=id then
        begin
          b:=true;
          //inc(count);
        end
        else b:=false;

        //prisvaivaem blok
        map[rx][ry].blocks[y+(z*128+(x*2048))]:=id;
        dec(count);

        if count=0 then
        begin
          result:=1;
          exit;
        end;

        //schitaem sosednie bloki
        k:=gen_schit(true,napravlenie,map,rx,ry,x,y,z,id,verh,niz,levo,pravo,vpered,nazad,zamena_id);

        if k=0 then exit;

        {sum:=0;
        while (sum<0.5)or(sum>0.7) do
          sum:=r.nextDouble;  }

        {if verh=true then koef[1]:=r.nextDouble else koef[1]:=0;
        if niz=true then koef[2]:=r.nextDouble else koef[2]:=0;
        if levo=true then koef[3]:=r.nextDouble else koef[3]:=0;
        if pravo=true then koef[4]:=r.nextDouble else koef[4]:=0;
        if vpered=true then koef[5]:=r.nextDouble else koef[5]:=0;
        if nazad=true then koef[6]:=r.nextDouble else koef[6]:=0; }

        if verh=true then koef[1]:=random else koef[1]:=0;
        if niz=true then koef[2]:=random else koef[2]:=0;
        if levo=true then koef[3]:=random else koef[3]:=0;
        if pravo=true then koef[4]:=random else koef[4]:=0;
        if vpered=true then koef[5]:=random else koef[5]:=0;
        if nazad=true then koef[6]:=random else koef[6]:=0;

        //delaem koeficent po napravleniyu maksimalnim
        {sum:=koef[1];
        k:=1;
        for i:=2 to 6 do
          if koef[i]>sum then
          begin
            sum:=koef[i];
            k:=i;
          end;

        koef[k]:=koef[napravlenie];
        koef[napravlenie]:=sum;   }

        {for i:=1 to 6 do
          if i<>napravlenie then koef[i]:=koef[i]/1.5; }

        if count<=k then
        begin
          sum:=0;
          for i:=1 to 6 do
            znach[i]:=0;

          while sum<>count do
          begin
            k:=random(6)+1;
            if koef[k]<>0 then
            begin
              znach[k]:=znach[k]+1;
              sum:=sum+1;
            end;
          end;
        end
        else
        begin

        sum:=0;
        for i:=1 to 6 do
        begin
          znach[i]:=koef[i];
          sum:=sum+znach[i];
        end;

        while sum<count do
        begin
          sum:=0;
          for i:=1 to 6 do
          begin
            znach[i]:=znach[i]+koef[i];
            sum:=sum+znach[i];
          end;
        end;

        sum:=0;
        for i:=1 to 6 do
        begin
          znach[i]:=trunc(znach[i]);
          sum:=sum+znach[i];
        end;

        if sum=0 then
        begin
          if (koef[napravlenie]<>0) then
            znach[napravlenie]:=1
          else
            while sum=0 do
            begin
              k:=random(6)+1;
              if koef[k]<>0 then
              begin
                znach[k]:=1;
                sum:=1;
              end;
            end;
          sum:=1;
        end;

        k:=abs(round(sum-count));

        repeat
        if sum>count then
        begin
          for i:=1 to 6 do
          if (znach[i]<>0)and(k>0) then
          begin
            znach[i]:=znach[i]-1;
            dec(k);
          end;
        end
        else if sum<count then
        begin
          for i:=1 to 6 do
          if (znach[i]<>0)and(k>0) then
          begin
            znach[i]:=znach[i]+1;
            dec(k);
          end;
        end;
        until k=0;

        end;

        if b=true then sum:=0
        else
        sum:=1;
        //vizivaem rekursiyu
        case napravlenie of
        1:begin    //verh
            if y<>127 then sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y+1,z,id,tip,trunc(znach[1]),r,zamena_id);

            if x=0 then sum:=sum+gen_recur(napravlenie,map,rx-1,ry,15,y,z,id,tip,trunc(znach[3]),r,zamena_id)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x-1,y,z,id,tip,trunc(znach[3]),r,zamena_id);

            if x=15 then sum:=sum+gen_recur(napravlenie,map,rx+1,ry,0,y,z,id,tip,trunc(znach[4]),r,zamena_id)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x+1,y,z,id,tip,trunc(znach[4]),r,zamena_id);

            if z=15 then sum:=sum+gen_recur(napravlenie,map,rx,ry+1,x,y,0,id,tip,trunc(znach[5]),r,zamena_id)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y,z+1,id,tip,trunc(znach[5]),r,zamena_id);

            if z=0 then sum:=sum+gen_recur(napravlenie,map,rx,ry-1,x,y,15,id,tip,trunc(znach[6]),r,zamena_id)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y,z-1,id,tip,trunc(znach[6]),r,zamena_id);
          end;
        2:begin    //niz
            if y<>0 then sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y-1,z,id,tip,trunc(znach[2]),r,zamena_id);

            if x=0 then sum:=sum+gen_recur(napravlenie,map,rx-1,ry,15,y,z,id,tip,trunc(znach[3]),r,zamena_id)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x-1,y,z,id,tip,trunc(znach[3]),r,zamena_id);

            if x=15 then sum:=sum+gen_recur(napravlenie,map,rx+1,ry,0,y,z,id,tip,trunc(znach[4]),r,zamena_id)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x+1,y,z,id,tip,trunc(znach[4]),r,zamena_id);

            if z=15 then sum:=sum+gen_recur(napravlenie,map,rx,ry+1,x,y,0,id,tip,trunc(znach[5]),r,zamena_id)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y,z+1,id,tip,trunc(znach[5]),r,zamena_id);

            if z=0 then sum:=sum+gen_recur(napravlenie,map,rx,ry-1,x,y,15,id,tip,trunc(znach[6]),r,zamena_id)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y,z-1,id,tip,trunc(znach[6]),r,zamena_id);
          end;
        3:begin    //levo
            if y<>127 then sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y+1,z,id,tip,trunc(znach[1]),r,zamena_id);

            if y<>0 then sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y-1,z,id,tip,trunc(znach[2]),r,zamena_id);

            if x=0 then sum:=sum+gen_recur(napravlenie,map,rx-1,ry,15,y,z,id,tip,trunc(znach[3]),r,zamena_id)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x-1,y,z,id,tip,trunc(znach[3]),r,zamena_id);

            if z=15 then sum:=sum+gen_recur(napravlenie,map,rx,ry+1,x,y,0,id,tip,trunc(znach[5]),r,zamena_id)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y,z+1,id,tip,trunc(znach[5]),r,zamena_id);

            if z=0 then sum:=sum+gen_recur(napravlenie,map,rx,ry-1,x,y,15,id,tip,trunc(znach[6]),r,zamena_id)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y,z-1,id,tip,trunc(znach[6]),r,zamena_id);
          end;
        4:begin    //pravo
            if y<>127 then sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y+1,z,id,tip,trunc(znach[1]),r,zamena_id);

            if y<>0 then sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y-1,z,id,tip,trunc(znach[2]),r,zamena_id);

            if x=15 then sum:=sum+gen_recur(napravlenie,map,rx+1,ry,0,y,z,id,tip,trunc(znach[4]),r,zamena_id)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x+1,y,z,id,tip,trunc(znach[4]),r,zamena_id);

            if z=15 then sum:=sum+gen_recur(napravlenie,map,rx,ry+1,x,y,0,id,tip,trunc(znach[5]),r,zamena_id)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y,z+1,id,tip,trunc(znach[5]),r,zamena_id);

            if z=0 then sum:=sum+gen_recur(napravlenie,map,rx,ry-1,x,y,15,id,tip,trunc(znach[6]),r,zamena_id)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y,z-1,id,tip,trunc(znach[6]),r,zamena_id);
          end;
        5:begin    //vpered
            if y<>127 then sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y+1,z,id,tip,trunc(znach[1]),r,zamena_id);

            if y<>0 then sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y-1,z,id,tip,trunc(znach[2]),r,zamena_id);

            if x=0 then sum:=sum+gen_recur(napravlenie,map,rx-1,ry,15,y,z,id,tip,trunc(znach[3]),r,zamena_id)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x-1,y,z,id,tip,trunc(znach[3]),r,zamena_id);

            if x=15 then sum:=sum+gen_recur(napravlenie,map,rx+1,ry,0,y,z,id,tip,trunc(znach[4]),r,zamena_id)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x+1,y,z,id,tip,trunc(znach[4]),r,zamena_id);

            if z=15 then sum:=sum+gen_recur(napravlenie,map,rx,ry+1,x,y,0,id,tip,trunc(znach[5]),r,zamena_id)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y,z+1,id,tip,trunc(znach[5]),r,zamena_id);
          end;
        6:begin    //nazad
            if y<>127 then sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y+1,z,id,tip,trunc(znach[1]),r,zamena_id);

            if y<>0 then sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y-1,z,id,tip,trunc(znach[2]),r,zamena_id);

            if x=0 then sum:=sum+gen_recur(napravlenie,map,rx-1,ry,15,y,z,id,tip,trunc(znach[3]),r,zamena_id)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x-1,y,z,id,tip,trunc(znach[3]),r,zamena_id);

            if x=15 then sum:=sum+gen_recur(napravlenie,map,rx+1,ry,0,y,z,id,tip,trunc(znach[4]),r,zamena_id)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x+1,y,z,id,tip,trunc(znach[4]),r,zamena_id);

            if z=0 then sum:=sum+gen_recur(napravlenie,map,rx,ry-1,x,y,15,id,tip,trunc(znach[6]),r,zamena_id)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y,z-1,id,tip,trunc(znach[6]),r,zamena_id);
          end;
        end;
        result:=trunc(sum);
      end;
    1:begin  //rasprostranenie po poverhnosti
        result:=0;
        if count<=5 then exit;
        //sozdaetsa ellips
        //delaem randomnie radiusi
        xxr:=r.nextInt(count-10)+10;
        yyr:=(r.nextInt(count-10)+10)shr 2;
        zzr:=r.nextInt(count-10)+10;

        //vichislaem koordinati centra po y
        i:=0;
        for j:=y+1 to y+yyr*2-2 do
          if get_block_id(map,-1,-1,x,j,z)=1 then inc(i);

        if i>3 then yyr:=(yyr*2-i+3)div 2;
        yy:=y-2+yyr;

        zz:=z;
        xx:=x;

        //izmenaem radius po x
        i:=0;
        for j:=xx downto xx-xxr do
          if get_block_id(map,-1,-1,j,yy,zz)=1 then inc(i);
        if i>3 then xxr:=xxr-(i-3);
        i:=0;
        for j:=xx to xx+xxr do
          if get_block_id(map,-1,-1,j,yy,zz)=1 then inc(i);
        if i>3 then xxr:=xxr-(i-3);

        //izmenaem radius po z
        i:=0;
        for j:=zz downto zz-zzr do
          if get_block_id(map,-1,-1,xx,yy,j)=1 then inc(i);
        if i>3 then zzr:=zzr-(i-3);
        i:=0;
        for j:=zz to zz+zzr do
          if get_block_id(map,-1,-1,xx,yy,j)=1 then inc(i);
        if i>3 then zzr:=zzr-(i-3);

        if (xxr<5)or(yyr<3)or(zzr<5) then exit;

        result:=result+1;

        for i:=xx-xxr to xx+xxr do
          for k:=zz-zzr to zz+zzr do
            begin
              sum:=sqr(yyr)*(1-sqr((i-xx)/xxr)-sqr((k-zz)/zzr));
              if sum<0 then continue;
              for j:=round(yy-sqrt(sum)) to round(yy+sqrt(sum)) do
                if get_block_id(map,-1,-1,i,j,k)<>0 then
                  if (id=3)and(get_block_id(map,-1,-1,i,j+1,k)=0) then
                    set_block_id(map,-1,-1,i,j,k,2)
                  else
                    set_block_id(map,-1,-1,i,j,k,id);
            end;

      end;
    end;
  end;

procedure gen_resourses3(var map:region; xreg,yreg:integer; pr_res:ar_tlights_koord; tip:byte; sid:int64; zamena_id:byte);

  procedure gen_stal(var map:region; chx,chy,x,y,z,id:integer; r:rnd);
  var minim,maxim:integer;
  rmin,rmax:integer;
  i,t:integer;
  b:boolean;
  begin
    //opredelaem minimum i maksimum v dannoy koordinate
    if map[chx][chy].blocks[y-1+(z*128+(x*2048))]=0 then dec(y)
    else inc(y);
    i:=y;
    //minimum
    b:=false;
    while b=false do
    begin
      t:=map[chx][chy].blocks[i+(z*128+(x*2048))];
      //if (t<>0)and(t<>1) then map[chx][chy].blocks[i+(z*128+(x*2048))]:=0;
      if (t<>0)and(t=1) then b:=true;
      dec(i);
    end;
    minim:=i+1;
    //maximum
    i:=y;
    b:=false;
    while b=false do
    begin
      t:=map[chx][chy].blocks[i+(z*128+(x*2048))];
      //if (t<>0)and(t<>1) then map[chx][chy].blocks[i+(z*128+(x*2048))]:=0;
      if (t<>0)and(t=1) then b:=true;
      inc(i);
    end;
    maxim:=i-1;

    if (maxim-minim)<6 then exit;

    t:=r.nextInt(100);
    if (t<33) then  //tolko verhniy
    begin
      rmin:=0;
      rmax:=r.nextInt(((maxim-minim)div 2)-3)+3;
    end
    else if (t>=33)and(t<66) then    //tolko nizhniy
    begin
      rmin:=r.nextInt(((maxim-minim)div 2)-3)+3;
      rmax:=0;
    end
    else     //oba
    begin
      rmax:=r.nextInt(((maxim-minim)div 2)-3)+3;
      rmin:=r.nextInt(((maxim-minim)div 2)-3)+3;
    end;

    for i:=minim to minim+rmin-1 do
      map[chx][chy].blocks[i+(z*128+(x*2048))]:=id;

    for i:=maxim downto maxim-rmax+1 do
      map[chx][chy].blocks[i+(z*128+(x*2048))]:=id;
  end;

  procedure gen_tikvi(var map:region; xreg,yreg,x,y,z,id,max_rad:integer; r:rnd);
  var i,j,k,xx,yy,zz,t,t1:integer;
  b:boolean;
  sides:set_trans_blocks;
  begin
    if max_rad<3 then max_rad:=3;
    //vichislaem budushie radiusi
    xx:=r.nextint(max_rad-2)+3;
    yy:=r.nextInt(max_rad-2)+3+r.nextInt(max_rad);
    zz:=r.nextint(max_rad-2)+3;

    //cikli po oblasti    
    for i:=x-xx to x+xx do   //X
      for k:=z-zz to z+zz do    //Z
      begin
        b:=false;
        for j:=y+yy downto y-yy do  //Y
        begin
          t:=get_block_id(map,xreg,yreg,i,j,k);
          if (t=1)and(b=false) then continue
          else if (t=0)and(b=false) then b:=true
          else if (t=1)and(b=true) then
          begin
            if r.nextDouble<0.05 then
            begin
              sides:=[];
              if get_block_id(map,xreg,yreg,i,j+1,k+1)=0 then include(sides,0);
              if get_block_id(map,xreg,yreg,i,j+1,k-1)=0 then include(sides,2);
              if get_block_id(map,xreg,yreg,i+1,j+1,k)=0 then include(sides,3);
              if get_block_id(map,xreg,yreg,i-1,j+1,k)=0 then include(sides,1);
              if sides=[] then sides:=[0,1,2,3];
              t1:=r.nextInt(4);
              while not(t1 in sides) do
                t1:=r.nextInt(4);
              set_block_id_data(map,xreg,yreg,i,j+1,k,id,t1);
            end;
            break;
          end;
        end;
      end;
  end;

var tempxot,tempxdo,tempyot,tempydo:integer;
i,t,count:integer;
chx,chy,x,y,z:integer;
r:rnd;
begin
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

  dec(tempxot);
  dec(tempxdo,3);
  dec(tempyot);
  dec(tempydo,3);

  if tip=1 then
  begin
    dec(tempxot);
    dec(tempyot);
    inc(tempxdo);
    inc(tempydo);
  end;

  for i:=0 to length(pr_res)-1 do
  begin
    //opredelaem, k kakomu chanku otnositsa
    chx:=pr_res[i].x;
    chy:=pr_res[i].z;

    if chx<0 then inc(chx);
    if chy<0 then inc(chy);

    chx:=chx div 16;
    chy:=chy div 16;

    if (chx<=0)and(pr_res[i].x<0) then dec(chx);
    if (chy<=0)and(pr_res[i].z<0) then dec(chy);

    //uslovie
    if (chx>=tempxot)and(chx<=tempxdo)and(chy>=tempyot)and(chy<=tempydo) then
    begin
      //perevodim v koordinati chanka
      x:=pr_res[i].x mod 16;
      z:=pr_res[i].z mod 16;
      if x<0 then inc(x,16);
      if z<0 then inc(z,16);
      y:=pr_res[i].y;
      //perevodim koordinati chanka v koordinati otnositelno regiona
      chx:=chx-tempxot+1;
      chy:=chy-tempyot+1;

      //vizov otrisovki
      if tip=0 then
      begin
        if map[chx][chy].blocks[y+(z*128+(x*2048))]<>1 then continue;

        r:=rnd.Create(sid);

        {t:=random(100);
        case t of
        0..7:begin
               id:=14;   //Gold
               count:=25;
             end;
        8..37:begin
                id:=15;  //Iron
                count:=25;
              end;
        38..75:begin
                 id:=16;  //Coal
                 count:=100;
               end;
        76..79:begin
                 id:=21;  //Lapiz
                 count:=15;
               end;
        80..95:begin
                 if random<0.1 then id:=73 else id:=74;  //Redstone
                 count:=20;
               end;
        96..99:begin
                 id:=56;  //Dimond
                 count:=15;
               end;
        end;      }
        case pr_res[i].id of
          14,15:count:=25;
          16:count:=100;
          21,56:count:=15;
          73,74:count:=20;
        end;

        if pr_res[i].id=82 then
        begin
          r.SetSeed(pr_res[i].x*1234+pr_res[i].y*2467+pr_res[i].z*3467);
          gen_stal(map,chx,chy,x,y,z,pr_res[i].id,r);
        end
        else if (pr_res[i].id=86)and(chx>1)and(chx<34)and(chy>1)and(chy<34) then
        begin
          r.SetSeed(pr_res[i].x*1234+pr_res[i].y*2467+pr_res[i].z*3467);
          gen_tikvi(map,xreg,yreg,pr_res[i].x,pr_res[i].y,pr_res[i].z,pr_res[i].id,r.nextInt(10),r);
        end
        else
        begin
        if get_block_id(map,xreg,yreg,pr_res[i].x,pr_res[i].y+1,pr_res[i].z)=1 then
          gen_recur(1,map,chx,chy,x,y,z,pr_res[i].id,0,count,r,zamena_id);

        if get_block_id(map,xreg,yreg,pr_res[i].x,pr_res[i].y-1,pr_res[i].z)=1 then
          gen_recur(2,map,chx,chy,x,y,z,pr_res[i].id,0,count,r,zamena_id);

        if get_block_id(map,xreg,yreg,pr_res[i].x-1,pr_res[i].y,pr_res[i].z)=1 then
          gen_recur(3,map,chx,chy,x,y,z,pr_res[i].id,0,count,r,zamena_id);

        if get_block_id(map,xreg,yreg,pr_res[i].x+1,pr_res[i].y,pr_res[i].z)=1 then
          gen_recur(4,map,chx,chy,x,y,z,pr_res[i].id,0,count,r,zamena_id);

        if get_block_id(map,xreg,yreg,pr_res[i].x,pr_res[i].y,pr_res[i].z+1)=1 then
          gen_recur(5,map,chx,chy,x,y,z,pr_res[i].id,0,count,r,zamena_id);

        if get_block_id(map,xreg,yreg,pr_res[i].x,pr_res[i].y,pr_res[i].z-1)=1 then
          gen_recur(6,map,chx,chy,x,y,z,pr_res[i].id,0,count,r,zamena_id);
        end;

        r.Free;
      end;

      if tip=1 then
      begin
        r:=rnd.create(sid+i);

        t:=r.nextInt(21)+10;

        gen_recur(1,map,0,0,pr_res[i].x,pr_res[i].y,pr_res[i].z,3,1,t,r,zamena_id);

        r.free;
      end;
      //map[chx][chy].blocks[y+(z*128+(x*2048))]:=20;
    end;
  end;
end;

function gen_vipuklost(var map:region; xreg,yreg,x,y,z:integer):boolean;
var i,j:integer;
b:boolean;
begin
  if (get_block_id(map,xreg,yreg,x,y-1,z) in trans_bl) then
  begin
    result:=false;
    exit;
  end;

  b:=true;
  for i:=x-1 to x+1 do
    for j:=z-1 to z+1 do
    begin
      if (i=x)and(j=z) then continue;
      if get_block_id(map,xreg,yreg,i,y,j)<>0 then
      begin
        b:=false;
        break;
      end;
    end;

  if b=false then
  begin
    result:=false;
    exit;
  end;

  set_block_id(map,xreg,yreg,x,y,z,2);
  set_block_id_data(map,xreg,yreg,x,y,z-1,106,1);
  set_block_id_data(map,xreg,yreg,x+1,y,z,106,2);
  set_block_id_data(map,xreg,yreg,x,y,z+1,106,4);
  set_block_id_data(map,xreg,yreg,x-1,y,z,106,8);
end;

procedure fill_planet_chunks(var ar_el:ar_planets_settings);
var k,tempx,tempy,tempk,tempz,i,j,z:integer;
begin
  for k:=0 to length(ar_el)-1 do
  begin
    //opredelaem kraynie koordinati po dvum osam
      tempx:=ar_el[k].x-ar_el[k].radius;
      tempk:=ar_el[k].x+ar_el[k].radius;
      tempy:=ar_el[k].z-ar_el[k].radius;
      tempz:=ar_el[k].z+ar_el[k].radius;

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

      //zapisivaem massiv koordinat v tekushuyu zapis'
      //popravka na minusovie chanki
      if (tempx<=0)and((ar_el[k].x-ar_el[k].radius)<0) then tempx:=tempx-1;
      if (tempk<=0)and((ar_el[k].x+ar_el[k].radius)<0) then tempk:=tempk-1;
      if (tempy<=0)and((ar_el[k].z-ar_el[k].radius)<0) then tempy:=tempy-1;
      if (tempz<=0)and((ar_el[k].z+ar_el[k].radius)<0) then tempz:=tempz-1;

      //videlaem pamat'
      setlength(ar_el[k].chunks,(tempk-tempx+1)*(tempz-tempy+1));

      //zapisivaem
      z:=0;
      for i:=tempx to tempk do
        for j:=tempy to tempz do
        begin
          ar_el[k].chunks[z].x:=i;
          ar_el[k].chunks[z].y:=j;
          inc(z);
        end;
  end;
end;

procedure calc_blocklight(var map:region;otx,oty,dox,doy:integer);

  procedure recur(napravlenie:byte; svet:shortint;var map:region;rx,ry,i,j,k:byte);
  begin   
    //if map[rx][ry].light[k+(j*128+(i*2048))]>svet then exit;
    if (map[rx][ry].blocks[k+(j*128+(i*2048))] in diff_bl) then svet:=svet-2;
    if svet<0 then svet:=0;

    map[rx][ry].light[k+(j*128+(i*2048))]:=svet;

    if svet<=1 then exit;
    case napravlenie of
    1:begin   //vverh
        if k>=127 then exit;

        //idem vverh
        if (map[rx][ry].blocks[k+1+(j*128+(i*2048))] in trans_bl)and
        (map[rx][ry].light[k+1+(j*128+(i*2048))]<(svet-1)) then
          recur(napravlenie,svet-1,map,rx,ry,i,j,k+1);

        //idem vlevo
        if i=0 then  //granica chanka
        begin
          if (map[rx-1][ry].blocks[k+(j*128+(15*2048))] in trans_bl)and
          (map[rx-1][ry].light[k+(j*128+(15*2048))]<(svet-1)) then
            recur(napravlenie,svet-1,map,rx-1,ry,15,j,k);
        end
        else
          if (map[rx][ry].blocks[k+(j*128+((i-1)*2048))] in trans_bl)and
          (map[rx][ry].light[k+(j*128+((i-1)*2048))]<(svet-1)) then
            recur(napravlenie,svet-1,map,rx,ry,i-1,j,k);

        //idem vpravo
        if i=15 then
        begin
          if (map[rx+1][ry].blocks[k+(j*128)] in trans_bl)and
          (map[rx+1][ry].light[k+(j*128)]<(svet-1)) then
            recur(napravlenie,svet-1,map,rx+1,ry,0,j,k);
        end
        else
          if (map[rx][ry].blocks[k+(j*128+((i+1)*2048))] in trans_bl)and
          (map[rx][ry].light[k+(j*128+((i+1)*2048))]<(svet-1))then
            recur(napravlenie,svet-1,map,rx,ry,i+1,j,k);

        //idem vpered
        if j=15 then
        begin
          if (map[rx][ry+1].blocks[k+(i*2048)] in trans_bl)and
          (map[rx][ry+1].light[k+(i*2048)]<(svet-1))then
            recur(napravlenie,svet-1,map,rx,ry+1,i,0,k);
        end
        else
          if (map[rx][ry].blocks[k+((j+1)*128+(i*2048))] in trans_bl)and
          (map[rx][ry].light[k+((j+1)*128+(i*2048))]<(svet-1))then
            recur(napravlenie,svet-1,map,rx,ry,i,j+1,k);

        //idem nazad
        if j=0 then
        begin
          if (map[rx][ry-1].blocks[k+(15*128+(i*2048))] in trans_bl)and
          (map[rx][ry-1].light[k+(15*128+(i*2048))]<(svet-1))then
            recur(napravlenie,svet-1,map,rx,ry-1,i,15,k);
        end
        else
          if (map[rx][ry].blocks[k+((j-1)*128+(i*2048))] in trans_bl)and
          (map[rx][ry].light[k+((j-1)*128+(i*2048))]<(svet-1)) then
            recur(napravlenie,svet-1,map,rx,ry,i,j-1,k);
      end;
    2:begin   //niz
        if k<=0 then exit;

        //idem vniz
        if (map[rx][ry].blocks[k-1+(j*128+(i*2048))] in trans_bl)and
        (map[rx][ry].light[k-1+(j*128+(i*2048))]<(svet-1))then
          recur(napravlenie,svet-1,map,rx,ry,i,j,k-1);

        //idem vlevo
        if i=0 then  //granica chanka
        begin
          if (map[rx-1][ry].blocks[k+(j*128+(15*2048))] in trans_bl)and
          (map[rx-1][ry].light[k+(j*128+(15*2048))]<(svet-1)) then
            recur(napravlenie,svet-1,map,rx-1,ry,15,j,k);
        end
        else
          if (map[rx][ry].blocks[k+(j*128+((i-1)*2048))] in trans_bl)and
          (map[rx][ry].light[k+(j*128+((i-1)*2048))]<(svet-1)) then
            recur(napravlenie,svet-1,map,rx,ry,i-1,j,k);

        //idem vpravo
        if i=15 then
        begin
          if (map[rx+1][ry].blocks[k+(j*128)] in trans_bl)and
          (map[rx+1][ry].light[k+(j*128)]<(svet-1)) then
            recur(napravlenie,svet-1,map,rx+1,ry,0,j,k);
        end
        else
          if (map[rx][ry].blocks[k+(j*128+((i+1)*2048))] in trans_bl)and
          (map[rx][ry].light[k+(j*128+((i+1)*2048))]<(svet-1))then
            recur(napravlenie,svet-1,map,rx,ry,i+1,j,k);

        //idem vpered
        if j=15 then
        begin
          if (map[rx][ry+1].blocks[k+(i*2048)] in trans_bl)and
          (map[rx][ry+1].light[k+(i*2048)]<(svet-1))then
            recur(napravlenie,svet-1,map,rx,ry+1,i,0,k);
        end
        else
          if (map[rx][ry].blocks[k+((j+1)*128+(i*2048))] in trans_bl)and
          (map[rx][ry].light[k+((j+1)*128+(i*2048))]<(svet-1))then
            recur(napravlenie,svet-1,map,rx,ry,i,j+1,k);

        //idem nazad
        if j=0 then
        begin
          if (map[rx][ry-1].blocks[k+(15*128+(i*2048))] in trans_bl)and
          (map[rx][ry-1].light[k+(15*128+(i*2048))]<(svet-1))then
            recur(napravlenie,svet-1,map,rx,ry-1,i,15,k);
        end
        else
          if (map[rx][ry].blocks[k+((j-1)*128+(i*2048))] in trans_bl)and
          (map[rx][ry].light[k+((j-1)*128+(i*2048))]<(svet-1)) then
            recur(napravlenie,svet-1,map,rx,ry,i,j-1,k);
      end;
    3:begin   //levo
        //idem vlevo
        if i=0 then  //granica chanka
        begin
          if (map[rx-1][ry].blocks[k+(j*128+(15*2048))] in trans_bl)and
          (map[rx-1][ry].light[k+(j*128+(15*2048))]<(svet-1)) then
            recur(napravlenie,svet-1,map,rx-1,ry,15,j,k);
        end
        else
          if (map[rx][ry].blocks[k+(j*128+((i-1)*2048))] in trans_bl)and
          (map[rx][ry].light[k+(j*128+((i-1)*2048))]<(svet-1)) then
            recur(napravlenie,svet-1,map,rx,ry,i-1,j,k);

        //idem vpered
        if j=15 then
        begin
          if (map[rx][ry+1].blocks[k+(i*2048)] in trans_bl)and
          (map[rx][ry+1].light[k+(i*2048)]<(svet-1))then
            recur(napravlenie,svet-1,map,rx,ry+1,i,0,k);
        end
        else
          if (map[rx][ry].blocks[k+((j+1)*128+(i*2048))] in trans_bl)and
          (map[rx][ry].light[k+((j+1)*128+(i*2048))]<(svet-1))then
            recur(napravlenie,svet-1,map,rx,ry,i,j+1,k);

        //idem nazad
        if j=0 then
        begin
          if (map[rx][ry-1].blocks[k+(15*128+(i*2048))] in trans_bl)and
          (map[rx][ry-1].light[k+(15*128+(i*2048))]<(svet-1))then
            recur(napravlenie,svet-1,map,rx,ry-1,i,15,k);
        end
        else
          if (map[rx][ry].blocks[k+((j-1)*128+(i*2048))] in trans_bl)and
          (map[rx][ry].light[k+((j-1)*128+(i*2048))]<(svet-1)) then
            recur(napravlenie,svet-1,map,rx,ry,i,j-1,k);

        //idem vverh
        if k<127 then
          if (map[rx][ry].blocks[k+1+(j*128+(i*2048))] in trans_bl)and
          (map[rx][ry].light[k+1+(j*128+(i*2048))]<(svet-1)) then
            recur(napravlenie,svet-1,map,rx,ry,i,j,k+1);

        //idem vniz
        if k>0 then
          if (map[rx][ry].blocks[k-1+(j*128+(i*2048))] in trans_bl)and
          (map[rx][ry].light[k-1+(j*128+(i*2048))]<(svet-1))then
            recur(napravlenie,svet-1,map,rx,ry,i,j,k-1);
      end;
    4:begin   //pravo
        //idem vpravo
        if i=15 then
        begin
          if (map[rx+1][ry].blocks[k+(j*128)] in trans_bl)and
          (map[rx+1][ry].light[k+(j*128)]<(svet-1)) then
            recur(napravlenie,svet-1,map,rx+1,ry,0,j,k);
        end
        else
          if (map[rx][ry].blocks[k+(j*128+((i+1)*2048))] in trans_bl)and
          (map[rx][ry].light[k+(j*128+((i+1)*2048))]<(svet-1))then
            recur(napravlenie,svet-1,map,rx,ry,i+1,j,k);

        //idem vpered
        if j=15 then
        begin
          if (map[rx][ry+1].blocks[k+(i*2048)] in trans_bl)and
          (map[rx][ry+1].light[k+(i*2048)]<(svet-1))then
            recur(napravlenie,svet-1,map,rx,ry+1,i,0,k);
        end
        else
          if (map[rx][ry].blocks[k+((j+1)*128+(i*2048))] in trans_bl)and
          (map[rx][ry].light[k+((j+1)*128+(i*2048))]<(svet-1))then
            recur(napravlenie,svet-1,map,rx,ry,i,j+1,k);

        //idem nazad
        if j=0 then
        begin
          if (map[rx][ry-1].blocks[k+(15*128+(i*2048))] in trans_bl)and
          (map[rx][ry-1].light[k+(15*128+(i*2048))]<(svet-1))then
            recur(napravlenie,svet-1,map,rx,ry-1,i,15,k);
        end
        else
          if (map[rx][ry].blocks[k+((j-1)*128+(i*2048))] in trans_bl)and
          (map[rx][ry].light[k+((j-1)*128+(i*2048))]<(svet-1)) then
            recur(napravlenie,svet-1,map,rx,ry,i,j-1,k);

        //idem vverh
        if k<127 then
          if (map[rx][ry].blocks[k+1+(j*128+(i*2048))] in trans_bl)and
          (map[rx][ry].light[k+1+(j*128+(i*2048))]<(svet-1)) then
            recur(napravlenie,svet-1,map,rx,ry,i,j,k+1);

        //idem vniz
        if k>0 then
          if (map[rx][ry].blocks[k-1+(j*128+(i*2048))] in trans_bl)and
          (map[rx][ry].light[k-1+(j*128+(i*2048))]<(svet-1))then
            recur(napravlenie,svet-1,map,rx,ry,i,j,k-1);
      end;
    5:begin   //pered
        //idem vpered
        if j=15 then
        begin
          if (map[rx][ry+1].blocks[k+(i*2048)] in trans_bl)and
          (map[rx][ry+1].light[k+(i*2048)]<(svet-1))then
            recur(napravlenie,svet-1,map,rx,ry+1,i,0,k);
        end
        else
          if (map[rx][ry].blocks[k+((j+1)*128+(i*2048))] in trans_bl)and
          (map[rx][ry].light[k+((j+1)*128+(i*2048))]<(svet-1))then
            recur(napravlenie,svet-1,map,rx,ry,i,j+1,k);

        //idem vlevo
        if i=0 then  //granica chanka
        begin
          if (map[rx-1][ry].blocks[k+(j*128+(15*2048))] in trans_bl)and
          (map[rx-1][ry].light[k+(j*128+(15*2048))]<(svet-1)) then
            recur(napravlenie,svet-1,map,rx-1,ry,15,j,k);
        end
        else
          if (map[rx][ry].blocks[k+(j*128+((i-1)*2048))] in trans_bl)and
          (map[rx][ry].light[k+(j*128+((i-1)*2048))]<(svet-1)) then
            recur(napravlenie,svet-1,map,rx,ry,i-1,j,k);

        //idem vpravo
        if i=15 then
        begin
          if (map[rx+1][ry].blocks[k+(j*128)] in trans_bl)and
          (map[rx+1][ry].light[k+(j*128)]<(svet-1)) then
            recur(napravlenie,svet-1,map,rx+1,ry,0,j,k);
        end
        else
          if (map[rx][ry].blocks[k+(j*128+((i+1)*2048))] in trans_bl)and
          (map[rx][ry].light[k+(j*128+((i+1)*2048))]<(svet-1))then
            recur(napravlenie,svet-1,map,rx,ry,i+1,j,k);

        //idem vverh
        if k<127 then
          if (map[rx][ry].blocks[k+1+(j*128+(i*2048))] in trans_bl)and
          (map[rx][ry].light[k+1+(j*128+(i*2048))]<(svet-1)) then
            recur(napravlenie,svet-1,map,rx,ry,i,j,k+1);

        //idem vniz
        if k>0 then
          if (map[rx][ry].blocks[k-1+(j*128+(i*2048))] in trans_bl)and
          (map[rx][ry].light[k-1+(j*128+(i*2048))]<(svet-1))then
            recur(napravlenie,svet-1,map,rx,ry,i,j,k-1);
      end;
    6:begin   //zad
        //idem nazad
        if j=0 then
        begin
          if (map[rx][ry-1].blocks[k+(15*128+(i*2048))] in trans_bl)and
          (map[rx][ry-1].light[k+(15*128+(i*2048))]<(svet-1))then
            recur(napravlenie,svet-1,map,rx,ry-1,i,15,k);
        end
        else
          if (map[rx][ry].blocks[k+((j-1)*128+(i*2048))] in trans_bl)and
          (map[rx][ry].light[k+((j-1)*128+(i*2048))]<(svet-1)) then
            recur(napravlenie,svet-1,map,rx,ry,i,j-1,k);

        //idem vlevo
        if i=0 then  //granica chanka
        begin
          if (map[rx-1][ry].blocks[k+(j*128+(15*2048))] in trans_bl)and
          (map[rx-1][ry].light[k+(j*128+(15*2048))]<(svet-1)) then
            recur(napravlenie,svet-1,map,rx-1,ry,15,j,k);
        end
        else
          if (map[rx][ry].blocks[k+(j*128+((i-1)*2048))] in trans_bl)and
          (map[rx][ry].light[k+(j*128+((i-1)*2048))]<(svet-1)) then
            recur(napravlenie,svet-1,map,rx,ry,i-1,j,k);

        //idem vpravo
        if i=15 then
        begin
          if (map[rx+1][ry].blocks[k+(j*128)] in trans_bl)and
          (map[rx+1][ry].light[k+(j*128)]<(svet-1)) then
            recur(napravlenie,svet-1,map,rx+1,ry,0,j,k);
        end
        else
          if (map[rx][ry].blocks[k+(j*128+((i+1)*2048))] in trans_bl)and
          (map[rx][ry].light[k+(j*128+((i+1)*2048))]<(svet-1))then
            recur(napravlenie,svet-1,map,rx,ry,i+1,j,k);

        //idem vverh
        if k<127 then
          if (map[rx][ry].blocks[k+1+(j*128+(i*2048))] in trans_bl)and
          (map[rx][ry].light[k+1+(j*128+(i*2048))]<(svet-1)) then
            recur(napravlenie,svet-1,map,rx,ry,i,j,k+1);

        //idem vniz
        if k>0 then
          if (map[rx][ry].blocks[k-1+(j*128+(i*2048))] in trans_bl)and
          (map[rx][ry].light[k-1+(j*128+(i*2048))]<(svet-1))then
            recur(napravlenie,svet-1,map,rx,ry,i,j,k-1);
      end;
    end;
  end;

  procedure recur2(svet:shortint;var map:region;rx,ry,i,j,k:byte);
  begin   
    //if map[rx][ry].light[k+(j*128+(i*2048))]>svet then exit;
    if (map[rx][ry].blocks[k+(j*128+(i*2048))] in diff_bl) then svet:=svet-2;
    if svet<0 then svet:=0;

    map[rx][ry].light[k+(j*128+(i*2048))]:=svet;

    if svet<=1 then exit;

        //idem vverh
        if k<127 then
          if (map[rx][ry].blocks[k+1+(j*128+(i*2048))] in trans_bl)and
          (map[rx][ry].light[k+1+(j*128+(i*2048))]<(svet-1)) then
            recur2(svet-1,map,rx,ry,i,j,k+1);

        //idem vniz
        if k>0 then
          if (map[rx][ry].blocks[k-1+(j*128+(i*2048))] in trans_bl)and
          (map[rx][ry].light[k-1+(j*128+(i*2048))]<(svet-1))then
            recur2(svet-1,map,rx,ry,i,j,k-1);

        //idem vlevo
        if i=0 then  //granica chanka
        begin
          if (map[rx-1][ry].blocks[k+(j*128+(15*2048))] in trans_bl)and
          (map[rx-1][ry].light[k+(j*128+(15*2048))]<(svet-1)) then
            recur2(svet-1,map,rx-1,ry,15,j,k);
        end
        else
          if (map[rx][ry].blocks[k+(j*128+((i-1)*2048))] in trans_bl)and
          (map[rx][ry].light[k+(j*128+((i-1)*2048))]<(svet-1)) then
            recur2(svet-1,map,rx,ry,i-1,j,k);

        //idem vpravo
        if i=15 then
        begin
          if (map[rx+1][ry].blocks[k+(j*128)] in trans_bl)and
          (map[rx+1][ry].light[k+(j*128)]<(svet-1)) then
            recur2(svet-1,map,rx+1,ry,0,j,k);
        end
        else
          if (map[rx][ry].blocks[k+(j*128+((i+1)*2048))] in trans_bl)and
          (map[rx][ry].light[k+(j*128+((i+1)*2048))]<(svet-1))then
            recur2(svet-1,map,rx,ry,i+1,j,k);

        //idem vpered
        if j=15 then
        begin
          if (map[rx][ry+1].blocks[k+(i*2048)] in trans_bl)and
          (map[rx][ry+1].light[k+(i*2048)]<(svet-1))then
            recur2(svet-1,map,rx,ry+1,i,0,k);
        end
        else
          if (map[rx][ry].blocks[k+((j+1)*128+(i*2048))] in trans_bl)and
          (map[rx][ry].light[k+((j+1)*128+(i*2048))]<(svet-1))then
            recur2(svet-1,map,rx,ry,i,j+1,k);

        //idem nazad
        if j=0 then
        begin
          if (map[rx][ry-1].blocks[k+(15*128+(i*2048))] in trans_bl)and
          (map[rx][ry-1].light[k+(15*128+(i*2048))]<(svet-1))then
            recur2(svet-1,map,rx,ry-1,i,15,k);
        end
        else
          if (map[rx][ry].blocks[k+((j-1)*128+(i*2048))] in trans_bl)and
          (map[rx][ry].light[k+((j-1)*128+(i*2048))]<(svet-1)) then
            recur2(svet-1,map,rx,ry,i,j-1,k);
          
  end;

var i,j,k:integer;
li:byte;
rx,ry:integer;
begin

  for rx:=otx+1 to dox+3 do      //chanki
    for ry:=oty+1 to doy+3 do

      for j:=0 to 15 do         //Z         //bloki
        for i:=0 to 15 do        //X
          for k:=0 to 127 do      //Y
          begin
            if (map[rx][ry].blocks[k+(j*128+(i*2048))] in light_bl) then  //esli svetashiysa blok
            begin
              case map[rx][ry].blocks[k+(j*128+(i*2048))] of
                89,10,11,51,91,95:li:=15;
                50:li:=14;
                62:li:=13;
                90:li:=11;
                94,74:li:=9;
                76:li:=7;
                39:li:=1
                else li:=0;
              end;

              if map[rx][ry].light[k+(j*128+(i*2048))]>=li then continue;

              {recur(1,li,map,rx,ry,i,j,k);
              recur(2,li,map,rx,ry,i,j,k);
              recur(3,li,map,rx,ry,i,j,k);
              recur(4,li,map,rx,ry,i,j,k);
              recur(5,li,map,rx,ry,i,j,k);
              recur(6,li,map,rx,ry,i,j,k);}

              recur2(li,map,rx,ry,i,j,k);

              {map[rx][ry].light[k+(j*128+(i*2048))]:=li;
              //map[rx][ry].light[k+(j*128+(i*2048))]:=15;
              inc(li,-1);
              //peredaem parametri v rekursivnuyu funkciyu
              //vverh
              if k<127 then
              begin
                t:=map[rx][ry].blocks[k+1+(j*128+(i*2048))];
                if (t in trans_bl)and
                (map[rx][ry].light[k+1+(j*128+(i*2048))]<li) then
                  recur(1,li,map,rx,ry,i,j,k+1)
                else if not(t in trans_bl) then
                  recur(1,li+1,map,rx,ry,i,j,k);
              end;
              //vniz
              if k>0 then
              begin
                t:=map[rx][ry].blocks[k-1+(j*128+(i*2048))];
                if (t in trans_bl)and
                (map[rx][ry].light[k-1+(j*128+(i*2048))]<li) then
                  recur(2,li,map,rx,ry,i,j,k-1)
                else if not(t in trans_bl) then
                  recur(2,li+1,map,rx,ry,i,j,k);
              end;
              //vlevo
              if i=0 then  //granica chanka
              begin
                t:=map[rx-1][ry].blocks[k+(j*128+(15*2048))];
                if (t in trans_bl)and
                (map[rx-1][ry].light[k+(j*128+(15*2048))]<li)then
                  recur(3,li,map,rx-1,ry,15,j,k)
                else if not(t in trans_bl) then
                  recur(3,li+1,map,rx,ry,i,j,k);
              end
              else
              begin
                t:=map[rx][ry].blocks[k+(j*128+((i-1)*2048))];
                if (t in trans_bl)and
                (map[rx][ry].light[k+(j*128+((i-1)*2048))]<li)then
                  recur(3,li,map,rx,ry,i-1,j,k)
                else if not(t in trans_bl) then
                  recur(3,li+1,map,rx,ry,i,j,k);
              end;
              //vpravo
              if i=15 then
              begin
                t:=map[rx+1][ry].blocks[k+(j*128)];
                if (t in trans_bl)and
                (map[rx+1][ry].light[k+(j*128)]<li)then
                  recur(4,li,map,rx+1,ry,0,j,k)
                else if not(t in trans_bl) then
                  recur(4,li+1,map,rx,ry,i,j,k);
              end
              else
              begin
                t:=map[rx][ry].blocks[k+(j*128+((i+1)*2048))];
                if (t in trans_bl)and
                (map[rx][ry].light[k+(j*128+((i+1)*2048))]<li)then
                  recur(4,li,map,rx,ry,i+1,j,k)
                else if not(t in trans_bl) then
                  recur(4,li+1,map,rx,ry,i,j,k);
              end;
              //vpered
              if j=15 then
              begin
                t:=map[rx][ry+1].blocks[k+(i*2048)];
                if (t in trans_bl)and
                (map[rx][ry+1].light[k+(i*2048)]<li)then
                  recur(5,li,map,rx,ry+1,i,0,k)
                else if not(t in trans_bl) then
                  recur(5,li+1,map,rx,ry,i,j,k);
              end
              else
              begin
                t:=map[rx][ry].blocks[k+((j+1)*128+(i*2048))];
                if (t in trans_bl)and
                (map[rx][ry].light[k+((j+1)*128+(i*2048))]<li)then
                  recur(5,li,map,rx,ry,i,j+1,k)
                else if not(t in trans_bl) then
                  recur(5,li+1,map,rx,ry,i,j,k);
              end;
              //nazad
              if j=0 then
              begin
                t:=map[rx][ry-1].blocks[k+(15*128+(i*2048))];
                if (t in trans_bl)and
                (map[rx][ry-1].light[k+(15*128+(i*2048))]<li)then
                  recur(6,li,map,rx,ry-1,i,15,k)
                else if not(t in trans_bl) then
                  recur(6,li+1,map,rx,ry,i,15,k);
              end
              else
              begin
                t:=map[rx][ry].blocks[k+((j-1)*128+(i*2048))];
                if (t in trans_bl)and
                (map[rx][ry].light[k+((j-1)*128+(i*2048))]<li) then
                  recur(6,li,map,rx,ry,i,j-1,k)
                else if not(t in trans_bl) then
                  recur(6,li+1,map,rx,ry,i,j,k);
              end;  }
            end;
          end;
end;

procedure calc_skylight(var map:region; otx,oty,dox,doy:integer);
var i,j,k:integer;
rx,ry:integer;
temp,temp_u,temp_d,temp_f,temp_b,temp_l,temp_r:byte;
max:byte;
b:boolean;
label na;
begin  
  //ochishaem skylight i heightmap
  for rx:=0 to 35 do
    for ry:=0 to 35 do
    begin
      zeromemory(map[rx][ry].skylight,length(map[rx][ry].skylight));
      zeromemory(map[rx][ry].heightmap,length(map[rx][ry].heightmap));
    end;

  //zapolnaem nachalnie znacheniya skylight (verhniy sloy)
  for rx:=otx+1 to dox+3 do
    for ry:=oty+1 to doy+3 do

      for i:=0 to 15 do   //Z
        for j:=0 to 15 do   //X
          if (map[rx][ry].blocks[127+(i*128+(j*2048))] in trans_bl) then
            map[rx][ry].skylight[127+(i*128+(j*2048))]:=15
          else map[rx][ry].heightmap[(i*16)+j]:=127;

  //ToDO: peredelat' obrabotku pervuyu skylight tak, chtobi lishniy raz ne dohodit' do samogo nisa karti

  //schitaem skylight perviy raz ot levogo nizhnego do pravogo verhnego ugla
  //schitaem sverhu vniz po 1 bloku
  for rx:=otx+1 to dox+3 do    //Xch
    for ry:=oty+1 to doy+3 do  //Ych
      for j:=0 to 15 do     //Z
        for i:=0 to 15 do      //X
        begin
          for k:=126 downto 0 do       //Y
          begin
            temp:=map[rx][ry].blocks[k+(i*128+(j*2048))];

            if ((not(temp in trans_bl))or(temp in diff_bl)or(temp=18))and(map[rx][ry].heightmap[(i*16)+j]<=(k+1)) then
              map[rx][ry].heightmap[(i*16)+j]:=k+1;

            if (temp in trans_bl) then      //materiali, kotorie polnostyu propuskayut svet
              if (temp in diff_bl) then   //materiali, kotorie ne polnostyu propuskayut svet
              begin
                if (map[rx][ry].skylight[k+1+(i*128+(j*2048))]>3) then
                  map[rx][ry].skylight[k+(i*128+(j*2048))]:=map[rx][ry].skylight[k+1+(i*128+(j*2048))]-3
                else
                  map[rx][ry].skylight[k+(i*128+(j*2048))]:=0;
              end
              else
              if (map[rx][ry].skylight[k+1+(i*128+(j*2048))]=15) then
                map[rx][ry].skylight[k+(i*128+(j*2048))]:=map[rx][ry].skylight[k+1+(i*128+(j*2048))];

          end;
        end;

  //ToDO: peredelat' tak, chtobi svet proschitivalsa vverh, no ne ubirat' neskol'ko proschetov, t.k. eto ne dast nuzhnogo resultata naprimer pri spiralnom tunnele vverh      
na:
  b:=false;
  for rx:=otx+1 to dox+3 do    //Xch
    for ry:=oty+1 to doy+3 do  //Ych
      for j:=0 to 15 do     //Z
        for i:=0 to 15 do      //X
        begin
          for k:=126 downto 0 do       //Y
          begin
            temp:=map[rx][ry].blocks[k+(j*128+(i*2048))];
            if (temp in trans_bl) then
            begin
              max:=map[rx][ry].skylight[k+(j*128+(i*2048))];
              if max<>15 then
              begin
                //po X
                if i<>15 then
                  temp_r:=map[rx][ry].skylight[k+(j*128+((i+1)*2048))]
                else
                  temp_r:=map[rx+1][ry].skylight[k+(j*128)];

                if i<>0 then
                  temp_l:=map[rx][ry].skylight[k+(j*128+((i-1)*2048))]
                else
                  temp_l:=map[rx-1][ry].skylight[k+(j*128+(15*2048))];

                //po Z
                if j<>15 then
                  temp_f:=map[rx][ry].skylight[k+((j+1)*128+(i*2048))]
                else
                  temp_f:=map[rx][ry+1].skylight[k+(i*2048)];

                if j<>0 then
                  temp_b:=map[rx][ry].skylight[k+((j-1)*128+(i*2048))]
                else
                  temp_b:=map[rx][ry-1].skylight[k+(15*128+(i*2048))];

                //po Y
                temp_u:=map[rx][ry].skylight[k+1+(j*128+(i*2048))];
                if k<>0 then temp_d:=map[rx][ry].skylight[k-1+(j*128+(i*2048))]
                else temp_d:=0;

                if (temp_l-1)>max then max:=temp_l-1;
                if (temp_r-1)>max then max:=temp_r-1;
                if (temp_f-1)>max then max:=temp_f-1;
                if (temp_b-1)>max then max:=temp_b-1;
                if (temp_u-1)>max then max:=temp_u-1;
                if (temp_d-1)>max then max:=temp_d-1;

                //popravka na vodu
                if (temp in diff_bl) then
                  if max>2 then inc(max,-2)
                  else max:=0;

                if map[rx][ry].skylight[k+(j*128+(i*2048))]<max then
                begin
                  map[rx][ry].skylight[k+(j*128+(i*2048))]:=max;
                  b:=true;
                end;

              end;

            end;

          end;
        end;


  for rx:=dox+3 downto otx+1 do    //Xch
    for ry:=doy+3 downto oty+1 do  //Ych
      for j:=15 downto 0 do     //Z
        for i:=15 downto 0 do      //X
        begin
          for k:=0 to 126 do       //Y
          begin
            temp:=map[rx][ry].blocks[k+(j*128+(i*2048))];
            if (temp in trans_bl) then
            begin
              max:=map[rx][ry].skylight[k+(j*128+(i*2048))];
              if max<>15 then
              begin
                //po X
                if i<>15 then
                  temp_r:=map[rx][ry].skylight[k+(j*128+((i+1)*2048))]
                else
                  temp_r:=map[rx+1][ry].skylight[k+(j*128)];

                if i<>0 then
                  temp_l:=map[rx][ry].skylight[k+(j*128+((i-1)*2048))]
                else
                  temp_l:=map[rx-1][ry].skylight[k+(j*128+(15*2048))];

                //po Z
                if j<>15 then
                  temp_f:=map[rx][ry].skylight[k+((j+1)*128+(i*2048))]
                else
                  temp_f:=map[rx][ry+1].skylight[k+(i*2048)];

                if j<>0 then
                  temp_b:=map[rx][ry].skylight[k+((j-1)*128+(i*2048))]
                else
                  temp_b:=map[rx][ry-1].skylight[k+(15*128+(i*2048))];

                //po Y
                temp_u:=map[rx][ry].skylight[k+1+(j*128+(i*2048))];
                if k<>0 then temp_d:=map[rx][ry].skylight[k-1+(j*128+(i*2048))]
                else temp_d:=0;

                if (temp_l-1)>max then max:=temp_l-1;
                if (temp_r-1)>max then max:=temp_r-1;
                if (temp_f-1)>max then max:=temp_f-1;
                if (temp_b-1)>max then max:=temp_b-1;
                if (temp_u-1)>max then max:=temp_u-1;
                if (temp_d-1)>max then max:=temp_d-1;

                //popravka na vodu
                if (temp in diff_bl) then
                  if max>2 then inc(max,-2)
                  else max:=0;

                if map[rx][ry].skylight[k+(j*128+(i*2048))]<max then
                begin
                  map[rx][ry].skylight[k+(j*128+(i*2048))]:=max;
                  b:=true;
                end;

              end;

            end;

          end;
        end;
  if b=true then goto na;

end;


//generaciya resursov po notchu
procedure gen_resourses2(var map:region; regx,regy:integer; x,y,z,id:integer; count:integer);
var d,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,f,t:extended;
l,i1,j1,k1,l1,i2,j2,k2,l2,i3:integer;
begin
  f:=random*pi;
  d:=(x+8)+(sin(f)*count)/8;
  d1:=(x+8)-(sin(f)*count)/8;
  d2:=(z+8)+(sin(f)*count)/8;
  d3:=(z+8)-(sin(f)*count)/8;
  d4:=y+random(3)+2;
  d5:=y+random(3)+2;
  for l:=0 to count do
  begin
    d6:=d+((d1-d)*l)/count;
    d7:=d4+((d5-d4)*l)/count;
    d8:=d2+((d3-d2)*l)/count;
    d9:=(random*count)/16;
    d10:=(sin((l * pi) / count) + 1) * d9 + 1;
    d11:=(sin((l * pi) / count) + 1) * d9 + 1;
    i1:=trunc(d6 - d10 / 2);
    j1:=trunc(d7 - d11 / 2);
    k1:=trunc(d8 - d10 / 2);
    l1:=trunc(d6 + d10 / 2);
    i2:=trunc(d7 + d11 / 2);
    j2:=trunc(d8 + d10 / 2);

    for k2:=i1 to l1 do
    begin
      d12 := ((k2 + 0.5) - d6) / (d10 / 2);
      if (d12*d12)>=1 then continue;

      for l2:=j1 to i2 do
      begin
        d13 := ((l2 + 0.5) - d7) / (d11 / 2);
        if (d12*d12+d13*d13)>=1 then continue;

        for i3:=k1 to j2 do
        begin
          d14 := ((i3 + 0.5) - d8) / (d10 / 2);

          t:=d12 * d12 + d13 * d13 + d14 * d14;
          if (t<1)and(get_block_id(map,regx,regy,k2,l2,i3)=1)and(l2>0)and(l2<127) then
            //if (t<=0.3)or((t>0.7)and(random<0.5)) then
              set_block_id(map,regx,regy,k2,l2,i3,id);
        end;
      end;
    end;
  end;
end;

function gen_taigatree1_notch(var map:region; xreg,yreg,x,y,z:integer; sid:int64):boolean;
var l,i1,j1,k1,i,j,k,j2,j4,k2,k4,i5:integer;
flag:boolean;
r:rnd;
begin
  r:=rnd.Create(sid);

  l:=r.nextInt(5)+7;
  i1:=l-r.nextInt(2)-3;
  j1:=l-i1;
  k1:=1+r.nextInt(j1+1);
  flag:=true;

  if (y<1)or((y+l+1)>127) then
  begin
    r.Free;
    result:=false;
    exit;
  end;

  for i:=y to y+1+l do   //Y
  begin
    if flag=false then break;
    j2:=1;
    if (i-y)<i1 then j2:=0
    else j2:=k1;
    for j:=x-j2 to x+j2 do  //X
      for k:=z-j2 to z+j2 do   //Z
      begin
        if flag=false then break;
        if (i>1)and(i<127) then
        begin
          j4:=get_block_id(map,xreg,yreg,j,i,k);
          if (j4<>0)and(j4<>18)and(j4<>78) then flag:=false;
        end
        else flag:=false;
      end;
  end;

  if (flag=false) then
  begin
    r.Free;
    result:=false;
    exit;
  end;

  j4:=get_block_id(map,xreg,yreg,x,y-1,z);
  if (j4<>2)and(j4<>3) then
  begin
    r.Free;
    result:=false;
    exit;
  end;

  set_block_id(map,xreg,yreg,x,y-1,z,3);

  k2:=0;
  for i:=y+l downto y+i1 do  //Y
  begin
    for j:=x-k2 to x+k2 do    //X
    begin
      k4:=j-x;
      for k:=z-k2 to z+k2 do    //Z
      begin
        i5:=k-z;
        if (abs(k4)<>k2)or(abs(i5)<>k2)or(k2<=0) then
          set_block_id_data(map,xreg,yreg,j,i,k,18,1);
      end;
    end;

    if (k2>=1)and(i=y+i1+1) then
    begin
      dec(k2);
      continue;
    end;
    if k2<k1 then
      inc(k2);
  end;

  for i:=0 to l-2 do
  begin
    j4:=get_block_id(map,xreg,yreg,x,y+i,z);
    if (j4=0)or(j4=18)or(j4=78) then
      set_block_id_data(map,xreg,yreg,x,y+i,z,17,1);
  end;

  r.Free;
  result:=true;
end;

function gen_taigatree2_notch(var map:region; xreg,yreg,x,y,z:integer; sid:int64):boolean;
var i,j,k,l,i1,j1,k1,j2,t,k2,i3,j4,j5,l5,i4:integer;
flag,flag1:boolean;
r:rnd;
begin
  r:=rnd.Create(sid);
  l:=r.nextInt(4)+6;
  i1:=1+r.nextInt(2);
  j1:=l-i1;
  k1:=2+r.nextInt(2);
  flag:=true;
  if (y<1)or(y+l+1>127) then
  begin
    r.Free;
    result:=false;
    exit;
  end;

  for i:=y to y+l+1 do   //Y
  begin
    if flag=false then break;
    j2:=1;
    if (i-y)<i1 then j2:=0
    else j2:=k1;
    for j:=x-j2 to x+j2 do  //X
      for k:=z-j2 to z+j2 do  //Z
      begin
        if flag=false then break;
        if (i>1)and(i<127) then
        begin
          t:=get_block_id(map,xreg,yreg,j,i,k);
          if (t<>0)and(t<>18)and(t<>78) then flag:=false;
        end
        else flag:=false;
      end;
  end;

  if flag=false then
  begin
    r.Free;
    result:=false;
    exit;
  end;
  t:=get_block_id(map,xreg,yreg,x,y-1,z);
  if (t<>2)and(t<>3) then
  begin
    r.Free;
    result:=false;
    exit;
  end;

  set_block_id(map,xreg,yreg,x,y-1,z,3);
  k2:=r.nextInt(2);
  i3:=1;
  flag1:=false;

  for i:=0 to j1 do
  begin
    j4:=(y+l)-i;      //Y
    for j:=x-k2 to x+k2 do //X
    begin
      j5:=j-x;
      for k:=z-k2 to z+k2 do  //Z
      begin
        l5:=k-z;
        if (abs(j5)<>k2)or(abs(l5)<>k2)or(k2<=0) then
          set_block_id_data(map,xreg,yreg,j,j4,k,18,1);
      end;
    end;
    if k2>=i3 then
    begin
      if flag1 then k2:=1
      else k2:=0;
      flag1:=true;
      inc(i3);
      if i3>k1 then i3:=k1;
    end
    else inc(k2);
  end;

  i4:=r.nextInt(3);
  for i:=0 to l-i4-1 do
  begin
    t:=get_block_id(map,xreg,yreg,x,y+i,z);
    if (t=0)or(t=18)or(t=78) then
      set_block_id_data(map,xreg,yreg,x,y+i,z,17,1);
  end;

  r.Free;
  result:=true;
end;

function gen_cactus(var map:region; xreg,yreg,x,y,z:integer; sid:int64):boolean;
var i,t:integer;
r:rnd;
begin
  r:=rnd.Create(sid);
  t:=1+r.nextInt(r.nextInt(3)+1);
  //proverka
  if get_block_id(map,xreg,yreg,x,y-1,z)<>12 then
  begin
    r.Free;
    result:=false;
    exit;
  end;

  for i:=y to y+t-1 do
    if (get_block_id(map,xreg,yreg,x,i,z)<>0)or
    (get_block_id(map,xreg,yreg,x-1,i,z)<>0)or
    (get_block_id(map,xreg,yreg,x+1,i,z)<>0)or
    (get_block_id(map,xreg,yreg,x,i,z-1)<>0)or
    (get_block_id(map,xreg,yreg,x,i,z+1)<>0) then
    begin
      r.Free;
      result:=false;
      exit;
    end;

  //risovanie
  for i:=y to y+t-1 do
    set_block_id(map,xreg,yreg,x,i,z,81);

  r.Free;
  result:=true;
end;

function gen_bigtree_notch(var map:region; xreg,yreg,x,y,z:integer; sid:int64;var sp:boolean; waterlevel:integer; hndl:cardinal):boolean;
var r:rnd;
field_878_e,field_871_l,field_870_m,field_869_n,height:integer;
field_876_g,field_875_h,field_874_i,field_873_j,field_872_k:extended;
field_868_o:array of array of integer;
field_882_a:array[0..5]of byte;
basepos:array[0..2]of integer;
b:boolean;

  function func_526_b(i:integer):double;
  begin
    if (i<0)or(i>=field_869_n) then
    begin
      result:=-1;
      exit;
    end;

    if (i<>0)and(i<>field_869_n-1)then result:=3
    else result:=2;
  end;

  function func_528_a(i:integer):double;
  var f,f1,f2:double;
  begin
    if i<(field_878_e * 0.29999999999999999) then
    begin
      result:=-1.618;
      exit;
    end;
    f:=field_878_e/2;
    f1:=field_878_e/2-i;
    if f1=0 then f2:=f
    else if abs(f1)>=f then f2:=0
      else f2:=sqrt(power(abs(f),2)-power(abs(f1),2));
    result:=f2*0.5;
  end;

  function func_524_a(ai,ai1:array of integer):integer;
  var ai2,ai3:array [0..2] of integer;
  i,j,k,l:integer;
  byte0,byte1,byte2:byte;
  byte3:smallint;
  d,d1:double;
  begin
    ai2[0]:=0;
    ai2[1]:=0;
    ai2[2]:=0;
    i:=0;
    for byte0:=0 to 2 do
    begin
      ai2[byte0]:=ai1[byte0]-ai[byte0];
      if abs(ai2[byte0])>abs(ai2[i]) then i:=byte0;
    end;
    if ai2[i]=0 then
    begin
      result:=-1;
      exit;
    end;

    byte1:=field_882_a[i];
    byte2:=field_882_a[i + 3];
    if ai2[i]>0 then byte3:=1
    else byte3:=-1;
    d:=ai2[byte1]/ai2[i];
    d1:=ai2[byte2]/ai2[i];
    ai3[0]:=0;
    ai3[1]:=0;
    ai3[2]:=0;
    j:=0;
    k:=ai2[i]+byte3;
    repeat
      if j=k then break;
      ai3[i]:=ai[i]+j;
      ai3[byte1]:=trunc(ai[byte1] + j * d);
      ai3[byte2]:=trunc(ai[byte2] + j * d1);
      l:=get_block_id(map,xreg,yreg,ai3[0], ai3[1], ai3[2]);
      if (l<>0)and(l<>18) then break;
      inc(j,byte3);
    until false;
    if j=k then result:=-1
    else result:=abs(j);
  end;

  procedure func_521_a;
  var i,j,k,l,i1,j1,k1,l1:integer;
  f,d,d1,d2,d3,d4:double;
  z:integer;
  ai:array of array of integer;
  ai1,ai2,ai3:array[0..2]of integer;
  begin
    height:=trunc(field_878_e * field_876_g);
    if height>field_878_e then height:=height-1;
    i:=trunc(1.3819999999999999+power((field_872_k * field_878_e) / 13, 2));
    if i<1 then i:=1;
    setlength(ai,i * field_878_e);
    for z:=0 to length(ai)-1 do
      setlength(ai[z],4);
    j:=(basePos[1] + field_878_e) - field_869_n;
    k:=1;
    l:=basepos[1]+height;
    i1:=j-basepos[1];
    ai[0][0]:=basepos[0];
    ai[0][1]:=j;
    ai[0][2]:=basepos[2];
    ai[0][3]:=l;
    dec(j);
    while i1>=0 do
    begin
      j1:=0;
      f:=func_528_a(i1);
      if f<0 then
      begin
        dec(j);
        dec(i1);
      end
      else
      begin
        d:=0.5;
        while j1<i do
        begin
          inc(j1);
          d1:=field_873_j*(f * (r.nextFloat() + 0.32800000000000001));
          d2:=r.nextFloat() * 2 * 3.1415899999999999;
          k1:= trunc(d1 * sin(d2) + basePos[0] + d);
          l1:=trunc(d1 * cos(d2) + basePos[2] + d);
          ai1[0]:=k1;
          ai1[1]:=j;
          ai1[2]:=l1;

          ai2[0]:=k1;
          ai2[1]:=j + field_869_n;
          ai2[2]:=l1;

          if func_524_a(ai1, ai2)<>-1 then continue;

          ai3[0]:=basepos[0];
          ai3[1]:=basepos[1];
          ai3[2]:=basepos[2];

          d3:=sqrt(power(abs(basePos[0]-ai1[0]),2)+power(abs(basePos[2]-ai1[2]),2));
          d4:=d3 * field_874_i;
          if (ai1[1]-d4)>l then ai3[1]:=l
          else ai3[1]:=trunc(ai1[1]-d4);
          if func_524_a(ai3, ai1)=-1 then
          begin
            ai[k][0]:=k1;
            ai[k][1]:=j;
            ai[k][2]:=l1;
            ai[k][3]:=ai3[1];
            inc(k);
          end;
        end;
        dec(j);
        dec(i1);
      end;

    end;
    setlength(field_868_o,k);
    for j1:=0 to k-1 do
      setlength(field_868_o[j1],4);

    for i:=0 to k-1 do
      for j:=0 to 3 do
        field_868_o[i][j]:=ai[i][j];
  end;

  procedure func_523_a(i,j,k:integer; f:double; byte0:byte; l:integer);
  var byte1,byte2:byte;
  i1,j1,k1,l1,i2:integer;
  ai,ai1:array [0..2]of integer;
  d:extended;
  begin
    i1:=trunc(f + 0.61799999999999999);
    byte1:=field_882_a[byte0];
    byte2:=field_882_a[byte0 + 3];
    ai[0]:=i;
    ai[1]:=j;
    ai[2]:=k;
    ai1[0]:=0;
    ai1[1]:=0;
    ai1[2]:=0;
    j1:=-i1;
    k1:=-i1;
    ai1[byte0]:=ai[byte0];
    while j1<=i1 do
    begin
      ai1[byte1]:=ai[byte1]+j1;
      l1:=-i1;
      while l1<=i1 do
      begin
        d:=sqrt(power(abs(j1) + 0.5, 2) + power(abs(l1) + 0.5, 2));
        if d>f then inc(l1)
        else
        begin
          ai1[byte2]:=ai[byte2]+l1;
          i2:=get_block_id(map,xreg,yreg,ai1[0], ai1[1], ai1[2]);
          if (i2<>0)and(i2<>18) then inc(l1)
          else
          begin
            set_block_id(map,xreg,yreg,ai1[0], ai1[1], ai1[2], l);
            inc(l1);
          end;
        end;
      end;
      inc(j1);
    end;
  end;

  procedure func_520_a(i,j,k:integer);
  var l,i1:integer;
  f:double;
  begin
    i1:=j + field_869_n;
    for l:=j to i1-1 do
    begin
      f:=func_526_b(l - j);
      func_523_a(i, l, k, f, 1, 18);
    end;
  end;

  procedure func_522_a(ai,ai1:array of integer; i:integer);
  var ai2,ai3:array[0..2] of integer;
  byte0,byte1,byte2:byte;
  byte3:smallint;
  j,k,l:integer;
  d,d1:extended;
  begin
    ai2[0]:=0; ai2[1]:=0; ai2[2]:=0;
    j:=0;
    for byte0:=0 to 2 do
    begin
      ai2[byte0]:=ai1[byte0] - ai[byte0];
      if(abs(ai2[byte0]) > abs(ai2[j])) then
        j:=byte0;
    end;
    if ai2[j]=0 then exit;
    byte1:=field_882_a[j];
    byte2:=field_882_a[j + 3];
    if ai2[j]>0 then byte3:=1
    else byte3:=-1;
    d:=ai2[byte1] / ai2[j];
    d1:=ai2[byte2] / ai2[j];
    ai3[0]:=0; ai3[1]:=0; ai3[2]:=0;
    k:=0;
    l:=ai2[j] + byte3;
    while k<>l do
    begin
      ai3[j]:=floor((ai[j] + k) + 0.5);
      ai3[byte1]:=floor(ai[byte1] + k * d + 0.5);
      ai3[byte2]:=floor(ai[byte2] + k * d1 + 0.5);
      set_block_id(map,xreg,yreg,ai3[0], ai3[1], ai3[2], i);
      k:=k+byte3;
    end;
  end;

  procedure func_518_b;
  var i,j,k,l,i1:integer;
  begin
    j:=length(field_868_o);
    for i:=0 to j-1 do
    begin
      k:=field_868_o[i][0];
      l:=field_868_o[i][1];
      i1:=field_868_o[i][2];
      func_520_a(k, l, i1);
    end;
  end;

  function func_527_c(i:integer):boolean;
  begin
    result:=i >= field_878_e * 0.20000000000000001;
  end;

  procedure func_529_c;
  var ai,ai1:array[0..2]of integer;
  begin
    ai[0]:=basepos[0];
    ai[1]:=basepos[1];
    ai[2]:=basepos[2];

    ai1[0]:=basepos[0];
    ai1[1]:=basepos[1]+height;
    ai1[2]:=basepos[2];

    func_522_a(ai, ai1, 17);
    if field_871_l=2 then
    begin
      inc(ai[0]);
      inc(ai1[0]);
      func_522_a(ai, ai1, 17);
      inc(ai[2]);
      inc(ai1[2]);
      func_522_a(ai, ai1, 17);
      dec(ai[0]);
      dec(ai1[0]);
      func_522_a(ai, ai1, 17);
    end;
  end;

  procedure func_525_d;
  var ai,ai2:array[0..2]of integer;
  ai1:array[0..3]of integer;
  i,j,k:integer;
  begin
    ai[0]:=basepos[0];
    ai[1]:=basepos[1];
    ai[2]:=basepos[2];
    for i:=0 to length(field_868_o)-1 do
    begin
      for j:=0 to 2 do
      begin
        ai1[j]:=field_868_o[i][j];
        ai2[j]:=ai1[j];
      end;
      ai1[3]:=field_868_o[i][3];
      ai[1]:=ai1[3];
      k:=ai[1] - basePos[1];
      if(func_527_c(k)) then
        func_522_a(ai, ai2, 17);
    end;
  end;

  function func_519_e:boolean;
  var ai,ai1:array[0..2]of integer;
  i,j:integer;
  begin
    ai[0]:=basepos[0];
    ai[1]:=basepos[1];
    ai[2]:=basepos[2];

    ai1[0]:=basepos[0];
    ai1[1]:=(basePos[1] + field_878_e) - 1;
    ai1[2]:=basepos[2];

    i:=get_block_id(map,xreg,yreg,basePos[0], basePos[1] - 1, basePos[2]);
    if (i<>2)and(i<>3) then
    begin
      result:=false;
      exit;
    end;
    j:=func_524_a(ai, ai1);
    if j=-1 then
    begin
      result:=true;
      exit;
    end;
    if j<6 then
      result:=false
    else
    begin
      field_878_e:=j;
      result:=true;
    end;
  end;

  procedure func_517_a(d,d1,d2:extended);
  begin
    field_870_m:=trunc(d*12);
    if d>0.5 then field_869_n:=5;
    field_873_j:=d1;
    field_872_k:=d2;
  end;

begin
  r:=rnd.Create;
  field_878_e:=0;
  field_876_g:=0.61799999999999999;
  field_875_h:=1.0;
  field_874_i:=0.38100000000000001;
  field_873_j:=1.0;
  field_872_k:=1.0;
  field_871_l:=1;
  field_870_m:=12;
  field_869_n:=4;
  field_882_a[0]:=2;
  field_882_a[1]:=0;
  field_882_a[2]:=0;
  field_882_a[3]:=1;
  field_882_a[4]:=2;
  field_882_a[5]:=1;
  basepos[0]:=0;
  basepos[1]:=0;
  basepos[2]:=0;

  r.SetSeed(sid);
  basepos[0]:=x;
  basepos[1]:=y;
  basepos[2]:=z;

  if field_878_e=0 then field_878_e:=5+r.nextInt(field_870_m);

  if func_519_e<>true then
  begin
    result:=false;
    exit;
  end
  else
  begin
    func_521_a;
    func_518_b;
    func_529_c;
    func_525_d;
    result:=true;

    if (sp=false)and((waterlevel-1)<y) then
  begin
    if (get_block_id(map,xreg,yreg,x+1,y-1,z)<>0)and
    (get_block_id(map,xreg,yreg,x+1,y,z)=0)and
    (get_block_id(map,xreg,yreg,x+1,y+1,z)=0) then
    begin
      //izmenaem spawn
      postmessage(hndl,WM_USER+308,1,x+1); //x
      postmessage(hndl,WM_USER+308,2,y); //y
      postmessage(hndl,WM_USER+308,3,z); //z
      sp:=true;
      b:=true;
    end;

    if (get_block_id(map,xreg,yreg,x-1,y-1,z)<>0)and
    (get_block_id(map,xreg,yreg,x-1,y,z)=0)and
    (get_block_id(map,xreg,yreg,x-1,y+1,z)=0)and
    (b=false) then
    begin
      //izmenaem spawn
      postmessage(hndl,WM_USER+308,1,x-1); //x
      postmessage(hndl,WM_USER+308,2,y); //y
      postmessage(hndl,WM_USER+308,3,z); //z
      sp:=true;
      b:=true;
    end;

    if (get_block_id(map,xreg,yreg,x,y-1,z+1)<>0)and
    (get_block_id(map,xreg,yreg,x,y,z+1)=0)and
    (get_block_id(map,xreg,yreg,x,y+1,z+1)=0)and
    (b=false) then
    begin
      //izmenaem spawn
      postmessage(hndl,WM_USER+308,1,x); //x
      postmessage(hndl,WM_USER+308,2,y); //y
      postmessage(hndl,WM_USER+308,3,z+1); //z
      sp:=true;
      b:=true;
    end;

    if (get_block_id(map,xreg,yreg,x,y-1,z-1)<>0)and
    (get_block_id(map,xreg,yreg,x,y,z-1)=0)and
    (get_block_id(map,xreg,yreg,x,y+1,z-1)=0)and
    (b=false) then
    begin
      //izmenaem spawn
      postmessage(hndl,WM_USER+308,1,x); //x
      postmessage(hndl,WM_USER+308,2,y); //y
      postmessage(hndl,WM_USER+308,3,z-1); //z
      sp:=true;
    end;
  end;

  end;

  for height:=0 to length(field_868_o)-1 do
    setlength(field_868_o[height],0);
  setlength(field_868_o,0);

  r.Free;
end;

function gen_tree_notch(var map:region; xreg,yreg:integer; sid:int64; x,y,z:integer;var sp:boolean; waterlevel:integer; hndl:cardinal; treetype:byte):boolean;
//treetype:
//0 = obichnoe derevo
//1 = bereza
var i,j,k,t,t1:integer;
l3,j4,tt:integer;
len:integer;
b:boolean;
r:rnd;
begin
  r:=rnd.Create(sid);

  len:=r.nextInt(3)+5;
  if (y<0)or((y+1+len)>127) then
  begin
    result:=false;
    r.Free;
    exit;
  end;
  b:=true;
  //proverka voidet li derevo
  for i:=y to y+1+len do
  begin
    t:=1;
    if i=y then t:=0;
    if i>=(y+1+len-2) then t:=2;
    for j:=x-t to x+t do
      for k:=z-t to z+t do
      begin
        t1:=get_block_id(map,xreg,yreg,j,i,k);
        if (t1<>0)and(t1<>18) then b:=false;
      end;
  end;

  if b=false then
  begin
    result:=false;
    r.Free;
    exit;
  end;

  t:=get_block_id(map,xreg,yreg,x,y-1,z);
  if ((t<>3)and(t<>2))or(y>=(127-len-1)) then
  begin
    result:=false;
    r.Free;
    exit;
  end;

  set_block_id(map,xreg,yreg,x,y-1,z,3);

  for i:=(y-3+len) to y+len do
  begin
    t:=i-(y+len);
    t1:=trunc(1-t/2);
    for j:=x-t1 to x+t1 do
    begin
      l3:=j-x;
      for k:=z-t1 to z+t1 do
      begin
        j4:=k-z;
        tt:=r.nextInt(2);
        if (abs(l3)<>t1)or(abs(j4)<>t1)or{(r.nextDouble>0.5)}(tt<>0)and(t<>0) then
          if treetype=0 then
            set_block_id(map,xreg,yreg,j,i,k,18)
          else
            set_block_id_data(map,xreg,yreg,j,i,k,18,2);
      end;
    end;
  end;

  for i:=0 to len-1 do
  begin
    t:=get_block_id(map,xreg,yreg,x,y+i,z);
    if (t=0)or(t=18) then
      if treetype=0 then
        set_block_id(map,xreg,yreg,x,y+i,z,17)
      else
        set_block_id_data(map,xreg,yreg,x,y+i,z,17,2);
  end;

  b:=false;

  if (sp=false)and((waterlevel-1)<y) then
  begin
    if (get_block_id(map,xreg,yreg,x+1,y-1,z)<>0)and
    (get_block_id(map,xreg,yreg,x+1,y,z)=0)and
    (get_block_id(map,xreg,yreg,x+1,y+1,z)=0) then
    begin
      //izmenaem spawn
      postmessage(hndl,WM_USER+308,1,x+1); //x
      postmessage(hndl,WM_USER+308,2,y); //y
      postmessage(hndl,WM_USER+308,3,z); //z
      sp:=true;
      b:=true;
    end;

    if (get_block_id(map,xreg,yreg,x-1,y-1,z)<>0)and
    (get_block_id(map,xreg,yreg,x-1,y,z)=0)and
    (get_block_id(map,xreg,yreg,x-1,y+1,z)=0)and
    (b=false) then
    begin
      //izmenaem spawn
      postmessage(hndl,WM_USER+308,1,x-1); //x
      postmessage(hndl,WM_USER+308,2,y); //y
      postmessage(hndl,WM_USER+308,3,z); //z
      sp:=true;
      b:=true;
    end;

    if (get_block_id(map,xreg,yreg,x,y-1,z+1)<>0)and
    (get_block_id(map,xreg,yreg,x,y,z+1)=0)and
    (get_block_id(map,xreg,yreg,x,y+1,z+1)=0)and
    (b=false) then
    begin
      //izmenaem spawn
      postmessage(hndl,WM_USER+308,1,x); //x
      postmessage(hndl,WM_USER+308,2,y); //y
      postmessage(hndl,WM_USER+308,3,z+1); //z
      sp:=true;
      b:=true;
    end;

    if (get_block_id(map,xreg,yreg,x,y-1,z-1)<>0)and
    (get_block_id(map,xreg,yreg,x,y,z-1)=0)and
    (get_block_id(map,xreg,yreg,x,y+1,z-1)=0)and
    (b=false) then
    begin
      //izmenaem spawn
      postmessage(hndl,WM_USER+308,1,x); //x
      postmessage(hndl,WM_USER+308,2,y); //y
      postmessage(hndl,WM_USER+308,3,z-1); //z
      sp:=true;
      b:=true;
    end;
  end;

  r.Free;
  result:=true;
end;

procedure calc_heightmap(var blocks,heightmap:array of byte);
var i,j,k:integer;
begin
  for i:=0 to 15 do      //Z
    for j:=0 to 15 do      //X
    begin
      for k:=127 downto 0 do  //Y
        if (blocks[k+(i*128+(j*2048))]<>0)and
        (blocks[k+(i*128+(j*2048))]<>20) then
        begin
          if k=127 then heightmap[(i*16)+j]:=127
          else heightmap[(i*16)+j]:=k+1;
          break;
        end;
      if k=0 then heightmap[(i*16)+j]:=0;
    end;
end;

procedure gen_border(xkoord,ykoord,width,len:integer; par_border:border_settings_type; var blocks,data:ar_type; entities:par_entity_type; tileentities:par_tile_entity_type);
var i,j,k:integer;
tempx,tempy,tempk,tempz:integer;
otx,dox,oty,doy:integer;
kol:byte;
r:rnd;
begin
  tempx:=-(width div 2);
  tempy:=-(len div 2);

  //esli nahodimsa za granicey karti
  if (xkoord<tempx)or
  (xkoord>(width div 2)-1)or
  (ykoord<tempy)or
  (ykoord>(len div 2)-1) then exit;

  if par_border.border_type=1 then
  begin
    if par_border.wall_void=true then
    begin
      tempx:=-(width div 2)+par_border.wall_void_thickness;
      tempy:=-(len div 2)+par_border.wall_void_thickness;
      if (xkoord<tempx)or
      (xkoord>(width div 2)-1-par_border.wall_void_thickness)or
      (ykoord<tempy)or
      (ykoord>(len div 2)-1-par_border.wall_void_thickness) then
        zeromemory(blocks,length(blocks))
      else
      begin

      kol:=par_border.wall_material;

      if (xkoord=tempx) then
        for k:=0 to 127 do  //Y
          for j:=0 to 15 do  //Z
            for i:=0 to par_border.wall_thickness-1 do  //X
              blocks[k+(j*128+(i*2048))]:=kol;

      if (xkoord=(width div 2)-1-par_border.wall_void_thickness) then
        for k:=0 to 127 do //Y
          for j:=0 to 15 do  //Z
            for i:=15 downto 16-par_border.wall_thickness do //X
              blocks[k+(j*128+(i*2048))]:=kol;

      if (ykoord=tempy) then
        for k:=0 to 127 do //Y
          for i:=0 to 15 do //X
            for j:=0 to par_border.wall_thickness-1 do //Y
              blocks[k+(j*128+(i*2048))]:=kol;

      if (ykoord=(len div 2)-1-par_border.wall_void_thickness) then
        for k:=0 to 127 do //Y
          for i:=0 to 15 do //X
            for j:=15 downto 16-par_border.wall_thickness do //Y
              blocks[k+(j*128+(i*2048))]:=kol;
      end;
    end
    else
    begin
      tempx:=-(width div 2);
      tempy:=-(len div 2);

      kol:=par_border.wall_material;

      if (xkoord=tempx) then
        for k:=0 to 127 do  //Y
          for j:=0 to 15 do  //Z
            for i:=0 to par_border.wall_thickness-1 do  //X
              blocks[k+(j*128+(i*2048))]:=kol;

      if (xkoord=(width div 2)-1) then
        for k:=0 to 127 do //Y
          for j:=0 to 15 do  //Z
            for i:=15 downto 16-par_border.wall_thickness do //X
              blocks[k+(j*128+(i*2048))]:=kol;

      if (ykoord=tempy) then
        for k:=0 to 127 do //Y
          for i:=0 to 15 do //X
            for j:=0 to par_border.wall_thickness-1 do //Y
              blocks[k+(j*128+(i*2048))]:=kol;

      if (ykoord=(len div 2)-1) then
        for k:=0 to 127 do //Y
          for i:=0 to 15 do //X
            for j:=15 downto 16-par_border.wall_thickness do //Y
              blocks[k+(j*128+(i*2048))]:=kol;
    end;
  end
  else if par_border.border_type=2 then
  begin
    tempx:=-(width div 2)+par_border.void_thickness;
    tempy:=-(len div 2)+par_border.void_thickness;

    if (xkoord<tempx)or
    (xkoord>(width div 2)-1-par_border.void_thickness)or
    (ykoord<tempy)or
    (ykoord>(len div 2)-1-par_border.void_thickness) then
      zeromemory(blocks,length(blocks));
  end
  else if par_border.border_type=3 then
  begin
    if par_border.cwall_gen_void=true then
    begin
      tempx:=-(width div 2)+par_border.cwall_void_width;
      tempy:=-(len div 2)+par_border.cwall_void_width;
      tempk:=(width div 2)-1-par_border.cwall_void_width;
      tempz:=(len div 2)-1-par_border.cwall_void_width;

      if (xkoord<tempx)or
      (xkoord>tempk)or
      (ykoord<tempy)or
      (ykoord>tempz) then
      begin
        zeromemory(blocks,length(blocks));
        zeromemory(data,length(data));
        exit;
      end;
    end
    else
    begin
      tempx:=-(width div 2);
      tempy:=-(len div 2);
      tempk:=(width div 2)-1;
      tempz:=(len div 2)-1;
    end;

    otx:=0;
    dox:=0;
    oty:=0;
    doy:=0;

    if ((xkoord=tempx)or(xkoord=tempk))and    //esli levaya ili pravaya stena
    (ykoord<>tempy)and(ykoord<>tempz) then
    begin
      otx:=3;
      dox:=12;
      oty:=0;
      doy:=15;
      for k:=1 to 100 do //Y
        for i:=otx to dox do //X
          for j:=oty to doy do //Z
            blocks[k+(j*128+(i*2048))]:=4;
      //dobavlaem chastokol
      r:=rnd.Create(xkoord*2331+ykoord*1649);
      for k:=99 to 100 do //Y
        for i:=otx-1 to dox+1 do //X
          for j:=oty to doy do //Z
          begin
            blocks[k+(j*128+(i*2048))]:=4;
            if ((j and 1)=1)and(k=100)and((i=otx-1)or(i=dox+1)) then
            begin
              blocks[k+1+(j*128+(i*2048))]:=44;
              data[k+1+(j*128+(i*2048))]:=3;
            end
            else if (k=100)and((i=otx-1)or(i=dox+1)) then
            begin
              blocks[k+1+(j*128+(i*2048))]:=4;
              if r.nextDouble<0.37 then
              begin
              blocks[k+2+(j*128+(i*2048))]:=50;
              data[k+2+(j*128+(i*2048))]:=5;
              end;
            end;
          end;
      r.Free;
      //dobavlaem relsi
      if par_border.cwall_gen_rails=true then
      for i:=7 to 8 do
        for j:=oty to doy do
          blocks[101+(j*128+(i*2048))]:=66;
      if par_border.cwall_gen_interior=true then
      begin
      //virezaem oblast' vnutri na 0 etazhe
      for k:=91 to 99 do
        for i:=otx+1 to dox-1 do
          for j:=oty to doy do
            blocks[k+(j*128+(i*2048))]:=0;
      //dobavlaem boinici
      if par_border.cwall_gen_boinici=true then
      begin
      case par_border.cwall_boinici_type of
      0:begin  //line
          //air
          blocks[93+(7*128+(3*2048))]:=0;
          blocks[94+(7*128+(3*2048))]:=0;
          blocks[95+(7*128+(3*2048))]:=0;
          //single slab
          blocks[92+(7*128+(3*2048))]:=44;
          //double slab
          blocks[91+(7*128+(3*2048))]:=43;
          blocks[92+(6*128+(3*2048))]:=43;
          blocks[92+(8*128+(3*2048))]:=43;
          blocks[93+(6*128+(3*2048))]:=43;
          blocks[93+(8*128+(3*2048))]:=43;
          blocks[94+(6*128+(3*2048))]:=43;
          blocks[94+(8*128+(3*2048))]:=43;
          blocks[95+(6*128+(3*2048))]:=43;
          blocks[95+(8*128+(3*2048))]:=43;
          blocks[96+(7*128+(3*2048))]:=43;

          //air
          blocks[93+(7*128+(12*2048))]:=0;
          blocks[94+(7*128+(12*2048))]:=0;
          blocks[95+(7*128+(12*2048))]:=0;
          //single slab
          blocks[92+(7*128+(12*2048))]:=44;
          //double slab
          blocks[91+(7*128+(12*2048))]:=43;
          blocks[92+(6*128+(12*2048))]:=43;
          blocks[92+(8*128+(12*2048))]:=43;
          blocks[93+(6*128+(12*2048))]:=43;
          blocks[93+(8*128+(12*2048))]:=43;
          blocks[94+(6*128+(12*2048))]:=43;
          blocks[94+(8*128+(12*2048))]:=43;
          blocks[95+(6*128+(12*2048))]:=43;
          blocks[95+(8*128+(12*2048))]:=43;
          blocks[96+(7*128+(12*2048))]:=43;
        end;
      1:begin  //cross
          //air
          blocks[93+(7*128+(3*2048))]:=0;
          blocks[94+(7*128+(3*2048))]:=0;
          blocks[95+(7*128+(3*2048))]:=0;
          //single slab
          blocks[92+(7*128+(3*2048))]:=44;
          blocks[94+(6*128+(3*2048))]:=44;
          blocks[94+(8*128+(3*2048))]:=44;
          //double slab
          blocks[91+(7*128+(3*2048))]:=43;
          blocks[92+(6*128+(3*2048))]:=43;
          blocks[92+(8*128+(3*2048))]:=43;
          blocks[93+(6*128+(3*2048))]:=43;
          blocks[93+(8*128+(3*2048))]:=43;
          blocks[94+(5*128+(3*2048))]:=43;
          blocks[94+(9*128+(3*2048))]:=43;
          blocks[95+(6*128+(3*2048))]:=43;
          blocks[95+(8*128+(3*2048))]:=43;
          blocks[96+(7*128+(3*2048))]:=43;

          //air
          blocks[93+(7*128+(12*2048))]:=0;
          blocks[94+(7*128+(12*2048))]:=0;
          blocks[95+(7*128+(12*2048))]:=0;
          //single slab
          blocks[92+(7*128+(12*2048))]:=44;
          blocks[94+(6*128+(12*2048))]:=44;
          blocks[94+(8*128+(12*2048))]:=44;
          //double slab
          blocks[91+(7*128+(12*2048))]:=43;
          blocks[92+(6*128+(12*2048))]:=43;
          blocks[92+(8*128+(12*2048))]:=43;
          blocks[93+(6*128+(12*2048))]:=43;
          blocks[93+(8*128+(12*2048))]:=43;
          blocks[94+(5*128+(12*2048))]:=43;
          blocks[94+(9*128+(12*2048))]:=43;
          blocks[95+(6*128+(12*2048))]:=43;
          blocks[95+(8*128+(12*2048))]:=43;
          blocks[96+(7*128+(12*2048))]:=43;
        end;
      2:begin  //square
          //air
          blocks[94+(7*128+(3*2048))]:=0;
          blocks[94+(8*128+(3*2048))]:=0;
          //single slab
          blocks[93+(7*128+(3*2048))]:=44;
          blocks[93+(8*128+(3*2048))]:=44;
          //double slab
          blocks[92+(7*128+(3*2048))]:=43;
          blocks[92+(8*128+(3*2048))]:=43;
          blocks[93+(6*128+(3*2048))]:=43;
          blocks[93+(9*128+(3*2048))]:=43;
          blocks[94+(6*128+(3*2048))]:=43;
          blocks[94+(9*128+(3*2048))]:=43;
          blocks[95+(7*128+(3*2048))]:=43;
          blocks[95+(8*128+(3*2048))]:=43;

          //air
          blocks[94+(7*128+(12*2048))]:=0;
          blocks[94+(8*128+(12*2048))]:=0;
          //single slab
          blocks[93+(7*128+(12*2048))]:=44;
          blocks[93+(8*128+(12*2048))]:=44;
          //double slab
          blocks[92+(7*128+(12*2048))]:=43;
          blocks[92+(8*128+(12*2048))]:=43;
          blocks[93+(6*128+(12*2048))]:=43;
          blocks[93+(9*128+(12*2048))]:=43;
          blocks[94+(6*128+(12*2048))]:=43;
          blocks[94+(9*128+(12*2048))]:=43;
          blocks[95+(7*128+(12*2048))]:=43;
          blocks[95+(8*128+(12*2048))]:=43;
        end;
      end;
      //dobavlaem fakeli dla boinic
      for k:=91 to 96 do
        for j:=5 to 9 do
        begin
          if blocks[k+(j*128+(3*2048))]=43 then
          begin
            blocks[k+(j*128+(4*2048))]:=50;
            data[k+(j*128+(4*2048))]:=1;
          end;
          if blocks[k+(j*128+(12*2048))]=43 then
          begin
            blocks[k+(j*128+(11*2048))]:=50;
            data[k+(j*128+(11*2048))]:=2;
          end;
        end;
      end;
      end;
    end
    else if ((ykoord=tempy)or(ykoord=tempz))and    //esli nizhnaya ili verhnaya stena
    (xkoord<>tempx)and(xkoord<>tempk) then
    begin
      otx:=0;
      dox:=15;
      oty:=3;
      doy:=12;
      for k:=1 to 100 do //Y
        for i:=otx to dox do //X
          for j:=oty to doy do //Z
            blocks[k+(j*128+(i*2048))]:=4;
      //dobavlaem chastokol
      r:=rnd.Create(xkoord*2331+ykoord*1649);
      for k:=99 to 100 do //Y
        for i:=otx to dox do //X
          for j:=oty-1 to doy+1 do //Z
          begin
            blocks[k+(j*128+(i*2048))]:=4;
            if ((i and 1)=1)and(k=100)and((j=oty-1)or(j=doy+1)) then
            begin
              blocks[k+1+(j*128+(i*2048))]:=44;
              data[k+1+(j*128+(i*2048))]:=3;
            end
            else if (k=100)and((j=oty-1)or(j=doy+1)) then
            begin
              blocks[k+1+(j*128+(i*2048))]:=4;
              if r.nextDouble<0.37 then
              begin
              blocks[k+2+(j*128+(i*2048))]:=50;
              data[k+2+(j*128+(i*2048))]:=5;
              end;
            end;
          end;
      r.Free;
      //dobavlaem relsi
      if par_border.cwall_gen_rails=true then
      for i:=otx to dox do
        for j:=7 to 8 do
        begin
          blocks[101+(j*128+(i*2048))]:=66;
          data[101+(j*128+(i*2048))]:=1;
        end;
      if par_border.cwall_gen_interior=true then
      begin
      //virezaem oblast' vnutri na 0 etazhe
      for k:=91 to 99 do
        for i:=otx to dox do
          for j:=oty+1 to doy-1 do
            blocks[k+(j*128+(i*2048))]:=0;
      //dobavlaem boinici
      if par_border.cwall_gen_boinici=true then
      begin
      case par_border.cwall_boinici_type of
      0:begin  //line
          //air
          blocks[93+(3*128+(7*2048))]:=0;
          blocks[94+(3*128+(7*2048))]:=0;
          blocks[95+(3*128+(7*2048))]:=0;
          //single slab
          blocks[92+(3*128+(7*2048))]:=44;
          //double slab
          blocks[91+(3*128+(7*2048))]:=43;
          blocks[92+(3*128+(6*2048))]:=43;
          blocks[92+(3*128+(8*2048))]:=43;
          blocks[93+(3*128+(6*2048))]:=43;
          blocks[93+(3*128+(8*2048))]:=43;
          blocks[94+(3*128+(6*2048))]:=43;
          blocks[94+(3*128+(8*2048))]:=43;
          blocks[95+(3*128+(6*2048))]:=43;
          blocks[95+(3*128+(8*2048))]:=43;
          blocks[96+(3*128+(7*2048))]:=43;

          //air
          blocks[93+(12*128+(7*2048))]:=0;
          blocks[94+(12*128+(7*2048))]:=0;
          blocks[95+(12*128+(7*2048))]:=0;
          //single slab
          blocks[92+(12*128+(7*2048))]:=44;
          //double slab
          blocks[91+(12*128+(7*2048))]:=43;
          blocks[92+(12*128+(6*2048))]:=43;
          blocks[92+(12*128+(8*2048))]:=43;
          blocks[93+(12*128+(6*2048))]:=43;
          blocks[93+(12*128+(8*2048))]:=43;
          blocks[94+(12*128+(6*2048))]:=43;
          blocks[94+(12*128+(8*2048))]:=43;
          blocks[95+(12*128+(6*2048))]:=43;
          blocks[95+(12*128+(8*2048))]:=43;
          blocks[96+(12*128+(7*2048))]:=43;
        end;
      1:begin  //cross
          //air
          blocks[93+(3*128+(7*2048))]:=0;
          blocks[94+(3*128+(7*2048))]:=0;
          blocks[95+(3*128+(7*2048))]:=0;
          //single slab
          blocks[92+(3*128+(7*2048))]:=44;
          blocks[94+(3*128+(6*2048))]:=44;
          blocks[94+(3*128+(8*2048))]:=44;
          //double slab
          blocks[91+(3*128+(7*2048))]:=43;
          blocks[92+(3*128+(6*2048))]:=43;
          blocks[92+(3*128+(8*2048))]:=43;
          blocks[93+(3*128+(6*2048))]:=43;
          blocks[93+(3*128+(8*2048))]:=43;
          blocks[94+(3*128+(5*2048))]:=43;
          blocks[94+(3*128+(9*2048))]:=43;
          blocks[95+(3*128+(6*2048))]:=43;
          blocks[95+(3*128+(8*2048))]:=43;
          blocks[96+(3*128+(7*2048))]:=43;

          //air
          blocks[93+(12*128+(7*2048))]:=0;
          blocks[94+(12*128+(7*2048))]:=0;
          blocks[95+(12*128+(7*2048))]:=0;
          //single slab
          blocks[92+(12*128+(7*2048))]:=44;
          blocks[94+(12*128+(6*2048))]:=44;
          blocks[94+(12*128+(8*2048))]:=44;
          //double slab
          blocks[91+(12*128+(7*2048))]:=43;
          blocks[92+(12*128+(6*2048))]:=43;
          blocks[92+(12*128+(8*2048))]:=43;
          blocks[93+(12*128+(6*2048))]:=43;
          blocks[93+(12*128+(8*2048))]:=43;
          blocks[94+(12*128+(5*2048))]:=43;
          blocks[94+(12*128+(9*2048))]:=43;
          blocks[95+(12*128+(6*2048))]:=43;
          blocks[95+(12*128+(8*2048))]:=43;
          blocks[96+(12*128+(7*2048))]:=43;
        end;
      2:begin  //square
          //air
          blocks[94+(3*128+(7*2048))]:=0;
          blocks[94+(3*128+(8*2048))]:=0;
          //single slab
          blocks[93+(3*128+(7*2048))]:=44;
          blocks[93+(3*128+(8*2048))]:=44;
          //double slab
          blocks[92+(3*128+(7*2048))]:=43;
          blocks[92+(3*128+(8*2048))]:=43;
          blocks[93+(3*128+(6*2048))]:=43;
          blocks[93+(3*128+(9*2048))]:=43;
          blocks[94+(3*128+(6*2048))]:=43;
          blocks[94+(3*128+(9*2048))]:=43;
          blocks[95+(3*128+(7*2048))]:=43;
          blocks[95+(3*128+(8*2048))]:=43;

          //air
          blocks[94+(12*128+(7*2048))]:=0;
          blocks[94+(12*128+(8*2048))]:=0;
          //single slab
          blocks[93+(12*128+(7*2048))]:=44;
          blocks[93+(12*128+(8*2048))]:=44;
          //double slab
          blocks[92+(12*128+(7*2048))]:=43;
          blocks[92+(12*128+(8*2048))]:=43;
          blocks[93+(12*128+(6*2048))]:=43;
          blocks[93+(12*128+(9*2048))]:=43;
          blocks[94+(12*128+(6*2048))]:=43;
          blocks[94+(12*128+(8*2048))]:=43;
          blocks[95+(12*128+(7*2048))]:=43;
          blocks[95+(12*128+(8*2048))]:=43;
        end;
      end;
      //dobavlaem fakeli dla boinic
      for k:=91 to 96 do
        for j:=5 to 9 do
        begin
          if blocks[k+(3*128+(j*2048))]=43 then
          begin
            blocks[k+(4*128+(j*2048))]:=50;
            data[k+(4*128+(j*2048))]:=3;
          end;
          if blocks[k+(12*128+(j*2048))]=43 then
          begin
            blocks[k+(11*128+(j*2048))]:=50;
            data[k+(11*128+(j*2048))]:=4;
          end;
        end;
      end;
      end;
    end
    else if (xkoord=tempx)and(ykoord=tempy) then
    begin
      otx:=3;
      dox:=15;
      oty:=3;
      doy:=15;
      //generim bashnu
      if par_border.cwall_gen_towers=true then
      begin
        for k:=1 to 120 do //Y
          for i:=1 to 14 do //X
            for j:=1 to 14 do //Z
              blocks[k+(j*128+(i*2048))]:=4;
        for k:=1 to 100 do
          for i:=3 to 12 do
          begin
            blocks[k+(15*128+(i*2048))]:=4;
            blocks[k+(i*128+(15*2048))]:=4;
          end;
        for k:=99 to 101 do    //chastokol na bloke, prilegayushem k bashne
        begin
          blocks[k+(15*128+(2*2048))]:=4;
          blocks[k+(15*128+(13*2048))]:=4;
          blocks[k+(2*128+(15*2048))]:=4;
          blocks[k+(13*128+(15*2048))]:=4;
        end;
        //virezaem prohodi na steni
        for k:=101 to 104 do
          for i:=6 to 9 do
          begin
            blocks[k+(14*128+(i*2048))]:=0;
            blocks[k+(i*128+(14*2048))]:=0;
          end;
        //virezaem vnutrennuyu komnatu
        for k:=101 to 109 do
          for i:=2 to 13 do
            for j:=2 to 13 do
              blocks[k+(j*128+(i*2048))]:=0;
        //virezaem vnutrennuyu komnatu 2 etazh
        for k:=111 to 119 do
          for i:=2 to 13 do
            for j:=2 to 13 do
              blocks[k+(j*128+(i*2048))]:=0;
        //delaem lestnicu s 1 etazha do krishi
        for k:=101 to 120 do
        begin
          blocks[k+(13*128+(13*2048))]:=65;
          data[k+(13*128+(13*2048))]:=2;
        end;
        if par_border.cwall_gen_interior=true then
        begin
        //virezaem vnutrennuyu komnatu 0 etazh
        for k:=91 to 99 do
          for i:=2 to 13 do
            for j:=2 to 13 do
              blocks[k+(j*128+(i*2048))]:=0;
        //delaem lestnicu s 0 do 1 etazha
        for k:=91 to 100 do
        begin
          blocks[k+(13*128+(13*2048))]:=65;
          data[k+(13*128+(13*2048))]:=2;
        end;

        //ubiraem dopolnitel'niy sloy blokov na 0 etazhe
        for i:=4 to 11 do
          for k:=91 to 98 do
          begin
            blocks[k+(15*128+(i*2048))]:=0;
            blocks[k+(i*128+(15*2048))]:=0;
          end;
        //virezaem prohodi na 0 etazh
        for i:=6 to 9 do
          for k:=91 to 94 do
          begin
            blocks[k+(i*128+(14*2048))]:=0;
            blocks[k+(14*128+(i*2048))]:=0;
          end;
        end;
        //stavim fakeli v prohodi na steni
        for i:=5 to 10 do
        begin
          if (i<>5)and(i<>10) then continue;
          if par_border.cwall_gen_interior=true then
          begin
          blocks[92+(15*128+(i*2048))]:=50;
          data[92+(15*128+(i*2048))]:=3;
          blocks[92+(i*128+(13*2048))]:=50;
          data[92+(i*128+(13*2048))]:=2;
          blocks[92+(13*128+(i*2048))]:=50;
          data[92+(13*128+(i*2048))]:=4;
          blocks[92+(i*128+(15*2048))]:=50;
          data[92+(i*128+(15*2048))]:=1;
          end;
          blocks[102+(15*128+(i*2048))]:=50;
          data[102+(15*128+(i*2048))]:=3;
          blocks[102+(i*128+(13*2048))]:=50;
          data[102+(i*128+(13*2048))]:=2;
          blocks[102+(13*128+(i*2048))]:=50;
          data[102+(13*128+(i*2048))]:=4;
          blocks[102+(i*128+(15*2048))]:=50;
          data[102+(i*128+(15*2048))]:=1;
        end;
        //delaem relsi
        if par_border.cwall_gen_rails=true then
        begin
        blocks[101+(8*128+(8*2048))]:=66;   //centr
        data[101+(8*128+(8*2048))]:=6;
        blocks[101+(7*128+(15*2048))]:=66;           //pravo
        data[101+(7*128+(15*2048))]:=7;
        blocks[101+(8*128+(15*2048))]:=66;
        data[101+(8*128+(15*2048))]:=9;
        blocks[101+(7*128+(14*2048))]:=66;
        data[101+(7*128+(14*2048))]:=6;
        blocks[101+(8*128+(14*2048))]:=66;
        data[101+(8*128+(14*2048))]:=8;
        blocks[101+(15*128+(7*2048))]:=66;           //niz
        data[101+(15*128+(7*2048))]:=6;
        blocks[101+(15*128+(8*2048))]:=66;
        data[101+(15*128+(8*2048))]:=8;
        //pramie
        for i:=3 to 13 do
        begin
          if i=8 then continue;
          blocks[101+(8*128+(i*2048))]:=27;
          if i=3 then data[101+(8*128+(i*2048))]:=3
          else if i<8 then data[101+(8*128+(i*2048))]:=1
          else data[101+(8*128+(i*2048))]:=9;
        end;
        for i:=3 to 14 do
        begin
          if i=8 then continue;
          blocks[101+(i*128+(8*2048))]:=27;
          if i=3 then data[101+(i*128+(8*2048))]:=4
          else if i<8 then data[101+(i*128+(8*2048))]:=0
          else data[101+(i*128+(8*2048))]:=8;
        end;
        //cobl v nachale busterov
        blocks[101+(8*128+(2*2048))]:=4;
        blocks[102+(8*128+(2*2048))]:=4;
        blocks[101+(2*128+(8*2048))]:=4;
        blocks[102+(2*128+(8*2048))]:=4;
        //cobl dla knopok
        blocks[101+(7*128+(7*2048))]:=4;
        //fakel na coble
        blocks[102+(7*128+(7*2048))]:=50;
        data[102+(7*128+(7*2048))]:=5;
        //knopki
        blocks[101+(7*128+(6*2048))]:=77;
        blocks[101+(6*128+(7*2048))]:=77;
        data[101+(7*128+(6*2048))]:=2;
        data[101+(6*128+(7*2048))]:=4;
        //redstone fakel
        blocks[101+(9*128+(9*2048))]:=76;
        data[101+(9*128+(9*2048))]:=5;
        //delaem sunduki
        if (tileentities<>nil) then
        begin
          i:=length(tileentities^);
          setlength(tileentities^,i+1);
          tileentities^[i].id:='Chest';

          tileentities^[i].x:=xkoord*16+2;
          tileentities^[i].y:=101;
          tileentities^[i].z:=ykoord*16+2;
          blocks[101+(2*128+(2*2048))]:=54;

          new(pchest_tile_entity_data(tileentities^[i].dannie));
          setlength(pchest_tile_entity_data(tileentities^[i].dannie)^.items,5);
          for k:=0 to 4 do
          begin
            pchest_tile_entity_data(tileentities^[i].dannie)^.items[k].id:=328;
            pchest_tile_entity_data(tileentities^[i].dannie)^.items[k].damage:=0;
            pchest_tile_entity_data(tileentities^[i].dannie)^.items[k].count:=1;
            pchest_tile_entity_data(tileentities^[i].dannie)^.items[k].slot:=k;
          end;
        end;
        end;

        //delaem chastokol na bashne
        for i:=0 to 15 do
          for j:=0 to 15 do
            if ((j=0)or(j=15))or((i=0)or(i=15)) then
            begin
              blocks[120+(j*128+(i*2048))]:=4;
              blocks[119+(j*128+(i*2048))]:=4;
              if (((i and 1)=1)and((j=0)or(j=15)))or
              (((j and 1)=1)and((i=0)or(i=15)))or
              ((i=0)and(j=0))or((i=0)and(j=15))or
              ((i=15)and(j=0))or((i=15)and(j=15)) then
              begin
                blocks[121+(j*128+(i*2048))]:=4;
                blocks[122+(j*128+(i*2048))]:=50;
                data[122+(j*128+(i*2048))]:=5;
              end
              else
              begin
                blocks[121+(j*128+(i*2048))]:=44;
                data[121+(j*128+(i*2048))]:=3;
              end;
            end;
        //delaem boinici
        if (par_border.cwall_gen_interior=true)and(par_border.cwall_gen_boinici=true) then
        gen_border_cwall_boinici(par_border.cwall_boinici_type,1,blocks,data);
        //delaem fakeli na boinicah
        for i:=1 to 14 do
          for j:=1 to 14 do
          begin
            if (i<>1)and(i<>14)and(j<>1)and(j<>14) then continue;
            for k:=91 to 118 do
            begin
              //proveraem levo
              if (i=1)and(blocks[k+(j*128+(i*2048))]=43) then
              begin
                blocks[k+(j*128+((i+1)*2048))]:=50;
                data[k+(j*128+((i+1)*2048))]:=1;
              end;
              //proveraem pravo
              if (i=14)and(blocks[k+(j*128+(i*2048))]=43) then
              begin
                blocks[k+(j*128+((i-1)*2048))]:=50;
                data[k+(j*128+((i-1)*2048))]:=2;
              end;
              //proveraem niz
              if (j=1)and(blocks[k+(j*128+(i*2048))]=43) then
              begin
                blocks[k+((j+1)*128+(i*2048))]:=50;
                data[k+((j+1)*128+(i*2048))]:=3;
              end;
              //proveraem verh
              if (j=14)and(blocks[k+(j*128+(i*2048))]=43) then
              begin
                blocks[k+((j-1)*128+(i*2048))]:=50;
                data[k+((j-1)*128+(i*2048))]:=4;
              end;
            end;
          end;
      end
      else
      begin
        //generim osnovanie steni
        for k:=1 to 100 do   //Y
          for i:=3 to 12 do   //X
            for j:=3 to 12 do  //Z
              blocks[k+(j*128+(i*2048))]:=4;
        //generim soedinenie so stenami
        for k:=1 to 100 do
          for i:=3 to 12 do
            for j:=0 to 2 do
            begin
              blocks[k+((13+j)*128+(i*2048))]:=4;
              blocks[k+(i*128+((13+j)*2048))]:=4;
            end;
        //generim chastokol dla sekcii soedineniya
          for i:=2 to 13 do
            for j:=0 to 2 do
              if (i=2)or(i=13) then
              begin
                //osnovanie
                blocks[99+((13+j)*128+(i*2048))]:=4;
                blocks[99+(i*128+((13+j)*2048))]:=4;
                blocks[100+((13+j)*128+(i*2048))]:=4;
                blocks[100+(i*128+((13+j)*2048))]:=4;
                //chastokol
                if (j and 1)=1 then
                begin
                  blocks[101+((13+j)*128+(i*2048))]:=4;
                  blocks[102+((13+j)*128+(i*2048))]:=50;
                  data[102+((13+j)*128+(i*2048))]:=5;
                  blocks[101+(i*128+((13+j)*2048))]:=4;
                  blocks[102+(i*128+((13+j)*2048))]:=50;
                  data[102+(i*128+((13+j)*2048))]:=5;
                end
                else
                begin
                  blocks[101+((13+j)*128+(i*2048))]:=44;
                  data[101+((13+j)*128+(i*2048))]:=3;
                  blocks[101+(i*128+((13+j)*2048))]:=44;
                  data[101+(i*128+((13+j)*2048))]:=3;
                end;
              end;
        //generim chastokol dla osnovaniya
        for i:=2 to 12 do  //X
          for j:=2 to 12 do  //Z
            if (i=2)or(j=2) then
              begin
                //osnovanie
                blocks[99+(j*128+(i*2048))]:=4;
                blocks[100+(j*128+(i*2048))]:=4;
                //chastokol
                if (((j and 1)=0)and(i=2))or
                (((i and 1)=0)and(j=2)) then
                begin
                  blocks[101+(j*128+(i*2048))]:=4;
                  blocks[102+(j*128+(i*2048))]:=50;
                  data[102+(j*128+(i*2048))]:=5;
                end
                else
                begin
                  blocks[101+(j*128+(i*2048))]:=44;
                  data[101+(j*128+(i*2048))]:=3;
                end;
              end;
      end;
    end
    else if (xkoord=tempx)and(ykoord=tempz) then
    begin
      otx:=3;
      dox:=15;
      oty:=0;
      doy:=12;
      //generim bashnu
      if par_border.cwall_gen_towers=true then
      begin
        for k:=1 to 120 do //Y
          for i:=1 to 14 do //X
            for j:=1 to 14 do //Z
              blocks[k+(j*128+(i*2048))]:=4;
        for k:=1 to 100 do
          for i:=3 to 12 do
          begin
            blocks[k+(i*2048)]:=4;
            blocks[k+(i*128+(15*2048))]:=4;
          end;
        for k:=99 to 101 do    //chastokol na bloke, prilegayushem k bashne
        begin
          blocks[k+(2*2048)]:=4;
          blocks[k+(13*2048)]:=4;
          blocks[k+(2*128+(15*2048))]:=4;
          blocks[k+(13*128+(15*2048))]:=4;
        end;
        //virezaem prohodi na steni
        for k:=101 to 104 do
          for i:=6 to 9 do
          begin
            blocks[k+(1*128+(i*2048))]:=0;
            blocks[k+(i*128+(14*2048))]:=0;
          end;
        //virezaem vnutrennuyu komnatu
        for k:=101 to 109 do
          for i:=2 to 13 do
            for j:=2 to 13 do
              blocks[k+(j*128+(i*2048))]:=0;
        //virezaem vnutrennuyu komnatu 2 etazh
        for k:=111 to 119 do
          for i:=2 to 13 do
            for j:=2 to 13 do
              blocks[k+(j*128+(i*2048))]:=0;
        //delaem lestnicu s 1 etazha do krishi
        for k:=101 to 120 do
        begin
          blocks[k+(2*128+(13*2048))]:=65;
          data[k+(2*128+(13*2048))]:=3;
        end;
        if par_border.cwall_gen_interior=true then
        begin
        //virezaem vnutrennuyu komnatu 0 etazh
        for k:=91 to 99 do
          for i:=2 to 13 do
            for j:=2 to 13 do
              blocks[k+(j*128+(i*2048))]:=0;

        //delaem lestnicu s 0 etazha do 1
        for k:=91 to 100 do
        begin
          blocks[k+(2*128+(13*2048))]:=65;
          data[k+(2*128+(13*2048))]:=3;
        end;

        //ubiraem dopolnitel'niy sloy blokov na 0 etazhe
        for i:=4 to 11 do
          for k:=91 to 98 do
          begin
            blocks[k+(i*2048)]:=0;
            blocks[k+(i*128+(15*2048))]:=0;
          end;
        //virezaem prohodi na 0 etazh
        for i:=6 to 9 do
          for k:=91 to 94 do
          begin
            blocks[k+(i*128+(14*2048))]:=0;
            blocks[k+(1*128+(i*2048))]:=0;
          end;
        end;
        //stavim fakeli v prohodi na steni
        for i:=5 to 10 do
        begin
          if (i<>5)and(i<>10) then continue;
          if par_border.cwall_gen_interior=true then
          begin
          blocks[92+(i*2048)]:=50;
          data[92+(i*2048)]:=4;
          blocks[92+(i*128+(13*2048))]:=50;
          data[92+(i*128+(13*2048))]:=2;
          blocks[92+(2*128+(i*2048))]:=50;
          data[92+(2*128+(i*2048))]:=3;
          blocks[92+(i*128+(15*2048))]:=50;
          data[92+(i*128+(15*2048))]:=1;
          end;
          blocks[102+(i*2048)]:=50;
          data[102+(i*2048)]:=4;
          blocks[102+(i*128+(13*2048))]:=50;
          data[102+(i*128+(13*2048))]:=2;
          blocks[102+(2*128+(i*2048))]:=50;
          data[102+(2*128+(i*2048))]:=3;
          blocks[102+(i*128+(15*2048))]:=50;
          data[102+(i*128+(15*2048))]:=1;
        end;
        //delaem relsi
        if par_border.cwall_gen_rails=true then
        begin
        blocks[101+(8*128+(8*2048))]:=66;   //centr
        data[101+(8*128+(8*2048))]:=9;
        blocks[101+(7*128+(15*2048))]:=66;           //pravo
        data[101+(7*128+(15*2048))]:=7;
        blocks[101+(8*128+(15*2048))]:=66;
        data[101+(8*128+(15*2048))]:=9;
        blocks[101+(7*128+(14*2048))]:=66;
        data[101+(7*128+(14*2048))]:=6;
        blocks[101+(8*128+(14*2048))]:=66;
        data[101+(8*128+(14*2048))]:=8;
        blocks[101+(7*2048)]:=66;           //niz
        data[101+(7*2048)]:=6;
        blocks[101+(8*2048)]:=66;
        data[101+(8*2048)]:=8;
        blocks[101+128+(7*2048)]:=66;
        data[101+128+(7*2048)]:=9;
        blocks[101+128+(8*2048)]:=66;
        data[101+128+(8*2048)]:=7;
        //pramie
        for i:=3 to 13 do
        begin
          if i=8 then continue;
          blocks[101+(8*128+(i*2048))]:=27;
          if i=3 then data[101+(8*128+(i*2048))]:=3
          else if i<8 then data[101+(8*128+(i*2048))]:=1
          else data[101+(8*128+(i*2048))]:=9;
        end;
        for i:=2 to 12 do
        begin
          if i=8 then continue;
          blocks[101+(i*128+(8*2048))]:=27;
          if i=12 then data[101+(i*128+(8*2048))]:=5
          else if i>8 then data[101+(i*128+(8*2048))]:=0
          else data[101+(i*128+(8*2048))]:=8;
        end;
        //cobl v nachale busterov
        blocks[101+(8*128+(2*2048))]:=4;
        blocks[102+(8*128+(2*2048))]:=4;
        blocks[101+(13*128+(8*2048))]:=4;
        blocks[102+(13*128+(8*2048))]:=4;
        //cobl dla knopok
        blocks[101+(9*128+(7*2048))]:=4;
        //fakel na coble
        blocks[102+(9*128+(7*2048))]:=50;
        data[102+(9*128+(7*2048))]:=5;
        //knopki
        blocks[101+(9*128+(6*2048))]:=77;
        blocks[101+(10*128+(7*2048))]:=77;
        data[101+(9*128+(6*2048))]:=2;
        data[101+(10*128+(7*2048))]:=3;
        //redstone fakel
        blocks[101+(7*128+(9*2048))]:=76;
        data[101+(7*128+(9*2048))]:=5;
        //delaem sunduki
        if (tileentities<>nil) then
        begin
          i:=length(tileentities^);
          setlength(tileentities^,i+1);
          tileentities^[i].id:='Chest';

          tileentities^[i].x:=xkoord*16+2;
          tileentities^[i].y:=101;
          tileentities^[i].z:=ykoord*16+13;
          blocks[101+(13*128+(2*2048))]:=54;

          new(pchest_tile_entity_data(tileentities^[i].dannie));
          setlength(pchest_tile_entity_data(tileentities^[i].dannie)^.items,5);
          for k:=0 to 4 do
          begin
            pchest_tile_entity_data(tileentities^[i].dannie)^.items[k].id:=328;
            pchest_tile_entity_data(tileentities^[i].dannie)^.items[k].damage:=0;
            pchest_tile_entity_data(tileentities^[i].dannie)^.items[k].count:=1;
            pchest_tile_entity_data(tileentities^[i].dannie)^.items[k].slot:=k;
          end;
        end;
        end;

        //delaem chastokol na bashne
        for i:=0 to 15 do
          for j:=0 to 15 do
            if ((j=0)or(j=15))or((i=0)or(i=15)) then
            begin
              blocks[120+(j*128+(i*2048))]:=4;
              blocks[119+(j*128+(i*2048))]:=4;
              if (((i and 1)=1)and((j=0)or(j=15)))or
              (((j and 1)=1)and((i=0)or(i=15)))or
              ((i=0)and(j=0))or((i=0)and(j=15))or
              ((i=15)and(j=0))or((i=15)and(j=15)) then
              begin
                blocks[121+(j*128+(i*2048))]:=4;
                blocks[122+(j*128+(i*2048))]:=50;
                data[122+(j*128+(i*2048))]:=5;
              end
              else
              begin
                blocks[121+(j*128+(i*2048))]:=44;
                data[121+(j*128+(i*2048))]:=3;
              end;
            end;
        //delaem boinici
        if (par_border.cwall_gen_interior=true)and(par_border.cwall_gen_boinici=true) then
        gen_border_cwall_boinici(par_border.cwall_boinici_type,2,blocks,data);
        //delaem fakeli na boinicah
        for i:=1 to 14 do
          for j:=1 to 14 do
          begin
            if (i<>1)and(i<>14)and(j<>1)and(j<>14) then continue;
            for k:=91 to 118 do
            begin
              //proveraem levo
              if (i=1)and(blocks[k+(j*128+(i*2048))]=43) then
              begin
                blocks[k+(j*128+((i+1)*2048))]:=50;
                data[k+(j*128+((i+1)*2048))]:=1;
              end;
              //proveraem pravo
              if (i=14)and(blocks[k+(j*128+(i*2048))]=43) then
              begin
                blocks[k+(j*128+((i-1)*2048))]:=50;
                data[k+(j*128+((i-1)*2048))]:=2;
              end;
              //proveraem niz
              if (j=1)and(blocks[k+(j*128+(i*2048))]=43) then
              begin
                blocks[k+((j+1)*128+(i*2048))]:=50;
                data[k+((j+1)*128+(i*2048))]:=3;
              end;
              //proveraem verh
              if (j=14)and(blocks[k+(j*128+(i*2048))]=43) then
              begin
                blocks[k+((j-1)*128+(i*2048))]:=50;
                data[k+((j-1)*128+(i*2048))]:=4;
              end;
            end;
          end;
      end
      else
      begin
        //generim osnovanie steni
        for k:=1 to 100 do   //Y
          for i:=3 to 12 do   //X
            for j:=3 to 12 do  //Z
              blocks[k+(j*128+(i*2048))]:=4;
        //generim soedinenie so stenami
        for k:=1 to 100 do
          for i:=3 to 12 do
            for j:=0 to 2 do
            begin
              blocks[k+(j*128+(i*2048))]:=4;
              blocks[k+(i*128+((13+j)*2048))]:=4;
            end;
        //generim chastokol dla sekcii soedineniya
          for i:=2 to 13 do
            for j:=0 to 2 do
              if (i=2)or(i=13) then
              begin
                //osnovanie
                blocks[99+(j*128+(i*2048))]:=4;
                blocks[99+(i*128+((13+j)*2048))]:=4;
                blocks[100+(j*128+(i*2048))]:=4;
                blocks[100+(i*128+((13+j)*2048))]:=4;
                //chastokol
                if ((j and 1)=0) then
                begin
                  blocks[101+(j*128+(i*2048))]:=4;
                  blocks[102+(j*128+(i*2048))]:=50;
                  data[102+(j*128+(i*2048))]:=5;

                  blocks[101+(i*128+((13+j)*2048))]:=44;
                  data[101+(i*128+((13+j)*2048))]:=3;
                end
                else
                begin
                  blocks[101+(j*128+(i*2048))]:=44;
                  data[101+(j*128+(i*2048))]:=3;

                  blocks[101+(i*128+((13+j)*2048))]:=4;
                  blocks[102+(i*128+((13+j)*2048))]:=50;
                  data[102+(i*128+((13+j)*2048))]:=5;
                end;
              end;
        //generim chastokol dla osnovaniya
        for i:=2 to 12 do  //X
          for j:=3 to 13 do  //Z
            if (i=2)or(j=13) then
              begin
                //osnovanie
                blocks[99+(j*128+(i*2048))]:=4;
                blocks[100+(j*128+(i*2048))]:=4;
                //chastokol
                if (((j and 1)=0)and(i=2))or
                (((i and 1)=0)and(j=13)) then
                begin
                  blocks[101+(j*128+(i*2048))]:=4;
                  blocks[102+(j*128+(i*2048))]:=50;
                  data[102+(j*128+(i*2048))]:=5;
                end
                else
                begin
                  blocks[101+(j*128+(i*2048))]:=44;
                  data[101+(j*128+(i*2048))]:=3;
                end;
              end;
      end;
    end
    else if (xkoord=tempk)and(ykoord=tempy) then
    begin
      otx:=0;
      dox:=12;
      oty:=3;
      doy:=15;
      //generim bashnu
      if par_border.cwall_gen_towers=true then
      begin
        for k:=1 to 120 do //Y
          for i:=1 to 14 do //X
            for j:=1 to 14 do //Z
              blocks[k+(j*128+(i*2048))]:=4;
        for k:=1 to 100 do
          for i:=3 to 12 do
          begin
            blocks[k+(15*128+(i*2048))]:=4;
            blocks[k+(i*128)]:=4;
          end;
        for k:=99 to 101 do     //chastokol na bloke, prilegayushem k bashne
        begin
          blocks[k+(15*128+(2*2048))]:=4;
          blocks[k+(15*128+(13*2048))]:=4;
          blocks[k+(2*128)]:=4;
          blocks[k+(13*128)]:=4;
        end;
        //virezaem prohodi na steni
        for k:=101 to 104 do
          for i:=6 to 9 do
          begin
            blocks[k+(14*128+(i*2048))]:=0;
            blocks[k+(i*128+(1*2048))]:=0;
          end;
        //virezaem vnutrennuyu komnatu
        for k:=101 to 109 do
          for i:=2 to 13 do
            for j:=2 to 13 do
              blocks[k+(j*128+(i*2048))]:=0;
        //virezaem vnutrennuyu komnatu 2 etazh
        for k:=111 to 119 do
          for i:=2 to 13 do
            for j:=2 to 13 do
              blocks[k+(j*128+(i*2048))]:=0;
        //delaem lestnicu s 1 etazha do krishi
        for k:=101 to 120 do
        begin
          blocks[k+(13*128+(2*2048))]:=65;
          data[k+(13*128+(2*2048))]:=2;
        end;

        if par_border.cwall_gen_interior=true then
        begin
        //virezaem vnutrennuyu komnatu 0 etazh
        for k:=91 to 99 do
          for i:=2 to 13 do
            for j:=2 to 13 do
              blocks[k+(j*128+(i*2048))]:=0;
        //delaem lestnicu s 0 etazha do 1
        for k:=91 to 100 do
        begin
          blocks[k+(13*128+(2*2048))]:=65;
          data[k+(13*128+(2*2048))]:=2;
        end;
        //ubiraem dopolnitel'niy sloy blokov na 0 etazhe
        for i:=4 to 11 do
          for k:=91 to 98 do
          begin
            blocks[k+(15*128+(i*2048))]:=0;
            blocks[k+(i*128)]:=0;
          end;
        //virezaem prohodi na 0 etazh
        for i:=6 to 9 do
          for k:=91 to 94 do
          begin
            blocks[k+(14*128+(i*2048))]:=0;
            blocks[k+(i*128+(1*2048))]:=0;
          end;
        end;
        //stavim fakeli v prohodi na steni
        for i:=5 to 10 do
        begin
          if (i<>5)and(i<>10) then continue;
          if par_border.cwall_gen_interior=true then
          begin
          blocks[92+(i*128)]:=50;
          data[92+(i*128)]:=2;
          blocks[92+(13*128+(i*2048))]:=50;
          data[92+(13*128+(i*2048))]:=4;
          blocks[92+(i*128+(2*2048))]:=50;
          data[92+(i*128+(2*2048))]:=1;
          blocks[92+(15*128+(i*2048))]:=50;
          data[92+(15*128+(i*2048))]:=3;
          end;
          blocks[102+(i*128)]:=50;
          data[102+(i*128)]:=2;
          blocks[102+(13*128+(i*2048))]:=50;
          data[102+(13*128+(i*2048))]:=4;
          blocks[102+(i*128+(2*2048))]:=50;
          data[102+(i*128+(2*2048))]:=1;
          blocks[102+(15*128+(i*2048))]:=50;
          data[102+(15*128+(i*2048))]:=3;
        end;
        //delaem relsi
        if par_border.cwall_gen_rails=true then
        begin
        blocks[101+(8*128+(8*2048))]:=66;   //centr
        data[101+(8*128+(8*2048))]:=7;
        blocks[101+(7*128)]:=66;           //levo
        data[101+(7*128)]:=7;
        blocks[101+(8*128)]:=66;
        data[101+(8*128)]:=9;
        blocks[101+(15*128+(7*2048))]:=66;           //niz
        data[101+(15*128+(7*2048))]:=6;
        blocks[101+(15*128+(8*2048))]:=66;
        data[101+(15*128+(8*2048))]:=8;
        //pramie
        for i:=1 to 12 do
        begin
          if i=8 then continue;
          blocks[101+(8*128+(i*2048))]:=27;
          if i=12 then data[101+(8*128+(i*2048))]:=2
          else if i>8 then data[101+(8*128+(i*2048))]:=1
          else data[101+(8*128+(i*2048))]:=9;
        end;
        for i:=3 to 14 do
        begin
          if i=8 then continue;
          blocks[101+(i*128+(8*2048))]:=27;
          if i=3 then data[101+(i*128+(8*2048))]:=4
          else if i<8 then data[101+(i*128+(8*2048))]:=0
          else data[101+(i*128+(8*2048))]:=8;
        end;
        //cobl v nachale busterov
        blocks[101+(8*128+(13*2048))]:=4;
        blocks[102+(8*128+(13*2048))]:=4;
        blocks[101+(2*128+(8*2048))]:=4;
        blocks[102+(2*128+(8*2048))]:=4;
        //cobl dla knopok
        blocks[101+(7*128+(9*2048))]:=4;
        //fakel na coble
        blocks[102+(7*128+(9*2048))]:=50;
        data[102+(7*128+(9*2048))]:=5;
        //knopki
        blocks[101+(6*128+(9*2048))]:=77;
        blocks[101+(7*128+(10*2048))]:=77;
        data[101+(6*128+(9*2048))]:=4;
        data[101+(7*128+(10*2048))]:=1;
        //redstone fakel
        blocks[101+(9*128+(7*2048))]:=76;
        data[101+(9*128+(7*2048))]:=5;
        //delaem sunduki
        if (tileentities<>nil) then
        begin
          i:=length(tileentities^);
          setlength(tileentities^,i+1);
          tileentities^[i].id:='Chest';

          tileentities^[i].x:=xkoord*16+13;
          tileentities^[i].y:=101;
          tileentities^[i].z:=ykoord*16+2;
          blocks[101+(2*128+(13*2048))]:=54;

          new(pchest_tile_entity_data(tileentities^[i].dannie));
          setlength(pchest_tile_entity_data(tileentities^[i].dannie)^.items,5);
          for k:=0 to 4 do
          begin
            pchest_tile_entity_data(tileentities^[i].dannie)^.items[k].id:=328;
            pchest_tile_entity_data(tileentities^[i].dannie)^.items[k].damage:=0;
            pchest_tile_entity_data(tileentities^[i].dannie)^.items[k].count:=1;
            pchest_tile_entity_data(tileentities^[i].dannie)^.items[k].slot:=k;
          end;
        end;
        end;

        //delaem chastokol na bashne
        for i:=0 to 15 do
          for j:=0 to 15 do
            if ((j=0)or(j=15))or((i=0)or(i=15)) then
            begin
              blocks[120+(j*128+(i*2048))]:=4;
              blocks[119+(j*128+(i*2048))]:=4;
              if (((i and 1)=1)and((j=0)or(j=15)))or
              (((j and 1)=1)and((i=0)or(i=15)))or
              ((i=0)and(j=0))or((i=0)and(j=15))or
              ((i=15)and(j=0))or((i=15)and(j=15)) then
              begin
                blocks[121+(j*128+(i*2048))]:=4;
                blocks[122+(j*128+(i*2048))]:=50;
                data[122+(j*128+(i*2048))]:=5;
              end
              else
              begin
                blocks[121+(j*128+(i*2048))]:=44;
                data[121+(j*128+(i*2048))]:=3;
              end;
            end;
        //delaem boinici
        if (par_border.cwall_gen_interior=true)and(par_border.cwall_gen_boinici=true) then
        gen_border_cwall_boinici(par_border.cwall_boinici_type,3,blocks,data);
        //delaem fakeli na boinicah
        for i:=1 to 14 do
          for j:=1 to 14 do
          begin
            if (i<>1)and(i<>14)and(j<>1)and(j<>14) then continue;
            for k:=91 to 118 do
            begin
              //proveraem levo
              if (i=1)and(blocks[k+(j*128+(i*2048))]=43) then
              begin
                blocks[k+(j*128+((i+1)*2048))]:=50;
                data[k+(j*128+((i+1)*2048))]:=1;
              end;
              //proveraem pravo
              if (i=14)and(blocks[k+(j*128+(i*2048))]=43) then
              begin
                blocks[k+(j*128+((i-1)*2048))]:=50;
                data[k+(j*128+((i-1)*2048))]:=2;
              end;
              //proveraem niz
              if (j=1)and(blocks[k+(j*128+(i*2048))]=43) then
              begin
                blocks[k+((j+1)*128+(i*2048))]:=50;
                data[k+((j+1)*128+(i*2048))]:=3;
              end;
              //proveraem verh
              if (j=14)and(blocks[k+(j*128+(i*2048))]=43) then
              begin
                blocks[k+((j-1)*128+(i*2048))]:=50;
                data[k+((j-1)*128+(i*2048))]:=4;
              end;
            end;
          end;
      end
      else
      begin
        //generim osnovanie steni
        for k:=1 to 100 do   //Y
          for i:=3 to 12 do   //X
            for j:=3 to 12 do  //Z
              blocks[k+(j*128+(i*2048))]:=4;
        //generim soedinenie so stenami
        for k:=1 to 100 do
          for i:=3 to 12 do
            for j:=0 to 2 do
            begin
              blocks[k+((13+j)*128+(i*2048))]:=4;
              blocks[k+(i*128+(j*2048))]:=4;
            end;
        //generim chastokol dla sekcii soedineniya
          for i:=2 to 13 do
            for j:=0 to 2 do
              if (i=2)or(i=13) then
              begin
                //osnovanie
                blocks[99+((13+j)*128+(i*2048))]:=4;
                blocks[99+(i*128+(j*2048))]:=4;
                blocks[100+((13+j)*128+(i*2048))]:=4;
                blocks[100+(i*128+(j*2048))]:=4;
                //chastokol
                if (j and 1)=1 then
                begin
                  blocks[101+((13+j)*128+(i*2048))]:=4;
                  blocks[102+((13+j)*128+(i*2048))]:=50;
                  data[102+((13+j)*128+(i*2048))]:=5;

                  blocks[101+(i*128+(j*2048))]:=44;
                  data[101+(i*128+(j*2048))]:=3;
                end
                else
                begin
                  blocks[101+((13+j)*128+(i*2048))]:=44;
                  data[101+((13+j)*128+(i*2048))]:=3;

                  blocks[101+(i*128+(j*2048))]:=4;
                  blocks[102+(i*128+(j*2048))]:=50;
                  data[102+(i*128+(j*2048))]:=5;
                end;
              end;
        //generim chastokol dla osnovaniya
        for i:=3 to 13 do  //X
          for j:=2 to 12 do  //Z
            if (i=13)or(j=2) then
              begin
                //osnovanie
                blocks[99+(j*128+(i*2048))]:=4;
                blocks[100+(j*128+(i*2048))]:=4;
                //chastokol
                if (((j and 1)=0)and(i=13))or
                (((i and 1)=0)and(j=2)) then
                begin
                  blocks[101+(j*128+(i*2048))]:=4;
                  blocks[102+(j*128+(i*2048))]:=50;
                  data[102+(j*128+(i*2048))]:=5;
                end
                else
                begin
                  blocks[101+(j*128+(i*2048))]:=44;
                  data[101+(j*128+(i*2048))]:=3;
                end;
              end;
      end;
    end
    else if (xkoord=tempk)and(ykoord=tempz) then
    begin
      otx:=0;
      dox:=12;
      oty:=0;
      doy:=12;
      //generim bashnu
      if par_border.cwall_gen_towers=true then
      begin
        for k:=1 to 120 do //Y
          for i:=1 to 14 do //X
            for j:=1 to 14 do //Z
              blocks[k+(j*128+(i*2048))]:=4;
        for k:=1 to 100 do
          for i:=3 to 12 do
          begin
            blocks[k+(i*2048)]:=4;
            blocks[k+(i*128)]:=4;
          end;
        for k:=99 to 101 do    //chastokol na bloke, prilegayushem k bashne
        begin
          blocks[k+(2*2048)]:=4;
          blocks[k+(13*2048)]:=4;
          blocks[k+(2*128)]:=4;
          blocks[k+(13*128)]:=4;
        end;
        //virezaem vnutrennuyu komnatu
        for k:=101 to 109 do
          for i:=2 to 13 do
            for j:=2 to 13 do
              blocks[k+(j*128+(i*2048))]:=0;
        //virezaem vnutrennuyu komnatu 2 etazh
        for k:=111 to 119 do
          for i:=2 to 13 do
            for j:=2 to 13 do
              blocks[k+(j*128+(i*2048))]:=0;
        //virezaem prohodi na steni
        for k:=101 to 104 do
          for i:=6 to 9 do
          begin
            blocks[k+(1*128+(i*2048))]:=0;
            blocks[k+(i*128+(1*2048))]:=0;
          end;
        //delaem lestnicu s 1 etazha do krishi
        for k:=101 to 120 do
        begin
          blocks[k+(2*128+(2*2048))]:=65;
          data[k+(2*128+(2*2048))]:=3;
        end;

        if par_border.cwall_gen_interior=true then
        begin
        //virezaem vnutrennuyu komnatu 0 etazh
        for k:=91 to 99 do
          for i:=2 to 13 do
            for j:=2 to 13 do
              blocks[k+(j*128+(i*2048))]:=0;
        //delaem lestnicu s 0 etazha do 1
        for k:=91 to 100 do
        begin
          blocks[k+(2*128+(2*2048))]:=65;
          data[k+(2*128+(2*2048))]:=3;
        end;
        //ubiraem dopolnitel'niy sloy blokov na 0 etazhe
        for i:=4 to 11 do
          for k:=91 to 98 do
          begin
            blocks[k+(i*2048)]:=0;
            blocks[k+(i*128)]:=0;
          end;
        //virezaem prohodi na 0 etazh
        for i:=6 to 9 do
          for k:=91 to 94 do
          begin
            blocks[k+(1*128+(i*2048))]:=0;
            blocks[k+(i*128+(1*2048))]:=0;
          end;
        end;
        //stavim fakeli v prohodi na steni
        for i:=5 to 10 do
        begin
          if (i<>5)and(i<>10) then continue;
          if par_border.cwall_gen_interior=true then
          begin
          blocks[92+(i*128)]:=50;
          data[92+(i*128)]:=2;
          blocks[92+(i*2048)]:=50;
          data[92+(i*2048)]:=4;
          blocks[92+(i*128+(2*2048))]:=50;
          data[92+(i*128+(2*2048))]:=1;
          blocks[92+(2*128+(i*2048))]:=50;
          data[92+(2*128+(i*2048))]:=3;
          end;
          blocks[102+(i*128)]:=50;
          data[102+(i*128)]:=2;
          blocks[102+(i*2048)]:=50;
          data[102+(i*2048)]:=4;
          blocks[102+(i*128+(2*2048))]:=50;
          data[102+(i*128+(2*2048))]:=1;
          blocks[102+(2*128+(i*2048))]:=50;
          data[102+(2*128+(i*2048))]:=3;
        end;
        //delaem relsi
        if par_border.cwall_gen_rails=true then
        begin
        blocks[101+(8*128+(8*2048))]:=66;   //centr
        data[101+(8*128+(8*2048))]:=8;
        blocks[101+(7*128)]:=66;           //levo
        data[101+(7*128)]:=7;
        blocks[101+(8*128)]:=66;
        data[101+(8*128)]:=9;
        blocks[101+(7*2048)]:=66;           //niz
        data[101+(7*2048)]:=6;
        blocks[101+(8*2048)]:=66;
        data[101+(8*2048)]:=8;
        blocks[101+(128+7*2048)]:=66;
        data[101+(128+7*2048)]:=9;
        blocks[101+(128+8*2048)]:=66;
        data[101+(128+8*2048)]:=7;
        //pramie
        for i:=1 to 12 do
        begin
          if i=8 then continue;
          blocks[101+(8*128+(i*2048))]:=27;
          if i=12 then data[101+(8*128+(i*2048))]:=2
          else if i>8 then data[101+(8*128+(i*2048))]:=1
          else data[101+(8*128+(i*2048))]:=9;
        end;
        for i:=2 to 12 do
        begin
          if i=8 then continue;
          blocks[101+(i*128+(8*2048))]:=27;
          if i=12 then data[101+(i*128+(8*2048))]:=5
          else if i>8 then data[101+(i*128+(8*2048))]:=0
          else data[101+(i*128+(8*2048))]:=8;
        end;
        //cobl v nachale busterov
        blocks[101+(8*128+(13*2048))]:=4;
        blocks[102+(8*128+(13*2048))]:=4;
        blocks[101+(13*128+(8*2048))]:=4;
        blocks[102+(13*128+(8*2048))]:=4;
        //cobl dla knopok
        blocks[101+(9*128+(9*2048))]:=4;
        //fakel na coble
        blocks[102+(9*128+(9*2048))]:=50;
        data[102+(9*128+(9*2048))]:=5;
        //knopki
        blocks[101+(10*128+(9*2048))]:=77;
        blocks[101+(9*128+(10*2048))]:=77;
        data[101+(10*128+(9*2048))]:=3;
        data[101+(9*128+(10*2048))]:=1;
        //redstone fakel
        blocks[101+(7*128+(7*2048))]:=76;
        data[101+(7*128+(7*2048))]:=5;
        //delaem sunduki
        if (tileentities<>nil) then
        begin
          i:=length(tileentities^);
          setlength(tileentities^,i+1);
          tileentities^[i].id:='Chest';

          tileentities^[i].x:=xkoord*16+13;
          tileentities^[i].y:=101;
          tileentities^[i].z:=ykoord*16+13;
          blocks[101+(13*128+(13*2048))]:=54;

          new(pchest_tile_entity_data(tileentities^[i].dannie));
          setlength(pchest_tile_entity_data(tileentities^[i].dannie)^.items,5);
          for k:=0 to 4 do
          begin
            pchest_tile_entity_data(tileentities^[i].dannie)^.items[k].id:=328;
            pchest_tile_entity_data(tileentities^[i].dannie)^.items[k].damage:=0;
            pchest_tile_entity_data(tileentities^[i].dannie)^.items[k].count:=1;
            pchest_tile_entity_data(tileentities^[i].dannie)^.items[k].slot:=k;
          end;
        end;
        end;

        //delaem chastokol na bashne
        for i:=0 to 15 do
          for j:=0 to 15 do
            if ((j=0)or(j=15))or((i=0)or(i=15)) then
            begin
              blocks[120+(j*128+(i*2048))]:=4;
              blocks[119+(j*128+(i*2048))]:=4;
              if (((i and 1)=1)and((j=0)or(j=15)))or
              (((j and 1)=1)and((i=0)or(i=15)))or
              ((i=0)and(j=0))or((i=0)and(j=15))or
              ((i=15)and(j=0))or((i=15)and(j=15)) then
              begin
                blocks[121+(j*128+(i*2048))]:=4;
                blocks[122+(j*128+(i*2048))]:=50;
                data[122+(j*128+(i*2048))]:=5;
              end
              else
              begin
                blocks[121+(j*128+(i*2048))]:=44;
                data[121+(j*128+(i*2048))]:=3;
              end;
            end;
        //delaem boinici
        if (par_border.cwall_gen_interior=true)and(par_border.cwall_gen_boinici=true) then
        gen_border_cwall_boinici(par_border.cwall_boinici_type,4,blocks,data);
        //delaem fakeli na boinicah
        for i:=1 to 14 do
          for j:=1 to 14 do
          begin
            if (i<>1)and(i<>14)and(j<>1)and(j<>14) then continue;
            for k:=91 to 118 do
            begin
              //proveraem levo
              if (i=1)and(blocks[k+(j*128+(i*2048))]=43) then
              begin
                blocks[k+(j*128+((i+1)*2048))]:=50;
                data[k+(j*128+((i+1)*2048))]:=1;
              end;
              //proveraem pravo
              if (i=14)and(blocks[k+(j*128+(i*2048))]=43) then
              begin
                blocks[k+(j*128+((i-1)*2048))]:=50;
                data[k+(j*128+((i-1)*2048))]:=2;
              end;
              //proveraem niz
              if (j=1)and(blocks[k+(j*128+(i*2048))]=43) then
              begin
                blocks[k+((j+1)*128+(i*2048))]:=50;
                data[k+((j+1)*128+(i*2048))]:=3;
              end;
              //proveraem verh
              if (j=14)and(blocks[k+(j*128+(i*2048))]=43) then
              begin
                blocks[k+((j-1)*128+(i*2048))]:=50;
                data[k+((j-1)*128+(i*2048))]:=4;
              end;
            end;
          end;
      end
      else
      begin
        //generim osnovanie steni
        for k:=1 to 100 do   //Y
          for i:=3 to 12 do   //X
            for j:=3 to 12 do  //Z
              blocks[k+(j*128+(i*2048))]:=4;
        //generim soedinenie so stenami
        for k:=1 to 100 do
          for i:=3 to 12 do
            for j:=0 to 2 do
            begin
              blocks[k+(j*128+(i*2048))]:=4;
              blocks[k+(i*128+(j*2048))]:=4;
            end;
        //generim chastokol dla sekcii soedineniya
          for i:=2 to 13 do
            for j:=0 to 2 do
              if (i=2)or(i=13) then
              begin
                //osnovanie
                blocks[99+(j*128+(i*2048))]:=4;
                blocks[99+(i*128+(j*2048))]:=4;
                blocks[100+(j*128+(i*2048))]:=4;
                blocks[100+(i*128+(j*2048))]:=4;
                //chastokol
                if (j and 1)=0 then
                begin
                  blocks[101+(j*128+(i*2048))]:=4;
                  blocks[102+(j*128+(i*2048))]:=50;
                  data[102+(j*128+(i*2048))]:=5;
                  blocks[101+(i*128+(j*2048))]:=4;
                  blocks[102+(i*128+(j*2048))]:=50;
                  data[102+(i*128+(j*2048))]:=5;
                end
                else
                begin
                  blocks[101+(j*128+(i*2048))]:=44;
                  data[101+(j*128+(i*2048))]:=3;
                  blocks[101+(i*128+(j*2048))]:=44;
                  data[101+(i*128+(j*2048))]:=3;
                end;
              end;
        //generim chastokol dla osnovaniya
        for i:=3 to 13 do  //X
          for j:=3 to 13 do  //Z
            if (i=13)or(j=13) then
              begin
                //osnovanie
                blocks[99+(j*128+(i*2048))]:=4;
                blocks[100+(j*128+(i*2048))]:=4;
                //chastokol
                if (((j and 1)=0)and(i=13))or
                (((i and 1)=0)and(j=13)) then
                begin
                  blocks[101+(j*128+(i*2048))]:=4;
                  blocks[102+(j*128+(i*2048))]:=50;
                  data[102+(j*128+(i*2048))]:=5;
                end
                else
                begin
                  blocks[101+(j*128+(i*2048))]:=44;
                  data[101+(j*128+(i*2048))]:=3;
                end;
              end;
      end;
    end;

    if (dox=0)and(doy=0) then exit;

    for i:=0 to 15 do //X
      for j:=0 to 15 do //Z
        blocks[j*128+(i*2048)]:=7;

    if par_border.cwall_gen_towers=true then
      gen_cwall_border_towers(xkoord,ykoord,width,len,par_border,blocks,data,entities,tileentities);

  end;
end;

procedure fill_el_chunks(var ar_el:ar_elipse_settings);
var k,tempx,tempy,tempk,tempz,i,j,z:integer;
begin
  for k:=0 to length(ar_el)-1 do
  begin
    //opredelaem kraynie koordinati po dvum osam
      tempx:=ar_el[k].x-ar_el[k].radius_x;
      tempk:=ar_el[k].x+ar_el[k].radius_x;
      tempy:=ar_el[k].z-ar_el[k].radius_z;
      tempz:=ar_el[k].z+ar_el[k].radius_z;

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

      //zapisivaem massiv koordinat v tekushuyu zapis'
      //popravka na minusovie chanki
      if (tempx<=0)and((ar_el[k].x-ar_el[k].radius_x)<0) then tempx:=tempx-1;
      if (tempk<=0)and((ar_el[k].x+ar_el[k].radius_x)<0) then tempk:=tempk-1;
      if (tempy<=0)and((ar_el[k].z-ar_el[k].radius_z)<0) then tempy:=tempy-1;
      if (tempz<=0)and((ar_el[k].z+ar_el[k].radius_z)<0) then tempz:=tempz-1;

      //videlaem pamat'
      setlength(ar_el[k].chunks,(tempk-tempx+1)*(tempz-tempy+1));

      //zapisivaem
      z:=0;
      for i:=tempx to tempk do
        for j:=tempy to tempz do
        begin
          ar_el[k].chunks[z].x:=i;
          ar_el[k].chunks[z].y:=j;
          inc(z);
        end;
  end;
end;

procedure fill_tun_chunks(var ar_tun:array of tunnels_settings);
var k,tempx,tempy,tempk,tempz,i,j,z:integer;
begin
  for k:=0 to length(ar_tun)-1 do
  begin
    //opredelaem kraynie koordinati po dvum osam

      tempx:=min(ar_tun[k].x1,ar_tun[k].x2)-ar_tun[k].radius_horiz;
      tempk:=max(ar_tun[k].x1,ar_tun[k].x2)+ar_tun[k].radius_horiz;
      tempy:=min(ar_tun[k].z1,ar_tun[k].z2)-ar_tun[k].radius_horiz;
      tempz:=max(ar_tun[k].z1,ar_tun[k].z2)+ar_tun[k].radius_horiz;

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

      //zapisivaem massiv koordinat v tekushuyu zapis'
      //popravka na minusovie chanki
      if (tempx<=0)and((min(ar_tun[k].x1,ar_tun[k].x2)-ar_tun[k].radius_horiz)<0) then tempx:=tempx-1;
      if (tempk<=0)and((max(ar_tun[k].x1,ar_tun[k].x2)+ar_tun[k].radius_horiz)<0) then tempk:=tempk-1;
      if (tempy<=0)and((min(ar_tun[k].z1,ar_tun[k].z2)-ar_tun[k].radius_horiz)<0) then tempy:=tempy-1;
      if (tempz<=0)and((max(ar_tun[k].z1,ar_tun[k].z2)+ar_tun[k].radius_horiz)<0) then tempz:=tempz-1;

      //videlaem pamat'
      setlength(ar_tun[k].chunks,(tempk-tempx+1)*(tempz-tempy+1));

      //zapisivaem
      z:=0;
      for i:=tempx to tempk do
        for j:=tempy to tempz do
        begin
          ar_tun[k].chunks[z].x:=i;
          ar_tun[k].chunks[z].y:=j;
          inc(z);
        end;
  end;
end;

procedure calc_cos_tun(var ar_tun:array of tunnels_settings);
var v1x,v1y,v1z,v2x,v2y,v2z,v3x,v3y,v3z:extended;
dl1,dl2,dl3:extended;
xx1,yy1,zz1,xx2,yy2,zz2,i:integer;
begin
  for i:=0 to length(ar_tun)-1 do
  begin
    xx1:=ar_tun[i].x1;
    yy1:=ar_tun[i].y1;
    zz1:=ar_tun[i].z1;
    xx2:=ar_tun[i].x2;
    yy2:=ar_tun[i].y2;
    zz2:=ar_tun[i].z2;

    //opredelaem pervoy vektor
    v1x:=xx2-xx1; //x2-x1
    v1y:=yy2-yy1; //y2-y1
    v1z:=zz2-zz1; //z2-z1

    //opredelaem vtoroy vektor: vektornoe proizvedenie pervogo i osi Oy
    v2x:=zz1-zz2;  //z1-z2
    v2y:=0;       //0
    v2z:=xx2-xx1;        //x2-x1

    //opredelaem tretiy vektor: vektornoe proizvedenie pervogo i vtorogo vektora
    v3x:=(yy2-yy1)*(xx2-xx1);        //(y2-y1)*(x2-x1)
    v3y:=(zz2-zz1)*(zz1-zz2)-sqr(xx2-xx1);        //(z2-z1)*(z1-z2)-(x2-x1)^2
    v3z:=-(yy2-yy1)*(zz1-zz2);        //-(y2-y1)*(z1-z2)

    //vichislaem dlini vektorov
    dl1:=sqrt(sqr(v1x)+sqr(v1y)+sqr(v1z));
    dl2:=sqrt(sqr(v2x)+sqr(v2y)+sqr(v2z));
    dl3:=sqrt(sqr(v3x)+sqr(v3y)+sqr(v3z));

    //vichislaem kosinusi uglov otkloneniya novih treh osey ko vsem glavnim osam koordinat
    ar_tun[i].c1x:=v1x/dl1;
    ar_tun[i].c1y:=v1y/dl1;
    ar_tun[i].c1z:=v1z/dl1;

    ar_tun[i].c2x:=v2x/dl2;
    ar_tun[i].c2y:=v2y/dl2;
    ar_tun[i].c2z:=v2z/dl2;

    ar_tun[i].c3x:=v3x/dl3;
    ar_tun[i].c3y:=v3y/dl3;
    ar_tun[i].c3z:=v3z/dl3;
  end;
end;

function get_noise_koord(x,y:integer; sid:int64; flat:boolean):integer;
var rand:rnd;
noise:NoiseGeneratorOctaves;
noise_mas:ar_double;
tempx,tempy:integer;
xk,yk:integer;
begin
  rand:=rnd.Create(sid);
  noise:=NoiseGeneratorOctaves.create(rand,4);
  setlength(noise_mas,256);

  if x<0 then tempx:=x+1 else tempx:=x;
  if y<0 then tempy:=y+1 else tempy:=y;

  tempx:=tempx div 16;
  tempy:=tempy div 16;

  if (tempx<=0)and(x<0) then dec(tempx);
  if (tempy<=0)and(y<0) then dec(tempy);

  noise_mas:=noise.generateNoiseOctaves(noise_mas,tempx*16,0,tempy*16,16,1,16,0.0075625,1,0.0075625, flat);

  xk:=x-(tempx*16);
  yk:=y-(tempy*16);

  result:=round(64+noise_mas[xk*16+yk]*8);

  setlength(noise_mas,0);
  noise.Free;
  rand.Free;
end;

procedure clear_all_entities(entities:par_entity_type; tentities:par_tile_entity_type);
var i,j:integer;
begin
  {type NumericEntitiesIDs=(
Monster,Giant,Zombie,Creeper,Skeleton,Spider,Chicken,Cow,Ghast,Slime,PigZombie,Pig,
Wolf,Sheep,Item,Arrow,Snowball,Egg,Painting,Minecart,Boat,PrimedTnt,
FallingSand);

NumericTEntitiesIDs=(
Furnace, Sign, MobSpawner, Chest, Music, Trap, RecordPlayer);}
  if length(entities^)<>0 then
  begin
    for i:=0 to length(entities^)-1 do
    begin
      if (entities^[i].id='Monster')or(entities^[i].id='Giant')or
      (entities^[i].id='Zombie')or(entities^[i].id='Creeper')or
      (entities^[i].id='Skeleton')or(entities^[i].id='Spider')or
      (entities^[i].id='Chicken')or(entities^[i].id='Cow')or
      (entities^[i].id='Ghast') then dispose(pmobs_entity_data(entities^[i].dannie))
      else if (entities^[i].id='Slime') then dispose(pslime_entity_data(entities^[i].dannie))
      else if (entities^[i].id='PigZombie') then dispose(ppzombie_entity_data(entities^[i].dannie))
      else if (entities^[i].id='Pig') then dispose(ppig_entity_data(entities^[i].dannie))
      else if (entities^[i].id='Wolf') then
      begin
        pwolf_entity_data(entities^[i].dannie)^.owner:='';
        dispose(pwolf_entity_data(entities^[i].dannie));
      end
      else if (entities^[i].id='Sheep') then dispose(psheep_entity_data(entities^[i].dannie))
      else if (entities^[i].id='Item') then dispose(pitem_entity_data(entities^[i].dannie))
      else if (entities^[i].id='Arrow')or(entities^[i].id='Snowball') then dispose(pthroable_entity_data(entities^[i].dannie))
      else if (entities^[i].id='Painting') then
      begin
        ppainting_entity_data(entities^[i].dannie)^.motive:='';
        dispose(ppainting_entity_data(entities^[i].dannie));
      end
      else if (entities^[i].id='FallingSand') then dispose(pfalling_entity_data(entities^[i].dannie))
      else if (entities^[i].id='PrimedTnt') then dispose(ptnt_entity_data(entities^[i].dannie))
      else if (entities^[i].id='Minecart') then
      begin
        setlength(pminecart_entity_data(entities^[i].dannie)^.items,0);
        dispose(pminecart_entity_data(entities^[i].dannie));
      end;
    end;
    setlength(entities^,0);
  end;

  if length(tentities^)<>0 then
  begin
    for i:=0 to length(tentities^)-1 do
    begin
      if (tentities^[i].id='Furnace') then
      begin
        setlength(pfurnace_tile_entity_data(tentities^[i].dannie)^.items,0);
        dispose(pfurnace_tile_entity_data(tentities^[i].dannie));
      end
      else if (tentities^[i].id='Sign') then
      begin
        for j:=1 to 4 do psign_tile_entity_data(tentities^[i].dannie)^.text[j]:='';
        dispose(psign_tile_entity_data(tentities^[i].dannie));
      end
      else if (tentities^[i].id='MobSpawner') then
      begin
        pmon_spawn_tile_entity_data(tentities^[i].dannie)^.entityid:='';
        dispose(pmon_spawn_tile_entity_data(tentities^[i].dannie));
      end
      else if (tentities^[i].id='Chest') then
      begin
        setlength(pchest_tile_entity_data(tentities^[i].dannie)^.items,0);
        dispose(pchest_tile_entity_data(tentities^[i].dannie));
      end
      else if (tentities^[i].id='Music') then dispose(pnote_tile_entity_data(tentities^[i].dannie))
      else if (tentities^[i].id='Trap') then
      begin
        setlength(pdispenser_tile_entity_data(tentities^[i].dannie)^.items,0);
        dispose(pdispenser_tile_entity_data(tentities^[i].dannie));
      end
      else if (tentities^[i].id='RecordPlayer') then dispose(pjukebox_tile_entity_data(tentities^[i].dannie));
    end;
    setlength(tentities^,0);
  end;
end;

end.

unit generation;

interface
uses f_version;
const WM_USER = $0400;

type
     tkoord=record
       x,y:integer;
     end;

     ar_tkoord=array of tkoord;
     par_tkoord=^ar_tkoord;

     tprostr_koord=record
       x,y,z:integer;
     end;

     ar_tprostr_koord=array of tprostr_koord;
     par_tprostr_koord=^ar_tprostr_koord;

     tlights_record=record
       x,y,z:integer;
       id:byte;
     end;

     ar_tlights_koord=array of tlights_record;
     par_tlights_koord=^ar_tlights_koord;

     layers=record
       start_alt:integer;
       width:integer;
       material:integer;
       material_data:byte;
       name:string[26];
     end;

     layers_ar=array of layers;

     pflatmap_settings_type=^flatmap_settings_type;
     flatmap_settings_type = record          //tip dannih, peredayushihsa v proceduru generacii ploskoy karti
       {groundlevel:byte;
       waterlevel:byte;
       dirt_on_top:boolean;
       grass_on_top:boolean;
       groundmaterial:byte;
       dirtmaterial:byte;  }
       sloi:layers_ar;
       potok_exit:boolean;
       handle:longword;
       pop_chunks:boolean;
       sid:int64;
       width,len:integer;
     end;

     pborder_settings_type=^border_settings_type;
     border_settings_type = record           //tip dannih dla hraneniya informacii o granici karti
       border_type:byte;
       wall_material:byte;
       wall_thickness:byte;
       wall_void_thickness:byte;
       wall_void:boolean;
       void_thickness:byte;
       cwall_gen_towers:boolean;
       cwall_towers_type:byte;
       cwall_towers_gen_chastokol:boolean;
       cwall_walls_gen_chastokol:boolean;
       cwall_gen_interior:boolean;
       cwall_gen_rails:boolean;
       cwall_gen_boinici:boolean;
       cwall_boinici_type:byte;
       cwall_gen_gates:boolean;
       cwall_gates_type:byte;
       cwall_gen_void:boolean;
       cwall_void_width:byte;
     end;

     pplanetoids_settings_type=^planetoids_settings_type;
     planetoids_settings_type = record       //tip dannih o formate kart Planetoids
       width,len:integer;
       planets_type:byte;
       map_type:byte;
       min,max:byte;
       distance:byte;
       density:word;
       groundlevel:byte;
       potok_exit:boolean;
       handle:longword;
       pop_chunks:boolean;
       sid:int64;
     end;

     ptunnels_settings_type=^tunnels_settings_type;
     tunnels_settings_type=record
       width,len:integer;
       round_tun:boolean;
       r_hor_min,r_hor_max,r_vert_min,r_vert_max:integer;
       round_tun_density:byte;
       tun_density:byte;
       skyholes_density:byte;
       light_density:byte;
       light_blocks:array of byte;
       light_blocks_type:byte;
       gen_tall_grass:boolean;
       gen_lights:boolean;
       gen_sun_holes:boolean;
       gen_hub:boolean;
       gen_seperate:boolean;
       gen_flooded:boolean;
       potok_exit:boolean;
       handle:longword;
       pop_chunks:boolean;
       sid:int64;
     end;

     tbiome=record
       forest,rainforest,desert,plains,taiga,ice_desert,tundra,sky,hell:boolean;
     end;

     pbio_settings_type=^bio_settings_type;
     bio_settings_type=record
       original_gen:boolean;
       underwater:boolean;
       gen_skyholes:boolean;
       gen_noise:boolean;
       gen_bridges:boolean;
       bridge_material:byte;
       bridge_rail_material:byte;
       bridge_width:byte;
       sphere_material:byte;
       sphere_distance:integer;
       sphere_ellipse:boolean;
       biomes:tbiome;
       width,len:integer;
       handle:longword;
       potok_exit:boolean;
       pop_chunks:boolean;
       sid:int64;
     end;

     pplanets_settings = ^planets_settings;
     planets_settings = record
       x,y,z:integer;
       radius:byte;
       material_shell:byte;
       material_fill:byte;
       material_thick:byte;
       fill_level:byte;
       parameter:byte;
       chunks:array of tkoord;
     end;

     ar_planets_settings=array of planets_settings;
     par_planets_settings=^ar_planets_settings;
     
     ptunnels_settings=^tunnels_settings;

     pelipse_settings=^elipse_settings;
     elipse_settings=record
       x,y,z:integer;
       radius_x:integer;
       radius_z:integer;
       radius_vert:integer;
       fill_material:byte;
       waterlevel:byte;
       flooded:boolean; 
       svazi_tun:array of ptunnels_settings;
       chunks:array of tkoord;
     end;

     ar_elipse_settings=array of elipse_settings;
     par_elipse_settings=^ar_elipse_settings;

     tunnels_settings = record
       x1,y1,z1:integer;
       x2,y2,z2:integer;
       c1x,c1y,c1z,c2x,c2y,c2z,c3x,c3y,c3z:extended; //cosinusi uglov otkloneniya osey k osnovnim osam
       radius_horiz:integer;
       radius_vert:integer;
       fill_material:byte;
       waterlevel:byte;
       flooded:boolean;
       svazi_nach,svazi_kon:array of ptunnels_settings;
       nach_sfera,kon_sfera:pelipse_settings;
       chunks:array of tkoord;
     end;

     mcheader=record       //tip dannih, opisivayushiy zagolovok fayla regionov Minecraft
       mclocations:array[1..1024] of cardinal;
       mctimestamp:array[1..1024] of longint;
     end;

     player_set=record
       food_exhaustion_level:single;
       food_tick_timer:integer;
       food_saturation_level:single;
       food_level:integer;
       xp_level:integer;
       xp_total:integer;
       xp:integer;
     end;

     level_set = record
       spawnx,spawny,spawnz:integer;
       path,name:string;
       game_time:integer;
       thundering,raining:byte;
       thunder_time,rain_time:integer;
       player:player_set;
       game_type:integer;
       map_features:byte;
       sid:int64;
       size:int64;
     end;

function gen_tunnels(path,map_name:string; var tun_set:tunnels_settings_type;var border_set:border_settings_type; level_settings:level_set):integer;
function gen_flat(path,map_name:string; var flat_settings:flatmap_settings_type;var border_set:border_settings_type; level_settings:level_set):integer;
function gen_planets(path,map_name:string; var pl_set:planetoids_settings_type;var border_set:border_settings_type; level_settings:level_set):integer;
function gen_biosphere(path,map_name:string; var biosf_settings:bio_settings_type;var border_set:border_settings_type; level_settings:level_set):integer;
function generate_level(var sett:level_set):integer;
function hextobin(s:string):string;
function bintoint(s:string):int64;
function calc_crc32(str:string):longword; overload;
function calc_crc32(mas:array of longword; start:integer):longword; overload;
function GetBlockId(str:string):byte;
function GetBlockName(id:byte):string;

implementation

uses windows, nbt, zlibex, math, SysUtils, {F_Version,} RandomMCT, NoiseGeneratorOctaves_u, NoiseGenerator_u, generation_biosf;

var crc32_table:array [0..255] of longword =
(   $00000000, $77073096, $EE0E612C, $990951BA,
    $076DC419, $706AF48F, $E963A535, $9E6495A3,
    $0EDB8832, $79DCB8A4, $E0D5E91E, $97D2D988,
    $09B64C2B, $7EB17CBD, $E7B82D07, $90BF1D91,
    $1DB71064, $6AB020F2, $F3B97148, $84BE41DE,
    $1ADAD47D, $6DDDE4EB, $F4D4B551, $83D385C7,
    $136C9856, $646BA8C0, $FD62F97A, $8A65C9EC,
    $14015C4F, $63066CD9, $FA0F3D63, $8D080DF5,
    $3B6E20C8, $4C69105E, $D56041E4, $A2677172,
    $3C03E4D1, $4B04D447, $D20D85FD, $A50AB56B,
    $35B5A8FA, $42B2986C, $DBBBC9D6, $ACBCF940,
    $32D86CE3, $45DF5C75, $DCD60DCF, $ABD13D59,
    $26D930AC, $51DE003A, $C8D75180, $BFD06116,
    $21B4F4B5, $56B3C423, $CFBA9599, $B8BDA50F,
    $2802B89E, $5F058808, $C60CD9B2, $B10BE924,
    $2F6F7C87, $58684C11, $C1611DAB, $B6662D3D,
    $76DC4190, $01DB7106, $98D220BC, $EFD5102A,
    $71B18589, $06B6B51F, $9FBFE4A5, $E8B8D433,
    $7807C9A2, $0F00F934, $9609A88E, $E10E9818,
    $7F6A0DBB, $086D3D2D, $91646C97, $E6635C01,
    $6B6B51F4, $1C6C6162, $856530D8, $F262004E,
    $6C0695ED, $1B01A57B, $8208F4C1, $F50FC457,
    $65B0D9C6, $12B7E950, $8BBEB8EA, $FCB9887C,
    $62DD1DDF, $15DA2D49, $8CD37CF3, $FBD44C65,
    $4DB26158, $3AB551CE, $A3BC0074, $D4BB30E2,
    $4ADFA541, $3DD895D7, $A4D1C46D, $D3D6F4FB,
    $4369E96A, $346ED9FC, $AD678846, $DA60B8D0,
    $44042D73, $33031DE5, $AA0A4C5F, $DD0D7CC9,
    $5005713C, $270241AA, $BE0B1010, $C90C2086,
    $5768B525, $206F85B3, $B966D409, $CE61E49F,
    $5EDEF90E, $29D9C998, $B0D09822, $C7D7A8B4,
    $59B33D17, $2EB40D81, $B7BD5C3B, $C0BA6CAD,
    $EDB88320, $9ABFB3B6, $03B6E20C, $74B1D29A,
    $EAD54739, $9DD277AF, $04DB2615, $73DC1683,
    $E3630B12, $94643B84, $0D6D6A3E, $7A6A5AA8,
    $E40ECF0B, $9309FF9D, $0A00AE27, $7D079EB1,
    $F00F9344, $8708A3D2, $1E01F268, $6906C2FE,
    $F762575D, $806567CB, $196C3671, $6E6B06E7,
    $FED41B76, $89D32BE0, $10DA7A5A, $67DD4ACC,
    $F9B9DF6F, $8EBEEFF9, $17B7BE43, $60B08ED5,
    $D6D6A3E8, $A1D1937E, $38D8C2C4, $4FDFF252,
    $D1BB67F1, $A6BC5767, $3FB506DD, $48B2364B,
    $D80D2BDA, $AF0A1B4C, $36034AF6, $41047A60,
    $DF60EFC3, $A867DF55, $316E8EEF, $4669BE79,
    $CB61B38C, $BC66831A, $256FD2A0, $5268E236,
    $CC0C7795, $BB0B4703, $220216B9, $5505262F,
    $C5BA3BBE, $B2BD0B28, $2BB45A92, $5CB36A04,
    $C2D7FFA7, $B5D0CF31, $2CD99E8B, $5BDEAE1D,
    $9B64C2B0, $EC63F226, $756AA39C, $026D930A,
    $9C0906A9, $EB0E363F, $72076785, $05005713,
    $95BF4A82, $E2B87A14, $7BB12BAE, $0CB61B38,
    $92D28E9B, $E5D5BE0D, $7CDCEFB7, $0BDBDF21,
    $86D3D2D4, $F1D4E242, $68DDB3F8, $1FDA836E,
    $81BE16CD, $F6B9265B, $6FB077E1, $18B74777,
    $88085AE6, $FF0F6A70, $66063BCA, $11010B5C,
    $8F659EFF, $F862AE69, $616BFFD3, $166CCF45,
    $A00AE278, $D70DD2EE, $4E048354, $3903B3C2,
    $A7672661, $D06016F7, $4969474D, $3E6E77DB,
    $AED16A4A, $D9D65ADC, $40DF0B66, $37D83BF0,
    $A9BCAE53, $DEBB9EC5, $47B2CF7F, $30B5FFE9,
    $BDBDF21C, $CABAC28A, $53B39330, $24B4A3A6,
    $BAD03605, $CDD70693, $54DE5729, $23D967BF,
    $B3667A2E, $C4614AB8, $5D681B02, $2A6F2B94,
    $B40BBE37, $C30C8EA1, $5A05DF1B, $2D02EF8D);

type
     ptparam_flat = ^tparam_flat;
     tparam_flat = record
       id:integer;
       handle:longword;
       fromx,fromy,tox,toy:integer;
       //groundlevel,waterlevel,groundmaterial,dirtmaterial:byte;
       //dirt_on_top,grass_on_top:boolean;
       border_par:pborder_settings_type;
       flatmap_par:pflatmap_settings_type;
       sid:longword;
     end;

     ptparam_planet=^tparam_planet;
     tparam_planet = record
       id:integer;
       handle:longword;
       fromx,fromy,tox,toy:integer;
       planet_par:pplanetoids_settings_type;
       border_par:pborder_settings_type;
       sid:longword;
     end;

     ptparam_tunnel=^tparam_tunnel;
     tparam_tunnel=record
       id:integer;
       handle:longword;
       fromx,fromy,tox,toy:integer;
       tunnel_par:ptunnels_settings_type;
       border_par:pborder_settings_type;
       sid:longword;
     end;

     ptparam_biosphere=^tparam_biosphere;
     tparam_biosphere=record
       id:integer;
       handle:longword;
       fromx,fromy,tox,toy:integer;
       bio_par:pbio_settings_type;
       border_par:pborder_settings_type;
       sid:longword;
     end;

     tparam_cep_tunnel=record
       nach:integer;
       len:integer;
     end;

     ar_cep_tunnel=array of tparam_cep_tunnel;

     ptparam_structure=^tparam_structure;
     tparam_structure=record
       id:integer;
       typ:byte;
       otx,oty,otz,dox,doy,doz:integer;
       chunks:array of tkoord;
     end;

     ar_param_structure=array of tparam_structure;
     par_param_structure=^ar_param_structure;

     chunk=record
       blocks:ar_type;
       data:ar_type;
       light:ar_type;
       skylight:ar_type;
       heightmap:ar_type;
       entities:ar_entity_type;
       tile_entities:ar_tile_entity_type;
     end;
line=array of chunk;
region=array of line;


var gen_struct:procedure (ar_struct:ar_param_structure; xchkoord,ychkoord,length,width:integer; entitys,tile_entitys:par_entity_type; map_type:byte; blocks,data,heightmap:ar_type; hndl:cardinal);
  gen_obl:procedure (fromx,fromy,tox,toy:integer; par_struct:par_param_structure);
  calc_polozh:procedure (map:region; var struct:tparam_structure);
  dll_hndl:thandle;
  loaded:boolean=false;

blocksid:array[0..116] of string=(
'Air',
'Stone',
'Grass',
'Dirt',
'Cobblestone',
'Wooden Plank',
'Sapling',
'Bedrock',
'Water',
'Stationary water',
'Lava',
'Stationary lava',
'Sand',
'Gravel',
'Gold Ore',
'Iron Ore',
'Coal Ore',
'Wood',
'Leaves',
'Sponge',
'Glass',
'Lapis Lazuli Ore',
'Lapis Lazuli Block',
'Dispenser',
'Sandstone',
'Note Block',
'Bed',
'Powered Rail',
'Detector Rail',
'Sticky Piston',
'Cobweb',
'Tall Grass',
'Dead Shrubs',
'Pison',
'Piston Extension',
'Wool',
'Block moved by Piston',
'Dandelion',
'Rose',
'Brown Mushroom',
'Red Mushroom',
'Gold Block',
'Iron Block',
'Double Slabs',
'Slabs',
'Brick Block',
'TNT',
'Bookshelf',
'Moss Stone',
'Obsidian',
'Torch',
'Fire',
'Monster Spawner',
'Wooden Stairs',
'Chest',
'Redstone Wire',
'Diamond Ore',
'Diamond Block',
'Crafting Table',
'Seeds',
'Farmland',
'Furnace',
'Burning Furnace',
'Sign Post',
'Wooden Door',
'Ladder',
'Rails',
'Cobblestone Stairs',
'Wall Sign',
'Lever',
'Stone Pressure Plate',
'Iron Door',
'Wooden Pressure Plate',
'Redstone Ore',
'Glowing Redstone Ore',
'Redstone Torch off state',
'Redstone Torch on state',
'Stone Button',
'Snow',
'Ice',
'Snow Block',
'Cactus',
'Clay Block',
'Sugar Cane',
'Jukebox',
'Fence',
'Pumpkin',
'Netherrack',
'Soul Sand',
'Glowstone Block',
'Portal',
'Jack-O-Lantern',
'Cake Block',
'Redstone Repeater off state',
'Redstone Repeater on state',
'Locked Chest',
'Trapdor',
'Hidden Silverfish',
'Stone Bricks',
'Huge Brown Mushroom',
'Huge Red Mushroom',
'Iron Bars',
'Glass Pane',
'Melon',
'Pumpkin Stem',
'Melon Stem',
'Vines',
'Fence Gate',
'Brick Stairs',
'Stone Brick Stairs',
'Mycelium',
'Lily Pad',
'Nether Brick',
'Nether Brick Fence',
'Nether Brick Stairs',
'Nether Wart',
'End of the array');

type for_set = 0..255;
set_trans_blocks = set of for_set;
var trans_bl:set_trans_blocks;
light_bl:set_trans_blocks;
diff_bl:set_trans_blocks;

function step(chislo, stepen:byte):int64;
var sum:int64;
i:integer;
begin
  if stepen=0 then sum:=1
  else sum:=chislo;
  for i:=2 to stepen do
    sum:=sum*chislo;
  result:=sum;
end;

function hextobin(s:string):string;
var str:string;
i:integer;
begin
  str:='';
  for i:=1 to length(s) do
    case s[i] of
      '0':str:=str+'0000';
      '1':str:=str+'0001';
      '2':str:=str+'0010';
      '3':str:=str+'0011';
      '4':str:=str+'0100';
      '5':str:=str+'0101';
      '6':str:=str+'0110';
      '7':str:=str+'0111';
      '8':str:=str+'1000';
      '9':str:=str+'1001';
      'a','A':str:=str+'1010';
      'b','B':str:=str+'1011';
      'c','C':str:=str+'1100';
      'd','D':str:=str+'1101';
      'e','E':str:=str+'1110';
      'f','F':str:=str+'1111';
    end;
  result:=str;
end;

function bintoint(s:string):int64;
var j,sum:int64;
i:integer;
begin
  j:=0;
  sum:=0;
  for i:=length(s) downto 1 do
  begin
    if s[i]='1' then sum:=sum+step(2,j);
    j:=j+1;
  end;
  result:=sum;
end;

procedure btolendian(var i:integer);
var s,s1:string;
j:integer;
begin
  s:=inttohex(i,8);
  s1:=s;
  for j:=1 to 4 do
  begin
    s1[2*(4-j)+1]:=s[2*(j-1)+1];
    s1[2*(4-j)+2]:=s[2*(j-1)+2];
  end;
  i:=bintoint(hextobin(s1));
end;

function calc_crc32(str:string):longword; overload;
var i:integer;
crc:longword;
begin
  crc:=$FFFFFFFF;
  for i:=1 to length(str) do
    crc:=(crc shr 8)xor crc32_table[(crc xor ord(str[i]))and $FF];
  result:=crc;
end;

function calc_crc32(mas:array of longword; start:integer):longword; overload;
var i:integer;
crc:longword;
begin
  crc:=$FFFFFFFF;
  for i:=start to length(mas)-1 do
  begin
    crc:=(crc shr 8)xor crc32_table[(crc xor (mas[i] and $FF000000))and $FF];
    crc:=(crc shr 8)xor crc32_table[(crc xor (mas[i] and $FF0000))and $FF];
    crc:=(crc shr 8)xor crc32_table[(crc xor (mas[i] and $FF00))and $FF];
    crc:=(crc shr 8)xor crc32_table[(crc xor (mas[i] and $FF))and $FF];
  end;

  result:=crc;
end;

function GetBlockId(str:string):byte;
var i:integer;
begin
  i:=-1;
  repeat
    inc(i);
  until (uppercase(blocksid[i])=uppercase(str))or(i>=116);
  if i>=116 then result:=255
  else result:=i;
end;

function GetBlockName(id:byte):string;
begin
  if id>=116 then result:='Unknown block'
  else
  result:=blocksid[id];
end;

function generate_level(var sett:level_set):integer;
var f:file;
str,strcompress:string;
begin
  result:=-1;

  nbtcompresslevel(sett.spawnx,sett.spawny,sett.spawnz,sett.name,str,sett.sid,sett.size,sett.game_type,sett.map_features,sett.raining,sett.rain_time*20,sett.thundering,sett.thunder_time*20,sett.game_time);

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

function gen_obsh_sid(sid:int64; bor_set:border_settings_type; par:pointer; map_type:byte; ver:TFileVersionInfo; level_settings:level_set):string;
var t:longword;
str,temp,bit:string;
i,j:integer;
flat:flatmap_settings_type;
planet:planetoids_settings_type;
tunnel:tunnels_settings_type;
bio:bio_settings_type;
flatp:pflatmap_settings_type;
planetp:pplanetoids_settings_type;
tunnelp:ptunnels_settings_type;
biop:pbio_settings_type;
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

  //blok crc32
  t:=calc_crc32(str);
  temp:=inttohex(1,2)+inttohex(4,2)+inttohex(t,8);
  str:=str+temp;

  {setlength(t,6);
  zeromemory(t,6*sizeof(longword));

  //SID++++++++++++++++++++++
  t[1]:=sid;

  //Version info+++++++++++++
  str:=ver.FileVersion;
  if str='10.100.1000.0' then str:='0.0.0.0';
  //Major version
  i:=strtoint(copy(str,1,pos('.',str)-1));
  t[2]:=t[2] or ((i and $F)shl 8);
  delete(str,1,pos('.',str));
  //Minor version
  i:=strtoint(copy(str,1,pos('.',str)-1));
  t[2]:=t[2] or ((i and $1F)shl 3);
  delete(str,1,pos('.',str));
  //Release
  i:=strtoint(copy(str,1,pos('.',str)-1));
  t[2]:=t[2] or ((i and $1C)shr 2);
  t[3]:=t[3] or ((i and $3)shl 30);

  //Map data+++++++++++++++++++
  t[3]:=t[3] or ((map_type and $F)shl 26);
  case map_type of
  0:begin       //flatmap
      flatp:=par;
      flat:=flatp^;
      t[2]:=t[2] or ((flat.width and $3FF)shl 22) or ((flat.len and $3FF)shl 12);

      //zapolnaem dannie karti
      i:=flat.groundlevel;
      t[3]:=t[3] or ((i and $7F)shl 19);
      i:=flat.waterlevel;
      t[3]:=t[3] or ((i and $7F)shl 12);

      //materiali perevodatsa v indeksi
      i:=flat.groundmaterial;
      case i of
        1:j:=0;    //stone
        4:j:=1;    //cobblestone
        48:j:=2;   //mossy cobblestone
        3:j:=3;    //dirt
        12:j:=4;   //sand
        24:j:=5;   //sandstone
        13:j:=6;   //gravel
        20:j:=7;   //glass
        49:j:=8;   //obsidian
        87:j:=9;   //netherrack
        88:j:=10;  //soul sand
        80:j:=11;  //snow block
        79:j:=12;  //ice
        9:j:=13;   //water
        7:j:=14;   //bedrock
      else j:=0; //default=stone
      end;

      t[3]:=t[3] or ((j and $1F)shl 7);

      i:=flat.dirtmaterial;
      case i of
        1:j:=0;    //stone
        4:j:=1;    //cobblestone
        48:j:=2;   //mossy cobblestone
        3:j:=3;    //dirt
        12:j:=4;   //sand
        24:j:=5;   //sandstone
        13:j:=6;   //gravel
        5:j:=7;    //wooden plank
        20:j:=8;   //glass
        82:j:=9;   //clay
        49:j:=10;  //obsidian
        87:j:=11;  //netherrack
        88:j:=12;  //soul sand
        80:j:=13;  //snow block
        79:j:=14;  //ice
      else j:=3; //default=dirt
      end;

      t[3]:=t[3] or ((j and $1F)shl 2);

      i:=integer(flat.dirt_on_top);
      t[3]:=t[3] or ((i and 1)shl 1);
      i:=integer(flat.grass_on_top);
      t[3]:=t[3] or (i and 1);
    end;
  5:begin    //planetoids
      planetp:=par;
      planet:=planetp^;
      t[2]:=t[2] or ((planet.width and $3FF)shl 22) or ((planet.len and $3FF)shl 12);

      i:=planet.map_type;
      t[3]:=t[3] or ((i and $7)shl 23);
      i:=planet.distance;
      t[3]:=t[3] or ((i and $3F)shl 17);
      i:=planet.min;
      t[3]:=t[3] or ((i and $3F)shl 11);
      i:=planet.max;
      t[3]:=t[3] or ((i and $3F)shl 5);
      i:=planet.density;
      t[3]:=t[3] or ((i and $7C) shr 2);
      t[4]:=t[4] or ((i and $3)shl 30);
      i:=planet.groundlevel;
      t[4]:=t[4] or ((i and $7F)shl 23);
    end;
  7:begin  //Golden tunnels
      tunnelp:=par;
      tunnel:=tunnelp^;
      t[2]:=t[2] or ((tunnel.width and $3FF)shl 22) or ((tunnel.len and $3FF)shl 12);

      i:=tunnel.tun_density;
      t[3]:=t[3] or ((i and $7F)shl 19);
      i:=integer(tunnel.round_tun);
      t[3]:=t[3] or ((i and 1)shl 18);
      i:=tunnel.r_hor_min;
      t[3]:=t[3] or ((i and $1F)shl 13);
      i:=tunnel.r_hor_max;
      t[3]:=t[3] or ((i and $1F)shl 8);
      i:=tunnel.r_vert_min;
      t[3]:=t[3] or ((i and $1F)shl 3);
      i:=tunnel.r_vert_max;
      t[3]:=t[3] or ((i shr 2)and $7);
      t[4]:=t[4] or ((i and $3)shl 30);
      i:=tunnel.round_tun_density;
      t[4]:=t[4] or ((i and $7F)shl 23);
      if (tunnel.gen_lights=true)and(tunnel.gen_sun_holes=false) then i:=0
      else if (tunnel.gen_lights=false)and(tunnel.gen_sun_holes=true) then i:=1
      else if (tunnel.gen_lights=true)and(tunnel.gen_sun_holes=true) then i:=2;
      t[4]:=t[4] or ((i and $3)shl 21);
      i:=tunnel.light_density;
      t[4]:=t[4] or ((i and $7F)shl 14);
      i:=0;
      for j:=0 to length(tunnel.light_blocks)-1 do
        case tunnel.light_blocks[j] of
          89:i:=i or $20;
          11:i:=i or $10;
          91:i:=i or $8;
          87:i:=i or $4;
          50:i:=i or $2;
          74:i:=i or 1;
        end;
      t[4]:=t[4] or ((i and $3F)shl 8);
      i:=tunnel.light_blocks_type;
      t[4]:=t[4] or ((i and $7)shl 5);
      i:=tunnel.skyholes_density;
      t[4]:=t[4] or ((i shr 2)and $1F);
      t[5]:=t[5] or ((i and $3)shl 30);
      i:=0;
      if tunnel.gen_tall_grass=true then i:=i or $8;
      if tunnel.gen_hub=true then i:=i or $4;
      if tunnel.gen_seperate=true then i:=i or $2;
      if tunnel.gen_flooded=true then i:=i or 1;
      t[5]:=t[5] or ((i and $F)shl 26);
    end;
  end;

  //Border data+++++++++++++++++
  t[5]:=t[5] or ((bor_set.border_type and $7)shl 23);
  case bor_set.border_type of
  1:begin
      //vichislaem indeks
      i:=bor_set.wall_material;
      case i of
        1:j:=0;
        3:j:=1;
        4:j:=2;
        5:j:=3;
        7:j:=4;
        9:j:=5;
        11:j:=6;
        12:j:=7;
        24:j:=8;
        13:j:=9;
        20:j:=10;
        49:j:=11;
        79:j:=12;
        80:j:=13;
        else
          j:=0;
        end;
      t[5]:=t[5] or ((j and $1F)shl 18);

      i:=bor_set.wall_thickness;
      t[5]:=t[5] or ((i and $F)shl 14);
      i:=integer(bor_set.wall_void);
      t[5]:=t[5] or ((i and 1)shl 13);
      i:=bor_set.wall_void_thickness;
      t[5]:=t[5] or ((i and $7F)shl 6);
    end;
  2:begin
      i:=bor_set.void_thickness;
      t[5]:=t[5] or ((i and $7F)shl 16);
    end;
  end;

  //t[0]:=calc_crc32(t,1);

  str:='';
  for i:=1 to 5 do                           
    str:=str+inttohex(t[i],8);

  while (length(str) mod 8)<>0 do
    str:='0'+str;

  t[0]:=calc_crc32(str);
  str:=inttohex(t[0],8)+str;

  setlength(t,0);  }

  result:=str;
end;

procedure generate_settings(path,name:string; sid:int64; bor_set:border_settings_type; par:pointer; map_type:byte; level_settings:level_set);
var f:file;
str,str1:string;
i,j:integer;
time:integer;
ver:TFileVersionInfo;
flat:flatmap_settings_type;
flatp:pflatmap_settings_type;
planet:planetoids_settings_type;
planetp:pplanetoids_settings_type;
tunnel:tunnels_settings_type;
tunnelp:ptunnels_settings_type;
bio:bio_settings_type;
biop:pbio_settings_type;
begin
  //str:=gen_obsh_sid(sid,bor_set,par,map_type,ver);

  str:='[General]'+#13+#10;;
  str:=str+'SID: '+inttostr(sid)+#13+#10;

  str:=str+'Generator path: '+paramstr(0)+#13+#10;
  ver:=Fileversioninfo(paramstr(0));
  str:=str+'Generator name: '+ver.ProductName+#13+#10;
  str:=str+'Extra generator info: '+ver.FileDescription+#13+#10;

  //vstavlaem sid tut, t.k. tut gotova struktura dla versii programmi
  str:=gen_obsh_sid(sid,bor_set,par,map_type,ver,level_settings)+#13+#10+#13+#10+str;

  if ver.FileVersion='10.100.1000.0' then
  str:=str+'Generator version: Not released version'+#13+#10
  else str:=str+'Generator version: '+ver.FileVersion+#13+#10;

  str:=str+'Map name: '+name+#13+#10;
  str:=str+'Map path: '+path+#13+#10;
  //str:=str+'Map type: ';
  //map type
  case map_type of
    0:begin
        flatp:=par;
        flat:=flatp^;
        str:=str+'Map width: '+inttostr(flat.width)+#13+#10;
        str:=str+'Map length: '+inttostr(flat.len)+#13+#10;
        str:=str+'Populate chunks: '+booltostr(flat.pop_chunks,true)+#13+#10;
        str:=str+'Raining: ';
        if level_settings.raining=1 then str:=str+'True'+#13+#10
        else str:=str+'False'+#13+#10;

        //delaem stroku vremeni dozhda
        time:=level_settings.rain_time;
        str1:='';
        if time>=60 then
          if ((time div 60) mod 10)=1 then str1:=str1+inttostr(time div 60)+' minute '
          else str1:=str1+inttostr(time div 60)+' minutes ';

        if (time mod 10)=1 then str1:=str1+inttostr(time mod 60)+' second'
        else str1:=str1+inttostr(time mod 60)+' seconds';

        str:=str+'Time until rain ';
        if level_settings.raining=1 then str:=str+'stops: '+str1
        else str:=str+'starts: '+str1;
        str:=str+#13+#10;

        str:=str+'Thundering: ';
        if level_settings.thundering=1 then str:=str+'True'+#13+#10
        else str:=str+'False'+#13+#10;
        //delaem stroku vremeni groma
        time:=level_settings.thunder_time;
        str1:='';
        if time>=60 then
          if ((time div 60) mod 10)=1 then str1:=str1+inttostr(time div 60)+' minute '
          else str1:=str1+inttostr(time div 60)+' minutes ';

        if (time mod 10)=1 then str1:=str1+inttostr(time mod 60)+' second'
        else str1:=str1+inttostr(time mod 60)+' seconds';

        str:=str+'Time until thunder ';
        if level_settings.thundering=1 then str:=str+'stops: '+str1
        else str:=str+'starts: '+str1;
        str:=str+#13+#10;

        str:=str+#13+#10;

        str:=str+'[Map settings]'+#13+#10;
        str:=str+'Map type: Flatmap'+#13+#10;
        str:=str+'Map layers:'+#13+#10;
        for i:=0 to length(flat.sloi)-1 do
        begin
          str:=str+'Layer ¹'+inttostr(i);

          str:=str+'   Starting altitude: ';
          str1:=inttostr(flat.sloi[i].start_alt);
          for j:=length(str1) to 6 do
            str1:=str1+' ';

          str:=str+str1+'Layer width: ';
          str1:=inttostr(flat.sloi[i].width);
          for j:=length(str1) to 6 do
            str1:=str1+' ';

          str:=str+str1+'Layer material: ';
          str1:=getblockname(flat.sloi[i].material);
          str:=str+str1+#13+#10;      
        end;

        str:=str+#13+#10;

        //Glowing Redstone Ore
        {str:=str+'Ground level: '+inttostr(flat.groundlevel)+#13+#10;
        str:=str+'Water level: '+inttostr(flat.waterlevel)+#13+#10;
        str:=str+'Ground material: '+getblockname(flat.groundmaterial)+#13+#10;
        str:=str+'Dirt material: '+getblockname(flat.dirtmaterial)+#13+#10;

        str:=str+'Dirt on top: '+booltostr(flat.dirt_on_top,true)+#13+#10;
        str:=str+'Grass on top of the dirt: '+booltostr(flat.grass_on_top,true)+#13+#10+#13+#10;}
      end;
    5:begin
        //str:=str+'Planetoids'+#13+#10;
        planetp:=par;
        planet:=planetp^;
        str:=str+'Map width: '+inttostr(planet.width)+#13+#10;
        str:=str+'Map length: '+inttostr(planet.len)+#13+#10;
        str:=str+'Populate chunks: '+booltostr(planet.pop_chunks,true)+#13+#10;
        str:=str+'Raining: ';
        if level_settings.raining=1 then str:=str+'True'+#13+#10
        else str:=str+'False'+#13+#10;

        //delaem stroku vremeni dozhda
        time:=level_settings.rain_time;
        str1:='';
        if time>=60 then
          if ((time div 60) mod 10)=1 then str1:=str1+inttostr(time div 60)+' minute '
          else str1:=str1+inttostr(time div 60)+' minutes ';

        if (time mod 10)=1 then str1:=str1+inttostr(time mod 60)+' second'
        else str1:=str1+inttostr(time mod 60)+' seconds';

        str:=str+'Time until rain ';
        if level_settings.raining=1 then str:=str+'stops: '+str1
        else str:=str+'starts: '+str1;
        str:=str+#13+#10;

        str:=str+'Thundering: ';
        if level_settings.thundering=1 then str:=str+'True'+#13+#10
        else str:=str+'False'+#13+#10;
        //delaem stroku vremeni groma
        time:=level_settings.thunder_time;
        str1:='';
        if time>=60 then
          if ((time div 60) mod 10)=1 then str1:=str1+inttostr(time div 60)+' minute '
          else str1:=str1+inttostr(time div 60)+' minutes ';

        if (time mod 10)=1 then str1:=str1+inttostr(time mod 60)+' second'
        else str1:=str1+inttostr(time mod 60)+' seconds';

        str:=str+'Time until thunder ';
        if level_settings.thundering=1 then str:=str+'stops: '+str1
        else str:=str+'starts: '+str1;
        str:=str+#13+#10;

        str:=str+#13+#10;

        str:=str+'[Map settings]'+#13+#10;
        str:=str+'Map type: Planetoids'+#13+#10;
        str:=str+'Planetoid map type: ';
        case planet.map_type of
          0:str:=str+'Open sky'+#13+#10;
          1:str:=str+'Water below'+#13+#10;
          2:str:=str+'Lava below'+#13+#10;
        end;
        str:=str+'Planetoids type: ';
        case planet.planets_type of
          0:str:=str+'Sphere'+#13+#10;
          1:str:=str+'Cube'+#13+#10;
        end;
        str:=str+'Minimum distance between planets: '+inttostr(planet.distance)+#13+#10;
        str:=str+'Minimum planet radius: '+inttostr(planet.min)+#13+#10;
        str:=str+'Maximum planet radius: '+inttostr(planet.max)+#13+#10;
        str:=str+'Planets density: '+inttostr(planet.density)+'%'+#13+#10;
        str:=str+'Ground level: '+inttostr(planet.groundlevel)+#13+#10+#13+#10;
      end;
    6:begin
        //str:=str+'BioSpheres'+#13+#10;
        biop:=par;
        bio:=biop^;
        str:=str+'Map width: '+inttostr(bio.width)+#13+#10;
        str:=str+'Map length: '+inttostr(bio.len)+#13+#10;
        str:=str+'Populate chunks: '+booltostr(bio.pop_chunks,true)+#13+#10;
        str:=str+'Raining: ';
        if level_settings.raining=1 then str:=str+'True'+#13+#10
        else str:=str+'False'+#13+#10;

        //delaem stroku vremeni dozhda
        time:=level_settings.rain_time;
        str1:='';
        if time>=60 then
          if ((time div 60) mod 10)=1 then str1:=str1+inttostr(time div 60)+' minute '
          else str1:=str1+inttostr(time div 60)+' minutes ';

        if (time mod 10)=1 then str1:=str1+inttostr(time mod 60)+' second'
        else str1:=str1+inttostr(time mod 60)+' seconds';

        str:=str+'Time until rain ';
        if level_settings.raining=1 then str:=str+'stops: '+str1
        else str:=str+'starts: '+str1;
        str:=str+#13+#10;

        str:=str+'Thundering: ';
        if level_settings.thundering=1 then str:=str+'True'+#13+#10
        else str:=str+'False'+#13+#10;
        //delaem stroku vremeni groma
        time:=level_settings.thunder_time;
        str1:='';
        if time>=60 then
          if ((time div 60) mod 10)=1 then str1:=str1+inttostr(time div 60)+' minute '
          else str1:=str1+inttostr(time div 60)+' minutes ';

        if (time mod 10)=1 then str1:=str1+inttostr(time mod 60)+' second'
        else str1:=str1+inttostr(time mod 60)+' seconds';

        str:=str+'Time until thunder ';
        if level_settings.thundering=1 then str:=str+'stops: '+str1
        else str:=str+'starts: '+str1;
        str:=str+#13+#10;

        str:=str+#13+#10;

        str:=str+'[Map settings]'+#13+#10;
        str:=str+'Map type: BioSpheres'+#13+#10;
        str:=str+'Spheres position: ';
        if bio.original_gen=true then str:=str+'Original (in grid)'+#13+#10
        else str:=str+'Random'+#13+#10;
        str:=str+'Water around BioSpheres: '+booltostr(bio.underwater,true)+#13+#10;
        if bio.underwater=true then
          str:=str+'Generate skyholes: '+booltostr(bio.gen_skyholes,true)+#13+#10;
        str:=str+'Generate land noise: '+booltostr(bio.gen_noise,true)+#13+#10;
        str:=str+'Generate bridges between BioSpheres: '+booltostr(bio.gen_bridges,true)+#13+#10;
        if bio.gen_bridges=true then
        begin
          str:=str+'Bridge width: '+inttostr(bio.bridge_width)+#13+#10;
          str:=str+'Bridge material: '+getblockname(bio.bridge_material)+#13+#10;
          str:=str+'Bridge rail material: '+getblockname(bio.bridge_rail_material)+#13+#10;
        end;
        str:=str+'BioSpheres outer layer material: '+getblockname(bio.sphere_material)+#13+#10;
        str:=str+'Minimum distance between BioSpheres: '+inttostr(bio.sphere_distance)+#13+#10;
        str:=str+'Generate ellipsoid BioSpheres: '+booltostr(bio.sphere_ellipse,true)+#13+#10;
        str:=str+'BioSpheres biomes: ';
        if bio.biomes.forest then str:=str+'Forest, ';
        if bio.biomes.rainforest then str:=str+'Rainforest, ';
        if bio.biomes.desert then str:=str+'Desert, ';
        if bio.biomes.plains then str:=str+'Plains, ';
        if bio.biomes.taiga then str:=str+'Taiga, ';
        if bio.biomes.ice_desert then str:=str+'Ice Desert, ';
        if bio.biomes.tundra then str:=str+'Tundra, ';
        if bio.biomes.hell then str:=str+'Nether, ';
        delete(str,length(str)-1,2);
        str:=str+#13+#10+#13+#10;
      end;
    7:begin
        //str:=str+'Golden Tunnels'+#13+#10;
        tunnelp:=par;
        tunnel:=tunnelp^;
        str:=str+'Map width: '+inttostr(tunnel.width)+#13+#10;
        str:=str+'Map length: '+inttostr(tunnel.len)+#13+#10;
        str:=str+'Populate chunks: '+booltostr(tunnel.pop_chunks,true)+#13+#10;
        str:=str+'Raining: ';
        if level_settings.raining=1 then str:=str+'True'+#13+#10
        else str:=str+'False'+#13+#10;

        //delaem stroku vremeni dozhda
        time:=level_settings.rain_time;
        str1:='';
        if time>=60 then
          if ((time div 60) mod 10)=1 then str1:=str1+inttostr(time div 60)+' minute '
          else str1:=str1+inttostr(time div 60)+' minutes ';

        if (time mod 10)=1 then str1:=str1+inttostr(time mod 60)+' second'
        else str1:=str1+inttostr(time mod 60)+' seconds';

        str:=str+'Time until rain ';
        if level_settings.raining=1 then str:=str+'stops: '+str1
        else str:=str+'starts: '+str1;
        str:=str+#13+#10;

        str:=str+'Thundering: ';
        if level_settings.thundering=1 then str:=str+'True'+#13+#10
        else str:=str+'False'+#13+#10;
        //delaem stroku vremeni groma
        time:=level_settings.thunder_time;
        str1:='';
        if time>=60 then
          if ((time div 60) mod 10)=1 then str1:=str1+inttostr(time div 60)+' minute '
          else str1:=str1+inttostr(time div 60)+' minutes ';

        if (time mod 10)=1 then str1:=str1+inttostr(time mod 60)+' second'
        else str1:=str1+inttostr(time mod 60)+' seconds';

        str:=str+'Time until thunder ';
        if level_settings.thundering=1 then str:=str+'stops: '+str1
        else str:=str+'starts: '+str1;
        str:=str+#13+#10;

        str:=str+#13+#10;

        str:=str+'[Map settings]'+#13+#10;
        str:=str+'Map type: Golden Tunnels'+#13+#10;
        str:=str+'Tunnels density: '+inttostr(tunnel.tun_density)+'%'+#13+#10;
        if tunnel.round_tun=true then
        begin
          str:=str+'Round tunnels: '+booltostr(tunnel.round_tun,true)+#13+#10;
          str:=str+'Minimum tunnel radius: '+inttostr(tunnel.r_hor_min)+#13+#10;
          str:=str+'Maximum tunnel radius: '+inttostr(tunnel.r_hor_max)+#13+#10;
        end
        else
        begin
          str:=str+'Round tunnels: '+booltostr(tunnel.round_tun,true)+#13+#10;
          str:=str+'Minimum horizontal tunnel radius: '+inttostr(tunnel.r_hor_min)+#13+#10;
          str:=str+'Maximum horizontal tunnel radius: '+inttostr(tunnel.r_hor_max)+#13+#10;
          str:=str+'Minimum vertical tunnel radius: '+inttostr(tunnel.r_vert_min)+#13+#10;
          str:=str+'Maximum vertical tunnel radius: '+inttostr(tunnel.r_vert_max)+#13+#10;
          str:=str+'Percent of round tunnels: '+inttostr(tunnel.round_tun_density)+'%'+#13+#10;
        end;
        str:=str+'Generate light sourses: '+booltostr(tunnel.gen_lights,true)+#13+#10;
        if tunnel.gen_lights=true then
        begin
          str:=str+'Light source density: '+inttostr(tunnel.light_density)+'%'+#13+#10;
          str:=str+'Light source placement type: ';
          case tunnel.light_blocks_type of
            0:str:=str+'Original'+#13+#10;
            1:str:=str+'Inside walls'+#13+#10;
            2:str:=str+'Inside walls with glass'+#13+#10;
            3:str:=str+'Floating'+#13+#10;
          end;
          str:=str+'Light blocks: ';
          for i:=0 to length(tunnel.light_blocks)-1 do
            str:=str+getblockname(tunnel.light_blocks[i])+', ';
          delete(str,length(str)-1,2);
          str:=str+#13+#10;
        end;
        str:=str+'Generate skyholes: '+booltostr(tunnel.gen_sun_holes,true)+#13+#10;
        if tunnel.gen_sun_holes=true then
          str:=str+'Skyholes density: '+inttostr(tunnel.skyholes_density)+'%'+#13+#10;
        str:=str+'Generate tall grass: '+booltostr(tunnel.gen_tall_grass,true)+#13+#10;
        str:=str+'Generate HUBs: '+booltostr(tunnel.gen_hub,true)+#13+#10;
        str:=str+'Generate seperate tunnel systems: '+booltostr(tunnel.gen_seperate,true)+#13+#10;
        str:=str+'Generate flooded tunnels: '+booltostr(tunnel.gen_flooded,true)+#13+#10+#13+#10;
      end
    else
      begin
        str:=str+'Unknown'+#13+#10+#13+#10;
      end;
  end;

  //border
  str:=str+'[Border settings]'+#13+#10;
  str:=str+'Border type: ';
  case bor_set.border_type of
    0:begin
        str:=str+'Normal transition'+#13+#10;
        str:=str+'This type of border has no settings'+#13+#10+#13+#10;
      end;
    1:begin
        str:=str+'Wall'+#13+#10;   
        //str:=str+'Wall material: '+inttostr(bor_set.wall_material)+#13+#10;
        str:=str+'Wall material: '+getblockname(bor_set.wall_material)+#13+#10;
        
        str:=str+'Wall thickness: '+inttostr(bor_set.wall_thickness)+#13+#10;
        str:=str+'Generate void behind the wall: '+booltostr(bor_set.wall_void,true)+#13+#10;
        str:=str+'Void width: '+inttostr(bor_set.wall_void_thickness)+#13+#10+#13+#10;
      end;
    2:begin
        str:=str+'Void'+#13+#10;
        str:=str+'Void width: '+inttostr(bor_set.void_thickness)+#13+#10+#13+#10;
      end;
    3:begin
        str:=str+'Castle Wall'+#13+#10;
        str:=str+'Generate towers: '+booltostr(bor_set.cwall_gen_towers,true)+#13+#10;
        if bor_set.cwall_gen_towers=true then
        begin
          str:=str+'Towers type: ';
          case bor_set.cwall_towers_type of
          0:str:=str+'Square towers'+#13+#10
          else str:=str+'Unknown'+#13+#10;
          end;
          str:=str+'Generate rails around a map: '+booltostr(bor_set.cwall_gen_rails,true)+#13+#10;
        end;
        str:=str+'Generate interior: '+booltostr(bor_set.cwall_gen_interior,true)+#13+#10;
        if bor_set.cwall_gen_interior=true then
        begin
          str:=str+'Generate loopholes: '+booltostr(bor_set.cwall_gen_boinici,true)+#13+#10;
          if bor_set.cwall_gen_boinici=true then
            case bor_set.cwall_boinici_type of
            0:str:=str+'Loophole type: Line'+#13+#10;
            1:str:=str+'Loophole type: Cross'+#13+#10;
            2:str:=str+'Loophole type: Square'+#13+#10
            else str:=str+'Loophole type: Unknown'+#13+#10;
            end;
        end;
        str:=str+'Generate gates: '+booltostr(bor_set.cwall_gen_gates,true)+#13+#10;
        if bor_set.cwall_gen_gates=true then
          case bor_set.cwall_gates_type of
          0:str:=str+'Gates type: Bars gate'+#13+#10
          else str:=str+'Gates type: Unknown'+#13+#10;
          end;
        str:=str+'Generate void behind a wall: '+booltostr(bor_set.cwall_gen_void,true)+#13+#10;
        if bor_set.cwall_gen_void=true then
          str:=str+'Void width: '+inttostr(bor_set.cwall_void_width)+#13+#10+#13+#10;
      end
    else
      begin
        str:=str+'Unknown'+#13+#10+#13+#10;
      end;
  end;

  //features
  str:=str+'[Features settings]'+#13+#10;
  str:=str+'Not yet ready'+#13+#10+#13+#10;

  //inventory
  str:=str+'[Player settings]'+#13+#10;
  str:=str+'Not yet ready'+#13+#10+#13+#10;

  str:='MCTerra settings file'+#0+#1+#2+#1+#5+#13+#10+str;

  assignfile(f,path+name+'\settings.txt');
  rewrite(f,1);
  blockwrite(f,str[1],length(str));
  closefile(f);
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

procedure calc_rand_border(var ar:array of double; start,len:integer; koef:double);
var i:integer;
k,d,d1:double;
begin
  if len<=1 then exit;
  i:=len div 2;
  //k:=len * koef;
  k:=(ar[start]+ar[start+len-1])*koef;
  d1:=(ar[start]+ar[start+len-1])/2;
  repeat
    d:=d1+random*k-random*k;
  until (d<=32)and(d>-32);
  ar[start+i-1]:=d;
  calc_rand_border(ar,start,i,koef);
  calc_rand_border(ar,start+i,len-i,koef);
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

procedure gen_tun_waterlevel(var map:region; var waterlevel:integer);
var rx,ry,x,y,z,t:integer;
begin
  if waterlevel<0 then waterlevel:=0;
  if waterlevel>127 then waterlevel:=127;

  for rx:=0 to 35 do
    for ry:=0 to 35 do
      for x:=0 to 15 do
        for z:=0 to 15 do
          for y:=2 to waterlevel do
          begin
            t:=map[rx][ry].blocks[y+(z*128+(x*2048))];
            if (t=0)or(t=31) then
              map[rx][ry].blocks[y+(z*128+(x*2048))]:=8;
          end;
end;

procedure tunnel_sphere_intersection(ar_tun:array of tunnels_settings; i1:integer; psfere:par_planets_settings);
var i,j,k,z,max1:integer;
x1,y1,z1:extended;
//tt:tunnels_settings;
fromi,toi:integer;
b:boolean;
begin
  //smotrim nachalo tunela
  //opredelaem maksimalniy radius tunela v nachale
  max1:=max(ar_tun[i1].radius_horiz,ar_tun[i1].radius_vert);
  for i:=0 to length(ar_tun[i1].svazi_nach)-1 do
  begin
    k:=max(ar_tun[i1].svazi_nach[i]^.radius_horiz,ar_tun[i1].svazi_nach[i]^.radius_vert);
    if k>max1 then max1:=k;
  end;

  k:=max1-max(ar_tun[i1].radius_horiz,ar_tun[i1].radius_vert);

  if k>20 then exit;

  //opredelaem, po kakoy osi budem v glavnom tunele
    if abs(ar_tun[i1].x1-ar_tun[i1].x2)>abs(ar_tun[i1].z1-ar_tun[i1].z2) then b:=true
    else b:=false;

    if b=true then
    begin
      fromi:=min(ar_tun[i1].x1,ar_tun[i1].x2);
      toi:=max(ar_tun[i1].x1,ar_tun[i1].x2);
    end
    else
    begin
      fromi:=min(ar_tun[i1].z1,ar_tun[i1].z2);
      toi:=max(ar_tun[i1].z1,ar_tun[i1].z2);
    end;

  //smotrim tekushiy tunel'
  if k>0 then
  begin
    j:=max1-1;
    i:=fromi+2;
    while i<=(fromi+(k+1)*2) do
    begin
      //opredelaem koordinati tochki
      if b=true then
      begin
        x1:=i;
        y1:=ar_tun[i1].y1+(ar_tun[i1].y2-ar_tun[i1].y1)*((x1-ar_tun[i1].x1)/(ar_tun[i1].x2-ar_tun[i1].x1));
        z1:=ar_tun[i1].z1+(ar_tun[i1].z2-ar_tun[i1].z1)*((x1-ar_tun[i1].x1)/(ar_tun[i1].x2-ar_tun[i1].x1));
      end
      else
      begin
        z1:=i;
        x1:=ar_tun[i1].x1+(ar_tun[i1].x2-ar_tun[i1].x1)*((z1-ar_tun[i1].z1)/(ar_tun[i1].z2-ar_tun[i1].z1));
        y1:=ar_tun[i1].y1+(ar_tun[i1].y2-ar_tun[i1].y1)*((z1-ar_tun[i1].z1)/(ar_tun[i1].z2-ar_tun[i1].z1));
      end;

      z:=length(psfere^);
      setlength(psfere^,z+1);
      psfere^[z].x:=round(x1);
      psfere^[z].y:=round(y1);
      psfere^[z].z:=round(z1);
      psfere^[z].radius:=j;
      psfere^[z].material_shell:=3;
      psfere^[z].material_fill:=3;
      psfere^[z].material_thick:=1;
      psfere^[z].fill_level:=psfere^[z].radius*2-1;
      dec(j);
      inc(i,2);
    end;
  end;

  //smotrim konec tunela
  //opredelaem maksimalniy radius tunela v konce
  max1:=max(ar_tun[i1].radius_horiz,ar_tun[i1].radius_vert);
  for i:=0 to length(ar_tun[i1].svazi_kon)-1 do
  begin
    k:=max(ar_tun[i1].svazi_kon[i]^.radius_horiz,ar_tun[i1].svazi_kon[i]^.radius_vert);
    if k>max1 then max1:=k;
  end;

  k:=max1-max(ar_tun[i1].radius_horiz,ar_tun[i1].radius_vert);

  if k>20 then exit;

  //smotrim tekushiy tunel' v konce
  if k>0 then
  begin
    j:=max1-1;
    i:=toi-2;
    while i>=(toi-(k+1)*2) do
    begin
      //opredelaem koordinati tochki
      if b=true then
      begin
        x1:=i;
        y1:=ar_tun[i1].y1+(ar_tun[i1].y2-ar_tun[i1].y1)*((x1-ar_tun[i1].x1)/(ar_tun[i1].x2-ar_tun[i1].x1));
        z1:=ar_tun[i1].z1+(ar_tun[i1].z2-ar_tun[i1].z1)*((x1-ar_tun[i1].x1)/(ar_tun[i1].x2-ar_tun[i1].x1));
      end
      else
      begin
        z1:=i;
        x1:=ar_tun[i1].x1+(ar_tun[i1].x2-ar_tun[i1].x1)*((z1-ar_tun[i1].z1)/(ar_tun[i1].z2-ar_tun[i1].z1));
        y1:=ar_tun[i1].y1+(ar_tun[i1].y2-ar_tun[i1].y1)*((z1-ar_tun[i1].z1)/(ar_tun[i1].z2-ar_tun[i1].z1));
      end;

      z:=length(psfere^);
      setlength(psfere^,z+1);
      psfere^[z].x:=round(x1);
      psfere^[z].y:=round(y1);
      psfere^[z].z:=round(z1);
      psfere^[z].radius:=j;
      psfere^[z].material_shell:=3;
      psfere^[z].material_fill:=3;
      psfere^[z].material_thick:=1;
      psfere^[z].fill_level:=psfere^[z].radius*2-1;
      dec(j);
      dec(i,2);
    end;
  end;

  //smotrim soedinitelnie toneli
 (* for i:=0 to length(ar_tun[i1].svazi_nach)-1 do
  begin
    k:=max(ar_tun[i1].svazi_nach[i]^.radius_horiz,ar_tun[i1].svazi_nach[i]^.radius_vert);
    if k<max1 then
    begin
      tt:=ar_tun[i1].svazi_nach[i]^;
      //opredelaem glavnuyu os' soedinitel'nogo tunela
      if abs(tt.x1-tt.x2)>abs(tt.z1-tt.z2) then b:=true
      else b:=false;

      if b=true then
      begin
        fromi:=min(tt.x1,tt.x2);
        toi:=max(tt.x1,tt.x2);
      end
      else
      begin
        fromi:=min(tt.z1,tt.z2);
        toi:=max(tt.z1,tt.z2);
      end;

      if (ar_tun[i1].x1=tt.x1)and
      (ar_tun[i1].z1=tt.z1)and
      (ar_tun[i1].y1=tt.y1) then b1:=false
      else b1:=true;

      j:=max1-1;
      if b1=true then i2:=fromi+2
      else i2:=toi-2;

      while j>=max(tt.radius_horiz,tt.radius_vert) do
    begin
      //opredelaem koordinati tochki
      if b=true then
      begin
        x1:=i2;
        y1:=tt.y1+(tt.y2-tt.y1)*((x1-tt.x1)/(tt.x2-tt.x1));
        z1:=tt.z1+(tt.z2-tt.z1)*((x1-tt.x1)/(tt.x2-tt.x1));
      end
      else
      begin
        z1:=i2;
        x1:=tt.x1+(tt.x2-tt.x1)*((z1-tt.z1)/(tt.z2-tt.z1));
        y1:=tt.y1+(tt.y2-tt.y1)*((z1-tt.z1)/(tt.z2-tt.z1));
      end;

      z:=length(psfere^);
      setlength(psfere^,z+1);
      psfere^[z].x:=round(x1);
      psfere^[z].y:=round(y1);
      psfere^[z].z:=round(z1);
      psfere^[z].radius:=j;
      psfere^[z].material_shell:=3;
      psfere^[z].material_fill:=3;
      psfere^[z].material_thick:=1;
      psfere^[z].fill_level:=psfere^[z].radius*2-1;
      dec(j);
      if b1=true then inc(i2,2)
      else dec(i2,2);
    end;
    end;
  end;   *)

end;

function tunnel_length(ar_tun:array of tunnels_settings; i1:integer):double;
begin
  result:=sqrt(sqr(ar_tun[i1].x2-ar_tun[i1].x1)+sqr(ar_tun[i1].y2-ar_tun[i1].y1)+sqr(ar_tun[i1].z2-ar_tun[i1].z1));
end;

function tunnel_flat_angle(ar_tun:array of tunnels_settings; i1:integer):double;
var d:extended;
x1,y1,z1,x2,y2,z2,x3,y3,z3,x4,y4,z4:integer;
begin
  x1:=ar_tun[i1].x2;
  y1:=ar_tun[i1].y2;
  z1:=ar_tun[i1].z2;
  x3:=x1;
  y3:=y1;
  z3:=z1;
  x2:=ar_tun[i1].x1;
  y2:=ar_tun[i1].y1;
  z2:=ar_tun[i1].z1;

  x4:=ar_tun[i1].x1;
  y4:=y3;
  z4:=ar_tun[i1].z1;

  d:=(x2-x1)*(x4-x3)+(y2-y1)*(y4-y3)+(z2-z1)*(z4-z3);
  d:=d/(sqrt(sqr(x2-x1)+sqr(y2-y1)+sqr(z2-z1))*sqrt(sqr(x4-x3)+sqr(y4-y3)+sqr(z4-z3)));
  d:=arccos(d);
  d:=radtodeg(d);
  result:=d;
end;

function tunnel_angle(ar_tun:array of tunnels_settings; i1,i2:integer):double;
var d:extended;
x1,y1,z1,x2,y2,z2,x3,y3,z3,x4,y4,z4:integer;
begin
  {x1:=ar_tun[i1].x2;
  y1:=ar_tun[i1].y2;
  z1:=ar_tun[i1].z2;
  x3:=x1;
  y3:=y1;
  z3:=z1;
  x2:=ar_tun[i1].x1;
  y2:=ar_tun[i1].y1;
  z2:=ar_tun[i1].z1;

  x4:=ar_tun[i2].x2;
  y4:=ar_tun[i2].y2;
  z4:=ar_tun[i2].z2;  }
  
  x1:=ar_tun[i1].x1;
  y1:=ar_tun[i1].y1;
  z1:=ar_tun[i1].z1;
  x2:=ar_tun[i1].x2;
  y2:=ar_tun[i1].y2;
  z2:=ar_tun[i1].z2;
  x3:=ar_tun[i2].x1;
  y3:=ar_tun[i2].y1;
  z3:=ar_tun[i2].z1;
  x4:=ar_tun[i2].x2;
  y4:=ar_tun[i2].y2;
  z4:=ar_tun[i2].z2;

  d:=(x2-x1)*(x4-x3)+(y2-y1)*(y4-y3)+(z2-z1)*(z4-z3);
  d:=d/(sqrt(sqr(x2-x1)+sqr(y2-y1)+sqr(z2-z1))*sqrt(sqr(x4-x3)+sqr(y4-y3)+sqr(z4-z3)));
  if d>=1 then d:=d-0.0000000001;
  if d<=-1 then d:=d+0.0000000001;
  d:=arccos(d);
  d:=radtodeg(d);
  result:=d;
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

function tunnel_intersection2(ar_tun:array of tunnels_settings; indeks:integer; iskl:array of integer):boolean;
var b_ind,b_var:boolean;
fromind,toind,fromvar,tovar:integer;
d,x1,y1,z1,x2,y2,z2:extended;
i,j,k:integer;
begin
  if length(ar_tun)<=2 then
  begin
    result:=false;
    exit;
  end;

  //opredelenie granis i osi po indeksu
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

  for i:=0 to length(ar_tun)-1 do
  begin
    //opredelaem isklucheniya
    b_var:=false;
    for j:=0 to length(iskl)-1 do
      if iskl[j]=i then b_var:=true;

    if (b_var=true)or(i=indeks) then continue;

    //opredelenie granic i osi po i-tomu tunelu
    if abs(ar_tun[i].x1-ar_tun[i].x2)<abs(ar_tun[i].z1-ar_tun[i].z2) then
    begin
      b_var:=true;
      fromvar:=min(ar_tun[i].z1,ar_tun[i].z2);
      tovar:=max(ar_tun[i].z1,ar_tun[i].z2);
    end
    else
    begin
      b_var:=false;
      fromvar:=min(ar_tun[i].x1,ar_tun[i].x2);
      tovar:=max(ar_tun[i].x1,ar_tun[i].x2);
    end;

    for j:=fromind to toind do
      for k:=fromvar to tovar do
      begin
        //schitaem koordinati pervoy tochki, kotoraya otnositsa k indeksu
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

        //schitaem koordinati vtoroy tochki, kotoraya otnositsa k i
        if b_var=true then
        begin
          z2:=k;
          x2:=ar_tun[i].x1+(ar_tun[i].x2-ar_tun[i].x1)*((z2-ar_tun[i].z1)/(ar_tun[i].z2-ar_tun[i].z1));
          y2:=ar_tun[i].y1+(ar_tun[i].y2-ar_tun[i].y1)*((z2-ar_tun[i].z1)/(ar_tun[i].z2-ar_tun[i].z1));
        end
        else
        begin
          x2:=k;
          y2:=ar_tun[i].y1+(ar_tun[i].y2-ar_tun[i].y1)*((x2-ar_tun[i].x1)/(ar_tun[i].x2-ar_tun[i].x1));
          z2:=ar_tun[i].z1+(ar_tun[i].z2-ar_tun[i].z1)*((x2-ar_tun[i].x1)/(ar_tun[i].x2-ar_tun[i].x1));
        end;

        //vichislaem rasstoyanie
          d:=sqrt(sqr(x2-x1)+sqr(y2-y1)+sqr(z2-z1));
          if d<(max(ar_tun[i].radius_horiz,ar_tun[i].radius_vert)+max(ar_tun[indeks].radius_horiz,ar_tun[indeks].radius_vert)+15) then
          begin
            result:=true;
            exit;
          end;
      end;
  end;
  result:=false;
end;

function tunnel_intersection(ar_tun:array of tunnels_settings; indeks:integer; iskl:array of integer):boolean;
var i,j,k:integer;
b:boolean;
d,x1,y1,z1,x2,y2,z2:double;
fromk,tok:integer;
fromki,toki:integer;
begin
  if length(ar_tun)<=2 then
  begin
    result:=false;
    exit;
  end;

  if ar_tun[indeks].x1<ar_tun[indeks].x2 then
  begin
    fromki:=ar_tun[indeks].x1;
    toki:=ar_tun[indeks].x2;
  end
  else
  begin
    fromki:=ar_tun[indeks].x2;
    toki:=ar_tun[indeks].x1;
  end;

  for i:=0 to length(ar_tun)-1 do
  begin
    b:=false;
    for j:=0 to length(iskl)-1 do
      if iskl[j]=i then
      begin
        b:=true;
        break;
      end;
    if i=indeks then b:=true;

    if b=true then continue;

    b:=false;  //po X
    if abs(ar_tun[i].x2-ar_tun[i].x1)<abs(ar_tun[i].z2-ar_tun[i].z1) then b:=true;


    if b=false then //po X
    begin
      if ar_tun[i].x1<ar_tun[i].x2 then
      begin
        fromk:=ar_tun[i].x1;
        tok:=ar_tun[i].x2;
      end
      else
      begin
        fromk:=ar_tun[i].x2;
        tok:=ar_tun[i].x1;
      end;

      for j:=fromk to tok do
        for k:=fromki to toki do
        begin
          //vichislaem ostal'nie koordinati
          x1:=j;
          x2:=k;
          y1:=(ar_tun[i].y2-ar_tun[i].y1)*(((j-ar_tun[i].x1)/(ar_tun[i].x2-ar_tun[i].x1))+(ar_tun[i].y1/(ar_tun[i].y2-ar_tun[i].y1)));
          z1:=(ar_tun[i].z2-ar_tun[i].z1)*(((j-ar_tun[i].x1)/(ar_tun[i].x2-ar_tun[i].x1))+(ar_tun[i].z1/(ar_tun[i].z2-ar_tun[i].z1)));
          y2:=(ar_tun[indeks].y2-ar_tun[indeks].y1)*(((k-ar_tun[indeks].x1)/(ar_tun[indeks].x2-ar_tun[indeks].x1))+(ar_tun[indeks].y1/(ar_tun[indeks].y2-ar_tun[indeks].y1)));
          z2:=(ar_tun[indeks].z2-ar_tun[indeks].z1)*(((k-ar_tun[indeks].x1)/(ar_tun[indeks].x2-ar_tun[indeks].x1))+(ar_tun[indeks].z1/(ar_tun[indeks].z2-ar_tun[indeks].z1)));
          //vichislaem rasstoyanie
          d:=sqrt(sqr(x2-x1)+sqr(y2-y1)+sqr(z2-z1));
          if d<(ar_tun[i].radius_horiz+ar_tun[indeks].radius_horiz+5) then
          begin
            result:=true;
            exit;
          end;
        end;
    end
    else  //po Z
    begin
      if ar_tun[i].z1<ar_tun[i].z2 then
      begin
        fromk:=ar_tun[i].z1;
        tok:=ar_tun[i].z2;
      end
      else
      begin
        fromk:=ar_tun[i].z2;
        tok:=ar_tun[i].z1;
      end;

      for j:=fromk to tok do
        for k:=fromki to toki do
        begin
          //vichislaem ostal'nie koordinati
          z1:=j;
          x2:=k;
          y1:=(ar_tun[i].y2-ar_tun[i].y1)*(((j-ar_tun[i].z1)/(ar_tun[i].z2-ar_tun[i].z1))+(ar_tun[i].y1/(ar_tun[i].y2-ar_tun[i].y1)));
          x1:=(ar_tun[i].x2-ar_tun[i].x1)*(((j-ar_tun[i].z1)/(ar_tun[i].z2-ar_tun[i].z1))+(ar_tun[i].x1/(ar_tun[i].x2-ar_tun[i].x1)));

          y2:=(ar_tun[indeks].y2-ar_tun[indeks].y1)*(((k-ar_tun[indeks].x1)/(ar_tun[indeks].x2-ar_tun[indeks].x1))+(ar_tun[indeks].y1/(ar_tun[indeks].y2-ar_tun[indeks].y1)));
          z2:=(ar_tun[indeks].z2-ar_tun[indeks].z1)*(((k-ar_tun[indeks].x1)/(ar_tun[indeks].x2-ar_tun[indeks].x1))+(ar_tun[indeks].z1/(ar_tun[indeks].z2-ar_tun[indeks].z1)));
          //vichislaem rasstoyanie
          d:=sqrt(sqr(x2-x1)+sqr(y2-y1)+sqr(z2-z1));
          if d<(ar_tun[i].radius_horiz+ar_tun[indeks].radius_horiz+5) then
          begin
            result:=true;
            exit;
          end;
        end;
    end
  end;
  result:=false;
end;

procedure calc_tun_dirt(var map:region; xreg,yreg:integer;var pr_dirt:ar_elipse_settings; sid:int64);
var i,j,z1:integer;
xxr,yyr,zzr,xx,yy,zz,count:integer;
x,y,z:integer;
tempx,tempy,tempk,tempz:integer;
r:rnd;
begin
  r:=rnd.Create;
  for z1:=0 to length(pr_dirt)-1 do
  begin
    r.SetSeed(sid+i);

    if pr_dirt[z1].radius_vert<>0 then continue;

    if pr_dirt[z1].fill_material=1 then count:=r.nextInt(21)+10
    else if pr_dirt[z1].fill_material=2 then count:=10;
    
    x:=pr_dirt[z1].x;
    y:=pr_dirt[z1].y;
    z:=pr_dirt[z1].z;

    //sozdaetsa ellips
    //delaem randomnie radiusi
    if pr_dirt[z1].fill_material=1 then
    begin
      xxr:=r.nextInt(count-10)+10;
      yyr:=(r.nextInt(count-10)+10)shr 2;
      zzr:=r.nextInt(count-10)+10;
    end
    else if pr_dirt[z1].fill_material=2 then
    begin
      xxr:=(r.nextInt(count-10)+10)div 2;
      yyr:=((r.nextInt(count-10)+10)shr 2)div 2;
      zzr:=(r.nextInt(count-10)+10)div 2;
    end;

    if yyr<3 then yyr:=3;
    
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

    if (xxr<5)or(yyr<3)or(zzr<5) then
      continue
    else
    begin
      //zapolnaem dannie
      pr_dirt[z1].x:=xx;
      pr_dirt[z1].y:=yy;
      pr_dirt[z1].z:=zz;
      pr_dirt[z1].radius_x:=xxr;
      pr_dirt[z1].radius_z:=zzr;
      pr_dirt[z1].radius_vert:=yyr;
      
      //zapolnaem chanki
      //opredelaem kraynie koordinati po dvum osam
      tempx:=pr_dirt[z1].x-pr_dirt[z1].radius_x;
      tempk:=pr_dirt[z1].x+pr_dirt[z1].radius_x;
      tempy:=pr_dirt[z1].z-pr_dirt[z1].radius_z;
      tempz:=pr_dirt[z1].z+pr_dirt[z1].radius_z;

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
      if (tempx<=0)and((pr_dirt[z1].x-pr_dirt[z1].radius_x)<0) then tempx:=tempx-1;
      if (tempk<=0)and((pr_dirt[z1].x+pr_dirt[z1].radius_x)<0) then tempk:=tempk-1;
      if (tempy<=0)and((pr_dirt[z1].z-pr_dirt[z1].radius_z)<0) then tempy:=tempy-1;
      if (tempz<=0)and((pr_dirt[z1].z+pr_dirt[z1].radius_z)<0) then tempz:=tempz-1;

      //videlaem pamat'
      setlength(pr_dirt[z1].chunks,(tempk-tempx+1)*(tempz-tempy+1));

      //zapisivaem
      z:=0;
      for i:=tempx to tempk do
        for j:=tempy to tempz do
        begin
          pr_dirt[z1].chunks[z].x:=i;
          pr_dirt[z1].chunks[z].y:=j;
          inc(z);
        end;

    end;
  end;
  r.Free;
end;

procedure gen_resourses3(var map:region; xreg,yreg:integer; pr_res:ar_tlights_koord; tip:byte; sid:int64);

  function gen_schit(same:boolean; napravlenie:byte; map:region; rx,ry,x,y,z,id:byte; var verh,niz,levo,pravo,vpered,nazad:boolean):integer;
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
          if (t=1)or((t=id)and(same=true)) then verh:=true;
        end;

        if x=0 then
        begin
          t:=map[rx-1][ry].blocks[y+(z*128+(15*2048))];
          if (t=1)or((t=id)and(same=true)) then levo:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+(z*128+((x-1)*2048))];
          if (t=1)or((t=id)and(same=true)) then levo:=true;
        end;

        if x=15 then
        begin
          t:=map[rx+1][ry].blocks[y+(z*128)];
          if (t=1)or((t=id)and(same=true)) then pravo:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+(z*128+((x+1)*2048))];
          if (t=1)or((t=id)and(same=true)) then pravo:=true;
        end;

        if z=0 then
        begin
          t:=map[rx][ry-1].blocks[y+(15*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then nazad:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+((z-1)*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then nazad:=true;
        end;

        if z=15 then
        begin
          t:=map[rx][ry+1].blocks[y+(x*2048)];
          if (t=1)or((t=id)and(same=true)) then vpered:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+((z+1)*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then vpered:=true;
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
          if (t=1)or((t=id)and(same=true)) then niz:=true;
        end;

        if x=0 then
        begin
          t:=map[rx-1][ry].blocks[y+(z*128+(15*2048))];
          if (t=1)or((t=id)and(same=true)) then levo:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+(z*128+((x-1)*2048))];
          if (t=1)or((t=id)and(same=true)) then levo:=true;
        end;

        if x=15 then
        begin
          t:=map[rx+1][ry].blocks[y+(z*128)];
          if (t=1)or((t=id)and(same=true)) then pravo:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+(z*128+((x+1)*2048))];
          if (t=1)or((t=id)and(same=true)) then pravo:=true;
        end;

        if z=0 then
        begin
          t:=map[rx][ry-1].blocks[y+(15*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then nazad:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+((z-1)*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then nazad:=true;
        end;

        if z=15 then
        begin
          t:=map[rx][ry+1].blocks[y+(x*2048)];
          if (t=1)or((t=id)and(same=true)) then vpered:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+((z+1)*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then vpered:=true;
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
          if (t=1)or((t=id)and(same=true)) then niz:=true;
        end;

        if y<>127 then
        begin
          t:=map[rx][ry].blocks[y+1+(z*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then verh:=true;
        end;

        if x=0 then
        begin
          t:=map[rx-1][ry].blocks[y+(z*128+(15*2048))];
          if (t=1)or((t=id)and(same=true)) then levo:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+(z*128+((x-1)*2048))];
          if (t=1)or((t=id)and(same=true)) then levo:=true;
        end;

        if z=0 then
        begin
          t:=map[rx][ry-1].blocks[y+(15*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then nazad:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+((z-1)*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then nazad:=true;
        end;

        if z=15 then
        begin
          t:=map[rx][ry+1].blocks[y+(x*2048)];
          if (t=1)or((t=id)and(same=true)) then vpered:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+((z+1)*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then vpered:=true;
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
          if (t=1)or((t=id)and(same=true)) then niz:=true;
        end;

        if y<>127 then
        begin
          t:=map[rx][ry].blocks[y+1+(z*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then verh:=true;
        end;

        if x=15 then
        begin
          t:=map[rx+1][ry].blocks[y+(z*128)];
          if (t=1)or((t=id)and(same=true)) then pravo:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+(z*128+((x+1)*2048))];
          if (t=1)or((t=id)and(same=true)) then pravo:=true;
        end;

        if z=0 then
        begin
          t:=map[rx][ry-1].blocks[y+(15*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then nazad:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+((z-1)*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then nazad:=true;
        end;

        if z=15 then
        begin
          t:=map[rx][ry+1].blocks[y+(x*2048)];
          if (t=1)or((t=id)and(same=true)) then vpered:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+((z+1)*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then vpered:=true;
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
          if (t=1)or((t=id)and(same=true)) then niz:=true;
        end;

        if y<>127 then
        begin
          t:=map[rx][ry].blocks[y+1+(z*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then verh:=true;
        end;

        if x=0 then
        begin
          t:=map[rx-1][ry].blocks[y+(z*128+(15*2048))];
          if (t=1)or((t=id)and(same=true)) then levo:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+(z*128+((x-1)*2048))];
          if (t=1)or((t=id)and(same=true)) then levo:=true;
        end;

        if x=15 then
        begin
          t:=map[rx+1][ry].blocks[y+(z*128)];
          if (t=1)or((t=id)and(same=true)) then pravo:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+(z*128+((x+1)*2048))];
          if (t=1)or((t=id)and(same=true)) then pravo:=true;
        end;

        if z=15 then
        begin
          t:=map[rx][ry+1].blocks[y+(x*2048)];
          if (t=1)or((t=id)and(same=true)) then vpered:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+((z+1)*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then vpered:=true;
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
          if (t=1)or((t=id)and(same=true)) then niz:=true;
        end;

        if y<>127 then
        begin
          t:=map[rx][ry].blocks[y+1+(z*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then verh:=true;
        end;

        if x=0 then
        begin
          t:=map[rx-1][ry].blocks[y+(z*128+(15*2048))];
          if (t=1)or((t=id)and(same=true)) then levo:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+(z*128+((x-1)*2048))];
          if (t=1)or((t=id)and(same=true)) then levo:=true;
        end;

        if x=15 then
        begin
          t:=map[rx+1][ry].blocks[y+(z*128)];
          if (t=1)or((t=id)and(same=true)) then pravo:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+(z*128+((x+1)*2048))];
          if (t=1)or((t=id)and(same=true)) then pravo:=true;
        end;

        if z=0 then
        begin
          t:=map[rx][ry-1].blocks[y+(15*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then nazad:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+((z-1)*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then nazad:=true;
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

  function gen_recur(napravlenie:byte; var map:region; rx,ry,x,y,z,id,tip:integer; count:integer; var r:rnd):integer;
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
        k:=gen_schit(true,napravlenie,map,rx,ry,x,y,z,id,verh,niz,levo,pravo,vpered,nazad);

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
            if y<>127 then sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y+1,z,id,tip,trunc(znach[1]),r);

            if x=0 then sum:=sum+gen_recur(napravlenie,map,rx-1,ry,15,y,z,id,tip,trunc(znach[3]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x-1,y,z,id,tip,trunc(znach[3]),r);

            if x=15 then sum:=sum+gen_recur(napravlenie,map,rx+1,ry,0,y,z,id,tip,trunc(znach[4]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x+1,y,z,id,tip,trunc(znach[4]),r);

            if z=15 then sum:=sum+gen_recur(napravlenie,map,rx,ry+1,x,y,0,id,tip,trunc(znach[5]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y,z+1,id,tip,trunc(znach[5]),r);

            if z=0 then sum:=sum+gen_recur(napravlenie,map,rx,ry-1,x,y,15,id,tip,trunc(znach[6]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y,z-1,id,tip,trunc(znach[6]),r);
          end;
        2:begin    //niz
            if y<>0 then sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y-1,z,id,tip,trunc(znach[2]),r);

            if x=0 then sum:=sum+gen_recur(napravlenie,map,rx-1,ry,15,y,z,id,tip,trunc(znach[3]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x-1,y,z,id,tip,trunc(znach[3]),r);

            if x=15 then sum:=sum+gen_recur(napravlenie,map,rx+1,ry,0,y,z,id,tip,trunc(znach[4]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x+1,y,z,id,tip,trunc(znach[4]),r);

            if z=15 then sum:=sum+gen_recur(napravlenie,map,rx,ry+1,x,y,0,id,tip,trunc(znach[5]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y,z+1,id,tip,trunc(znach[5]),r);

            if z=0 then sum:=sum+gen_recur(napravlenie,map,rx,ry-1,x,y,15,id,tip,trunc(znach[6]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y,z-1,id,tip,trunc(znach[6]),r);
          end;
        3:begin    //levo
            if y<>127 then sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y+1,z,id,tip,trunc(znach[1]),r);

            if y<>0 then sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y-1,z,id,tip,trunc(znach[2]),r);

            if x=0 then sum:=sum+gen_recur(napravlenie,map,rx-1,ry,15,y,z,id,tip,trunc(znach[3]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x-1,y,z,id,tip,trunc(znach[3]),r);

            if z=15 then sum:=sum+gen_recur(napravlenie,map,rx,ry+1,x,y,0,id,tip,trunc(znach[5]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y,z+1,id,tip,trunc(znach[5]),r);

            if z=0 then sum:=sum+gen_recur(napravlenie,map,rx,ry-1,x,y,15,id,tip,trunc(znach[6]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y,z-1,id,tip,trunc(znach[6]),r);
          end;
        4:begin    //pravo
            if y<>127 then sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y+1,z,id,tip,trunc(znach[1]),r);

            if y<>0 then sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y-1,z,id,tip,trunc(znach[2]),r);

            if x=15 then sum:=sum+gen_recur(napravlenie,map,rx+1,ry,0,y,z,id,tip,trunc(znach[4]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x+1,y,z,id,tip,trunc(znach[4]),r);

            if z=15 then sum:=sum+gen_recur(napravlenie,map,rx,ry+1,x,y,0,id,tip,trunc(znach[5]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y,z+1,id,tip,trunc(znach[5]),r);

            if z=0 then sum:=sum+gen_recur(napravlenie,map,rx,ry-1,x,y,15,id,tip,trunc(znach[6]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y,z-1,id,tip,trunc(znach[6]),r);
          end;
        5:begin    //vpered
            if y<>127 then sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y+1,z,id,tip,trunc(znach[1]),r);

            if y<>0 then sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y-1,z,id,tip,trunc(znach[2]),r);

            if x=0 then sum:=sum+gen_recur(napravlenie,map,rx-1,ry,15,y,z,id,tip,trunc(znach[3]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x-1,y,z,id,tip,trunc(znach[3]),r);

            if x=15 then sum:=sum+gen_recur(napravlenie,map,rx+1,ry,0,y,z,id,tip,trunc(znach[4]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x+1,y,z,id,tip,trunc(znach[4]),r);

            if z=15 then sum:=sum+gen_recur(napravlenie,map,rx,ry+1,x,y,0,id,tip,trunc(znach[5]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y,z+1,id,tip,trunc(znach[5]),r);
          end;
        6:begin    //nazad
            if y<>127 then sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y+1,z,id,tip,trunc(znach[1]),r);

            if y<>0 then sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y-1,z,id,tip,trunc(znach[2]),r);

            if x=0 then sum:=sum+gen_recur(napravlenie,map,rx-1,ry,15,y,z,id,tip,trunc(znach[3]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x-1,y,z,id,tip,trunc(znach[3]),r);

            if x=15 then sum:=sum+gen_recur(napravlenie,map,rx+1,ry,0,y,z,id,tip,trunc(znach[4]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x+1,y,z,id,tip,trunc(znach[4]),r);

            if z=0 then sum:=sum+gen_recur(napravlenie,map,rx,ry-1,x,y,15,id,tip,trunc(znach[6]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y,z-1,id,tip,trunc(znach[6]),r);
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
        else
        begin
        if get_block_id(map,xreg,yreg,pr_res[i].x,pr_res[i].y+1,pr_res[i].z)=1 then
          gen_recur(1,map,chx,chy,x,y,z,pr_res[i].id,0,count,r);

        if get_block_id(map,xreg,yreg,pr_res[i].x,pr_res[i].y-1,pr_res[i].z)=1 then
          gen_recur(2,map,chx,chy,x,y,z,pr_res[i].id,0,count,r);

        if get_block_id(map,xreg,yreg,pr_res[i].x-1,pr_res[i].y,pr_res[i].z)=1 then
          gen_recur(3,map,chx,chy,x,y,z,pr_res[i].id,0,count,r);

        if get_block_id(map,xreg,yreg,pr_res[i].x+1,pr_res[i].y,pr_res[i].z)=1 then
          gen_recur(4,map,chx,chy,x,y,z,pr_res[i].id,0,count,r);

        if get_block_id(map,xreg,yreg,pr_res[i].x,pr_res[i].y,pr_res[i].z+1)=1 then
          gen_recur(5,map,chx,chy,x,y,z,pr_res[i].id,0,count,r);

        if get_block_id(map,xreg,yreg,pr_res[i].x,pr_res[i].y,pr_res[i].z-1)=1 then
          gen_recur(6,map,chx,chy,x,y,z,pr_res[i].id,0,count,r);
        end;

        r.Free;
      end;

      if tip=1 then
      begin
        r:=rnd.create(sid+i);

        t:=r.nextInt(21)+10;

        gen_recur(1,map,0,0,pr_res[i].x,pr_res[i].y,pr_res[i].z,3,1,t,r);

        r.free;
      end;
      //map[chx][chy].blocks[y+(z*128+(x*2048))]:=20;
    end;
  end;
end;

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

procedure gen_resourses(var map:region; sid:int64; chx,chy,x,y,z,id,tip:integer; count:integer);

  function gen_schit(same:boolean; napravlenie:byte; map:region; rx,ry,x,y,z,id:byte; var verh,niz,levo,pravo,vpered,nazad:boolean):integer;
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
          if (t=1)or((t=id)and(same=true)) then verh:=true;
        end;

        if x=0 then
        begin
          t:=map[rx-1][ry].blocks[y+(z*128+(15*2048))];
          if (t=1)or((t=id)and(same=true)) then levo:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+(z*128+((x-1)*2048))];
          if (t=1)or((t=id)and(same=true)) then levo:=true;
        end;

        if x=15 then
        begin
          t:=map[rx+1][ry].blocks[y+(z*128)];
          if (t=1)or((t=id)and(same=true)) then pravo:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+(z*128+((x+1)*2048))];
          if (t=1)or((t=id)and(same=true)) then pravo:=true;
        end;

        if z=0 then
        begin
          t:=map[rx][ry-1].blocks[y+(15*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then nazad:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+((z-1)*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then nazad:=true;
        end;

        if z=15 then
        begin
          t:=map[rx][ry+1].blocks[y+(x*2048)];
          if (t=1)or((t=id)and(same=true)) then vpered:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+((z+1)*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then vpered:=true;
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
          t:=map[rx][ry].blocks[y-1+(z*128+(15*2048))];
          if (t=1)or((t=id)and(same=true)) then niz:=true;
        end;

        if x=0 then
        begin
          t:=map[rx-1][ry].blocks[y+(z*128+(15*2048))];
          if (t=1)or((t=id)and(same=true)) then levo:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+(z*128+((x-1)*2048))];
          if (t=1)or((t=id)and(same=true)) then levo:=true;
        end;

        if x=15 then
        begin
          t:=map[rx+1][ry].blocks[y+(z*128)];
          if (t=1)or((t=id)and(same=true)) then pravo:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+(z*128+((x+1)*2048))];
          if (t=1)or((t=id)and(same=true)) then pravo:=true;
        end;

        if z=0 then
        begin
          t:=map[rx][ry-1].blocks[y+(15*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then nazad:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+((z-1)*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then nazad:=true;
        end;

        if z=15 then
        begin
          t:=map[rx][ry+1].blocks[y+(x*2048)];
          if (t=1)or((t=id)and(same=true)) then vpered:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+((z+1)*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then vpered:=true;
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
          t:=map[rx][ry].blocks[y-1+(z*128+(15*2048))];
          if (t=1)or((t=id)and(same=true)) then niz:=true;
        end;

        if y<>127 then
        begin
          t:=map[rx][ry].blocks[y+1+(z*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then verh:=true;
        end;

        if x=0 then
        begin
          t:=map[rx-1][ry].blocks[y+(z*128+(15*2048))];
          if (t=1)or((t=id)and(same=true)) then levo:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+(z*128+((x-1)*2048))];
          if (t=1)or((t=id)and(same=true)) then levo:=true;
        end;

        if z=0 then
        begin
          t:=map[rx][ry-1].blocks[y+(15*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then nazad:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+((z-1)*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then nazad:=true;
        end;

        if z=15 then
        begin
          t:=map[rx][ry+1].blocks[y+(x*2048)];
          if (t=1)or((t=id)and(same=true)) then vpered:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+((z+1)*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then vpered:=true;
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
          t:=map[rx][ry].blocks[y-1+(z*128+(15*2048))];
          if (t=1)or((t=id)and(same=true)) then niz:=true;
        end;

        if y<>127 then
        begin
          t:=map[rx][ry].blocks[y+1+(z*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then verh:=true;
        end;

        if x=15 then
        begin
          t:=map[rx+1][ry].blocks[y+(z*128)];
          if (t=1)or((t=id)and(same=true)) then pravo:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+(z*128+((x+1)*2048))];
          if (t=1)or((t=id)and(same=true)) then pravo:=true;
        end;

        if z=0 then
        begin
          t:=map[rx][ry-1].blocks[y+(15*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then nazad:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+((z-1)*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then nazad:=true;
        end;

        if z=15 then
        begin
          t:=map[rx][ry+1].blocks[y+(x*2048)];
          if (t=1)or((t=id)and(same=true)) then vpered:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+((z+1)*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then vpered:=true;
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
          t:=map[rx][ry].blocks[y-1+(z*128+(15*2048))];
          if (t=1)or((t=id)and(same=true)) then niz:=true;
        end;

        if y<>127 then
        begin
          t:=map[rx][ry].blocks[y+1+(z*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then verh:=true;
        end;

        if x=0 then
        begin
          t:=map[rx-1][ry].blocks[y+(z*128+(15*2048))];
          if (t=1)or((t=id)and(same=true)) then levo:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+(z*128+((x-1)*2048))];
          if (t=1)or((t=id)and(same=true)) then levo:=true;
        end;

        if x=15 then
        begin
          t:=map[rx+1][ry].blocks[y+(z*128)];
          if (t=1)or((t=id)and(same=true)) then pravo:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+(z*128+((x+1)*2048))];
          if (t=1)or((t=id)and(same=true)) then pravo:=true;
        end;

        if z=15 then
        begin
          t:=map[rx][ry+1].blocks[y+(x*2048)];
          if (t=1)or((t=id)and(same=true)) then vpered:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+((z+1)*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then vpered:=true;
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
          t:=map[rx][ry].blocks[y-1+(z*128+(15*2048))];
          if (t=1)or((t=id)and(same=true)) then niz:=true;
        end;

        if y<>127 then
        begin
          t:=map[rx][ry].blocks[y+1+(z*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then verh:=true;
        end;

        if x=0 then
        begin
          t:=map[rx-1][ry].blocks[y+(z*128+(15*2048))];
          if (t=1)or((t=id)and(same=true)) then levo:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+(z*128+((x-1)*2048))];
          if (t=1)or((t=id)and(same=true)) then levo:=true;
        end;

        if x=15 then
        begin
          t:=map[rx+1][ry].blocks[y+(z*128)];
          if (t=1)or((t=id)and(same=true)) then pravo:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+(z*128+((x+1)*2048))];
          if (t=1)or((t=id)and(same=true)) then pravo:=true;
        end;

        if z=0 then
        begin
          t:=map[rx][ry-1].blocks[y+(15*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then nazad:=true;
        end else
        begin
          t:=map[rx][ry].blocks[y+((z-1)*128+(x*2048))];
          if (t=1)or((t=id)and(same=true)) then nazad:=true;
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

  function gen_recur(napravlenie:byte; var map:region; rx,ry,x,y,z,id,tip:integer; count:integer; var r:rnd):integer;
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
        k:=gen_schit(true,napravlenie,map,rx,ry,x,y,z,id,verh,niz,levo,pravo,vpered,nazad);

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
            if y<>127 then sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y+1,z,id,tip,trunc(znach[1]),r);

            if x=0 then sum:=sum+gen_recur(napravlenie,map,rx-1,ry,15,y,z,id,tip,trunc(znach[3]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x-1,y,z,id,tip,trunc(znach[3]),r);

            if x=15 then sum:=sum+gen_recur(napravlenie,map,rx+1,ry,0,y,z,id,tip,trunc(znach[4]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x+1,y,z,id,tip,trunc(znach[4]),r);

            if z=15 then sum:=sum+gen_recur(napravlenie,map,rx,ry+1,x,y,0,id,tip,trunc(znach[5]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y,z+1,id,tip,trunc(znach[5]),r);

            if z=0 then sum:=sum+gen_recur(napravlenie,map,rx,ry-1,x,y,15,id,tip,trunc(znach[6]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y,z-1,id,tip,trunc(znach[6]),r);
          end;
        2:begin    //niz
            if y<>0 then sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y-1,z,id,tip,trunc(znach[2]),r);

            if x=0 then sum:=sum+gen_recur(napravlenie,map,rx-1,ry,15,y,z,id,tip,trunc(znach[3]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x-1,y,z,id,tip,trunc(znach[3]),r);

            if x=15 then sum:=sum+gen_recur(napravlenie,map,rx+1,ry,0,y,z,id,tip,trunc(znach[4]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x+1,y,z,id,tip,trunc(znach[4]),r);

            if z=15 then sum:=sum+gen_recur(napravlenie,map,rx,ry+1,x,y,0,id,tip,trunc(znach[5]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y,z+1,id,tip,trunc(znach[5]),r);

            if z=0 then sum:=sum+gen_recur(napravlenie,map,rx,ry-1,x,y,15,id,tip,trunc(znach[6]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y,z-1,id,tip,trunc(znach[6]),r);
          end;
        3:begin    //levo
            if y<>127 then sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y+1,z,id,tip,trunc(znach[1]),r);

            if y<>0 then sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y-1,z,id,tip,trunc(znach[2]),r);

            if x=0 then sum:=sum+gen_recur(napravlenie,map,rx-1,ry,15,y,z,id,tip,trunc(znach[3]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x-1,y,z,id,tip,trunc(znach[3]),r);

            if z=15 then sum:=sum+gen_recur(napravlenie,map,rx,ry+1,x,y,0,id,tip,trunc(znach[5]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y,z+1,id,tip,trunc(znach[5]),r);

            if z=0 then sum:=sum+gen_recur(napravlenie,map,rx,ry-1,x,y,15,id,tip,trunc(znach[6]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y,z-1,id,tip,trunc(znach[6]),r);
          end;
        4:begin    //pravo
            if y<>127 then sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y+1,z,id,tip,trunc(znach[1]),r);

            if y<>0 then sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y-1,z,id,tip,trunc(znach[2]),r);

            if x=15 then sum:=sum+gen_recur(napravlenie,map,rx+1,ry,0,y,z,id,tip,trunc(znach[4]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x+1,y,z,id,tip,trunc(znach[4]),r);

            if z=15 then sum:=sum+gen_recur(napravlenie,map,rx,ry+1,x,y,0,id,tip,trunc(znach[5]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y,z+1,id,tip,trunc(znach[5]),r);

            if z=0 then sum:=sum+gen_recur(napravlenie,map,rx,ry-1,x,y,15,id,tip,trunc(znach[6]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y,z-1,id,tip,trunc(znach[6]),r);
          end;
        5:begin    //vpered
            if y<>127 then sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y+1,z,id,tip,trunc(znach[1]),r);

            if y<>0 then sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y-1,z,id,tip,trunc(znach[2]),r);

            if x=0 then sum:=sum+gen_recur(napravlenie,map,rx-1,ry,15,y,z,id,tip,trunc(znach[3]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x-1,y,z,id,tip,trunc(znach[3]),r);

            if x=15 then sum:=sum+gen_recur(napravlenie,map,rx+1,ry,0,y,z,id,tip,trunc(znach[4]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x+1,y,z,id,tip,trunc(znach[4]),r);

            if z=15 then sum:=sum+gen_recur(napravlenie,map,rx,ry+1,x,y,0,id,tip,trunc(znach[5]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y,z+1,id,tip,trunc(znach[5]),r);
          end;
        6:begin    //nazad
            if y<>127 then sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y+1,z,id,tip,trunc(znach[1]),r);

            if y<>0 then sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y-1,z,id,tip,trunc(znach[2]),r);

            if x=0 then sum:=sum+gen_recur(napravlenie,map,rx-1,ry,15,y,z,id,tip,trunc(znach[3]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x-1,y,z,id,tip,trunc(znach[3]),r);

            if x=15 then sum:=sum+gen_recur(napravlenie,map,rx+1,ry,0,y,z,id,tip,trunc(znach[4]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x+1,y,z,id,tip,trunc(znach[4]),r);

            if z=0 then sum:=sum+gen_recur(napravlenie,map,rx,ry-1,x,y,15,id,tip,trunc(znach[6]),r)
            else sum:=sum+gen_recur(napravlenie,map,rx,ry,x,y,z-1,id,tip,trunc(znach[6]),r);
          end;
        end;
        result:=trunc(sum);
      end;
    1:begin  //rasprostranenie po poverhnosti
        if count<=5 then exit;
        //sozdaetsa ellips
        //delaem randomnie radiusi
        xxr:=random(count-10)+10;
        yyr:=(random(count-10)+10)shr 2;
        zzr:=random(count-10)+10;

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


        for i:=xx-xxr to xx+xxr do
          for k:=zz-zzr to zz+zzr do
            begin
              sum:=sqr(yyr)*(1-sqr((i-xx)/xxr)-sqr((k-zz)/zzr));
              if sum<0 then continue;
              for j:=round(yy-sqrt(sum)) to round(yy+sqrt(sum)) do
                if get_block_id(map,-1,-1,i,j,k)=1 then
                  if (id=3)and(get_block_id(map,-1,-1,i,j+1,k)=0) then
                    set_block_id(map,-1,-1,i,j,k,2)
                  else
                    set_block_id(map,-1,-1,i,j,k,id);
            end;

      end;
    end;
  end;

var r:rnd;
s:integer;
begin
  r:=Rnd.Create(sid);

  if tip=0 then
  begin
    s:=gen_recur(1,map,chx,chy,x,y,z,id,tip,count,r);
  end;
  {s:=s+gen_recur(2,map,chx,chy,x,y,z,id,tip,count,r);
  s:=s+gen_recur(3,map,chx,chy,x,y,z,id,tip,count,r);
  s:=s+gen_recur(4,map,chx,chy,x,y,z,id,tip,count,r);
  s:=s+gen_recur(5,map,chx,chy,x,y,z,id,tip,count,r);
  s:=s+gen_recur(6,map,chx,chy,x,y,z,id,tip,count,r);   }

  r.Free;
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

procedure gen_tun_holes(map:region; xreg,yreg:integer; pr_koord:ar_tprostr_koord);
var tempxot,tempyot,tempxdo,tempydo:integer;
chx,chy:integer;
i,j,k:integer;
x,y,z,t:integer;
b:boolean;
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

  for i:=0 to length(pr_koord)-1 do
  begin
    if pr_koord[i].z=1000 then continue;

    if (pr_koord[i].x<(xreg*512-10))or(pr_koord[i].x>(xreg*512+522))or
    (pr_koord[i].y<(yreg*512-10))or(pr_koord[i].y>(yreg*512+522)) then continue;

    //proveraem, umeshaetsa li lovushka
    b:=true;
    for j:=pr_koord[i].x-3 to pr_koord[i].x+3 do
      for k:=pr_koord[i].y-3 to pr_koord[i].y+3 do
      begin
        if b=false then break;
        //opredelaem, k kakomu chanku otnositsa
        chx:=j;
        chy:=k;
        if chx<0 then inc(chx);
        if chy<0 then inc(chy);
        chx:=chx div 16;
        chy:=chy div 16;
        if (chx<=0)and(j<0) then dec(chx);
        if (chy<=0)and(k<0) then dec(chy);

        //uslovie
        if (chx>=tempxot)and(chx<=tempxdo)and(chy>=tempyot)and(chy<=tempydo) then
        begin
          //perevodim v koordinati chanka
          x:=j mod 16;
          z:=k mod 16;
          if x<0 then inc(x,16);
          if z<0 then inc(z,16);
          chx:=chx-tempxot;
          chy:=chy-tempyot;

          for y:=127 downto 119 do
          begin
            t:=map[chx][chy].blocks[y+(z*128+(x*2048))];
            if (t<>1)and(t<>7)and(t<>10)and(t<>20) then
            begin
              b:=false;
              break;
            end;
          end;
        end;
      end;

    if b=false then
    begin
      pr_koord[i].z:=1000;
      continue;
    end;


    (*for j:=pr_koord[i].x-3 to pr_koord[i].x+3 do
      for k:=pr_koord[i].y-3 to pr_koord[i].y+3 do
        if (j=pr_koord[i].x)and(k=pr_koord[i].y) then
        begin
          chx:=j;
          chy:=k;
          if chx<0 then inc(chx);
          if chy<0 then inc(chy);
          chx:=chx div 16;
          chy:=chy div 16;
          if (chx<=0)and(j<0) then dec(chx);
          if (chy<=0)and(k<0) then dec(chy);

          //uslovie
          if (chx>=tempxot)and(chx<=tempxdo)and(chy>=tempyot)and(chy<=tempydo) then
          begin
            //perevodim v koordinati chanka
            x:=j mod 16;
            z:=k mod 16;
            if x<0 then inc(x,16);
            if z<0 then inc(z,16);
            chx:=chx-tempxot;
            chy:=chy-tempyot;

            for y:=127 downto 123 do
              map[chx][chy].blocks[y+(z*128+(x*2048))]:=0;

            //map[chx][chy].blocks[121+(z*128+(x*2048))]:=1;
            y:=122;
            b:=true;
            while b=true do
            begin
              t:=map[chx][chy].blocks[y+(z*128+(x*2048))];
              if (t<>1)or(y=0) then b:=false
              else
                map[chx][chy].blocks[y+(z*128+(x*2048))]:=20;
              dec(y);
            end;

            inc(y);
            b:=true;
            while b=true do
            begin
              t:=map[chx][chy].blocks[y+(z*128+(x*2048))];
              if (t=1)or(y=0) then b:=false
              else
                map[chx][chy].blocks[y+(z*128+(x*2048))]:=0;
              dec(y);
            end;

            map[chx][chy].blocks[120+(z*128+(x*2048))]:=76;
            map[chx][chy].data[120+(z*128+(x*2048))]:=5;

          end;
        end
        else
        begin
          //opredelaem, k kakomu chanku otnositsa
          chx:=j;
          chy:=k;
          if chx<0 then inc(chx);
          if chy<0 then inc(chy);
          chx:=chx div 16;
          chy:=chy div 16;
          if (chx<=0)and(j<0) then dec(chx);
          if (chy<=0)and(k<0) then dec(chy);

          //uslovie
          if (chx>=tempxot)and(chx<=tempxdo)and(chy>=tempyot)and(chy<=tempydo) then
          begin
            //perevodim v koordinati chanka
            x:=j mod 16;
            z:=k mod 16;
            if x<0 then inc(x,16);
            if z<0 then inc(z,16);
            chx:=chx-tempxot;
            chy:=chy-tempyot;

            if (j=pr_koord[i].x-3)or(j=pr_koord[i].x+3)or
            (k=pr_koord[i].y-3)or(k=pr_koord[i].y+3) then
            begin
              for y:=127 downto 120 do
                map[chx][chy].blocks[y+(z*128+(x*2048))]:=7;
            end
            else if (j=pr_koord[i].x)and(k=pr_koord[i].y+1) then
            begin
              //redstone
              map[chx][chy].blocks[120+(z*128+(x*2048))]:=55;
              map[chx][chy].data[120+(z*128+(x*2048))]:=15;
              //bedrock
              map[chx][chy].blocks[121+(z*128+(x*2048))]:=7;
              //lava
              map[chx][chy].blocks[122+(z*128+(x*2048))]:=10;
              //air
              for y:=123 to 126 do
                map[chx][chy].blocks[y+(z*128+(x*2048))]:=0;
              //TNT
              map[chx][chy].blocks[127+(z*128+(x*2048))]:=46;
            end
            else if (j=pr_koord[i].x)and(k=pr_koord[i].y+2) then
            begin
              //stone
              map[chx][chy].blocks[120+(z*128+(x*2048))]:=1;
              map[chx][chy].blocks[122+(z*128+(x*2048))]:=1;
              map[chx][chy].blocks[124+(z*128+(x*2048))]:=1;
              //redstone torch
              map[chx][chy].blocks[121+(z*128+(x*2048))]:=75;
              map[chx][chy].data[121+(z*128+(x*2048))]:=5;
              map[chx][chy].blocks[123+(z*128+(x*2048))]:=76;
              map[chx][chy].data[123+(z*128+(x*2048))]:=5;
              map[chx][chy].blocks[127+(z*128+(x*2048))]:=75;
              map[chx][chy].data[127+(z*128+(x*2048))]:=2;
              //air
              for y:=125 to 126 do
                map[chx][chy].blocks[y+(z*128+(x*2048))]:=0;
            end
            else if (j=pr_koord[i].x+1)and(k=pr_koord[i].y+2) then
            begin
              //redstone torch
              map[chx][chy].blocks[124+(z*128+(x*2048))]:=75;
              map[chx][chy].data[124+(z*128+(x*2048))]:=1;
              map[chx][chy].blocks[126+(z*128+(x*2048))]:=76;
              map[chx][chy].data[126+(z*128+(x*2048))]:=5;
              //stone
              map[chx][chy].blocks[125+(z*128+(x*2048))]:=1;
              //map[chx][chy].blocks[127+(z*128+(x*2048))]:=7;
              //lava
              for y:=122 to 122 do
                map[chx][chy].blocks[y+(z*128+(x*2048))]:=10;
              //glass
              map[chx][chy].blocks[120+(z*128+(x*2048))]:=20;
              map[chx][chy].blocks[121+(z*128+(x*2048))]:=20;
              //air
              map[chx][chy].blocks[123+(z*128+(x*2048))]:=0;
            end
            else if ((j=pr_koord[i].x+1)or((j=pr_koord[i].x-1)))and(k=pr_koord[i].y+1) then
            begin
              //glass
              map[chx][chy].blocks[120+(z*128+(x*2048))]:=20;
              //lava
              map[chx][chy].blocks[121+(z*128+(x*2048))]:=10;
              map[chx][chy].blocks[122+(z*128+(x*2048))]:=10;
              //air
              for y:=123 to 126 do
                map[chx][chy].blocks[y+(z*128+(x*2048))]:=0;
              //bedrock
              map[chx][chy].blocks[127+(z*128+(x*2048))]:=7;
            end
            else if ((j=pr_koord[i].x+1)and(k=pr_koord[i].y))or
            ((j=pr_koord[i].x-1)and(k=pr_koord[i].y))or
            ((j=pr_koord[i].x)and(k=pr_koord[i].y-1)) then
            begin
              //bedrock
              map[chx][chy].blocks[120+(z*128+(x*2048))]:=7;
              map[chx][chy].blocks[127+(z*128+(x*2048))]:=7;
              //lava
              map[chx][chy].blocks[121+(z*128+(x*2048))]:=10;
              map[chx][chy].blocks[122+(z*128+(x*2048))]:=10;
              //air
              for y:=123 to 126 do
                map[chx][chy].blocks[y+(z*128+(x*2048))]:=0;
            end
            else if (j=pr_koord[i].x-1)and(k=pr_koord[i].y+2) then
            begin
              //glass
              map[chx][chy].blocks[120+(z*128+(x*2048))]:=20;
              map[chx][chy].blocks[121+(z*128+(x*2048))]:=20;
              //lava
              map[chx][chy].blocks[122+(z*128+(x*2048))]:=10;
              //air
              for y:=123 to 126 do
                map[chx][chy].blocks[y+(z*128+(x*2048))]:=0;
              //bedrock
              map[chx][chy].blocks[127+(z*128+(x*2048))]:=7;
            end
            else
            begin
              //air
              for y:=123 to 126 do
                map[chx][chy].blocks[y+(z*128+(x*2048))]:=0;
              //lava
              map[chx][chy].blocks[121+(z*128+(x*2048))]:=10;
              map[chx][chy].blocks[122+(z*128+(x*2048))]:=10;
              //bedrock
              map[chx][chy].blocks[120+(z*128+(x*2048))]:=7;
             // map[chx][chy].blocks[127+(z*128+(x*2048))]:=7;
            end;
            {else
              for y:=120 to 126 do
                map[chx][chy].blocks[y+(z*128+(x*2048))]:=0;   }

            y:=119;
            map[chx][chy].blocks[y+(z*128+(x*2048))]:=7;
          end;
        end;   *)


    for j:=pr_koord[i].x-6 to pr_koord[i].x+6 do
      for k:=pr_koord[i].y-6 to pr_koord[i].y+6 do
        if (j=pr_koord[i].x)and(k=pr_koord[i].y) then
        begin
          //opredelaem, k kakomu chanku otnositsa
          chx:=j;
          chy:=k;
          if chx<0 then inc(chx);
          if chy<0 then inc(chy);
          chx:=chx div 16;
          chy:=chy div 16;
          if (chx<=0)and(j<0) then dec(chx);
          if (chy<=0)and(k<0) then dec(chy);

          //uslovie
          if (chx>=tempxot)and(chx<=tempxdo)and(chy>=tempyot)and(chy<=tempydo) then
          begin
            //perevodim v koordinati chanka
            x:=j mod 16;
            z:=k mod 16;
            if x<0 then inc(x,16);
            if z<0 then inc(z,16);
            chx:=chx-tempxot;
            chy:=chy-tempyot;

            y:=127;
            map[chx][chy].blocks[y+(z*128+(x*2048))]:=1;
            b:=true;
            while b=true do
            begin
              t:=map[chx][chy].blocks[y+(z*128+(x*2048))];
              if (t<>1)or(y=0) then b:=false
              else
                map[chx][chy].blocks[y+(z*128+(x*2048))]:=20;
              dec(y);
            end;

            inc(y);
            b:=true;
            while b=true do
            begin
              t:=map[chx][chy].blocks[y+(z*128+(x*2048))];
              if (t=1)or(t=8)or(y=0) then b:=false
              else
                map[chx][chy].blocks[y+(z*128+(x*2048))]:=0;
              dec(y);
            end;
          end;
        end
        else
        begin
          //opredelaem, k kakomu chanku otnositsa
          chx:=j;
          chy:=k;
          if chx<0 then inc(chx);
          if chy<0 then inc(chy);
          chx:=chx div 16;
          chy:=chy div 16;
          if (chx<=0)and(j<0) then dec(chx);
          if (chy<=0)and(k<0) then dec(chy);

          //uslovie
          if (chx>=tempxot)and(chx<=tempxdo)and(chy>=tempyot)and(chy<=tempydo) then
          begin
            //perevodim v koordinati chanka
            x:=j mod 16;
            z:=k mod 16;
            if x<0 then inc(x,16);
            if z<0 then inc(z,16);
            chx:=chx-tempxot;
            chy:=chy-tempyot;

            if (j=pr_koord[i].x-6)or(j=pr_koord[i].x+6)or
            (k=pr_koord[i].y-6)or(k=pr_koord[i].y+6) then t:=7
            else t:=11;

            if map[chx][chy].blocks[127+(z*128+(x*2048))]=11 then t:=11;

            for y:=127 downto 123 do
              map[chx][chy].blocks[y+(z*128+(x*2048))]:=t;
            y:=122;
            map[chx][chy].blocks[y+(z*128+(x*2048))]:=7; 
          end;
        end;
  end;
end;

procedure gen_tun_lights(map:region; xreg,yreg:integer; pr_koord:ar_tlights_koord);
var rx,ry,i:integer;
tempxot,tempyot,tempxdo,tempydo:integer;
chx,chy:integer;
x,y,z,t,id:integer;
x1,y1,z1:integer;
vih:boolean;
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

  {inc(tempxot);
  inc(tempyot);
  dec(tempxdo);
  dec(tempydo); }

  for i:=0 to length(pr_koord)-1 do
  begin
    //opredelaem, k kakomu chanku otnositsa
    chx:=pr_koord[i].x;
    chy:=pr_koord[i].z;

    if chx<0 then inc(chx);
    if chy<0 then inc(chy);

    chx:=chx div 16;
    chy:=chy div 16;

    if (chx<=0)and(pr_koord[i].x<0) then dec(chx);
    if (chy<=0)and(pr_koord[i].z<0) then dec(chy);

    //uslovie
    if (chx>=tempxot)and(chx<=tempxdo)and(chy>=tempyot)and(chy<=tempydo) then
    begin
      //proverka na pravilnoe raspolozhenie istochnikov
      vih:=false;
      x:=pr_koord[i].x;
      y:=pr_koord[i].y;
      z:=pr_koord[i].z;
      id:=pr_koord[i].id;

      //po x
      t:=get_block_id(map,xreg,yreg,x-1,y,z);
      if (t<>0)and(t<>17)and(t<>18)and(t<>20)and
      (t<>31)and(t<>8)and(t<>9)and
      (t<>39)and(t<>40)and(t<>13) then
      begin
        if t=id then continue;
        vih:=true;
      end;
      t:=get_block_id(map,xreg,yreg,x+1,y,z);
      if (t<>0)and(t<>17)and(t<>18)and(t<>20)and
      (t<>31)and(t<>8)and(t<>9)and
      (t<>39)and(t<>40)and(t<>13) then
      begin
        if t=id then continue;
        vih:=true;
      end;
      //po y
      t:=get_block_id(map,xreg,yreg,x,y-1,z);
      if (t<>0)and(t<>17)and(t<>18)and(t<>20)and
      (t<>31)and(t<>8)and(t<>9)and
      (t<>39)and(t<>40)and(t<>13) then
      begin
        if t=id then continue;
        vih:=true;
      end;
      t:=get_block_id(map,xreg,yreg,x,y+1,z);
      if (t<>0)and(t<>17)and(t<>18)and(t<>20)and
      (t<>31)and(t<>8)and(t<>9)and
      (t<>39)and(t<>40)and(t<>13) then
      begin
        if t=id then continue;
        vih:=true;
      end;
      //po z
      t:=get_block_id(map,xreg,yreg,x,y,z-1);
      if (t<>0)and(t<>17)and(t<>18)and(t<>20)and
      (t<>31)and(t<>8)and(t<>9)and
      (t<>39)and(t<>40)and(t<>13) then
      begin
        if t=id then continue;
        vih:=true;
      end;
      t:=get_block_id(map,xreg,yreg,x,y,z+1);
      if (t<>0)and(t<>17)and(t<>18)and(t<>20)and
      (t<>31)and(t<>8)and(t<>9)and
      (t<>39)and(t<>40)and(t<>13) then
      begin
        if t=id then continue;
        vih:=true;
      end;

      if vih=true then
      for x1:=x-1 to x+1 do
        for y1:=y-1 to y+1 do
          for z1:=z-1 to z+1 do
            if get_block_id(map,xreg,yreg,x1,y1,z1)=id then vih:=false;

      if vih=true then
      begin
        //perevodim v koordinati chanka
        x:=pr_koord[i].x mod 16;
        z:=pr_koord[i].z mod 16;
        if x<0 then inc(x,16);
        if z<0 then inc(z,16);
        y:=pr_koord[i].y;

        //perevodim koordinati chanka v koordinati otnositelno regiona
        chx:=chx-tempxot;
        chy:=chy-tempyot;

        t:=map[chx][chy].blocks[y+(z*128+(x*2048))];
        if (t=0)or(t=8) then
        //if t=1 then
          map[chx][chy].blocks[y+(z*128+(x*2048))]:=id;
      end;  
    end;
  end;


  (*
  for rx:=0 to 35 do
    for ry:=0 to 35 do
    begin
      if xreg<0 then tempx:=((xreg+1)*32-(32-rx))
      else tempx:=(xreg*32)+rx;

      if yreg<0 then  tempy:=((yreg*32)+ry)
      else tempy:=(yreg+1)*32-(32-ry);

      dec(tempx,2);
      dec(tempy,2);

      otx:=tempx*16;
      oty:=tempy*16;
      dox:=otx+15;
      doy:=oty+15;

      for i:=0 to length(pr_koord)-1 do
      begin
        if (pr_koord[i].x>otx)and(pr_koord[i].x<dox)and
        (pr_koord[i].z>oty)and(pr_koord[i].z<doy) then
        begin
          {x:=(pr_koord[i].x div 16);
          z:=(pr_koord[i].z div 16);
          if x<0 then dec(x);
          if z<0 then dec(z);
          x:=x+(pr_koord[i].x mod 16);
          z:=z+(pr_koord[i].z mod 16); }
          x:=pr_koord[i].x mod 16;
          z:=pr_koord[i].z mod 16;
          if x<0 then inc(x,16);
          if z<0 then inc(z,16);
          y:=pr_koord[i].y;
          map[rx][ry].blocks[y+(z*128+(x*2048))]:=89;
        end;
      end;
    end;  *)
end;

procedure gen_tun(xkoord,ykoord:integer; var blocks:array of byte; var tun:array of tunnels_settings; pr_koord:par_tlights_koord; pr_koord_holes:par_tprostr_koord; pr_koord_dirt:par_elipse_settings; pr_koord_res:par_tlights_koord; pop,gen_l,gen_s:boolean; light_den,skyholes_den:byte);
var k,t,t1:integer;
i,j,z:integer;
x1,z1,y1:integer;
f:byte;
dl1:extended;
xx,yy,zz,d:extended;
koef:extended;
vih:boolean;
mas_koord:ar_tprostr_koord;
mas_koord_holes:ar_tkoord;
begin
  setlength(mas_koord,0);
  setlength(mas_koord_holes,0);

  for k:=0 to length(tun)-1 do
  begin
    vih:=true;
    for t:=0 to length(tun[k].chunks)-1 do
      if (tun[k].chunks[t].x=xkoord)and(tun[k].chunks[t].y=ykoord) then
      begin
        vih:=false;
        break;
      end;
    //dla otladki
    //vih:=false;

    if vih=true then continue;

    //zapolnaem chank steklom dla otladki
    //fillchar(blocks[0],length(blocks),20);

    //zapominaem material zalivki
    f:=tun[k].fill_material;

    //vichisaem otnositelnie koordinati
    x1:=xkoord*16;
    z1:=ykoord*16;

    x1:=tun[k].x1-x1;
    z1:=tun[k].z1-z1;
    y1:=tun[k].y1;

    dl1:=sqrt(sqr(tun[k].x2-tun[k].x1)+sqr(tun[k].y2-tun[k].y1)+sqr(tun[k].z2-tun[k].z1));


    for z:=1 to 127 do  //Y
      for i:=0 to 15 do  //X
        for j:=0 to 15 do  //Z
        begin
          xx:=(i-x1)*tun[k].c2x+(z-y1)*tun[k].c2y+(j-z1)*tun[k].c2z;
          yy:=(i-x1)*tun[k].c1x+(z-y1)*tun[k].c1y+(j-z1)*tun[k].c1z;
          zz:=(i-x1)*tun[k].c3x+(z-y1)*tun[k].c3y+(j-z1)*tun[k].c3z;

          if (yy>=dl1)or(yy<0) then continue;

          d:=sqr(xx)/sqr(tun[k].radius_horiz)+sqr(zz)/sqr(tun[k].radius_vert);

          koef:=1.425+(min(tun[k].radius_horiz,tun[k].radius_vert)-5)*(-0.0138);

          //ToDO: vozmozhno dobavit' 2 sloya zapolneniya iz raznih materialov
          //proverat' rasstoyanie ot poluchennoy tochki do osi Y (centra cilindra)
          //if d<=sqr(cyl[k].radius) then
          if (d<=koef) then
          begin

            {if (d>=1)and(d<koef)and(gen_l=true)and(random<(light_den/5000)) then
            begin
              t:=length(mas_koord);
              setlength(mas_koord,t+1);
              mas_koord[t].x:=i;
              mas_koord[t].y:=z;
              mas_koord[t].z:=j;
            end;   }
            if (d>=0.8)and(d<1)and(gen_l=true)and(random<(light_den/5000)) then
            begin
              t:=length(mas_koord);
              setlength(mas_koord,t+1);
              mas_koord[t].x:=i;
              mas_koord[t].y:=z;
              mas_koord[t].z:=j;
            end;  

            if (d>=1)and(d<=koef)and(random<0.0004)and(zz>0) then
            begin
              t:=xkoord;
              t1:=ykoord;
              if t>0 then dec(t);
              if t1>0 then dec(t1);
              t:=abs(xkoord mod 32);
              t1:=abs(ykoord mod 32);
              if (t>2)and(t<30)and(t1>2)and(t1<30) then
              begin
                t:=length(pr_koord_dirt^);
                setlength(pr_koord_dirt^,t+1);
                pr_koord_dirt^[t].x:=i+xkoord*16;
                pr_koord_dirt^[t].y:=z;
                pr_koord_dirt^[t].z:=j+ykoord*16;
                if random<0.12 then pr_koord_dirt^[t].fill_material:=2
                else pr_koord_dirt^[t].fill_material:=1;
              end;
            end;
            if (d>=1)and(d<=koef)and(random<0.00011) then
            begin
              t:=length(pr_koord_res^);
              setlength(pr_koord_res^,t+1);
              pr_koord_res^[t].x:=i+xkoord*16;
              pr_koord_res^[t].z:=j+ykoord*16;
              pr_koord_res^[t].y:=z;
              t1:=random(100);
              case t1 of
                0..7:pr_koord_res^[t].id:=14;   //Gold
                8..37:pr_koord_res^[t].id:=15;  //Iron
                38..75:pr_koord_res^[t].id:=16;  //Coal
                76..79:pr_koord_res^[t].id:=21;  //Lapiz
                80..95:if random>0.1 then pr_koord_res^[t].id:=73 else pr_koord_res^[t].id:=74;  //Redstone
                96..99:pr_koord_res^[t].id:=56;  //Dimond
              end;
            end;
            if (d>=0.3)and(d<=0.4)and
            (random<(skyholes_den/10000))and(pop=false)and(gen_s=true)and
            (yy<(dl1-10))and(yy>10) then
            begin
              t:=length(mas_koord_holes);
              setlength(mas_koord_holes,t+1);
              mas_koord_holes[t].x:=i;
              mas_koord_holes[t].y:=j;
            end;

            if d<=1 then
            begin
              if (tun[k].flooded=true)and(z<=tun[k].waterlevel) then
                blocks[z+(j*128+(i*2048))]:=8
              else
                blocks[z+(j*128+(i*2048))]:=f;
            end;
          end;
        end;

    if pop=false then
    begin
      //perenosim koordinati v massiv dirok
      for i:=0 to length(mas_koord_holes)-1 do
      begin
        t:=length(pr_koord_holes^);
        setlength(pr_koord_holes^,t+1);
        pr_koord_holes^[t].x:=mas_koord_holes[i].x+xkoord*16;
        pr_koord_holes^[t].y:=mas_koord_holes[i].y+ykoord*16;
      end;

    for i:=0 to length(mas_koord)-1 do
      //if random<(light_den/5000) then
      begin
        //prisvaivanie materiala

        z:=89;

        //vih:=true;
        {vih:=false;
        if (mas_koord[i].x<>0) then
        begin
          t:=blocks[mas_koord[i].y+(mas_koord[i].z*128+((mas_koord[i].x-1)*2048))];
          if t=z then continue;
          if t<>0 then vih:=true;
        end;

        if (mas_koord[i].x<>15)and(vih=false) then
        begin
          t:=blocks[mas_koord[i].y+(mas_koord[i].z*128+((mas_koord[i].x+1)*2048))];
          if t=z then continue;
          if t<>0 then vih:=true;
        end;

        if (mas_koord[i].z<>0)and(vih=false) then
        begin
          t:=blocks[mas_koord[i].y+((mas_koord[i].z-1)*128+(mas_koord[i].x*2048))];
          if t=z then continue;
          if t<>0 then vih:=true;
        end;

        if (mas_koord[i].z<>15)and(vih=false) then
        begin
          t:=blocks[mas_koord[i].y+((mas_koord[i].z+1)*128+(mas_koord[i].x*2048))];
          if t=z then continue;
          if t<>0 then vih:=true;
        end;

        if (mas_koord[i].y<>0)and(vih=false) then
        begin
          t:=blocks[(mas_koord[i].y-1)+(mas_koord[i].z*128+(mas_koord[i].x*2048))];
          if t=z then continue;
          if t<>0 then vih:=true;
        end;

        if (mas_koord[i].y<>127)and(vih=false) then
        begin
          t:=blocks[(mas_koord[i].y+1)+(mas_koord[i].z*128+(mas_koord[i].x*2048))];
          if t=z then continue;
          if t<>0 then vih:=true;
        end;  }

        //if vih=true then
        begin
          //blocks[mas_koord[i].y+(mas_koord[i].z*128+(mas_koord[i].x*2048))]:=z;
          //perevodim koordinati v obshie
          t:=length(pr_koord^);
          setlength(pr_koord^,t+1);
          pr_koord^[t].x:=xkoord*16+mas_koord[i].x;
          pr_koord^[t].z:=ykoord*16+mas_koord[i].z;
          pr_koord^[t].y:=mas_koord[i].y;
          pr_koord^[t].id:=z;
        end;
      end;
    end;

    setlength(mas_koord,0);
    setlength(mas_koord_holes,0);
  end;
end;  

procedure gen_plosk(xkoord,ykoord:integer; var blocks:array of byte);
var v1x,v1y,v1z,v2x,v2y,v2z,v3x,v3y,v3z:extended;
c1x,c1y,c1z,c2x,c2y,c2z,c3x,c3y,c3z:extended;
dl1,dl2,dl3:extended;
xx1,yy1,zz1,xx2,yy2,zz2:integer;
i,j,k,z:integer;
x1,y1,z1:integer;
xx,yy,zz,t:extended;
begin
    xx1:=20;
    yy1:=70;
    zz1:=-50;
    xx2:=20;
    yy2:=70;
    zz2:=-30;

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
    c1x:=v1x/dl1;
    c1y:=v1y/dl1;
    c1z:=v1z/dl1;

    c2x:=v2x/dl2;
    c2y:=v2y/dl2;
    c2z:=v2z/dl2;

    c3x:=v3x/dl3;
    c3y:=v3y/dl3;
    c3z:=v3z/dl3;

  //vichisaem otnositelnie koordinati
    x1:=xkoord*16;
    z1:=ykoord*16;

    x1:=xx1-x1;
    z1:=zz1-z1;
    y1:=yy1;

    dl1:=sqrt(sqr(xx2-xx1)+sqr(yy2-yy1)+sqr(zz2-zz1));


    for z:=1 to 127 do  //Y
      for i:=0 to 15 do  //X
        for j:=0 to 15 do  //Z
        begin
          xx:=(i-x1)*c2x+(z-y1)*c2y+(j-z1)*c2z;
          yy:=(i-x1)*c1x+(z-y1)*c1y+(j-z1)*c1z;
          zz:=(i-x1)*c3x+(z-y1)*c3y+(j-z1)*c3z;

          //t:=5*cos(yy/5+cos(xx/5));

          //if (zz>=t-0.5){and(zz<=t+0.5)} then
          if (zz>=-0.5)and(zz<=0.5)and(xx<=5)and(xx>=-5)and(yy>=0)and(yy<=dl1) then
            blocks[z+(j*128+(i*2048))]:=1;
        end;
end;

procedure gen_elipse(xkoord,ykoord:integer; var blocks:array of byte; var sferi:ar_elipse_settings; trees,pr_koord:par_tlights_koord; pr_res:par_tlights_koord; pop,gen_l:boolean; light_den:byte; tip:byte);
var i,j,k,l,z11,z22,t,t1,t2:integer;
x1,y1,z1,r_x,r_z,r_y:integer;
mat:byte;
temp:extended;
vih:boolean;
mas_koord:ar_tprostr_koord;
mas_koord_res:ar_tlights_koord;
r:rnd;
sid:int64;
id:integer;
begin
  setlength(mas_koord,0);
  setlength(mas_koord_res,0);
  r:=rnd.Create;

  for k:=0 to length(sferi)-1 do
  begin
    vih:=true;
    for i:=0 to length(sferi[k].chunks)-1 do
    if (sferi[k].chunks[i].x=xkoord)and(sferi[k].chunks[i].y=ykoord) then vih:=false;

    if vih=true then continue;

    sid:=sferi[k].x*3169+sferi[k].y*9214+sferi[k].z*2467+sferi[k].radius_x*34647;
    r.SetSeed(sid);
    sid:=r.nextInt(1000);
    case sid of
      0..23:id:=14;
      24..113:id:=15;
      114..227:id:=16;
      228..239:id:=21;
      240..287:if r.nextDouble>0.1 then id:=73 else id:=74;
      288..299:id:=56;
      300..390:id:=82
    else id:=0;
    end;

    mat:=sferi[k].fill_material;
    x1:=xkoord*16;
    z1:=ykoord*16;
    x1:=sferi[k].x-x1;
    z1:=sferi[k].z-z1;
    y1:=sferi[k].y;
    r_x:=sferi[k].radius_x;
    r_z:=sferi[k].radius_z;
    r_y:=sferi[k].radius_vert;

    if sferi[k].fill_material=1 then vih:=false
    else if sferi[k].fill_material=2 then vih:=true;

    for i:=0 to 15 do  //Z        //levo pravo
      for j:=y1-round((r_y/3)*2) to y1+round((r_y/3)*2) do   //Y
      begin
        temp:=sqr(r_x)*(1-sqr((j-y1)/r_y)-sqr((i-z1)/r_z));
        if temp<0 then continue;
        z11:=x1+round(sqrt(temp));
        z22:=x1-round(sqrt(temp));
        for l:=z22 to z11 do
          if (l>=0)and(l<=15) then
          begin
            if (l=z22)or(l=z11) then
            begin
              if (pop=false)and(id<>0) then
              begin
                t:=length(mas_koord_res);
                setlength(mas_koord_res,t+1);
                if (l=z22)and(id<>82) then
                begin
                  mas_koord_res[t].x:=l-1;
                  mas_koord_res[t].y:=j;
                  mas_koord_res[t].z:=i;
                  mas_koord_res[t].id:=id;
                end
                else if (l=z11)and(id<>82) then
                begin
                  mas_koord_res[t].x:=l+1;
                  mas_koord_res[t].y:=j;
                  mas_koord_res[t].z:=i;
                  mas_koord_res[t].id:=id;
                end;
              end;
              if (gen_l=true) then
              begin
                t:=length(mas_koord);
                setlength(mas_koord,t+1);
                mas_koord[t].x:=l;
                mas_koord[t].y:=j;
                mas_koord[t].z:=i;
              end;
            end;
            if tip=0 then
              if (sferi[k].flooded=true)and(j<=sferi[k].waterlevel) then
                blocks[j+(i*128+(l*2048))]:=8
              else
                blocks[j+(i*128+(l*2048))]:=mat
            else if (tip=1)and(vih=false) then
            begin
              t:=blocks[j+(i*128+(l*2048))];
              if (t<>0)and(t<>8)and(t<>82)and(blocks[j+1+(i*128+(l*2048))]=0) then
                blocks[j+(i*128+(l*2048))]:=2
              else if (t<>0)and(t<>8)and(t<>82) then
                blocks[j+(i*128+(l*2048))]:=3;
            end
            else if (tip=1)and(vih=true) then
            begin
              t:=blocks[j+(i*128+(l*2048))];
              if (t<>0)and(t<>2)and(t<>3)and(t<>8)and(t<>82) then
                blocks[j+(i*128+(l*2048))]:=13;
            end;
          end;
      end;

    for i:=0 to 15 do  //X            //pered zad
      for j:=y1-round((r_y/3)*2) to y1+round((r_y/3)*2) do   //Y
      begin
        temp:=sqr(r_z)*(1-sqr((i-x1)/r_x)-sqr((j-y1)/r_y));
        if temp<0 then continue;
        z11:=z1+round(sqrt(temp));
        z22:=z1-round(sqrt(temp));
        for l:=z22 to z11 do
          if (l>=0)and(l<=15) then
          begin
            if (l=z22)or(l=z11) then
            begin
              if (pop=false)and(id<>0) then
              begin
                t:=length(mas_koord_res);
                setlength(mas_koord_res,t+1);
                if (l=z22)and(id<>82) then
                begin
                  mas_koord_res[t].x:=i;
                  mas_koord_res[t].y:=j;
                  mas_koord_res[t].z:=l-1;
                  mas_koord_res[t].id:=id;
                end
                else if (l=z11)and(id<>82) then
                begin
                  mas_koord_res[t].x:=i;
                  mas_koord_res[t].y:=j;
                  mas_koord_res[t].z:=l+1;
                  mas_koord_res[t].id:=id;
                end;
              end;
              if (gen_l=true) then
              begin
                t:=length(mas_koord);
                setlength(mas_koord,t+1);
                mas_koord[t].x:=i;
                mas_koord[t].y:=j;
                mas_koord[t].z:=l;
              end;
            end;
            if tip=0 then
              if (sferi[k].flooded=true)and(j<=sferi[k].waterlevel) then
                blocks[j+(l*128+(i*2048))]:=8
              else
                blocks[j+(l*128+(i*2048))]:=mat
            else if (tip=1)and(vih=false) then
            begin
              t:=blocks[j+(l*128+(i*2048))];
              if (t<>0)and(t<>8)and(t<>82)and(blocks[j+1+(l*128+(i*2048))]=0) then
                blocks[j+(l*128+(i*2048))]:=2
              else if (t<>0)and(t<>8)and(t<>82) then
                blocks[j+(l*128+(i*2048))]:=3;
            end
            else if (tip=1)and(vih=true) then
            begin
              t:=blocks[j+(i*128+(l*2048))];
              if (t<>0)and(t<>2)and(t<>3)and(t<>8)and(t<>82) then
                blocks[j+(i*128+(l*2048))]:=13;
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
        begin
            if (l=z22)or(l=z11) then
            begin
              if (pop=false)and(id<>0) then
              begin
                t:=length(mas_koord_res);
                setlength(mas_koord_res,t+1);
                if l=z22 then
                begin
                  mas_koord_res[t].x:=i;
                  mas_koord_res[t].y:=l-1;
                  mas_koord_res[t].z:=j;
                  mas_koord_res[t].id:=id;
                end
                else if l=z11 then
                begin
                  mas_koord_res[t].x:=i;
                  mas_koord_res[t].y:=l+1;
                  mas_koord_res[t].z:=j;
                  mas_koord_res[t].id:=id;
                end;
              end;
              if (gen_l=true) then
              begin
                t:=length(mas_koord);
                setlength(mas_koord,t+1);
                mas_koord[t].x:=i;
                mas_koord[t].y:=l;
                mas_koord[t].z:=j;
              end;
            end;

            if tip=0 then
              if (sferi[k].flooded=true)and(l<=sferi[k].waterlevel) then
                blocks[l+(j*128+(i*2048))]:=8
              else
                blocks[l+(j*128+(i*2048))]:=mat
            else if (tip=1)and(vih=false) then   //zemla
            begin     
                t:=blocks[l+(j*128+(i*2048))];
                if (t<>0)and(t<>8)and(t<>82)and(blocks[l+1+(j*128+(i*2048))]=0) then
                begin
                  blocks[l+(j*128+(i*2048))]:=2;
                  t1:=i+xkoord*16;
                  t2:=j+ykoord*16;
                  if t1>0 then dec(t1);
                  if t2>0 then dec(t2);
                  {t1:=abs(t1);
                  t2:=abs(t2);
                  while t1>512 do
                    dec(t1,512);
                  while t2>512 do
                    dec(t2,512);   }
                  t1:=abs(t1 mod 512);
                  t2:=abs(t2 mod 512);

                  if (random<0.06)and(t1>4)and(t1<508)and(t2>4)and(t2<508) then
                  begin
                    t1:=length(trees^);       //derevo
                    setlength(trees^,t1+1);
                    trees^[t1].x:=i+xkoord*16;
                    trees^[t1].z:=j+ykoord*16;
                    trees^[t1].y:=l+1;
                    trees^[t1].id:=0;
                  end
                  else
                  if random<0.2 then    //trava
                  begin
                    t1:=length(trees^);
                    setlength(trees^,t1+1);
                    trees^[t1].x:=i+xkoord*16;
                    trees^[t1].z:=j+ykoord*16;
                    trees^[t1].y:=l+1;
                    trees^[t1].id:=1;
                  end;
                end
                else if (t<>0)and(t<>8)and(t<>82) then
                  blocks[l+(j*128+(i*2048))]:=3;

            end
            else if (tip=1)and(vih=true) then    //graviy
            begin
              t:=blocks[l+(j*128+(i*2048))];
              if (t<>0)and(t<>8)and(t<>2)and(t<>3)and(t<>82)and(blocks[l+1+(j*128+(i*2048))]=0) then
              begin
                blocks[l+(j*128+(i*2048))]:=13;
                if random<0.07 then
                begin
                  t1:=length(trees^);       //grib
                  setlength(trees^,t1+1);
                  trees^[t1].x:=i+xkoord*16;
                  trees^[t1].z:=j+ykoord*16;
                  trees^[t1].y:=l+1;
                  if random<0.5 then trees^[t1].id:=2
                  else trees^[t1].id:=3;
                end;
              end
              else if (t<>0)and(t<>8)and(t<>2)and(t<>3)and(t<>82) then
                blocks[l+(j*128+(i*2048))]:=13;
            end;
        end;
      end;
  end;

  //rabota s koordinatami osvesheniya+++++++++++++++++
  for i:=0 to length(mas_koord)-2 do
  begin
    if mas_koord[i].y=1000 then continue;
    for j:=i+1 to length(mas_koord)-1 do
    begin
      if mas_koord[j].y=1000 then continue;

      if (mas_koord[i].x=mas_koord[j].x)and
      (mas_koord[i].y=mas_koord[j].y)and
      (mas_koord[i].z=mas_koord[j].z) then
        mas_koord[j].y:=1000;
    end;
  end;
  //perevodim v obshie koordinati
  for i:=0 to length(mas_koord)-1 do
    if mas_koord[i].y<>1000 then
    begin
      mas_koord[i].x:=mas_koord[i].x+xkoord*16;
      mas_koord[i].z:=mas_koord[i].z+ykoord*16;
    end;
  if (gen_l=true)and(tip=0)and(pop=false) then
  begin
    //sravnivaem s obshim massivom na ravenstvo
    for i:=0 to length(mas_koord)-1 do
    begin
      if mas_koord[i].y=1000 then continue;
      for j:=0 to length(pr_koord^)-1 do
        if (mas_koord[i].x=pr_koord^[j].x)and
        (mas_koord[i].y=pr_koord^[j].y)and
        (mas_koord[i].z=pr_koord^[j].z) then
        begin
          mas_koord[i].y:=1000;
          break;
        end;
    end;
    for i:=0 to length(mas_koord)-1 do
    begin
      if mas_koord[i].y=1000 then continue;
      if (random<(light_den/5000)) then
      begin
        j:=length(pr_koord^);
        setlength(pr_koord^,j+1);
        pr_koord^[j].x:=mas_koord[i].x;
        pr_koord^[j].y:=mas_koord[i].y;
        pr_koord^[j].z:=mas_koord[i].z;
        pr_koord^[j].id:=89;
      end;
    end;
  end;


  //rabota s koordinatami resursov++++++++++++++++++++++
  //udalaem povtori
  for i:=0 to length(mas_koord_res)-2 do
  begin
    if mas_koord_res[i].y=1000 then continue;
    for j:=i+1 to length(mas_koord_res)-1 do
    begin
      if mas_koord_res[j].y=1000 then continue;

      if (mas_koord_res[i].x=mas_koord_res[j].x)and
      (mas_koord_res[i].y=mas_koord_res[j].y)and
      (mas_koord_res[i].z=mas_koord_res[j].z)and
      (mas_koord_res[i].id<>82)and(mas_koord_res[j].id<>82) then
        mas_koord_res[j].y:=1000
      else
      if (mas_koord_res[i].x=mas_koord_res[j].x)and
      (mas_koord_res[i].z=mas_koord_res[j].z)and
      (mas_koord_res[i].id=82)and(mas_koord_res[j].id=82) then
        mas_koord_res[j].y:=1000;
    end;
  end;
  //perevodim v obshie koordinati
  for i:=0 to length(mas_koord_res)-1 do
    if mas_koord_res[i].y<>1000 then
    begin
      mas_koord_res[i].x:=mas_koord_res[i].x+xkoord*16;
      mas_koord_res[i].z:=mas_koord_res[i].z+ykoord*16;
    end;
  if (tip=0)and(pop=false) then
  begin
    //kopiruem v obshiy massiv
    for i:=0 to length(mas_koord_res)-1 do
    begin
      if (random<0.01)and(mas_koord_res[i].y<>1000)and(mas_koord_res[i].id<>82) then
      begin
        t:=length(pr_res^);
        setlength(pr_res^,t+1);
        pr_res^[t].x:=mas_koord_res[i].x;
        pr_res^[t].y:=mas_koord_res[i].y;
        pr_res^[t].z:=mas_koord_res[i].z;
        pr_res^[t].id:=mas_koord_res[i].id;
      end
      else if (random<0.1)and(mas_koord_res[i].y<>1000)and(mas_koord_res[i].id=82) then
      begin
        t:=length(pr_res^);
        setlength(pr_res^,t+1);
        pr_res^[t].x:=mas_koord_res[i].x;
        pr_res^[t].y:=mas_koord_res[i].y;
        pr_res^[t].z:=mas_koord_res[i].z;
        pr_res^[t].id:=mas_koord_res[i].id;
      end;
    end;
  end;

  setlength(mas_koord,0);
  setlength(mas_koord_res,0);
  r.Free;
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

function gen_flooded(var ar_tun:array of tunnels_settings; var map:region):boolean;

  function get_tun_ind(tun:tunnels_settings; ar_tun:array of tunnels_settings):integer;
  var i,ind:integer;
  begin
    ind:=0;
    for i:= 0 to length(ar_tun)-1 do
      if (ar_tun[i].x1=tun.x1)and
      (ar_tun[i].z1=tun.z1)and
      (ar_tun[i].y1=tun.y1) then
      begin
        ind:=i;
        break;
      end;
    result:=ind;
  end;

  function check_water(var map:region):boolean;
  var chx,chy,x,y,z:integer;
  b:boolean;
  begin
    b:=false;
    for chx:=0 to 16 do
      for chy:=0 to 16 do
      begin
        if b=true then break;
        for x:=0 to 15 do
          for z:=0 to 15 do
            for y:=1 to 126 do
              if (map[chx][chy].blocks[y+(z*128+(x*2048))]=8) then
              begin
                if map[chx][chy].blocks[y-1+(z*128+(x*2048))]=0 then b:=true;

                if (x=0)and(chx<>0) then
                  if map[chx-1][chy].blocks[y+(z*128+(15*2048))]=0 then b:=true;
                if x<>0 then
                  if map[chx][chy].blocks[y+(z*128+((x-1)*2048))]=0 then b:=true;

                if (x=15)and(chx<>16) then
                  if map[chx+1][chy].blocks[y+(z*128)]=0 then b:=true;
                if x<>15 then
                  if map[chx][chy].blocks[y+(z*128+((x+1)*2048))]=0 then b:=true;

                if (z=0)and(chy<>0) then
                  if map[chx][chy-1].blocks[y+(15*128+(x*2048))]=0 then b:=true;
                if z<>0 then
                  if map[chx][chy].blocks[y+((z-1)*128+(x*2048))]=0 then b:=true;

                if (z=15)and(chy<>16) then
                  if map[chx][chy+1].blocks[y+(x*2048)]=0 then b:=true;
                if z<>15 then
                  if map[chx][chy].blocks[y+((z+1)*128+(x*2048))]=0 then b:=true;
              end;
      end;
    result:=b;
  end;

  function calc_tun_flood(var ar_tun:array of tunnels_settings; napr,waterlevel,ind:integer; var map:region):integer;
  var sum,i,j,t,chx,chy,k,z,t1:integer;
  chxot,chyot:integer;
  pereh:boolean;
  temp_tun1,temp_tun2:array of tunnels_settings;
  temp_sf:ar_elipse_settings;
  t_lights:ar_tlights_koord;
  t_holes:ar_tprostr_koord;
  t_res:ar_tlights_koord;
  t_dirt:ar_elipse_settings;
  begin
    ar_tun[ind].flooded:=true;
    ar_tun[ind].waterlevel:=waterlevel;
    result:=1;
    if napr=0 then
    begin
      if ar_tun[ind].y1<ar_tun[ind].y2 then
      begin
        for i:=0 to length(ar_tun[ind].svazi_nach)-1 do
        begin
          t1:=get_tun_ind(ar_tun[ind].svazi_nach[i]^,ar_tun);
          if (ar_tun[ind].x1=ar_tun[ind].svazi_nach[i]^.x1) then
            result:=result+calc_tun_flood(ar_tun,1,waterlevel,t1,map)
          else
            result:=result+calc_tun_flood(ar_tun,0,waterlevel,t1,map);
        end;
      end
      else
      begin
        for i:=0 to length(ar_tun[ind].svazi_nach)-1 do
        begin
          t:=min(ar_tun[ind].svazi_nach[i]^.y1,ar_tun[ind].svazi_nach[i]^.y2);
          if (t-ar_tun[ind].svazi_nach[i]^.radius_vert)>waterlevel then continue;
          if (t=ar_tun[ind].y1)and((t-ar_tun[ind].svazi_nach[i]^.radius_vert)<waterlevel) then
          begin
            t1:=get_tun_ind(ar_tun[ind].svazi_nach[i]^,ar_tun);
            if (ar_tun[ind].x1=ar_tun[ind].svazi_nach[i]^.x1) then
              result:=result+calc_tun_flood(ar_tun,1,waterlevel,t1,map)
            else
              result:=result+calc_tun_flood(ar_tun,0,waterlevel,t1,map);
          end
          else
          begin    //stroim
            setlength(temp_tun1,1);
            temp_tun1[0]:=ar_tun[ind];
            setlength(temp_tun2,1);
            temp_tun2[0]:=ar_tun[ind].svazi_nach[i]^;
            setlength(temp_sf,1);
            temp_sf[0]:=ar_tun[ind].nach_sfera^;

            calc_cos_tun(temp_tun1);
            calc_cos_tun(temp_tun2);

            fill_tun_chunks(temp_tun1);
            fill_tun_chunks(temp_tun2);
            fill_el_chunks(temp_sf);

            chx:=ar_tun[ind].x1;
            chy:=ar_tun[ind].z1;
            if chx<0 then inc(chx);
            if chy<0 then inc(chy);
            chx:=chx div 16;
            chy:=chy div 16;
            if (chx<=0)and(ar_tun[ind].x1<0) then dec(chx);
            if (chy<=0)and(ar_tun[ind].z1<0) then dec(chy);
            chxot:=chx-8;
            chyot:=chy-8;

            for k:=0 to 16 do
              for z:=0 to 16 do
              begin
                fillchar(map[k][z].blocks[0],length(map[k][z].blocks),1);
                //poradok generirovaniya: vtoroy tunel, sfera, perviy tunel
                gen_tun(chxot+k,chyot+z,map[k][z].blocks,temp_tun2,@t_lights,@t_holes,@t_dirt,@t_res,true,false,false,50,50);
                gen_elipse(chxot+k,chyot+z,map[k][z].blocks,temp_sf,nil,@t_lights,@t_res,true,false,50,0);
                gen_tun(chxot+k,chyot+z,map[k][z].blocks,temp_tun1,@t_lights,@t_holes,@t_dirt,@t_res,true,false,false,50,50);

                //gen_tun(tempx-2,tempy-2,map[k][z].blocks,ar_tun,@pr_koord_lights,@pr_koord_holes,@pr_koord_dirt,@pr_koord_res,b1,par.tunnel_par^.gen_lights,par.tunnel_par^.gen_sun_holes,par.tunnel_par^.light_density,par.tunnel_par^.skyholes_density);
                //gen_elipse(tempx-2,tempy-2,map[k][z].blocks,ar_el,nil,@pr_koord_lights,@pr_koord_res,b1,par.tunnel_par^.gen_lights,par.tunnel_par^.light_density,0);
              end;

            //proveraem, est' li voda bez stenok...
            if check_water(map)=true then
            begin
              t1:=get_tun_ind(ar_tun[ind].svazi_nach[i]^,ar_tun);
              if (ar_tun[ind].x1=ar_tun[ind].svazi_nach[i]^.x1) then
                result:=result+calc_tun_flood(ar_tun,1,waterlevel,t1,map)
              else
                result:=result+calc_tun_flood(ar_tun,0,waterlevel,t1,map);
            end;
          end;
        end;
      end;
    end
    else
    begin
      if ar_tun[ind].y1>ar_tun[ind].y2 then
      begin
        for i:=0 to length(ar_tun[ind].svazi_kon)-1 do
        begin
          t1:=get_tun_ind(ar_tun[ind].svazi_kon[i]^,ar_tun);
          if (ar_tun[ind].x2=ar_tun[ind].svazi_kon[i]^.x1) then
            result:=result+calc_tun_flood(ar_tun,1,waterlevel,t1,map)
          else
            result:=result+calc_tun_flood(ar_tun,0,waterlevel,t1,map);
        end;
      end
      else
      begin
        for i:=0 to length(ar_tun[ind].svazi_kon)-1 do
        begin
          t:=min(ar_tun[ind].svazi_kon[i]^.y1,ar_tun[ind].svazi_kon[i]^.y2);
          if (t-ar_tun[ind].svazi_kon[i]^.radius_vert)>waterlevel then continue;
          if (t=ar_tun[ind].y2)and((t-ar_tun[ind].svazi_kon[i]^.radius_vert)<waterlevel) then
          begin
            t1:=get_tun_ind(ar_tun[ind].svazi_kon[i]^,ar_tun);
            if (ar_tun[ind].x1=ar_tun[ind].svazi_kon[i]^.x1) then
              result:=result+calc_tun_flood(ar_tun,1,waterlevel,t1,map)
            else
              result:=result+calc_tun_flood(ar_tun,0,waterlevel,t1,map);
          end
          else
          begin    //stroim
            setlength(temp_tun1,1);
            temp_tun1[0]:=ar_tun[ind];
            setlength(temp_tun2,1);
            temp_tun2[0]:=ar_tun[ind].svazi_kon[i]^;
            setlength(temp_sf,1);
            temp_sf[0]:=ar_tun[ind].kon_sfera^;

            calc_cos_tun(temp_tun1);
            calc_cos_tun(temp_tun2);

            fill_tun_chunks(temp_tun1);
            fill_tun_chunks(temp_tun2);
            fill_el_chunks(temp_sf);

            chx:=ar_tun[ind].x1;
            chy:=ar_tun[ind].z1;
            if chx<0 then inc(chx);
            if chy<0 then inc(chy);
            chx:=chx div 16;
            chy:=chy div 16;
            if (chx<=0)and(ar_tun[ind].x1<0) then dec(chx);
            if (chy<=0)and(ar_tun[ind].z1<0) then dec(chy);
            chxot:=chx-8;
            chyot:=chy-8;

            for k:=0 to 16 do
              for z:=0 to 16 do
              begin
                fillchar(map[k][z].blocks[0],length(map[k][z].blocks),1);
                //poradok generirovaniya: vtoroy tunel, sfera, perviy tunel
                gen_tun(chxot+k,chyot+z,map[k][z].blocks,temp_tun2,@t_lights,@t_holes,@t_dirt,@t_res,true,false,false,50,50);
                gen_elipse(chxot+k,chyot+z,map[k][z].blocks,temp_sf,nil,@t_lights,@t_res,true,false,50,0);
                gen_tun(chxot+k,chyot+z,map[k][z].blocks,temp_tun1,@t_lights,@t_holes,@t_dirt,@t_res,true,false,false,50,50);

                //gen_tun(tempx-2,tempy-2,map[k][z].blocks,ar_tun,@pr_koord_lights,@pr_koord_holes,@pr_koord_dirt,@pr_koord_res,b1,par.tunnel_par^.gen_lights,par.tunnel_par^.gen_sun_holes,par.tunnel_par^.light_density,par.tunnel_par^.skyholes_density);
                //gen_elipse(tempx-2,tempy-2,map[k][z].blocks,ar_el,nil,@pr_koord_lights,@pr_koord_res,b1,par.tunnel_par^.gen_lights,par.tunnel_par^.light_density,0);
              end;

            //proveraem, est' li voda bez stenok...
            if check_water(map)=true then
            begin
              t1:=get_tun_ind(ar_tun[ind].svazi_kon[i]^,ar_tun);
              if (ar_tun[ind].x1=ar_tun[ind].svazi_kon[i]^.x1) then
                result:=result+calc_tun_flood(ar_tun,1,waterlevel,t1,map)
              else
                result:=result+calc_tun_flood(ar_tun,0,waterlevel,t1,map);
            end;
          end;
        end;
      end;
    end;

    setlength(temp_tun1,0);
    setlength(temp_tun2,0);
    setlength(temp_sf,0);
    result:=sum;
  end;

var i,j,level:integer;
//point:ptunnels_settings;
begin
  for i:=0 to length(ar_tun)-1 do
  begin
    if ar_tun[i].flooded=true then continue;
    j:=max(ar_tun[i].y1,ar_tun[i].y2)-min(ar_tun[i].y1,ar_tun[i].y2)-ar_tun[i].radius_vert*2;
    if j<5 then continue;
    level:=min(ar_tun[i].y1,ar_tun[i].y2)+ar_tun[i].radius_vert+random(j);
    if level>60 then continue;
    if ar_tun[i].y1<ar_tun[i].y2 then
      calc_tun_flood(ar_tun,0,level,i,map)
    else
      calc_tun_flood(ar_tun,1,level,i,map);
    break;
  end;
end;

procedure gen_cwall_border_towers(xkoord,ykoord,width,len:integer; par_border:border_settings_type; var blocks,data:ar_type; entities:par_entity_type; tileentities:par_tile_entity_type);
var i,j,k:integer;
tempx,tempy,tempk,tempz:integer;
kolx,kolz:integer;
tekchotx,tekchdox,tekchoty,tekchdoy:integer;
tekint,tekintotn:integer;
shagx,shagz,tekush:double;
b:boolean;
begin
  if par_border.cwall_gen_void=true then
  begin
    tempx:=-(width div 2)+par_border.cwall_void_width;
    tempy:=-(len div 2)+par_border.cwall_void_width;
    tempk:=(width div 2)-1-par_border.cwall_void_width;
    tempz:=(len div 2)-1-par_border.cwall_void_width;
  end
  else
  begin
    tempx:=-(width div 2);
    tempy:=-(len div 2);
    tempk:=(width div 2)-1;
    tempz:=(len div 2)-1;
  end;

  //esli uglovoy chank, to vihod
  if ((xkoord=tempx)and(ykoord=tempy))or
  ((xkoord=tempx)and(ykoord=tempz))or
  ((xkoord=tempk)and(ykoord=tempy))or
  ((xkoord=tempk)and(ykoord=tempz)) then
    exit;

  //schitaem kol-vo bashen na kazhdoy iz storon karti
  kolx:=((tempk-tempx+1) div 10)-1;
  kolz:=((tempz-tempy+1) div 10)-1;

  //vichislaem shag v blokah ot kazhdoy bashni do sleduyushey
  shagx:=(tempk-tempx-1)*16;
  shagz:=(tempz-tempy-1)*16;
  shagx:=shagx/(kolx+1);
  shagz:=shagz/(kolz+1);

  //vishiclaem kraynie bloki tekushego chanka
  tekchotx:=xkoord*16;
  tekchoty:=ykoord*16;
  tekchdox:=tekchotx+15;
  tekchdoy:=tekchoty+15;

  if (xkoord=tempx)or(xkoord=tempk) then   //esli levaya ili pravaya stenka
  begin
    tekush:=(tempy+1)*16+shagz;
    while tekush<((tempz-1)*16) do
    begin  
      tekint:=round(tekush);
      if ((tekint-9)<tekchdoy)or((tekint+8)>tekchoty) then
      begin
        //vichislaem otnositelnie koordinati centra
        tekintotn:=tekint-tekchoty;
        if (par_border.cwall_gen_interior=true)and(par_border.cwall_gen_boinici=true) then
        begin
        //smotrim, est' li boinici radom
        b:=false;
        for j:=tekintotn-8 to tekintotn+7 do //Z
        begin
          if (j<0)or(j>15)or(b=true)or((j<>(tekintotn-8))and(j<>(tekintotn+7))) then continue;
          for k:=91 to 99 do  //Y
            if blocks[k+(j*128+(3*2048))]<>4 then
            begin
              b:=true;
              break;
            end;
        end;
        //esli est', to ochishaem ih
        if b=true then
        for j:=0 to 15 do   //Z
          for k:=91 to 99 do
          begin
            blocks[k+(j*128+(3*2048))]:=4;
            blocks[k+(j*128+(12*2048))]:=4;
            blocks[k+(j*128+(4*2048))]:=0;
            blocks[k+(j*128+(11*2048))]:=0;
            data[k+(j*128+(4*2048))]:=0;
            data[k+(j*128+(11*2048))]:=0;
          end;
        end;
        //otrisovivaem bashnu
        for j:=tekintotn-7 to tekintotn+6 do //Z
        begin
          if (j<0)or(j>15) then continue;
          for k:=1 to 110 do  //Y
            for i:=1 to 14 do  //X
              blocks[k+(j*128+(i*2048))]:=4;
        end;
        //virezaem komnatu
        for j:=tekintotn-6 to tekintotn+5 do //Z
        begin
          if (j<0)or(j>15) then continue;
          for k:=101 to 109 do  //Y
            for i:=2 to 13 do  //X
              blocks[k+(j*128+(i*2048))]:=0;
        end;
        //virezaem komnatu na 0 etazhe
        if par_border.cwall_gen_interior=true then
        for j:=tekintotn-6 to tekintotn+5 do //Z
        begin
          if (j<0)or(j>15) then continue;
          for k:=91 to 99 do  //Y
            for i:=2 to 13 do  //X
              blocks[k+(j*128+(i*2048))]:=0;
        end;
        //virezaem arki-prohodi
        for j:=tekintotn-7 to tekintotn+6 do //Z
        begin
          if (j<0)or(j>15)or((j<>(tekintotn-7))and(j<>(tekintotn+6))) then continue;
          for k:=101 to 104 do  //Y   //na 1 etazhe
            for i:=6 to 9 do  //X
              blocks[k+(j*128+(i*2048))]:=0;
          if par_border.cwall_gen_interior=true then
          for k:=91 to 94 do  //Y     //na 0 etazhe
            for i:=6 to 9 do  //X
              blocks[k+(j*128+(i*2048))]:=0;
        end;
        //delaem fakeli vnutri komnati na 1 etazhe i vnutri i snaruzhi komnati na 0 etazhe
        for j:=tekintotn-8 to tekintotn+7 do //Z
        begin
          if (j<0)or(j>15) then continue;
          if par_border.cwall_gen_interior=true then
          begin
          if (j=tekintotn-8) then
          begin
            blocks[92+(j*128+(5*2048))]:=50;
            blocks[92+(j*128+(10*2048))]:=50;
            data[92+(j*128+(5*2048))]:=4;
            data[92+(j*128+(10*2048))]:=4;
          end;
          if (j=tekintotn+7) then
          begin
            blocks[92+(j*128+(5*2048))]:=50;
            blocks[92+(j*128+(10*2048))]:=50;
            data[92+(j*128+(5*2048))]:=3;
            data[92+(j*128+(10*2048))]:=3;
          end;
          end;
          if (j=tekintotn-6) then
          begin
            if par_border.cwall_gen_interior=true then
            begin
            blocks[92+(j*128+(5*2048))]:=50;
            blocks[92+(j*128+(10*2048))]:=50;
            data[92+(j*128+(5*2048))]:=3;
            data[92+(j*128+(10*2048))]:=3;
            end;
            blocks[102+(j*128+(5*2048))]:=50;
            blocks[102+(j*128+(10*2048))]:=50;
            data[102+(j*128+(5*2048))]:=3;
            data[102+(j*128+(10*2048))]:=3;
          end;
          if (j=tekintotn+5) then
          begin
            if par_border.cwall_gen_interior=true then
            begin
            blocks[92+(j*128+(5*2048))]:=50;
            blocks[92+(j*128+(10*2048))]:=50;
            data[92+(j*128+(5*2048))]:=4;
            data[92+(j*128+(10*2048))]:=4;
            end;
            blocks[102+(j*128+(5*2048))]:=50;
            blocks[102+(j*128+(10*2048))]:=50;
            data[102+(j*128+(5*2048))]:=4;
            data[102+(j*128+(10*2048))]:=4;
          end;
        end;
        //delaem relsi naskvoz' bashni
        if par_border.cwall_gen_rails=true then
        begin
        for j:=tekintotn-8 to tekintotn+7 do //Z
        begin
          if (j<0)or(j>15) then continue;
          if (j=tekintotn-8)or(j=tekintotn+7) then
          begin
            blocks[101+(j*128+(7*2048))]:=66;
            blocks[101+(j*128+(8*2048))]:=66;
            data[101+(j*128+(7*2048))]:=6;
            data[101+(j*128+(8*2048))]:=8;
          end
          else if (j=tekintotn) then
          begin
            blocks[101+(j*128+(7*2048))]:=66;
            blocks[101+(j*128+(8*2048))]:=66;
            data[101+(j*128+(7*2048))]:=9;
            data[101+(j*128+(8*2048))]:=7;
          end
          else if (j>tekintotn-8)and(j<tekintotn) then
          begin
            blocks[101+(j*128+(7*2048))]:=27;
            data[101+(j*128+(7*2048))]:=8;
            if (j=tekintotn-4) then
            begin
              blocks[101+(j*128+(6*2048))]:=76;
              data[101+(j*128+(6*2048))]:=5;
              blocks[101+(j*128+(9*2048))]:=76;
              data[101+(j*128+(9*2048))]:=5;
            end;
          end
          else if (j>tekintotn)and(j<tekintotn+7) then
          begin
            blocks[101+(j*128+(8*2048))]:=27;
            data[101+(j*128+(8*2048))]:=8;
            if (j=tekintotn+3) then
            begin
              blocks[101+(j*128+(6*2048))]:=76;
              data[101+(j*128+(6*2048))]:=5;
              blocks[101+(j*128+(9*2048))]:=76;
              data[101+(j*128+(9*2048))]:=5;
            end;
          end;
        end;
        //delaem busteri
        for j:=tekintotn-7 to tekintotn+6 do //Z
        begin
          if (j<0)or(j>15) then continue;
          if (j>=tekintotn-7)and(j<=tekintotn-2) then
          begin
            blocks[101+(j*128+(8*2048))]:=27;
            data[101+(j*128+(8*2048))]:=8;
          end
          else if (j>=tekintotn+2)and(j<=tekintotn+6) then
          begin
            blocks[101+(j*128+(7*2048))]:=27;
            data[101+(j*128+(7*2048))]:=8;
          end
          else if (j=tekintotn-1) then
          begin
            for i:=9 to 11 do
            begin
              blocks[101+(j*128+(i*2048))]:=27;
              data[101+(j*128+(i*2048))]:=1;
            end;
            blocks[101+(j*128+(12*2048))]:=27;
            data[101+(j*128+(12*2048))]:=2;
            blocks[101+(j*128+(13*2048))]:=4;
            blocks[102+(j*128+(13*2048))]:=4;
            blocks[101+(j*128+(8*2048))]:=66;
            data[101+(j*128+(8*2048))]:=9;
          end
          else if (j=tekintotn) then
          begin
            blocks[101+(j*128+(9*2048))]:=4;
            blocks[101+(j*128+(6*2048))]:=4;
            blocks[102+(j*128+(9*2048))]:=50;
            blocks[102+(j*128+(6*2048))]:=50;
            data[102+(j*128+(9*2048))]:=5;
            data[102+(j*128+(6*2048))]:=5;
            blocks[101+(j*128+(10*2048))]:=77;
            data[101+(j*128+(10*2048))]:=1;
            blocks[101+(j*128+(5*2048))]:=77;
            data[101+(j*128+(5*2048))]:=2;
          end
          else if (j=tekintotn+1) then
          begin
            for i:=4 to 6 do
            begin
              blocks[101+(j*128+(i*2048))]:=27;
              data[101+(j*128+(i*2048))]:=1;
            end;
            blocks[101+(j*128+(3*2048))]:=27;
            data[101+(j*128+(3*2048))]:=3;
            blocks[101+(j*128+(2*2048))]:=4;
            blocks[102+(j*128+(2*2048))]:=4;
            blocks[101+(j*128+(7*2048))]:=66;
            data[101+(j*128+(7*2048))]:=7;
          end;
          //delaem sunduki
          if (tileentities<>nil)and((j=tekintotn-6)or(j=tekintotn+5)) then
          begin
            i:=length(tileentities^);
            setlength(tileentities^,i+1);
            tileentities^[i].id:='Chest';
            if (j=tekintotn-6) then
            begin
              tileentities^[i].x:=xkoord*16+2;
              tileentities^[i].y:=101;
              tileentities^[i].z:=ykoord*16+j;
              blocks[101+(j*128+(2*2048))]:=54;
            end
            else if (j=tekintotn+5) then
            begin
              tileentities^[i].x:=xkoord*16+13;
              tileentities^[i].y:=101;
              tileentities^[i].z:=ykoord*16+j;
              blocks[101+(j*128+(13*2048))]:=54;
            end;
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
        end;
        //delaem lestnicu ot 1 etazha na krishu
        for j:=tekintotn-6 to tekintotn+5 do //Z
        begin
          if (j<0)or(j>15) then continue;
          if (j=tekintotn-6) then
            for k:=101 to 110 do
            begin
              blocks[k+(j*128+(13*2048))]:=65;
              data[k+(j*128+(13*2048))]:=3;
            end;
          if (j=tekintotn+5) then
            for k:=101 to 110 do
            begin
              blocks[k+(j*128+(2*2048))]:=65;
              data[k+(j*128+(2*2048))]:=2;
            end;
        end;
        //delaem lestnicu ot 0 etazha na 1 etazh
        if par_border.cwall_gen_interior=true then
        begin
        for j:=tekintotn-6 to tekintotn+5 do //Z
        begin
          if (j<0)or(j>15) then continue;
          if (j=tekintotn-6) then
            for k:=91 to 100 do
            begin
              blocks[k+(j*128+(13*2048))]:=65;
              data[k+(j*128+(13*2048))]:=3;
            end;
          if (j=tekintotn+5) then
            for k:=91 to 100 do
            begin
              blocks[k+(j*128+(2*2048))]:=65;
              data[k+(j*128+(2*2048))]:=2;
            end;
        end;
        //delaem boinici
        if par_border.cwall_gen_boinici=true then
        for j:=tekintotn-2 to tekintotn+2 do //Z
        begin
          if (j<0)or(j>15) then continue;
          case par_border.cwall_boinici_type of
          0:begin  //line
              if (j=tekintotn-1)or(j=tekintotn+1) then
              begin
                for k:=2 to 5 do
                begin
                  blocks[(90+k)+(j*128+(1*2048))]:=43;
                  blocks[(90+k)+(j*128+(14*2048))]:=43;
                  blocks[(101+k)+(j*128+(1*2048))]:=43;
                  blocks[(101+k)+(j*128+(14*2048))]:=43;
                end;
              end
              else if j=tekintotn then
              begin
                blocks[91+(j*128+(1*2048))]:=43;
                blocks[92+(j*128+(1*2048))]:=44;
                blocks[93+(j*128+(1*2048))]:=0;
                blocks[94+(j*128+(1*2048))]:=0;
                blocks[95+(j*128+(1*2048))]:=0;
                blocks[96+(j*128+(1*2048))]:=43;
                blocks[91+(j*128+(14*2048))]:=43;
                blocks[92+(j*128+(14*2048))]:=44;
                blocks[93+(j*128+(14*2048))]:=0;
                blocks[94+(j*128+(14*2048))]:=0;
                blocks[95+(j*128+(14*2048))]:=0;
                blocks[96+(j*128+(14*2048))]:=43;
                blocks[102+(j*128+(1*2048))]:=43;
                blocks[103+(j*128+(1*2048))]:=44;
                blocks[104+(j*128+(1*2048))]:=0;
                blocks[105+(j*128+(1*2048))]:=0;
                blocks[106+(j*128+(1*2048))]:=0;
                blocks[107+(j*128+(1*2048))]:=43;
                blocks[102+(j*128+(14*2048))]:=43;
                blocks[103+(j*128+(14*2048))]:=44;
                blocks[104+(j*128+(14*2048))]:=0;
                blocks[105+(j*128+(14*2048))]:=0;
                blocks[106+(j*128+(14*2048))]:=0;
                blocks[107+(j*128+(14*2048))]:=43;
              end;
            end;
          1:begin  //cross
              if (j=tekintotn-2)or(j=tekintotn+2) then
              begin
                blocks[94+(j*128+(1*2048))]:=43;
                blocks[94+(j*128+(14*2048))]:=43;
                blocks[105+(j*128+(1*2048))]:=43;
                blocks[105+(j*128+(14*2048))]:=43;
              end
              else if (j=tekintotn-1)or(j=tekintotn+1) then
              begin
                blocks[92+(j*128+(1*2048))]:=43;
                blocks[93+(j*128+(1*2048))]:=43;
                blocks[94+(j*128+(1*2048))]:=44;
                blocks[95+(j*128+(1*2048))]:=43;
                blocks[92+(j*128+(14*2048))]:=43;
                blocks[93+(j*128+(14*2048))]:=43;
                blocks[94+(j*128+(14*2048))]:=44;
                blocks[95+(j*128+(14*2048))]:=43;
                blocks[103+(j*128+(1*2048))]:=43;
                blocks[104+(j*128+(1*2048))]:=43;
                blocks[105+(j*128+(1*2048))]:=44;
                blocks[106+(j*128+(1*2048))]:=43;
                blocks[103+(j*128+(14*2048))]:=43;
                blocks[104+(j*128+(14*2048))]:=43;
                blocks[105+(j*128+(14*2048))]:=44;
                blocks[106+(j*128+(14*2048))]:=43;
              end
              else if j=tekintotn then
              begin
                blocks[91+(j*128+(1*2048))]:=43;
                blocks[92+(j*128+(1*2048))]:=44;
                blocks[93+(j*128+(1*2048))]:=0;
                blocks[94+(j*128+(1*2048))]:=0;
                blocks[95+(j*128+(1*2048))]:=0;
                blocks[96+(j*128+(1*2048))]:=43;
                blocks[91+(j*128+(14*2048))]:=43;
                blocks[92+(j*128+(14*2048))]:=44;
                blocks[93+(j*128+(14*2048))]:=0;
                blocks[94+(j*128+(14*2048))]:=0;
                blocks[95+(j*128+(14*2048))]:=0;
                blocks[96+(j*128+(14*2048))]:=43;
                blocks[102+(j*128+(1*2048))]:=43;
                blocks[103+(j*128+(1*2048))]:=44;
                blocks[104+(j*128+(1*2048))]:=0;
                blocks[105+(j*128+(1*2048))]:=0;
                blocks[106+(j*128+(1*2048))]:=0;
                blocks[107+(j*128+(1*2048))]:=43;
                blocks[102+(j*128+(14*2048))]:=43;
                blocks[103+(j*128+(14*2048))]:=44;
                blocks[104+(j*128+(14*2048))]:=0;
                blocks[105+(j*128+(14*2048))]:=0;
                blocks[106+(j*128+(14*2048))]:=0;
                blocks[107+(j*128+(14*2048))]:=43;
              end;
            end;
          2:begin  //square
              if (j=tekintotn-2)or(j=tekintotn+1) then
              begin
                blocks[93+(j*128+(1*2048))]:=43;
                blocks[93+(j*128+(14*2048))]:=43;
                blocks[94+(j*128+(1*2048))]:=43;
                blocks[94+(j*128+(14*2048))]:=43;
                blocks[103+(j*128+(1*2048))]:=43;
                blocks[103+(j*128+(14*2048))]:=43;
                blocks[104+(j*128+(1*2048))]:=43;
                blocks[104+(j*128+(14*2048))]:=43;
              end
              else if (j=tekintotn-1)or(j=tekintotn) then
              begin
                blocks[92+(j*128+(1*2048))]:=43;
                blocks[95+(j*128+(1*2048))]:=43;
                blocks[93+(j*128+(1*2048))]:=44;
                blocks[94+(j*128+(1*2048))]:=0;
                blocks[92+(j*128+(14*2048))]:=43;
                blocks[95+(j*128+(14*2048))]:=43;
                blocks[93+(j*128+(14*2048))]:=44;
                blocks[94+(j*128+(14*2048))]:=0;
                blocks[102+(j*128+(1*2048))]:=43;
                blocks[105+(j*128+(1*2048))]:=43;
                blocks[103+(j*128+(1*2048))]:=44;
                blocks[104+(j*128+(1*2048))]:=0;
                blocks[102+(j*128+(14*2048))]:=43;
                blocks[105+(j*128+(14*2048))]:=43;
                blocks[103+(j*128+(14*2048))]:=44;
                blocks[104+(j*128+(14*2048))]:=0;
              end;
            end;
          end;
        end;
        end;
        //delaem fakeli na boinicah s vnutrenney storoni
        for j:=tekintotn-2 to tekintotn+2 do //Z
        begin
          if (j<0)or(j>15) then continue;
          for k:=91 to 107 do
          begin
            if blocks[k+(j*128+(2048))]=43 then
            begin
              blocks[k+(j*128+(2*2048))]:=50;
              data[k+(j*128+(2*2048))]:=1;
            end;
            if blocks[k+(j*128+(14*2048))]=43 then
            begin
              blocks[k+(j*128+(13*2048))]:=50;
              data[k+(j*128+(13*2048))]:=2;
            end;
          end;
        end;
        //delaem rasshirenie naverhu bashni dla chastokola + chastokol
        for j:=tekintotn-8 to tekintotn+7 do //Z
        begin
          if (j<0)or(j>15) then continue;
          for k:=109 to 110 do  //Y
            for i:=0 to 15 do  //X
            begin
              if (j<>(tekintotn-8))and(j<>(tekintotn+7))and(i<>0)and(i<>15) then continue;
              blocks[k+(j*128+(i*2048))]:=4;     //rasshirenie
              if k=110 then         //chastokol + fakeli
              begin
                if (j=(tekintotn-8))or(j=(tekintotn+7)) then
                  if ((i and 1)=1) then
                  begin
                    blocks[k+1+(j*128+(i*2048))]:=4;
                    blocks[k+2+(j*128+(i*2048))]:=50;
                    data[k+2+(j*128+(i*2048))]:=5;
                  end
                  else
                  begin
                    blocks[k+1+(j*128+(i*2048))]:=44;
                    data[k+1+(j*128+(i*2048))]:=3;
                  end;

                if (i=0)or(i=15) then
                  if ((j and 1)=1)then
                  begin
                    blocks[k+1+(j*128+(i*2048))]:=4;
                    blocks[k+2+(j*128+(i*2048))]:=50;
                    data[k+2+(j*128+(i*2048))]:=5;
                  end
                  else
                  begin
                    blocks[k+1+(j*128+(i*2048))]:=44;
                    data[k+1+(j*128+(i*2048))]:=3;
                  end;

                //otdelno ugli
                if ((i=0)and(j=(tekintotn-8)))or
                ((i=0)and(j=(tekintotn+7)))or
                ((i=15)and(j=(tekintotn-8)))or
                ((i=15)and(j=(tekintotn+7))) then
                begin
                  blocks[k+1+(j*128+(i*2048))]:=4;
                  blocks[k+2+(j*128+(i*2048))]:=50;
                  data[k+2+(j*128+(i*2048))]:=5;
                end;
              end;
            end;
        end;
      end;
      tekush:=tekush+shagz;
    end;
  end;

  if (ykoord=tempy)or(ykoord=tempz) then   //esli verhnaya ili nizhnaya stena
  begin
    tekush:=(tempx+1)*16+shagx;
    while tekush<((tempk-1)*16) do
    begin
      tekint:=round(tekush);
      if ((tekint-9)<tekchdox)or((tekint+8)>tekchotx) then
      begin
        //vichislaem otnositelnie koordinati centra
        tekintotn:=tekint-tekchotx;
        //smotrim, est' li boinici radom
        if (par_border.cwall_gen_interior=true)and(par_border.cwall_gen_boinici=true) then
        begin
        b:=false;
        for j:=tekintotn-8 to tekintotn+7 do //X
        begin
          if (j<0)or(j>15)or(b=true)or((j<>(tekintotn-8))and(j<>(tekintotn+7))) then continue;
          for k:=91 to 99 do  //Y
            if blocks[k+(3*128+(j*2048))]<>4 then
            begin
              b:=true;
              break;
            end;
        end;
        //esli est', to ochishaem ih
        if b=true then
        for j:=0 to 15 do   //X
          for k:=91 to 99 do
          begin
            blocks[k+(3*128+(j*2048))]:=4;
            blocks[k+(12*128+(j*2048))]:=4;
            blocks[k+(4*128+(j*2048))]:=0;
            blocks[k+(11*128+(j*2048))]:=0;
            data[k+(4*128+(j*2048))]:=0;
            data[k+(11*128+(j*2048))]:=0;
          end;
        end;
        //otrisovivaem bashnu
        for j:=tekintotn-7 to tekintotn+6 do //X
        begin
          if (j<0)or(j>15) then continue;
          for k:=1 to 110 do  //Y
            for i:=1 to 14 do  //Z
              blocks[k+(i*128+(j*2048))]:=4;
        end;
        //virezaem komnatu
        for j:=tekintotn-6 to tekintotn+5 do //X
        begin
          if (j<0)or(j>15) then continue;
          for k:=101 to 109 do  //Y
            for i:=2 to 13 do  //Z
              blocks[k+(i*128+(j*2048))]:=0;
        end;
        //virezaem komnatu na 0 etazhe
        if par_border.cwall_gen_interior=true then
        for j:=tekintotn-6 to tekintotn+5 do //X
        begin
          if (j<0)or(j>15) then continue;
          for k:=91 to 99 do  //Y
            for i:=2 to 13 do  //X
              blocks[k+(i*128+(j*2048))]:=0;
        end;
        //virezaem arki-prohodi
        for j:=tekintotn-7 to tekintotn+6 do //X
        begin
          if (j<0)or(j>15)or((j<>(tekintotn-7))and(j<>(tekintotn+6))) then continue;
          for k:=101 to 104 do  //Y   //na 1 etazhe
            for i:=6 to 9 do  //Z
              blocks[k+(i*128+(j*2048))]:=0;
          if par_border.cwall_gen_interior=true then
          for k:=91 to 94 do  //Y     //na 0 etazhe
            for i:=6 to 9 do  //X
              blocks[k+(i*128+(j*2048))]:=0;
        end;
        //delaem fakeli vnutri komnati na 1 etazhe i vnutri i snaruzhi komnati na 0 etazhe
        for j:=tekintotn-8 to tekintotn+7 do //X
        begin
          if (j<0)or(j>15) then continue;
          if par_border.cwall_gen_interior=true then
          begin
          if (j=tekintotn-8) then
          begin
            blocks[92+(5*128+(j*2048))]:=50;
            blocks[92+(10*128+(j*2048))]:=50;
            data[92+(5*128+(j*2048))]:=2;
            data[92+(10*128+(j*2048))]:=2;
          end;
          if (j=tekintotn+7) then
          begin
            blocks[92+(5*128+(j*2048))]:=50;
            blocks[92+(10*128+(j*2048))]:=50;
            data[92+(5*128+(j*2048))]:=1;
            data[92+(10*128+(j*2048))]:=1;
          end;
          end;
          if (j=tekintotn-6) then
          begin
            if par_border.cwall_gen_interior=true then
            begin
            blocks[92+(5*128+(j*2048))]:=50;
            blocks[92+(10*128+(j*2048))]:=50;
            data[92+(5*128+(j*2048))]:=1;
            data[92+(10*128+(j*2048))]:=1;
            end;
            blocks[102+(5*128+(j*2048))]:=50;
            blocks[102+(10*128+(j*2048))]:=50;
            data[102+(5*128+(j*2048))]:=1;
            data[102+(10*128+(j*2048))]:=1;
          end;
          if (j=tekintotn+5) then
          begin
            if par_border.cwall_gen_interior=true then
            begin
            blocks[92+(5*128+(j*2048))]:=50;
            blocks[92+(10*128+(j*2048))]:=50;
            data[92+(5*128+(j*2048))]:=2;
            data[92+(10*128+(j*2048))]:=2;
            end;
            blocks[102+(5*128+(j*2048))]:=50;
            blocks[102+(10*128+(j*2048))]:=50;
            data[102+(5*128+(j*2048))]:=2;
            data[102+(10*128+(j*2048))]:=2;
          end;
        end;
        //delaem relsi naskvoz' bashni
        if par_border.cwall_gen_rails=true then
        begin
        for j:=tekintotn-8 to tekintotn+7 do //Z
        begin
          if (j<0)or(j>15) then continue;
          if (j=tekintotn-8)or(j=tekintotn+7) then
          begin
            blocks[101+(7*128+(j*2048))]:=66;
            blocks[101+(8*128+(j*2048))]:=66;
            data[101+(7*128+(j*2048))]:=7;
            data[101+(8*128+(j*2048))]:=9;
          end
          else if (j=tekintotn) then
          begin
            blocks[101+(7*128+(j*2048))]:=66;
            blocks[101+(8*128+(j*2048))]:=66;
            data[101+(7*128+(j*2048))]:=6;
            data[101+(8*128+(j*2048))]:=8;
          end
          else if (j>tekintotn-8)and(j<tekintotn) then
          begin
            blocks[101+(8*128+(j*2048))]:=27;
            data[101+(8*128+(j*2048))]:=9;
            if (j=tekintotn-4) then
            begin
              blocks[101+(6*128+(j*2048))]:=76;
              data[101+(6*128+(j*2048))]:=5;
              blocks[101+(9*128+(j*2048))]:=76;
              data[101+(9*128+(j*2048))]:=5;
            end;
          end
          else if (j>tekintotn)and(j<tekintotn+7) then
          begin
            blocks[101+(7*128+(j*2048))]:=27;
            data[101+(7*128+(j*2048))]:=9;
            if (j=tekintotn+3) then
            begin
              blocks[101+(6*128+(j*2048))]:=76;
              data[101+(6*128+(j*2048))]:=5;
              blocks[101+(9*128+(j*2048))]:=76;
              data[101+(9*128+(j*2048))]:=5;
            end;
          end;
        end;
        //delaem busteri
        for j:=tekintotn-7 to tekintotn+6 do //Z
        begin
          if (j<0)or(j>15) then continue;
          if (j>=tekintotn-7)and(j<=tekintotn-2) then
          begin
            blocks[101+(7*128+(j*2048))]:=27;
            data[101+(7*128+(j*2048))]:=9;
          end
          else if (j>=tekintotn+2)and(j<=tekintotn+6) then
          begin
            blocks[101+(8*128+(j*2048))]:=27;
            data[101+(8*128+(j*2048))]:=9;
          end
          else if (j=tekintotn-1) then
          begin
            for i:=4 to 6 do
            begin
              blocks[101+(i*128+(j*2048))]:=27;
              data[101+(i*128+(j*2048))]:=0;
            end;
            blocks[101+(3*128+(j*2048))]:=27;
            data[101+(3*128+(j*2048))]:=4;
            blocks[101+(2*128+(j*2048))]:=4;
            blocks[102+(2*128+(j*2048))]:=4;
            blocks[101+(7*128+(j*2048))]:=66;
            data[101+(7*128+(j*2048))]:=8;
          end
          else if (j=tekintotn) then
          begin
            blocks[101+(9*128+(j*2048))]:=4;
            blocks[101+(6*128+(j*2048))]:=4;
            blocks[102+(9*128+(j*2048))]:=50;
            blocks[102+(6*128+(j*2048))]:=50;
            data[102+(9*128+(j*2048))]:=5;
            data[102+(6*128+(j*2048))]:=5;
            blocks[101+(10*128+(j*2048))]:=77;
            data[101+(10*128+(j*2048))]:=3;
            blocks[101+(5*128+(j*2048))]:=77;
            data[101+(5*128+(j*2048))]:=4;
          end
          else if (j=tekintotn+1) then
          begin
            for i:=9 to 11 do
            begin
              blocks[101+(i*128+(j*2048))]:=27;
              data[101+(i*128+(j*2048))]:=0;
            end;
            blocks[101+(12*128+(j*2048))]:=27;
            data[101+(12*128+(j*2048))]:=5;
            blocks[101+(13*128+(j*2048))]:=4;
            blocks[102+(13*128+(j*2048))]:=4;
            blocks[101+(8*128+(j*2048))]:=66;
            data[101+(8*128+(j*2048))]:=6;
          end;
          //delaem sunduki
          if (tileentities<>nil)and((j=tekintotn-6)or(j=tekintotn+5)) then
          begin
            i:=length(tileentities^);
            setlength(tileentities^,i+1);
            tileentities^[i].id:='Chest';
            if (j=tekintotn-6) then
            begin
              tileentities^[i].x:=xkoord*16+j;
              tileentities^[i].y:=101;
              tileentities^[i].z:=ykoord*16+2;
              blocks[101+(2*128+(j*2048))]:=54;
            end
            else if (j=tekintotn+5) then
            begin
              tileentities^[i].x:=xkoord*16+j;
              tileentities^[i].y:=101;
              tileentities^[i].z:=ykoord*16+13;
              blocks[101+(13*128+(j*2048))]:=54;
            end;
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
        end;
        //delaem lestnicu ot 1 etazha na krishu
        for j:=tekintotn-6 to tekintotn+5 do //Z
        begin
          if (j<0)or(j>15) then continue;
          if (j=tekintotn-6) then
            for k:=101 to 110 do
            begin
              blocks[k+(13*128+(j*2048))]:=65;
              data[k+(13*128+(j*2048))]:=5;
            end;
          if (j=tekintotn+5) then
            for k:=101 to 110 do
            begin
              blocks[k+(2*128+(j*2048))]:=65;
              data[k+(2*128+(j*2048))]:=4;
            end;
        end;
        if par_border.cwall_gen_interior=true then
        begin
        //delaem lestnicu ot 0 etazha na 1 etazh
        for j:=tekintotn-6 to tekintotn+5 do //Z
        begin
          if (j<0)or(j>15) then continue;
          if (j=tekintotn-6) then
            for k:=91 to 100 do
            begin
              blocks[k+(13*128+(j*2048))]:=65;
              data[k+(13*128+(j*2048))]:=5;
            end;
          if (j=tekintotn+5) then
            for k:=91 to 100 do
            begin
              blocks[k+(2*128+(j*2048))]:=65;
              data[k+(2*128+(j*2048))]:=4;
            end;
        end;
        //delaem boinici
        if par_border.cwall_gen_boinici=true then
        for j:=tekintotn-2 to tekintotn+2 do //Z
        begin
          if (j<0)or(j>15) then continue;
          case par_border.cwall_boinici_type of
          0:begin  //line
              if (j=tekintotn-1)or(j=tekintotn+1) then
              begin
                for k:=2 to 5 do
                begin
                  blocks[(90+k)+(1*128+(j*2048))]:=43;
                  blocks[(90+k)+(14*128+(j*2048))]:=43;
                  blocks[(101+k)+(1*128+(j*2048))]:=43;
                  blocks[(101+k)+(14*128+(j*2048))]:=43;
                end;
              end
              else if j=tekintotn then
              begin
                blocks[91+(1*128+(j*2048))]:=43;
                blocks[92+(1*128+(j*2048))]:=44;
                blocks[93+(1*128+(j*2048))]:=0;
                blocks[94+(1*128+(j*2048))]:=0;
                blocks[95+(1*128+(j*2048))]:=0;
                blocks[96+(1*128+(j*2048))]:=43;
                blocks[91+(14*128+(j*2048))]:=43;
                blocks[92+(14*128+(j*2048))]:=44;
                blocks[93+(14*128+(j*2048))]:=0;
                blocks[94+(14*128+(j*2048))]:=0;
                blocks[95+(14*128+(j*2048))]:=0;
                blocks[96+(14*128+(j*2048))]:=43;
                blocks[102+(1*128+(j*2048))]:=43;
                blocks[103+(1*128+(j*2048))]:=44;
                blocks[104+(1*128+(j*2048))]:=0;
                blocks[105+(1*128+(j*2048))]:=0;
                blocks[106+(1*128+(j*2048))]:=0;
                blocks[107+(1*128+(j*2048))]:=43;
                blocks[102+(14*128+(j*2048))]:=43;
                blocks[103+(14*128+(j*2048))]:=44;
                blocks[104+(14*128+(j*2048))]:=0;
                blocks[105+(14*128+(j*2048))]:=0;
                blocks[106+(14*128+(j*2048))]:=0;
                blocks[107+(14*128+(j*2048))]:=43;
              end;
            end;
          1:begin  //cross
              if (j=tekintotn-2)or(j=tekintotn+2) then
              begin
                blocks[94+(1*128+(j*2048))]:=43;
                blocks[94+(14*128+(j*2048))]:=43;
                blocks[105+(1*128+(j*2048))]:=43;
                blocks[105+(14*128+(j*2048))]:=43;
              end
              else if (j=tekintotn-1)or(j=tekintotn+1) then
              begin
                blocks[92+(1*128+(j*2048))]:=43;
                blocks[93+(1*128+(j*2048))]:=43;
                blocks[94+(1*128+(j*2048))]:=44;
                blocks[95+(1*128+(j*2048))]:=43;
                blocks[92+(14*128+(j*2048))]:=43;
                blocks[93+(14*128+(j*2048))]:=43;
                blocks[94+(14*128+(j*2048))]:=44;
                blocks[95+(14*128+(j*2048))]:=43;
                blocks[103+(1*128+(j*2048))]:=43;
                blocks[104+(1*128+(j*2048))]:=43;
                blocks[105+(1*128+(j*2048))]:=44;
                blocks[106+(1*128+(j*2048))]:=43;
                blocks[103+(14*128+(j*2048))]:=43;
                blocks[104+(14*128+(j*2048))]:=43;
                blocks[105+(14*128+(j*2048))]:=44;
                blocks[106+(14*128+(j*2048))]:=43;
              end
              else if j=tekintotn then
              begin
                blocks[91+(1*128+(j*2048))]:=43;
                blocks[92+(1*128+(j*2048))]:=44;
                blocks[93+(1*128+(j*2048))]:=0;
                blocks[94+(1*128+(j*2048))]:=0;
                blocks[95+(1*128+(j*2048))]:=0;
                blocks[96+(1*128+(j*2048))]:=43;
                blocks[91+(14*128+(j*2048))]:=43;
                blocks[92+(14*128+(j*2048))]:=44;
                blocks[93+(14*128+(j*2048))]:=0;
                blocks[94+(14*128+(j*2048))]:=0;
                blocks[95+(14*128+(j*2048))]:=0;
                blocks[96+(14*128+(j*2048))]:=43;
                blocks[102+(1*128+(j*2048))]:=43;
                blocks[103+(1*128+(j*2048))]:=44;
                blocks[104+(1*128+(j*2048))]:=0;
                blocks[105+(1*128+(j*2048))]:=0;
                blocks[106+(1*128+(j*2048))]:=0;
                blocks[107+(1*128+(j*2048))]:=43;
                blocks[102+(14*128+(j*2048))]:=43;
                blocks[103+(14*128+(j*2048))]:=44;
                blocks[104+(14*128+(j*2048))]:=0;
                blocks[105+(14*128+(j*2048))]:=0;
                blocks[106+(14*128+(j*2048))]:=0;
                blocks[107+(14*128+(j*2048))]:=43;
              end;
            end;
          2:begin  //square
              if (j=tekintotn-2)or(j=tekintotn+1) then
              begin
                blocks[93+(1*128+(j*2048))]:=43;
                blocks[93+(14*128+(j*2048))]:=43;
                blocks[94+(1*128+(j*2048))]:=43;
                blocks[94+(14*128+(j*2048))]:=43;
                blocks[103+(1*128+(j*2048))]:=43;
                blocks[103+(14*128+(j*2048))]:=43;
                blocks[104+(1*128+(j*2048))]:=43;
                blocks[104+(14*128+(j*2048))]:=43;
              end
              else if (j=tekintotn-1)or(j=tekintotn) then
              begin
                blocks[92+(1*128+(j*2048))]:=43;
                blocks[95+(1*128+(j*2048))]:=43;
                blocks[93+(1*128+(j*2048))]:=44;
                blocks[94+(1*128+(j*2048))]:=0;
                blocks[92+(14*128+(j*2048))]:=43;
                blocks[95+(14*128+(j*2048))]:=43;
                blocks[93+(14*128+(j*2048))]:=44;
                blocks[94+(14*128+(j*2048))]:=0;
                blocks[102+(1*128+(j*2048))]:=43;
                blocks[105+(1*128+(j*2048))]:=43;
                blocks[103+(1*128+(j*2048))]:=44;
                blocks[104+(1*128+(j*2048))]:=0;
                blocks[102+(14*128+(j*2048))]:=43;
                blocks[105+(14*128+(j*2048))]:=43;
                blocks[103+(14*128+(j*2048))]:=44;
                blocks[104+(14*128+(j*2048))]:=0;
              end;
            end;
          end;
        end;
        end;
        //delaem fakeli na boinicah s vnutrenney storoni
        for j:=tekintotn-2 to tekintotn+2 do //Z
        begin
          if (j<0)or(j>15) then continue;
          for k:=91 to 107 do
          begin
            if blocks[k+(128+(j*2048))]=43 then
            begin
              blocks[k+(2*128+(j*2048))]:=50;
              data[k+(2*128+(j*2048))]:=3;
            end;
            if blocks[k+(14*128+(j*2048))]=43 then
            begin
              blocks[k+(13*128+(j*2048))]:=50;
              data[k+(13*128+(j*2048))]:=4;
            end;
          end;
        end;
        //delaem rasshirenie naverhu bashni dla chastokola + chastokol
        for j:=tekintotn-8 to tekintotn+7 do //X
        begin
          if (j<0)or(j>15) then continue;
          for k:=109 to 110 do  //Y
            for i:=0 to 15 do  //Z
            begin
              if (j<>(tekintotn-8))and(j<>(tekintotn+7))and(i<>0)and(i<>15) then continue;
              blocks[k+(i*128+(j*2048))]:=4;   //rasshirenie
              if k=110 then       //chastokol + fakeli
              begin
                if (j=(tekintotn-8))or(j=(tekintotn+7)) then
                  if ((i and 1)=1) then
                  begin
                    blocks[k+1+(i*128+(j*2048))]:=4;
                    blocks[k+2+(i*128+(j*2048))]:=50;
                    data[k+2+(i*128+(j*2048))]:=5;
                  end
                  else
                  begin
                    blocks[k+1+(i*128+(j*2048))]:=44;
                    data[k+1+(i*128+(j*2048))]:=3;
                  end;

                if (i=0)or(i=15) then
                  if ((j and 1)=1)then
                  begin
                    blocks[k+1+(i*128+(j*2048))]:=4;
                    blocks[k+2+(i*128+(j*2048))]:=50;
                    data[k+2+(i*128+(j*2048))]:=5;
                  end
                  else
                  begin
                    blocks[k+1+(i*128+(j*2048))]:=44;
                    data[k+1+(i*128+(j*2048))]:=3;
                  end;

                //otdelno ugli
                if ((i=0)and(j=(tekintotn-8)))or
                ((i=0)and(j=(tekintotn+7)))or
                ((i=15)and(j=(tekintotn-8)))or
                ((i=15)and(j=(tekintotn+7))) then
                begin
                  blocks[k+1+(i*128+(j*2048))]:=4;
                  blocks[k+2+(i*128+(j*2048))]:=50;
                  data[k+2+(i*128+(j*2048))]:=5;
                end;
              end;
            end;
        end;
      end;
      tekush:=tekush+shagx;
    end;
  end;
end;

procedure gen_border_cwall_boinici(tip,storona:integer; var blocks,data:ar_type);
var i:integer;
begin
  //storoni:
  //1=levaya nizhnaya
  //2=levaya verhnaya
  //3=pravaya nizhnaya
  //4=pravaya verhnaya
  for i:=1 to 14 do
    begin
      if (i<>1)and(i<>14)then continue;

      case tip of
      0:begin  //line
          //2 etazh
            //air
            blocks[114+(7*128+(i*2048))]:=0;
            blocks[115+(7*128+(i*2048))]:=0;
            blocks[116+(7*128+(i*2048))]:=0;
            //single slab
            blocks[113+(7*128+(i*2048))]:=44;
            //double slab
            blocks[112+(7*128+(i*2048))]:=43;
            blocks[113+(6*128+(i*2048))]:=43;
            blocks[113+(8*128+(i*2048))]:=43;
            blocks[114+(6*128+(i*2048))]:=43;
            blocks[114+(8*128+(i*2048))]:=43;
            blocks[115+(6*128+(i*2048))]:=43;
            blocks[115+(8*128+(i*2048))]:=43;
            blocks[116+(6*128+(i*2048))]:=43;
            blocks[116+(8*128+(i*2048))]:=43;
            blocks[117+(7*128+(i*2048))]:=43;

            //air
            blocks[114+(i*128+(7*2048))]:=0;
            blocks[115+(i*128+(7*2048))]:=0;
            blocks[116+(i*128+(7*2048))]:=0;
            //single slab
            blocks[113+(i*128+(7*2048))]:=44;
            //double slab
            blocks[112+(i*128+(7*2048))]:=43;
            blocks[113+(i*128+(6*2048))]:=43;
            blocks[113+(i*128+(8*2048))]:=43;
            blocks[114+(i*128+(6*2048))]:=43;
            blocks[114+(i*128+(8*2048))]:=43;
            blocks[115+(i*128+(6*2048))]:=43;
            blocks[115+(i*128+(8*2048))]:=43;
            blocks[116+(i*128+(6*2048))]:=43;
            blocks[116+(i*128+(8*2048))]:=43;
            blocks[117+(i*128+(7*2048))]:=43;

          //0 i 1 etazhi
          if (((storona=1)or(storona=2))and(i=1))or
          (((storona=3)or(storona=4))and(i=14)) then
          begin
            //air
            blocks[104+(7*128+(i*2048))]:=0;
            blocks[105+(7*128+(i*2048))]:=0;
            blocks[106+(7*128+(i*2048))]:=0;
            //single slab
            blocks[103+(7*128+(i*2048))]:=44;
            //double slab
            blocks[102+(7*128+(i*2048))]:=43;
            blocks[103+(6*128+(i*2048))]:=43;
            blocks[103+(8*128+(i*2048))]:=43;
            blocks[104+(6*128+(i*2048))]:=43;
            blocks[104+(8*128+(i*2048))]:=43;
            blocks[105+(6*128+(i*2048))]:=43;
            blocks[105+(8*128+(i*2048))]:=43;
            blocks[106+(6*128+(i*2048))]:=43;
            blocks[106+(8*128+(i*2048))]:=43;
            blocks[107+(7*128+(i*2048))]:=43;

            //air
            blocks[93+(7*128+(i*2048))]:=0;
            blocks[94+(7*128+(i*2048))]:=0;
            blocks[95+(7*128+(i*2048))]:=0;
            //single slab
            blocks[92+(7*128+(i*2048))]:=44;
            //double slab
            blocks[91+(7*128+(i*2048))]:=43;
            blocks[92+(6*128+(i*2048))]:=43;
            blocks[92+(8*128+(i*2048))]:=43;
            blocks[93+(6*128+(i*2048))]:=43;
            blocks[93+(8*128+(i*2048))]:=43;
            blocks[94+(6*128+(i*2048))]:=43;
            blocks[94+(8*128+(i*2048))]:=43;
            blocks[95+(6*128+(i*2048))]:=43;
            blocks[95+(8*128+(i*2048))]:=43;
            blocks[96+(7*128+(i*2048))]:=43;
          end;
          if (((storona=1)or(storona=3))and(i=1))or
          (((storona=2)or(storona=4))and(i=14)) then
          begin
            //air
            blocks[104+(i*128+(7*2048))]:=0;
            blocks[105+(i*128+(7*2048))]:=0;
            blocks[106+(i*128+(7*2048))]:=0;
            //single slab
            blocks[103+(i*128+(7*2048))]:=44;
            //double slab
            blocks[102+(i*128+(7*2048))]:=43;
            blocks[103+(i*128+(6*2048))]:=43;
            blocks[103+(i*128+(8*2048))]:=43;
            blocks[104+(i*128+(6*2048))]:=43;
            blocks[104+(i*128+(8*2048))]:=43;
            blocks[105+(i*128+(6*2048))]:=43;
            blocks[105+(i*128+(8*2048))]:=43;
            blocks[106+(i*128+(6*2048))]:=43;
            blocks[106+(i*128+(8*2048))]:=43;
            blocks[107+(i*128+(7*2048))]:=43;

            //air
            blocks[93+(i*128+(7*2048))]:=0;
            blocks[94+(i*128+(7*2048))]:=0;
            blocks[95+(i*128+(7*2048))]:=0;
            //single slab
            blocks[92+(i*128+(7*2048))]:=44;
            //double slab
            blocks[91+(i*128+(7*2048))]:=43;
            blocks[92+(i*128+(6*2048))]:=43;
            blocks[92+(i*128+(8*2048))]:=43;
            blocks[93+(i*128+(6*2048))]:=43;
            blocks[93+(i*128+(8*2048))]:=43;
            blocks[94+(i*128+(6*2048))]:=43;
            blocks[94+(i*128+(8*2048))]:=43;
            blocks[95+(i*128+(6*2048))]:=43;
            blocks[95+(i*128+(8*2048))]:=43;
            blocks[96+(i*128+(7*2048))]:=43;
          end;
        end;
      1:begin  //cross
            //2 etazh
            //air
            blocks[114+(7*128+(i*2048))]:=0;
            blocks[115+(7*128+(i*2048))]:=0;
            blocks[116+(7*128+(i*2048))]:=0;
            //single slab
            blocks[113+(7*128+(i*2048))]:=44;
            blocks[115+(6*128+(i*2048))]:=44;
            blocks[115+(8*128+(i*2048))]:=44;
            //double slab
            blocks[112+(7*128+(i*2048))]:=43;
            blocks[113+(6*128+(i*2048))]:=43;
            blocks[113+(8*128+(i*2048))]:=43;
            blocks[114+(6*128+(i*2048))]:=43;
            blocks[114+(8*128+(i*2048))]:=43;
            blocks[115+(5*128+(i*2048))]:=43;
            blocks[115+(9*128+(i*2048))]:=43;
            blocks[116+(6*128+(i*2048))]:=43;
            blocks[116+(8*128+(i*2048))]:=43;
            blocks[117+(7*128+(i*2048))]:=43;

            //air
            blocks[114+(i*128+(7*2048))]:=0;
            blocks[115+(i*128+(7*2048))]:=0;
            blocks[116+(i*128+(7*2048))]:=0;
            //single slab
            blocks[113+(i*128+(7*2048))]:=44;
            blocks[115+(i*128+(6*2048))]:=44;
            blocks[115+(i*128+(8*2048))]:=44;
            //double slab
            blocks[112+(i*128+(7*2048))]:=43;
            blocks[113+(i*128+(6*2048))]:=43;
            blocks[113+(i*128+(8*2048))]:=43;
            blocks[114+(i*128+(6*2048))]:=43;
            blocks[114+(i*128+(8*2048))]:=43;
            blocks[115+(i*128+(5*2048))]:=43;
            blocks[115+(i*128+(9*2048))]:=43;
            blocks[116+(i*128+(6*2048))]:=43;
            blocks[116+(i*128+(8*2048))]:=43;
            blocks[117+(i*128+(7*2048))]:=43;

          //0 i 1 etazhi
          if (((storona=1)or(storona=2))and(i=1))or
          (((storona=3)or(storona=4))and(i=14)) then
          begin
            //air
            blocks[104+(7*128+(i*2048))]:=0;
            blocks[105+(7*128+(i*2048))]:=0;
            blocks[106+(7*128+(i*2048))]:=0;
            //single slab
            blocks[103+(7*128+(i*2048))]:=44;
            blocks[105+(6*128+(i*2048))]:=44;
            blocks[105+(8*128+(i*2048))]:=44;
            //double slab
            blocks[102+(7*128+(i*2048))]:=43;
            blocks[103+(6*128+(i*2048))]:=43;
            blocks[103+(8*128+(i*2048))]:=43;
            blocks[104+(6*128+(i*2048))]:=43;
            blocks[104+(8*128+(i*2048))]:=43;
            blocks[105+(5*128+(i*2048))]:=43;
            blocks[105+(9*128+(i*2048))]:=43;
            blocks[106+(6*128+(i*2048))]:=43;
            blocks[106+(8*128+(i*2048))]:=43;
            blocks[107+(7*128+(i*2048))]:=43;

            //air
            blocks[93+(7*128+(i*2048))]:=0;
            blocks[94+(7*128+(i*2048))]:=0;
            blocks[95+(7*128+(i*2048))]:=0;
            //single slab
            blocks[92+(7*128+(i*2048))]:=44;
            blocks[94+(6*128+(i*2048))]:=44;
            blocks[94+(8*128+(i*2048))]:=44;
            //double slab
            blocks[91+(7*128+(i*2048))]:=43;
            blocks[92+(6*128+(i*2048))]:=43;
            blocks[92+(8*128+(i*2048))]:=43;
            blocks[93+(6*128+(i*2048))]:=43;
            blocks[93+(8*128+(i*2048))]:=43;
            blocks[94+(5*128+(i*2048))]:=43;
            blocks[94+(9*128+(i*2048))]:=43;
            blocks[95+(6*128+(i*2048))]:=43;
            blocks[95+(8*128+(i*2048))]:=43;
            blocks[96+(7*128+(i*2048))]:=43;
          end;
          if (((storona=1)or(storona=3))and(i=1))or
          (((storona=2)or(storona=4))and(i=14)) then
          begin
            //air
            blocks[104+(i*128+(7*2048))]:=0;
            blocks[105+(i*128+(7*2048))]:=0;
            blocks[106+(i*128+(7*2048))]:=0;
            //single slab
            blocks[103+(i*128+(7*2048))]:=44;
            blocks[105+(i*128+(6*2048))]:=44;
            blocks[105+(i*128+(8*2048))]:=44;
            //double slab
            blocks[102+(i*128+(7*2048))]:=43;
            blocks[103+(i*128+(6*2048))]:=43;
            blocks[103+(i*128+(8*2048))]:=43;
            blocks[104+(i*128+(6*2048))]:=43;
            blocks[104+(i*128+(8*2048))]:=43;
            blocks[105+(i*128+(5*2048))]:=43;
            blocks[105+(i*128+(9*2048))]:=43;
            blocks[106+(i*128+(6*2048))]:=43;
            blocks[106+(i*128+(8*2048))]:=43;
            blocks[107+(i*128+(7*2048))]:=43;

            //air
            blocks[93+(i*128+(7*2048))]:=0;
            blocks[94+(i*128+(7*2048))]:=0;
            blocks[95+(i*128+(7*2048))]:=0;
            //single slab
            blocks[92+(i*128+(7*2048))]:=44;
            blocks[94+(i*128+(6*2048))]:=44;
            blocks[94+(i*128+(8*2048))]:=44;
            //double slab
            blocks[91+(i*128+(7*2048))]:=43;
            blocks[92+(i*128+(6*2048))]:=43;
            blocks[92+(i*128+(8*2048))]:=43;
            blocks[93+(i*128+(6*2048))]:=43;
            blocks[93+(i*128+(8*2048))]:=43;
            blocks[94+(i*128+(5*2048))]:=43;
            blocks[94+(i*128+(9*2048))]:=43;
            blocks[95+(i*128+(6*2048))]:=43;
            blocks[95+(i*128+(8*2048))]:=43;
            blocks[96+(i*128+(7*2048))]:=43;
          end;
        end;
      2:begin  //square
            //2 etazh
            //air
            blocks[114+(7*128+(i*2048))]:=0;
            blocks[114+(8*128+(i*2048))]:=0;
            //single slab
            blocks[113+(7*128+(i*2048))]:=44;
            blocks[113+(8*128+(i*2048))]:=44;
            //double slab
            blocks[112+(7*128+(i*2048))]:=43;
            blocks[112+(8*128+(i*2048))]:=43;
            blocks[113+(6*128+(i*2048))]:=43;
            blocks[113+(9*128+(i*2048))]:=43;
            blocks[114+(6*128+(i*2048))]:=43;
            blocks[114+(9*128+(i*2048))]:=43;
            blocks[115+(7*128+(i*2048))]:=43;
            blocks[115+(8*128+(i*2048))]:=43;

            //air
            blocks[114+(i*128+(7*2048))]:=0;
            blocks[114+(i*128+(8*2048))]:=0;
            //single slab
            blocks[113+(i*128+(7*2048))]:=44;
            blocks[113+(i*128+(8*2048))]:=44;
            //double slab
            blocks[112+(i*128+(7*2048))]:=43;
            blocks[112+(i*128+(8*2048))]:=43;
            blocks[113+(i*128+(6*2048))]:=43;
            blocks[113+(i*128+(9*2048))]:=43;
            blocks[114+(i*128+(6*2048))]:=43;
            blocks[114+(i*128+(9*2048))]:=43;
            blocks[115+(i*128+(7*2048))]:=43;
            blocks[115+(i*128+(8*2048))]:=43;

          //0 i 1 etazhi
          if (((storona=1)or(storona=2))and(i=1))or
          (((storona=3)or(storona=4))and(i=14)) then
          begin
            //air
            blocks[104+(7*128+(i*2048))]:=0;
            blocks[104+(8*128+(i*2048))]:=0;
            //single slab
            blocks[103+(7*128+(i*2048))]:=44;
            blocks[103+(8*128+(i*2048))]:=44;
            //double slab
            blocks[102+(7*128+(i*2048))]:=43;
            blocks[102+(8*128+(i*2048))]:=43;
            blocks[103+(6*128+(i*2048))]:=43;
            blocks[103+(9*128+(i*2048))]:=43;
            blocks[104+(6*128+(i*2048))]:=43;
            blocks[104+(9*128+(i*2048))]:=43;
            blocks[105+(7*128+(i*2048))]:=43;
            blocks[105+(8*128+(i*2048))]:=43;

            //air
            blocks[94+(7*128+(i*2048))]:=0;
            blocks[94+(8*128+(i*2048))]:=0;
            //single slab
            blocks[93+(7*128+(i*2048))]:=44;
            blocks[93+(8*128+(i*2048))]:=44;
            //double slab
            blocks[92+(7*128+(i*2048))]:=43;
            blocks[92+(8*128+(i*2048))]:=43;
            blocks[93+(6*128+(i*2048))]:=43;
            blocks[93+(9*128+(i*2048))]:=43;
            blocks[94+(6*128+(i*2048))]:=43;
            blocks[94+(9*128+(i*2048))]:=43;
            blocks[95+(7*128+(i*2048))]:=43;
            blocks[95+(8*128+(i*2048))]:=43;
          end;
          if (((storona=1)or(storona=3))and(i=1))or
          (((storona=2)or(storona=4))and(i=14)) then
          begin
            //air
            blocks[104+(i*128+(7*2048))]:=0;
            blocks[104+(i*128+(8*2048))]:=0;
            //single slab
            blocks[103+(i*128+(7*2048))]:=44;
            blocks[103+(i*128+(8*2048))]:=44;
            //double slab
            blocks[102+(i*128+(7*2048))]:=43;
            blocks[102+(i*128+(8*2048))]:=43;
            blocks[103+(i*128+(6*2048))]:=43;
            blocks[103+(i*128+(9*2048))]:=43;
            blocks[104+(i*128+(6*2048))]:=43;
            blocks[104+(i*128+(9*2048))]:=43;
            blocks[105+(i*128+(7*2048))]:=43;
            blocks[105+(i*128+(8*2048))]:=43;

            //air
            blocks[94+(i*128+(7*2048))]:=0;
            blocks[94+(i*128+(8*2048))]:=0;
            //single slab
            blocks[93+(i*128+(7*2048))]:=44;
            blocks[93+(i*128+(8*2048))]:=44;
            //double slab
            blocks[92+(i*128+(7*2048))]:=43;
            blocks[92+(i*128+(8*2048))]:=43;
            blocks[93+(i*128+(6*2048))]:=43;
            blocks[93+(i*128+(9*2048))]:=43;
            blocks[94+(i*128+(6*2048))]:=43;
            blocks[94+(i*128+(9*2048))]:=43;
            blocks[95+(i*128+(7*2048))]:=43;
            blocks[95+(i*128+(8*2048))]:=43;
          end;
        end;
      end;
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

  noise_mas:=noise.generateNoiseOctaves(noise_mas,tempx*16,109.0134,tempy*16,16,1,16,0.0075625,1,0.0075625, flat);

  xk:=x-(tempx*16);
  yk:=y-(tempy*16);

  result:=round(64+noise_mas[xk*16+yk]*8);

  setlength(noise_mas,0);
  noise.Free;
  rand.Free;
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

  noise_mas:=noise.generateNoiseOctaves(noise_mas,(xkoord)*16,109.0134,(ykoord)*16,16,1,16,0.0075625,1,0.0075625,not(par.gen_noise));
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

procedure clear_bio_leaves(var map:region; otx,oty,dox,doy:integer; par:bio_settings_type);
var i,j,k,t:integer;
chx,chy:integer;
begin
  for chx:=otx+2 to dox+2 do
    for chy:=oty+2 to doy+2 do
      for i:=0 to 15 do //x
        for j:=0 to 15 do  //z
        begin
          for k:=127 downto 10 do //y
          begin
            t:=map[chx][chy].blocks[k+(j*128+(i*2048))];
            if (t=par.sphere_material)or(t=1)or(t=20)or(t=par.bridge_material)or(t=par.bridge_rail_material) then break;
            //if (t=18)or(t=17) then
              if par.underwater=true then map[chx][chy].blocks[k+(j*128+(i*2048))]:=8
              else map[chx][chy].blocks[k+(j*128+(i*2048))]:=0;
          end;
          for k:=10 to 127 do //y
          begin
            t:=map[chx][chy].blocks[k+(j*128+(i*2048))];
            if (t=par.sphere_material)or(t=1)or(t=20)or(t=par.bridge_material)or(t=par.bridge_rail_material) then break;
            //if (t=18)or(t=17) then
              if par.underwater=true then map[chx][chy].blocks[k+(j*128+(i*2048))]:=8
              else map[chx][chy].blocks[k+(j*128+(i*2048))]:=0;
          end;
        end;
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
      noise_mas:=noise.generateNoiseOctaves(noise_mas,(lakes[k].chunks[i].x)*16,109.0134,(lakes[k].chunks[i].y)*16,16,1,16,0.0075625,1,0.0075625, flat);
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

  noise_mas:=noise.generateNoiseOctaves(noise_mas,(xkoord)*16,109.0134,(ykoord)*16,16,1,16,0.0075625,1,0.0075625,not(par.gen_noise));
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

(*function gen_biosphere_thread(Parameter:pointer):integer;
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
                 place_bio_spawners(map,i,j,ar_rasten[k].x,ar_rasten[k].y-2,ar_rasten[k].z,1,par.bio_par^.sid+k);
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
end; *)

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

function gen_tunnels_thread(Parameter:pointer):integer;
var regx_nach,regy_nach,regx,regy:integer;
i,j,k,z:integer;
otx,oty,dox,doy:integer;
tempx,tempy,tempk,tempz:integer;
id:word;
param:ptparam_tunnel;
par:tparam_tunnel;
map:region;
head:mcheader;
str,strcompress:string;
fdata,rez:ar_type;
hndl:cardinal;
count:dword;
co,co1:integer;
waterlevel:integer;
ar_tun:array of tunnels_settings;
//ar_sf:array of planets_settings;
ar_el:ar_elipse_settings;
cep_tun:ar_cep_tunnel;
b,b1,sp:boolean;
angle,angle2:extended;
iskluch:array of integer;
pr_koord_lights:ar_tlights_koord;
pr_koord_holes,pr_koord_holes_obsh:ar_tprostr_koord;
pr_koord_res:ar_tlights_koord;
pr_koord_dirt:ar_elipse_settings;
pr_koord_trees:ar_tlights_koord;
pop_koord:ar_tkoord;
label nach;

procedure thread_exit(p:ptparam_tunnel);
var i,j:integer;
begin
  if p^.tunnel_par^.potok_exit=true then
  begin
    //++++++++OCHISHENIE PAMATI++++++++++++=
  //ochishaem pamat ot massiva resultata dla nbtcompress
  setlength(rez,0);

  //ochishaem pamat' ot massiva sfer
  {for i:=0 to length(ar_sf)-1 do
    setlength(ar_sf[i].chunks,0);
  setlength(ar_sf,0); }

  //oschishaem pamat' ot massiva tuneley
  for i:=0 to length(ar_tun)-1 do
  begin
    setlength(ar_tun[i].svazi_nach,0);
    setlength(ar_tun[i].svazi_kon,0);
    setlength(ar_tun[i].chunks,0);
  end;
  setlength(ar_tun,0);

  //ochishaem pamat' ot massiva populated dla sveta i skyholes
  setlength(pop_koord,0);

  //ochishaem pamat ot massiva elipsov
  for i:=0 to length(ar_el)-1 do
    setlength(ar_el[i].chunks,0);
  setlength(ar_el,0);

  //ochishaem pamat ot massiva cepey tuneley
  setlength(cep_tun,0);

  //ochishaem massiv isklucheniy
  setlength(iskluch,0);

  //oschishaem massiv dla zemli
  for i:=0 to length(pr_koord_dirt)-1 do
    setlength(pr_koord_dirt[i].chunks,0);
  setlength(pr_koord_dirt,0);

  //ochishaem massivi koordinat dla sveta,skyholes,resursov,derevev
  setlength(pr_koord_lights,0);
  setlength(pr_koord_holes,0);
  setlength(pr_koord_holes_obsh,0);
  setlength(pr_koord_res,0);
  setlength(pr_koord_trees,0);

  //ochishaem pamat ot karti
  for i:=0 to 35 do
    for j:=0 to 35 do
    begin
      clear_all_entities(@map[k][z].entities,@map[k][z].tile_entities);
      setlength(map[i][j].blocks,0);
      setlength(map[i][j].data,0);
      setlength(map[i][j].light,0);
      setlength(map[i][j].skylight,0);
      setlength(map[i][j].heightmap,0);
    end;
  for i:=0 to 35 do
    setlength(map[i],0);
  setlength(map,0);
    endthread(0);
  end;
end;

begin
  param:=parameter;
  par:=param^;

  //smotrim border
  {case par.border_par^.border_type of
  1:begin  //wall
      if par.border_par^.wall_void=false then
      begin
        par.border_par^.wall_void:=true;
        par.border_par^.wall_void_thickness:=15;
      end
      else if par.border_par^.wall_void_thickness<15 then
        par.border_par^.wall_void_thickness:=15;
    end;
  2:begin
      par.border_par^.border_type:=1;
      par.border_par^.wall_material:=7;
      par.border_par^.wall_thickness:=1;
      par.border_par^.wall_void:=true;
      if par.border_par^.void_thickness>15 then
        par.border_par^.wall_void_thickness:=par.border_par^.void_thickness
      else
        par.border_par^.wall_void_thickness:=15;
    end
  else
    begin
      par.border_par^.border_type:=1;
      par.border_par^.wall_material:=7;
      par.border_par^.wall_thickness:=1;
      par.border_par^.wall_void_thickness:=15;
      par.border_par^.wall_void:=true;
    end;
  end;  }

  //kol:=0;
  waterlevel:=10;

  //opredelaem kol-vo region faylov, kotoroe sozdavat
  tempx:=(par.tox-par.fromx+1);      //kol-vo chankov po osam
  tempy:=(par.toy-par.fromy+1);

  //postmessage(par.handle,WM_USER+302,par.id,tempx*tempy);

  postmessage(par.handle,WM_USER+312,0,0);
  //postmessage(par.handle,WM_USER+307,0,0);

  //videlaem pamat pod massiv NBT dla generacii
  setlength(rez,82360);
  //setlength(heightmap,256);

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

  //postmessage(par.handle,WM_USER+300,1,0);

  RandSeed:=par.sid;
  //sozdaem randomnuyu cep tuneley
  //kol-vo tuneley
  //j:=3+random(5);

  //opredelaem obshee kol-vo chankov na karte
  i:=tempx*tempy;

  //opredelaem kol-vo tuneley, kotoroe nado generit' ishoda iz sootnosheniya 10 chankov=1 tunel
  //j:=i div 10;
  //100% = 1 tunel' na 10 chankov + neskolko ne sgeneriruyutsa

  {j:=round((par.tunnel_par^.tun_density/1000)*i);
  j:=round(j+(10*(random*j/100))-(10*(random*j/100)));
  postmessage(par.handle,WM_USER+304,10001,j);

  //j:=j div 3;

  //opredelaem kol-vo cepey tuneley i zapolnaem kol-vom tuneley v kazhdoy cepi
  b1:=false;
  k:=0;
  z:=0;
  tempz:=0; //obshaya summa
  while b1=false do
  begin
    setlength(cep_tun,k+1);
    z:=6+random(13);
    if (tempz+z)>j then z:=j-tempz;

    if z<3 then
    begin
      setlength(cep_tun,k);
      b1:=true;
    end
    else
      cep_tun[k].len:=z;

    inc(k);
    inc(tempz,z);
  end;

  //opredelaem granici koordinat
  tempx:=abs(par.fromx*16);
  tempy:=abs(par.fromy*16);
  //tempk:=(par.tox+1)*16-1;
  //tempz:=(par.toy+1)*16-1;

  //zapolnaem cepi tuneley tunelami
  //setlength(ar_tun,j);
  setlength(ar_tun,0);

  postmessage(par.handle,WM_USER+313,0,0);

  id:=0;

  //cikl po vsem cepam
  for k:=0 to length(cep_tun)-1 do
  begin
    thread_exit(param);

    postmessage(par.handle,WM_USER+314,0,k+1);

    //opredelaem indeks novogo tunela
    if k=0 then cep_tun[k].nach:=0
    else
      cep_tun[k].nach:=cep_tun[k-1].nach+cep_tun[k-1].len;

    inc(id);
    postmessage(par.handle,WM_USER+314,id,0);

    //delaem perviy tunel' v cepi
    setlength(ar_tun,length(ar_tun)+1);
    b1:=true;
    setlength(iskluch,0);
    while b1=true do
    begin
      thread_exit(param);
      ar_tun[cep_tun[k].nach].radius_horiz:=par.tunnel_par^.r_hor_min+random(par.tunnel_par^.r_hor_max-par.tunnel_par^.r_hor_min);
      ar_tun[cep_tun[k].nach].radius_vert:=ar_tun[cep_tun[k].nach].radius_horiz;

      ar_tun[cep_tun[k].nach].x1:=random(tempx-ar_tun[cep_tun[k].nach].radius_horiz-5)-random(tempx-ar_tun[cep_tun[k].nach].radius_horiz-5);
      ar_tun[cep_tun[k].nach].z1:=random(tempy-ar_tun[cep_tun[k].nach].radius_horiz-5)-random(tempy-ar_tun[cep_tun[k].nach].radius_horiz-5);
      ar_tun[cep_tun[k].nach].x2:=random(tempx-ar_tun[cep_tun[k].nach].radius_horiz-5)-random(tempx-ar_tun[cep_tun[k].nach].radius_horiz-5);
      ar_tun[cep_tun[k].nach].z2:=random(tempy-ar_tun[cep_tun[k].nach].radius_horiz-5)-random(tempy-ar_tun[cep_tun[k].nach].radius_horiz-5);
      ar_tun[cep_tun[k].nach].y1:=random(127-2*(ar_tun[cep_tun[k].nach].radius_vert+5))+ar_tun[cep_tun[k].nach].radius_vert+5;
      ar_tun[cep_tun[k].nach].y2:=random(127-2*(ar_tun[cep_tun[k].nach].radius_vert+5))+ar_tun[cep_tun[k].nach].radius_vert+5;
      ar_tun[cep_tun[k].nach].fill_material:=0;

      if ar_tun[cep_tun[k].nach].x1=ar_tun[cep_tun[k].nach].x2 then inc(ar_tun[cep_tun[k].nach].x2);
      if ar_tun[cep_tun[k].nach].y1=ar_tun[cep_tun[k].nach].y2 then inc(ar_tun[cep_tun[k].nach].y2);
      if ar_tun[cep_tun[k].nach].z1=ar_tun[cep_tun[k].nach].z2 then inc(ar_tun[cep_tun[k].nach].z2);

      b1:=tunnel_intersection(ar_tun,cep_tun[k].nach,iskluch);

      if (tunnel_flat_angle(ar_tun,cep_tun[k].nach)>60)or
      (tunnel_length(ar_tun,cep_tun[k].nach)<70) then b1:=true;

      if (b1=false) then
      begin
        setlength(ar_tun[cep_tun[k].nach].svazi_nach,0);
        setlength(ar_tun[cep_tun[k].nach].svazi_kon,0);
      end;
    end;

    //delaem ostal'nie tuneli v cepi
    setlength(iskluch,1);
    for z:=cep_tun[k].nach+1 to cep_tun[k].nach+cep_tun[k].len-1 do
    begin
      thread_exit(param);
      
      inc(id);
      postmessage(par.handle,WM_USER+314,id,0);

      postmessage(par.handle,WM_USER+316,1000,0);

      iskluch[0]:=z-1;
      setlength(ar_tun,length(ar_tun)+1);
      tempz:=1;

      if par.tunnel_par^.round_tun=true then
        b:=true
      else if random(100)<par.tunnel_par^.round_tun_density then
        b:=true
      else b:=false;

      if b=true then
      begin
        ar_tun[z].radius_horiz:=par.tunnel_par^.r_hor_min+random(par.tunnel_par^.r_hor_max-par.tunnel_par^.r_hor_min);
        ar_tun[z].radius_vert:=ar_tun[z].radius_horiz;
      end
      else
      begin
        ar_tun[z].radius_horiz:=par.tunnel_par^.r_hor_min+random(par.tunnel_par^.r_hor_max-par.tunnel_par^.r_hor_min);
        ar_tun[z].radius_vert:=par.tunnel_par^.r_vert_min+random(par.tunnel_par^.r_vert_max-par.tunnel_par^.r_vert_min);
      end;

    nach:
      postmessage(par.handle,WM_USER+317,tempz,0);

      //ar_tun[z].x1:=random(tempx-ar_tun[z].radius_horiz-5)-random(tempx-ar_tun[z].radius_horiz-5);
      ar_tun[z].x1:=ar_tun[z-1].x2;
      ar_tun[z].x2:=random(tempx-ar_tun[z].radius_horiz-5)-random(tempx-ar_tun[z].radius_horiz-5);
      //ar_tun[z].z1:=random(tempx-ar_tun[z].radius_horiz-5)-random(tempx-ar_tun[z].radius_horiz-5);
      ar_tun[z].z1:=ar_tun[z-1].z2;
      ar_tun[z].z2:=random(tempy-ar_tun[z].radius_horiz-5)-random(tempy-ar_tun[z].radius_horiz-5);
      //ar_tun[z].y1:=random(127-2*(ar_tun[z].radius_vert+5))+ar_tun[z].radius_vert+5;
      ar_tun[z].y1:=ar_tun[z-1].y2;
      ar_tun[z].y2:=random(127-2*(max(ar_tun[z].radius_vert,ar_tun[z].radius_horiz)+5))+max(ar_tun[z].radius_vert,ar_tun[z].radius_horiz)+5;
      ar_tun[z].fill_material:=0;

      if ar_tun[z].x1=ar_tun[z].x2 then inc(ar_tun[z].x2);
      if ar_tun[z].y1=ar_tun[z].y2 then inc(ar_tun[z].y2);
      if ar_tun[z].z1=ar_tun[z].z2 then inc(ar_tun[z].z2);

      angle:=tunnel_length(ar_tun,z);
      if (angle<70)or(angle>600) then goto nach;

      b1:=tunnel_intersection2(ar_tun,z,iskluch);

      if (tempz mod 1000)=0 then
      begin
        postmessage(par.handle,WM_USER+305,z,12345);
        dec(id);
        setlength(ar_tun,length(ar_tun)-1);
        //cep_tun[k].len:=length(ar_tun);
        if k=0 then cep_tun[k].len:=length(ar_tun)
          else cep_tun[k].len:=z-cep_tun[k].nach;
        break;
      end;

      if b1=true then
      begin
        inc(tempz);
        goto nach;
      end;

      postmessage(par.handle,WM_USER+304,z+2000,round(angle));

      angle:=180-tunnel_angle(ar_tun,z-1,z);
      postmessage(par.handle,WM_USER+304,z,round(angle));
      if angle<30 then goto nach;

      angle:=tunnel_flat_angle(ar_tun,z);
      postmessage(par.handle,WM_USER+304,z+1000,round(angle));
      if angle>60 then goto nach;

      postmessage(par.handle,WM_USER+317,1000,0);

      if ((min(ar_tun[z].y1,ar_tun[z].y2)-5-max(ar_tun[z].radius_horiz,ar_tun[z].radius_vert))<0)or
      ((max(ar_tun[z].y1,ar_tun[z].y2)+5+max(ar_tun[z].radius_horiz,ar_tun[z].radius_vert))>126) then
      begin
        ar_tun[z].radius_horiz:=ar_tun[z-1].radius_horiz;
        ar_tun[z].radius_vert:=ar_tun[z-1].radius_vert;
      end;

      tempk:=length(ar_tun[z-1].svazi_kon);
      setlength(ar_tun[z-1].svazi_kon,tempk+1);
      ar_tun[z-1].svazi_kon[tempk]:=@ar_tun[z];

      tempk:=length(ar_tun[z].svazi_nach);
      setlength(ar_tun[z].svazi_nach,tempk+1);
      ar_tun[z].svazi_nach[tempk]:=@ar_tun[z-1];
    end;

  end;

  setlength(iskluch,0);

  //soedinaem neskolko cepey tuneley esli ne postavlena galochka v forme nastroek
  if par.tunnel_par^.gen_seperate=false then
  for i:=0 to length(cep_tun)-2 do
    for tempz:=i+1 to length(cep_tun)-1 do
  begin
    b1:=false;
    z:=length(ar_tun);
    setlength(ar_tun,z+1);

    //soedinaem cep' i s i+1
    for j:=cep_tun[i].nach to cep_tun[i].nach+cep_tun[i].len-1 do
    begin
      if b1=true then break;
      for k:=cep_tun[tempz].nach to cep_tun[tempz].nach+cep_tun[tempz].len-1 do
      begin
        thread_exit(param);

        tempx:=2;
        if j<>cep_tun[i].nach then inc(tempx);
        if k<>cep_tun[tempz].nach then inc(tempx);
        setlength(iskluch,tempx);
        tempx:=0;
        iskluch[tempx]:=j;
        inc(tempx);
        iskluch[tempx]:=k;
        inc(tempx);
        if j<>cep_tun[i].nach then
        begin
          iskluch[tempx]:=j-1;
          inc(tempx);
        end;
        if k<>cep_tun[tempz].nach then
          iskluch[tempx]:=k-1;

        //soedinaem nachalo s nachalom
        ar_tun[z].x1:=ar_tun[j].x1;
        ar_tun[z].y1:=ar_tun[j].y1;
        ar_tun[z].z1:=ar_tun[j].z1;
        ar_tun[z].x2:=ar_tun[k].x1;
        ar_tun[z].y2:=ar_tun[k].y1;
        ar_tun[z].z2:=ar_tun[k].z1;
        ar_tun[z].radius_horiz:=max(max(ar_tun[j].radius_horiz,ar_tun[k].radius_horiz),max(ar_tun[j].radius_vert,ar_tun[k].radius_vert));
        ar_tun[z].radius_vert:=ar_tun[z].radius_horiz;
        ar_tun[z].fill_material:=0;
        if ar_tun[z].x1=ar_tun[z].x2 then inc(ar_tun[z].x2);
        if ar_tun[z].y1=ar_tun[z].y2 then inc(ar_tun[z].y2);
        if ar_tun[z].z1=ar_tun[z].z2 then inc(ar_tun[z].z2);

        angle2:=tunnel_angle(ar_tun,z,j);
        angle:=180-tunnel_angle(ar_tun,z,k);
        if angle<angle2 then angle2:=angle;
        if j<>cep_tun[i].nach then angle:=180-tunnel_angle(ar_tun,z,j-1);
        if angle<angle2 then angle2:=angle;
        if k<>cep_tun[tempz].nach then angle:=tunnel_angle(ar_tun,z,k-1);
        if angle<angle2 then angle2:=angle;

        if (tunnel_intersection2(ar_tun,z,iskluch)=false)and
        (tunnel_flat_angle(ar_tun,z)<60)and
        (tunnel_length(ar_tun,z)>30)and
        (angle2>30) then
        begin
          b1:=true;
          inc(id);
          postmessage(par.handle,WM_USER+314,id,0);
          //prisoedinili tunel' k nachalu tunela j i nachalu tunela k
          //prisoedinaem tunel' k nachalu tunela j
          tempk:=length(ar_tun[j].svazi_nach);
          setlength(ar_tun[j].svazi_nach,tempk+1);
          ar_tun[j].svazi_nach[tempk]:=@ar_tun[z];
          //prisoedinaem tunel' k koncu tunela j-1 esli on est'
          if j<>cep_tun[i].nach then
          begin
            tempk:=length(ar_tun[j-1].svazi_kon);
            setlength(ar_tun[j-1].svazi_kon,tempk+1);
            ar_tun[j-1].svazi_kon[tempk]:=@ar_tun[z];
          end;
          //prisoedinaem tunel' k nachalu tunela k
          tempk:=length(ar_tun[k].svazi_nach);
          setlength(ar_tun[k].svazi_nach,tempk+1);
          ar_tun[k].svazi_nach[tempk]:=@ar_tun[z];
          //prisoedinaem tunel' k konsu tunela k-1 esli on est'
          if k<>cep_tun[tempz].nach then
          begin
            tempk:=length(ar_tun[k-1].svazi_kon);
            setlength(ar_tun[k-1].svazi_kon,tempk+1);
            ar_tun[k-1].svazi_kon[tempk]:=@ar_tun[z];
          end;
          break;
        end
        else
        begin
          //soedinaem nachalo s koncom
          tempx:=2;
          if j<>cep_tun[i].nach then inc(tempx);
          if k<>(cep_tun[tempz].nach+cep_tun[tempz].len-1) then inc(tempx);
          setlength(iskluch,tempx);
          tempx:=0;
          iskluch[tempx]:=j;
          inc(tempx);
          iskluch[tempx]:=k;
          inc(tempx);
          if j<>cep_tun[i].nach then
          begin
            iskluch[tempx]:=j-1;
            inc(tempx);
          end;
          if k<>(cep_tun[tempz].nach+cep_tun[tempz].len-1) then
            iskluch[tempx]:=k+1;

          ar_tun[z].x1:=ar_tun[j].x1;
          ar_tun[z].y1:=ar_tun[j].y1;
          ar_tun[z].z1:=ar_tun[j].z1;
          ar_tun[z].x2:=ar_tun[k].x2;
          ar_tun[z].y2:=ar_tun[k].y2;
          ar_tun[z].z2:=ar_tun[k].z2;
          ar_tun[z].radius_horiz:=max(max(ar_tun[j].radius_horiz,ar_tun[k].radius_horiz),max(ar_tun[j].radius_vert,ar_tun[k].radius_vert));
          ar_tun[z].radius_vert:=ar_tun[z].radius_horiz;
          ar_tun[z].fill_material:=0;
          if ar_tun[z].x1=ar_tun[z].x2 then inc(ar_tun[z].x2);
          if ar_tun[z].y1=ar_tun[z].y2 then inc(ar_tun[z].y2);
          if ar_tun[z].z1=ar_tun[z].z2 then inc(ar_tun[z].z2);

          angle2:=tunnel_angle(ar_tun,z,j);
          angle:=tunnel_angle(ar_tun,z,k);
          if angle<angle2 then angle2:=angle;
          if j<>cep_tun[i].nach then angle:=180-tunnel_angle(ar_tun,z,j-1);
          if angle<angle2 then angle2:=angle;
          if k<>(cep_tun[tempz].nach+cep_tun[tempz].len-1) then angle:=180-tunnel_angle(ar_tun,z,k+1);
          if angle<angle2 then angle2:=angle;

          if (tunnel_intersection2(ar_tun,z,iskluch)=false)and
          (tunnel_flat_angle(ar_tun,z)<60)and
          (tunnel_length(ar_tun,z)>30)and
          (angle>30) then
          begin
            b1:=true;
            inc(id);
            postmessage(par.handle,WM_USER+314,id,0);
            //prisoedinili tunel' k nachalu tunela j i nachalu tunela k
            //prisoedinaem tunel' k nachalu tunela j
            tempk:=length(ar_tun[j].svazi_nach);
            setlength(ar_tun[j].svazi_nach,tempk+1);
            ar_tun[j].svazi_nach[tempk]:=@ar_tun[z];
            //prisoedinaem tunel' k koncu tunela j-1 esli on est'
            if j<>cep_tun[i].nach then
            begin
              tempk:=length(ar_tun[j-1].svazi_kon);
              setlength(ar_tun[j-1].svazi_kon,tempk+1);
              ar_tun[j-1].svazi_kon[tempk]:=@ar_tun[z];
            end;
            //prisoedinaem tunel' k koncu tunela k
            tempk:=length(ar_tun[k].svazi_kon);
            setlength(ar_tun[k].svazi_kon,tempk+1);
            ar_tun[k].svazi_kon[tempk]:=@ar_tun[z];
            //prisoedinaem tunel' k nachalu tunela k+1 esli on est'
            if k<>(cep_tun[tempz].nach+cep_tun[tempz].len-1) then
            begin
              tempk:=length(ar_tun[k+1].svazi_nach);
              setlength(ar_tun[k+1].svazi_nach,tempk+1);
              ar_tun[k+1].svazi_nach[tempk]:=@ar_tun[z];
            end;
            break;
          end
          else
          begin
            //soedinaem konec s nachalom
            tempx:=2;
            if j<>(cep_tun[i].nach+cep_tun[i].len-1) then inc(tempx);
            if k<>cep_tun[tempz].nach then inc(tempx);
            setlength(iskluch,tempx);
            tempx:=0;
            iskluch[tempx]:=j;
            inc(tempx);
            iskluch[tempx]:=k;
            inc(tempx);
            if j<>(cep_tun[i].nach+cep_tun[i].len-1) then
            begin
              iskluch[tempx]:=j+1;
              inc(tempx);
            end;
            if k<>cep_tun[tempz].nach then
              iskluch[tempx]:=k-1;

            ar_tun[z].x1:=ar_tun[j].x2;
            ar_tun[z].y1:=ar_tun[j].y2;
            ar_tun[z].z1:=ar_tun[j].z2;
            ar_tun[z].x2:=ar_tun[k].x1;
            ar_tun[z].y2:=ar_tun[k].y1;
            ar_tun[z].z2:=ar_tun[k].z1;
            ar_tun[z].radius_horiz:=max(max(ar_tun[j].radius_horiz,ar_tun[k].radius_horiz),max(ar_tun[j].radius_vert,ar_tun[k].radius_vert));
            ar_tun[z].radius_vert:=ar_tun[z].radius_horiz;
            ar_tun[z].fill_material:=0;
            if ar_tun[z].x1=ar_tun[z].x2 then inc(ar_tun[z].x2);
            if ar_tun[z].y1=ar_tun[z].y2 then inc(ar_tun[z].y2);
            if ar_tun[z].z1=ar_tun[z].z2 then inc(ar_tun[z].z2);

            angle2:=180-tunnel_angle(ar_tun,z,j);
            angle:=180-tunnel_angle(ar_tun,z,k);
            if angle<angle2 then angle2:=angle;
            if j<>(cep_tun[i].nach+cep_tun[i].len-1) then angle:=tunnel_angle(ar_tun,z,j+1);
            if angle<angle2 then angle2:=angle;
            if k<>cep_tun[tempz].nach then angle:=tunnel_angle(ar_tun,z,k-1);
            if angle<angle2 then angle2:=angle;

            if (tunnel_intersection2(ar_tun,z,iskluch)=false)and
            (tunnel_flat_angle(ar_tun,z)<60)and
            (tunnel_length(ar_tun,z)>30)and
            (angle>30) then
            begin
              b1:=true;
              inc(id);
              postmessage(par.handle,WM_USER+314,id,0);
              //prisoedinaem tunel' k koncu tunela j
              tempk:=length(ar_tun[j].svazi_kon);
              setlength(ar_tun[j].svazi_kon,tempk+1);
              ar_tun[j].svazi_kon[tempk]:=@ar_tun[z];
              //prisoedinaem tunel' k nachalu tunela j+1 esli on est'
              if j<>(cep_tun[i].nach+cep_tun[i].len-1) then
              begin
                tempk:=length(ar_tun[j+1].svazi_nach);
                setlength(ar_tun[j+1].svazi_nach,tempk+1);
                ar_tun[j+1].svazi_nach[tempk]:=@ar_tun[z];
              end;
              //prisoedinaem tunel' k nachalu tunela k
              tempk:=length(ar_tun[k].svazi_nach);
              setlength(ar_tun[k].svazi_nach,tempk+1);
              ar_tun[k].svazi_nach[tempk]:=@ar_tun[z];
              //prisoedinaem tunel' k koncu tunela k-1 esli on est'
              if k<>cep_tun[tempz].nach then
              begin
                tempk:=length(ar_tun[k-1].svazi_kon);
                setlength(ar_tun[k-1].svazi_kon,tempk+1);
                ar_tun[k-1].svazi_kon[tempk]:=@ar_tun[z];
              end;
              break;
            end
            else
            begin
              //soedinaem konec s koncom
              tempx:=2;
              if j<>(cep_tun[i].nach+cep_tun[i].len-1) then inc(tempx);
              if k<>(cep_tun[tempz].nach+cep_tun[tempz].len-1) then inc(tempx);
              setlength(iskluch,tempx);
              tempx:=0;
              iskluch[tempx]:=j;
              inc(tempx);
              iskluch[tempx]:=k;
              inc(tempx);
              if j<>(cep_tun[i].nach+cep_tun[i].len-1) then
              begin
                iskluch[tempx]:=j-1;
                inc(tempx);
              end;
              if k<>(cep_tun[tempz].nach+cep_tun[tempz].len-1) then
                iskluch[tempx]:=k-1;

              ar_tun[z].x1:=ar_tun[j].x2;
              ar_tun[z].y1:=ar_tun[j].y2;
              ar_tun[z].z1:=ar_tun[j].z2;
              ar_tun[z].x2:=ar_tun[k].x2;
              ar_tun[z].y2:=ar_tun[k].y2;
              ar_tun[z].z2:=ar_tun[k].z2;
              ar_tun[z].radius_horiz:=max(max(ar_tun[j].radius_horiz,ar_tun[k].radius_horiz),max(ar_tun[j].radius_vert,ar_tun[k].radius_vert));
              ar_tun[z].radius_vert:=ar_tun[z].radius_horiz;
              ar_tun[z].fill_material:=0;
              if ar_tun[z].x1=ar_tun[z].x2 then inc(ar_tun[z].x2);
              if ar_tun[z].y1=ar_tun[z].y2 then inc(ar_tun[z].y2);
              if ar_tun[z].z1=ar_tun[z].z2 then inc(ar_tun[z].z2);

              angle2:=180-tunnel_angle(ar_tun,z,j);
              angle:=tunnel_angle(ar_tun,z,k);
              if angle<angle2 then angle2:=angle;
              if j<>(cep_tun[i].nach+cep_tun[i].len-1) then angle:=tunnel_angle(ar_tun,z,j+1);
              if angle<angle2 then angle2:=angle;
              if k<>(cep_tun[tempz].nach+cep_tun[tempz].len-1) then angle:=180-tunnel_angle(ar_tun,z,k+1);
              if angle<angle2 then angle2:=angle;

              if (tunnel_intersection2(ar_tun,z,iskluch)=false)and
              (tunnel_flat_angle(ar_tun,z)<60)and
              (tunnel_length(ar_tun,z)>30)and
              (angle>30) then
              begin
                b1:=true;
                inc(id);
                postmessage(par.handle,WM_USER+314,id,0);
                //prisoedinaem tunel' k koncu tunela j
                tempk:=length(ar_tun[j].svazi_kon);
                setlength(ar_tun[j].svazi_kon,tempk+1);
                ar_tun[j].svazi_kon[tempk]:=@ar_tun[z];
                //prisoedinaem tunel' k nachalu tunela j+1 esli on est'
                if j<>(cep_tun[i].nach+cep_tun[i].len-1) then
                begin
                  tempk:=length(ar_tun[j+1].svazi_nach);
                  setlength(ar_tun[j+1].svazi_nach,tempk+1);
                  ar_tun[j+1].svazi_nach[tempk]:=@ar_tun[z];
                end;
                //prisoedinaem tunel' k koncu tunela k
                tempk:=length(ar_tun[k].svazi_kon);
                setlength(ar_tun[k].svazi_kon,tempk+1);
                ar_tun[k].svazi_kon[tempk]:=@ar_tun[z];
                //prisoedinaem tunel' k nachalu tunela k+1 esli on est'
                if k<>(cep_tun[tempz].nach+cep_tun[tempz].len-1) then
                begin
                  tempk:=length(ar_tun[k+1].svazi_nach);
                  setlength(ar_tun[k+1].svazi_nach,tempk+1);
                  ar_tun[k+1].svazi_nach[tempk]:=@ar_tun[z];
                end;
                break;
              end;
            end;
          end;
        end;

      end;
    end;
    if b1=false then setlength(ar_tun,z);

  end;

  setlength(iskluch,0);

  //ishem vtoruyu po glubine tochku tuneley
  tempx:=127;
  tempy:=127;

  for i:=0 to length(ar_tun)-1 do
  begin
    if ar_tun[i].y1<tempx then tempx:=ar_tun[i].y1;
    if ar_tun[i].y2<tempx then tempx:=ar_tun[i].y2;
  end;

  for i:=0 to length(ar_tun)-1 do
  begin
    if (ar_tun[i].y1<tempy)and(ar_tun[i].y1<>tempx) then tempy:=ar_tun[i].y1;
    if (ar_tun[i].y2<tempy)and(ar_tun[i].y2<>tempx) then tempy:=ar_tun[i].y2;
  end;

  if tempy>40 then waterlevel:=0
  else waterlevel:=tempy;

  for i:=0 to length(ar_tun)-1 do
    if ((ar_tun[i].y1-ar_tun[i].radius_vert)<waterlevel)or
    ((ar_tun[i].y2-ar_tun[i].radius_vert)<waterlevel) then
    begin
      ar_tun[i].flooded:=true;
      ar_tun[i].waterlevel:=waterlevel;
    end
    else
    begin
      ar_tun[i].flooded:=false;
      ar_tun[i].waterlevel:=0;
    end;           }

  postmessage(par.handle,WM_USER+316,0,0);


  setlength(ar_tun,3);

  ar_tun[0].x1:=-20;
  ar_tun[0].y1:=80;
  ar_tun[0].z1:=50;
  ar_tun[0].x2:=-70;
  ar_tun[0].y2:=50;
  ar_tun[0].z2:=-50;
  ar_tun[0].radius_horiz:=12;
  ar_tun[0].radius_vert:=12;
  ar_tun[0].fill_material:=0;
  setlength(ar_tun[0].svazi_kon,1);
  ar_tun[0].svazi_kon[0]:=@ar_tun[1];
  ar_tun[0].waterlevel:=0;

  ar_tun[1].x1:=-70;
  ar_tun[1].y1:=50;
  ar_tun[1].z1:=-50;
  ar_tun[1].x2:=40;
  ar_tun[1].y2:=60;
  ar_tun[1].z2:=-40;
  ar_tun[1].radius_horiz:=30;
  ar_tun[1].radius_vert:=30;
  ar_tun[1].fill_material:=0;
  setlength(ar_tun[1].svazi_nach,1);
  ar_tun[1].svazi_nach[0]:=@ar_tun[0];
  setlength(ar_tun[1].svazi_kon,1);
  ar_tun[1].svazi_kon[0]:=@ar_tun[2];
  ar_tun[1].waterlevel:=0;

  ar_tun[2].x1:=40;
  ar_tun[2].y1:=60;
  ar_tun[2].z1:=-40;
  ar_tun[2].x2:=20;
  ar_tun[2].y2:=70;
  ar_tun[2].z2:=80;
  ar_tun[2].radius_horiz:=8;
  ar_tun[2].radius_vert:=8;
  ar_tun[2].fill_material:=0;
  setlength(ar_tun[2].svazi_nach,1);
  ar_tun[2].svazi_nach[0]:=@ar_tun[1];
  ar_tun[3].waterlevel:=0;

  {setlength(ar_tun,1);

  ar_tun[0].x1:=10;
  ar_tun[0].y1:=80;
  ar_tun[0].z1:=10;
  ar_tun[0].x2:=50;
  ar_tun[0].y2:=80;
  ar_tun[0].z2:=50;
  ar_tun[0].radius_horiz:=5;
  ar_tun[0].radius_vert:=5;
  ar_tun[0].fill_material:=0;  }


  //for i:=cep_tun[0].nach to cep_tun[0].nach+cep_tun[0].len-1 do
  // ar_tun[i].fill_material:=20;
  

  (*setlength(ar_sf,length(ar_tun)+1);

  ar_sf[0].x:=ar_tun[0].x1;
  ar_sf[0].z:=ar_tun[0].z1;
  ar_sf[0].y:=ar_tun[0].y1;
  ar_sf[0].radius:=max(ar_tun[0].radius_horiz,ar_tun[0].radius_vert)-1;
  ar_sf[0].material_shell:=0;
  ar_sf[0].material_fill:=0;
  ar_sf[0].material_thick:=1;
  ar_sf[0].fill_level:=ar_sf[0].radius*2-1;

  for i:=0 to length(ar_tun)-1 do
  begin
    ar_sf[i+1].x:=ar_tun[i].x2;
    ar_sf[i+1].y:=ar_tun[i].y2;
    ar_sf[i+1].z:=ar_tun[i].z2;
    k:=max(ar_tun[i].radius_horiz,ar_tun[i].radius_vert);
    for j:=0 to length(ar_tun[i].svazi_kon)-1 do
      if max(ar_tun[i].svazi_kon[j]^.radius_horiz,ar_tun[i].svazi_kon[j]^.radius_vert)>k
      then k:=max(ar_tun[i].svazi_kon[j]^.radius_horiz,ar_tun[i].svazi_kon[j]^.radius_vert);
    ar_sf[i+1].radius:=k-1;
    ar_sf[i+1].material_shell:=0;
    ar_sf[i+1].material_fill:=0;
    ar_sf[i+1].material_thick:=1;
    ar_sf[i+1].fill_level:=ar_sf[i+1].radius*2-1;
  end;   *)

  {if par.tunnel_par^.gen_hub=true then
  begin
    k:=1;
    setlength(ar_el,k);
    //testovaya sfera haba
    ar_el[0].x:=0;
    ar_el[0].y:=64;
    ar_el[0].z:=0;
    ar_el[0].radius_x:=53;
    ar_el[0].radius_z:=53;
    ar_el[0].radius_vert:=53;
    ar_el[0].fill_material:=0;
    ar_el[0].flooded:=true;
    ar_el[0].waterlevel:=0;
  end
  else
  begin   }
    k:=0;
    setlength(ar_el,k);
  //end;

  for i:=0 to length(ar_tun)-1 do
  begin
    if ar_tun[i].nach_sfera=nil then
    begin
      inc(k);
      setlength(ar_el,k);
      ar_el[k-1].x:=ar_tun[i].x1;
      ar_el[k-1].y:=ar_tun[i].y1;
      ar_el[k-1].z:=ar_tun[i].z1;
      z:=max(ar_tun[i].radius_horiz,ar_tun[i].radius_vert);
      for j:=0 to length(ar_tun[i].svazi_nach)-1 do
        if max(ar_tun[i].svazi_nach[j]^.radius_horiz,ar_tun[i].svazi_nach[j]^.radius_vert)>z then
          z:=max(ar_tun[i].svazi_nach[j]^.radius_horiz,ar_tun[i].svazi_nach[j]^.radius_vert);
      ar_el[k-1].radius_x:=z-1;
      ar_el[k-1].radius_z:=z-1;
      ar_el[k-1].radius_vert:=z-1;
      ar_el[k-1].fill_material:=0;

      b:=ar_tun[i].flooded;
      tempx:=ar_tun[i].waterlevel;
      for j:=0 to length(ar_tun[i].svazi_nach)-1 do
        if ar_tun[i].svazi_nach[j]^.flooded then
        begin
          b:=true;
          tempx:=max(tempx,ar_tun[i].svazi_nach[j]^.waterlevel);
        end;
      if b=true then
      begin
        ar_el[k-1].flooded:=true;
        ar_el[k-1].waterlevel:=tempx;
      end
      else
        ar_el[k-1].flooded:=false;

      ar_tun[i].nach_sfera:=@ar_el[k-1];
      for j:=0 to length(ar_tun[i].svazi_nach)-1 do
        if (ar_tun[i].svazi_nach[j]^.x1=ar_el[k-1].x)and
        (ar_tun[i].svazi_nach[j]^.y1=ar_el[k-1].y)and
        (ar_tun[i].svazi_nach[j]^.z1=ar_el[k-1].z) then
          ar_tun[i].svazi_nach[j]^.nach_sfera:=@ar_el[k-1]
        else
          ar_tun[i].svazi_nach[j]^.kon_sfera:=@ar_el[k-1];
    end;

    if ar_tun[i].kon_sfera=nil then
    begin
      inc(k);
      setlength(ar_el,k);
      ar_el[k-1].x:=ar_tun[i].x2;
      ar_el[k-1].y:=ar_tun[i].y2;
      ar_el[k-1].z:=ar_tun[i].z2;
      z:=max(ar_tun[i].radius_horiz,ar_tun[i].radius_vert);
      for j:=0 to length(ar_tun[i].svazi_kon)-1 do
        if max(ar_tun[i].svazi_kon[j]^.radius_horiz,ar_tun[i].svazi_kon[j]^.radius_vert)>z then
          z:=max(ar_tun[i].svazi_kon[j]^.radius_horiz,ar_tun[i].svazi_kon[j]^.radius_vert);
      ar_el[k-1].radius_x:=z-1;
      ar_el[k-1].radius_z:=z-1;
      ar_el[k-1].radius_vert:=z-1;
      ar_el[k-1].fill_material:=0;

      b:=ar_tun[i].flooded;
      tempx:=ar_tun[i].waterlevel;
      for j:=0 to length(ar_tun[i].svazi_kon)-1 do
        if ar_tun[i].svazi_kon[j]^.flooded then
        begin
          b:=true;
          tempx:=max(tempx,ar_tun[i].svazi_kon[j]^.waterlevel);
        end;
      if b=true then
      begin
        ar_el[k-1].flooded:=true;
        ar_el[k-1].waterlevel:=tempx;
      end
      else
        ar_el[k-1].flooded:=false;

      ar_tun[i].kon_sfera:=@ar_el[k-1];
      for j:=0 to length(ar_tun[i].svazi_kon)-1 do
        if (ar_tun[i].svazi_kon[j]^.x1=ar_el[k-1].x)and
        (ar_tun[i].svazi_kon[j]^.y1=ar_el[k-1].y)and
        (ar_tun[i].svazi_kon[j]^.z1=ar_el[k-1].z) then
          ar_tun[i].svazi_kon[j]^.nach_sfera:=@ar_el[k-1]
        else
          ar_tun[i].svazi_kon[j]^.kon_sfera:=@ar_el[k-1];
    end;
  end;

  {setlength(ar_el,length(ar_tun)+1);

  ar_el[0].x:=ar_tun[0].x1;
  ar_el[0].z:=ar_tun[0].z1;
  ar_el[0].y:=ar_tun[0].y1;
  ar_el[0].radius_x:=max(ar_tun[0].radius_horiz,ar_tun[0].radius_vert)-1;
  ar_el[0].radius_z:=ar_el[0].radius_x;
  ar_el[0].radius_vert:=ar_el[0].radius_x;
  ar_el[0].fill_material:=0;

  for i:=0 to length(ar_tun)-1 do
  begin
    ar_el[i+1].x:=ar_tun[i].x2;
    ar_el[i+1].y:=ar_tun[i].y2;
    ar_el[i+1].z:=ar_tun[i].z2;
    k:=max(ar_tun[i].radius_horiz,ar_tun[i].radius_vert);
    for j:=0 to length(ar_tun[i].svazi_kon)-1 do
      if max(ar_tun[i].svazi_kon[j]^.radius_horiz,ar_tun[i].svazi_kon[j]^.radius_vert)>k
      then k:=max(ar_tun[i].svazi_kon[j]^.radius_horiz,ar_tun[i].svazi_kon[j]^.radius_vert);
    ar_el[i+1].radius_x:=k-1;
    ar_el[i+1].radius_z:=ar_el[i+1].radius_x;
    ar_el[i+1].radius_vert:=ar_el[i+1].radius_x;
    ar_el[i+1].fill_material:=0;
  end;  }

  calc_cos_tun(ar_tun);

  {for i:=0 to length(ar_tun)-1 do
    tunnel_sphere_intersection(ar_tun,i,@ar_sf);}

  {setlength(ar_el,1);

  ar_el[0].x:=20;
  ar_el[0].y:=50;
  ar_el[0].z:=20;
  ar_el[0].radius_x:=10;
  ar_el[0].radius_z:=7;
  ar_el[0].radius_vert:=4;
  ar_el[0].fill_material:=0;

  setlength(ar_el[0].chunks,4);
  ar_el[0].chunks[0].x:=0;
  ar_el[0].chunks[0].y:=0;
  ar_el[0].chunks[1].x:=1;
  ar_el[0].chunks[1].y:=0;
  ar_el[0].chunks[2].x:=0;
  ar_el[0].chunks[2].y:=1;
  ar_el[0].chunks[3].x:=1;
  ar_el[0].chunks[3].y:=1;     }

  {i:=length(ar_sf);
  setlength(ar_sf,i+1);

  ar_sf[i].x:=40;
  ar_sf[i].z:=-38;
  ar_sf[i].y:=60;
  ar_sf[i].radius:=10;
  ar_sf[i].material_shell:=3;
  ar_sf[i].material_fill:=0;
  ar_sf[i].material_thick:=1;
  ar_sf[i].fill_level:=ar_sf[i].radius*2-1; }

  {ar_tun[0].x1:=100;
  ar_tun[0].z1:=10;
  ar_tun[0].y1:=80;
  ar_tun[0].x2:=-10;
  ar_tun[0].z2:=10;
  ar_tun[0].y2:=50;
  ar_tun[0].radius_horiz:=5;
  ar_tun[0].radius_vert:=5;
  ar_tun[0].fill_material:=0;
  //sdelat' chanki

  ar_tun[1].x1:=-10;
  ar_tun[1].z1:=10;
  ar_tun[1].y1:=50;
  ar_tun[1].x2:=100;
  ar_tun[1].z2:=10;
  ar_tun[1].y2:=20;
  ar_tun[1].radius_horiz:=5;
  ar_tun[1].radius_vert:=5;
  ar_tun[1].fill_material:=0;   }
  //sdelat' chanki

  //delaem testovie sferi
  {setlength(ar_sf,1);
  ar_sf[0].x:=60;
  ar_sf[0].z:=30;
  ar_sf[0].y:=70;
  ar_sf[0].radius:=5;
  ar_sf[0].material_shell:=0;
  ar_sf[0].material_fill:=0;
  ar_sf[0].material_thick:=1;
  ar_sf[0].fill_level:=ar_sf[0].radius*2-1;    }


  //angle:=tunnel_angle(ar_tun,0,1);
  //postmessage(par.handle,WM_USER+304,6666,round(angle));

  fill_tun_chunks(ar_tun);
 { for k:=0 to length(ar_tun)-1 do
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
  end;  }

  (*for k:=0 to length(ar_sf)-1 do
  begin
    //opredelaem kraynie koordinati po dvum osam
      tempx:=ar_sf[k].x-ar_sf[k].radius;
      tempk:=ar_sf[k].x+ar_sf[k].radius;
      tempy:=ar_sf[k].z-ar_sf[k].radius;
      tempz:=ar_sf[k].z+ar_sf[k].radius;

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
      if (tempx<=0)and((ar_sf[k].x-ar_sf[k].radius)<0) then tempx:=tempx-1;
      if (tempk<=0)and((ar_sf[k].x+ar_sf[k].radius)<0) then tempk:=tempk-1;
      if (tempy<=0)and((ar_sf[k].z-ar_sf[k].radius)<0) then tempy:=tempy-1;
      if (tempz<=0)and((ar_sf[k].z+ar_sf[k].radius)<0) then tempz:=tempz-1;

      //videlaem pamat'
      setlength(ar_sf[k].chunks,(tempk-tempx+1)*(tempz-tempy+1));

      //zapisivaem
      z:=0;
      for i:=tempx to tempk do
        for j:=tempy to tempz do
        begin
          ar_sf[k].chunks[z].x:=i;
          ar_sf[k].chunks[z].y:=j;
          inc(z);
        end;
  end; *)

  fill_el_chunks(ar_el);
  {for k:=0 to length(ar_el)-1 do
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
  end;    }

  if par.tunnel_par^.gen_flooded=true then
  begin
  gen_flooded(ar_tun,map);

  for i:=0 to length(ar_tun)-1 do
  begin
    //nach sfera
    if ar_tun[i].flooded=true then
      tempx:=ar_tun[i].waterlevel
    else
      tempx:=0;
    for j:=0 to length(ar_tun[i].svazi_nach)-1 do
      if (ar_tun[i].svazi_nach[j]^.flooded=true)and
      (ar_tun[i].svazi_nach[j]^.waterlevel>tempx) then
        tempx:=ar_tun[i].svazi_nach[j]^.waterlevel;

    if tempx<>0 then
    begin
      ar_tun[i].nach_sfera^.flooded:=true;
      ar_tun[i].nach_sfera^.waterlevel:=tempx;
    end;

    //kon sfera
    if ar_tun[i].flooded=true then
      tempx:=ar_tun[i].waterlevel
    else
      tempx:=0;
    for j:=0 to length(ar_tun[i].svazi_kon)-1 do
      if (ar_tun[i].svazi_kon[j]^.flooded=true)and
      (ar_tun[i].svazi_kon[j]^.waterlevel>tempx) then
        tempx:=ar_tun[i].svazi_kon[j]^.waterlevel;

    if tempx<>0 then
    begin
      ar_tun[i].kon_sfera^.flooded:=true;
      ar_tun[i].kon_sfera^.waterlevel:=tempx;
    end;
  end;
  
  end;

  //izmenaem spawn
  {if par.tunnel_par^.gen_hub=true then
  begin
    tempx:=ar_el[1].x;
    tempy:=ar_el[1].y-ar_el[1].radius_vert;
    tempz:=ar_el[1].z;
  end
  else
  begin  }
    tempx:=ar_el[0].x;
    tempy:=ar_el[0].y-ar_el[0].radius_vert;
    tempz:=ar_el[0].z;
  //end;

  for i:=0 to length(ar_el)-1 do
    if ar_el[i].flooded=false then
    begin
      tempx:=ar_el[i].x;
      tempy:=ar_el[i].y-ar_el[i].radius_vert;
      tempz:=ar_el[i].z;

      setlength(pr_koord_dirt,1);
      pr_koord_dirt[0].x:=tempx;
      pr_koord_dirt[0].y:=tempy;
      pr_koord_dirt[0].z:=tempz;
      pr_koord_dirt[0].fill_material:=1;
      pr_koord_dirt[0].radius_vert:=ar_el[i].radius_vert+5;
      pr_koord_dirt[0].radius_x:=ar_el[i].radius_vert+5;
      pr_koord_dirt[0].radius_z:=ar_el[i].radius_vert+5;
      if (pr_koord_dirt[0].y-pr_koord_dirt[0].radius_vert)<2 then
        pr_koord_dirt[0].radius_vert:=pr_koord_dirt[0].y-2;
      fill_el_chunks(pr_koord_dirt);
      break;
    end;  
             
  postmessage(par.handle,WM_USER+308,1,tempx); //x
  postmessage(par.handle,WM_USER+308,2,tempy); //y
  postmessage(par.handle,WM_USER+308,3,tempz); //z
  sp:=false;

  postmessage(par.handle,WM_USER+315,0,0);

  co:=0;
  co1:=0;

  {for i:=0 to length(ar_tun)-1 do
    if ar_tun[i].waterlevel=0 then ar_tun[i].flooded:=false
    else ar_tun[i].flooded:=true;  }

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
      end
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

  //opredelaem kol-vo region faylov, kotoroe sozdavat
  tempx:=(par.tox-par.fromx+1);      //kol-vo chankov po osam
  tempy:=(par.toy-par.fromy+1);

  postmessage(par.handle,WM_USER+302,par.id,tempx*tempy);

  postmessage(par.handle,WM_USER+300,1,0);

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

      //peredaem soobshenie o nachale zapisi blokov
      postmessage(par.handle,WM_USER+309,i,j);

      //ochishaem kartu
      for k:=0 to 35 do
        for z:=0 to 35 do
        begin
          fillchar(map[k][z].blocks[0],length(map[k][z].blocks),1);
          //zapolnaem niz i verh adminiumom i 1 sloy lavoy
          for tempx:=0 to 15 do  //x
            for tempz:=0 to 15 do  //z
            begin
              map[k][z].blocks[tempz*128+(tempx*2048)]:=7;
              map[k][z].blocks[127+(tempz*128+(tempx*2048))]:=7;
              map[k][z].blocks[1+(tempz*128+(tempx*2048))]:=10;
            end;
          //delaem steni iz adminiuma
          {if i<0 then tempx:=((i+1)*32-(32-k))
          else tempx:=(i*32)+k;
          if j<0 then  tempy:=((j*32)+z)
          else tempy:=(j+1)*32-(32-z);
          dec(tempx,2);
          dec(tempy,2);
          if (tempx=par.fromx) then
            for tempk:=0 to 127 do   //y
              for tempz:=0 to 15 do   //z
                map[k][z].blocks[tempk+(tempz*128)]:=7;
          if (tempx=par.tox) then
            for tempk:=0 to 127 do      //y
              for tempz:=0 to 15 do      //z
                map[k][z].blocks[tempk+(tempz*128+(15*2048))]:=7;
          if (tempy=par.fromy) then
            for tempk:=0 to 127 do      //y
              for tempz:=0 to 15 do      //x
                map[k][z].blocks[tempk+(tempz*2048)]:=7;
          if (tempy=par.toy) then
            for tempk:=0 to 127 do      //y
              for tempz:=0 to 15 do      //x
                map[k][z].blocks[tempk+(15*128+(tempz*2048))]:=7; }

          zeromemory(map[k][z].data,length(map[k][z].data));
          zeromemory(map[k][z].light,length(map[k][z].light));
          zeromemory(map[k][z].heightmap,length(map[k][z].heightmap));
          fillchar(map[k][z].skylight[0],length(map[k][z].skylight),0);
          clear_all_entities(@map[k][z].entities,@map[k][z].tile_entities);
        end;

      //ochishaem head
      for k:=1 to 1024 do
      begin
        head.mclocations[k]:=0;
        head.mctimestamp[k]:=0;
      end;

      //zapolnaem head
      tempx:=2;
      for k:=otx to dox do
        for z:=oty to doy do
        begin
          str:=inttohex(tempx,6)+inttohex(1,2);
          tempy:=bintoint(hextobin(str));
          btolendian(tempy);
          head.mclocations[(k+(z*32))+1]:=tempy;
          inc(tempx);
        end;

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

          gen_border(tempx-2,tempy-2,par.tox-par.fromx+1,par.toy-par.fromy+1,par.border_par^,map[k][z].blocks,map[k][z].data,nil,nil);
          if map[k][z].blocks[0]=0 then continue;

          try
          //gen_sphere(tempx-2,tempy-2,map[k][z].blocks,ar_sf,0,3);
          gen_tun(tempx-2,tempy-2,map[k][z].blocks,ar_tun,@pr_koord_lights,@pr_koord_holes,@pr_koord_dirt,@pr_koord_res,b1,par.tunnel_par^.gen_lights,par.tunnel_par^.gen_sun_holes,par.tunnel_par^.light_density,par.tunnel_par^.skyholes_density);
          gen_elipse(tempx-2,tempy-2,map[k][z].blocks,ar_el,nil,@pr_koord_lights,@pr_koord_res,b1,par.tunnel_par^.gen_lights,par.tunnel_par^.light_density,0);
          {if (tempx-2>=-5)and(tempx-2<=5)and
          (tempy-2>=-5)and(tempy-2<=5)
          then gen_plosk(tempx-2,tempy-2,map[k][z].blocks); }
          except
            on e:exception do messagebox(par.handle,pchar(e.Message+#13+#10+'Koordinati='+inttostr(k)+','+inttostr(z)),'Error',MB_OK);
          end;
          inc(co1);
          //postmessage(par.handle,WM_USER+304,par.id,co1);
        end;

      //ishem blizkie koordinati dirok
      for k:=0 to length(pr_koord_holes)-2 do
      begin
        if pr_koord_holes[k].z=1000 then continue;
        for z:=k+1 to length(pr_koord_holes)-1 do
        begin
          if pr_koord_holes[k].z=1000 then continue;
          if ((pr_koord_holes[k].x-7)<=pr_koord_holes[z].x)and
          ((pr_koord_holes[k].x+7)>=pr_koord_holes[z].x)and
          ((pr_koord_holes[k].y-7)<=pr_koord_holes[z].y)and
          ((pr_koord_holes[k].y+7)>=pr_koord_holes[z].y) then
            if random<0.5 then
              pr_koord_holes[k].z:=1000
            else
              pr_koord_holes[z].z:=1000;
        end;
      end;

      if length(pr_koord_holes_obsh)=0 then
      begin
        for k:=0 to length(pr_koord_holes)-1 do
          if (pr_koord_holes[k].z<>1000) then
          begin
            z:=length(pr_koord_holes_obsh);
            setlength(pr_koord_holes_obsh,z+1);
            pr_koord_holes_obsh[z]:=pr_koord_holes[k];
          end;
      end
      else
      begin
        for k:=0 to length(pr_koord_holes)-1 do
        begin
          if pr_koord_holes[k].z=1000 then continue;
          for z:=0 to length(pr_koord_holes_obsh)-1 do
            if ((pr_koord_holes[k].x-7)<=pr_koord_holes_obsh[z].x)and
            ((pr_koord_holes[k].x+7)>=pr_koord_holes_obsh[z].x)and
            ((pr_koord_holes[k].y-7)<=pr_koord_holes_obsh[z].y)and
            ((pr_koord_holes[k].y+7)>=pr_koord_holes_obsh[z].y)and
            (pr_koord_holes_obsh[z].z<>1000) then
            begin
              pr_koord_holes[k].z:=1000;
              break;
            end;
        end;

        for k:=0 to length(pr_koord_holes)-1 do
          if (pr_koord_holes[k].z<>1000) then
          begin
            z:=length(pr_koord_holes_obsh);
            setlength(pr_koord_holes_obsh,z+1);
            pr_koord_holes_obsh[z]:=pr_koord_holes[k];
          end;
      end;

      setlength(pr_koord_holes,0);

      //generim resursi
      {if (i=-1)and(j=-1) then
      begin
        //gen_resourses(map,par.tunnel_par^.sid,29,30,15,32,14,20,0,600);  //y=33
        gen_resourses(map,par.tunnel_par^.sid,29,30,-35,36,-50,3,1,40);
        //gen_resourses2(map,i,j,-70,20,-50,20,300);
        gen_tree_notch(map,par.tunnel_par^.sid,-29,38,-50);
        gen_tree_notch(map,par.tunnel_par^.sid,-33,38,-52);
        gen_tree_notch(map,par.tunnel_par^.sid,-41,37,-52);
        gen_tree_notch(map,par.tunnel_par^.sid,-35,37,-48);
      end; }

      gen_resourses3(map,i,j,pr_koord_res,0,par.tunnel_par^.sid);

      calc_tun_dirt(map,i,j,pr_koord_dirt,par.tunnel_par^.sid);

      //todo: udalenie lishnih sfer zemli

      //risuem zemlu ili graviy
      for k:=0 to 35 do
        for z:=0 to 35 do
        begin
          if i<0 then tempx:=((i+1)*32-(32-k))
          else tempx:=(i*32)+k;

          if j<0 then  tempy:=((j*32)+z)
          else tempy:=(j+1)*32-(32-z);

          gen_elipse(tempx-2,tempy-2,map[k][z].blocks,pr_koord_dirt,@pr_koord_trees,nil,nil,false,false,0,1);
        end;

      //delaem derevya
      for k:=0 to length(pr_koord_trees)-1 do
      begin
        if pr_koord_trees[k].id=0 then
          gen_tree_notch(map,i,j,par.tunnel_par^.sid+k,pr_koord_trees[k].x,pr_koord_trees[k].y,pr_koord_trees[k].z,sp,waterlevel,par.handle,0)
        else if (pr_koord_trees[k].id=1)and(par.tunnel_par^.gen_tall_grass=true) then
        begin
          tempx:=random(1000);
          if get_block_id(map,i,j,pr_koord_trees[k].x,pr_koord_trees[k].y-1,pr_koord_trees[k].z)=2 then
          if tempx<3 then
            set_block_id_data(map,i,j,pr_koord_trees[k].x,pr_koord_trees[k].y,pr_koord_trees[k].z,31,0)
          else if tempx<8 then
            set_block_id_data(map,i,j,pr_koord_trees[k].x,pr_koord_trees[k].y,pr_koord_trees[k].z,31,2)
          else
            set_block_id_data(map,i,j,pr_koord_trees[k].x,pr_koord_trees[k].y,pr_koord_trees[k].z,31,1);
        end;
      end;

      //gen_resourses3(map,i,j,pr_koord_dirt,1,par.tunnel_par^.sid);

      //otladka
      {begin
        pr_koord_lights[0].x:=-69;
        pr_koord_lights[0].y:=21;
        pr_koord_lights[0].z:=-45;
        setlength(pr_koord_lights,1);
      end;   }

      gen_tun_lights(map,i,j,pr_koord_lights);
      gen_tun_holes(map,i,j,pr_koord_holes_obsh);

      //gen_tun_waterlevel(map,waterlevel);

      postmessage(par.handle,WM_USER+310,i,j);
      
      //schitaem skylight srazu dla vsego regiona
      //postmessage(par.handle,WM_USER+311,0,0);
      calc_skylight(map,otx,oty,dox,doy);
      //postmessage(par.handle,WM_USER+311,0,0);

      //schitaem blocklight
      //postmessage(par.handle,WM_USER+311,0,0);
      calc_blocklight(map,otx,oty,dox,doy);
      //postmessage(par.handle,WM_USER+311,0,0);

      //delaem gribi
      for k:=0 to length(pr_koord_trees)-1 do
      begin
        if (pr_koord_trees[k].id=2)or(pr_koord_trees[k].id=3) then
        begin
          //postmessage(par.handle,WM_USER+305,0,9999999);
          gen_mushroom(map,i,j,pr_koord_trees[k].x,pr_koord_trees[k].y,pr_koord_trees[k].z,pr_koord_trees[k].id);
        end;
      end;

      //ispolzuem massiv dla hraneniya informacii, kotoruyu budem zapisivat' v fayl
      setlength(fdata,0);

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

          //zeromemory(heightmap,length(heightmap));
          //calc_heightmap(map[k+2][z+2].blocks,heightmap);

          nbtcompress2(tempx,tempy,map[k+2][z+2].blocks,map[k+2][z+2].data,map[k+2][z+2].skylight,map[k+2][z+2].light,map[k+2][z+2].heightmap,map[k+2][z+2].entities,map[k+2][z+2].tile_entities,not(par.tunnel_par^.pop_chunks),@rez);

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

      if writefile(hndl,head,sizeof(head),count,nil)=false then
        postmessage(par.handle,WM_USER+304,300,-4000);

      writefile(hndl,fdata[0],length(fdata),count,nil);

      closehandle(hndl);

      postmessage(par.handle,WM_USER+319,0,length(fdata));

      setlength(fdata,0);

      thread_exit(param);
    end;

  //soobsheniya o dlinne massivov
  //postmessage(par.handle,WM_USER+304,11112222,length(pr_koord_dirt));
  //postmessage(par.handle,WM_USER+304,11112222,length(pr_koord_trees));


  //++++++++OCHISHENIE PAMATI++++++++++++=
  //ochishaem pamat ot massiva resultata dla nbtcompress
  setlength(rez,0);

  //ochishaem pamat' ot massiva sfer
  {for i:=0 to length(ar_sf)-1 do
    setlength(ar_sf[i].chunks,0);
  setlength(ar_sf,0);  }

  //oschishaem pamat' ot massiva tuneley
  for i:=0 to length(ar_tun)-1 do
  begin
    setlength(ar_tun[i].svazi_nach,0);
    setlength(ar_tun[i].svazi_kon,0);
    setlength(ar_tun[i].chunks,0);
  end;
  setlength(ar_tun,0);

  //ochishaem pamat' ot massiva populated dla sveta i skyholes
  setlength(pop_koord,0);

  //ochishaem pamat ot massiva elipsov
  for i:=0 to length(ar_el)-1 do
    setlength(ar_el[i].chunks,0);
  setlength(ar_el,0);

  //ochishaem pamat ot massiva cepey tuneley
  setlength(cep_tun,0);

  //ochishaem massiv isklucheniy
  setlength(iskluch,0);

  //oschishaem massiv dla zemli
  for i:=0 to length(pr_koord_dirt)-1 do
    setlength(pr_koord_dirt[i].chunks,0);
  setlength(pr_koord_dirt,0);

  //ochishaem massivi koordinat dla sveta,skyholes,resursov,derevev
  setlength(pr_koord_lights,0);
  setlength(pr_koord_holes,0);
  setlength(pr_koord_holes_obsh,0);
  setlength(pr_koord_res,0);
  setlength(pr_koord_trees,0);

  //ochishaem pamat ot karti
  for i:=0 to 35 do
    for j:=0 to 35 do
    begin
      clear_all_entities(@map[k][z].entities,@map[k][z].tile_entities);
      setlength(map[i][j].blocks,0);
      setlength(map[i][j].data,0);
      setlength(map[i][j].light,0);
      setlength(map[i][j].skylight,0);
      setlength(map[i][j].heightmap,0);
    end;
  for i:=0 to 35 do
    setlength(map[i],0);
  setlength(map,0);

  endthread(0);
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

      {rand:=rnd.Create(par.flatmap_par^.sid);
      octaves:=NoiseGeneratorOctaves.create(rand,4);
      setlength(noise_mas,256);}

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

          {noise_mas:=octaves.generateNoiseOctaves(noise_mas,tempx*16,109.0134,tempy*16,16,1,16,0.0078125,1,0.0078125);

          for tempk:=0 to length(noise_mas)-1 do
          begin
            noise_mas[tempk]:=64+noise_mas[tempk]*8;
            if noise_mas[tempk]<1 then noise_mas[tempk]:=1;
            if noise_mas[tempk]>125 then noise_mas[tempk]:=125;
          end;

          for tempk:=0 to 15 do  //X
            for tempz:=0 to 15 do  //Z
            begin
              count:=round(noise_mas[tempk+tempz*16]);
              while count>0 do
              begin
                map[k][z].blocks[count+(tempk*128+(tempz*2048))]:=1;
                dec(count);
              end;
            end;   }

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

      {rand.Free;
      octaves.Free;
      setlength(noise_mas,0);     }

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

initialization

begin
  trans_bl:=[0,20,8,9,6,18,26,27,28,30,31,32,37,38,39,40,50,51,52,55,59,63,64,65,66,68,69,70,71,72,75,76,77,78,79,81,83,85,90,92,93,94,96,101,102,104,105,106,107,111,113,115];
  light_bl:=[51,91,10,11,89,50,76,90,94,74,62,39,95];
  diff_bl:=[8,9,79];

  dll_hndl:=loadlibrary('gen_structures.dll');
  if dll_hndl<>0 then
  begin
    @gen_struct:=getProcAddress(dll_hndl,'gen_struct');
    @gen_obl:=getProcAddress(dll_hndl,'gen_obl');
    @calc_polozh:=getProcAddress(dll_hndl,'calc_polozh');

    if (addr(gen_struct)<>nil)and
    (addr(gen_obl)<>nil)and
    (addr(calc_polozh)<>nil) then
      loaded:=true;
  end;
end;

finalization

begin
  if dll_hndl<>0 then freelibrary(dll_hndl);
end;

end.

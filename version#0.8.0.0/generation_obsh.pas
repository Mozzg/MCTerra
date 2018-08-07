unit generation_obsh;

interface

uses NBT, F_Version, windows, SysUtils;

const WM_USER = $0400;

type DWORD = Longword;

     for_set = 0..255;
     set_trans_blocks = set of for_set;

     ar_double=array of extended;

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

     oblast_type=record
       x,y:integer;
       r,r1:integer;
       tip:byte;
     end;

     par_oblast=^ar_oblast;
     ar_oblast=array of oblast_type;

     par_int=^ar_int;
     ar_int=array of integer;

     karta_type=array of array of integer;
     pkarta_type=^karta_type;

     layers=record
       start_alt:integer;
       width:integer;
       material:integer;
       material_data:byte;
       name:string[26];
     end;

     layers_ar=array of layers;

     vil_tip_type=record
       ruied,normal,normal_veg,fortif,hidden:boolean;
     end;

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

     pbiomes_desert_settings_type=^biomes_desert_settings_type;
     biomes_desert_settings_type=record
       gen_cactus:boolean;
       gen_shrubs:boolean;
       gen_oasises:boolean;
       gen_pyr:boolean;
       gen_volcano:boolean;
       gen_preview:boolean;
       gen_prev_oasis:boolean;
       gen_prev_vil:boolean;
       gen_only_prev:boolean;
       gen_vil:boolean;
       under_block:byte;
       //gen_oasis_den:boolean;
       //oasis_den:integer;
       oasis_count:integer;
       vil_count:integer;
       vil_names:array of string[15];
       vil_types:vil_tip_type;
       width,len:integer;
       handle:longword;
       potok_exit:boolean;
       pop_chunks:boolean;
       sid:int64;
     end;

     poriginal_settings_type=^original_settings_type;
     original_settings_type=record
       version:integer;
       width,len:integer;
       handle:longword;
       potok_exit:boolean;
       pop_chunks:boolean;
       sid:int64;
     end;

//-------------------

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
       waterlevel_nat:byte;
       flooded_nat:boolean;
       waterlevel_unnat:byte;
       flooded_unnat:boolean;
       svazi_nach,svazi_kon:array of ptunnels_settings;
       nach_sfera,kon_sfera:pelipse_settings;
       chunks:array of tkoord;
     end;

     ar_tun_settings=array of tunnels_settings;
     par_tun_settings=^ar_tun_settings;

     mcheader=record       //tip dannih, opisivayushiy zagolovok fayla regionov Minecraft
       mclocations:array[1..1024] of cardinal;
       mctimestamp:array[1..1024] of longint;
     end;

     {player_set=record
       food_exhaustion_level:single;
       food_tick_timer:integer;
       food_saturation_level:single;
       food_level:integer;
       xp_level:integer;
       xp_total:integer;
       xp:integer;
     end;

     level_set = record
       spawnx,spawny,spawnz:int64;
       path,name:string;
       game_time:integer;
       thundering,raining:byte;
       thunder_time,rain_time:integer;
       player:player_set;
       game_type:integer;
       map_features:byte;
       sid:int64;
       size:int64;
     end;}

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

     ptparam_biomes_desert=^tparam_biomes_desert;
     tparam_biomes_desert=record
       path,map_name:string;
       id:integer;
       handle:longword;
       fromx,fromy,tox,toy:integer;
       desert_par:pbiomes_desert_settings_type;
       border_par:pborder_settings_type;
       sid:longword;
     end;

     ptparam_original=^tparam_original;
     tparam_original=record
       id:integer;
       handle:longword;
       fromx,fromy,tox,toy:integer;
       original_par:poriginal_settings_type;
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

var trans_bl:set_trans_blocks;
light_bl:set_trans_blocks;
diff_bl:set_trans_blocks;
solid_bl:set_trans_blocks;

//dla DLL
  gen_struct:procedure (ar_struct:ar_param_structure; xchkoord,ychkoord,length,width:integer; entitys,tile_entitys:par_entity_type; map_type:byte; blocks,data,heightmap:ar_type; hndl:cardinal);
  gen_obl:procedure (fromx,fromy,tox,toy:integer; par_struct:par_param_structure);
  calc_polozh:procedure (map:region; var struct:tparam_structure);
  dll_hndl:thandle;
  loaded:boolean=false;

//data dla flatmap
wood_data:array[1..3] of string=('Usual','Spruce','Brich');
pistons_data:array[1..6] of string=('Facing down','Facing up','Facing east','Facing west','Facing north','Facing south');
wool_data:array[1..16] of string=('White color','Orange color','Magenta color','Light blue color','Yellow color','Lime color','Pink color','Gray color','Light gray color','Cyan color','Purple color','Blue color','Brown color','Green color','Red color','Black color');
slabs_data:array[1..7] of string=('Stone slab','Sandstone slab','Wooden slab','Cobblestone slab','Brick slab','Stone brick slab','Nether brick slab');
pumpkin_data:array[1..4] of string=('Facing east','Facing south','Facing west','Facing north');
silverfish_data:array[1..3] of string=('Stone block','Cobblestone block','Stone brick block');
stonebrick_data:array[1..3] of string=('Normal brick','Mossy brick','Cracked brick');
mushroom_data:array[1..11] of string=('Pores on all sides','Cap on top, south and west','Cap on top and west','Cap on top, north and west','Cap on top and south','Cap on top','Cap on top and north','Cap on top, south and east','Cap on top and east','Cap on top, north and east','Stem texture on al sides');


function bintoint(s:string):int64;
function hextobin(s:string):string; 
procedure btolendian(var i:integer);
procedure generate_settings(path,name:string; sid:int64; bor_set:border_settings_type; par:pointer; map_type:byte; level_settings:level_set);
function GetBlockName(id:byte):string;
function GetBlockId(str:string):byte;
function calc_crc32(str:string):longword; overload;
function calc_crc32(mas:array of longword; start:integer):longword; overload;
function shll(chislo:integer; smeshenie:byte):integer;
function shrr(chislo:integer; smeshenie:byte):integer;
function shll_l(chislo:int64; smeshenie:byte):int64;
function shrr_l(chislo:int64; smeshenie:byte):int64;

implementation

uses generation_spec;

var blocksid:array[0..116] of string=(
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

crc32_table:array [0..255] of longword =
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

function shll(chislo:integer; smeshenie:byte):integer;
begin
  if chislo<0 then
    result:=(chislo shl smeshenie)or $80000000
  else
    result:=chislo shl smeshenie;
end;

function shrr(chislo:integer; smeshenie:byte):integer;
var i,t:integer;
begin
  if chislo<0 then
  begin
    t:=chislo;
    for i:=1 to smeshenie do
    begin
      t:=(t shr 1)or $80000000;
      if t=-1 then break;
    end;
    result:=t;
  end
  else
    result:=chislo shr smeshenie;
end;

function shll_l(chislo:int64; smeshenie:byte):int64;
begin
  if chislo<0 then
    result:=(chislo shl smeshenie)or $8000000000000000
  else
    result:=chislo shl smeshenie;
end;

function shrr_l(chislo:int64; smeshenie:byte):int64;
var i:integer;
t:int64;
begin
  if chislo<0 then
  begin
    t:=chislo;
    for i:=1 to smeshenie do
    begin
      t:=(t shr 1)or $8000000000000000;
      if t=-1 then break;
    end;
    result:=t;
  end
  else
    result:=chislo shr smeshenie;
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
desert:biomes_desert_settings_type;
desertp:pbiomes_desert_settings_type;
original:original_settings_type;
originalp:poriginal_settings_type;
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

  //str:=str+'Populate chunks: '+booltostr(flat.pop_chunks,true)+#13+#10;
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

  str:=str+'Game mode: ';
  case level_settings.game_type of
    0:str:=str+'Survival'+#13+#10;
    1:str:=str+'Creative'+#13+#10;
    2:str:=str+'Hardcore'+#13+#10;
  end;

  //str:=str+'Map name: '+name+#13+#10;
  //str:=str+'Map path: '+path+#13+#10;
  //map type
  case map_type of
    0:begin
        flatp:=par;
        flat:=flatp^;
        str:=str+'Map name: '+name+#13+#10;
        str:=str+'Map path: '+path+#13+#10;
        str:=str+'Map width: '+inttostr(flat.width)+#13+#10;
        str:=str+'Map length: '+inttostr(flat.len)+#13+#10;
        str:=str+'Populate chunks: '+booltostr(flat.pop_chunks,true)+#13+#10;

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
          for j:=length(str1) to 20 do
            str1:=str1+' ';

          str:=str+str1+'Layer data: ';

          case flat.sloi[i].material of
          17,18:str1:=wood_data[flat.sloi[i].material_data+1]; //wood, leaves
          29,33:str1:=pistons_data[flat.sloi[i].material_data+1];  //pistons
          35:str1:=wool_data[flat.sloi[i].material_data+1];  //wool
          43,44:str1:=slabs_data[flat.sloi[i].material_data+1];  //double slabs, slabs
          86,91:str1:=pumpkin_data[flat.sloi[i].material_data+1];  //pumpkin, jack-o-lantern
          97:str1:=silverfish_data[flat.sloi[i].material_data+1];  //silverfish
          98:str1:=stonebrick_data[flat.sloi[i].material_data+1];  //stone brick
          99,100:str1:=mushroom_data[flat.sloi[i].material_data+1] //huge mushrooms
          else
            str1:='Item data not available';
          end;

          //str1:=inttostr(flat.sloi[i].material_data);
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
    1:begin
        originalp:=par;
        original:=originalp^;
        str:=str+'Map name: '+name+#13+#10;
        str:=str+'Map path: '+path+#13+#10;
        str:=str+'Map width: '+inttostr(original.width)+#13+#10;
        str:=str+'Map length: '+inttostr(original.len)+#13+#10;
        str:=str+'Populate chunks: '+booltostr(original.pop_chunks,true)+#13+#10;

        str:=str+#13+#10;

        str:=str+'[Map settings]'+#13+#10;
        str:=str+'Map type: Original (like-Notch)'+#13+#10;


        str:=str+#13+#10;
      end;
    3:begin  //biomes
        desertp:=par;
        desert:=desertp^;
        str:=str+'Map name: '+name+#13+#10;
        str:=str+'Map path: '+path+#13+#10;
        str:=str+'Map width: '+inttostr(desert.width)+#13+#10;
        str:=str+'Map length: '+inttostr(desert.len)+#13+#10;
        str:=str+'Populate chunks: '+booltostr(desert.pop_chunks,true)+#13+#10;

        str:=str+#13+#10;

        str:=str+'[Map settings]'+#13+#10;
        str:=str+'Map type: Desert'+#13+#10;
        str:=str+'Block material under the sand: '+getblockname(desert.under_block)+#13+#10;
        str:=str+'Generate shrubs: '+booltostr(desert.gen_shrubs,true)+#13+#10;
        str:=str+'Generate cactuses: '+booltostr(desert.gen_cactus,true)+#13+#10;
        str:=str+'Generate pyramids: '+booltostr(desert.gen_pyr,true)+#13+#10;
        str:=str+'Generate volcanoes: '+booltostr(desert.gen_volcano,true)+#13+#10;
        if desert.gen_oasises=true then
        begin
          str:=str+'Generate oasises: True'+#13+#10;
          str:=str+'Oasis count: '+inttostr(desert.oasis_count)+#13+#10;
        end
        else
          str:=str+'Generate oasises: False'+#13+#10;
        if desert.gen_preview=true then
        begin
          str:=str+'Generate heightmap preview: True'+#13+#10;
          str:=str+'Generate oasises preview: '+booltostr(desert.gen_prev_oasis,true)+#13+#10;
          str:=str+'Generate villages preview: '+booltostr(desert.gen_prev_vil,true)+#13+#10;
          str:=str+'Generate only preview: '+booltostr(desert.gen_only_prev,true)+#13+#10;
        end
        else
          str:=str+'Generate heightmap preview: False'+#13+#10;
        if desert.gen_vil=true then
        begin
          str:=str+'Generate villages: True'+#13+#10;
          str:=str+'Villages types: ';
          if desert.vil_types.ruied=true then str:=str+'Ruined, ';
          if desert.vil_types.normal=true then str:=str+'Normal, ';
          if desert.vil_types.normal_veg=true then str:=str+'Normal with vegetation, ';
          if desert.vil_types.fortif=true then str:=str+'Fortified, ';
          if desert.vil_types.hidden=true then str:=str+'Hidden, ';
          delete(str,length(str)-1,2);
          str:=str+#13+#10;
          str:=str+'Village count: '+inttostr(length(desert.vil_names))+#13+#10;
          str:=str+'Village names:'+#13+#10;
          for i:=0 to length(desert.vil_names)-1 do
            str:=str+'  '+inttostr(i+1)+'. '+desert.vil_names[i]+#13+#10;
        end
        else
          str:=str+'Generate villages: False'+#13+#10;
        str:=str+#13+#10;
      end;
    5:begin
        //str:=str+'Planetoids'+#13+#10;
        planetp:=par;
        planet:=planetp^;
        str:=str+'Map name: '+name+#13+#10;
        str:=str+'Map path: '+path+#13+#10;
        str:=str+'Map width: '+inttostr(planet.width)+#13+#10;
        str:=str+'Map length: '+inttostr(planet.len)+#13+#10;
        str:=str+'Populate chunks: '+booltostr(planet.pop_chunks,true)+#13+#10;

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
        str:=str+'Map name: '+name+#13+#10;
        str:=str+'Map path: '+path+#13+#10;
        str:=str+'Map width: '+inttostr(bio.width)+#13+#10;
        str:=str+'Map length: '+inttostr(bio.len)+#13+#10;
        str:=str+'Populate chunks: '+booltostr(bio.pop_chunks,true)+#13+#10;

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
        str:=str+'Map name: '+name+#13+#10;
        str:=str+'Map path: '+path+#13+#10;
        str:=str+'Map width: '+inttostr(tunnel.width)+#13+#10;
        str:=str+'Map length: '+inttostr(tunnel.len)+#13+#10;
        str:=str+'Populate chunks: '+booltostr(tunnel.pop_chunks,true)+#13+#10;

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

  //Player settings
  str:=str+'[Player settings]'+#13+#10;
  //str:=str+'Not yet ready'+#13+#10+#13+#10;
  str:=str+'XP Level: '+inttostr(level_settings.player.xplevel)+#13+#10;
  i:=trunc(level_settings.player.xp*10000*100);
  str:=str+'Experience on current level(%): '+floattostr(i/10000)+#13+#10;
  str:=str+'Total score: '+inttostr(level_settings.player.score)+#13+#10;
  if level_settings.player.overrite_pos=true then
  begin
    str:=str+'Override position: True'+#13+#10;
    str:=str+'New X-pos: '+floattostr(level_settings.player.pos[0])+#13+#10;
    str:=str+'New Y-pos: '+floattostr(level_settings.player.pos[1])+#13+#10;
    str:=str+'New Z-pos: '+floattostr(level_settings.player.pos[2])+#13+#10;
  end
  else
    str:=str+'Override position: False'+#13+#10;
  str:=str+'Line of sight Yaw: '+inttostr(trunc(level_settings.player.rotation[0]))+#13+#10;
  str:=str+'Line of sight Pitch: '+inttostr(trunc(level_settings.player.rotation[1]))+#13+#10;
  str:=str+'Health: '+inttostr(level_settings.player.health)+#13+#10;
  str:=str+'Food level: '+inttostr(level_settings.player.food_level)+#13+#10;
  str:=str+#13+#10;

  //features
  str:=str+'[Features settings]'+#13+#10;
  str:=str+'Not yet ready'+#13+#10+#13+#10;

  str:='MCTerra settings file'+#0+#1+#2+#1+#5+#13+#10+str;

  assignfile(f,path+name+'\settings.txt');
  rewrite(f,1);
  blockwrite(f,str[1],length(str));
  closefile(f);
end;  

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

initialization

begin
  trans_bl:=[0,20,8,9,6,18,26,27,28,30,31,32,37,38,39,40,50,51,52,55,59,63,64,65,66,68,69,70,71,72,75,76,77,78,79,81,83,85,90,92,93,94,96,101,102,104,105,106,107,111,113,115];
  light_bl:=[51,91,10,11,89,50,76,90,94,74,62,39,95];
  diff_bl:=[8,9,79];
  solid_bl:=[1,2,3,4,5,7,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,29,30,33,34,35,36,41,42,43,44,45,46,47,48,49,52,53,54,56,57,58,60,61,62,64,67,71,73,74,79,80,81,82,84,85,86,87,88,89,91,92,95,96,97,98,99,100,101,102,103,107,108,109,110,112,113,114];

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

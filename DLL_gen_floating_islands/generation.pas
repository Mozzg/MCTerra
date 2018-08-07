unit generation;

interface

const PROTOCOL_DLL = 5;
WM_USER = $0400;

type TColor = -$7FFFFFFF-1..$7FFFFFFF;

const
  clBlack = TColor($000000);
  clWhite = TColor($FFFFFF);
  clRed = TColor($0000FF);
  clGreen = TColor($008000);
  clSilver = TColor($C0C0C0);
  clYellow = TColor($00FFFF);

  biome_colors:array[1..15] of integer = (
  $80DF57,   //plains
  $22B14C,   //forest
  $200F2FF,  //desert
  $A4EEBA,   //taiga
  $655B5B,   //swampland
  $FF00,     //jungle
  $2AA8493,  //mushroom
  $FFFFFF,   //ice plains
  $28CFAFF,  //ice desert
  $2FF00FF,  //icy
  $2EF9E6F,  //glaciers
  $2630109,  //obsidian
  $2FFFF00,  //glass
  $2000080,  //hell
  $2C95916   //sky
  );

  biome_priority:array[0..14] of byte = (
  2,  //forest
  3,  //desert
  4,  //taiga
  1,  //plains
  7,  //mushroom
  6,  //jungle
  5,  //swampland
  11, //glacier
  14, //hell
  15, //sky
  13, //glass
  10, //icy
  8,  //ice plains
  12, //obsidian
  9   //ice desert
  );

type
     ar_byte = array of byte;
     ar_int = array of integer;
     ar_double = array of double;
     ar_boolean = array of boolean;
     
     TPlugRec = record
       size_info:integer;
       size_flux:integer;
       size_gen_settings:integer;
       size_chunk:integer;
       size_change_block:integer;
       data:pointer;
     end;

     TPlugSettings = packed record
       plugin_type:byte;
       aditional_type:byte;
       full_name:PChar;
       name:PChar;
       author:PChar;
       dll_path:PChar;
       maj_v, min_j, rel_v:byte; //version
       change_par:array[1..21] of boolean;
       has_preview:boolean;
     end;

     TFlux_set = record
       available:Boolean;
       min_max:boolean;
       default:int64;
       min:int64;
       max:int64;
     end;

     TPlayer_settings = record
       XP_level:integer;
       XP:single;
       HP:integer;
       Food_level:integer;
       Score:integer;
       Rotation:array[0..1] of single;
       Overrite_pos:Boolean;
       Pos:array[0..2] of double;
       Floating:Boolean;
     end;

     TGen_settings = record
       Border_gen:TPlugRec;
       Buildings_gen:TPlugRec;
       Landscape_gen:TPlugRec;
       Path:PChar;
       Name:PChar;
       Map_type:byte;
       Width, Length:integer;
       border_in,border_out:integer;
       Game_type:integer;
       SID:int64;
       Populate_chunks:Boolean;
       Generate_structures:Boolean;
       Game_time:integer;
       Raining, Thundering:Boolean;
       Rain_time, Thunder_time:integer;
       Player:TPlayer_settings;
       Files_size:int64;
       Spawn_pos:array[0..2] of integer;
     end;

     TEntity_type = record
       Id:string;
       Pos:array[0..2] of double;
       Motion:array[0..2] of double;
       Rotation:array[0..1] of single;
       Fall_distance:single;
       Fire:smallint;
       Air:smallint;
       On_ground:Boolean;
       Data:pointer;
     end;

     TTile_entity_type = record
       Id:string;
       x,y,z:integer;
       data:pointer;
     end;

     TGen_chunk = record
       Biomes:ar_byte;
       Blocks:ar_byte;
       Data:ar_byte;
       Light:ar_byte;
       Skylight:ar_byte;
       Heightmap:ar_int;
       Has_additional_id:Boolean;
       sections:array[0..15] of boolean;
       Add_id:ar_byte;
       has_skylight,has_blocklight:boolean;
       raschet_skylight:boolean;
       Entities:array of TEntity_type;
       Tile_entities:array of TTile_entity_type;
     end;

     TChange_block = record
       id:integer;
       name:PChar;
       solid,transparent:Boolean;
       light_level:integer;
     end;

     //tip dla hraneniya data_value dla bloka
     TBlock_data_set = record
       data_id:byte;
       data_name:string[45];
     end;

     //tip dla sootvetstviya ID bloka, ego nazvaniya i harakteristik
     TBlock_set = record
       id:integer;
       name:string[35];
       solid,transparent,diffuse,tile:boolean;
       light_level:byte;
       diffuse_level:byte;
       data:array of TBlock_data_set;
     end;

     line=array of TGen_Chunk;
     region=array of line;

     //tipi dla mnozhestv blokov
     for_set = 0..255;
     set_trans_blocks = set of for_set;

//internal type
     chunk_type=record
       x,z,par:integer;
     end;

     biome_type=record
       id,b_type:integer;
       chunks:array of chunk_type;
     end;

     TObj = record
       x,y,z,id:integer;
     end;
     TObj_ar = array of TObj;

     //tip dla inventara i sundukov, furnace, dispenser
     pslot_item_data=^slot_item_data;
     slot_item_data=record
       id:smallint;
       damage:smallint;
       count,slot:byte;
     end;

     //MobSpawner  
     pmon_spawn_tile_entity_data=^mon_spawn_tile_entity_data;
     mon_spawn_tile_entity_data=record
       entityid:string; //id moba
       delay:smallint;
     end;

     //Chest
     pchest_tile_entity_data=^chest_tile_entity_data;
     chest_tile_entity_data=record
       items:array of slot_item_data;  //ot 0 do 26 (vsego 27=3*9)
     end;

var last_error:PChar;    //stroka s soobsheniem ob oshibke
plug_info_return:TPlugRec;   //zapis' s informaciey o razmerah tipov dannih dla viyasneniya sootvetstviya
plugin_settings:TPlugSettings;   //zapis' s informaciey o plagine
dll_path_str:string = '';  //stroka s putem do DLLki
app_hndl:cardinal;  //hendl Application menedgera
initialized:boolean = false;  //priznak inicializacii plagina
initialized_blocks:boolean = false;  //priznak peredachi massiva blokov
crc_manager:int64;    //CRC poluchennoe ot menedgera
flux:TFlux_set;  //zapis' s informaciey o izmenenii parametrov
mess_str:string;
mess_to_manager:PChar;   //stroka dla peredachi soobsheniy v menedger
stopped:boolean = false;   //priznak ostanovki generacii
prev_ready:boolean = false;  //priznak gotovnosti preview k prosmotru
gen_set_save:TGen_settings;  //peremennaya dla sohraneniya nastroek generatora/menedgera

blocks_ids:array of TBlock_set;
crc_rasch_man,crc_rasch:integer;
map_wid,map_len:integer;   //shirota i dlinna karti

trans_bl:set_trans_blocks;
light_bl:set_trans_blocks;
diff_bl:set_trans_blocks;
solid_bl:set_trans_blocks;


function init_generator(gen_set:TGen_settings; var bord_in,bord_out:integer):boolean;
function generate_chunk(i,j:integer):TGen_Chunk;
procedure clear_dynamic;
function gen_region(i,j:integer; map:region):boolean; register;

implementation

uses RandomMCT, crc32_u, windows, ChunkProviderTest_u, SysUtils, Math,
previewf, graphics, NoiseGeneratorOctaves_u, MapGenRavine_u, MapGenCaves_u,
Mathhelper_u;

var chunk:TGen_Chunk;
zero_chunk:TGen_Chunk;
r_obsh:rnd = nil;
provider:ChunkProviderTest;
ravine_gen:MapGenRavine = nil;
caves_gen:MapGenCaves = nil;
land_noise:NoiseGeneratorOctaves = nil;
obsh_sid:int64;
map_has_portal:boolean;
wid_save,len_save:integer;
spawn_x,spawn_y,spawn_z:integer;
first_region:boolean;
x_reg_old:integer;

gen_chunks,rand_chunks,pop_chunks:array of chunk_type;
gen_biomes,gen_biomes_fin:array of biome_type;
pic:array of ar_int;
obj:TObj_ar;


function set_block_id(map:region; xreg,yreg:integer; x,y,z,id:integer):boolean;
  var tempxot,tempxdo,tempyot,tempydo:integer;
  chx,chy:integer;
  xx,zz,yy:integer;
  begin
    if (y<0)or(y>255) then
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

      map[chx][chy].blocks[xx+zz*16+yy*256]:=id;
      result:=true;
    end
    else result:=false;
  end;

function set_block_id_data(map:region; xreg,yreg:integer; x,y,z,id,data:integer):boolean;
  var tempxot,tempxdo,tempyot,tempydo:integer;
  chx,chy:integer;
  xx,zz,yy:integer;
  begin
    if (y<0)or(y>255) then
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

      map[chx][chy].blocks[xx+zz*16+yy*256]:=id;
      map[chx][chy].data[xx+zz*16+yy*256]:=data;
      result:=true;
    end
    else result:=false;
  end;

function get_block_id(map:region; xreg,yreg:integer; x,y,z:integer):byte;
  var tempxot,tempxdo,tempyot,tempydo:integer;
  chx,chy:integer;
  xx,zz,yy:integer;
  begin
    if (y<0)or(y>255) then
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

      result:=map[chx][chy].blocks[xx+zz*16+yy*256];
    end
    else result:=255;
  end;

function check_end_spike(map:region; xreg,yreg,x,y,z:integer; sid:int64):boolean;
var rand:rnd;
vis,rad,xx,zz,yy,t,tt,t1:integer;
b,bb:boolean;
begin
  rand:=rnd.Create(sid);

  vis:=rand.nextInt(30)+10;
  rad:=2+rand.nextInt(3);
  rand.Free;
  
  bb:=false;
  t:=y;
  for yy:=y-1 downto 0 do
  begin
    if bb=true then break;

    b:=true;
    tt:=0;
    for xx:=x-rad-1 to x+rad+1 do
      for zz:=z-rad-1 to z+rad+1 do
      begin
        t1:=get_block_id(map,xreg,yreg,xx,yy,zz);
        if (t1=0)or(t1=255)then
        begin
          tt:=-2;
          b:=false;
        end;
        if t1=121 then tt:=-1;
      end;

    if b=true then
    begin
      t:=yy;
      break;
    end;

    if (b=false)and(tt=-2) then bb:=true;
  end;

  if bb=true then
  begin
    result:=false;
    exit;
  end;

  for yy:=t to t+vis do
    for xx:=x-rad to x+rad do
      for zz:=z-rad to z+rad do
        if get_block_id(map,xreg,yreg,xx,yy,zz)=49 then
        begin
          result:=false;
          exit;
        end;

  result:=true;
end;

function gen_end_portal(map:region; xreg,yreg,x,y,z:integer; ver:double; sid:int64):boolean;
var i,j,k:integer;
t:integer;
r:rnd;
begin
  r:=rnd.Create(sid);  
  //po X v +
  t:=1;
  if r.nextDouble<ver then set_block_id_data(map,xreg,yreg,x+2,y,z+1,120,t+4)
  else set_block_id_data(map,xreg,yreg,x+2,y,z+1,120,t);
  if r.nextDouble<ver then set_block_id_data(map,xreg,yreg,x+2,y,z,120,t+4)
  else set_block_id_data(map,xreg,yreg,x+2,y,z,120,t);
  if r.nextDouble<ver then set_block_id_data(map,xreg,yreg,x+2,y,z-1,120,t+4)
  else set_block_id_data(map,xreg,yreg,x+2,y,z-1,120,t);
  //po X v -
  t:=3;
  //v seredine vsegda budet ne zapolneniy
  if r.nextDouble<ver then set_block_id_data(map,xreg,yreg,x-2,y,z+1,120,t+4)
  else set_block_id_data(map,xreg,yreg,x-2,y,z+1,120,t);
  set_block_id_data(map,xreg,yreg,x-2,y,z,120,t);
  if r.nextDouble<ver then set_block_id_data(map,xreg,yreg,x-2,y,z-1,120,t+4)
  else set_block_id_data(map,xreg,yreg,x-2,y,z-1,120,t);
  //po Z v +
  t:=2;
  if r.nextDouble<ver then set_block_id_data(map,xreg,yreg,x-1,y,z+2,120,t+4)
  else set_block_id_data(map,xreg,yreg,x-1,y,z+2,120,t);
  if r.nextDouble<ver then set_block_id_data(map,xreg,yreg,x,y,z+2,120,t+4)
  else set_block_id_data(map,xreg,yreg,x,y,z+2,120,t);
  if r.nextDouble<ver then set_block_id_data(map,xreg,yreg,x+1,y,z+2,120,t+4)
  else set_block_id_data(map,xreg,yreg,x+1,y,z+2,120,t);
  //po Z v -
  t:=0;
  if r.nextDouble<ver then set_block_id_data(map,xreg,yreg,x-1,y,z-2,120,t+4)
  else set_block_id_data(map,xreg,yreg,x-1,y,z-2,120,t);
  if r.nextDouble<ver then set_block_id_data(map,xreg,yreg,x,y,z-2,120,t+4)
  else set_block_id_data(map,xreg,yreg,x,y,z-2,120,t);
  if r.nextDouble<ver then set_block_id_data(map,xreg,yreg,x+1,y,z-2,120,t+4)
  else set_block_id_data(map,xreg,yreg,x+1,y,z-2,120,t);

  r.Free;
  result:=true;
end;

procedure gen_surf(i,j:integer; ch:TGen_chunk);
var mas:ar_double;
x,y,z,t:integer;
column:ar_byte;
begin
  provider.ProvideChunk(i,j,ch.Blocks);

  mas:=land_noise.generateNoiseOctaves(mas,i*16,0,j*16,16,1,16,0.02,1,0.02);
  for x:=0 to length(mas)-1 do
    mas[x]:=64+mas[x]*8;
  setlength(column,128);

  for x:=0 to 15 do
    for z:=0 to 15 do
    begin
      //perenosim kolonnu
      for y:=0 to 127 do
        column[y]:=ch.Blocks[x+z*16+y*256];

      //ochishaem mesto v chanke
      for y:=0 to 255 do
        ch.Blocks[x+z*16+y*256]:=0;

      //vichislaem nachalnie usloviya perenosa
      y:=0;
      t:=round(mas[x*16+z]);
      if t<0 then t:=0;
      while (y<128)and(t<256) do
      begin
        ch.Blocks[x+z*16+t*256]:=column[y];
        inc(y);
        inc(t);
      end;
    end;

  setlength(column,0);
  setlength(mas,0);
end;

function gen_spike_sky(map:region; xreg,yreg,x,y,z,id:integer; sid:int64):boolean;
var rand:rnd;
rad,vis,xx,zz,yy,t,tt,t1:integer;
d:double;
b,bb:boolean;
begin
  rand:=rnd.Create(sid);
  vis:=rand.nextInt(30)+10;
  rad:=2+rand.nextInt(3);
  rand.Free;

  bb:=false;
  t:=y;
  for yy:=y-1 downto 0 do
  begin
    if bb=true then break;

    b:=true;
    tt:=0;
    for xx:=x-rad-1 to x+rad+1 do
      for zz:=z-rad-1 to z+rad+1 do
      begin
        t1:=get_block_id(map,xreg,yreg,xx,yy,zz);
        if (t1=0)or(t1=255)then
        begin
          tt:=-2;
          b:=false;
        end;
        if t1=121 then tt:=-1;
      end;

    if b=true then
    begin
      t:=yy;
      break;
    end;

    if (b=false)and(tt=-2) then bb:=true;
  end;

  if bb=true then
  begin
    result:=false;
    exit;
  end;

  vis:=vis+(y-t);

  for yy:=t to t+vis do
    for xx:=x-rad to x+rad do
      for zz:=z-rad to z+rad do
        if get_block_id(map,xreg,yreg,xx,yy,zz)=id then
        begin
          result:=false;
          exit;
        end;


  for xx:=x-rad to x+rad do
  begin
    d:=sqr(rad)-sqr(x-xx);
    if d<0 then continue;
    d:=sqrt(d);
    for zz:=z-round(d) to z+round(d) do
      for yy:=t to t+vis do
        set_block_id(map,xreg,yreg,xx,yy,zz,id);
  end;

  for zz:=z-rad to z+rad do
  begin
    d:=sqr(rad)-sqr(z-zz);
    if d<0 then continue;
    d:=sqrt(d);
    for xx:=x-round(d) to x+round(d) do
      for yy:=t to t+vis do
        set_block_id(map,xreg,yreg,xx,yy,zz,id);
  end;   
  
  result:=true;
end;

function gen_dungeon_notch(map:region; xreg,yreg,x,y,z:integer; rand:rnd):boolean;
type item_stack=record
       count,id:integer;
     end;
var byte0,l,i1,j1,k1,j2,i3,t,l1,k2,j3,i2,l2,k3,l3,i4,j4,k4,i,j,k:integer;
label label0;

   function pickCheckLootItem(rand:rnd):item_stack;
var i:integer;
begin
  i:=rand.nextInt(13);
  if (i = 0)then
  begin
    result.id:=329;  //saddle
    result.count:=rand.nextInt(3) + 1;
    exit;
  end;
  if (i = 1)then
  begin
    result.id:=265;  //IronIngot
    result.count:=rand.nextInt(6) + 4;
    exit;
  end;
  if (i = 2)then
  begin
    result.id:=297;  //bread
    result.count:=rand.nextInt(6) + 4;
    exit;
  end;
  if (i = 3)then
  begin
    result.id:=296;  //wheat
    result.count:=rand.nextInt(5) + 3;
    exit;
  end;
  if (i = 4)then
  begin
    result.id:=289;  //gunpowder
    result.count:=rand.nextInt(10) + 10;
    exit;
  end;
  if (i = 5)then
  begin
    result.id:=287;  //silk/thread
    result.count:=rand.nextInt(12) + 10;
    exit;
  end;
  if (i = 6)then
  begin
    result.id:=325;  //empty bucket
    result.count:=rand.nextInt(3) + 1;
    exit;
  end;
  if (i = 7)and(rand.nextInt(20) = 0)then
  begin
    result.id:=322;  //golden apple
    result.count:=1;
    exit;
  end;
  if (i = 8)and(rand.nextInt(2) = 0)then
  begin
    result.id:=331;  //redstone
    result.count:=rand.nextInt(10) + 5;
    exit;
  end;
  if (i = 9)and(rand.nextInt(5) = 0)then
  begin
    result.id:=2256+rand.nextInt(11); //record
    result.count:=1;
    exit;
  end;
  if (i = 10)then
  begin
    result.id:=351;  //dye
    result.count:=1;
    exit;
  end;
  if (i = 11)then
  begin
    result.id:=264;  //diamond
    result.count:=rand.nextInt(10) + 5;
    exit;
  end;
  if (i = 12)then
  begin
    result.id:=368;  //ender pearl
    result.count:=rand.nextInt(15) + 5;
    exit;
  end;
  result.id:=0;
  result.count:=0;
end;

function pickMobSpawner(rand:rnd):string;
var i:integer;
begin
  i:=rand.nextInt(100);
  case i of
    0..7:result:='Monster';
    8..15:result:='Spider';
    16..29:result:='Creeper';
    30..40:result:='CaveSpider';
    41..49:result:='Slime';
    50..55:result:='PigZombie';
    56..70:result:='Enderman';
    71..82:result:='Blaze';
    83..91:result:='Skeleton';
    92..99:result:='Zombie'
    else result:='Zombie';
  end;
  {i:=rand.nextInt(4);
  if i=0 then result:='Skeleton'
  else if i=1 then result:='Zombie'
  else if i=2 then result:='Zombie'
  else if i=3 then result:='Spider'
  else result:='Blaze';  }
end;

procedure gen_chest_content(map:region; xreg,yreg,x,y,z:integer; rand:rnd);
var tempxot,tempyot,chx,chy,xx,zz,t,t1,k4,k,k3,k2:integer;
st:item_stack;
b:boolean;
begin
  //schitaem koordinati nachalnih i konechnih chankov v regione
  if xreg<0 then
    tempxot:=(xreg+1)*32-32
  else
    tempxot:=xreg*32;

  if yreg<0 then
    tempyot:=(yreg+1)*32-32
  else
    tempyot:=yreg*32;

  dec(tempxot,2);
  dec(tempyot,2);

  //opredelaem, k kakomu chanku otnositsa
  chx:=x;
  chy:=z;

  if chx<0 then inc(chx);
  if chy<0 then inc(chy);

  chx:=chx div 16;
  chy:=chy div 16;

  if (chx<=0)and(x<0) then dec(chx);
  if (chy<=0)and(z<0) then dec(chy);

  //perevodim v koordinati chanka
  xx:=x mod 16;
  zz:=z mod 16;
  if xx<0 then inc(xx,16);
  if zz<0 then inc(zz,16);

  chx:=chx-tempxot;
  chy:=chy-tempyot;

  //delaem sunduk
  map[chx][chy].blocks[xx+zz*16+y*256]:=54;

  t:=length(map[chx][chy].Tile_entities);
  setlength(map[chx][chy].Tile_entities,t+1);
  map[chx][chy].Tile_entities[t].Id:='Chest';
  map[chx][chy].Tile_entities[t].x:=x;
  map[chx][chy].Tile_entities[t].y:=y;
  map[chx][chy].Tile_entities[t].z:=z;
  new(pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data));

  for k4:=0 to 7 do
  begin
    st:=pickCheckLootItem(rand);
    if st.id=0 then continue;
    t1:=length(pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items);
    k3:=rand.nextInt(27);
    b:=false;
    for k:=0 to t1-1 do
      if pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[k].slot=k3 then
      begin
        b:=true;
        k2:=k;
        break;
      end;
    if b=true then
    begin
      pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[k2].id:=st.id;
      pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[k2].count:=st.count;
      if st.id=351 then pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[k2].damage:=3
      else pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[k2].damage:=0;
    end
    else
    begin
      setlength(pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items,t1+1);
      pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[t1].id:=st.id;
      pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[t1].count:=st.count;
      pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[t1].slot:=k3;
      if st.id=351 then pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[t1].damage:=3
      else pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[t1].damage:=0;
    end;
  end;
end;

procedure gen_rand_spawner(map:region; xreg,yreg,x,y,z:integer; rand:rnd);
var tempxot,tempyot,chx,chy,xx,zz,t:integer;
str:string;
begin
  //schitaem koordinati nachalnih i konechnih chankov v regione
  if xreg<0 then
    tempxot:=(xreg+1)*32-32
  else
    tempxot:=xreg*32;

  if yreg<0 then
    tempyot:=(yreg+1)*32-32
  else
    tempyot:=yreg*32;

  dec(tempxot,2);
  dec(tempyot,2);

  //opredelaem, k kakomu chanku otnositsa
  chx:=x;
  chy:=z;

  if chx<0 then inc(chx);
  if chy<0 then inc(chy);

  chx:=chx div 16;
  chy:=chy div 16;

  if (chx<=0)and(x<0) then dec(chx);
  if (chy<=0)and(z<0) then dec(chy);

  //perevodim v koordinati chanka
  xx:=x mod 16;
  zz:=z mod 16;
  if xx<0 then inc(xx,16);
  if zz<0 then inc(zz,16);

  chx:=chx-tempxot;
  chy:=chy-tempyot;

  //delaem spawner
  map[chx][chy].blocks[xx+zz*16+y*256]:=52;

  t:=length(map[chx][chy].Tile_entities);
  setlength(map[chx][chy].Tile_entities,t+1);
  map[chx][chy].Tile_entities[t].Id:='MobSpawner';
  map[chx][chy].Tile_entities[t].x:=x;
  map[chx][chy].Tile_entities[t].y:=y;
  map[chx][chy].Tile_entities[t].z:=z;
  new(pmon_spawn_tile_entity_data(map[chx][chy].Tile_entities[t].data));

  pmon_spawn_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.entityid:=pickMobSpawner(rand);
  pmon_spawn_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.delay:=200;
end;

begin
  i:=x;
  j:=y;
  k:=z;
  byte0:=3;
  l:=rand.nextInt(2) + 2;
  i1:=rand.nextInt(2) + 2;
  j1:=0;
  for k1:=i-l-1 to i+l+1 do
    for j2:=j-1 to j+byte0+1 do
      for i3:=k-i1-1 to k+i1+1 do
      begin
        t:=get_block_id(map,xreg,yreg,k1, j2, i3);
        if (j2 = j - 1)and(not(t in solid_bl))then
        begin
          result:=false;
          exit;
        end;
        if (j2 = j + byte0 + 1)and(not(t in solid_bl))then
        begin
          result:=false;
          exit;
        end;
        if (((k1 = i - l - 1)or(k1 = i + l + 1)or(i3 = k - i1 - 1)or(i3 = k + i1 + 1))and(j2 = j)and(get_block_id(map,xreg,yreg,k1, j2, i3)=0)and(get_block_id(map,xreg,yreg,k1, j2 + 1, i3)=0))then
          inc(j1);
      end;

  if (j1 < 1)or(j1 > 5)then
  begin
    result:=false;
    exit;
  end;

  for l1:=i-l-1 to i+l+1 do
    for k2:=j+byte0 downto j-1 do
      for j3:=k-i1-1 to k+i1+1 do
      begin
        if (l1 = i - l - 1)or(k2 = j - 1)or(j3 = k - i1 - 1)or(l1 = i + l + 1)or(k2 = j + byte0 + 1)or(j3 = k + i1 + 1)then
        begin
          if (k2 >= 0)and(not(get_block_id(map,xreg,yreg,l1, k2 - 1, j3) in solid_bl))then
          begin
            set_block_id(map,xreg,yreg,l1, k2, j3, 0);
            continue;
          end;
          if (not(get_block_id(map,xreg,yreg,l1, k2, j3) in solid_bl))then
            continue;
          if (k2 = j - 1)and(rand.nextInt(4) <> 0)then
            set_block_id(map,xreg,yreg,l1, k2, j3, 48)
          else
            set_block_id(map,xreg,yreg,l1, k2, j3, 4);
        end
        else
          set_block_id(map,xreg,yreg,l1, k2, j3, 0);
      end;

  for i2:=0 to 1 do
  begin
    for l2:=0 to 2 do
    begin
      k3:=(i + rand.nextInt(l * 2 + 1)) - l;
      l3:=j;
      i4:=(k + rand.nextInt(i1 * 2 + 1)) - i1;
      if (get_block_id(map,xreg,yreg,k3, l3, i4)<>0)then
        continue;
      j4:=0;
      if (get_block_id(map,xreg,yreg,k3 - 1, l3, i4)in solid_bl)then inc(j4);
      if (get_block_id(map,xreg,yreg,k3 + 1, l3, i4)in solid_bl)then inc(j4);
      if (get_block_id(map,xreg,yreg,k3, l3, i4 - 1)in solid_bl)then inc(j4);
      if (get_block_id(map,xreg,yreg,k3, l3, i4 + 1)in solid_bl)then inc(j4);
      if (j4 <> 1)then continue;

      gen_chest_content(map,xreg,yreg,k3, l3, i4,rand);
      goto label0;
    end;
    label0:
  end;

  gen_rand_spawner(map,xreg,yreg,i,j,k,rand);

  result:=true;
end;

function gen_lakes_notch(map:region; xreg,yreg,x,y,z,id:integer; rand:rnd):boolean;
var l,i1,l4,i5,j5,j1,k2,l3,t,k1,l2,i4,l1,i3,j4,i2,j3,k4,j2,k3,byte0:integer;
aflag:ar_boolean;
d,d1,d2,d3,d4,d5,d6,d7,d8,d9:double;
flag,flag1,tf:boolean;
i,j,k:integer;
begin
  i:=x;
  j:=y;
  k:=z;

  i:=i-8;
  k:=k-8;
  while (j>0)and(get_block_id(map,xreg,yreg,i,j,k)=0) do
    dec(j);
  j:=j-4;
  setlength(aflag,2048);
  l:=rand.nextInt(4) + 4;

  for i1:=0 to l-1 do
  begin
    d:=rand.nextDouble() * 6 + 3;
    d1:=rand.nextDouble() * 4 + 2;
    d2:=rand.nextDouble() * 6 + 3;
    d3:=rand.nextDouble() * (16 - d - 2) + 1 + d / 2;
    d4:=rand.nextDouble() * (8 - d1 - 4) + 2 + d1 / 2;
    d5:=rand.nextDouble() * (16 - d2 - 2) + 1 + d2 / 2;
    for l4:=1 to 14 do
      for i5:=1 to 14 do
        for j5:=1 to 6 do
        begin
          d6:=(l4 - d3) / (d / 2);
          d7:=(j5 - d4) / (d1 / 2);
          d8:=(i5 - d5) / (d2 / 2);
          d9:=d6 * d6 + d7 * d7 + d8 * d8;
          if (d9 < 1)then aflag[(l4 * 16 + i5) * 8 + j5]:=true;
        end;
  end;

  for j1:=0 to 15 do
    for k2:=0 to 15 do
      for l3:=0 to 7 do
      begin
        //?????????????
        //flag:=not(aflag[(j1 * 16 + k2) * 8 + l3])and((j1 < 15) and aflag[((j1 + 1) * 16 + k2) * 8 + l3] or (j1 > 0) and aflag[((j1 - 1) * 16 + k2) * 8 + l3] or (k2 < 15) and aflag[(j1 * 16 + (k2 + 1)) * 8 + l3] or (k2 > 0) and aflag[(j1 * 16 + (k2 - 1)) * 8 + l3] or (l3 < 7) and aflag[(j1 * 16 + k2) * 8 + (l3 + 1)] or (l3 > 0) and aflag[(j1 * 16 + k2) * 8 + (l3 - 1)]);
        flag:=not(aflag[(j1 * 16 + k2) * 8 + l3]);
        if (j1<15) then tf:=aflag[((j1 + 1) * 16 + k2) * 8 + l3]
        else tf:=false;
        if j1>0 then tf:=tf or aflag[((j1 - 1) * 16 + k2) * 8 + l3];
        if k2<15 then tf:=tf or aflag[(j1 * 16 + (k2 + 1)) * 8 + l3];
        if k2>0 then tf:=tf or aflag[(j1 * 16 + (k2 - 1)) * 8 + l3];
        if l3<7 then tf:=tf or aflag[(j1 * 16 + k2) * 8 + (l3 + 1)];
        if l3>0 then tf:=tf or aflag[(j1 * 16 + k2) * 8 + (l3 - 1)];

        flag:=flag and tf;
        //flag:= not(aflag[(j1 * 16 + k2) * 8 + l3])and(((j1 < 15) and aflag[((j1 + 1) * 16 + k2) * 8 + l3]) or ((j1 > 0) and aflag[((j1 - 1) * 16 + k2) * 8 + l3])or((k2 < 15) and aflag[(j1 * 16 + (k2 + 1)) * 8 + l3])or((k2 > 0) and aflag[(j1 * 16 + (k2 - 1)) * 8 + l3])or((l3 < 7) and aflag[(j1 * 16 + k2) * 8 + (l3 + 1)])or((l3 > 0) and aflag[(j1 * 16 + k2) * 8 + (l3 - 1)]));
        if not(flag)then continue;
        t:=get_block_id(map,xreg,yreg,i + j1, j + l3, k + k2);
        if (l3 >= 4)and((t=8)or(t=9))then
        begin
          setlength(aflag,0);
          result:=false;
          exit;
        end;
        if (l3 < 4)and(not(t in solid_bl))and(t <> id)then
        begin
          setlength(aflag,0);
          result:=false;
          exit;
        end;
      end;

  for k1:=0 to 15 do
    for l2:=0 to 15 do
      for i4:=0 to 7 do
      begin
        if (aflag[(k1 * 16 + l2) * 8 + i4])then
          if i4<4 then set_block_id(map,xreg,yreg,i + k1, j + i4, k + l2,id)
          else set_block_id(map,xreg,yreg,i + k1, j + i4, k + l2,0);
      end;

  for l1:=0 to 15 do
    for i3:=0 to 15 do
      for j4:=4 to 7 do
      begin
        if ((not (aflag[(l1 * 16 + i3) * 8 + j4]))or(get_Block_Id(map,xreg,yreg,i + l1, (j + j4) - 1, k + i3) <> 3)) then
          continue;
        {genbase:=manager_save.getBiomeGenAt(i + l1, k + i3);
        if (genbase.topBlock = 110) then
          set_block_id(map,xreg,yreg,i + l1, (j + j4) - 1, k + i3,110)
        else  }
          set_block_id(map,xreg,yreg,i + l1, (j + j4) - 1, k + i3,2);
      end;

  if (id=10)or(id=11) then
    for i2:=0 to 15 do
      for j3:=0 to 15 do
        for k4:=0 to 7 do
        begin
          //???????????????????????????
          //flag1:=not(aflag[(i2 * 16 + j3) * 8 + k4])and((i2 < 15)and aflag[((i2 + 1) * 16 + j3) * 8 + k4] or (i2 > 0)and aflag[((i2 - 1) * 16 + j3) * 8 + k4] or (j3 < 15)and aflag[(i2 * 16 + (j3 + 1)) * 8 + k4] or (j3 > 0)and aflag[(i2 * 16 + (j3 - 1)) * 8 + k4] or (k4 < 7)and aflag[(i2 * 16 + j3) * 8 + (k4 + 1)] or (k4 > 0)and aflag[(i2 * 16 + j3) * 8 + (k4 - 1)]);
          //flag1:=(not(aflag[(i2 * 16 + j3) * 8 + k4]))and((i2 < 15) and aflag[((i2 + 1) * 16 + j3) * 8 + k4])or((i2 > 0) and aflag[((i2 - 1) * 16 + j3) * 8 + k4])or((j3 < 15) and aflag[(i2 * 16 + (j3 + 1)) * 8 + k4])or((j3 > 0) and aflag[(i2 * 16 + (j3 - 1)) * 8 + k4])or((k4 < 7) and aflag[(i2 * 16 + j3) * 8 + (k4 + 1)])or((k4 > 0) and aflag[(i2 * 16 + j3) * 8 + (k4 - 1)]);
          flag1:=not(aflag[(i2 * 16 + j3) * 8 + k4]);
          if i2<15 then tf:=aflag[((i2 + 1) * 16 + j3) * 8 + k4]
          else tf:=false;
          if i2>0 then tf:=tf or aflag[((i2 - 1) * 16 + j3) * 8 + k4];
          if j3<15 then tf:=tf or aflag[(i2 * 16 + (j3 + 1)) * 8 + k4];
          if j3>0 then tf:=tf or aflag[(i2 * 16 + (j3 - 1)) * 8 + k4];
          if k4<7 then tf:=tf or aflag[(i2 * 16 + j3) * 8 + (k4 + 1)];
          if k4>0 then tf:=tf or aflag[(i2 * 16 + j3) * 8 + (k4 - 1)];

          flag1:=flag1 and tf;
          if (flag1)and((k4 < 4)or(rand.nextInt(2) <> 0)) and (get_block_id(map,xreg,yreg,i + i2, j + k4, k + j3)in solid_bl)then
            set_block_id(map,xreg,yreg,i + i2, j + k4, k + j3,1);
        end;

  //stavim spawn trostnika
  if (id=8)or(id=9) then
  begin
    byte0:=length(obj);
    setlength(obj,byte0+1);
    obj[byte0].x:=i+8;
    obj[byte0].z:=k+8;
    obj[byte0].y:=j+4;
    obj[byte0].id:=38;   //reed patch

    byte0:=length(obj);
    setlength(obj,byte0+1);
    obj[byte0].x:=i+8;
    obj[byte0].z:=k+8;
    obj[byte0].y:=j+4;
    obj[byte0].id:=41;   //lily pad patches
  end;

  byte0:=length(obj);
  setlength(obj,byte0+1);
  obj[byte0].x:=i+8;
  obj[byte0].z:=k+8;
  obj[byte0].y:=j+4;
  obj[byte0].id:=39;   //clay patches

  {if (id=8)or(id=9) then
    for j2:=0 to 15 do
      for k3:=0 to 15 do
      begin
        byte0:=4;
        if (func_40471_p(map,xreg,yreg,i + j2, j + byte0, k + k3))then
          set_block_id(map,xreg,yreg,i + j2, j + byte0, k + k3,79);
      end;  }

  setlength(aflag,0);
  result:=true;
end;

procedure gen_pumpkins_patch(map:region; xreg,yreg,x,y,z,id:integer; sid:int64);
var r:rnd;
i,j,k,l,t:integer;
begin
  r:=rnd.Create(sid);
  for i:=0 to 63 do
  begin
    j:=x+r.nextInt(8)-r.nextInt(8);
    k:=y+r.nextInt(6)-r.nextInt(6);
    l:=z+r.nextInt(8)-r.nextInt(8);
    t:=get_block_id(map,xreg,yreg,j,k-1,l);
    if (get_block_id(map,xreg,yreg,j,k,l)=0)and((t=2)or(t=3)) then
      if id=103 then set_block_id_data(map,xreg,yreg,j,k,l,id,0)
      else set_block_id_data(map,xreg,yreg,j,k,l,id,r.nextInt(4));
  end;
  r.Free;
end;

function gen_bigtree_notch(map:region; xreg,yreg,x,y,z:integer; sid:int64):boolean;
var rr:rnd;
basepos:array[0..2] of integer;
otherCoordPairs:array[0..5] of byte;
heightLimit,height,trunkSize,heightLimitLimit,leafDistanceLimit:integer;
leafNodes:array of array of integer;
field_874_i,field_873_j,field_872_k,heightAttenuation:extended;

  procedure Init;
  begin
    rr:=rnd.Create;
    heightLimit:=0;
    heightAttenuation:=0.61799999999999999;
    field_874_i:=0.38100000000000001;
    field_873_j:=1;
    field_872_k:=1;
    trunkSize:=1;
    heightLimitLimit:=12;
    leafDistanceLimit:=4;

    otherCoordPairs[0]:=2;
    otherCoordPairs[1]:=0;
    otherCoordPairs[2]:=0;
    otherCoordPairs[3]:=1;
    otherCoordPairs[4]:=2;
    otherCoordPairs[5]:=1;

    SetRoundMode(rmDown);
  end;

  procedure Destroy;
  var i:integer;
  begin
    rr.Free;

    for i:=0 to length(leafNodes)-1 do
      setlength(leafNodes[i],0);
    setlength(leafNodes,0);

    SetRoundMode(rmNearest);
  end;

  procedure func_517_a(d,d1,d2:double);
begin
  heightLimitLimit:=trunc(d*12);
  if d>0.5 then leafDistanceLimit:=5;
  field_873_j:=d1;
  field_872_k:=d2;
end;

function leafNodeNeedsBase(i:integer):boolean;
begin
  result:=(i>=(heightLimit * 0.20000000000000001));
end;

procedure placeBlockLine(map:region; xreg,yreg:integer; ai,ai1:array of integer; i:integer);
var ai2,ai3:array[0..2]of integer;
byte0,byte1,byte2:byte;
byte3,j,k:integer;
d,d1:double;
begin
  j:=0;
  for byte0:=0 to 2 do
  begin
    ai2[byte0]:=ai1[byte0]-ai[byte0];
    if abs(ai2[byte0])>abs(ai2[j]) then j:=byte0;
  end;

  if ai2[j]=0 then exit;

  byte1:=otherCoordPairs[j];
  byte2:=otherCoordPairs[j+3];
  if(ai2[j]>0) then byte3:=1
  else byte3:=-1;

  d:=ai2[byte1]/ai2[j];
  d1:=ai2[byte2]/ai2[j];

  k:=0;
  while k<>(ai2[j]+byte3) do
  begin
    ai3[j]:=round(ai[j]+k+0.5);
    ai3[byte1]:=round(ai[byte1]+k*d+0.5);
    ai3[byte2]:=round(ai[byte2]+k*d1+0.5);
    set_block_id(map,xreg,yreg,ai3[0],ai3[1],ai3[2],i);

    k:=k+byte3;
  end;
end;

procedure generateLeafNodeBases(map:region;xreg,yreg:integer);
var i:integer;
ai,ai2:array[0..2]of integer;
begin
  for i:=0 to 2 do
    ai[i]:=basepos[i];

  for i:=0 to length(leafNodes)-1 do
  begin
    ai2[0]:=leafNodes[i][0];
    ai2[1]:=leafNodes[i][1];
    ai2[2]:=leafNodes[i][2];

    ai[1]:=leafNodes[i][3];
    if leafNodeNeedsBase(ai[1]-basePos[1]) then placeBlockLine(map,xreg,yreg,ai,ai2,17);
  end;
end;

procedure generateTrunk(map:region; xreg,yreg:integer);
var ai,ai1:array[0..2]of integer;
i,j,k,l:integer;
begin
  i:=basePos[0];
  j:=basePos[1];
  k:=basePos[1]+height;
  l:=basePos[2];

  ai[0]:=i;
  ai[1]:=j;
  ai[2]:=l;

  ai1[0]:=i;
  ai1[1]:=k;
  ai1[2]:=l;

  placeBlockLine(map,xreg,yreg,ai,ai1,17);

  if trunkSize=2 then
  begin
    inc(ai[0]);
    inc(ai1[0]);
    placeBlockLine(map,xreg,yreg,ai, ai1, 17);
    inc(ai[2]);
    inc(ai1[2]);
    placeBlockLine(map,xreg,yreg,ai, ai1, 17);
    dec(ai[0]);
    dec(ai1[0]);
    placeBlockLine(map,xreg,yreg,ai, ai1, 17);
  end;
end;

function func_528_a(i:integer):double;
var f,f1,f2:double;
begin
  if i<(heightlimit*0.29999999999999999) then
  begin
    result:=-1.618;
    exit;
  end;

  f:=heightlimit/2;
  f1:=heightlimit/2-i;
  if f1=0 then f2:=f
  else if abs(f1)>=f then f2:=0
  else f2:=sqrt(sqr(f)-sqr(f1));

  f2:=f2*0.5;
  result:=f2;
end;

procedure func_523_a(map:region; xreg,yreg,i,j,k:integer; f:double; byte0:byte; l:integer);
var i1,j1,l1,i2:integer;
byte1,byte2:byte;
ai,ai1:array[0..2]of integer;
d:extended;
begin
  i1:=trunc(f+0.61799999999999999);
  byte1:=otherCoordPairs[byte0];
  byte2:=otherCoordPairs[byte0+3];

  ai[0]:=i;
  ai[1]:=j;
  ai[2]:=k;

  ai1[0]:=0;
  ai1[1]:=0;
  ai1[2]:=0;

  j1:=-i1;
  ai1[byte0]:=ai[byte0];

  while j1<=i1 do
  begin
    ai1[byte1]:=ai[byte1]+j1;

    l1:=-i1;
    while l1<=i1 do
    begin
      d:=sqrt(sqr(abs(j1)+0.5)+sqr(abs(l1)+0.5));
      if d>f then inc(l1)
      else
      begin
        ai1[byte2]:=ai[byte2]+l1;
        i2:=get_block_id(map,xreg,yreg,ai1[0],ai1[1],ai1[2]);
        if (i2<>0)and(i2<>18) then inc(l1)
        else
        begin
          set_block_id(map,xreg,yreg,ai1[0],ai1[1],ai1[2],l);
          inc(l1);
        end;
      end;
    end;

    inc(j1);
  end;
end;

function func_526_b(i:integer):double;
begin
  if (i<0)or(i>leafDistanceLimit) then
  begin
    result:=-1;
    exit;
  end;

  if (i<>0)and(i<>(leafDistanceLimit-1)) then result:=3
  else result:=2;
end;

procedure generateLeafNode(map:region; xreg,yreg,i,j,k:integer);
var l:integer;
begin
  for l:=j to j+leafDistanceLimit-1 do
    func_523_a(map,xreg,yreg,i,l,k,func_526_b(l-j),1,18);
end;

procedure generateLeaves(map:region; xreg,yreg:integer);
var i:integer;
begin
  for i:=0 to length(leafNodes)-1 do
    generateLeafNode(map,xreg,yreg,leafNodes[i][0],leafNodes[i][1],leafNodes[i][2]);
end;

function checkBlockLine(map:region; xreg,yreg:integer; ai,ai1:array of integer):integer;
var ai2,ai3:array[0..2]of integer;
i,t,j,k,l,byte3:integer;
byte1,byte2:byte;
d,d1:double;
begin
  t:=0;
  for i:=0 to 2 do
  begin
    ai2[i]:=ai1[i]-ai[i];
    if abs(ai2[i])>abs(ai2[t]) then t:=i;
  end;

  if ai2[t]=0 then
  begin
    result:=-1;
    exit;
  end;

  byte1:=otherCoordPairs[t];
  byte2:=otherCoordPairs[t+3];
  if (ai2[t]>0) then byte3:=1 else byte3:=-1;

  d:=ai2[byte1]/ai2[t];
  d1:=ai2[byte2]/ai2[t];

  j:=0;
  k:=ai2[t]+byte3;

  repeat
    if j=k then break;

    ai3[t]:=ai[t]+j;
    ai3[byte1]:=round(ai[byte1]+j*d);
    ai3[byte2]:=round(ai[byte2]+j*d1);
    l:=get_block_id(map,xreg,yreg,ai3[0],ai3[1],ai3[2]);

    if(l<>0)and(l<>18)and(l<>31) then break;
    j:=j+byte3;
  until false;

  if (j=k) then
    result:=-1
  else
    result:=abs(j);
end;

procedure generateLeafNodeList(map:region; xreg,yreg:integer);
var i,j,k,l,i1,j1,k1,l1:integer;
ai:array of array of integer;
ai1,ai2,ai3:array[0..2]of integer;
f,d1,d2,d4:double;
begin
  height:=trunc(heightlimit*heightAttenuation);
  if height>=heightlimit then height:=height-heightlimit;

  i:=trunc(1.3819999999999999+power((field_872_k*heightlimit)/13,2));
  if i<1 then i:=1;

  setlength(ai,i*heightlimit);
  for j:=0 to length(ai)-1 do
    setlength(ai[j],4);

  j:=(basepos[1]+heightlimit)-leafDistanceLimit;
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
      while j1<i do
      begin
        d1:=field_873_j*(f*(rr.nextDouble+0.32800000000000001));
        d2:=rr.nextDouble*2*3.1415899999999999;

        k1:=round(d1*sin(d2)+basepos[0]+0.5);
        l1:=round(d1*cos(d2)+basepos[2]+0.5);

        ai1[0]:=k1;
        ai1[1]:=j;
        ai1[2]:=l1;

        ai2[0]:=k1;
        ai2[1]:=j+leafDistanceLimit;
        ai2[2]:=l1;

        if checkBlockLine(map,xreg,yreg,ai1,ai2)<>-1 then
        begin
          inc(j1);
          continue;
        end;

        ai3[0]:=basepos[0];
        ai3[1]:=basepos[1];
        ai3[2]:=basepos[2];

        d4:=sqrt(sqr(basepos[0]-ai1[0])+sqr(basepos[2]-ai1[2]))*field_874_i;

        if(ai1[1]-d4)>l then ai3[1]:=l
        else ai3[1]:=trunc(ai1[1]-d4);

        if checkBlockLine(map,xreg,yreg,ai3,ai1)=-1 then
        begin
          ai[k][0]:=k1;
          ai[k][1]:=j;
          ai[k][2]:=l1;
          ai[k][3]:=ai3[1];
          inc(k);
        end;

        inc(j1);
      end;
      dec(j);
      dec(i1);
    end;
  end;

  setlength(leafNodes,k);
  for j1:=0 to k-1 do
    setlength(leafNodes[j1],4);

  for j1:=0 to k-1 do
    for k1:=0 to 3 do
      leafNodes[j1][k1]:=ai[j1][k1];

  for j1:=0 to length(ai)-1 do
    setlength(ai[j1],0);
  setlength(ai,0);
end;

function validTreeLocation(map:region; xreg,yreg:integer):boolean;
var ai,ai1:array[0..2] of integer;
i:integer;
begin
  for i:=0 to 2 do
  begin
    ai[i]:=basepos[i];
    if i=1 then ai1[i]:=basepos[i]+heightlimit-1
    else ai1[i]:=basepos[i];
  end;
  i:=get_block_id(map,xreg,yreg,basepos[0],basepos[1]-1,basepos[2]);
  if (i<>2)and(i<>3) then
  begin
    result:=false;
    exit;
  end;
  i:=checkBlockLine(map,xreg,yreg,ai,ai1);

  if i=-1 then
  begin
    result:=true;
    exit;
  end;
  if (i<6) then
    result:=false
  else
  begin
    heightlimit:=i;
    result:=true;
  end;
end;

begin
  init;

  rr.SetSeed(sid);
  basepos[0]:=x;
  basepos[1]:=y;
  basepos[2]:=z;

  if heightlimit=0 then heightlimit:=5+rr.nextInt(heightlimitlimit);

  if validTreeLocation(map,xreg,yreg)=false then
  begin
    result:=false;
  end
  else
  begin
    generateLeafNodeList(map,xreg,yreg);
    generateLeaves(map,xreg,yreg);
    generateTrunk(map,xreg,yreg);
    generateLeafNodeBases(map,xreg,yreg);
    result:=true;
  end;
  destroy;
end;

procedure gen_vines_jungle_notch(map:region; xreg,yreg,x,y,z:integer; sid:int64);
var rand:rnd;
i,j,k:integer;

  procedure gen_vines(map:region; xreg,yreg,x,y,z:integer; sid:int64);
  var data,l_u,l_d,l_l,l_r,max,i:integer;
  r:rnd;
  begin
    r:=rnd.Create(sid);

    i:=get_block_id(map,xreg,yreg,x,y,z+1);
    if not(i in solid_bl) then l_u:=0
    else l_u:=r.nextInt(7)+4;

    i:=get_block_id(map,xreg,yreg,x,y,z-1);
    if not(i in solid_bl) then l_d:=0
    else l_d:=r.nextInt(7)+4;

    i:=get_block_id(map,xreg,yreg,x-1,y,z);
    if not(i in solid_bl) then l_l:=0
    else l_l:=r.nextInt(7)+4;

    i:=get_block_id(map,xreg,yreg,x+1,y,z);
    if not(i in solid_bl) then l_r:=0
    else l_r:=r.nextInt(7)+4;

    max:=l_u;
    if l_d>max then max:=l_d;
    if l_l>max then max:=l_l;
    if l_r>max then max:=l_r;

    l_u:=y-l_u;
    l_d:=y-l_d;
    l_l:=y-l_l;
    l_r:=y-l_r;

    max:=y-max;
    if max<0 then max:=0;

    for i:=y downto max+1 do
    begin
      if get_block_id(map,xreg,yreg,x,i,z)<>0 then break;

      data:=0;
      if i>l_u then data:=data or 1;
      if i>l_d then data:=data or 4;
      if i>l_l then data:=data or 2;
      if i>l_r then data:=data or 8;
      set_block_id_data(map,xreg,yreg,x,i,z,106,data);
    end;

    r.Free;
  end;

begin
  rand:=rnd.Create(sid);
  i:=x;
  j:=y;
  k:=z;

  while j<256 do
  begin
    if get_block_id(map,xreg,yreg,i,j,k)=0 then
    begin
      {if (get_block_id(map,xreg,yreg,i,j,k+1) in solid_bl) then
      begin
        set_block_id_data(map,xreg,yreg,i,j,k,106,1);
        inc(j);
        continue;
      end;
      if (get_block_id(map,xreg,yreg,i-1,j,k) in solid_bl) then
      begin
        set_block_id_data(map,xreg,yreg,i,j,k,106,2);
        inc(j);
        continue;
      end;
      if (get_block_id(map,xreg,yreg,i,j,k-1) in solid_bl) then
      begin
        set_block_id_data(map,xreg,yreg,i,j,k,106,4);
        inc(j);
        continue;
      end;
      if (get_block_id(map,xreg,yreg,i+1,j,k) in solid_bl) then
      begin
        set_block_id_data(map,xreg,yreg,i,j,k,106,8);
        inc(j);
        continue;
      end; }
      gen_vines(map,xreg,yreg,i,j,k,sid);
      inc(j);
      continue;
    end;

    inc(j);
    i:=x+rand.nextInt(4)-rand.nextInt(4);
    k:=z+rand.nextInt(4)-rand.nextInt(4);
  end;
end;

function gen_nether_wart(map:region; xreg,yreg,x,y,z:integer; sid:int64):boolean;
var rand:rnd;
begin
  rand:=rnd.Create(sid);

  if get_block_id(map,xreg,yreg,x,y-1,z)=87 then
  begin
    set_block_id_data(map,xreg,yreg,x,y,z,115,rand.nextInt(4));
    result:=true;
  end
  else result:=false;

  rand.Free;
end;

function gen_glowstone_hell(map:region; xreg,yreg,x,y,z:integer):boolean;
begin
  if (get_block_id(map,xreg,yreg,x-1,y,z)<>0)and
  (get_block_id(map,xreg,yreg,x+1,y,z)<>0)and
  (get_block_id(map,xreg,yreg,x,y,z-1)<>0)and
  (get_block_id(map,xreg,yreg,x,y,z+1)<>0)and
  (get_block_id(map,xreg,yreg,x,y-1,z)<>0)and
  (get_block_id(map,xreg,yreg,x,y+1,z)<>0)and
  (get_block_id(map,xreg,yreg,x,y,z)=87)then
  begin
    set_block_id_data(map,xreg,yreg,x,y,z,89,0);
    result:=true
  end
  else
    result:=false;
end;

procedure gen_lily_lakes_patch(map:region; xreg,yreg,x,y,z:integer; sid:int64);
var xx,zz:integer;
rand:rnd;
begin
  rand:=rnd.Create(sid);

  for xx:=x-8 to x+8 do
    for zz:=z-8 to z+8 do
      if (get_block_id(map,xreg,yreg,xx,y-1,zz)=9)and(get_block_id(map,xreg,yreg,xx,y,zz)=0)and
      (rand.nextDouble<0.09)then
        set_block_id_data(map,xreg,yreg,xx,y,zz,111,0);

  rand.Free;
end;

procedure gen_clay_lakes_patch(map:region; xreg,yreg,x,y,z:integer; sid:int64);
var xx,yy,zz:integer;
rand:rnd;
begin
  rand:=rnd.Create(sid);

  for xx:=x-12 to x+12 do
    for zz:=z-12 to z+12 do
      for yy:=y-8 to y+8 do
        if(get_block_id(map,xreg,yreg,xx,yy,zz)=1)and(rand.nextDouble<0.02)then
          set_block_id_data(map,xreg,yreg,xx,yy,zz,82,0); 

  rand.Free;
end;

procedure gen_reed_lakes_patch(map:region; xreg,yreg,x,y,z:integer; sid:int64);
var i,xx,zz:integer;
rand:rnd;

  procedure place_reed;
  var t1,t2,t3,t4,tt:integer;
  begin
    tt:=get_block_id(map,xreg,yreg,xx,y-1,zz);
    if (get_block_id(map,xreg,yreg,xx,y,zz)=0)and(tt in solid_bl) then
    begin
      t1:=get_block_id(map,xreg,yreg,xx-1,y-1,zz);
      t2:=get_block_id(map,xreg,yreg,xx+1,y-1,zz);
      t3:=get_block_id(map,xreg,yreg,xx,y-1,zz-1);
      t4:=get_block_id(map,xreg,yreg,xx,y-1,zz+1);

      if ((t1=8)or(t1=9)or(t2=8)or(t2=9)or(t3=8)or(t3=9)or
      (t4=8)or(t4=9))and(rand.nextDouble<0.3) then
      begin
        t1:=1+rand.nextInt(4);
        for t2:=y to y+t1 do
          if get_block_id(map,xreg,yreg,xx,t2,zz)=0 then
            set_block_id_data(map,xreg,yreg,xx,t2,zz,83,0)
          else break;

        if (tt<>2)and(tt<>3)and(tt<>12)and(tt<>13) then
        begin
          if rand.nextDouble<0.2 then set_block_id_data(map,xreg,yreg,xx,y-1,zz,2,0)
          else set_block_id_data(map,xreg,yreg,xx,y-1,zz,3,0);
        end;
      end;
    end;
  end;

begin
  rand:=rnd.Create(sid);
  {for i:=0 to 50 do
  begin
    xx:=x+rand.nextInt(9)-rand.nextInt(9);
    zz:=z+rand.nextInt(9)-rand.nextInt(9);
    place_reed;
  end;  }

  for xx:=x-8 to x+8 do
    for zz:=z-8 to z+8 do
    begin
      place_reed;
    end;

  rand.Free;
  //set_block_id_data(map,xreg,yreg,x,y,z,89,0);
end;

function gen_shrub_notch(map:region; xreg,yreg,x,y,z,id_wood,data_wood,id_leaves,data_leaves:integer; sid:int64):boolean;
var t:integer;
k,l,i1,j1,k1,l1,i2:integer;
rand:rnd;
begin
  t:=get_block_id(map,xreg,yreg,x,y-1,z);
  if (t=2)or(t=3)then
  begin
    rand:=rnd.Create(sid);
    set_block_id_data(map,xreg,yreg,x,y,z,id_wood,data_wood);
    for k:=y to y+2 do
    begin
      l:=k - y;
      i1:=2 - l;
      for j1:=x-i1 to x+i1 do
      begin
        k1:=j1 - x;
        for l1:=z-i1 to z+i1 do
        begin
          i2:= l1 - z;
          if ((abs(k1)<>i1)or(abs(i2)<>i1)or(rand.nextInt(2)<>0))and(not(get_block_id(map,xreg,yreg,j1,k,l1)in solid_bl))then
            set_block_id_data(map,xreg,yreg,j1,k,l1,id_leaves,data_leaves);
        end;
      end;
    end;
    rand.Free;
    result:=true;
  end
  else
    result:=false;
end;

function gen_huge_tree_notch(map:region; xreg,yreg,x,y,z,len,id_wood,data_wood,id_leaves,data_leaves:integer; sid:int64):boolean;
var par3,par4,par5:integer;
i,byte0,j,i1,k1,k2,k,l,l1,l2,j3,i2,i3,j1,j2:integer;
f:double;
rand:rnd;
flag:boolean;

  procedure func_48192_a(map:region; xreg,yreg,par2,par3,par4,par5:integer; rand1:rnd);
  var byte0,i,j,l,i1,j1,k1:integer;
  begin
    byte0:=2;

    for i:=par4-byte0 to par4 do
    begin
      j:=i - par4;
      k:=(par5 + 1) - j;

      for l:=par2-k to par2+k+1 do
      begin
        i1:=l - par2;

        for j1:=par3-k to par3+k+1 do
        begin
          k1:=j1 - par3;

          if ((i1>=0)or(k1>=0)or(i1*i1+k1*k1<=k*k))and((i1<=0)or(k1<=0)or(i1*i1+k1*k1<=(k+1)*(k+1)))and((rand1.nextInt(4)<>0)or(i1*i1+k1*k1<=(k-1)*(k-1)))then
            //set_block_id_data(map,xreg,yreg,l, i, j1,id_leaves,data_leaves);
            set_block_id_data(map,xreg,yreg,l, i, j1,18,3);
        end;
      end;
    end;
  end;

begin
  par3:=x;
  par4:=y;
  par5:=z;
  rand:=rnd.Create(sid);
  i:=rand.nextInt(3) + len;
  flag:=true;
  if (par4 < 1)or(par4 + i + 1 > 256)then
  begin
    result:=false;
    rand.Free;
    exit;
  end;

  for j:=par4 to par4+1+i do
  begin
    byte0:=2;
    if (j = par4)then byte0:=1;
    if (j >= (par4 + 1 + i) - 2) then byte0:=2;

    for i1:=par3-byte0 to par3+byte0 do
    begin
      if flag=false then break;
      for k1:=par5-byte0 to par5+byte0 do
      begin
        if flag=false then break;
        if (j >= 0)and(j < 256)then
        begin
          k2:=get_block_id(map,xreg,yreg,i1,j,k1);
          if (k2 <> 0)and(k2<>18)and(k2<>2)and(k2<>3)and(k2<>17)and(k2<>6)then
            flag:=false;
        end
        else flag:=false;
      end;
    end;
  end;

  if not(flag)then
  begin
    result:=false;
    rand.Free;
    exit;
  end;

  k:=get_block_id(map,xreg,yreg,par3, par4 - 1, par5);

  if ((k<>2)and(k<>3))or(par4 >= 256 - i - 1)then
  begin
    result:=false;
    rand.Free;
    exit;
  end;

  set_block_id(map,xreg,yreg,par3, par4 - 1, par5,3);
  set_block_id(map,xreg,yreg,par3+1, par4 - 1, par5,3);
  set_block_id(map,xreg,yreg,par3, par4 - 1, par5+1,3);
  set_block_id(map,xreg,yreg,par3+1, par4 - 1, par5+1,3);

  func_48192_a(map,xreg,yreg, par3, par5, par4 + i, 2, rand);

  l:=(par4 + i) - 2 - rand.nextInt(4);
  while (l > par4 + i / 2) do
  begin
    f:=rand.nextFloat() * Pi * 2;
    l1:=par3 + trunc(0.5 + MathHelper_u.math_cos(f) * 4);
    l2:=par5 + trunc(0.5 + MathHelper_u.math_sin(f) * 4);
    func_48192_a(map,xreg,yreg, l1, l2, l, 0, rand);

    for j3:=0 to 4 do
    begin
      i2:=par3 + trunc(1.5 + MathHelper_u.math_cos(f) * j3);
      i3:=par5 + trunc(1.5 + MathHelper_u.math_sin(f) * j3);
      set_block_id_data(map,xreg,yreg,i2, (l - 3) + (j3 div 2), i3, id_wood, data_wood);
    end;
    l:=l-(2 + rand.nextInt(4));
  end;

  for j1:=0 to i-1 do
  begin
    j2:=get_block_id(map,xreg,yreg,par3, par4 + j1, par5);

    if (j2 = 0)or(j2 = id_leaves)then
    begin
      set_block_id_data(map,xreg,yreg,par3, par4 + j1, par5,id_wood,data_wood);

      if (j1 > 0)then
      begin
        if (rand.nextInt(3) > 0)and(get_block_id(map,xreg,yreg,par3 - 1, par4 + j1, par5)=0)then
          set_block_id_data(map,xreg,yreg,par3 - 1, par4 + j1, par5,106,8);

        if (rand.nextInt(3) > 0)and(get_block_id(map,xreg,yreg,par3, par4 + j1, par5 - 1)=0)then
          set_block_id_data(map,xreg,yreg,par3, par4 + j1, par5 - 1,106,1);
      end;
    end;

    if (j1 >= i - 1)then continue;

    j2:=get_block_id(map,xreg,yreg,par3 + 1, par4 + j1, par5);

    if (j2 = 0)or(j2 = id_leaves)then
    begin
      set_block_id_data(map,xreg,yreg,par3 + 1, par4 + j1, par5,id_wood,data_wood);

      if (j1 > 0)then
      begin
        if (rand.nextInt(3) > 0)and(get_block_id(map,xreg,yreg,par3 + 2, par4 + j1, par5)=0)then
          set_block_id_data(map,xreg,yreg,par3 + 2, par4 + j1, par5,106,2);

        if (rand.nextInt(3) > 0)and(get_block_id(map,xreg,yreg,par3 + 1, par4 + j1, par5 - 1)=0)then
          set_block_id_data(map,xreg,yreg,par3 + 1, par4 + j1, par5 - 1,106,1);
      end;
    end;

    j2:=get_block_id(map,xreg,yreg,par3 + 1, par4 + j1, par5 + 1);

    if (j2 = 0)or(j2 = id_leaves)then
    begin
      set_block_id_data(map,xreg,yreg,par3 + 1, par4 + j1, par5 + 1,id_wood,data_wood);

      if (j1 > 0)then
      begin
        if (rand.nextInt(3) > 0)and(get_block_id(map,xreg,yreg,par3 + 2, par4 + j1, par5 + 1)=0)then
          set_block_id_data(map,xreg,yreg,par3 + 2, par4 + j1, par5 + 1,106,2);

        if (rand.nextInt(3) > 0)and(get_block_id(map,xreg,yreg,par3 + 1, par4 + j1, par5 + 2)=0)then
          set_block_id_data(map,xreg,yreg,par3 + 1, par4 + j1, par5 + 2,106,4);
      end;
    end;

    j2:=get_block_id(map,xreg,yreg,par3, par4 + j1, par5 + 1);

    if (j2 <> 0)and(j2 <> id_leaves)then continue;

    set_block_id_data(map,xreg,yreg,par3, par4 + j1, par5 + 1,id_wood,data_wood);

    if (j1 <= 0) then continue;

    if (rand.nextInt(3) > 0)and(get_block_id(map,xreg,yreg,par3 - 1, par4 + j1, par5 + 1)=0)then
      set_block_id_data(map,xreg,yreg,par3 - 1, par4 + j1, par5 + 1,106,8);

    if (rand.nextInt(3) > 0)and(get_block_id(map,xreg,yreg,par3, par4 + j1, par5 + 2)=0)then
      set_block_id_data(map,xreg,yreg,par3, par4 + j1, par5 + 2,106,4);
  end;

  rand.Free;
  result:=true;
end;

function gen_big_mushroom_notch(map:region; xreg,yreg,x,y,z,typ:integer; sid:int64):boolean;
var r:rnd;
l,i,j,k,t,l1,i3:integer;
byte0:byte;
flag:boolean;
data:integer;
begin
  r:=rnd.Create(sid);

  l:=r.nextInt(3)+4;
  r.Free;
  flag:=true;
  if (y<1)or((y+l+1)>256) then
  begin
    result:=false;
    exit;
  end;

  for i:=y to y+l+1 do
  begin
    byte0:=3;
    if i=y then byte0:=0;
    if i=y+1 then byte0:=1;
    if i=y+2 then byte0:=2;
    for j:=x-byte0 to x+byte0 do
      for k:=z-byte0 to z+byte0 do
      begin
        t:=get_block_id(map,xreg,yreg,j,i,k);
        if (t<>0)and(t<>18) then flag:=false;
      end;
  end;

  t:=get_block_id(map,xreg,yreg,x,y-1,z);
  if (t<>2)and(t<>3)and(t<>110) then flag:=false;

  if flag=false then
  begin
    result:=false;
    exit;
  end;

  set_block_id(map,xreg,yreg,x,y-1,z,3);
  l1:=y+l;
  if typ=1 then l1:=y+l-3;

  for j:=l1 to y+l do
  begin
    i3:=1;
    if j<(y+l) then inc(i3);
    if typ=0 then i3:=3;
    for i:=x-i3 to x+i3 do
      for k:=z-i3 to z+i3 do
      begin
        data:=5;
        if i=x-i3 then dec(data);
        if i=x+i3 then inc(data);
        if k=z-i3 then dec(data,3);
        if k=z+i3 then inc(data,3);
        if (typ=0)or(j<y+l) then
        begin
          if ((i=x-i3)or(i=x+i3))and((k=z-i3)or(k=z+i3)) then continue;
          if (i=x-(i3-1))and(k=z-i3) then data:=1;
          if (i=x-i3)and(k=z-(i3-1)) then data:=1;
          if (i=x+(i3-1))and(k=z-i3) then data:=3;
          if (i=x+i3)and(k=z-(i3-1)) then data:=3;
          if (i=x-(i3-1))and(k=z+i3) then data:=7;
          if (i=x-i3)and(k=z+(i3-1)) then data:=7;
          if (i=x+(i3-1))and(k=z+i3) then data:=9;
          if (i=x+i3)and(k=z+(i3-1)) then data:=9;   
        end;
        if (data=5)and(j<y+l) then data:=0;

        if ((data<>0)or(y>=y+l-1))and(get_block_id(map,xreg,yreg,i,j,k)in trans_bl) then
          set_block_id_data(map,xreg,yreg,i,j,k,99+typ,data);
      end;
  end;

  for i:=0 to l-1 do
  begin
    if (get_block_id(map,xreg,yreg,x,y+i,z)in trans_bl) then
      set_block_id_data(map,xreg,yreg,x,y+i,z,99+typ,10);
  end;

  result:=true;
end;

function gen_jungle_tree_notch(map:region; xreg,yreg,x,y,z,len,id,data,id_leaves,data_leaves:integer; sid:int64):boolean;
var l,i1,i2,l2,j3,byte0,j1,k1,j2,i3,k3,l3,i4,j4,l1,k2,i,j,k,par3,par4,par5,k4:integer;
flag:boolean;
rand:rnd;

  procedure func_48198_a(map:region; xreg,yreg,par2,par3,par4,par5:integer);
  var i:integer;
  begin
    set_block_id_data(map,xreg,yreg,par2,par3,par4,106,par5);
    for i:=1 to 4 do
    begin
      if get_block_id(map,xreg,yreg,par2,par3-i,par4)<>0 then break;
      set_block_id_data(map,xreg,yreg,par2,par3-i,par4,106,par5);
    end;
  end;

begin
  rand:=rnd.Create(sid);
  i:=x;
  j:=y;
  k:=z;
  par3:=x;
  par4:=y;
  par5:=z;
  l:=rand.nextInt(3) + len;
  flag:=true;
  if (j < 1)or(j + l + 1 > 256)then
  begin
    rand.Free;
    result:=false;
    exit;
  end;
  for i1:=j to j+1+l do
  begin
    byte0:=1;
    if (i1 = j)then byte0:=0;
    if (i1 >= (j + 1 + l) - 2)then byte0:=2;
    for i2:=i-byte0 to i+byte0 do
    begin
      if flag=false then break;
      for l2:=k-byte0 to k+byte0 do
      begin
        if flag=false then break;
        if (i1 >= 0)and(i1 < 256) then
        begin
          j3:=get_block_id(map,xreg,yreg,i2, i1, l2);
          if (j3 <> 0)and(j3 <> 18) then flag:=false;
        end
        else flag:=false;
      end;
    end;
  end;

  if flag=false then
  begin
    rand.Free;
    result:=false;
    exit;
  end;

  j1:=get_block_id(map,xreg,yreg,i, j - 1, k);
  if ((j1 <> 2)and(j1 <> 3))or(j >= 256 - l - 1)then
  begin
    rand.Free;
    result:=false;
    exit;
  end;
  set_block_id(map,xreg,yreg,i, j - 1, k, 3);
  for k1:=(j-3)+l to j+l do
  begin
    j2:=k1 - (j + l);
    i3:=1 - j2 div 2;
    for k3:=i-i3 to i+i3 do
    begin
      l3:=k3 - i;
      for i4:=k-i3 to k+i3 do
      begin
        j4:=i4 - k;
        if (((abs(l3) <> i3)or(abs(j4) <> i3)or(rand.nextInt(2) <> 0)and(j2 <> 0)) and (get_block_id(map,xreg,yreg,k3, k1, i4)in trans_bl)) then
          set_block_id_data(map,xreg,yreg, k3, k1, i4, id_leaves, data_leaves);
      end;
    end;
  end;

  for l1:=0 to l-1 do
  begin
    k2:=get_block_id(map,xreg,yreg,i, j + l1, k);
    if (k2 = 0)or(k2 = 18) then
      set_block_id_data(map,xreg,yreg, i, j + l1, k, id, data);
  end;


  for i2:=(par4-3)+l to par4+l do
  begin
    i3:=i2 - (par4 + l);
    k3:=2 - (i3 div 2);

    for i4:=par3-k3 to par3+k3 do
      for k4:=par5-k3 to par5+k3 do
      begin
        if (get_block_id(map,xreg,yreg,i4, i2, k4)<> id_leaves) then continue;

        if (rand.nextInt(4) = 0)and(get_block_id(map,xreg,yreg,i4 - 1, i2, k4)= 0) then
          func_48198_a(map,xreg,yreg, i4 - 1, i2, k4, 8);

        if (rand.nextInt(4) = 0)and(get_block_id(map,xreg,yreg,i4 + 1, i2, k4) = 0)then
          func_48198_a(map,xreg,yreg, i4 + 1, i2, k4, 2);

        if (rand.nextInt(4) = 0)and(get_block_id(map,xreg,yreg,i4, i2, k4 - 1) = 0) then
          func_48198_a(map,xreg,yreg, i4, i2, k4 - 1, 1);

        if (rand.nextInt(4) = 0)and(get_block_id(map,xreg,yreg,i4, i2, k4 + 1) = 0) then
          func_48198_a(map,xreg,yreg, i4, i2, k4 + 1, 4);  
      end;
  end;

  rand.Free;
  result:=true;
end;

function gen_tree_notch(map:region; xreg,yreg,x,y,z,id,data,id_leaves,data_leaves:integer; sid:int64):boolean;
var len:integer;
i,j,k,t,t1,l3,j4:integer;
tempxot,tempyot,chx,chy,xx,zz,ii:integer;
flag,b:boolean;
byte0:byte;
r:rnd;
begin
  r:=rnd.Create(sid);

  len:=r.nextInt(3)+5;
  if id=49 then inc(len,2);
  if (y<1)or((y+len+1)>256) then
  begin
    result:=false;
    r.Free;
    exit;
  end;

  flag:=true;
  for i:=y to y+len+1 do
  begin
    if flag=false then break;

    if i=y then byte0:=0
    else if i<(y+len-1) then byte0:=2
    else byte0:=1;

    for j:=x-byte0 to x+byte0 do
    begin
      if flag=false then break;

      for k:=z-byte0 to z+byte0 do
      begin
        if flag=false then break;

        t:=get_block_id(map,xreg,yreg,j,i,k);
        if (t<>0)and(t<>id_leaves)and(t<>255) then flag:=false;
        if (id=49)and(t=49) then flag:=false;
      end;
    end;
  end;

  if flag=false then
  begin
    result:=false;
    r.Free;
    exit;
  end;

  t:=get_block_id(map,xreg,yreg,x,y-1,z);
  if (t in trans_bl) then
  begin
    result:=false;
    r.Free;
    exit;
  end
  else if (t=2) then
  begin
    set_block_id(map,xreg,yreg,x,y-1,z,3);
  end;

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
        if (abs(l3)<>t1)or(abs(j4)<>t1)or(r.nextInt(2)<>0)and(t<>0) then
          set_block_id_data(map,xreg,yreg,j,i,k,id_leaves,data_leaves);
      end;
    end;
  end;

  for i:=0 to len-1 do
  begin
    t:=get_block_id(map,xreg,yreg,x,y+i,z);
    if (t=0)or(t=id_leaves) then
      set_block_id_data(map,xreg,yreg,x,y+i,z,id,data);

    //sozdaem sunduk v obsidianovom dereve
    if (t=49)and(id_leaves=49)and(i=len-2)and(r.nextDouble<0.1) then
    begin
      //schitaem koordinati nachalnih i konechnih chankov v regione
      if xreg<0 then
        tempxot:=(xreg+1)*32-32
      else
        tempxot:=xreg*32;

      if yreg<0 then
        tempyot:=(yreg+1)*32-32
      else
        tempyot:=yreg*32;

      dec(tempxot,2);
      dec(tempyot,2);

      //opredelaem, k kakomu chanku otnositsa
      chx:=x;
      chy:=z;

      if chx<0 then inc(chx);
      if chy<0 then inc(chy);

      chx:=chx div 16;
      chy:=chy div 16;

      if (chx<=0)and(x<0) then dec(chx);
      if (chy<=0)and(z<0) then dec(chy);

      //perevodim v koordinati chanka
      xx:=x mod 16;
      zz:=z mod 16;
      if xx<0 then inc(xx,16);
      if zz<0 then inc(zz,16);

      chx:=chx-tempxot;
      chy:=chy-tempyot;

      r:=rnd.Create(sid);

      //delaem sunduk
      map[chx][chy].blocks[xx+zz*16+(y+i)*256]:=54;
      map[chx][chy].data[xx+zz*16+(y+i)*256]:=r.nextInt(4)+2;

      //telaem tile_entity
      t:=length(map[chx][chy].Tile_entities);
      setlength(map[chx][chy].Tile_entities,t+1);
      map[chx][chy].Tile_entities[t].Id:='Chest';
      map[chx][chy].Tile_entities[t].x:=x;
      map[chx][chy].Tile_entities[t].y:=y+i;
      map[chx][chy].Tile_entities[t].z:=z;
      new(pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data));
      //opredelaem kol-vo zanimaemih slotov
      t1:=r.nextInt(6)+4;
      //zapolnaem sloti
      setlength(pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items,t1);
      for ii:=0 to t1-1 do
      begin
        repeat
        //opredelaem nomer slota
        k:=r.nextInt(27);
        //opredelaem, ne zanat li on uzhe
        b:=false;
        for j:=0 to ii-1 do
          if pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[j].slot=k then
          begin
            b:=true;
            break;
          end;
        until b=false;
        //zapolnaem pola
        j:=r.nextInt(127)+256;
        if (j=342)or(j=343) then j:=260;
        pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[ii].id:=j;
        pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[ii].damage:=0;
        pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[ii].count:=r.nextInt(3)+1;
        pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[ii].slot:=k;
      end;
    end;
  end;

  r.Free;
  result:=true;
end;

function gen_icetree_notch(map:region; xreg,yreg,x,y,z,id,data,id_leaves,data_leaves:integer; sid:int64):boolean;
var len:integer;
i,j,k,t,t1,l3,j4:integer;
flag:boolean;
byte0:byte;
r:rnd;
begin
  r:=rnd.Create(sid);

  len:=r.nextInt(3)+5;
  if (y<1)or((y+len+1)>256) then
  begin
    result:=false;
    r.Free;
    exit;
  end;

  flag:=true;
  for i:=y to y+len+1 do
  begin
    if flag=false then break;

    if i=y then byte0:=0
    else if i<(y+len-1) then byte0:=2
    else byte0:=1;

    if byte0<>0 then inc(byte0,2);

    for j:=x-byte0 to x+byte0 do
    begin
      if flag=false then break;

      for k:=z-byte0 to z+byte0 do
      begin
        if flag=false then break;

        t:=get_block_id(map,xreg,yreg,j,i,k);
        if (t<>0)and(t<>255) then flag:=false;
      end;
    end;
  end;

  if flag=false then
  begin
    result:=false;
    r.Free;
    exit;
  end;

  t:=get_block_id(map,xreg,yreg,x,y-1,z);
  if (t<>79)and(t<>2)and(t<>3)and(t<>id) then
  begin
    result:=false;
    r.Free;
    exit;
  end
  else if (t=2) then
  begin
    set_block_id(map,xreg,yreg,x,y-1,z,3);
  end;

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
        if (abs(l3)<>t1)or(abs(j4)<>t1)or(r.nextInt(2)<>0)and(t<>0) then
          set_block_id_data(map,xreg,yreg,j,i,k,id_leaves,data_leaves);
      end;
    end;
  end;

  for i:=0 to len-1 do
  begin
    t:=get_block_id(map,xreg,yreg,x,y+i,z);
    if (t=0)or(t=id_leaves) then
      set_block_id_data(map,xreg,yreg,x,y+i,z,id,data);
  end;

  r.Free;
  result:=true;
end;

procedure gen_obsidian_frame(map:region; xreg,yreg,x,y,z,id:integer);
var t:integer;
b:boolean;
begin
  for t:=y downto 0 do
  begin
    if get_block_id(map,xreg,yreg,x,t,z)=0 then continue;

    b:=false;
    if get_block_id(map,xreg,yreg,x-1,t,z)=0 then b:=true;
    if get_block_id(map,xreg,yreg,x+1,t,z)=0 then b:=true;
    if get_block_id(map,xreg,yreg,x,t,z-1)=0 then b:=true;
    if get_block_id(map,xreg,yreg,x,t,z+1)=0 then b:=true;
    if t<=254 then
      if get_block_id(map,xreg,yreg,x,t+1,z)=0 then b:=true;
    if t>=1 then
      if get_block_id(map,xreg,yreg,x,t-1,z)=0 then b:=true;

    if b=true then set_block_id_data(map,xreg,yreg,x,t,z,id,0);  
  end;
end;

procedure gen_glass_frame(map:region; xreg,yreg,x,y,z,id:integer);
var t:integer;
b,b1:boolean;
begin
  b:=false;
  b1:=false;
  for t:=0 to 255 do
  begin
    if get_block_id(map,xreg,yreg,x,t,z)<>0 then
    begin
      b1:=true;
      if b=true then
      begin
        if get_block_id(map,xreg,yreg,x,t,z)=1 then
          set_block_id(map,xreg,yreg,x,t,z,id);
        continue;
      end;

      //proverka na izmenenie bloka
      if (get_block_id(map,xreg,yreg,x-1,t,z)=0)or
      (get_block_id(map,xreg,yreg,x+1,t,z)=0)or
      (get_block_id(map,xreg,yreg,x,t,z-1)=0)or
      (get_block_id(map,xreg,yreg,x,t,z+1)=0)or
      (get_block_id(map,xreg,yreg,x,t-1,z)=0) then
        set_block_id(map,xreg,yreg,x,t,z,1)
      else
      begin
        if get_block_id(map,xreg,yreg,x,t,z)=1 then
          set_block_id(map,xreg,yreg,x,t,z,id);
        b:=true;
      end;
    end
    else if b1=true then break;
  end;   

  {t:=0;
  while (get_block_id(map,xreg,yreg,x,t,z)=0)and(t<255) do
  begin
    if get_block_id(map,xreg,yreg,x-1,t,z)<>0 then set_block_id(map,xreg,yreg,x-1,t,z,1);
    if get_block_id(map,xreg,yreg,x+1,t,z)<>0 then set_block_id(map,xreg,yreg,x+1,t,z,1);
    if get_block_id(map,xreg,yreg,x,t,z-1)<>0 then set_block_id(map,xreg,yreg,x,t,z-1,1);
    if get_block_id(map,xreg,yreg,x,t,z+1)<>0 then set_block_id(map,xreg,yreg,x,t,z+1,1);

    inc(t);
  end;

  if t=255 then exit;

  set_block_id(map,xreg,yreg,x,t,z,1);

  inc(t);
  while (get_block_id(map,xreg,yreg,x,t,z)<>0)and(t<255) do
  begin
    set_block_id(map,xreg,yreg,x,t,z,id);

    inc(t);
  end;  }
end;

function gen_obsidian_treasure(map:region; xreg,yreg,x,y,z:integer; sid:int64):boolean;
var xx,zz,yy,t,tempxot,tempyot,chx,chy,t1,i,j,k:integer;
b:boolean;
r:rnd;
begin
  //poisk seredini v dannom meste
  xx:=0;
  for yy:=y downto 0 do
    if get_block_id(map,xreg,yreg,x,yy,z)=0 then
    begin
      xx:=yy+1;
      break;
    end;

  y:=y-((y-xx) div 2);

  //proverka na udachnosti mesta
  //dolzhno bit' 2 bloka kamna v kazhduyu storonu
  b:=false;
  for xx:=x-2 to x+2 do
  begin
    if b=true then break;
    for yy:=y-2 to y+2 do
    begin
      if b=true then break;
      for zz:=z-2 to z+2 do
      begin
        if b=true then break;
        t:=get_block_id(map,xreg,yreg,xx,yy,zz);
        if (t<>1) then
        begin
          b:=true;
          break;
        end;
      end;
    end;
  end;

  if b=true then
  begin
    result:=false;
    exit;
  end;  

  //schitaem koordinati nachalnih i konechnih chankov v regione
    if xreg<0 then
      tempxot:=(xreg+1)*32-32
    else
      tempxot:=xreg*32;

    if yreg<0 then
      tempyot:=(yreg+1)*32-32
    else
      tempyot:=yreg*32;

    dec(tempxot,2);
    dec(tempyot,2);

    //opredelaem, k kakomu chanku otnositsa
    chx:=x;
    chy:=z;

    if chx<0 then inc(chx);
    if chy<0 then inc(chy);

    chx:=chx div 16;
    chy:=chy div 16;

    if (chx<=0)and(x<0) then dec(chx);
    if (chy<=0)and(z<0) then dec(chy);

    //perevodim v koordinati chanka
    xx:=x mod 16;
    zz:=z mod 16;
    if xx<0 then inc(xx,16);
    if zz<0 then inc(zz,16);

    chx:=chx-tempxot;
    chy:=chy-tempyot;

  r:=rnd.Create(sid);

  //delaem sunduk
  map[chx][chy].blocks[xx+zz*16+y*256]:=54;
  //delaem povorot sunduka
  map[chx][chy].data[xx+zz*16+y*256]:=r.nextInt(4)+2;

  //telaem tile_entity
  t:=length(map[chx][chy].Tile_entities);
  setlength(map[chx][chy].Tile_entities,t+1);
  map[chx][chy].Tile_entities[t].Id:='Chest';
  map[chx][chy].Tile_entities[t].x:=x;
  map[chx][chy].Tile_entities[t].y:=y;
  map[chx][chy].Tile_entities[t].z:=z;
  new(pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data));
  //setlength(pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items,0);

  //opredelaem kol-vo zanimaemih slotov
    t1:=r.nextInt(6)+4;
    //zapolnaem sloti
    setlength(pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items,t1);
    for i:=0 to t1-1 do
    begin
      repeat
      //opredelaem nomer slota
      k:=r.nextInt(27);
      //opredelaem, ne zanat li on uzhe
      b:=false;
      for j:=0 to i-1 do
        if pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[j].slot=k then
        begin
          b:=true;
          break;
        end;
      until b=false;
      //zapolnaem pola
      j:=r.nextInt(127)+256;
      if (j=342)or(j=343) then j:=260;
      pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].id:=j;
      pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].damage:=0;
      pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].count:=r.nextInt(3)+1;
      pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].slot:=k;
    end;

    //dopolnaem sunduk s rarnim lutom
    i:=length(pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items);
    setlength(pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items,i+1);
    //opredelaem svobodniy slot
    repeat
      //opredelaem nomer slota
      k:=r.nextInt(27);
      //opredelaem, ne zanat li on uzhe
      b:=false;
      for j:=0 to i-1 do
        if pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[j].slot=k then
        begin
          b:=true;
          break;
        end;
    until b=false;
    //zapolnaem slot
    pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].id:=1;
    pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].slot:=k;
    pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].damage:=0;
    pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].count:=1;
    case r.nextInt(1500) of
      0..99:begin  //grass
              pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].id:=2;
              pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].count:=r.nextInt(4)+2;
            end;
      100..199:begin  //bedrock
                 pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].id:=7;
               end;
      200..299:begin  //lava
                 pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].id:=10;
                 pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].count:=r.nextInt(3)+1;
               end;
      300..399:begin  //sponge
                 pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].id:=19;
               end;
      400..499:begin  //cobweb
                 pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].id:=30;
                 pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].count:=r.nextInt(3)+1;
               end;
      500..599:begin  //tnt
                 pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].id:=46;
                 pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].count:=r.nextInt(21)+10;
               end;
      600..699:begin  //mobspawner
                 pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].id:=52;
               end;
      700..799:begin  //block of diamond
                 pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].id:=57;
                 pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].count:=r.nextInt(5)+1;
               end;
      800..899:begin  //ice
                 pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].id:=79;
                 pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].count:=r.nextInt(4)+2;
               end;
      900..999:begin  //portal
                 pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].id:=90;
               end;
      1000..1099:begin  //mycelium
                   pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].id:=110;
                   pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].count:=r.nextInt(4)+2;
                 end;
      1100..1199:begin  //end portal frame
                   pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].id:=384;
                   pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].count:=r.nextInt(6)+5;
                 end;
      1200..1299:begin
                   pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].id:=385;
                   pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].count:=r.nextInt(5)+1;
                 end;
      1300..1399:begin  //spawn egg
                  pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].id:=383;
                  case r.nextInt(12) of
                  0:pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].damage:=61;
                  1:pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].damage:=120;
                  2:pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].damage:=98;
                  3:pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].damage:=50;
                  4:pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].damage:=55;
                  5:pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].damage:=59;
                  6:pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].damage:=58;
                  7:pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].damage:=95;
                  8:pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].damage:=94;
                  9:pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].damage:=56;
                  10:pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].damage:=62;
                  11:pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].damage:=91;
                  end;
                end;
      1400..1499:begin
                   t1:=1256;
                   case r.nextInt(11) of
                     0:;
                     1:inc(t1,1);
                     2:inc(t1,2);
                     3:inc(t1,3);
                     4:inc(t1,4);
                     5:inc(t1,5);
                     6:inc(t1,6);
                     7:inc(t1,7);
                     8:inc(t1,8);
                     9:inc(t1,9);
                     10:inc(t1,10);
                   end;
                   pchest_tile_entity_data(map[chx][chy].Tile_entities[t].data)^.items[i].id:=t1;
                 end;
    end;

  r.Free;
  result:=true;
end;

function gen_kaktus_notch(map:region; xreg,yreg,x,y,z:integer; sid:int64):boolean;
var r:rnd;
l,i,t,tt,t1,t2,t3,t4:integer;
b:boolean;
begin
  r:=rnd.Create(sid);
  l:=1 + r.nextInt(r.nextInt(3) + 1);
  b:=false;
  for i:=0 to l-1 do
  begin
    t:=get_block_id(map,xreg,yreg,x,y+i,z);
    t1:=get_block_id(map,xreg,yreg,x-1,y+i,z);
    t2:=get_block_id(map,xreg,yreg,x+1,y+i,z);
    t3:=get_block_id(map,xreg,yreg,x,y+i,z-1);
    t4:=get_block_id(map,xreg,yreg,x,y+i,z+1);
    tt:=get_block_id(map,xreg,yreg,x,y+i-1,z);
    if (t=0)and(t1 in trans_bl)and(t2 in trans_bl)and(t3 in trans_bl)and(t4 in trans_bl)and((tt=12)or(tt=81)) then
    begin
      set_block_id_data(map,xreg,yreg,x,y+i,z,81,0);
      b:=true;
    end
    else break;
  end;

  r.Free;
  result:=b;
end;

//procedura generacii visikoy elki
function gen_tree_taiga1_notch(map:region; xreg,yreg,x,y,z:integer; sid:int64):boolean;
var len:integer;
i1,j1,k1,l1,j2,l2,k3,t,k4,i5:integer;
flag:boolean;
r:rnd;
begin
  r:=rnd.Create(sid);

  len:=r.nextInt(5)+7;
  i1:=len-r.nextInt(2)-3;
  j1:=len-i1;
  k1:=1+r.nextInt(j1+1);
  flag:=true;

  if (y<1)or((y+len+1)>256) then
  begin
    result:=false;
    r.Free;
    exit;
  end;

  for l1:=y to y+1+len do
  begin
    if flag=false then break;

    if (l1-y)<i1 then j2:=0
    else j2:=k1;

    for l2:=x-j2 to x+j2 do
      for k3:=z-j2 to z+j2 do
      begin
        if flag=false then break;

        t:=get_block_id(map,xreg,yreg,l2,l1,k3);
        if(t<>0)and(t<>18) then flag:=false;
      end;
  end;

  if flag=false then
  begin
    result:=false;
    r.Free;
    exit;
  end;

  t:=get_block_id(map,xreg,yreg,x,y-1,z);
  if(t=2)or(t=3) then
    set_block_id(map,xreg,yreg,x,y-1,z,3)
  else
  begin
    result:=false;
    r.Free;
    exit;
  end;

  j2:=0;
  for l1:=y+len downto y+i1 do
  begin
    for l2:=x-j2 to x+j2 do
    begin
      k4:=l2-x;
      for k3:=z-j2 to z+j2 do
      begin
        i5:=k3-z;
        if (abs(k4)<>j2)or(abs(i5)<>j2)or(j2<=0) then
          set_block_id_data(map,xreg,yreg,l2,l1,k3,18,1);
      end;
    end;

    if(j2>=1)and(l1=y+i1+1) then
    begin
      dec(j2);
      continue;
    end;
    if(j2<k1) then inc(j2);
  end;

  for l1:=0 to len-2 do
  begin
    t:=get_block_id(map,xreg,yreg,x,y+l1,z);
    if(t=0)or(t=18) then set_block_id_data(map,xreg,yreg,x,y+l1,z,17,1);
  end;

  r.Free;
  result:=true;
end;

//procedura generacii shirokoy elki
function gen_tree_taiga2_notch(map:region; xreg,yreg,x,y,z:integer; sid:int64):boolean;
var l,i1,j1,k1,i,j,k,j2,t,k2,i3,j4,j5,l5:integer;
flag,flag1:boolean;
r:rnd;
begin
  r:=rnd.Create(sid);

  l:=r.nextInt(4)+6;
  if(y<1)or((y+l+1)>256) then
  begin
    result:=false;
    exit;
  end;
  i1:=1+r.nextInt(2);
  j1:=l-i1;
  k1:=2+r.nextInt(2);
  flag:=true;

  for i:=y to y+1+l do
  begin
    if flag=false then break;

    if(i-y)<i1 then j2:=0
    else j2:=k1;
    for j:=x-j2 to x+j2 do
      for k:=z-j2 to z+j2 do
      begin
        if flag=false then break;

        t:=get_block_id(map,xreg,yreg,j,i,k);
        if (t<>0)and(t<>18) then flag:=false;
      end;
  end;

  if flag=false then
  begin
    result:=false;
    r.Free;
    exit;
  end;

  t:=get_block_id(map,xreg,yreg,x,y-1,z);
  if(t=2)or(t=3) then
    set_block_id(map,xreg,yreg,x,y-1,z,3)
  else
  begin
    result:=false;
    r.Free;
    exit;
  end;

  k2:=r.nextInt(2);
  i3:=1;
  flag1:=false;
  for i:=0 to j1 do
  begin
    j4:=(y+l)-i;
    for j:=x-k2 to x+k2 do
    begin
      j5:=j-x;
      for k:=z-k2 to z+k2 do
      begin
        l5:=k-z;
        if (abs(j5)<>k2)or(abs(l5)<>k2)or(k2<=0) then
          set_block_id_data(map,xreg,yreg,j,j4,k,18,1);
      end;
    end;

    if(k2>=i3) then
    begin
      if flag1 then k2:=1 else k2:=0;
      flag1:=true;
      inc(i3);
      if(i3>k1) then i3:=k1;
    end
    else inc(k2);
  end;

  i3:=r.nextInt(3);
  for i:=0 to l-i3-1 do
  begin
    t:=get_block_id(map,xreg,yreg,x,y+i,z);
    if(t=0)or(t=18) then set_block_id_data(map,xreg,yreg,x,y+i,z,17,1);
  end;

  r.Free;
  result:=true;
end;

function gen_tree_swamp_notch(map:region; xreg,yreg,i,j,k:integer; sid:int64):boolean;
var l,i1,byte0,j2,j3,i4,t,j1,k1,k2,k3,j4,l4,k5,j5,l1,l2,i2,l3,i3,k4,i5:integer;
flag:boolean;
rand:rnd;

  procedure func_35265_a(xreg,yreg:integer; map:region; i,j,k,l:integer);
  var i1,t:integer;
  begin
    set_block_id_data(map,xreg,yreg,i, j, k, 106, l);
    t:=0;
    for i1:=4 downto 1 do
    begin
      inc(t);
      if get_block_id(map,xreg,yreg,i, j - t, k) <> 0 then break;
        set_block_id_data(map,xreg,yreg,i, j - t, k, 106, l);
    end;
  end;

begin
  rand:=rnd.Create(sid);
  l:=rand.nextInt(4) + 5;
  t:=get_block_id(map,xreg,yreg,i,j-1,k);
  while ((t=8)or(t=9))and(j>=0) do
  begin
    dec(j);
    t:=get_block_id(map,xreg,yreg,i,j-1,k);
  end;
  flag:=true;
  if (j < 1)or(j + l + 1 > 128) then
  begin
    result:=false;
    rand.Free;
    exit;
  end;
  for i1:=j to j+1+l do
  begin
    byte0:=1;
    if (i1 = j) then byte0:=0;
    if (i1 >= (j + 1 + l) - 2)then byte0:=3;
    for j2:=i-byte0 to i+byte0 do
    begin
      if flag=false then break;
      for j3:=k-byte0 to k+byte0 do
      begin
        if flag=false then break;
        if (i1 >= 0)and(i1 < 128) then
        begin
          i4:=get_block_id(map,xreg,yreg,j2, i1, j3);
          if (i4 = 0)or(i4 = 18) then continue;
          if (i4 = 8)or(i4 = 9) then
          begin
            if (i1 > j) then flag:=false;
          end
          else flag:=false;
        end
        else flag:=false;
      end;
    end;
  end;

  if flag=false then
  begin
    result:=false;
    rand.Free;
    exit;
  end;
  j1:=get_block_id(map,xreg,yreg,i, j - 1, k);
  if (j1 <> 2)and(j1 <> 3)or(j >= 128 - l - 1) then
  begin
    result:=false;
    rand.Free;
    exit;
  end;
  set_block_id(map,xreg,yreg,i, j - 1, k, 3);

  for k1:=(j - 3) + l to j+l do
  begin
    k2:=k1 - (j + l);
    k3:=2 - k2 div 2;
    for j4:=i-k3 to i+k3 do
    begin
      l4:=j4 - i;
      for j5:=k-k3 to k+k3 do
      begin
        k5:=j5 - k;
        if (((abs(l4) <> k3)or(abs(k5) <> k3)or(rand.nextInt(2) <> 0)and(k2 <> 0))and(get_block_id(map,xreg,yreg,j4, k1, j5)in trans_bl))then
          set_block_id(map,xreg,yreg,j4, k1, j5, 18);
      end;
    end;
  end;

  for l1:=0 to l-1 do
  begin
    l2:=get_block_id(map,xreg,yreg,i, j + l1, k);
    if (l2 = 0)or(l2 = 18)or(l2 = 8)or(l2 = 9) then
      set_block_id(map,xreg,yreg,i, j + l1, k, 17);
  end;

  for i2:=(j - 3) + l to j+l do
  begin
    i3:=i2 - (j + l);
    l3:=2 - i3 div 2;
    for k4:=i-l3 to i+l3 do
      for i5:=k-l3 to k+l3 do
      begin
        if (get_block_id(map,xreg,yreg,k4, i2, i5) <> 18) then continue;
        if (rand.nextInt(4) = 0)and(get_block_id(map,xreg,yreg,k4 - 1, i2, i5) = 0) then
          func_35265_a(xreg,yreg,map, k4 - 1, i2, i5, 8);
        if (rand.nextInt(4) = 0)and(get_block_id(map,xreg,yreg,k4 + 1, i2, i5) = 0) then
          func_35265_a(xreg,yreg,map, k4 + 1, i2, i5, 2);
        if (rand.nextInt(4) = 0)and(get_block_id(map,xreg,yreg,k4, i2, i5 - 1) = 0) then
          func_35265_a(xreg,yreg,map, k4, i2, i5 - 1, 1);
        if (rand.nextInt(4) = 0)and(get_block_id(map,xreg,yreg,k4, i2, i5 + 1) = 0) then
          func_35265_a(xreg,yreg,map, k4, i2, i5 + 1, 4);
      end;
  end;

  rand.Free;
  result:=true;
end;

function init_generator(gen_set:TGen_settings; var bord_in,bord_out:integer):boolean;
var stopping:boolean;
t,tt,x,y,mat,z:integer;

d1,d2:integer;

rand:rnd;
chx,chz,wid,len:integer;
count_min_max,b:boolean;
minx,minz,maxx,maxz:integer;
color,replace_col:integer;
wid_all,len_all:integer;
mas_chunk:ar_byte;
d:double;
biome_max_count,biome_count:array[0..14] of integer;

label mushroom_label,obs_glass_label,hell_sky_label,hell_sky_label1,fill_label;

  function recursive_mark(x,z:integer):integer;
  begin
    if pic[x][z]<>replace_col then
    begin
      result:=0;
      exit;
    end;

    pic[x][z]:=color;
    result:=1;

    if count_min_max=true then
    begin
      if x<minx then minx:=x;
      if x>maxx then maxx:=x;
      if z<minz then minz:=z;
      if z>maxz then maxz:=z;
    end;

    //vlevo
    if x>0 then result:=result+recursive_mark(x-1,z);
    //vpravo
    if x<wid_all then result:=result+recursive_mark(x+1,z);
    //vniz
    if z>0 then result:=result+recursive_mark(x,z-1);
    //vverh
    if z<len_all then result:=result+recursive_mark(x,z+1);
  end;

  function recursive_chunk_mark(x,z:integer; id,zam_id:integer):integer;
  var t:integer;
  b:boolean;
  begin
    b:=false;
    t:=0;
    while t<length(gen_chunks) do
    begin
      if (gen_chunks[t].x=x)and(gen_chunks[t].z=z)and(gen_chunks[t].par=zam_id) then
      begin
        b:=true;
        break;
      end;
      inc(t);
    end;

    if b=false then
    begin
      result:=0;
      exit;
    end;

    gen_chunks[t].par:=id;
    result:=1;

    //vlevo
    if x>(-(wid div 2)) then result:=result+recursive_chunk_mark(x-1,z,id,zam_id);
    //vpravo
    if x<((wid div 2)-1) then result:=result+recursive_chunk_mark(x+1,z,id,zam_id);
    //vniz
    if z>(-(len div 2)) then result:=result+recursive_chunk_mark(x,z-1,id,zam_id);
    //vverh
    if z<((len div 2)-1) then result:=result+recursive_chunk_mark(x,z+1,id,zam_id);
  end;

  procedure check_stop;
  begin
    if stopped=true then
    begin
      setlength(mas_chunk,0);
      //setlength(intersect_sferi,0);
      //setlength(region_sferi,0);
      stopping:=true;
    end;
  end;
begin
  gen_set_save:=gen_set;

  r_obsh:=rnd.Create;
  stopped:=false;
  stopping:=false;
  crc_rasch:=1;
  crc_rasch_man:=-1;
  obsh_sid:=gen_set.SID;
  setlength(gen_chunks,0);
  setlength(rand_chunks,0);
  setlength(pop_chunks,0);
  setlength(obj,0);
  setlength(gen_biomes,0);
  setlength(gen_biomes_fin,0);
  //proznak gotovnosti preview
  prev_ready:=false;

  //videlaem pamat' pod chank
  setlength(chunk.Biomes,256);
  setlength(chunk.Blocks,65536);
  setlength(chunk.Data,65536);
  setlength(chunk.Add_id,0);
  setlength(chunk.Skylight,0);
  setlength(chunk.Light,0);
  setlength(chunk.Entities,0);
  setlength(chunk.Tile_entities,0);
  chunk.Has_additional_id:=false;
  chunk.has_skylight:=false;
  chunk.has_blocklight:=false;

  //videlaem pamat' pod nulevoy chank
  setlength(zero_chunk.Biomes,256);
  setlength(zero_chunk.Blocks,65536);
  setlength(zero_chunk.Data,65536);
  setlength(zero_chunk.Add_id,0);
  setlength(zero_chunk.Skylight,0);
  setlength(zero_chunk.Light,0);
  setlength(zero_chunk.Entities,0);
  setlength(zero_chunk.Tile_entities,0);
  zero_chunk.Has_additional_id:=false;
  zero_chunk.has_skylight:=false;
  zero_chunk.has_blocklight:=false;

  //messagebox(app_hndl,pchar('CRC reseived='+inttohex(crc_manager,16)),'Message',mb_ok);
  //proveraem avtorizaciyu
  t:=crc_manager and $FFFFFFFF;  //opredelayushee chislo
  x:=crc_manager shr 32;     //izmenennoe CRC
  //vichislaem CRC ot infi
  calcCRC32(@plugin_settings,sizeof(plugin_settings),y);
  //messagebox(app_hndl,pchar('CRC nachalnoe='+inttohex(y,8)),'Message',mb_ok);
  //sozdaem random s sidom iz CRC
  //r:=rnd.Create(y);
  r_obsh.SetSeed(y);
  //vichislaem kol-vo vizovov randoma
  mat:=((t shr 4)and 1)+((t shr 13) and 2)+((t shr 18)and 4)+((t shr 26) and 8);
  //delaem opredelennoe kol-vo vizivov randoma
  for z:=1 to mat do
    r_obsh.nextInt;
  t:=r_obsh.nextInt;
  //messagebox(app_hndl,pchar('CRC izmenennoe='+inttohex(t,8)+#13+#10+'CRC izmenennoe iz menedgera='+inttohex(x,8)),'Message',mb_ok);
  //r.Free;

  //sohranaem 2 znacheniya do buduyushih ispolzovaniy
  crc_rasch:=t;
  crc_rasch_man:=x;

  //ochishaem chank
  zeromemory(chunk.Biomes,length(chunk.Biomes));
  zeromemory(chunk.Blocks,length(chunk.Blocks));
  zeromemory(chunk.Data,length(chunk.Data));

  //ochishaem chank
  zeromemory(zero_chunk.Biomes,length(zero_chunk.Biomes));
  zeromemory(zero_chunk.Blocks,length(zero_chunk.Blocks));
  zeromemory(zero_chunk.Data,length(zero_chunk.Data));

  //inicializaciya
  first_region:=true;
  spawn_x:=0;
  spawn_z:=0;
  spawn_y:=64;
  wid_save:=gen_set.Width;
  len_save:=gen_set.Length;
  provider:=ChunkProviderTest.Create(gen_set.SID);
  rand:=rnd.Create(gen_set.SID);
  r_obsh.SetSeed(gen_set.SID);
  map_has_portal:=false;
  land_noise:=NoiseGeneratorOctaves.Create(rand,4);
  ravine_gen:=MapGenRavine.Create;
  caves_gen:=MapGenCaves.Create;
  //rand:=rnd.Create(gen_set.SID);
  rand.SetSeed(gen_set.SID);
  wid_all:=gen_set.Width*16-1;
  len_all:=gen_set.Length*16-1;
  setlength(pic,wid_all+1);
  for t:=0 to wid_all do
    setlength(pic[t],len_all+1);
  setlength(mas_chunk,16*16*256);
  wid:=gen_set.Width;
  len:=gen_set.Length;
  map_wid:=wid;
  map_len:=len;

  preview.Image1.Height:=len*16+8*16;
  preview.Image1.Width:=wid*16;
  preview.Image1.Picture.Bitmap.Width:=preview.Image1.Width;
  preview.Image1.Picture.Bitmap.Height:=preview.Image1.Height;

  preview.Image1.Canvas.Brush.Color:=clWhite;
  preview.Image1.Canvas.FillRect(preview.Image1.Canvas.ClipRect);
  
  //izmenaem leybli
  //mess_str:='Pre-generating chunks';
  //mess_to_manager:=pchar(mess_str);
  mess_to_manager:=pchar('Pre-generating chunks');
  postmessage(app_hndl,WM_USER+305,integer(mess_to_manager),4);
  //mess_str:='Pre-generating chunk';
  //mess_to_manager:=pchar(mess_str);
  mess_to_manager:=pchar('Pre-generating chunk');
  postmessage(app_hndl,WM_USER+305,integer(mess_to_manager),1);
  t:=gen_set.Width*gen_set.Length;
  mess_str:='out of '+inttostr(t);
  mess_to_manager:=pchar(mess_str);
  postmessage(app_hndl,WM_USER+305,integer(mess_to_manager),3);
  postmessage(app_hndl,WM_USER+304,0,0);  //chislo
  //ustanavluvaem progress bar
  postmessage(app_hndl,WM_USER+301,0,0);  //sbros
  postmessage(app_hndl,WM_USER+302,t,0);  //ustanovka maksimuma

  //timestamp dla zamera vremeni pregeneracii
  postmessage(app_hndl,WM_USER+311,0,0);

  mat:=0;  //schetchik
  //generim chanki
  for chx:=-(wid div 2) to (wid div 2)-1 do
    for chz:=-(len div 2) to (len div 2)-1 do
    begin
      provider.ProvideChunk(chx,chz,mas_chunk);

      for x:=0 to 15 do
        for z:=0 to 15 do
        begin
          b:=false;
          for y:=127 downto 0 do
            if mas_chunk[x+z*16+y*256]<>0 then
            begin
              b:=true;
              break;
            end;

          if b=false then t:=clBlack
          else t:=clWhite;

          pic[(chx+(wid div 2))*16+x][(chz+(len div 2))*16+z]:=t;
        end;
      inc(mat);
      postmessage(app_hndl,WM_USER+303,mat,0);  //progress bar
      postmessage(app_hndl,WM_USER+304,mat,0);  //chislo

      //proverka na ostanovku
      if (mat and $7F)=0 then
      begin
        check_stop;
        if stopping=true then
        begin
          result:=false;
          postmessage(app_hndl,WM_USER+310,0,0);  //soobshenie ob uspeshnoy ostanovke
          exit;
        end;
      end;
    end;

  //izmenaem leybl
  mess_str:='Generating biomes';
  mess_to_manager:=pchar(mess_str);
  postmessage(app_hndl,WM_USER+305,integer(mess_to_manager),4);

  //delaem flag, chtobi ne schital min i max
  count_min_max:=false;

  //prohodimsa po verhu i nizu
  color:=clRed;
  replace_col:=clWhite;
  for x:=0 to wid_all do
  begin
    z:=len_all;
    recursive_mark(x,z);
    recursive_mark(x,z-1);
    recursive_mark(x,z-2);
    recursive_mark(x,z-3);
    recursive_mark(x,z-4);
    recursive_mark(x,z-5);
    recursive_mark(x,z-6);
    recursive_mark(x,z-7);
    recursive_mark(x,z-8);
    recursive_mark(x,z-9);
    recursive_mark(x,z-10);
    recursive_mark(x,z-11);
    recursive_mark(x,z-12);
    recursive_mark(x,z-13);
    recursive_mark(x,z-14);
    recursive_mark(x,z-15);

    recursive_mark(x,0);
    recursive_mark(x,1);
    recursive_mark(x,2);
    recursive_mark(x,3);
    recursive_mark(x,4);
    recursive_mark(x,5);
    recursive_mark(x,6);
    recursive_mark(x,7);
    recursive_mark(x,8);
    recursive_mark(x,9);
    recursive_mark(x,10);
    recursive_mark(x,11);
    recursive_mark(x,12);
    recursive_mark(x,13);
    recursive_mark(x,14);
    recursive_mark(x,15);
  end;
  //idem po levu i pravu
  for z:=0 to len_all do
  begin
    x:=wid_all;
    recursive_mark(x,z);
    recursive_mark(x-1,z);
    recursive_mark(x-2,z);
    recursive_mark(x-3,z);
    recursive_mark(x-4,z);
    recursive_mark(x-5,z);
    recursive_mark(x-6,z);
    recursive_mark(x-7,z);
    recursive_mark(x-8,z);
    recursive_mark(x-9,z);
    recursive_mark(x-10,z);
    recursive_mark(x-11,z);
    recursive_mark(x-12,z);
    recursive_mark(x-13,z);
    recursive_mark(x-14,z);
    recursive_mark(x-15,z);

    recursive_mark(0,z);
    recursive_mark(1,z);
    recursive_mark(2,z);
    recursive_mark(3,z);
    recursive_mark(4,z);
    recursive_mark(5,z);
    recursive_mark(6,z);
    recursive_mark(7,z);
    recursive_mark(8,z);
    recursive_mark(9,z);
    recursive_mark(10,z);
    recursive_mark(11,z);
    recursive_mark(12,z);
    recursive_mark(13,z);
    recursive_mark(14,z);
    recursive_mark(15,z);
  end;

  //debug
  {t:=preview.Image1.Height;
  for x:=0 to length(pic)-1 do
  begin
    for z:=0 to length(pic[x])-1 do
      preview.Image1.Canvas.Pixels[x,t-z-1]:=pic[z][x];
  end;
  preview.Image1.Picture.SaveToFile('D:\Evgeniy\DelphiProjects\DLL_gen_floating_islands\prev_debug.bmp');
   }
  //ishem malenkie ostrova
  for x:=0 to wid_all do
    for z:=0 to len_all do
    if pic[x][z]=clWhite then
    begin      
      count_min_max:=true;
      minx:=x;
      maxx:=x;
      minz:=z;
      maxz:=z;
      color:=clGreen;
      replace_col:=clWhite;
      t:=recursive_mark(x,z);

      if t<20 then
      begin
        count_min_max:=false;
        //recursive_mark(x,z,clFuchsia,clGreen);
        color:=clRed;
        replace_col:=clGreen;
        recursive_mark(x,z);
        continue;
      end;
      minx:=(maxx-minx+1);
      minz:=(maxz-minz+1);
      d:=min(minx,minz)/max(minx,minz);
      if (d<0.4)and(t<35) then
      begin
        count_min_max:=false;
        //recursive_mark(x,z,clBlue,clGreen);
        color:=clRed;
        replace_col:=clGreen;
        recursive_mark(x,z);
        continue;
      end;
      color:=clSilver;
      replace_col:=clGreen;
      recursive_mark(x,z);
    end;

  count_min_max:=false;

  //pomechaem chanki, kotorie ne generatsa
  for chx:=-(wid div 2) to (wid div 2)-1 do
    for chz:=-(len div 2) to (len div 2)-1 do
    begin
      b:=false;
      for x:=0 to 15 do
        for z:=0 to 15 do
          if pic[(chx+(wid div 2))*16+x][(chz+(len div 2))*16+z]=clSilver then
          begin
            b:=true;
            break;
          end;

      if b=false then
      begin
        for x:=0 to 15 do
        begin
          pic[(chx+(wid div 2))*16+x][(chz+(len div 2))*16+x]:=clGreen;
          pic[(chx+(wid div 2))*16+x][(chz+(len div 2))*16+(15-x)]:=clGreen;
          pic[(chx+(wid div 2))*16+x][(chz+(len div 2))*16]:=clGreen;
          pic[(chx+(wid div 2))*16+x][(chz+(len div 2))*16+15]:=clGreen;
          pic[(chx+(wid div 2))*16][(chz+(len div 2))*16+x]:=clGreen;
          pic[(chx+(wid div 2))*16+15][(chz+(len div 2))*16+x]:=clGreen;
        end;
      end
      else
      begin
        x:=length(gen_chunks);
        setlength(gen_chunks,x+1);
        gen_chunks[x].x:=chx;
        gen_chunks[x].z:=chz;
        gen_chunks[x].par:=0;
      end;
    end;

  t:=1;
  //delaem otdel'nie zoni biomov
  for x:=0 to length(gen_chunks)-1 do
    if gen_chunks[x].par=0 then
    begin
      recursive_chunk_mark(gen_chunks[x].x,gen_chunks[x].z,t,0);
      inc(t);
    end;

  dec(t);
  //delaem otdel'nie massivi
  setlength(gen_biomes,t);
  for x:=0 to length(gen_biomes)-1 do
  begin
    gen_biomes[x].id:=x+1;
    gen_biomes[x].b_type:=-1;
    setlength(gen_biomes[x].chunks,0);
    for z:=0 to length(gen_chunks)-1 do
      if gen_chunks[z].par=x+1 then
      begin
        y:=length(gen_biomes[x].chunks);
        setlength(gen_biomes[x].chunks,y+1);
        gen_biomes[x].chunks[y].x:=gen_chunks[z].x;
        gen_biomes[x].chunks[y].z:=gen_chunks[z].z;
        gen_biomes[x].chunks[y].par:=gen_chunks[z].par;
      end;
  end;

  //udalaem malen'kie otdel'nie ostrova
  for y:=0 to length(gen_biomes)-1 do
  begin
    t:=0;
    for tt:=0 to length(gen_biomes[y].chunks)-1 do
    begin
      if t>95 then break;
      for x:=0 to 15 do
        for z:=0 to 15 do
          if pic[(gen_biomes[y].chunks[tt].x+(wid div 2))*16+x][(gen_biomes[y].chunks[tt].z+(len div 2))*16+z]=clSilver then inc(t);
    end;

    if t<=95 then
    begin
      gen_biomes[y].b_type:=-2;

      for tt:=0 to length(gen_biomes[y].chunks)-1 do
      for x:=0 to 15 do
        begin
          pic[(gen_biomes[y].chunks[tt].x+(wid div 2))*16+x][(gen_biomes[y].chunks[tt].z+(len div 2))*16+x]:=clYellow;
          pic[(gen_biomes[y].chunks[tt].x+(wid div 2))*16+x][(gen_biomes[y].chunks[tt].z+(len div 2))*16+(15-x)]:=clYellow;
          pic[(gen_biomes[y].chunks[tt].x+(wid div 2))*16+x][(gen_biomes[y].chunks[tt].z+(len div 2))*16]:=clYellow;
          pic[(gen_biomes[y].chunks[tt].x+(wid div 2))*16+x][(gen_biomes[y].chunks[tt].z+(len div 2))*16+15]:=clYellow;
          pic[(gen_biomes[y].chunks[tt].x+(wid div 2))*16][(gen_biomes[y].chunks[tt].z+(len div 2))*16+x]:=clYellow;
          pic[(gen_biomes[y].chunks[tt].x+(wid div 2))*16+15][(gen_biomes[y].chunks[tt].z+(len div 2))*16+x]:=clYellow;
        end;
    end;
  end;

  //delaem massiv dla randomnogo perenosa
  t:=0;
  for x:=0 to length(gen_biomes)-1 do
  begin
    if gen_biomes[x].b_type=-2 then continue;

    setlength(rand_chunks,t+1);
    rand_chunks[t].x:=x;
    rand_chunks[t].z:=t;
    rand_chunks[t].par:=0;
    inc(t);
  end;
  //meshaem massiv
  y:=length(rand_chunks);
  for x:=0 to 128 do
  begin
    z:=rand.nextInt(y);
    t:=rand.nextInt(y);

    tt:=rand_chunks[z].x;
    rand_chunks[z].x:=rand_chunks[t].x;
    rand_chunks[t].x:=tt;
  end;

  //perenosim biomi
  setlength(gen_biomes_fin,length(rand_chunks));
  for x:=0 to length(rand_chunks)-1 do
  begin
    t:=rand_chunks[x].x;
    gen_biomes_fin[x].id:=gen_biomes[t].id;
    gen_biomes_fin[x].b_type:=gen_biomes[t].b_type;
    setlength(gen_biomes_fin[x].chunks,length(gen_biomes[t].chunks));
    for z:=0 to length(gen_biomes[t].chunks)-1 do
      gen_biomes_fin[x].chunks[z]:=gen_biomes[t].chunks[z];
  end;

  {t:=0;
  //perenosim normal'nie biomi
  for x:=0 to length(gen_biomes)-1 do
  begin
    if gen_biomes[x].b_type=-2 then continue;

    setlength(gen_biomes_fin,t+1);
    gen_biomes_fin[t].id:=gen_biomes[x].id;
    gen_Biomes_fin[t].b_type:=gen_biomes[x].b_type;
    setlength(gen_biomes_fin[t].chunks,length(gen_biomes[x].chunks));
    for z:=0 to length(gen_biomes[x].chunks)-1 do
      gen_biomes_fin[t].chunks[z]:=gen_biomes[x].chunks[z];

    inc(t);
  end;  }

  //ochishaem stariy massiv biomov
  for x:=0 to length(gen_biomes)-1 do
    setlength(gen_biomes[x].chunks,0);
  setlength(gen_biomes,0);

  //zapolnaem massiv maksimalnogo kol-va biomov
  t:=length(gen_biomes_fin);
  biome_max_count[0]:=-1;
  biome_max_count[1]:=-1;
  biome_max_count[2]:=10;
  biome_max_count[3]:=-1;
  biome_max_count[4]:=-1;
  biome_max_count[5]:=-1;
  biome_max_count[6]:=round(t*0.06);
  if biome_max_count[6]=0 then inc(biome_max_count[6]);
  biome_max_count[7]:=-1;
  biome_max_count[8]:=round(t*0.02);
  if biome_max_count[8]=0 then inc(biome_max_count[8]);
  biome_max_count[9]:=round(t*0.03);
  if biome_max_count[9]=0 then inc(biome_max_count[9]);
  biome_max_count[10]:=-1;
  biome_max_count[11]:=round(t*0.03);
  if biome_max_count[11]=0 then inc(biome_max_count[11]);
  biome_max_count[12]:=round(t*0.04);
  if biome_max_count[12]=0 then inc(biome_max_count[12]);
  biome_max_count[13]:=3;
  biome_max_count[14]:=3;

  //zapolnaem massiv kol-va biomov
  for x:=0 to length(biome_count)-1 do
    biome_count[x]:=0;

  //zapolnaem biomi
  if length(gen_biomes_fin)<>0 then
  begin
    for mat:=0 to length(biome_priority)-1 do
    begin
      //kogda ishem biomi, delaem nachalnie indeks -1 i kol-vo biomov=0
      //potom posle proverki na prohozhdenie arhipelaga po usloviyam dannogo bioma smotrim, izmenilsa li indeks
      //esli ne ismenilsa, to net podhodashego mesta dla bioma i perehodim k sleduyushemu
      //potom arhipelagi bez biomov zapolnatsa randomnimi dal'she

      case biome_priority[mat] of
        2,3,4:begin   //forest, desert, taiga
                //opredelaem maksimal'nie po razmeru biomi
                t:=-1;
                tt:=0;
                for x:=0 to length(gen_biomes_fin)-1 do
                begin
                  z:=length(gen_biomes_fin[x].chunks);
                  if (biome_priority[mat]=3)and(z<4) then continue;
                  if (tt<z)and(gen_biomes_fin[x].b_type=-1) then
                  begin
                    t:=x;
                    tt:=z;
                  end;
                end;

                if t=-1 then continue;
                gen_biomes_fin[t].b_type:=biome_priority[mat];
                inc(biome_count[biome_priority[mat]-1]);
              end;
        1,5,8,9,11:begin  //plains, swampland, ice plains, ice desert
                     //opredelaem biomi s lubim kol-vom chankov
                     t:=-1;
                     for x:=0 to length(gen_biomes_fin)-1 do
                       if gen_biomes_fin[x].b_type=-1 then
                       begin
                         t:=x;
                         break;
                       end;

                     if t=-1 then continue;
                     gen_biomes_fin[t].b_type:=biome_priority[mat];
                     inc(biome_count[biome_priority[mat]-1]);
                   end;
        6:begin   //jungle
            //opredelaem biomi ot 6 chankov
            t:=-1;
            for x:=0 to length(gen_biomes_fin)-1 do
              if (gen_biomes_fin[x].b_type=-1)and(length(gen_biomes_fin[x].chunks)>=6) then
              begin
                t:=x;
                break;
              end;

            if t=-1 then continue;
            gen_biomes_fin[t].b_type:=biome_priority[mat];
            inc(biome_count[biome_priority[mat]-1]);
          end;
        7:begin  //mushroom
            //opredelaem biomi ot 4 do 16 chankov v storonu uvelicheniya
            y:=16;
        mushroom_label:
            t:=-1;
            b:=false;
            for x:=0 to length(gen_biomes_fin)-1 do
            begin
              z:=length(gen_biomes_fin[x].chunks);
              if (z>y)and(gen_biomes_fin[x].b_type=-1) then b:=true;
              if (gen_biomes_fin[x].b_type=-1)and(z>=4)and(z<=y) then
              begin
                t:=x;
                break;
              end;
            end;

            if (t=-1)and(b=true) then
            begin
              inc(y);
              goto mushroom_label;
            end;

            if t=-1 then continue;
            gen_biomes_fin[t].b_type:=biome_priority[mat];
            inc(biome_count[biome_priority[mat]-1]);
          end;
        10:begin  //Icy
             //opredelaem biomi ot 4 chankov
             t:=-1;
             for x:=0 to length(gen_biomes_fin)-1 do
               if (gen_biomes_fin[x].b_type=-1)and(length(gen_biomes_fin[x].chunks)>=4) then
               begin
                 t:=x;
                 break;
               end;

             if t=-1 then continue;
             gen_biomes_fin[t].b_type:=biome_priority[mat];
             inc(biome_count[biome_priority[mat]-1]);
           end;
        12,13:begin  //obsidian, glass
                //opredelaem biomi ot 6 do 14 v obe storoni, no uvelichenie po 2
                y:=6;
                z:=14;
        obs_glass_label:
                b:=false;
                t:=-1;
                for x:=0 to length(gen_biomes_fin)-1 do
                begin
                  tt:=length(gen_biomes_fin[x].chunks);
                  if gen_biomes_fin[x].b_type=-1 then b:=true;
                  if (gen_biomes_fin[x].b_type=-1)and(tt>=y)and(tt<=z) then
                  begin
                    t:=x;
                    break;
                  end;
                end;

                if (t=-1)and(b=true) then
                begin
                  if y>1 then dec(y);
                  inc(z,2);
                  goto obs_glass_label;
                end;

                if t=-1 then continue;
                gen_biomes_fin[t].b_type:=biome_priority[mat];
                inc(biome_count[biome_priority[mat]-1]);
              end;
        14:begin  //hell
                //opredelaem biomi ot 6 do 14 v storonu uvelicheniya
                y:=6;
                z:=14;
        hell_sky_label:
                b:=false;
                t:=-1;
                for x:=0 to length(gen_biomes_fin)-1 do
                begin
                  tt:=length(gen_biomes_fin[x].chunks);
                  if (gen_biomes_fin[x].b_type=-1)and(tt>z) then b:=true;
                  if (gen_biomes_fin[x].b_type=-1)and(tt>=y)and(tt<=z) then
                  begin
                    t:=x;
                    break;
                  end;
                end;

                if (t=-1)and(b=true) then
                begin
                  inc(z);
                  goto hell_sky_label;
                end;

                if t=-1 then continue;
                gen_biomes_fin[t].b_type:=biome_priority[mat];
                inc(biome_count[biome_priority[mat]-1]);
              end;
        15:begin  //sky
                //opredelaem biomi ot 6 do 14 v storonu uvelicheniya
                y:=18;
                z:=20;
        hell_sky_label1:
                b:=false;
                t:=-1;
                for x:=0 to length(gen_biomes_fin)-1 do
                begin
                  tt:=length(gen_biomes_fin[x].chunks);
                  if (gen_biomes_fin[x].b_type=-1)and(tt>z) then b:=true;
                  if (gen_biomes_fin[x].b_type=-1)and(tt>=y)and(tt<=z) then
                  begin
                    t:=x;
                    break;
                  end;
                end;

                if (t=-1)and(b=true) then
                begin
                  inc(z);
                  goto hell_sky_label1;
                end;

                if t=-1 then continue;
                gen_biomes_fin[t].b_type:=biome_priority[mat];
                inc(biome_count[biome_priority[mat]-1]);
              end;
      end;
    end;
  end;

  //zapolnenie ostalnih biomov
  for x:=0 to length(gen_biomes_fin)-1 do
  begin
    if gen_biomes_fin[x].b_type<>-1 then continue;

  fill_label:
    t:=rand.nextInt(15)+1;
    b:=false;
    //proverka na sootvetstvie kol-vu chankov
    tt:=length(gen_biomes_fin[x].chunks);
    case t of
      1,2,4,5,8,9,11:begin
                       //kol-vo chankov luboe
                     end;
      3,10:if tt<4 then b:=true;
      6:if tt<6 then b:=true;
      7:if (tt<4)or(tt>16) then b:=true;
      12,13,14:if (tt<6)or(tt>14) then b:=true;
      15:if (tt<18)or(tt>20) then b:=true;
    end;
    //proverka na maksimum
    if (biome_count[t-1]>=biome_max_count[t-1])and(biome_max_count[t-1]<>-1) then b:=true;

    if b=true then goto fill_label;

    gen_biomes_fin[x].b_type:=t;
    inc(biome_count[t-1]);
  end;

  //opredelaem tochku spawna
  //opredelaem les s maksimal'nim kol-vom chankov
  t:=0;
  y:=-1;
  for x:=0 to length(gen_biomes_fin)-1 do
  begin
    tt:=length(gen_biomes_fin);
    if (tt>t)and(gen_biomes_fin[x].b_type=2) then
    begin
      t:=tt;
      y:=x;
    end;
  end;
  tt:=y;
  //opredelaem chank v oblasti s maksimal'nim kol-vom zemli
  if tt<>-1 then
  begin
    d1:=-1; //indeks chanka
    d2:=0;  //maksimum
    for y:=0 to length(gen_biomes_fin[tt].chunks)-1 do
    begin
      t:=0;  //kol-vo zemli
      chx:=gen_biomes_fin[tt].chunks[y].x;
      chz:=gen_biomes_fin[tt].chunks[y].z;
      for x:=0 to 15 do
        for z:=0 to 15 do
          if pic[(chx+(wid div 2))*16+x][(chz+(len div 2))*16+z]=clSilver then inc(t);

      if d2<t then
      begin
        d2:=t;
        d1:=y;
      end;

      if d2>=256 then break;
    end;

    if d1<>-1 then  //esli chank nashli
    begin
      //generim chank
      gen_surf(gen_biomes_fin[tt].chunks[d1].x,gen_biomes_fin[tt].chunks[d1].z,chunk);

      //opredelaem tochku
      b:=false;
      for x:=0 to 15 do
      begin
        if b=true then break;
        for z:=0 to 15 do
        begin
          if b=true then break;
          for y:=255 downto 0 do
          begin
            if b=true then break;
            if chunk.Blocks[x+z*16+y*256]<>0 then
            begin
              b:=true;
              spawn_x:=gen_biomes_fin[tt].chunks[d1].x*16+x;
              spawn_z:=gen_biomes_fin[tt].chunks[d1].z*16+z;
              spawn_y:=y+2;
              //delaem soobsheniya
              postmessage(app_hndl,WM_USER+306,0,spawn_x);
              postmessage(app_hndl,WM_USER+306,1,spawn_y);
              postmessage(app_hndl,WM_USER+306,2,spawn_z);

              break;
            end;
          end;
        end;
      end;
      //pomechaem
      //y:=palettergb(255,100,100);
      y:=clWhite;
      for x:=-5 to 5 do
        for z:=-5 to 5 do
          if abs(x)=abs(z) then
          begin
            pic[spawn_x+(wid div 2)*16+x][spawn_z+(len div 2)*16+z]:=y;
            pic[spawn_x+(wid div 2)*16+x-1][spawn_z+(len div 2)*16+z]:=y;
            pic[spawn_x+(wid div 2)*16+x][spawn_z+(len div 2)*16+z-1]:=y;
            pic[spawn_x+(wid div 2)*16+x+1][spawn_z+(len div 2)*16+z]:=y;
            pic[spawn_x+(wid div 2)*16+x][spawn_z+(len div 2)*16+z+1]:=y;
          end;
    end;
  end;

  //peredaem stroku so statistikoy biomov
  mess_str:='Biome statistics:'+#13+#10;
  mess_str:=mess_str+'Plains biome (1)='+inttostr(biome_count[0])+#13+#10;
  mess_str:=mess_str+'Forest biome (2)='+inttostr(biome_count[1])+#13+#10;
  mess_str:=mess_str+'Desert biome (3)='+inttostr(biome_count[2])+#13+#10;
  mess_str:=mess_str+'Taiga biome (4)='+inttostr(biome_count[3])+#13+#10;
  mess_str:=mess_str+'Swampland biome (5)='+inttostr(biome_count[4])+#13+#10;
  mess_str:=mess_str+'Jungle biome (6)='+inttostr(biome_count[5])+#13+#10;
  mess_str:=mess_str+'Mushroom biome (7)='+inttostr(biome_count[6])+#13+#10;
  mess_str:=mess_str+'Ice plains biome (8)='+inttostr(biome_count[7])+#13+#10;
  mess_str:=mess_str+'Ice desert biome (9)='+inttostr(biome_count[8])+#13+#10;
  mess_str:=mess_str+'Icy biome (10)='+inttostr(biome_count[9])+#13+#10;
  mess_str:=mess_str+'Glacier biome (11)='+inttostr(biome_count[10])+#13+#10;
  mess_str:=mess_str+'Obsidian biome (12)='+inttostr(biome_count[11])+#13+#10;
  mess_str:=mess_str+'Glass biome (13)='+inttostr(biome_count[12])+#13+#10;
  mess_str:=mess_str+'Hell biome (14)='+inttostr(biome_count[13])+#13+#10;
  mess_str:=mess_str+'Sky biome (15)='+inttostr(biome_count[14])+#13+#10;
  mess_to_manager:=pchar(mess_str);
  postmessage(app_hndl,WM_USER+309,integer(mess_to_manager),0);

  for y:=0 to length(gen_biomes_fin)-1 do
  begin
    if gen_biomes_fin[y].b_type=-1 then continue;

    t:=biome_colors[gen_biomes_fin[y].b_type];

    for tt:=0 to length(gen_biomes_fin[y].chunks)-1 do
    begin
      chx:=gen_biomes_fin[y].chunks[tt].x;
      chz:=gen_biomes_fin[y].chunks[tt].z;
      for x:=0 to 15 do
        for z:=0 to 15 do
        begin
          if pic[(chx+(wid div 2))*16+x][(chz+(len div 2))*16+z]=clSilver then
            pic[(chx+(wid div 2))*16+x][(chz+(len div 2))*16+z]:=t;
        end;
    end;
  end;

  //izmenaem leybl
  mess_str:='Drawing preview';
  mess_to_manager:=pchar(mess_str);
  postmessage(app_hndl,WM_USER+305,integer(mess_to_manager),4);

  t:=preview.Image1.Height;
  for x:=0 to length(pic)-1 do
  begin
    for z:=0 to length(pic[x])-1 do
      preview.Image1.Canvas.Pixels[x,t-z-1]:=pic[z][x];
  end;

  //pomechaem chanki, v kotorih est' oblasti, kotorie ne generatsa
  for y:=0 to length(gen_chunks)-1 do
  begin
    b:=false;
    for x:=0 to 15 do
    begin
      if b=true then break;
      for z:=0 to 15 do
        if pic[(gen_chunks[y].x+(wid div 2))*16+x][(gen_chunks[y].z+(len div 2))*16+z]=clRed then
        begin
          b:=true;
          break;
        end;
    end;

    if b=false then gen_chunks[y].par:=0
    else gen_chunks[y].par:=1;

    if pic[(gen_chunks[y].x+(wid div 2))*16][(gen_chunks[y].z+(len div 2))*16]=clYellow then gen_chunks[y].par:=2;
  end;

  preview.Image1.Canvas.Brush.Style:=bsSolid;
  for x:=1 to 8 do
  begin
    preview.Image1.Canvas.Brush.Color:=biome_colors[x];
    preview.Image1.Canvas.Rectangle(0,x*16-15,15,x*16);
  end;
  for x:=9 to 15 do
  begin
    preview.Image1.Canvas.Brush.Color:=biome_colors[x];
    preview.Image1.Canvas.Rectangle(75,(x-8)*16-15,75+15,(x-8)*16);
  end;

  preview.Image1.Canvas.Brush.Color:=clWhite;
  preview.Image1.Canvas.TextOut(16,0,'Plains');
  preview.Image1.Canvas.TextOut(16,16,'Forest');
  preview.Image1.Canvas.TextOut(16,32,'Desert');
  preview.Image1.Canvas.TextOut(16,48,'Taiga');
  preview.Image1.Canvas.TextOut(16,64,'Swampland');
  preview.Image1.Canvas.TextOut(16,80,'Jungle');
  preview.Image1.Canvas.TextOut(16,96,'Mushroom');
  preview.Image1.Canvas.TextOut(16,112,'Ice plains');

  preview.Image1.Canvas.TextOut(75+16,0,'Ice desert');
  preview.Image1.Canvas.TextOut(75+16,16,'Icy');
  preview.Image1.Canvas.TextOut(75+16,32,'Glaciers');
  preview.Image1.Canvas.TextOut(75+16,48,'Obsidian');
  preview.Image1.Canvas.TextOut(75+16,64,'Glass');
  preview.Image1.Canvas.TextOut(75+16,80,'Hell');
  preview.Image1.Canvas.TextOut(75+16,96,'Sky');

  //timestamp dla zamera vremeni pregeneracii
  postmessage(app_hndl,WM_USER+311,1,0);

  //izmenaem priznak gotovnosti preview
  prev_ready:=true;

  setlength(rand_chunks,0);
  setlength(mas_chunk,0);
  rand.Free;
  result:=true;
end;

procedure clear_red_floating(i,j:integer; chunk:TGen_chunk);
var x,y,z:integer;
begin
  for x:=0 to 15 do
    for z:=0 to 15 do
      if pic[(i+(map_wid div 2))*16+x][(j+(map_len div 2))*16+z]=clRed then
      begin
        for y:=0 to 255 do
          chunk.Blocks[x+z*16+y*256]:=0;
      end;
end;  

procedure gen_ores_chunk(i,j:integer; ch:TGen_chunk);
var x,y,z,t:integer;
begin
  for x:=0 to 15 do
    for z:=0 to 15 do
      for y:=255 downto 0 do
      begin
        t:=ch.Blocks[x+z*16+y*256];
          if (t=1)or(t=20) then
            case r_obsh.nextInt(220000) of
              0..103:begin    //gold ore
                       ch.Blocks[x+z*16+y*256]:=14;
                     end;
              104..903:begin   //iron ore
                         ch.Blocks[x+z*16+y*256]:=15;
                       end;
              904..2499:begin   //coal ore
                          ch.Blocks[x+z*16+y*256]:=16;
                        end;
              2500..2541:begin   //lapis lazuli ore
                           ch.Blocks[x+z*16+y*256]:=21;
                         end;
              2542..2589:begin    //diamond ore
                           ch.Blocks[x+z*16+y*256]:=56;
                         end;
              2590..2856:begin   //redstone ore
                           ch.Blocks[x+z*16+y*256]:=73;
                         end;
              2857..4452:begin   //gravel
                           ch.Blocks[x+z*16+y*256]:=13;
                         end;
            end;

          if (t=87)and(r_obsh.nextDouble<0.08) then ch.Blocks[x+z*16+y*256]:=88;
      end;
end;

procedure gen_biome_chunk(i,j:integer; ch:TGen_chunk; pop:boolean);
var k,t,biome,x,y,z,t1,t_desert:integer;
b:boolean;
begin
  //opredelaem k kakomu biomu prinadlezhit chank
  b:=false;
  biome:=0;
  for k:=0 to length(gen_biomes_fin)-1 do
  begin
    if b=true then break;
    for t:=0 to length(gen_biomes_fin[k].chunks)-1 do
      if (gen_biomes_fin[k].chunks[t].x=i)and(gen_biomes_fin[k].chunks[t].z=j) then
      begin
        biome:=k;
        b:=true;
        break;
      end;
  end;

  if b=false then exit;

  biome:=gen_biomes_fin[biome].b_type;

  for x:=0 to 15 do
    for z:=0 to 15 do
    begin
      t:=0;
      b:=false;
      case biome of
        1:begin  //plains
            for y:=254 downto 0 do
            begin
              k:=ch.Blocks[x+z*16+y*256];
              if k<>0 then
              begin
                b:=true;
                if (t=0)and(ch.Blocks[x+z*16+(y+1)*256]=0) then
                begin
                  t:=3;
                  ch.Blocks[x+z*16+y*256]:=2;

                  //delaem travu
                  if (pop=false)and(r_obsh.nextDouble<0.1) then
                  begin
                    t1:=length(obj);
                    setlength(obj,t1+1);
                    obj[t1].x:=i*16+x;
                    obj[t1].z:=j*16+z;
                    obj[t1].y:=y+1;
                    obj[t1].id:=1;
                  end;
                  //delaem cveti
                  if (pop=false)and(r_obsh.nextDouble<0.03) then
                  begin
                    t1:=length(obj);
                    setlength(obj,t1+1);
                    obj[t1].x:=i*16+x;
                    obj[t1].z:=j*16+z;
                    obj[t1].y:=y+1;
                    obj[t1].id:=r_obsh.nextInt(2)+2;  //oduvanchik ili roza
                  end;
                  //delaem tikvi/arbuzi
                  if (pop=false)and(r_obsh.nextDouble<0.0003) then
                  begin
                    t1:=length(obj);
                    setlength(obj,t1+1);
                    obj[t1].x:=i*16+x;
                    obj[t1].z:=j*16+z;
                    obj[t1].y:=y+1;
                    obj[t1].id:=r_obsh.nextInt(2)+4;
                  end;
                end
                else if t>0 then
                begin
                  ch.Blocks[x+z*16+y*256]:=3;
                  dec(t);
                end;
              end
              else if (k=0)and(t<>0) then t:=0;
            end;

            if b=true then ch.Biomes[x+z*16]:=1;
          end;
        2:begin  //forest
            for y:=254 downto 0 do
            begin
              k:=ch.Blocks[x+z*16+y*256];
              if k<>0 then
              begin
                b:=true;
                if (t=0)and(ch.Blocks[x+z*16+(y+1)*256]=0) then
                begin
                  t:=3;
                  ch.Blocks[x+z*16+y*256]:=2;

                  //delaem travu
                  if (pop=false)and(r_obsh.nextDouble<0.07) then
                  begin
                    t1:=length(obj);
                    setlength(obj,t1+1);
                    obj[t1].x:=i*16+x;
                    obj[t1].z:=j*16+z;
                    obj[t1].y:=y+1;
                    obj[t1].id:=1;
                  end;
                  //delaem cveti
                  if (pop=false)and(r_obsh.nextDouble<0.02) then
                  begin
                    t1:=length(obj);
                    setlength(obj,t1+1);
                    obj[t1].x:=i*16+x;
                    obj[t1].z:=j*16+z;
                    obj[t1].y:=y+1;
                    obj[t1].id:=r_obsh.nextInt(2)+2;  //oduvanchik ili roza
                  end;
                  //delaem derev'ya
                  if (pop=false)and(r_obsh.nextDouble<0.09) then
                  begin
                    t1:=length(obj);
                    setlength(obj,t1+1);
                    obj[t1].x:=i*16+x;
                    obj[t1].z:=j*16+z;
                    obj[t1].y:=y+1;
                    if r_obsh.nextDouble<0.2 then obj[t1].id:=7
                    else obj[t1].id:=6;
                  end;
                  //delaem tikvi/arbuzi
                  if (pop=false)and(r_obsh.nextDouble<0.00003) then
                  begin
                    t1:=length(obj);
                    setlength(obj,t1+1);
                    obj[t1].x:=i*16+x;
                    obj[t1].z:=j*16+z;
                    obj[t1].y:=y+1;
                    obj[t1].id:=r_obsh.nextInt(2)+4;
                  end;
                end
                else if t>0 then
                begin
                  ch.Blocks[x+z*16+y*256]:=3;
                  dec(t);
                end;
              end
              else if (k=0)and(t<>0) then t:=0;
            end;

            if b=true then ch.Biomes[x+z*16]:=4;
          end;
        3:begin  //desert
            for y:=254 downto 0 do
            begin
              k:=ch.Blocks[x+z*16+y*256];
              if k<>0 then
              begin
                b:=true;
                if (t=0)and(ch.Blocks[x+z*16+(y+1)*256]=0) then
                begin
                  t_desert:=r_obsh.nextInt(4);
                  t:=r_obsh.nextInt(2)+2+t_desert;
                  ch.Blocks[x+z*16+y*256]:=12;

                  //delaem visohshiy kust
                  if (pop=false)and(r_obsh.nextDouble<0.012) then
                  begin
                    t1:=length(obj);
                    setlength(obj,t1+1);
                    obj[t1].x:=i*16+x;
                    obj[t1].z:=j*16+z;
                    obj[t1].y:=y+1;
                    obj[t1].id:=8;
                  end;
                  //delaem kaktus
                  if (pop=false)and(r_obsh.nextDouble<0.013) then
                  begin
                    t1:=length(obj);
                    setlength(obj,t1+1);
                    obj[t1].x:=i*16+x;
                    obj[t1].z:=j*16+z;
                    obj[t1].y:=y+1;
                    obj[t1].id:=9;
                  end;
                  //delaem visohshuyu travu
                  if (pop=false)and(r_obsh.nextDouble<0.005) then
                  begin
                    t1:=length(obj);
                    setlength(obj,t1+1);
                    obj[t1].x:=i*16+x;
                    obj[t1].z:=j*16+z;
                    obj[t1].y:=y+1;
                    obj[t1].id:=10;
                  end;
                end
                else if t>0 then
                begin
                  if t>t_desert then
                  begin
                    ch.Blocks[x+z*16+y*256]:=12;
                    dec(t);
                  end
                  else
                  begin
                    ch.Blocks[x+z*16+y*256]:=24;
                    dec(t);
                    dec(t_desert);
                  end;   
                end;
              end
              else if (k=0)and(t<>0) then t:=0;
            end;

            if b=true then ch.Biomes[x+z*16]:=2;
          end;
        4:begin  //taiga
            for y:=254 downto 0 do
            begin
              k:=ch.Blocks[x+z*16+y*256];
              if k<>0 then
              begin
                b:=true;
                if (t=0)and(ch.Blocks[x+z*16+(y+1)*256]=0) then
                begin
                  t:=3;
                  ch.Blocks[x+z*16+y*256]:=2;

                  //delaem travu
                  if (pop=false)and(r_obsh.nextDouble<0.06) then
                  begin
                    t1:=length(obj);
                    setlength(obj,t1+1);
                    obj[t1].x:=i*16+x;
                    obj[t1].z:=j*16+z;
                    obj[t1].y:=y+1;
                    obj[t1].id:=1;
                  end;
                  //delaem cveti
                  if (pop=false)and(r_obsh.nextDouble<0.015) then
                  begin
                    t1:=length(obj);
                    setlength(obj,t1+1);
                    obj[t1].x:=i*16+x;
                    obj[t1].z:=j*16+z;
                    obj[t1].y:=y+1;
                    obj[t1].id:=r_obsh.nextInt(2)+2;  //oduvanchik ili roza
                  end;
                  //delaem derev'ya
                  if (pop=false)and(r_obsh.nextDouble<0.04) then
                  begin
                    t1:=length(obj);
                    setlength(obj,t1+1);
                    obj[t1].x:=i*16+x;
                    obj[t1].z:=j*16+z;
                    obj[t1].y:=y+1;
                    if r_obsh.nextDouble<0.2 then obj[t1].id:=11
                    else obj[t1].id:=12;
                  end;
                end
                else if t>0 then
                begin
                  ch.Blocks[x+z*16+y*256]:=3;
                  dec(t);
                end;
              end
              else if (k=0)and(t<>0) then t:=0;
            end;

            if b=true then ch.Biomes[x+z*16]:=5;
          end;
        5:begin  //swampland
            for y:=254 downto 0 do
            begin
              k:=ch.Blocks[x+z*16+y*256];
              if k<>0 then
              begin
                b:=true;
                if (t=0)and(ch.Blocks[x+z*16+(y+1)*256]=0) then
                begin
                  t:=3;
                  ch.Blocks[x+z*16+y*256]:=2;

                  //delaem travu
                  if (pop=false)and(r_obsh.nextDouble<0.03) then
                  begin
                    t1:=length(obj);
                    setlength(obj,t1+1);
                    obj[t1].x:=i*16+x;
                    obj[t1].z:=j*16+z;
                    obj[t1].y:=y+1;
                    obj[t1].id:=1;
                  end;
                  //delaem cveti
                  if (pop=false)and(r_obsh.nextDouble<0.015) then
                  begin
                    t1:=length(obj);
                    setlength(obj,t1+1);
                    obj[t1].x:=i*16+x;
                    obj[t1].z:=j*16+z;
                    obj[t1].y:=y+1;
                    obj[t1].id:=r_obsh.nextInt(2)+2;  //oduvanchik ili roza
                  end;
                  //delaem derev'ya
                  if (pop=false)and(r_obsh.nextDouble<0.03) then
                  begin
                    t1:=length(obj);
                    setlength(obj,t1+1);
                    obj[t1].x:=i*16+x;
                    obj[t1].z:=j*16+z;
                    obj[t1].y:=y+1;
                    obj[t1].id:=13;
                  end;
                  //delaem gribi
                  if (pop=false)and(r_obsh.nextDouble<0.01) then
                  begin
                    t1:=length(obj);
                    setlength(obj,t1+1);
                    obj[t1].x:=i*16+x;
                    obj[t1].z:=j*16+z;
                    obj[t1].y:=y+1;
                    obj[t1].id:=14+r_obsh.nextInt(2);  //korichneviy i krasniy grib
                  end;
                end
                else if t>0 then
                begin
                  ch.Blocks[x+z*16+y*256]:=3;
                  dec(t);
                end;
              end
              else if (k=0)and(t<>0) then t:=0;
            end;

            if b=true then ch.Biomes[x+z*16]:=6;
          end;
        6:begin  //jungle
            for y:=254 downto 0 do
            begin
              k:=ch.Blocks[x+z*16+y*256];
              if k<>0 then
              begin
                b:=true;
                if (t=0)and(ch.Blocks[x+z*16+(y+1)*256]=0) then
                begin
                  t:=3;
                  ch.Blocks[x+z*16+y*256]:=2;

                  //delaem derev'ya
                  if (pop=false)and(r_obsh.nextDouble<0.15) then
                  begin
                    t1:=length(obj);
                    setlength(obj,t1+1);
                    obj[t1].x:=i*16+x;
                    obj[t1].z:=j*16+z;
                    obj[t1].y:=y+1;
                    if r_obsh.nextDouble<0.1 then obj[t1].id:=33  //bol'shoe derevo
                    else if r_obsh.nextDouble<0.18 then obj[t1].id:=34  //jungle kust
                    else if r_obsh.nextDouble<0.12 then obj[t1].id:=35  //jungle ogromnoe derevo
                    else if r_obsh.nextDouble<0.2 then obj[t1].id:=36  //jungle derevo
                    else obj[t1].id:=3;
                  end;
                  //delaem travu
                  if (pop=false)and(r_obsh.nextDouble<0.42) then
                  begin
                    t1:=length(obj);
                    setlength(obj,t1+1);
                    obj[t1].x:=i*16+x;
                    obj[t1].z:=j*16+z;
                    obj[t1].y:=y+1;
                    obj[t1].id:=1;
                  end;
                  //delaem cveti
                  if (pop=false)and(r_obsh.nextDouble<0.003) then
                  begin
                    t1:=length(obj);
                    setlength(obj,t1+1);
                    obj[t1].x:=i*16+x;
                    obj[t1].z:=j*16+z;
                    obj[t1].y:=y+1;
                    obj[t1].id:=r_obsh.nextInt(2)+2;  //oduvanchik ili roza
                  end;
                  //delaem populaciyu lian
                  if (pop=false)and(r_obsh.nextDouble<0.3) then
                  begin
                    t1:=length(obj);
                    setlength(obj,t1+1);
                    obj[t1].x:=i*16+x;
                    obj[t1].z:=j*16+z;
                    obj[t1].y:=y-20;
                    if obj[t1].y<1 then obj[t1].y:=1;
                    obj[t1].id:=37;
                  end;
                end
                else if t>0 then
                begin
                  ch.Blocks[x+z*16+y*256]:=3;
                  dec(t);
                end;
              end
              else if (k=0)and(t<>0) then t:=0;
            end;

            if b=true then ch.Biomes[x+z*16]:=21;
          end;
        7:begin  //mushroom
            for y:=254 downto 0 do
            begin
              k:=ch.Blocks[x+z*16+y*256];
              if k<>0 then
              begin
                b:=true;
                if (t=0)and(ch.Blocks[x+z*16+(y+1)*256]=0) then
                begin
                  t:=3;
                  ch.Blocks[x+z*16+y*256]:=110;

                  //delaem gribi
                  if (pop=false)and(r_obsh.nextDouble<0.02) then
                  begin
                    t1:=length(obj);
                    setlength(obj,t1+1);
                    obj[t1].x:=i*16+x;
                    obj[t1].z:=j*16+z;
                    obj[t1].y:=y+1;
                    obj[t1].id:=14+r_obsh.nextInt(2);  //korichneviy i krasniy grib
                  end;
                  //delaem bol'shie gribi
                  if (pop=false)and(r_obsh.nextDouble<0.01) then
                  begin
                    t1:=length(obj);
                    setlength(obj,t1+1);
                    obj[t1].x:=i*16+x;
                    obj[t1].z:=j*16+z;
                    obj[t1].y:=y+1;
                    obj[t1].id:=16+r_obsh.nextInt(2);  //korichneviy i krasniy bol'shoy grib
                  end;
                end
                else if t>0 then
                begin
                  ch.Blocks[x+z*16+y*256]:=3;
                  dec(t);
                end;
              end
              else if (k=0)and(t<>0) then t:=0;
            end;

            if b=true then ch.Biomes[x+z*16]:=14;
          end;
        8:begin  //ice plains
            for y:=254 downto 0 do
            begin
              k:=ch.Blocks[x+z*16+y*256];
              if k<>0 then
              begin
                b:=true;
                if (t=0)and(ch.Blocks[x+z*16+(y+1)*256]=0) then
                begin
                  t:=3;
                  ch.Blocks[x+z*16+y*256]:=2;

                  //delaem travu
                  if (pop=false)and(r_obsh.nextDouble<0.06) then
                  begin
                    t1:=length(obj);
                    setlength(obj,t1+1);
                    obj[t1].x:=i*16+x;
                    obj[t1].z:=j*16+z;
                    obj[t1].y:=y+1;
                    obj[t1].id:=1;
                  end;
                  //delaem cveti
                  if (pop=false)and(r_obsh.nextDouble<0.015) then
                  begin
                    t1:=length(obj);
                    setlength(obj,t1+1);
                    obj[t1].x:=i*16+x;
                    obj[t1].z:=j*16+z;
                    obj[t1].y:=y+1;
                    obj[t1].id:=r_obsh.nextInt(2)+2;  //oduvanchik ili roza
                  end;
                end
                else if t>0 then
                begin
                  ch.Blocks[x+z*16+y*256]:=3;
                  dec(t);
                end;
              end
              else if (k=0)and(t<>0) then t:=0;
            end;

            if b=true then ch.Biomes[x+z*16]:=12;
          end;
        9:begin  //ice desert
            for y:=254 downto 0 do
            begin
              k:=ch.Blocks[x+z*16+y*256];
              if k<>0 then
              begin
                b:=true;
                if (t=0)and(ch.Blocks[x+z*16+(y+1)*256]=0) then
                begin
                  t_desert:=r_obsh.nextInt(4);
                  t:=r_obsh.nextInt(2)+2+t_desert;
                  ch.Blocks[x+z*16+y*256]:=12;

                  //net ob'ektov
                end
                else if t>0 then
                begin
                  if t>t_desert then
                  begin
                    ch.Blocks[x+z*16+y*256]:=12;
                    dec(t);
                  end
                  else
                  begin
                    ch.Blocks[x+z*16+y*256]:=24;
                    dec(t);
                    dec(t_desert);
                  end;   
                end;
              end
              else if (k=0)and(t<>0) then t:=0;
            end;

            if b=true then ch.Biomes[x+z*16]:=12;
          end;
        10:begin  //Icy
             for y:=254 downto 0 do
             begin
               k:=ch.Blocks[x+z*16+y*256];
               if k<>0 then
               begin
                 b:=true;
                 if (t=0)and(ch.Blocks[x+z*16+(y+1)*256]=0) then
                 begin
                   t_desert:=3;
                   t:=5;
                   ch.Blocks[x+z*16+y*256]:=79;

                   //ledanoe derevo
                   if (pop=false)and(r_obsh.nextDouble<0.02) then
                   begin
                     t1:=length(obj);
                     setlength(obj,t1+1);
                     obj[t1].x:=i*16+x;
                     obj[t1].z:=j*16+z;
                     obj[t1].y:=y+1;
                     obj[t1].id:=18;
                   end;
                 end
                 else if t>0 then
                 begin
                   if t>t_desert then
                   begin
                     ch.Blocks[x+z*16+y*256]:=79;
                     dec(t);
                   end
                   else
                   begin
                     ch.Blocks[x+z*16+y*256]:=3;
                     dec(t);
                     dec(t_desert);
                   end;
                 end;
               end
               else if (k=0)and(t<>0) then t:=0;
             end;

             if b=true then ch.Biomes[x+z*16]:=12;
           end;
        11:begin  //Glaciers
             for y:=254 downto 0 do
             begin
               k:=ch.Blocks[x+z*16+y*256];
               if k<>0 then
               begin
                 b:=true;
                 if (t=0)and(ch.Blocks[x+z*16+(y+1)*256]=0) then
                 begin
                   t:=3;
                   ch.Blocks[x+z*16+y*256]:=2;

                   //delaem travu
                   if (pop=false)and(r_obsh.nextDouble<0.07) then
                   begin
                     t1:=length(obj);
                     setlength(obj,t1+1);
                     obj[t1].x:=i*16+x;
                     obj[t1].z:=j*16+z;
                     obj[t1].y:=y+1;
                     obj[t1].id:=1;
                   end;
                   //delaem cveti
                   if (pop=false)and(r_obsh.nextDouble<0.02) then
                   begin
                     t1:=length(obj);
                     setlength(obj,t1+1);
                     obj[t1].x:=i*16+x;
                     obj[t1].z:=j*16+z;
                     obj[t1].y:=y+1;
                     obj[t1].id:=r_obsh.nextInt(2)+2;  //oduvanchik ili roza
                   end;
                   //delaem derev'ya
                   if (pop=false)and(r_obsh.nextDouble<0.09) then
                   begin
                     t1:=length(obj);
                     setlength(obj,t1+1);
                     obj[t1].x:=i*16+x;
                     obj[t1].z:=j*16+z;
                     obj[t1].y:=y+1;
                     if r_obsh.nextDouble<0.2 then obj[t1].id:=7
                     else obj[t1].id:=6;
                   end;
                   //delaem tikvi/arbuzi
                   if (pop=false)and(r_obsh.nextDouble<0.00003) then
                   begin
                     t1:=length(obj);
                     setlength(obj,t1+1);
                     obj[t1].x:=i*16+x;
                     obj[t1].z:=j*16+z;
                     obj[t1].y:=y+1;
                     obj[t1].id:=r_obsh.nextInt(2)+4;
                   end;
                 end
                 else if t>0 then
                 begin
                   ch.Blocks[x+z*16+y*256]:=3;
                   dec(t);
                 end;
               end
               else if (k=0)and(t<>0) then t:=0;
             end;

             if b=true then ch.Biomes[x+z*16]:=13;
           end;
        12:begin  //Obsidian
             for y:=255 downto 0 do
             begin
               if ch.Blocks[x+z*16+y*256]<>0 then
               begin
                 b:=true;

                 //spaunim obsidian
                 if (pop=false) then
                 begin
                   t1:=length(obj);
                   setlength(obj,t1+1);
                   obj[t1].x:=i*16+x;
                   obj[t1].z:=j*16+z;
                   obj[t1].y:=y;
                   obj[t1].id:=19;
                 end;
                 //spaunim derev'ya
                 if (pop=false)and(r_obsh.nextDouble<0.03) then
                 begin
                   t1:=length(obj);
                   setlength(obj,t1+1);
                   obj[t1].x:=i*16+x;
                   obj[t1].z:=j*16+z;
                   obj[t1].y:=y+1;
                   obj[t1].id:=20;
                 end;
                 //spaunim spratannie sokrovisha
                 if (pop=false)and(r_obsh.nextDouble<0.008) then
                 begin
                   t1:=length(obj);
                   setlength(obj,t1+1);
                   obj[t1].x:=i*16+x;
                   obj[t1].z:=j*16+z;
                   obj[t1].y:=y;
                   obj[t1].id:=21;
                 end;
                 break;
               end;
             end;

             if b=true then ch.Biomes[x+z*16]:=8;
           end;
        13:begin  //glass
             for y:=255 downto 0 do
             begin
               if ch.Blocks[x+z*16+y*256]<>0 then
               begin
                 b:=true;

                 //delaem steklo
                 if (pop=false) then
                 begin
                   t1:=length(obj);
                   setlength(obj,t1+1);
                   obj[t1].x:=i*16+x;
                   obj[t1].z:=j*16+z;
                   obj[t1].y:=y;
                   obj[t1].id:=22;
                 end;
                 //spaunim steklannie derev'ya
                 if (pop=false)and(r_obsh.nextDouble<0.03) then
                 begin
                   t1:=length(obj);
                   setlength(obj,t1+1);
                   obj[t1].x:=i*16+x;
                   obj[t1].z:=j*16+z;
                   obj[t1].y:=y+1;
                   obj[t1].id:=23;
                 end;
                 break;
               end;
             end;

             if b=true then ch.Biomes[x+z*16]:=2;
           end;
        14:begin  //hell
             for y:=254 downto 0 do
             begin
               if ch.Blocks[x+z*16+y*256]<>0 then
               begin
                 b:=true;

                 if ch.Blocks[x+z*16+(y+1)*256]=0 then
                 begin
                   //spaunim ogon'
                   if (pop=false)and(r_obsh.nextDouble<0.015) then
                   begin
                     t1:=length(obj);
                     setlength(obj,t1+1);
                     obj[t1].x:=i*16+x;
                     obj[t1].z:=j*16+z;
                     obj[t1].y:=y+1;
                     obj[t1].id:=24;
                   end;
                   //spaunim nether wart
                   if (pop=false)and(r_obsh.nextDouble<0.02) then
                   begin
                     t1:=length(obj);
                     setlength(obj,t1+1);
                     obj[t1].x:=i*16+x;
                     obj[t1].z:=j*16+z;
                     obj[t1].y:=y+1;
                     obj[t1].id:=42;
                   end;
                 end;

                 //spaunim glowstone v lubom meste ostrova
                 if (pop=false)and(r_obsh.nextDouble<0.05) then
                 begin
                   t1:=length(obj);
                   setlength(obj,t1+1);
                   obj[t1].x:=i*16+x;
                   obj[t1].z:=j*16+z;
                   obj[t1].y:=y;
                   obj[t1].id:=40;
                 end;

                 ch.Blocks[x+z*16+y*256]:=87;
               end;
             end;

             if b=true then ch.Biomes[x+z*16]:=8;
           end;
        15:begin  //sky
             for y:=254 downto 0 do
             begin
               if ch.Blocks[x+z*16+y*256]<>0 then
               begin
                 b:=true;

                 if ch.Blocks[x+z*16+(y+1)*256]=0 then
                 begin
                   //delaem ob'ekti
                   //spaunim kolonni
                   if (pop=false)and(r_obsh.nextDouble<0.015) then
                   begin
                     t1:=length(obj);
                     setlength(obj,t1+1);
                     obj[t1].x:=i*16+x;
                     obj[t1].z:=j*16+z;
                     obj[t1].y:=y+1;
                     obj[t1].id:=25;
                   end;
                 end;
                 ch.Blocks[x+z*16+y*256]:=121;
               end;
             end;

             if b=true then ch.Biomes[x+z*16]:=9;
           end;
      end;

      {if b=true then
        for y:=0 to 255 do
        begin
          t:=ch.Blocks[x+z*16+y*256];
          if t=1 then
            case r_obsh.nextInt(50000) of
              0..103:begin    //gold ore
                       t1:=length(obj);
                       setlength(obj,t1+1);
                       obj[t1].x:=i*16+x;
                       obj[t1].z:=j*16+z;
                       obj[t1].y:=y;
                       obj[t1].id:=27;
                     end;
              104..903:begin   //iron ore
                         t1:=length(obj);
                         setlength(obj,t1+1);
                         obj[t1].x:=i*16+x;
                         obj[t1].z:=j*16+z;
                         obj[t1].y:=y;
                         obj[t1].id:=28;
                       end;
              904..2499:begin   //coal ore
                          t1:=length(obj);
                          setlength(obj,t1+1);
                          obj[t1].x:=i*16+x;
                          obj[t1].z:=j*16+z;
                          obj[t1].y:=y;
                          obj[t1].id:=29;
                        end;
              2500..2541:begin   //lapis lazuli ore
                           t1:=length(obj);
                           setlength(obj,t1+1);
                           obj[t1].x:=i*16+x;
                           obj[t1].z:=j*16+z;
                           obj[t1].y:=y;
                           obj[t1].id:=30;
                         end;
              2542..2589:begin    //diamond ore
                           t1:=length(obj);
                           setlength(obj,t1+1);
                           obj[t1].x:=i*16+x;
                           obj[t1].z:=j*16+z;
                           obj[t1].y:=y;
                           obj[t1].id:=31;
                         end;
              2590..2856:begin   //redstone ore
                           t1:=length(obj);
                           setlength(obj,t1+1);
                           obj[t1].x:=i*16+x;
                           obj[t1].z:=j*16+z;
                           obj[t1].y:=y;
                           obj[t1].id:=32;  
                         end;
            end;
        end;}
    end;
end;

function generate_chunk(i,j:integer):TGen_Chunk;
var t,x,t1:integer;
b,gen_c,gen_r:boolean;
begin
  if stopped then
  begin
    mess_str:='Reseived chunk return after stop';
    mess_to_manager:=PChar(mess_str);
    postmessage(app_hndl,WM_USER+309,integer(mess_to_manager),0);
    result:=chunk;
    exit;
  end;

  //ochishaem chank
  //zeromemory(chunk.Blocks,length(chunk.Blocks));
  zeromemory(chunk.Data,length(chunk.Data));
  zeromemory(chunk.Biomes,length(chunk.Biomes));

  b:=false;
  x:=0;
  for t:=0 to length(gen_chunks)-1 do
    if (i=gen_chunks[t].x)and(j=gen_chunks[t].z) then
    begin
      if gen_chunks[t].par=0 then b:=true
      else if gen_chunks[t].par=2 then b:=false
      else
      begin
        x:=1;
        b:=true;
      end;
      break;
    end;

  if b=false then
  begin
    result:=zero_chunk;
    exit;
  end;

  gen_surf(i,j,chunk);

  if x=1 then clear_red_floating(i,j,chunk);

  if crc_rasch=crc_rasch_man then
  begin
    //opredelaem, sozdavali li mi ob'ekti dla etogo chanka uzhe ili net
    b:=false;
    for x:=0 to length(pop_chunks)-1 do
      if (pop_chunks[x].x=i)and(pop_chunks[x].z=j) then
      begin
        b:=true;
        break;
      end;

    gen_biome_chunk(i,j,chunk,b);

    //opredelaem, nuzhno li spaunit' pesheri i ovragi
    t1:=-1;
    for x:=0 to length(gen_biomes_fin)-1 do
    begin
      if t1<>-1 then break;
      for t:=0 to length(gen_biomes_fin[x].chunks)-1 do
        if (gen_biomes_fin[x].chunks[t].x=i)and(gen_biomes_fin[x].chunks[t].z=j) then
        begin
          t1:=gen_biomes_fin[x].b_type;
          break;
        end;
    end;

    case t1 of
      1,2,4,8,11:begin  //plains,forest,taiga,ice plains,glaciers
                   gen_c:=true;
                   gen_r:=true;
                 end;
      3,6,10:begin  //desert,jungle,icy
               gen_c:=true;
               gen_r:=false;
             end;
      5:begin  //swampland
          gen_c:=false;
          gen_r:=true;
        end;
      7,9,12,13,14,15:begin  //mushroom,ice desert,obsidian,glass,hell,sky
                        gen_c:=false;
                        gen_r:=false;
                      end
      else
      begin
        gen_c:=false;
        gen_r:=false;
      end;
    end;

    if gen_c=true then
      caves_gen.generate(obsh_sid,i,j,chunk.Blocks);
    if gen_r=true then
      ravine_gen.generate(obsh_sid,i,j,chunk.Blocks);

    gen_ores_chunk(i,j,chunk);

    //dobavlaem koordinati chanka v massiv populacii
    if b=false then
    begin
      x:=length(pop_chunks);
      setlength(pop_chunks,x+1);
      pop_chunks[x].x:=i;
      pop_chunks[x].z:=j;
    end;

    result:=chunk;
  end
  else
    result:=zero_chunk;
end;

procedure clear_dynamic;
var i:integer;
begin
  //ochishaem pamat' ot chanka
  //ne ochishaem t.k. vozmozhno iz za etogo voznikaet oshibka
  setlength(chunk.Biomes,0);
  setlength(chunk.Blocks,0);
  setlength(chunk.Data,0);
  setlength(chunk.Add_id,0);
  setlength(chunk.Skylight,0);
  setlength(chunk.Light,0);
  setlength(chunk.Entities,0);
  setlength(chunk.Tile_entities,0);

  setlength(zero_chunk.Biomes,0);
  setlength(zero_chunk.Blocks,0);
  setlength(zero_chunk.Data,0);
  setlength(zero_chunk.Add_id,0);
  setlength(zero_chunk.Skylight,0);
  setlength(zero_chunk.Light,0);
  setlength(zero_chunk.Entities,0);
  setlength(zero_chunk.Tile_entities,0);

  for i:=0 to length(pic)-1 do
    setlength(pic[i],0);
  setlength(pic,0);
  setlength(gen_chunks,0);
  setlength(rand_chunks,0);
  setlength(pop_chunks,0);
  setlength(obj,0);
  for i:=0 to length(gen_biomes)-1 do
    setlength(gen_biomes[i].chunks,0);
  setlength(gen_biomes,0);
  for i:=0 to length(gen_biomes_fin)-1 do
    setlength(gen_biomes_fin[i].chunks,0);
  setlength(gen_biomes_fin,0);


  provider.Free;
  map_has_portal:=false;

  if r_obsh<>nil then
  begin
    r_obsh.Free;
    r_obsh:=nil;
  end;

  if land_noise<>nil then
  begin
    land_noise.Free;
    land_noise:=nil;
  end;

  if ravine_gen<>nil then
  begin
    ravine_gen.Free;
    ravine_gen:=nil;
  end;

  if caves_gen<>nil then
  begin
    caves_gen.Free;
    caves_gen:=nil;
  end;
end;

procedure create_end_portal(xreg,yreg:integer; map:region);
var i,t:integer;
begin
  for i:=0 to length(obj)-1 do
    if get_block_id(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z)<>255 then
    begin
      if obj[i].id=25 then
      begin
        if check_end_spike(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,obsh_sid+i)=true then
        begin
          t:=length(obj);
          setlength(obj,t+1);
          obj[t].x:=obj[i].x;
          obj[t].y:=obj[i].y+r_obsh.nextInt(10);
          obj[t].z:=obj[i].z;
          obj[t].id:=26;

          map_has_portal:=true;
          exit;
        end;
      end;
    end;
end;

procedure gen_objects(xreg,yreg:integer; map:region);
var i,j,k,t:integer;
begin
  for i:=0 to length(obj)-1 do
  begin
    if get_block_id(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z)<>255 then
    case obj[i].id of
      1:begin  //zelenaya obichnaya trava
          t:=get_block_id(map,xreg,yreg,obj[i].x,obj[i].y-1,obj[i].z);
          if (get_block_id(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z)=0)and((t=2)or(t=3)or(t=60)) then
            set_block_id_data(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,31,1);
        end;
      2:begin  //oduvanchik
          t:=get_block_id(map,xreg,yreg,obj[i].x,obj[i].y-1,obj[i].z);
          if (get_block_id(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z)=0)and((t=2)or(t=3)or(t=60)) then
            set_block_id(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,37);
        end;
      3:begin  //roza
          t:=get_block_id(map,xreg,yreg,obj[i].x,obj[i].y-1,obj[i].z);
          if (get_block_id(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z)=0)and((t=2)or(t=3)or(t=60)) then
            set_block_id(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,38);
        end;
      4:begin  //gruppa tikv
          gen_pumpkins_patch(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,86,obsh_sid+i);
        end;
      5:begin  //gruppa arbuzov
          gen_pumpkins_patch(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,103,obsh_sid+i);
        end;
      6:begin  //obichnoe derevo po notchu
          gen_tree_notch(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,17,0,18,0,obsh_sid+i);
        end;
      7:begin  //obichnaya bereza po notchu
          gen_tree_notch(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,17,2,18,2,obsh_sid+i);
        end;
      8:begin  //visohshiy kust
          t:=get_block_id(map,xreg,yreg,obj[i].x,obj[i].y-1,obj[i].z);
          if (get_block_id(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z)=0)and((t=2)or(t=3)or(t=60)or(t=12)) then
            set_block_id_data(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,32,0);
        end;
      9:begin  //kaktus
          gen_kaktus_notch(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,obsh_sid+i);
        end;
      10:begin  //trava v vide kusta
           t:=get_block_id(map,xreg,yreg,obj[i].x,obj[i].y-1,obj[i].z);
           if (get_block_id(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z)=0)and((t=2)or(t=3)or(t=60)or(t=12)) then
             set_block_id_data(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,31,0);
         end;
      11:begin  //visokaya elka
           gen_tree_taiga1_notch(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,obsh_sid+i);
         end;
      12:begin  //shirokaya elka
           gen_tree_taiga2_notch(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,obsh_sid+i);
         end;
      13:begin  //bolotnoe derevo
           gen_tree_swamp_notch(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,obsh_sid+i);
         end;
      14:begin  //korichneviy grib
           t:=get_block_id(map,xreg,yreg,obj[i].x,obj[i].y-1,obj[i].z);
           if (get_block_id(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z)=0)and((t=2)or(t=3)or(t=60)or(t=13)or(t=110)) then
             set_block_id_data(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,39,0);
         end;
      15:begin  //krasniy grib
           t:=get_block_id(map,xreg,yreg,obj[i].x,obj[i].y-1,obj[i].z);
           if (get_block_id(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z)=0)and((t=2)or(t=3)or(t=60)or(t=13)or(t=110)) then
             set_block_id_data(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,40,0);
         end;
      16:begin  //korichneviy bol'shoy grib
           //if get_block_id(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z)=0 then
           //set_block_id(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,89);
           gen_big_mushroom_notch(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,0,obsh_sid+i);
         end;
      17:begin  //krasniy bol'shoy grib
           //if get_block_id(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z)=0 then
           //set_block_id(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,91);
           gen_big_mushroom_notch(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,1,obsh_sid+i);
         end;
      18:begin  //ledanoe derevo
           gen_icetree_notch(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,80,0,79,0,obsh_sid+i);
         end;
      19:begin  //obsidianovoe obramlenie obsidianovogo ostrova
           gen_obsidian_frame(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,49);
         end;
      20:begin  //obsidianovoe derevo
           gen_tree_notch(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,49,0,49,0,obsh_sid+i);
         end;
      21:begin  //sokrovisha v obsidianovom ostrove
           gen_obsidian_treasure(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,obsh_sid+i);
         end;
      22:begin  //podderzhka stekla i samo steklo
           gen_glass_frame(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,20);
         end;
      23:begin  //steklannoe derevo
           gen_icetree_notch(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,20,0,102,0,obsh_sid+i);
         end;
      24:begin  //ogon'
           t:=get_block_id(map,xreg,yreg,obj[i].x,obj[i].y-1,obj[i].z);
           if (get_block_id(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z)=0)and(t=87) then
             set_block_id_data(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,51,15);
         end;
      25:begin  //kolonna The END
           gen_spike_sky(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,49,obsh_sid+i);
         end;
      26:begin  //end portal
           gen_end_portal(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,0.8,obsh_sid+i);
         end;
      27:begin  //gold ore
           t:=get_block_id(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z);
           if (t=1)or(t=20) then
             set_block_id_data(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,14,0);
         end;
      28:begin  //iron ore
           t:=get_block_id(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z);
           if (t=1)or(t=20) then
             set_block_id_data(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,15,0);
         end;
      29:begin  //coal ore
           t:=get_block_id(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z);
           if (t=1)or(t=20) then
             set_block_id_data(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,16,0);
         end;
      30:begin  //lapis ore
           t:=get_block_id(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z);
           if (t=1)or(t=20) then
             set_block_id_data(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,21,0);
         end;
      31:begin  //diamond ore
           t:=get_block_id(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z);
           if (t=1)or(t=20) then
             set_block_id_data(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,56,0);
         end;
      32:begin  //redstone ore
           t:=get_block_id(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z);
           if (t=1)or(t=20) then
             set_block_id_data(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,73,0);
         end;
      33:begin  //bol'shoe derevo
           gen_bigtree_notch(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,obsh_sid+i);
         end;
      34:begin  //jungle kust
           gen_shrub_notch(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,17,3,18,0,obsh_sid+i);
         end;
      35:begin  //bol'shoe jungle derevo
           gen_huge_tree_notch(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,10 + r_obsh.nextInt(20),17,3,18,3,obsh_sid+i);
         end;
      36:begin  //obichnoe jungle derevo
           //gen_jungle_tree_notch(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,4 + r_obsh.nextInt(7),17,3,18,3,obsh_sid+i);
         end;
      37:begin  //jungle vines
           //gen_vines_jungle_notch(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,obsh_sid+i);
         end;
      38:begin  //reed patch dla ozer
           gen_reed_lakes_patch(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,obsh_sid+i);
         end;
      39:begin  //zalezhi glini okolo ozer
           gen_clay_lakes_patch(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,obsh_sid+i);
         end;
      40:begin  //glowstone dla hell biome
           gen_glowstone_hell(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z);
         end;
      41:begin  //lily pad dla ozer
           gen_lily_lakes_patch(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,obsh_sid+i);
         end;
      42:begin  //nether wart
           gen_nether_wart(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,obsh_sid+i);
         end;
    end;
  end;

  //generim posle, t.k. iz-za lian ne mogut zaspavnitsa bol'shie derev'ya
  for i:=0 to length(obj)-1 do
  begin
    if get_block_id(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z)<>255 then
    case obj[i].id of
      36:begin   //obichnoe jungle derevo
           gen_jungle_tree_notch(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,4 + r_obsh.nextInt(7),17,3,18,3,obsh_sid+i);
         end;
      37:begin  //jungle vines
           gen_vines_jungle_notch(map,xreg,yreg,obj[i].x,obj[i].y,obj[i].z,obsh_sid+i);
         end;
    end;
  end;


  //ochishaem tochku spawna
  t:=get_block_id(map,xreg,yreg,spawn_x,spawn_y,spawn_z);
  if (t in solid_bl) then set_block_id_data(map,xreg,yreg,spawn_x,spawn_y,spawn_z,0,0);
  t:=get_block_id(map,xreg,yreg,spawn_x,spawn_y-1,spawn_z);
  if (t in solid_bl) then set_block_id_data(map,xreg,yreg,spawn_x,spawn_y-1,spawn_z,0,0);
  //proveraem, mozhno li stoyat'
  t:=get_block_id(map,xreg,yreg,spawn_x,spawn_y-2,spawn_z);
  if not(t in solid_bl) then
  begin
    for i:=spawn_x-2 to spawn_x+2 do
      for j:=spawn_z-2 to spawn_z+2 do
        for k:=spawn_y-2 downto spawn_y-4 do
          if not(get_block_id(map,xreg,yreg,i,k,j) in solid_bl) then
            set_block_id_data(map,xreg,yreg,i,k,j,0,0);
  end;
end;

procedure gen_snow_region(xreg,yreg:integer; map:region);
var chx,chy,x,y,z,t,tb:integer;
begin
  for chx:=0 to 35 do
    for chy:=0 to 35 do
      for x:=0 to 15 do
        for z:=0 to 15 do
        begin
          tb:=map[chx][chy].Biomes[x+z*16];
          if ((tb=5)or(tb=12)or(tb=13))and(map[chx][chy].Blocks[x+z*16+255*256]=0) then
          begin
            y:=255;
            while (map[chx][chy].Blocks[x+z*16+y*256]=0)and(y>0) do
              dec(y);
            if y=0 then continue;

            t:=map[chx][chy].Blocks[x+z*16+y*256];
            if (t in solid_bl)and(t<>20)and(t<>89)and(t<>79)and(t<>52) then
              map[chx][chy].Blocks[x+z*16+(y+1)*256]:=78;

            if (t=8)or(t=9) then
              map[chx][chy].Blocks[x+z*16+(y)*256]:=79;
          end;
        end;
end;

procedure gen_glaciers_region(xreg,yreg:integer; map:region);
var chx,chy,x,y,z,t,tb:integer;
b:boolean;
r:rnd;

  procedure recursive_iceing(chx,chz,x,y,z,count:integer);
  var temp:byte;
  begin
    if r.nextDouble<0.4 then
      dec(count);
    if r.nextDouble<0.6 then temp:=1
    else temp:=0;
    if (count-1)=0 then exit;

    map[chx][chz].Blocks[x+z*16+y*256]:=79;
    map[chx][chz].Data[x+z*16+y*256]:=count;

    //smotrim vverh
    if y<255 then
      if (map[chx][chz].Blocks[x+z*16+(y+1)*256]=0)or
      (map[chx][chz].Blocks[x+z*16+(y+1)*256]=79) then
        if map[chx][chz].Data[x+z*16+(y+1)*256]<(count-1) then
          recursive_iceing(chx,chz,x,y+1,z,count-1);

    //smotrim vniz
    if y>0 then
      if (map[chx][chz].Blocks[x+z*16+(y-1)*256]=0)or
      (map[chx][chz].Blocks[x+z*16+(y-1)*256]=79) then
        if map[chx][chz].Data[x+z*16+(y-1)*256]<(count-1) then
          recursive_iceing(chx,chz,x,y-1,z,count-1);

    //smotrim vlevo
    if x>0 then
    begin
      if (map[chx][chz].Blocks[(x-1)+z*16+y*256]=0)or
      (map[chx][chz].Blocks[(x-1)+z*16+y*256]=79) then
        if map[chx][chz].Data[(x-1)+z*16+y*256]<(count-1-temp) then
          recursive_iceing(chx,chz,x-1,y,z,count-1-temp);
    end
    else if chx>0 then
      if (map[chx-1][chz].Blocks[15+z*16+y*256]=0)or
      (map[chx-1][chz].Blocks[15+z*16+y*256]=79) then
        if map[chx-1][chz].Data[15+z*16+y*256]<(count-1-temp) then
          recursive_iceing(chx-1,chz,15,y,z,count-1-temp);

    //smotrim vpravo
    if x<15 then
    begin
      if (map[chx][chz].Blocks[(x+1)+z*16+y*256]=0)or
      (map[chx][chz].Blocks[(x+1)+z*16+y*256]=79) then
        if map[chx][chz].Data[(x+1)+z*16+y*256]<(count-1-temp) then
          recursive_iceing(chx,chz,x+1,y,z,count-1-temp);
    end
    else if chx<35 then
      if (map[chx+1][chz].Blocks[z*16+y*256]=0)or
      (map[chx+1][chz].Blocks[z*16+y*256]=79) then
        if map[chx+1][chz].Data[z*16+y*256]<(count-1-temp) then
          recursive_iceing(chx+1,chz,0,y,z,count-1-temp);

    //smotrim nazad
    if z>0 then
    begin
      if (map[chx][chz].Blocks[x+(z-1)*16+y*256]=0)or
      (map[chx][chz].Blocks[x+(z-1)*16+y*256]=79) then
        if map[chx][chz].Data[x+(z-1)*16+y*256]<(count-1-temp) then
          recursive_iceing(chx,chz,x,y,z-1,count-1-temp);
    end
    else if chz>0 then
      if (map[chx][chz-1].Blocks[x+15*16+y*256]=0)or
      (map[chx][chz-1].Blocks[x+15*16+y*256]=79) then
        if map[chx][chz-1].Data[x+15*16+y*256]<(count-1-temp) then
          recursive_iceing(chx,chz-1,x,y,15,count-1-temp);

    //smotrim vpered
    if z<15 then
    begin
      if (map[chx][chz].Blocks[x+(z+1)*16+y*256]=0)or
      (map[chx][chz].Blocks[x+(z+1)*16+y*256]=79) then
        if map[chx][chz].Data[x+(z+1)*16+y*256]<(count-1-temp) then
          recursive_iceing(chx,chz,x,y,z+1,count-1-temp);
    end
    else if chz<35 then
      if (map[chx][chz+1].Blocks[x+y*256]=0)or
      (map[chx][chz+1].Blocks[x+y*256]=79) then
        if map[chx][chz+1].Data[x+y*256]<(count-1-temp) then
          recursive_iceing(chx,chz+1,x,y,0,count-1-temp);
  end;

begin
  b:=false;
  r:=rnd.Create(obsh_sid);
  for chx:=0 to 35 do
    for chy:=0 to 35 do
      for x:=0 to 15 do
        for z:=0 to 15 do
        begin
          tb:=map[chx][chy].Biomes[x+z*16];
          if (tb=13)then
          begin
            {y:=255;
            t:=map[chx][chy].Blocks[x+z*16+y*256];
            while ((t<>2)and(t<>3)and(t<>1))and(y>0) do
            begin
              dec(y);
              t:=map[chx][chy].Blocks[x+z*16+y*256];
            end;
            if y=0 then continue;

            inc(y);

            t:=map[chx][chy].Blocks[x+z*16+y*256];
            if (t=0)or(t=79) then
            begin
              b:=true;
              recursive_iceing(chx,chy,x,y,z,18);
            end; }
            for y:=254 downto 0 do
            begin
              t:=map[chx][chy].Blocks[x+z*16+y*256];
              if (t=2)or(t=3)or(t=1) then
                if (map[chx][chy].Blocks[x+z*16+(y+1)*256]=0)or
                (map[chx][chy].Blocks[x+z*16+(y+1)*256]=79) then
                begin
                  b:=true;
                  recursive_iceing(chx,chy,x,y+1,z,18);
                end;
            end;
          end;
        end;

  r.Free;

  //ochishaem data dla l'da
  if b=true then
  for chx:=0 to 35 do
    for chy:=0 to 35 do
      for x:=0 to 15 do
        for z:=0 to 15 do
          for y:=0 to 255 do
            if (map[chx][chy].Blocks[x+z*16+y*256]=79)and
            (map[chx][chy].Data[x+z*16+y*256]<>0) then
            begin
              map[chx][chy].Data[x+z*16+y*256]:=0;
              map[chx][chy].Biomes[x+z*16]:=13;
            end;
end;

procedure gen_lakes_dung(xreg,yreg:integer; map:region);
var chx,chy,x,y,z,maxy,miny,t,t1:integer;
otx,dox,oty,doy,wid,len:integer;
chcx,chcy:integer;
gen_dung,gen_lakes:boolean;
rand:rnd;
l1,l2:int64;
begin
  //schitaem koordinati nachalnih i konechnih chankov v regione
    if xreg<0 then
    begin
      otx:=(xreg+1)*32-32;
      dox:=(xreg+1)*32-1;
    end
    else
    begin
      otx:=xreg*32;
      dox:=(xreg*32)+31;
    end;

    if yreg<0 then
    begin
      oty:=(yreg+1)*32-32;
      doy:=(yreg+1)*32-1;
    end
    else
    begin
      oty:=yreg*32;
      doy:=(yreg*32)+31;
    end;

  //wid:=gen_settings_save.Width div 2;
  //len:=gen_settings_save.Length div 2;
  wid:=wid_save div 2;
  len:=len_save div 2;

  if (-1*wid)>otx then otx:=-1*wid;
  if (wid-1)<dox then dox:=wid-1;
  if (-1*len)>oty then oty:=-1*len;
  if (len-1)<doy then doy:=len-1;

  while otx<0 do inc(otx,32);
  while oty<0 do inc(oty,32);
  while dox<0 do inc(dox,32);
  while doy<0 do inc(doy,32);

  while otx>31 do dec(otx,32);
  while oty>31 do dec(oty,32);
  while dox>31 do dec(dox,32);
  while doy>31 do dec(doy,32);

  inc(otx,2);
  inc(dox,2);
  inc(oty,2);
  inc(doy,2);

  dec(otx);
  dec(oty);

  for chx:=otx to dox do
    for chy:=oty to doy do
    begin
      //opredelaem koordinati tekuchego chanka
      chcx:=xreg*32-2+chx;
      chcy:=yreg*32-2+chy;

      //opredelaem tip arhipelaga 
      t1:=-1;
      for x:=0 to length(gen_biomes_fin)-1 do
      begin
        if t1<>-1 then break;
        for z:=0 to length(gen_biomes_fin[x].chunks)-1 do
          if (gen_biomes_fin[x].chunks[z].x=chcx)and(gen_biomes_fin[x].chunks[z].z=chcy) then
          begin
            t1:=gen_biomes_fin[x].b_type;
            break;
          end;
      end;

      case t1 of
        -1:begin
             gen_dung:=false;
             gen_lakes:=false;
           end;
        1,2,3,4,5,8,9,11:begin  //vse ostal'nie
                           gen_dung:=true;
                           gen_lakes:=true;
                         end;
        6,7:begin  //jungle, mushroom
              gen_dung:=true;
              gen_lakes:=false;
            end;
        10,12,13,15:begin  //Icy, obsidian, glass, sky
                      gen_dung:=false;
                      gen_lakes:=false;
                    end;
        14:begin  //hell
             gen_dung:=false;
             gen_lakes:=true;
           end;
      end;

      //ishem maksimum i minimum v dannom chanke
      if(gen_dung=true)or(gen_lakes=true)then
      begin
        maxy:=0;
        miny:=255;
        t:=-1;
        for x:=0 to 15 do
          for z:=0 to 15 do
            for y:=255 downto 0 do
              if map[chx][chy].Blocks[x+z*16+y*256]<>0 then
              begin
                t:=y;
                if maxy<y then maxy:=y;
              end;
        if(t<>-1)and(t<miny) then miny:=t;

        if maxy<miny then break;

        rand:=rnd.Create(obsh_sid);
        l1:=(rand.nextLong() div 2) * 2 + 1;
        l2:=(rand.nextLong() div 2) * 2 + 1;
        rand.setSeed((chcx * l1 + chcy * l2) xor obsh_sid);

        if gen_dung=true then
        begin
          gen_dungeon_notch(map,xreg,yreg,chcx*16+rand.nextInt(16)+8,rand.nextInt(maxy-miny)+miny,chcy*16+rand.nextInt(16)+8,rand);
          gen_dungeon_notch(map,xreg,yreg,chcx*16+rand.nextInt(16)+8,rand.nextInt(maxy-miny)+miny,chcy*16+rand.nextInt(16)+8,rand);
          gen_dungeon_notch(map,xreg,yreg,chcx*16+rand.nextInt(16)+8,rand.nextInt(maxy-miny)+miny,chcy*16+rand.nextInt(16)+8,rand);
          gen_dungeon_notch(map,xreg,yreg,chcx*16+rand.nextInt(16)+8,rand.nextInt(maxy-miny)+miny,chcy*16+rand.nextInt(16)+8,rand);
        end;

        if gen_lakes=true then
          if t1=14 then
          begin
            if rand.nextInt(3)=0 then
              gen_lakes_notch(map,xreg,yreg,chcx*16+rand.nextInt(16)+8,rand.nextInt(maxy-miny)+miny,chcy*16+rand.nextInt(16)+8,11,rand);
          end
          else
          begin
            if t1=5 then x:=5
            else x:=0;
            for z:=0 to x do
            begin
              if (t1=5)or(rand.nextInt(3)=0) then
                gen_lakes_notch(map,xreg,yreg,chcx*16+rand.nextInt(16)+8,rand.nextInt(maxy-miny)+miny,chcy*16+rand.nextInt(16)+8,9,rand);
              if rand.nextInt(5)=0 then
                gen_lakes_notch(map,xreg,yreg,chcx*16+rand.nextInt(16)+8,rand.nextInt(maxy-miny)+miny,chcy*16+rand.nextInt(16)+8,11,rand);
            end;
          end;

        rand.Free;
      end;
    end;
end;

function gen_region(i,j:integer; map:region):boolean; register;
var k,z,t:integer;
tempxot,tempxdo,tempyot,tempydo,chx,chy:integer;
reg_change:boolean;
begin
  t:=getcurrenttime;

  //opredelaem izmenenie koordinati regiona po osi X
  if first_region=true then
  begin
    x_reg_old:=i;
    first_region:=false;
    reg_change:=false;
  end
  else
  begin
    if x_reg_old<>i then
    begin
      reg_change:=true;
      x_reg_old:=i;
    end
    else reg_change:=false;      
  end;

  //ochishaem povtoreniya
  //ishem povtoreniya
  for k:=0 to length(obj)-2 do
  begin
    if obj[k].y=1000 then continue;
    for z:=k+1 to length(obj)-1 do
    begin
      if obj[z].y=1000 then continue;
      if (obj[k].x=obj[z].x)and(obj[k].y=obj[z].y)and
      (obj[k].z=obj[z].z)and(obj[k].id=obj[z].id) then
        obj[z].y:=1000;
    end;
  end;

  //samo udalenie
  k:=0;
  if length(obj)>2 then
  repeat
    if obj[k].y=1000 then
    begin
      if k<>(length(obj)-1) then
        move(obj[k+1],obj[k],(length(obj)-k-1)*sizeof(TObj));
      setlength(obj,length(obj)-1);
    end
    else
      inc(k);
  until k>(length(obj)-1);

  //opredelenie polozheniya portala v END
  if map_has_portal=false then
    create_end_portal(i,j,map);

  //generaciya dungey i ozer
  gen_lakes_dung(i,j,map);

  //otrisovka ob'ektov
  gen_objects(i,j,map);

  //delaem Glaciers
  gen_glaciers_region(i,j,map);

  //delaem sneg
  gen_snow_region(i,j,map);


  //ishem uzhe neispol'zuemie ob'ekti i pomechaem ih
  //schitaem koordinati nachalnih i konechnih chankov v regione
  if i<0 then
  begin
    tempxot:=(i+1)*32-32;
    tempxdo:=(i+1)*32+3;
  end
  else
  begin
    tempxot:=i*32;
    tempxdo:=(i*32)+35;
  end;

  if j<0 then
  begin
    tempyot:=(j+1)*32-32;
    tempydo:=(j+1)*32+3;
  end
  else
  begin
    tempyot:=j*32;
    tempydo:=(j*32)+35;
  end;

  dec(tempxot,2);
  dec(tempxdo,2);
  dec(tempyot,2);
  dec(tempydo,2);

  //delaem granicu iz vnutrennih chankov
  inc(tempxot,4);
  dec(tempxdo,4);
  inc(tempyot,4);
  dec(tempydo,4);

  //prosmatrivaem massiv
  for k:=0 to length(obj)-1 do
  begin
    //opredelaem, k kakomu chanku otnositsa
    chx:=obj[k].x;
    chy:=obj[k].z;

    if chx<0 then inc(chx);
    if chy<0 then inc(chy);

    chx:=chx div 16;
    chy:=chy div 16;

    if (chx<=0)and(obj[k].x<0) then dec(chx);
    if (chy<=0)and(obj[k].z<0) then dec(chy);

    //proveraem na izmenenie regiona
    if reg_change=true then
    begin
      if (chx<(tempxot-4)) then obj[k].y:=1000;
      if (chx>=tempxot)and(chx<=tempxdo)and(chy>=tempyot)and(chy<=tempydo) then
        obj[k].y:=1000;
    end
    else
    begin
      if (chx>=tempxot)and(chx<=tempxdo)and(chy>=tempyot)and(chy<=tempydo) then
        obj[k].y:=1000;
    end;
  end;

  //udalaem ob'ekti
  k:=0;
  if length(obj)>2 then
  repeat
    if obj[k].y=1000 then
    begin
      if k<>(length(obj)-1) then
        move(obj[k+1],obj[k],(length(obj)-k-1)*sizeof(TObj));
      setlength(obj,length(obj)-1);
    end
    else
      inc(k);
  until k>(length(obj)-1);

  t:=getcurrenttime-t;

  postmessage(app_hndl,WM_USER+307,-100000,t);

  result:=true;
end;

end.

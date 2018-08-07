unit generation;

interface

const PROTOCOL_DLL = 5;
WM_USER = $0400;

type byte_ar = array of byte;
     int_ar = array of integer;
     
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
       Id:PChar;
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
       Id:PChar;
       x,y,z:integer;
       data:pointer;
     end;  

     TGen_chunk = record
       Biomes:byte_ar;
       Blocks:byte_ar;
       Data:byte_ar;
       Light:byte_ar;
       Skylight:byte_ar;
       Heightmap:int_ar;
       Has_additional_id:Boolean;
       sections:array[0..15] of boolean;
       Add_id:byte_ar;
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

     //tipi dla sohraneniya parametrov generacii
     layer=record
       start_alt:integer;
       width:integer;
       material:integer;
       material_data:byte;
       name:string[26];
     end;

     layers_ar = array of layer;

     //infa o versii fayla
     TFileVersionInfo = record 
       FileType,
       CompanyName,
       FileDescription,
       FileVersion,
       InternalName,
       LegalCopyRight,
       LegalTradeMarks,
       OriginalFileName,
       ProductName,
       ProductVersion,
       Comments,
       SpecialBuildStr,
       PrivateBuildStr,
       FileFunction : string;
       DebugBuild,
       PreRelease,
       SpecialBuild,
       PrivateBuild,
       Patched,
       InfoInferred : Boolean;
     end;

     line=array of TGen_Chunk;
     region=array of line;

var last_error:PChar;    //stroka s soobsheniem ob oshibke
plug_info_return:TPlugRec;   //zapis' s informaciey o razmerah tipov dannih dla viyasneniya sootvetstviya
plugin_settings:TPlugSettings;   //zapis' s informaciey o plagine
dll_path_str:string = '';  //stroka s putem do DLLki
app_hndl:cardinal;  //hendl Application menedgera
initialized:boolean = false;  //priznak inicializacii plagina
initialized_blocks:boolean = false;  //priznak peredachi massiva blokov
crc_manager:int64;    //CRC poluchennoe ot menedgera
flux:TFlux_set;  //zapis' s informaciey o izmenenii parametrov
mess_to_manager:PChar;   //stroka dla peredachi soobsheniy v menedger
stopped:boolean = false;   //priznak ostanovki generacii

sloi:layers_ar;  //massiv sloev dla generacii

blocks_ids:array of TBlock_set;


function init_generator(gen_set:TGen_settings; var bord_in,bord_out:integer):boolean;
function generate_chunk(i,j:integer):TGen_Chunk;
procedure clear_dynamic;
function gen_region(i,j:integer; var map:region):boolean; register;

function GetBlockId(str:string):integer;
function GetBlockIndexByName(str:string):integer;
function GetBlockIndexByID(id:integer):integer;
function GetBlockName(id:integer):string;

implementation

uses sysutils, randomMCT, windows, crc32_u;

var chunk:TGen_Chunk;
rnd_var:rnd;

function GetBlockId(str:string):integer;
var i:integer;
begin
  for i:=0 to length(blocks_ids)-1 do
    if uppercase(blocks_ids[i].name)=uppercase(str) then
    begin
      result:=blocks_ids[i].id;
      exit;
    end;

  result:=255;
end;

function GetBlockIndexByName(str:string):integer;
var i:integer;
begin
  for i:=0 to length(blocks_ids)-1 do
    if uppercase(blocks_ids[i].name)=uppercase(str) then
    begin
      result:=i;
      exit;
    end;

  result:=255;
end;

function GetBlockIndexByID(id:integer):integer;
var i:integer;
begin
  for i:=0 to length(blocks_ids)-1 do
    if blocks_ids[i].id=id then
    begin
      result:=i;
      exit;
    end;

  result:=255;
end;

function GetBlockName(id:integer):string;
var i:integer;
begin
  for i:=0 to length(blocks_ids)-1 do
    if id=blocks_ids[i].id then
    begin
      result:=blocks_ids[i].name;
      exit;
    end;
  result:='Unknown block';  
end;

procedure clear_dynamic;
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
end;

function init_generator(gen_set:TGen_settings; var bord_in,bord_out:integer):boolean;
var x,y,z,t:integer;
mat,data:integer;
r:rnd;
begin
  stopped:=false;

  //soobshenie ob ochishenii paneli
  postmessage(app_hndl,WM_USER+300,plugin_settings.plugin_type and 7,0);

  //peredaem soobshenie o smene leybla
  mess_to_manager:=pchar('Initializing flatmap generator');
  postmessage(app_hndl,WM_USER+305,integer(mess_to_manager),4);

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

  //messagebox(app_hndl,pchar('CRC reseived='+inttohex(crc_manager,16)),'Message',mb_ok);
  //proveraem avtorizaciyu
  t:=crc_manager and $FFFFFFFF;  //opredelayushee chislo
  x:=crc_manager shr 32;     //izmenennoe CRC
  //vichislaem CRC ot infi
  calcCRC32(@plugin_settings,sizeof(plugin_settings),y);
  //messagebox(app_hndl,pchar('CRC nachalnoe='+inttohex(y,8)),'Message',mb_ok);
  //sozdaem random s sidom iz CRC
  r:=rnd.Create(y);
  //vichislaem kol-vo vizovov randoma
  mat:=((t shr 4)and 1)+((t shr 13) and 2)+((t shr 18)and 4)+((t shr 26) and 8);
  //delaem opredelennoe kol-vo vizivov randoma
  for z:=1 to mat do
    r.nextInt;
  t:=r.nextInt;
  //messagebox(app_hndl,pchar('CRC izmenennoe='+inttohex(t,8)+#13+#10+'CRC izmenennoe iz menedgera='+inttohex(x,8)),'Message',mb_ok);
  r.Free;

  //zapolnaem v sootvetstvii so sloyami
  zeromemory(chunk.Biomes,length(chunk.Biomes));
  zeromemory(chunk.Blocks,length(chunk.Blocks));
  zeromemory(chunk.Data,length(chunk.Data));

  rnd_var:=rnd.Create(gen_set.SID);

  //proveraem pravilnost' CRC
  if t=x then
  begin
    //messagebox(app_hndl,pchar('Voshli v bloki'),'Message',mb_ok);
    for t:=0 to length(sloi)-1 do
    begin
      mat:=sloi[t].material;
      data:=sloi[t].material_data;
      for y:=sloi[t].start_alt to sloi[t].start_alt+sloi[t].width-1 do
        for x:=0 to 15 do
          for z:=0 to 15 do
          begin
            chunk.Blocks[x+z*16+y*256]:=mat;
            if data<>0 then chunk.Data[x+z*16+y*256]:=data;
          end;
    end;
  end;

  //menaem tochku spauna
  x:=0;
  z:=0;
  y:=sloi[length(sloi)-1].start_alt+sloi[length(sloi)-1].width+1;
  postmessage(app_hndl,WM_USER+306,0,x);
  postmessage(app_hndl,WM_USER+306,1,y);
  postmessage(app_hndl,WM_USER+306,2,z);

  //peredaem soobshenie o smene leybla
  mess_to_manager:='Flatmap generator ready';
  postmessage(app_hndl,WM_USER+305,integer(mess_to_manager),4);

  result:=true;
end;

function generate_chunk(i,j:integer):TGen_Chunk;
var t,mat,data,x,y,z:integer;
begin
  if stopped then
  begin
    mess_to_manager:='Reseived chunk return after stop';
    postmessage(app_hndl,WM_USER+309,integer(mess_to_manager),0);
    result:=chunk;
    exit;
  end; 

  result:=chunk;
end;

function gen_region(i,j:integer; var map:region):boolean; register;
begin
  result:=false;
end;

end.

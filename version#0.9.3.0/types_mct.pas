unit types_mct;

interface

uses jpeg;

const time_const:extended=1000/60;
WM_USER = $0400;
WM_NEXTDLGCTL = $0028;


type
  byte_ar = array of byte;
  pbyte_ar = ^byte_ar;

  int_ar = array of integer;

  //tipi dla mnozhestv blokov
  for_set = 0..255;
  set_trans_blocks = set of for_set;

  //tip dannih dla hraneniya light_level, diffuse_level
  TID_data = record
    id,data:integer;
  end;
  TID_data_ar = array of TID_data;

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
  TBlock_set_ar = array of TBlock_set;
  pTBlock_set_ar = ^TBlock_set_ar;

  //tip dla zameni blokov
  TBlock_change = record
    fromID,toID:integer;
    fromData,toData:byte;
  end;
  TBlock_change_ar = array of TBlock_change;

  //tip dla infi o plagine
  pTPlugSettings=^TPlugSettings;
  TPlugSettings = packed record
    plugin_type:byte;
    aditional_type:byte;
    full_name:PChar;
    name:PChar;
    author:PChar;
    dll_path:PChar;
    maj_v, min_v, rel_v:byte; //version
    change_par:array[1..21] of boolean;
    has_preview:boolean;
  end;

  //tip dla polucheniya infi o plagine
  TPlugRec = record
    size_info:integer;
    size_flux:integer;
    size_gen_settings:integer;
    size_chunk:integer;
    size_change_block:integer;
    data:pointer;
  end;

  //tip dla izmeneniya parametrov
  TFlux_set = record
    available:Boolean;
    min_max:boolean;
    default:int64;
    min:int64;
    max:int64;
  end;

  //tip dla nastroek igroka
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

  //tip dla nastroek generatora
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

//****************************************************************
  //tip dla opisaniya Entity
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

  //tip dla opisaniya TileEntity
  TTile_entity_type = record
    Id:string;
    x,y,z:integer;
    data:pointer;
  end;

  ar_entity_type=array of TEntity_type;
  par_entity_type=^ar_entity_type;

  ar_tile_entity_type=array of TTile_entity_type;
  par_tile_entity_type=^ar_tile_entity_type;

  //tip dla inventara i sundukov, furnace, dispenser
  pslot_item_data=^slot_item_data;
  slot_item_data=record
    id:smallint;
    damage:smallint;
    count,slot:byte;
  end;

    //Furnace
     pfurnace_tile_entity_data=^furnace_tile_entity_data;
     furnace_tile_entity_data=record
       burn_time, cook_time:smallint;  //BurnTime=vremya do propadaniya ogn'ya; CookTime=vremya do obzhiganiya resursa (vse vremya v tikah)
       //pri bol'shom burntime indikator zapolnen a potom kak vrema zakanchivaetsa - indikator obichno umen'shitsa do nula (predpolozhitel'no)
       items:array of slot_item_data;  //slot 0=gotovashiesa; 1=toplivo; 2=resultat
     end;

    //Sign
     psign_tile_entity_data=^sign_tile_entity_data;
     sign_tile_entity_data=record
       text:array[1..4]of string[15];   //esli stroki pustie, to v programme oni dolzhni bit' proinicializirovani tak: text[x]:='';
     end;

     //MonsterSpawner
     pmon_spawn_tile_entity_data=^mon_spawn_tile_entity_data;
     mon_spawn_tile_entity_data=record
       entityid:string; //id moba, kotoriy spavnitsa (i ne tol'ko moba)
       delay:smallint;
     end;

     //Chest
     pchest_tile_entity_data=^chest_tile_entity_data;
     chest_tile_entity_data=record
       items:array of slot_item_data;  //ot 0 do 26 (vsego 27=3*9)
     end;

     //Note Block
     pnote_tile_entity_data=^note_tile_entity_data;
     note_tile_entity_data=record
       pitch:byte; //kol-vo nazhatiy pravoy knopkoy
     end;

     //Dispenser
     pdispenser_tile_entity_data=^dispenser_tile_entity_data;
     dispenser_tile_entity_data=record
       items:array of slot_item_data;     //kol-vo ot 0 do 8 (sloti 0-8)
     end;

     //Jukebox
     pjukebox_tile_entity_data=^jukebox_tile_entity_data;
     jukebox_tile_entity_data=record
       rec:integer; //item ID veshi (mozhet bit' ne tol'ko plastinka). Esli vnutri nichego net, to pole otsutstvuet (nuzhno prisvaivat' -1)
       //chtobi plastinka viprigivala po PKM, to nado v date k bloku JukeBox postavit' 1
       //esli ne propisat' data, to vesh vseravno vipadet pri razbivanii
     end;

     //Brewing Stand (Cauldron)
     pcauldron_tile_entity_data=^cauldron_tile_entity_data;
     cauldron_tile_entity_data=record
       brew_time:smallint;
       items:array of slot_item_data;     //kol-vo ot 0 do 3 (sloti 0-3) Slot3=resurs, kotoriy pererabativaetsa
     end;

//********************************************************------------
  //tip dla chanka
  {TChunk = record
    Biomes:byte_ar;
    Blocks:byte_ar;
    Data:byte_ar;
    Has_additional_id:Boolean;
    Add_id:byte_ar;
    has_skylight,has_blocklight:boolean;
    Skylight:byte_ar;
    Light:byte_ar;
    Entities:array of TEntity_type;
    Tile_entities:array of TTile_entity_type;
  end;  }

  //tip dla izmeneniya ID blokov
  TChange_block = record
    id:integer;
    name:PChar;
    solid,transparent:Boolean;
    light_level:integer;
  end;

  //tip dla chanka
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
    Entities:ar_entity_type;
    Tile_entities:ar_tile_entity_type;
  end;

  line=array of TGen_Chunk;
  region=array of line;

  //tipi dla funkciy plagina
  TGet_prot = function (protocol:integer):integer; register;
  TGet_info = function:TPlugRec; register;
  TInit = function (hndl:Cardinal; temp:int64):boolean; register;
  TGet_diff = function (id:integer):TFlux_set; register;
  TGet_compatible = function (plugin_info:TPlugRec):boolean; register;
  TGet_last_err = function:PChar; register;
  TInit_gen = function (gen_set:TGen_settings; var bord_in,bord_out:integer):boolean; register;
  TGet_chunk = function (i,j:integer):TGen_Chunk; register;
  TGet_chunk2 = function (xreg,yreg,i,j:integer):TGen_Chunk; stdcall;
  TGet_chunk_add = function (i,j:integer; var chunk:TGen_Chunk):boolean; register;
  TStop_gen = procedure (i:integer); register;
  //TReplace_blocks = function (ids:array of TChange_block):boolean;
  TSet_blocks = function (ids:array of TBlock_set):boolean; register;
  TShow_wnd = function (gen_set:TGen_settings):integer; register;
  TGen_region = function (i,j:integer; map:region):boolean; register;

  //tip dla plagina
  pTPlugin_type = ^TPlugin_type;
  TPlugin_type = record
    active:boolean;
    handle:cardinal;
    info:TPlugSettings;
    plug_version:string;
    plug_file:string;
    plug_full_name:string[30];
    plug_name:string[30];
    plug_author:string[30];
    crc_info:int64;
    plugrec:TPlugRec;
    preview:TJPEGImage;
    auth:boolean;

    get_protocol:TGet_prot;
    get_info:TGet_info;
    init:TInit;
    get_different_settings:TGet_diff;
    get_compatible:TGet_compatible;
    get_last_error:TGet_last_err;
    init_gen:TInit_gen;
    gen_chunk:TGet_chunk;
    gen_chunk2:TGet_chunk2;
    get_chunk_add:TGet_chunk_add;
    stop_gen:TStop_gen;
    set_block_id:TSet_blocks;
    show_settings_wnd:TShow_wnd;
    gen_region:TGen_region;
  end;

  //massiv plaginov
  TPlugin_ar = array of TPlugin_type;

  form_coord=record
    top,left:integer;
  end;

  //tip dla sohraneniya nastroek
  save_options_type=record
    save_enabled:boolean;
    save_type:integer;
    fast_load:boolean;
    change_disabled:boolean;
    main_f,options_f,blocks_f,about_f,border_f:form_coord;
    sid:int64;
  end;

  //massiv hendlov dla potokov
  pTHNDL_ar = ^THNDL_ar;
  THNDL_ar = array of cardinal;

  mcheader=record       //tip dannih, opisivayushiy zagolovok fayla regionov Minecraft
    mclocations:array[1..1024] of cardinal;
    mctimestamp:array[1..1024] of longint;
  end;


const plug_size = sizeof(TPlugSettings);
flux_size = sizeof(TFlux_set);
gen_settings_size = sizeof(TGen_settings);
chunk_size = sizeof(TGen_Chunk);
change_block_size = sizeof(TBlock_set);
PROTOCOL = 5;

implementation

end.

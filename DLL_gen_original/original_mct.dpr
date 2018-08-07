library original_mct;

{$DESCRIPTION 'Original minecraft generator plugin for MCTerra'}
  
{$R *.res}
//{$R preview.res}

uses
  sharemem,
  windows,
  sysutils,
  F_Version in 'F_Version.pas',
  generation in 'generation.pas',
  RandomMCT in 'RandomMCT.pas',
  crc32_u in 'crc32_u.pas',
  IChunkProvider_u in 'IChunkProvider_u.pas',
  ChunkProviderGenerate_u in 'ChunkProviderGenerate_u.pas',
  NoiseGenerator_u in 'NoiseGenerator_u.pas',
  NoiseGeneratorPerlin_u in 'NoiseGeneratorPerlin_u.pas',
  NoiseGeneratorOctaves_u in 'NoiseGeneratorOctaves_u.pas',
  MathHelper_u in 'MathHelper_u.pas',
  BiomeGenBase_u in 'BiomeGenBase_u.pas',
  BiomeGenForest_u in 'BiomeGenForest_u.pas',
  BiomeGenHills_u in 'BiomeGenHills_u.pas',
  GenLayer_u in 'GenLayer_u.pas',
  LayerIsland_u in 'LayerIsland_u.pas',
  IntCache_u in 'IntCache_u.pas',
  GenLayerZoomFuzzy_u in 'GenLayerZoomFuzzy_u.pas',
  BIomeGenOcean_u in 'BIomeGenOcean_u.pas',
  BiomeGenPlains_u in 'BiomeGenPlains_u.pas',
  BiomeGenDesert_u in 'BiomeGenDesert_u.pas',
  BiomeGenTaiga_u in 'BiomeGenTaiga_u.pas',
  BiomeGenSwamp_u in 'BiomeGenSwamp_u.pas',
  BiomeGenRiver_u in 'BiomeGenRiver_u.pas',
  BiomeGenHell_u in 'BiomeGenHell_u.pas',
  BiomeGenEnd_u in 'BiomeGenEnd_u.pas',
  BiomeGenSnow_u in 'BiomeGenSnow_u.pas',
  BiomeGenMushroomIsland_u in 'BiomeGenMushroomIsland_u.pas',
  BiomeGenBeach_u in 'BiomeGenBeach_u.pas',
  GenLayerIsland_u in 'GenLayerIsland_u.pas',
  GenLayerZoom_u in 'GenLayerZoom_u.pas',
  GenLayerSnow_u in 'GenLayerSnow_u.pas',
  GenLayerMushroomIsland_u in 'GenLayerMushroomIsland_u.pas',
  GenLayerRiverInit_u in 'GenLayerRiverInit_u.pas',
  GenLayerRiver_u in 'GenLayerRiver_u.pas',
  GenLayerSmooth_u in 'GenLayerSmooth_u.pas',
  GenLayerVillageLandscape_u in 'GenLayerVillageLandscape_u.pas',
  GenLayerHills_u in 'GenLayerHills_u.pas',
  GenLayerTemperature_u in 'GenLayerTemperature_u.pas',
  GenLayerDownfall_u in 'GenLayerDownfall_u.pas',
  GenLayerShore_u in 'GenLayerShore_u.pas',
  GenLayerSwampRivers_u in 'GenLayerSwampRivers_u.pas',
  GenLayerSmoothZoom_u in 'GenLayerSmoothZoom_u.pas',
  GenLayerTemperatureMix_u in 'GenLayerTemperatureMix_u.pas',
  GenLayerDownfallMix_u in 'GenLayerDownfallMix_u.pas',
  GenLayerRiverMix_u in 'GenLayerRiverMix_u.pas',
  GenLayerZoomVoronoi_u in 'GenLayerZoomVoronoi_u.pas',
  WorldChunkManager_u in 'WorldChunkManager_u.pas',
  LongHashMapEntry_u in 'LongHashMapEntry_u.pas',
  LongHashMap_u in 'LongHashMap_u.pas',
  BiomeCache_u in 'BiomeCache_u.pas',
  BiomeCacheBlock_u in 'BiomeCacheBlock_u.pas',
  MapGenBase_u in 'MapGenBase_u.pas',
  MapGenCaves_u in 'MapGenCaves_u.pas',
  MapGenRavine_u in 'MapGenRavine_u.pas',
  WorldGenerator_u in 'WorldGenerator_u.pas',
  WorldGenLakes_u in 'WorldGenLakes_u.pas',
  WorldGenDungeons_u in 'WorldGenDungeons_u.pas',
  WorldGenClay_u in 'WorldGenClay_u.pas',
  WorldGenSand_u in 'WorldGenSand_u.pas',
  WorldGenMinable_u in 'WorldGenMinable_u.pas',
  WorldGenFlowers_u in 'WorldGenFlowers_u.pas',
  WorldGenBigMushroom_u in 'WorldGenBigMushroom_u.pas',
  WorldGenReed_u in 'WorldGenReed_u.pas',
  WorldGenCactus_u in 'WorldGenCactus_u.pas',
  MapGenWaterlily_u in 'MapGenWaterlily_u.pas',
  BiomeDecorator_u in 'BiomeDecorator_u.pas',
  WorldGenTrees_u in 'WorldGenTrees_u.pas',
  WorldGenBigTree_u in 'WorldGenBigTree_u.pas',
  WorldGenForest_u in 'WorldGenForest_u.pas',
  WorldGenTaiga1_u in 'WorldGenTaiga1_u.pas',
  WorldGenTaiga2_u in 'WorldGenTaiga2_u.pas',
  WorldGenSwamp_u in 'WorldGenSwamp_u.pas',
  WorldGenTallGrass_u in 'WorldGenTallGrass_u.pas',
  WorldGenDeadBush_u in 'WorldGenDeadBush_u.pas',
  WorldGenPumpkin_u in 'WorldGenPumpkin_u.pas',
  WorldGenLiquids_u in 'WorldGenLiquids_u.pas';

var i:integer;
ver:TFileVersionInfo;
hndl:THandle;

function GetModuleFileNameStr(Instance: THandle): string;
var
  buffer: array [0..MAX_PATH] of Char;
begin
  GetModuleFileName( Instance, buffer, MAX_PATH);
  Result := buffer;
end;

function get_protocol(protocol:integer):integer; register;
begin
  result:=PROTOCOL_DLL;
end;

function get_info:TPlugRec; register;
begin
  plug_info_return.size_info:=sizeof(TPlugSettings);
  plug_info_return.size_flux:=sizeof(TFlux_set);
  plug_info_return.size_gen_settings:=sizeof(TGen_settings);
  plug_info_return.size_chunk:=sizeof(TGen_Chunk);
  plug_info_return.size_change_block:=sizeof(TBlock_set);
  plug_info_return.data:=@plugin_settings;
  result:=plug_info_return;
end;

function Init(hndl:LongWord; temp:int64):boolean; register;
begin
  app_hndl:=hndl;
  
  initialized:=true;

  //perepisivaem crc
  crc_manager:=temp;  
   
  result:=true;
end;

function get_different_settings(id:integer):TFlux_set; register;
begin
  result:=flux;
end;

function get_compatible(plugin_info:TPlugRec):boolean; register;
begin
  result:=true;   //sovmestim so vsem
  //vozmozhno izmenenie v buduyushem
end;

function get_last_error:PChar; register;
begin
  result:=last_error;
end;

function Init_gen(gen_set:TGen_settings; var bord_in,bord_out:integer):Boolean; register;
begin
  result:=init_generator(gen_set,bord_in,bord_out);
end; 

function gen_chunk(xreg,yreg,i,j:integer):TGen_Chunk; stdcall;
begin
  result:=generate_chunk(i,j);
end;

function get_chunk_add(i,j:integer; var chunk:TGen_Chunk):Boolean; register;
begin
  result:=false;  //plagin ne yavlaetsa dopolnitelnim plaginom
end;

procedure stop_gen(i:integer);register;
begin
  stopped:=true;

  mess_str:='Reseived stoping message with code '+inttostr(i);
  mess_to_manager:=pchar(mess_str);
  postmessage(app_hndl,WM_USER+309,integer(mess_to_manager),0);

  if i=1 then
    clear_dynamic;
end;

function set_block_id(ids:array of TBlock_set):Boolean; register;
begin
  last_error:='Plugin doesn''t support change of block IDs';
  result:=true;
end;

Function show_settings_wnd(gen_set:TGen_settings):integer; register;
begin
  if (initialized=true) then
  begin
    messagebox(app_hndl,'There are not supposed to be any settings','Notice',MB_OK);
    result:=1;
  end
  else
  begin
    last_error:='Plugin has not been initialized when manager wants to show a window';
    result:=0;
  end;
end;

exports
  get_protocol, get_info, Init, get_different_settings,
  get_compatible, get_last_error, Init_gen, gen_chunk,
  get_chunk_add, stop_gen, set_block_id, show_settings_wnd,
  gen_region;

begin
  plugin_settings.plugin_type:=168;  //landscape with auth
  plugin_settings.aditional_type:=2;
  plugin_settings.full_name:='Original generator for MCTerra';
  plugin_settings.name:='Original';
  plugin_settings.author:='Mozzg';
  dll_path_str:=pchar(GetModuleFileNameStr(hinstance));
  plugin_settings.dll_path:=pchar(dll_path_str);
  plugin_settings.maj_v:=0;
  plugin_settings.min_j:=0;
  plugin_settings.rel_v:=3;
  for i:=1 to 21 do
    plugin_settings.change_par[i]:=true;
  plugin_settings.has_preview:=false;

  flux.available:=true;
  flux.min_max:=false;
  flux.default:=-1;

  last_error:='No errors';

  ver:=FileVersionInfo(paramstr(0));

  if (ver.CompanyName<>'Mozg production')or
  (ver.FileDescription<>'MineCraft TERRAin generator')or
  (ver.InternalName<>'Terra')or
  (ver.LegalCopyRight<>'Pervov "Mozzg" Evgeniy')or
  (ver.ProductName<>'MCTerra')or
  (ver.SpecialBuild<>true) then
  begin
    hndl:=getmodulehandle(pchar(dll_path_str));
    freelibrary(hndl);
  end;
end.

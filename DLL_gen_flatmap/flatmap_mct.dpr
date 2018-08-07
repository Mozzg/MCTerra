library flatmap_mct;

{$DESCRIPTION 'Flatmap generator plugin for MCTerra'}
  
{$R *.res}
{$R preview.res}

uses
  sharemem,
  settingsf in 'settingsf.pas' {settings},
  generation in 'generation.pas',
  windows,
  sysutils,
  crc32_u in 'crc32_u.pas',
  RandomMCT in 'RandomMCT.pas',
  F_Version in 'F_Version.pas';

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
  try
    init_form(app_hndl);
  except
    on e:exception do
    begin
      last_error:=pchar('Error ocured when initializing form with message:'+#13+#10+e.Message);
      result:=false;
      exit;
    end;
  end;
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

{function gen_chunk(i,j:integer):TChunk; register;
begin
  result:=generate_chunk(i,j);
end;}

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

  mess_to_manager:=pchar('Reseived stoping message with code '+inttostr(i));
  postmessage(app_hndl,WM_USER+309,integer(mess_to_manager),0);

  if i=1 then
    clear_dynamic;
end;

//function set_block_id(ids:array of TChange_block):Boolean;
function set_block_id(ids:array of TBlock_set):Boolean; register;
var i,j,k:integer;
begin
  {mess_to_manager:=pchar('Reseived set blocks function, length='+inttostr(length(ids)));
  postmessage(app_hndl,WM_USER+309,integer(mess_to_manager),0);  }

  setlength(blocks_ids,length(ids));

  for i:=0 to length(blocks_ids)-1 do
  begin
    j:=length(ids[i].data);
    setlength(blocks_ids[i].data,j);
    if j<>0 then
      for k:=0 to j-1 do
        blocks_ids[i].data[k]:=ids[i].data[k];
    blocks_ids[i].id:=ids[i].id;
    blocks_ids[i].name:=ids[i].name;
    blocks_ids[i].solid:=ids[i].solid;
    blocks_ids[i].transparent:=ids[i].transparent;
    blocks_ids[i].diffuse:=ids[i].diffuse;
    blocks_ids[i].tile:=ids[i].tile;
    blocks_ids[i].light_level:=ids[i].light_level;
    blocks_ids[i].diffuse_level:=ids[i].diffuse_level;
  end;

  //izmenaem spisok na forme
  settings.ComboBox3.Items.Clear;
  for i:=0 to length(blocks_ids)-1 do
    settings.ComboBox3.Items.Add(blocks_ids[i].name+' ('+inttostr(blocks_ids[i].id)+')');

  initialized_blocks:=true;
  result:=true;
  //last_error:='Plugin doesn''t support change of block IDs';
  //result:=false;
end;

Function show_settings_wnd:integer; register;
begin
  if (initialized=true)and(initialized_blocks=true) then
    result:=settings.ShowModal
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
  //plugin_settings.plugin_type:=0;  //landscape
  plugin_settings.plugin_type:=168;  //landscape with auth
  plugin_settings.aditional_type:=1;
  plugin_settings.full_name:='Flatmap generator for MCTerra';
  plugin_settings.name:='Flatmap';
  plugin_settings.author:='Mozzg';
  dll_path_str:=pchar(GetModuleFileNameStr(hinstance));
  plugin_settings.dll_path:=pchar(dll_path_str);
  plugin_settings.maj_v:=0;
  plugin_settings.min_j:=0;
  plugin_settings.rel_v:=2;
  for i:=1 to 21 do
    plugin_settings.change_par[i]:=true;
  plugin_settings.has_preview:=true;

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

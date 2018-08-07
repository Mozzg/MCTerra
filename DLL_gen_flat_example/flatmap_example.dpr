library flatmap_example;

{$R *.res}
{$R prev_example.res}  //this resourse contains preview picture
{To make preview picture, do the following:
1. Create a JPEG picture 250x200 pixels
2. Create <resource_name>.rc file with following text: "PREVIEW JPEG <picture_name>.jpg"
Note that you can change only name of the file, words PREVIEW and JPEG must remain untouched
3. Download file "brcc32.exe" from anywhere in the internet, or copy it from you C/Delphi bin folder
4. Place all files (picture, rc-file and brcc32.exe) in the same directory
5. Create a bat-file with the following text: "brcc32.exe <resource_name>.rc"
6. Run bat-file.

After this simple actions you should get res-file, witch must be placed in you project folder}


//Note that all functions use register calling convention and this must not be modified

uses
  sharemem,  //Sharemem unit is nessesary
  generation in 'generation.pas',   //unit for generation functions and all nessesary types
  settingsf in 'settingsf.pas' {settings},   //unit for settings form
  Windows, SysUtils;

var i:integer;

//function for getting a full path to current DLL
function GetModuleFileNameStr(Instance: THandle): string;
var
  buffer: array [0..MAX_PATH] of Char;
begin
  GetModuleFileName( Instance, buffer, MAX_PATH);
  Result := buffer;
end;

//exported function for getting an exchange protocol from DLL
//don't change this
function get_protocol(protocol:integer):integer; register;
begin
  result:=DLL_PROTOCOL;
end;

//exported function for getting information from DLL
//don't change this
function get_info:TPlugRec; register;
begin
  plugin_info.size_info:=sizeof(TPlugSettings);
  plugin_info.size_flux:=sizeof(TFlux_set);
  plugin_info.size_gen_settings:=sizeof(TGen_settings);
  plugin_info.size_chunk:=sizeof(TGen_Chunk);
  plugin_info.size_change_block:=sizeof(TBlock_set);
  plugin_info.data:=@plugin_settings;
  result:=plugin_info;
end;

//exported function for initialization of the plugin
//This function runs when manager hooks a DLL
//Parameters are:
//hndl - Application.Handle of manager for PostMessage functions
//temp - random number for further purposes
//If this function returns false, then the plugin is ignored
function Init(hndl:LongWord; temp:int64):boolean; register;
begin
  app_hndl:=hndl;
  try
    //Form initialization for creating the form.
    //If you don't create a form, then there would be error when you'll try to show it.
    //If your plugin don't need any settings, then you shouldn't
    //run this function and shouldn't create unit with the form.
    //If your plugin has very diverse settings, then you can create
    //any number of forms, but they must be initialized like in function init_form.
    init_form(app_hndl);  
  except
    on e:exception do
    begin
      last_error:=pchar('Error ocured when initializing form with message:'+#13+#10+e.Message);
      result:=false;
      exit;
    end;
  end;
  //Variable used to indicate that the form is created sucsessfuly
  //Used in show_settings_wnd function
  initialized:=true; 
   
  result:=true;
end;

//exported function for gettings different parameters min and max values (width and length of a map for example)
//In this example it returns always "Use manager defaults"
function get_different_settings(id:integer):TFlux_set; register;
begin
  result:=flux;
end;

//exported function to determine the compatibility of this plugin with other plugins
//In this example it always returns true, witch means, that this plugin is compatible with any other plugins
function get_compatible(plugin_info:TPlugRec):boolean; register;
begin
  result:=true;
end;

//exported function to send last error messages to manager
//dont' change this
function get_last_error:PChar; register;
begin
  result:=last_error;
end;

//exported function to initialize the generator
//This function runs one time when the user presses "Generate map" button
//It is supposed to make all nessesary preperations for main generation cicles
//gen_set parameter shows the generation settings, witch will be used in the generation
//
//Function returns true, if a generation was sucsessful; false if there is an error.
//If this function returns false, then the generation stops
function Init_gen(gen_set:TGen_settings):Boolean; register;
begin
  result:=init_generator(gen_set);
end;

//exported function to generate a sertain chunk
//This is a main generation function.
//It runs every time, when a manager needs to get a sertain chunk.
//i and j parameters represents chunk coordinates in minecraft world (global coordinates)
//
//Note: this function runs more, than there is chunks on a map,
//because every region has an additional border 2 chunks wide for
//internal purposes, so there whould be several runs of this function
//for some chunks
function gen_chunk(i,j:integer):TGen_Chunk; register;
begin
  result:=generate_chunk(i,j);
end;

//exported function to generate additional blocks on a chunk
//This function runs only for border and structures generators and never runs in landscape generators
//It returns true if the chunk has changed; false if there are no changes
function get_chunk_add(i,j:integer; var chunk:TGen_Chunk):Boolean; register;
begin
  result:=false;
end;

//exported function to stop a generation process
//This function runs one time with parameter i=0, if a user presses "Stop generation" button and if the plugin is initializing generator. Then it runs another time with parameter i=1.
//Also this function runs every time, when the generation sucsessfuly stops with paremeter i=1.
//This function purpose is to clean up any dynamic variables and set up default values.
procedure stop_gen(i:integer);register;
begin
  stopped:=true;

  mess_to_manager:=pchar('Reseived stoping message with code '+inttostr(i));
  postmessage(app_hndl,WM_USER+309,integer(mess_to_manager),0);

  if i=1 then
    clear_dynamic;
end;

//exported function to transfer array of blocks ID's, names and parameters
//Manager runs this function at the start of the program and after user change blocks parameters
//If this function returns false at the start of this program, manager marks this plugin as inactive and ignores it
//Return true to confirm block parameters change
function set_block_id(ids:array of TBlock_set):Boolean; register;
var i,j,k:integer;
begin
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

  //Change combobox on form
  settings.ComboBox1.Items.Clear;
  for i:=0 to length(blocks_ids)-1 do
    if blocks_ids[i].solid=true then
      settings.ComboBox1.Items.Add(blocks_ids[i].name+' ('+inttostr(blocks_ids[i].id)+')');

  initialized_blocks:=true;
  result:=true;     
end;

//exported function to show a settings window of the plugin
//This function returns a ModalResult of a window call or 0 if it fails
function show_settings_wnd:integer; register;
begin
  if (initialized=true)and(initialized_blocks=true) then
    result:=settings.ShowModal
  else
  begin
    last_error:='Plugin has not been initialized when manager wants to show a window';
    result:=0;
  end;
end;

//exported function to add some blocks after all chunks of a region has been generated
//You can access all chunks of current generated region with this function.
//i,j is a region coordinates (used in region file names)
//map is 36x36 array of chunks in a region
//Function always returns true
//
//Note that a normal region has 32x32 chunks, but this region has
//36x36 chunks for internal purpose. So real region chunks
//begin at 2 and ends at 33 (starts with 0).
//Also note that there can be empty chunks if this region is a border
//region and user choose map size, that can't fill all regions fully.
function gen_region(i,j:integer; map:region):boolean; register;
begin
  result:=true;
end;


//Note that all functions can be in any other units, but they must be global
exports
  get_protocol, get_info, Init, get_different_settings,
  get_compatible, get_last_error, Init_gen, gen_chunk,
  get_chunk_add, stop_gen, set_block_id, show_settings_wnd,
  gen_region;

begin
  //plugin variables initialization
  dll_path_str:='';
  last_error:='No errors';
  initialized:=false;
  initialized_blocks:=false;
  stopped:=false;
  level_height:=63;
  fill_id:=1;

  //plugin settings info initialization
  plugin_settings.plugin_type:=0;  //landscape plugin type
  plugin_settings.aditional_type:=1;  //normal landscape type
  plugin_settings.full_name:='Flatmap example plugin';  //will be visible in plugin info
  plugin_settings.name:='Flatmap example';  //plugin name in plugin list
  plugin_settings.author:='Mozzg';
  dll_path_str:=pchar(GetModuleFileNameStr(hinstance));
  plugin_settings.dll_path:=pchar(dll_path_str);  //this need to be done for further campatibility
  plugin_settings.maj_v:=0;
  plugin_settings.min_j:=0;
  plugin_settings.rel_v:=1;    //plugin version
  for i:=1 to 21 do
    plugin_settings.change_par[i]:=true;
  plugin_settings.has_preview:=true;  //this should be false if you have no preview attached to this DLL, otherwise this plugin will be ignored

  //Flux record initialization to signal the manager to use default parameter values
  flux.available:=true;
  flux.min_max:=false;
  flux.default:=-1;
end.
 
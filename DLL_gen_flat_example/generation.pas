unit generation;

interface

const DLL_PROTOCOL = 4;  //DLL protocol in form of constant. Change this when you know what you are doing.
WM_USER = $0400;  //WM_USER constant, used in PostMessage functions
//For PostMessage function parameters, see end of this file

type  byte_ar = array of byte;
      int_ar = array of integer;

     //different types, used in DLL functions
     //don't change these types, unless protocol is changed
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

     line=array of TGen_Chunk;
     region=array of line;

     TBlock_data_set = record
       data_id:byte;
       data_name:string[45];
     end;

     TBlock_set = record
       id:integer;
       name:string[35];
       solid,transparent,diffuse,tile:boolean;
       light_level:byte;
       diffuse_level:byte;
       data:array of TBlock_data_set;
     end;



var plugin_info:TPlugRec;  //information about a plugin types, used in get_info function. Contains a pointer to Plugin_settings
plugin_settings:TPlugSettings;  //information about a plugin
dll_path_str:string;  //string, contains path to current DLL
flux:TFlux_set;  //variable, that is used in get_different_settings function
last_error:PChar;  //this variable contains last error message and used in get_last_error function
app_hndl:cardinal;  //this variable contains handle to manager's Application. Used to send messages to manager, using PostMessage function

//local variables
initialized:boolean;  //true if plugin has been initialized
initialized_blocks:boolean;  //true if plugin received blocks parameters array
stopped:boolean;  //true if manager sends stopping "message", false in every other cases
mess_to_manager:PChar;  //this is a PChar message, that is used to send strings to manager
blocks_ids:array of TBlock_set;  //array of blocks parameters, used only to store and access data by this plugin
level_height:integer;  //variable, showing the height of the filled part of the map
fill_id:integer;  //variable, showing ID of the fill block


function init_generator(gen_set:TGen_settings):boolean;
function generate_chunk(i,j:integer):TGen_Chunk;
procedure clear_dynamic;

implementation

uses Windows;

var chunk:TGen_Chunk;

//procedure to clean up dynamic variables
procedure clear_dynamic;
begin
  setlength(chunk.Biomes,0);
  setlength(chunk.Blocks,0);
  setlength(chunk.Data,0);
  setlength(chunk.Add_id,0);
  setlength(chunk.Skylight,0);
  setlength(chunk.Light,0);
  setlength(chunk.Entities,0);
  setlength(chunk.Tile_entities,0);
end;

//function to initialize the generator
//In this function plugin creates dynamic chunk and fills it with the chosen blocks id to chosen height
//Also it uses messages to send current status to the manager.
//At the end of this function plugins sends messages to change current spawn point of the map. If this isn't done, manager uses the default coordinates (0,64,0)
function init_generator(gen_set:TGen_settings):boolean;
var x,y,z:integer;
begin
  stopped:=false;

  //message to clear Statusbar
  postmessage(app_hndl,WM_USER+300,plugin_settings.plugin_type and 7,0);

  //message to change label
  mess_to_manager:=pchar('Initializing flatmap generator');
  postmessage(app_hndl,WM_USER+305,integer(mess_to_manager),4);

  //creating dynamic chunk
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

  //filling chunk with blocks
  zeromemory(chunk.Biomes,length(chunk.Biomes));
  zeromemory(chunk.Blocks,length(chunk.Blocks));
  zeromemory(chunk.Data,length(chunk.Data));

  for y:=level_height downto 0 do
    for x:=0 to 15 do
      for z:=0 to 15 do
        chunk.Blocks[x+z*16+y*256]:=fill_id;

  //changing spawn point
  x:=0;
  z:=0;
  y:=level_height+2;
  postmessage(app_hndl,WM_USER+306,0,x);
  postmessage(app_hndl,WM_USER+306,1,y);
  postmessage(app_hndl,WM_USER+306,2,z);

  //message to change label
  mess_to_manager:='Flatmap generator ready';
  postmessage(app_hndl,WM_USER+305,integer(mess_to_manager),4);

  result:=true;
end;

//function to return previously generated chunk
//If chunks are not the same, then you should fill chunks variable
//here with different blocks instead of init_generator function
function generate_chunk(i,j:integer):TGen_Chunk;
begin
  if stopped then
  begin
    //if this code will complete, there might be an error in manager
    //please report it to MCTerra creator
    mess_to_manager:='Reseived chunk return after stop';
    postmessage(app_hndl,WM_USER+309,integer(mess_to_manager),0);
  end;

  //fill chunk here with different blocks
  {for y:=level_height downto 0 do
    for x:=0 to 15 do
      for z:=0 to 15 do
        chunk.Blocks[x+z*16+y*256]:=7;}

  result:=chunk;  //you should always send chunk as a result
end;

end.



//////////////////////////////////////////
//PostMessage function parameters
PostMessage function has 4 parameters:
hWnd - Handle of form or application to receive a message. Should always be Application.handle of manager, witch can be received through Init function.
Msg - Message ID to send. This determine what action should be done in manager.
wParam, lParam - Parameters of the message. They are different for every different message ID.

For further explanation:
There are 4 changable labels and 1 progress bar on manager's status bar,
witch can be changed via PostMessage. 3 labels is on second panel
and 1 label on third panel of a status bar. Second label on second panel
is a special numeric label, that can be used to show quickly changing
numeric values without creating blinks for other labels.

Labels in this description is numbered from 1 to 4, for example:
you want to show following text on second panel:
"Generating object 35 of 1450", and the following text on third panel:
"Generating objects for region -2,3".
Obviously number of objects will be changing, so you should send the
following texts:
for label 1:"Generating object"
for label 2 (this is numeric label, so you should use numeric send to
be faster): number 35
for label 3:"of 1450"
for label 4:"Generating objects for region -2,3"
Then instead of sending all of this texts again, you should send
another numeric label with another number of objects generated.
Texts that are send to manager completley overrides existing texts.


List of message IDs that can be useful:
1. WM_USER+300 - Clear all labels and progress bar.
  This function clears all texts on all labels on status bar and
makes progress bar look enmpty (0% fill). Position and max parameters
of progress bar is set to 0. wParam must be 0, lParam can be any number.

2. WM_USER+301 - Clear progress bar.
  This function makes progress bar look enmpty (0% fill). Position and
max parameters of progress bar is set to 0. wParam must be 0, lParam
can be any number.

3. WM_USER+302 - Changes maxumim of progress bar.
  This function changes "Max" parameter of progress bar. Note that it
doesn't set "Max" parameter, instead it adds sertain value to this
parameter. wParam is the amount, that adds to Max, lParam must be 0.

4. WM_USER+303 - Changes the position of progress bar.
  This function sets "Position" parameter of progress bar to sertain
value. wParam - new position of progress bar, lParam must be 0.

5. WM_USER+304 - Changes the numeric value of second label.
  This function sets sertain number to be visible on second label.
wParam is new number, lParam must be 0.

6. WM_USER+305 - Change text on labels.
  This function sets sertain text on sertain labels. Text is sended via
PChar variable. wParam is PChar variable, converted to integer; lParam
is label ID and must be between 1 and 4.
Example of using this function:
  mess:=pchar('Initializing flatmap generator');
  postmessage(app_hndl,WM_USER+305,integer(mess),4);
It is preferable to use string variables with this function like this:
  mess_str:='Initializing flatmap generator';
  mess:=pchar(mess_str);
  postmessage(app_hndl,WM_USER+305,integer(mess),4);

7. WM_USER+306 - Change the spawn point of player.
  This function changes the spawn point of a player to a sertain
coordinates. wParam is coordinate or spawn position for a sertain ax,
lParam is parameter, indicating witch ax is used in this function
call (0-x; 1-y; 2-z).

8. WM_USER+307 - Data transfer to show in log.
  This function shows a message in log:
"Reseived data: <number1>; <number2>", where number1 is wParam
and number2 is lParam.

9. WM_USER+309 - String transfer to show in log.
  This function shows a message in log:
"Reseived string from plugin #<number1>=<string1>", where number1 is
lParam. wParam is a PChar variable, converted to integer. This functions
acts like WM_USER+305. Be sure to use string variables if you want to
show many log messages in a short amount of time.


=================WARNING===============
Do not use other messages or not possible parameters to these messages,
because it can crash the program.

unit load_sidf;

interface

uses
  Graphics, Controls, Forms,
  SysUtils, Classes, Dialogs, StdCtrls;

type
  Tload = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    OpenDialog1: TOpenDialog;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  load: Tload;

implementation

uses mainf, F_Version, biosphere_propf, generation_obsh, zlibex;

{$R *.dfm}

type TColor = -$7FFFFFFF-1..$7FFFFFFF;

const clGreen = TColor($008000);

var obshSID:string;
bloki:array[1..8] of string;

procedure clear_bloki;
var i:integer;
begin
  for i:=1 to 8 do
    bloki[i]:='';
end;

procedure Tload.Button1Click(Sender: TObject);
var b:boolean;
i,j,k,z:integer;
str,str1:string;
tun_light:array[1..6] of boolean;
begin
  b:=false;
    for i:=1 to 6 do
      if bloki[i]='' then
      begin
        b:=true;
        break;
      end;

  if b=true then
  begin
    application.MessageBox('Settings not loaded','Error');
    clear_bloki;
    exit;
  end;

  str:=inttostr(bintoint(copy(bloki[4],1,4)))+'.'+inttostr(bintoint(copy(bloki[4],5,6)))+'.'+inttostr(bintoint(copy(bloki[4],11,6)))+'.0';

  if (str='0.0.0.0')or(load.Label15.Font.Color<>clgreen) then
  begin
    //application.MessageBox('Bad version number, can''t read the file','Error');
    if messagedlg('Configuration file have development version. This may cause the program to crash.'+#13+#10+'Are you sure you want to continue?',mtConfirmation,mbOKCancel,0)=mrCancel then
    begin
      clear_bloki;
      exit;
    end;
  end;    

  //sid
  main.Edit4.Text:=inttostr(bintoint(bloki[2]));

  //dlinna i shirina karti
  i:=bintoint(copy(bloki[3],1,12));
  j:=bintoint(copy(bloki[3],13,12));
  main.Edit1.Text:=inttostr(i);
  main.Edit2.Text:=inttostr(j);
  if i=j then main.CheckBox1.Checked:=true
  else main.CheckBox1.Checked:=false;
  main.CheckBox1Click(main);

  //populate chunks
  if bloki[3][26]='1' then main.CheckBox2.Checked:=true
  else main.CheckBox2.Checked:=false;
  //generate structures
  if bloki[3][27]='1' then main.CheckBox3.Checked:=true
  else main.CheckBox3.Checked:=false;
  //game type
  i:=bintoint(copy(bloki[3],28,3));
  main.ComboBox2.ItemIndex:=i;
  //raining
  if bloki[3][31]='1' then main.CheckBox4.Checked:=true
  else main.CheckBox4.checked:=false;
  //rain time
  i:=bintoint(copy(bloki[3],32,20));
  main.Edit6.Text:=inttostr(i);
  //thundering
  if bloki[3][52]='1' then main.CheckBox5.Checked:=true
  else main.CheckBox5.checked:=false;
  //thundertime
  i:=bintoint(copy(bloki[3],53,20));
  main.Edit7.Text:=inttostr(i);
  main.CheckBox4Click(main);

  //nastroyki karti
  i:=bintoint(copy(bloki[5],1,5));
  main.ComboBox1.ItemIndex:=i;
  main.ComboBox1Change(main);
  case i of
  0:begin  //flatmap
      str:=bloki[5];
      delete(str,1,5);

      j:=length(str) div 20;
      setlength(main.flatmap_prop.sloi,0);
      for k:=1 to j do
      begin
        z:=length(main.flatmap_prop.sloi);
        setlength(main.flatmap_prop.sloi,z+1);
        main.flatmap_prop.sloi[z].width:=bintoint(copy(str,1,8));
        main.flatmap_prop.sloi[z].material:=bintoint(copy(str,9,8));
        main.flatmap_prop.sloi[z].material_data:=bintoint(copy(str,17,4));
        delete(str,1,20);
      end;

      main.flatmap_prop.sloi[0].start_alt:=0;
      main.flatmap_prop.sloi[0].name:='Bedrock';

      for k:=1 to length(main.flatmap_prop.sloi)-1 do
      begin
        main.flatmap_prop.sloi[k].start_alt:=main.flatmap_prop.sloi[k-1].start_alt+main.flatmap_prop.sloi[k-1].width;
        //main.flatmap_prop.sloi[k].name:='Layer '+inttostr(k);
        main.flatmap_prop.sloi[k].name:=getblockname(main.flatmap_prop.sloi[k].material)+' layer';
      end;

      {main.flatmap_prop.groundlevel:=bintoint(copy(bloki[5],6,7));
      main.flatmap_prop.waterlevel:=bintoint(copy(bloki[5],13,7));
      main.flatmap_prop.groundmaterial:=bintoint(copy(bloki[5],20,8));
      main.flatmap_prop.dirtmaterial:=bintoint(copy(bloki[5],28,8));
      if bloki[5][36]='1' then main.flatmap_prop.dirt_on_top:=true
      else main.flatmap_prop.dirt_on_top:=false;
      if bloki[5][37]='1' then main.flatmap_prop.grass_on_top:=true
      else main.flatmap_prop.grass_on_top:=false;  }
    end;
  1:begin   //original
    end;
  3:begin   //desert
      if bloki[5][6]='1' then main.biomes_desert_prop.gen_oasises:=true else main.biomes_desert_prop.gen_oasises:=false;
      main.biomes_desert_prop.oasis_count:=bintoint(copy(bloki[5],7,7));
      main.biomes_desert_prop.under_block:=bintoint(copy(bloki[5],14,8));
      if bloki[5][22]='1' then main.biomes_desert_prop.gen_shrubs:=true else main.biomes_desert_prop.gen_shrubs:=false;
      if bloki[5][23]='1' then main.biomes_desert_prop.gen_cactus:=true else main.biomes_desert_prop.gen_cactus:=false;
      if bloki[5][24]='1' then main.biomes_desert_prop.gen_pyr:=true else main.biomes_desert_prop.gen_pyr:=false;
      if bloki[5][25]='1' then main.biomes_desert_prop.gen_volcano:=true else main.biomes_desert_prop.gen_volcano:=false;
      if bloki[5][26]='1' then main.biomes_desert_prop.gen_preview:=true else main.biomes_desert_prop.gen_preview:=false;
      if bloki[5][27]='1' then main.biomes_desert_prop.gen_prev_oasis:=true else main.biomes_desert_prop.gen_prev_oasis:=false;
      if bloki[5][28]='1' then main.biomes_desert_prop.gen_prev_vil:=true else main.biomes_desert_prop.gen_prev_vil:=false;
      if bloki[5][29]='1' then main.biomes_desert_prop.gen_only_prev:=true else main.biomes_desert_prop.gen_only_prev:=false;
      if bloki[5][30]='1' then main.biomes_desert_prop.gen_vil:=true else main.biomes_desert_prop.gen_vil:=false;
      //village types
      if bloki[5][31]='1' then main.biomes_desert_prop.vil_types.ruied:=true else main.biomes_desert_prop.vil_types.ruied:=false;
      if bloki[5][32]='1' then main.biomes_desert_prop.vil_types.normal:=true else main.biomes_desert_prop.vil_types.normal:=false;
      if bloki[5][33]='1' then main.biomes_desert_prop.vil_types.normal_veg:=true else main.biomes_desert_prop.vil_types.normal_veg:=false;
      if bloki[5][34]='1' then main.biomes_desert_prop.vil_types.fortif:=true else main.biomes_desert_prop.vil_types.fortif:=false;
      if bloki[5][35]='1' then main.biomes_desert_prop.vil_types.hidden:=true else main.biomes_desert_prop.vil_types.hidden:=false;

      str:=copy(bloki[5],36,length(bloki[5])-35);

      i:=length(str) mod 8;
      delete(str,length(str)-i,i);
      j:=length(str) div 8;
      str1:='';

      for i:=0 to j-1 do
        str1:=str1+chr(bintoint(copy(str,(i*8)+1,8)));

      str:=zdecompressstr(str1);

      if pos(#0,str)=0 then
      begin
        application.MessageBox('Error converting village names','Error');
        exit;
      end;

      setlength(main.biomes_desert_prop.vil_names,0);

      i:=pos(#0,str);
      while i<>0 do
      begin
        str1:=copy(str,1,i-1);
        delete(str,1,i);
        j:=length(main.biomes_desert_prop.vil_names);
        setlength(main.biomes_desert_prop.vil_names,j+1);
        main.biomes_desert_prop.vil_names[j]:=str1;
        i:=pos(#0,str);
      end;

    end;
  5:begin  //planetoids
      main.planet_prop.map_type:=bintoint(copy(bloki[5],6,3));
      main.planet_prop.distance:=bintoint(copy(bloki[5],9,6));
      main.planet_prop.min:=bintoint(copy(bloki[5],15,6));
      main.planet_prop.max:=bintoint(copy(bloki[5],21,6));
      main.planet_prop.density:=bintoint(copy(bloki[5],27,7));
      main.planet_prop.groundlevel:=bintoint(copy(bloki[5],34,7));
      main.planet_prop.planets_type:=bintoint(copy(bloki[5],41,4));
    end;
  6:begin  //biospheres
      if bloki[5][6]='1' then main.biosfer_prop.original_gen:=true
      else main.biosfer_prop.original_gen:=false;
      if bloki[5][7]='1' then main.biosfer_prop.underwater:=true
      else main.biosfer_prop.underwater:=false;
      if bloki[5][8]='1' then main.biosfer_prop.gen_skyholes:=true
      else main.biosfer_prop.gen_skyholes:=false;
      if bloki[5][9]='1' then main.biosfer_prop.gen_noise:=true
      else main.biosfer_prop.gen_noise:=false;
      if bloki[5][10]='1' then
      begin
        main.biosfer_prop.gen_bridges:=true;
        gen_br:=true;
      end
      else
      begin
        main.biosfer_prop.gen_bridges:=false;
        gen_br:=false;
      end;
      main.biosfer_prop.bridge_material:=bintoint(copy(bloki[5],11,8));
      main.biosfer_prop.bridge_rail_material:=bintoint(copy(bloki[5],19,8));
      main.biosfer_prop.bridge_width:=bintoint(copy(bloki[5],27,4));
      main.biosfer_prop.sphere_material:=bintoint(copy(bloki[5],31,8));
      main.biosfer_prop.sphere_distance:=bintoint(copy(bloki[5],39,9));
      sf_dist:=main.biosfer_prop.sphere_distance;
      if bloki[5][48]='1' then
      begin
        main.biosfer_prop.sphere_ellipse:=true;
        gen_el:=true;
      end
      else
      begin
        main.biosfer_prop.sphere_ellipse:=false;
        gen_el:=false;
      end;
      //biomi
      if bloki[5][49]='1' then main.biosfer_prop.biomes.forest:=true
      else main.biosfer_prop.biomes.forest:=false;
      if bloki[5][50]='1' then main.biosfer_prop.biomes.rainforest:=true
      else main.biosfer_prop.biomes.rainforest:=false;
      if bloki[5][51]='1' then main.biosfer_prop.biomes.desert:=true
      else main.biosfer_prop.biomes.desert:=false;
      if bloki[5][52]='1' then main.biosfer_prop.biomes.plains:=true
      else main.biosfer_prop.biomes.plains:=false;
      if bloki[5][53]='1' then main.biosfer_prop.biomes.taiga:=true
      else main.biosfer_prop.biomes.taiga:=false;
      if bloki[5][54]='1' then main.biosfer_prop.biomes.ice_desert:=true
      else main.biosfer_prop.biomes.ice_desert:=false;
      if bloki[5][55]='1' then main.biosfer_prop.biomes.tundra:=true
      else main.biosfer_prop.biomes.tundra:=false;
      if bloki[5][56]='1' then main.biosfer_prop.biomes.sky:=true
      else main.biosfer_prop.biomes.sky:=false;
      if bloki[5][57]='1' then main.biosfer_prop.biomes.hell:=true
      else main.biosfer_prop.biomes.hell:=false;
    end;
  7:begin  //golden tunnels
      main.tunnel_prop.tun_density:=bintoint(copy(bloki[5],6,7));
      if bloki[5][13]='1' then main.tunnel_prop.round_tun:=true
      else main.tunnel_prop.round_tun:=false;
      main.tunnel_prop.r_hor_min:=bintoint(copy(bloki[5],14,5));
      main.tunnel_prop.r_hor_max:=bintoint(copy(bloki[5],19,5));
      main.tunnel_prop.r_vert_min:=bintoint(copy(bloki[5],24,5));
      main.tunnel_prop.r_vert_max:=bintoint(copy(bloki[5],29,5));
      main.tunnel_prop.round_tun_density:=bintoint(copy(bloki[5],34,7));
      if bloki[5][41]='1' then main.tunnel_prop.gen_tall_grass:=true
      else main.tunnel_prop.gen_tall_grass:=false;
      if bloki[5][42]='1' then main.tunnel_prop.gen_hub:=true
      else main.tunnel_prop.gen_hub:=false;
      if bloki[5][43]='1' then main.tunnel_prop.gen_seperate:=true
      else main.tunnel_prop.gen_seperate:=false;
      if bloki[5][44]='1' then main.tunnel_prop.gen_flooded:=true
      else main.tunnel_prop.gen_flooded:=false;
      if bloki[5][45]='1' then main.tunnel_prop.gen_lights:=true
      else main.tunnel_prop.gen_lights:=false;
      main.tunnel_prop.light_density:=bintoint(copy(bloki[5],46,7));
      main.tunnel_prop.light_blocks_type:=bintoint(copy(bloki[5],59,3));
      if bloki[5][62]='1' then main.tunnel_prop.gen_sun_holes:=true
      else main.tunnel_prop.gen_sun_holes:=false;
      main.tunnel_prop.skyholes_density:=bintoint(copy(bloki[5],63,7));
      //light bloki
      for j:=1 to 6 do
        if bloki[5][52+j]='1' then tun_light[j]:=true
        else tun_light[j]:=false;
      setlength(main.tunnel_prop.light_blocks,0);
      for j:=1 to 6 do
        if tun_light[j]=true then
        begin
          k:=length(main.tunnel_prop.light_blocks);
          setlength(main.tunnel_prop.light_blocks,k+1);
          case j of
          1:main.tunnel_prop.light_blocks[k]:=89;
          2:main.tunnel_prop.light_blocks[k]:=11;
          3:main.tunnel_prop.light_blocks[k]:=91;
          4:main.tunnel_prop.light_blocks[k]:=87;
          5:main.tunnel_prop.light_blocks[k]:=50;
          6:main.tunnel_prop.light_blocks[k]:=74;
          end;   
        end;
    end;
  end;

  //nastroyki granici karti
  i:=bintoint(copy(bloki[6],1,4));
  case i of
  0:begin   //normal
      main.border_prop.border_type:=0;
    end;
  1:begin   //wall
      main.border_prop.border_type:=1;
      main.border_prop.wall_material:=bintoint(copy(bloki[6],5,8));
      if bloki[6][13]='1' then main.border_prop.wall_void:=true
      else main.border_prop.wall_void:=false;
      main.border_prop.wall_void_thickness:=bintoint(copy(bloki[6],14,6));
      main.border_prop.wall_thickness:=bintoint(copy(bloki[6],20,5));
    end;
  2:begin   //void
      main.border_prop.border_type:=2;
      main.border_prop.void_thickness:=bintoint(copy(bloki[6],5,7));
    end;
  3:begin  //castle wall
      main.border_prop.border_type:=3;
      if bloki[6][5]='1' then main.border_prop.cwall_gen_towers:=true
      else main.border_prop.cwall_gen_towers:=false;
      main.border_prop.cwall_towers_type:=bintoint(copy(bloki[6],6,4));
      if bloki[6][10]='1' then main.border_prop.cwall_gen_rails:=true
      else main.border_prop.cwall_gen_rails:=false;
      if bloki[6][11]='1' then main.border_prop.cwall_gen_interior:=true
      else main.border_prop.cwall_gen_interior:=false;
      if bloki[6][12]='1' then main.border_prop.cwall_gen_boinici:=true
      else main.border_prop.cwall_gen_boinici:=false;
      main.border_prop.cwall_boinici_type:=bintoint(copy(bloki[6],13,4));
      if bloki[6][17]='1' then main.border_prop.cwall_gen_gates:=true
      else main.border_prop.cwall_gen_gates:=false;
      main.border_prop.cwall_gates_type:=bintoint(copy(bloki[6],18,4));
      if bloki[6][22]='1' then main.border_prop.cwall_gen_void:=true
      else main.border_prop.cwall_gen_void:=false;
      main.border_prop.cwall_void_width:=bintoint(copy(bloki[6],23,7));
    end;
  end;

  //nastroyki igroka
  if bloki[8]<>'' then
  begin
    {application.MessageBox(pchar(inttostr(bintoint(copy(bloki[8],1,7)))),'');
    application.MessageBox(pchar(inttostr(bintoint(copy(bloki[8],8,20)))),'');
    application.MessageBox(pchar(inttostr(bintoint(copy(bloki[8],28,20)))),'');
    application.MessageBox(pchar(inttostr(bintoint(copy(bloki[8],48,1)))),'');
    application.MessageBox(pchar(inttostr(bintoint(copy(bloki[8],49,32)))),'');
    application.MessageBox(pchar(inttostr(bintoint(copy(bloki[8],81,8)))),'');
    application.MessageBox(pchar(inttostr(bintoint(copy(bloki[8],89,32)))),'');
    application.MessageBox(pchar(inttostr(bintoint(copy(bloki[8],121,5)))),'');
    application.MessageBox(pchar(inttostr(bintoint(copy(bloki[8],126,10)))),'');
    application.MessageBox(pchar(inttostr(bintoint(copy(bloki[8],136,8)))),'');
    application.MessageBox(pchar(inttostr(bintoint(copy(bloki[8],144,5)))),'');
    application.MessageBox(pchar(inttostr(bintoint(copy(bloki[8],149,4)))),''); }
    main.level_settings.player.xplevel:=bintoint(copy(bloki[8],1,7));
    i:=bintoint(copy(bloki[8],8,20));
    main.level_settings.player.xp:=i/1000000;
    main.level_settings.player.score:=bintoint(copy(bloki[8],28,20));
    if copy(bloki[8],48,1)='1' then main.level_settings.player.overrite_pos:=true
    else main.level_settings.player.overrite_pos:=false;
    i:=bintoint(copy(bloki[8],49,32));
    if (i shr 31)=1 then i:=($100000000-i)*-1;
    main.level_settings.player.pos[0]:=i;
    main.level_settings.player.pos[1]:=bintoint(copy(bloki[8],81,8));
    i:=bintoint(copy(bloki[8],89,32));
    if (i shr 31)=1 then i:=($100000000-i)*-1;
    main.level_settings.player.pos[2]:=i;
    main.level_settings.player.health:=bintoint(copy(bloki[8],121,5));
    i:=bintoint(copy(bloki[8],127,9));
    if copy(bloki[8],126,1)='1' then i:=-i;
    main.level_settings.player.rotation[0]:=i;
    i:=bintoint(copy(bloki[8],137,7));
    if copy(bloki[8],136,1)='1' then i:=-i;
    main.level_settings.player.rotation[1]:=i;
    main.level_settings.player.food_level:=bintoint(copy(bloki[8],144,5));
  end;

  application.MessageBox('Loading completed sucsessfuly','Notice');

  //ochishaem pola
  load.Edit1.Text:='';
  load.Edit2.Text:='';
  load.Edit3.Text:='';
  load.Label7.Caption:='n/a';
  load.Label8.Caption:='n/a';
  load.Label9.Caption:='n/a';
  load.Label12.Caption:='n/a';
  load.Label13.Caption:='n/a';
  load.Label15.Caption:='n/a';
  load.Label15.Font.Color:=clblack;
  load.Label17.Caption:='n/a';

  clear_bloki;
  modalresult:=mrOK;

  {if obshSID='' then
  begin
    application.MessageBox('Settings not loaded','Error');
    exit;
  end;

  temp:=bintoint(hextobin(copy(obshSID,17,9)));
  str:=inttostr((temp shr 12)and $F)+'.'+inttostr((temp shr 7)and $1F)+'.'+inttostr((temp shr 2)and $1F)+'.0';

  if str='0.0.0.0' then
  begin
    //if messagedlg('',mtConfirmation,mbOKCancel,0)=mrCancel then exit;
    application.MessageBox('Bad version number, can''t read the file','Error');
    exit;
  end;

  major:=strtoint(copy(str,1,pos('.',str)-1));
  delete(str,1,pos('.',str));
  minor:=strtoint(copy(str,1,pos('.',str)-1));
  delete(str,1,pos('.',str));
  release:=strtoint(copy(str,1,pos('.',str)-1));

  if ((major=0)and(minor=4)and(release<2))or
  ((major=0)and(minor<4)) then
  begin
    application.MessageBox(pchar('Bad version number.'+#13+#10+'MCTerra can generate settings file only from version 0.4.2.0,'+#13+#10+'but version in this setting file is '+inttostr(major)+'.'+inttostr(minor)+'.'+inttostr(release)+'.0'),'Error');
    exit;
  end;

  //proverka na vse versii

  //ot 0.4.2.0 do 0.4.4.0
  if (major=0)and(minor>=4)and(release>=2)and
  (minor<=4)and(release<=4) then
  begin
    //application.MessageBox('Normal version, writing','Error');
    setlength(t,5);
    for i:=0 to 4 do
      t[i]:=bintoint(hextobin(copy(obshSID,(i*8)+1,8)));

    //delaem sid
    main.edit4.Text:=inttohex(t[1],8);
    //delaem dlinnu i shirinu karti
    i:=t[2] shr 22;
    j:=(t[2] shr 12) and $3FF;
    main.Edit1.Text:=inttostr(i);
    main.Edit2.Text:=inttostr(j);
    if i=j then main.CheckBox1.Checked:=true
    else main.CheckBox1.Checked:=false;
    main.CheckBox1Click(main);
    //delaem tip karti i kartinku
    i:=(t[3] shr 26) and $F;
    main.ComboBox1.ItemIndex:=i;
    main.ComboBox1Change(main);
    //delaem dannie karti
    case i of
    0:begin  //flatmap
        j:=(t[3] shr 19) and $7F;
        main.flatmap_prop.groundlevel:=j;
        j:=(t[3] shr 12) and $7F;
        main.flatmap_prop.waterlevel:=j;

        j1:=(t[3] shr 7) and $1F;
        case j1 of
          0:j:=1;
          1:j:=4;
          2:j:=48;
          3:j:=3;
          4:j:=12;
          5:j:=24;
          6:j:=13;
          7:j:=20;
          8:j:=49;
          9:j:=87;
          10:j:=88;
          11:j:=80;
          12:j:=79;
          13:j:=9;
          14:j:=7
          else j:=1;
        end;
        main.flatmap_prop.groundmaterial:=j;

        j1:=(t[3] shr 2) and $1F;
        case j1 of
          0:j:=1;
          1:j:=4;
          2:j:=48;
          3:j:=3;
          4:j:=12;
          5:j:=24;
          6:j:=13;
          7:j:=5;
          8:j:=20;
          9:j:=82;
          10:j:=49;
          11:j:=87;
          12:j:=88;
          13:j:=80;
          14:j:=79
          else j:=3;
        end;
        main.flatmap_prop.dirtmaterial:=j;

        if ((t[3] shr 1) and 1)=1 then main.flatmap_prop.dirt_on_top:=true
        else main.flatmap_prop.dirt_on_top:=false;

        if (t[3] and 1)=1 then main.flatmap_prop.grass_on_top:=true
        else main.flatmap_prop.grass_on_top:=false;
      end;
    5:begin  //planetoids
        j:=(t[3] shr 23) and $7;
        main.planet_prop.map_type:=j;
        j:=(t[3] shr 17) and $3F;
        main.planet_prop.distance:=j;
        j:=(t[3] shr 11) and $3F;
        main.planet_prop.min:=j;
        j:=(t[3] shr 5) and $3F;
        main.planet_prop.max:=j;

        j:=((t[3] and $1F) shl 2) or (t[4] shr 30);
        main.planet_prop.density:=j;
        j:=(t[4] shr 23) and $7F;
        main.planet_prop.groundlevel:=j;
      end;
    end;

    //delaem border settings
    i:=(t[4] shr 20) and $7;
    main.border_prop.border_type:=i; 

    case i of
    1:begin  //Wall
        j1:=(t[4] shr 15)and $1F;
        case j1 of
          0:j:=1;
          1:j:=3;
          2:j:=4;
          3:j:=5;
          4:j:=7;
          5:j:=9;
          6:j:=11;
          7:j:=12;
          8:j:=24;
          9:j:=13;
          10:j:=20;
          11:j:=49;
          12:j:=79;
          13:j:=80;
        end;
        main.border_prop.wall_material:=j;

        j:=(t[4] shr 11) and $F;
        main.border_prop.wall_thickness:=j;
        if ((t[4] shr 10) and 1)=1 then main.border_prop.wall_void:=true
        else main.border_prop.wall_void:=false;
        j:=(t[4] shr 3) and $7F;
        main.border_prop.wall_void_thickness:=j;
      end;
    2:begin  //Void
        j:=(t[4] shr 13) and $7F;
        main.border_prop.void_thickness:=j;
      end;
    end;

  end
  else
  //ot 0.5.0.0 do 0.5.4.0
  //dobavleni nastroyki dla Golden Tunnels
  if (major=0)and(minor>=5)and(release>=0)and
  (minor<=5)and(release<=4) then
  begin
    setlength(t,6);
    for i:=0 to 5 do
      t[i]:=bintoint(hextobin(copy(obshSID,(i*8)+1,8)));

    //delaem sid
    main.edit4.Text:=inttohex(t[1],8);
    //delaem dlinnu i shirinu karti
    i:=t[2] shr 22;
    j:=(t[2] shr 12) and $3FF;
    main.Edit1.Text:=inttostr(i);
    main.Edit2.Text:=inttostr(j);
    if i=j then main.CheckBox1.Checked:=true
    else main.CheckBox1.Checked:=false;
    main.CheckBox1Click(main);
    //delaem tip karti i kartinku
    i:=(t[3] shr 26) and $F;
    main.ComboBox1.ItemIndex:=i;
    main.ComboBox1Change(main);
    //delaem dannie karti
    case i of
    0:begin  //flatmap
        j:=(t[3] shr 19) and $7F;
        main.flatmap_prop.groundlevel:=j;
        j:=(t[3] shr 12) and $7F;
        main.flatmap_prop.waterlevel:=j;

        j1:=(t[3] shr 7) and $1F;
        case j1 of
          0:j:=1;
          1:j:=4;
          2:j:=48;
          3:j:=3;
          4:j:=12;
          5:j:=24;
          6:j:=13;
          7:j:=20;
          8:j:=49;
          9:j:=87;
          10:j:=88;
          11:j:=80;
          12:j:=79;
          13:j:=9;
          14:j:=7
          else j:=1;
        end;
        main.flatmap_prop.groundmaterial:=j;

        j1:=(t[3] shr 2) and $1F;
        case j1 of
          0:j:=1;
          1:j:=4;
          2:j:=48;
          3:j:=3;
          4:j:=12;
          5:j:=24;
          6:j:=13;
          7:j:=5;
          8:j:=20;
          9:j:=82;
          10:j:=49;
          11:j:=87;
          12:j:=88;
          13:j:=80;
          14:j:=79
          else j:=3;
        end;
        main.flatmap_prop.dirtmaterial:=j;

        if ((t[3] shr 1) and 1)=1 then main.flatmap_prop.dirt_on_top:=true
        else main.flatmap_prop.dirt_on_top:=false;

        if (t[3] and 1)=1 then main.flatmap_prop.grass_on_top:=true
        else main.flatmap_prop.grass_on_top:=false;
      end;
    5:begin  //planetoids
        j:=(t[3] shr 23) and $7;
        main.planet_prop.map_type:=j;
        j:=(t[3] shr 17) and $3F;
        main.planet_prop.distance:=j;
        j:=(t[3] shr 11) and $3F;
        main.planet_prop.min:=j;
        j:=(t[3] shr 5) and $3F;
        main.planet_prop.max:=j;

        j:=((t[3] and $1F) shl 2) or (t[4] shr 30);
        main.planet_prop.density:=j;
        j:=(t[4] shr 23) and $7F;
        main.planet_prop.groundlevel:=j;
      end;
    7:begin  //golden tunnels
        j:=(t[3] shr 19) and $7F;
        main.tunnel_prop.tun_density:=j;
        if ((t[3] shr 18) and 1)=1 then main.tunnel_prop.round_tun:=true
        else main.tunnel_prop.round_tun:=false;
        j:=(t[3] shr 13) and $1F;
        main.tunnel_prop.r_hor_min:=j;
        j:=(t[3] shr 8) and $1F;
        main.tunnel_prop.r_hor_max:=j;
        j:=(t[3] shr 3) and $1F;
        main.tunnel_prop.r_vert_min:=j;
        j:=((t[3] and $7)shl 2) or (t[4] shr 30);
        main.tunnel_prop.r_vert_max:=j;
        j:=(t[4] shr 23) and $7F;
        main.tunnel_prop.round_tun_density:=j;
        j:=(t[4] shr 21) and $3;
        case j of
        0:begin
            main.tunnel_prop.gen_lights:=true;
            main.tunnel_prop.gen_sun_holes:=false;
          end;
        1:begin
            main.tunnel_prop.gen_lights:=false;
            main.tunnel_prop.gen_sun_holes:=true;
          end;
        2:begin
            main.tunnel_prop.gen_lights:=true;
            main.tunnel_prop.gen_sun_holes:=true;
          end;
        end;
        j:=(t[4] shr 14) and $7F;
        main.tunnel_prop.light_density:=j;
        j:=(t[4] shr 8) and $3F;
        setlength(main.tunnel_prop.light_blocks,0);
        for j1:=0 to 5 do
          if ((j shr (5-j1))and 1)=1 then
          begin
            j2:=length(main.tunnel_prop.light_blocks);
            setlength(main.tunnel_prop.light_blocks,j2+1);
            case j1 of
            0:main.tunnel_prop.light_blocks[j2]:=89;
            1:main.tunnel_prop.light_blocks[j2]:=11;
            2:main.tunnel_prop.light_blocks[j2]:=91;
            3:main.tunnel_prop.light_blocks[j2]:=87;
            4:main.tunnel_prop.light_blocks[j2]:=50;
            5:main.tunnel_prop.light_blocks[j2]:=74;
            end;
          end;
        j:=(t[4] shr 5) and $7;
        main.tunnel_prop.light_blocks_type:=j;
        j:=((t[4] and $1F)shl 2) or (t[5] shr 30);
        main.tunnel_prop.skyholes_density:=j;
        if ((t[5] shr 29) and 1)=1 then main.tunnel_prop.gen_tall_grass:=true
        else main.tunnel_prop.gen_tall_grass:=false;
        if ((t[5] shr 28) and 1)=1 then main.tunnel_prop.gen_hub:=true
        else main.tunnel_prop.gen_hub:=false;
        if ((t[5] shr 27) and 1)=1 then main.tunnel_prop.gen_seperate:=true
        else main.tunnel_prop.gen_seperate:=false;
        if ((t[5] shr 26) and 1)=1 then main.tunnel_prop.gen_flooded:=true
        else main.tunnel_prop.gen_flooded:=false;
      end;
    end;

    //delaem border settings
    i:=(t[5] shr 23) and $7;
    main.border_prop.border_type:=i;

    case i of
    1:begin  //Wall
        j1:=(t[5] shr 18)and $1F;
        case j1 of
          0:j:=1;
          1:j:=3;
          2:j:=4;
          3:j:=5;
          4:j:=7;
          5:j:=9;
          6:j:=11;
          7:j:=12;
          8:j:=24;
          9:j:=13;
          10:j:=20;
          11:j:=49;
          12:j:=79;
          13:j:=80;
        end;
        main.border_prop.wall_material:=j;

        j:=(t[5] shr 14) and $F;
        main.border_prop.wall_thickness:=j;
        if ((t[5] shr 13) and 1)=1 then main.border_prop.wall_void:=true
        else main.border_prop.wall_void:=false;
        j:=(t[5] shr 6) and $7F;
        main.border_prop.wall_void_thickness:=j;
      end;
    2:begin  //Void
        j:=(t[5] shr 16) and $7F;
        main.border_prop.void_thickness:=j;
      end;
    end;
  end
  else
  //ot 0.5.5.0 do beskonechnosti
  //if (major=0)and(minor>=4)and(release>=3)and
  //(minor<=4)and(release<=5) then
  begin
    application.MessageBox('Future version of the program.'+#13+#10+'To read this settings, download the latest version of MCTerra.','Error');
    exit;
  end;

  setlength(t,0);

  application.MessageBox('Loading completed sucsessfuly','Notice');

  //ochishaem pola
  load.Edit1.Text:='';
  load.Edit2.Text:='';
  load.Edit3.Text:='';
  load.Label7.Caption:='n/a';
  load.Label8.Caption:='n/a';
  load.Label9.Caption:='n/a';
  load.Label12.Caption:='n/a';
  load.Label13.Caption:='n/a';
  load.Label15.Caption:='n/a';
  load.Label15.Font.Color:=clblack;

  obshSID:='';
  modalresult:=mrOK;     }
end;

procedure Tload.Button2Click(Sender: TObject);
begin
  //ochishaem pola
  load.Edit1.Text:='';
  load.Edit2.Text:='';
  load.Edit3.Text:='';
  load.Label7.Caption:='n/a';
  load.Label8.Caption:='n/a';
  load.Label9.Caption:='n/a';
  load.Label12.Caption:='n/a';
  load.Label13.Caption:='n/a';
  load.Label15.Caption:='n/a';
  load.Label15.Font.Color:=clBlack;
  load.Label17.Caption:='n/a';

  obshSID:='';
  modalresult:=mrCancel;

  clear_bloki;
end;

procedure Tload.Button3Click(Sender: TObject);
var f:textfile;
str,str1,str2,data:string;
temp,i,j:integer;
t:cardinal;
minor,major,release,minor1,major1,release1:byte;
b:boolean;
ver:TFileVersionInfo;
begin
  if load.OpenDialog1.Execute then
  begin
    assignfile(f,load.OpenDialog1.FileName);
    reset(f);
    readln(f,str);

    str1:='MCTerra settings file'+#0+#1+#2+#1+#5;
    if str<>str1 then
    begin
      application.MessageBox('This is not a settings file, can''t open','Error');
      exit;
    end;

    readln(f,str);

    closefile(f);

    i:=length(str);
    if (i and 1)=1 then
    begin
      application.MessageBox('Settings file is corrupted, can''t read','Error');
      exit;
    end;

    i:=i div 2;
    //zapolnaem stroki blokov
    j:=0;
    while j<(i-1) do
    begin
      str1:=copy(str,1+(j*2),2);
      str2:=copy(str,1+(j*2)+2,2);
      data:=copy(str,1+(j*2)+4,bintoint(hextobin(str2))*2);
      temp:=bintoint(hextobin(str1));
      if (temp>=1)and(temp<=8) then
      begin
        bloki[temp]:=data;
        inc(j,(length(data)div 2)+1);
      end;

      inc(j);
    end;

    b:=false;
    for i:=1 to 6 do
      if bloki[i]='' then
      begin
        b:=true;
        break;
      end;

    if (b=true)or(temp<>1) then
    begin
      application.MessageBox('Settings file have wrong format','Error');
      clear_bloki;
      exit;
    end;

    //proveraem na crc
    str1:=str;
    delete(str1,length(str1)-11,12);
    t:=calc_crc32(str1);
    str1:=inttohex(t,8);

    if str1<>bloki[1] then
    begin
      application.MessageBox('Wrong checksum. Can''t read file.','Error');
      clear_bloki;
      exit;
    end;

    load.Edit2.Text:=str;
    load.Edit1.Text:=inttostr(bintoint(hextobin(bloki[2])));

    //perevodim v dvoichniy vid
    for i:=1 to 8 do
      if bloki[i]<>'' then
        bloki[i]:=hextobin(bloki[i]);

    //map type
    temp:=bintoint(copy(bloki[5],1,5));
    case temp of
    0:load.Label7.Caption:='Flatmap';
    1:load.Label7.Caption:='Original';
    3:load.Label7.Caption:='Desert';
    5:load.Label7.Caption:='Planetoids';
    6:load.Label7.Caption:='BioSpheres';
    7:load.Label7.Caption:='Golden Tunnels'
    else
      load.Label7.Caption:='Unknown';
    end;

    //border type
    temp:=bintoint(copy(bloki[6],1,4));
    case temp of
    0:load.Label8.Caption:='Normal transition';
    1:load.Label8.Caption:='Wall';
    2:load.Label8.Caption:='Void';
    3:load.Label8.Caption:='Castle Wall'
    else
      load.Label8.Caption:='Unknown';
    end;

    //features type
    load.Label9.Caption:='None';

    //map width
    temp:=bintoint(copy(bloki[3],1,12));
    load.Label12.Caption:=inttostr(temp);

    //map length
    temp:=bintoint(copy(bloki[3],13,12));
    load.Label13.Caption:=inttostr(temp);

    //versiya zapuskaemogo ekzeshnika
    ver:=Fileversioninfo(paramstr(0));
    str:=ver.FileVersion;
    major:=strtoint(copy(str,1,pos('.',str)-1));
    delete(str,1,pos('.',str));
    minor:=strtoint(copy(str,1,pos('.',str)-1));
    delete(str,1,pos('.',str));
    release:=strtoint(copy(str,1,pos('.',str)-1));

    //versiya v fayle nastroek
    str:=inttostr(bintoint(copy(bloki[4],1,4)))+'.'+inttostr(bintoint(copy(bloki[4],5,6)))+'.'+inttostr(bintoint(copy(bloki[4],11,6)))+'.0';
    major1:=strtoint(copy(str,1,pos('.',str)-1));
    delete(str,1,pos('.',str));
    minor1:=strtoint(copy(str,1,pos('.',str)-1));
    delete(str,1,pos('.',str));
    release1:=strtoint(copy(str,1,pos('.',str)-1));
    str:=inttostr(major1)+'.'+inttostr(minor1)+'.'+inttostr(release1)+'.0';

    if ((major1=0)and(minor1=0)and(release1=0))or
    ((major=10)and(minor=100)and(release=1000)) then
      load.Label15.Font.Color:=clred
    else if ver.FileVersion=str then
      load.Label15.Font.Color:=clgreen
    else if ((major1>=0)and(major1<=major))and
    (((minor1=4)and(release1>=2))or(minor1>4))and
    (((minor1=minor)and(release1<=release))or(minor1<minor)) then
      load.Label15.Font.Color:=clolive
    else load.Label15.Font.Color:=clred;

    load.Label15.Caption:=str;

    load.Edit3.Text:=load.OpenDialog1.FileName;

    //nastroyka igroka
    if bloki[8]<>'' then load.Label17.Caption:='Present'
    else load.Label17.Caption:='Not Present';

    {str1:=copy(str,9,length(str)-8);
    t1:=calc_crc32(str1);
    str:=copy(str,1,8);

    if str<>inttohex(t1,8) then
    begin
      application.MessageBox('Wrong checksum, failed to load.','Error');
      exit;
    end;

    //map type
    t1:=bintoint(hextobin(copy(str1,17,8)));
    temp:=(t1 shr 26) and $F;
    case temp of
    0:load.Label7.Caption:='Flatmap';
    5:load.Label7.Caption:='Planetoids';
    6:load.Label7.Caption:='BioSpheres';
    7:load.Label7.Caption:='Golden Tunnels'
    else
      load.Label7.Caption:='Unknown';
    end;

    //border type
    t1:=bintoint(hextobin(copy(str1,33,8)));
    temp:=(t1 shr 23) and $7;
    case temp of
    0:load.Label8.Caption:='Normal transition';
    1:load.Label8.Caption:='Wall';
    2:load.Label8.Caption:='Void';
    3:load.Label8.Caption:='Castle Wall'
    else
      load.Label8.Caption:='Unknown';
    end;

    //feature types
    load.Label9.Caption:='None';

    t1:=bintoint(hextobin(copy(str1,9,8)));
    //map length
    temp:=(t1 shr 12) and $3FF;
    load.Label13.Caption:=inttostr(temp);
    //map width
    temp:=(t1 shr 22) and $3FF;
    load.Label12.Caption:=inttostr(temp);

    obshSID:=str+str1;

    //versiya zapuskaemogo ekzeshnika
    ver:=Fileversioninfo(paramstr(0));
    str:=ver.FileVersion;
    major:=strtoint(copy(str,1,pos('.',str)-1));
    delete(str,1,pos('.',str));
    minor:=strtoint(copy(str,1,pos('.',str)-1));
    delete(str,1,pos('.',str));
    release:=strtoint(copy(str,1,pos('.',str)-1));

    //versiya v fayle nastroek
    temp:=bintoint(hextobin(copy(obshSID,17,9)));
    str:=inttostr((temp shr 12)and $F)+'.'+inttostr((temp shr 7)and $1F)+'.'+inttostr((temp shr 2)and $1F)+'.0';
    major1:=strtoint(copy(str,1,pos('.',str)-1));
    delete(str,1,pos('.',str));
    minor1:=strtoint(copy(str,1,pos('.',str)-1));
    delete(str,1,pos('.',str));
    release1:=strtoint(copy(str,1,pos('.',str)-1));
    str:=inttostr(major1)+'.'+inttostr(minor1)+'.'+inttostr(release1)+'.0';

    if ((major1=0)and(minor1=0)and(release1=0))or
    ((major=10)and(minor=100)and(release=1000)) then
      load.Label15.Font.Color:=clblack
    else if ver.FileVersion=str then
      load.Label15.Font.Color:=clgreen
    else if ((major1>=0)and(major1<=major))and
    (((minor1=4)and(release1>=2))or(minor1>4))and
    (((minor1=minor)and(release1<=release))or(minor1<minor)) then
      load.Label15.Font.Color:=clolive
    else load.Label15.Font.Color:=clred;

    load.Label15.Caption:=str;

    load.Edit3.Text:=load.OpenDialog1.FileName;
    load.Edit2.Text:=obshSID;
    load.Edit1.Text:=copy(str1,1,8);  }
  end;
end;

procedure Tload.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  key:=#0;
end;

procedure Tload.FormCreate(Sender: TObject);
var i:integer;
begin
  //for i:=1 to 6 do
  //  bloki[i]:='';
  clear_bloki;
end;

end.

unit borderf;

interface

uses
  Forms, Controls, Classes, StdCtrls, ExtCtrls, jpeg;

type
  Tborder = class(TForm)
    GroupBox5: TGroupBox;
    Panel1: TPanel;
    Image1: TImage;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    ComboBox1: TComboBox;
    GroupBox7: TGroupBox;
    Label12: TLabel;
    Label15: TLabel;
    Label11: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Button3: TButton;
    Image2: TImage;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  border: Tborder;

implementation

uses mainf, SysUtils, Windows;

{$R *.dfm}

var save_sel:integer;

procedure Tborder.Button1Click(Sender: TObject);
begin
  modalresult:=mrok;
end;

procedure Tborder.Button2Click(Sender: TObject);
begin
  border.ComboBox1.ItemIndex:=save_sel;
  border.ComboBox1Change(Self);

  modalresult:=mrcancel;
end;

procedure Tborder.ComboBox1Change(Sender: TObject);
var i:integer;
rect:TRect;
begin
  i:=border.ComboBox1.ItemIndex;
  border.Label18.Caption:=border_plugins[i].plug_full_name;
  border.Label17.Caption:=border_plugins[i].plug_author;
  border.Label16.Caption:=border_plugins[i].plug_version;
  border.Label25.Caption:=border_plugins[i].plug_file;

  border_sel:=i;

  if border_plugins[i].info.has_preview then
    border.Image1.Canvas.Draw(0,0,border_plugins[i].preview)
  else
  begin
    rect.Left:=0;
    rect.Top:=0;
    rect.Bottom:=200;
    rect.Right:=250;
    border.Image1.Canvas.FillRect(rect);
    border.Image1.Canvas.TextOut(80,90,'No preview available');
  end;
end;

procedure Tborder.Button3Click(Sender: TObject);
begin
  //if border.ComboBox1.Text<>'(No plugins available)' then
  if assigned(border_plugins[border.ComboBox1.ItemIndex].show_settings_wnd) then
  begin
    //formiruem nastroyki karti
    generation_settings.Landscape_gen:=landscape_plugins[land_sel].plugrec;
    generation_settings.Border_gen:=border_plugins[border_sel].plugrec;
    generation_settings.Buildings_gen:=structures_plugins[struct_sel].plugrec;
    path_str:='';
    name_str:=main.Edit1.Text;
    generation_settings.Path:=pchar(path_str);
    generation_settings.Name:=pchar(name_str);
    generation_settings.Map_type:=main.ComboBox1.ItemIndex;
    generation_settings.Width:=strtoint(main.Edit3.Text);
    generation_settings.Length:=strtoint(main.Edit4.Text);
    generation_settings.Game_type:=main.ComboBox2.ItemIndex;
    generation_settings.SID:=map_sid;
    generation_settings.Populate_chunks:=main.CheckBox1.Checked;
    generation_settings.Generate_structures:=main.CheckBox2.Checked;
    generation_settings.Game_time:=convert_time(strtoint(main.Edit8.Text),strtoint(main.Edit9.Text));
    case main.ComboBox3.ItemIndex of
    0:begin
        generation_settings.Raining:=false;
        generation_settings.Thundering:=false;
      end;
    1:begin
        generation_settings.Raining:=true;
        generation_settings.Thundering:=false;
      end;
    2:begin
        generation_settings.Raining:=true;
        generation_settings.Thundering:=true;
      end;
    end;
    //perevodim iz sekund v takti minecrafta
    generation_settings.Rain_time:=strtoint(main.Edit5.Text)*20;
    generation_settings.Thunder_time:=strtoint(main.Edit6.Text)*20;
    
    generation_settings.Files_size:=0;
    generation_settings.Spawn_pos[0]:=0;
    generation_settings.Spawn_pos[1]:=64;
    generation_settings.Spawn_pos[2]:=0;

    border_plugins[border.ComboBox1.ItemIndex].show_settings_wnd(generation_settings);
  end
  else
    application.MessageBox('No settings window available','Error');
end;

procedure Tborder.FormCreate(Sender: TObject);
begin
  if save_opt.save_enabled=true then
    if (save_opt.border_f.top<>-1)and(save_opt.border_f.left<>-1) then
    begin
      border.Top:=save_opt.border_f.top;
      border.Left:=save_opt.border_f.left;
    end;

  save_sel:=0;
end;

procedure Tborder.FormShow(Sender: TObject);
begin
  save_sel:=border_sel;
end;

end.

unit settingsf;

interface

uses
  Forms, Classes, Controls, StdCtrls, StrUtils;

type
  Tsettings = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    ComboBox1: TComboBox;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  settings: Tsettings;

  
procedure init_form(hndl:LongWord);

implementation

uses generation, SysUtils;

{$R *.dfm}

//Form creation. This function runs on plugin initialization.
procedure init_form(hndl:LongWord);
begin
  Application.Handle:=hndl;  
  settings:=TSettings.Create(Application);
end;

//Cancel button press.
procedure Tsettings.Button2Click(Sender: TObject);
begin
  modalresult:=mrCancel;
end;

//OK button press.
procedure Tsettings.Button1Click(Sender: TObject);
var str:string;
i:integer;
begin
  str:=settings.ComboBox1.Text;
  i:=pos('(',str);
  str:=copy(str,i+1,posex(')',str,i+1)-i-1);
  fill_id:=strtoint(str);
  level_height:=strtoint(settings.Edit1.text);

  modalresult:=mrOK;
end;

//FormShow function. This function runs when this form is shown.
procedure Tsettings.FormShow(Sender: TObject);
var i:integer;
str:string;
begin
  settings.Edit1.Text:=inttostr(level_height);
  str:='';
  for i:=0 to length(blocks_ids)-1 do
    if blocks_ids[i].id=fill_id then
    begin
      str:=blocks_ids[i].name+' ('+inttostr(blocks_ids[i].id)+')';
      break;
    end;

  if str='' then i:=0
  else i:=settings.ComboBox1.Items.IndexOf(str);
  settings.ComboBox1.ItemIndex:=i;
end;

end.

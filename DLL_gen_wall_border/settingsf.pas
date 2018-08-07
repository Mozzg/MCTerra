unit settingsf;

interface

uses
  Forms, Classes, Controls, ExtCtrls, StdCtrls;

type
  Tsettings = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label3: TLabel;
    ComboBox1: TComboBox;
    Label4: TLabel;
    Edit3: TEdit;
    RadioGroup1: TRadioGroup;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    Edit1: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit3Exit(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  settings: Tsettings;

procedure init_form(hndl:LongWord);

implementation

uses generation, sysutils, windows;

{$R *.dfm}

var void_save:boolean;

procedure init_form(hndl:LongWord);
begin
  Application.Handle:=hndl;  
  settings:=TSettings.Create(Application);

  //inicializaciya peremennih
  border_in_out:=true;
  border_blocks:=1;
  border_void:=false;
  border_void_chunks:=1;
  border_material:=7;

  border_in:=1;
  border_out:=0;
end;

procedure Tsettings.Button1Click(Sender: TObject);
begin
  border_material:=settings.ComboBox1.ItemIndex;
  border_blocks:=strtoint(settings.Edit3.Text);
  if settings.RadioGroup1.ItemIndex=0 then border_in_out:=true
  else border_in_out:=false;
  border_void:=settings.CheckBox1.Checked;
  border_void_chunks:=strtoint(settings.Edit1.Text);

  modalresult:=mrOK;
end;

procedure Tsettings.Button2Click(Sender: TObject);
begin
  modalresult:=mrCancel;
end;

procedure Tsettings.FormShow(Sender: TObject);
begin
  void_save:=border_void;

  settings.ComboBox1.ItemIndex:=border_material;
  settings.Edit3.Text:=inttostr(border_blocks);
  if border_in_out=true then settings.RadioGroup1.ItemIndex:=0
  else settings.RadioGroup1.ItemIndex:=1;
  settings.CheckBox1.Checked:=border_void;
  settings.Edit1.Text:=inttostr(border_void_chunks);
  settings.CheckBox1Click(self);
  settings.RadioGroup1Click(self);
end;

procedure Tsettings.CheckBox1Click(Sender: TObject);
begin
  if settings.CheckBox1.Checked=false then
  begin
    settings.Label1.Enabled:=false;
    settings.Edit1.Enabled:=false;
  end
  else
  begin
    settings.Label1.Enabled:=true;
    settings.Edit1.Enabled:=true;
  end;
end;

procedure Tsettings.RadioGroup1Click(Sender: TObject);
begin
  if settings.RadioGroup1.ItemIndex=0 then
  begin
    settings.CheckBox1.Enabled:=true;
    settings.CheckBox1.Checked:=void_save;    
  end
  else
  begin
    void_save:=settings.CheckBox1.Checked;
    settings.CheckBox1.Checked:=true;
    settings.CheckBox1.Enabled:=false;     
  end;
end;

procedure Tsettings.Edit3KeyPress(Sender: TObject; var Key: Char);
begin  
  if not(((key>=#48) and (key<=#57))or (key=#8)) then key:=#0;
end;

procedure Tsettings.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if not(((key>=#48) and (key<=#57))or (key=#8)) then key:=#0;
end;

procedure Tsettings.Edit3Exit(Sender: TObject);
var i:integer;
begin
  if settings.Edit3.Text='' then settings.Edit3.Text:='1';

  i:=strtoint(settings.Edit3.Text);
  if (i<1)or(i>64) then
  begin
    MessageBox(app_hndl,'Wall thickness must be between 1 and 64 blocks','Error',mb_OK);
    settings.Edit3.SelStart:=0;
    settings.Edit3.SelLength:=length(settings.Edit3.Text);
    settings.Edit3.SetFocus;
  end;
end;

procedure Tsettings.Edit3Change(Sender: TObject);
var str:string;
begin
  str:=settings.Edit3.Text;
  if length(str)>4 then
  begin
    setlength(str,4);
    settings.Edit3.Text:=str;
    settings.Edit3.SelStart:=4;
  end;
end;

procedure Tsettings.Edit1Exit(Sender: TObject);
var i:integer;
begin
  if settings.Edit1.Text='' then settings.Edit1.Text:='1';

  i:=strtoint(settings.Edit1.Text);
  if (i<1)or(i>128) then
  begin
    MessageBox(app_hndl,'Void width must be between 1 and 128 chunks','Error',mb_OK);
    settings.Edit1.SelStart:=0;
    settings.Edit1.SelLength:=length(settings.Edit1.Text);
    settings.Edit1.SetFocus;
  end;
end;

procedure Tsettings.Edit1Change(Sender: TObject);
var str:string;
begin
  str:=settings.Edit1.Text;
  if length(str)>4 then
  begin
    setlength(str,4);
    settings.Edit1.Text:=str;
    settings.Edit1.SelStart:=4;
  end;
end;

end.

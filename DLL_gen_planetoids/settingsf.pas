unit settingsf;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  Tsettings = class(TForm)
    Label1: TLabel;
    ComboBox1: TComboBox;
    Button1: TButton;
    Button2: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    ComboBox2: TComboBox;
    Label4: TLabel;
    Edit2: TEdit;
    Label5: TLabel;
    Edit3: TEdit;
    Label6: TLabel;
    Edit4: TEdit;
    Label7: TLabel;
    Edit5: TEdit;
    Label8: TLabel;
    Edit6: TEdit;
    Label9: TLabel;
    Edit7: TEdit;
    CheckBox1: TCheckBox;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure Edit5KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox1Change(Sender: TObject);
    procedure Edit6KeyPress(Sender: TObject; var Key: Char);
    procedure Edit7KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit4Exit(Sender: TObject);
    procedure Edit6Exit(Sender: TObject);
    procedure Edit7Exit(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure Edit3Exit(Sender: TObject);
    procedure Edit5Exit(Sender: TObject);
    procedure ComboBox2Exit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  settings: Tsettings;


procedure init_form(hndl:LongWord);

implementation

uses generation;

{$R *.dfm}

var temp_ground_level:integer;
temp_min_spawn:integer;
temp_max_spawn:integer;
temp_min_size:integer;
temp_max_size:integer;
temp_density:integer;
temp_distance:integer;

procedure init_form(hndl:LongWord);
begin
  Application.Handle:=hndl;  
  settings:=TSettings.Create(Application);

  //inicializaciya nachalnih znacheniy
  map_type:=0;
  ground_level:=0;
  planet_type:=0;
  planet_density:=70;
  size_min:=10;
  size_max:=20;
  distance:=4;
  spawn_min:=16;
  spawn_max:=240;
  gen_wall:=true;
end;

procedure Tsettings.Button2Click(Sender: TObject);
begin
  modalresult:=mrCancel;
end;

procedure Tsettings.Button1Click(Sender: TObject);
begin
  //proverka
  if (temp_max_spawn-temp_min_size-5)<(temp_ground_level) then
  begin
    messagebox(settings.Handle,'Ground level must be greater than maximum planet spawn height + minimum planet size + 5 blocks'+#13+#10+'Please change ground level, maximum planet spawn height or minimum planet size','Error',mb_ok);
    exit;
  end;

  if temp_min_spawn>temp_max_spawn then
  begin
    messagebox(settings.Handle,'Minimum planet spawn height must be less than maximum planet spawn height'+#13+#10+'Please change minimum or maximum planet spawn height','Error',mb_ok);
    exit;
  end;
  if (temp_min_spawn-temp_min_size-5)<temp_ground_level then
  begin
    messagebox(settings.Handle,'Minimum planet spawn height must be greater than ground level + minimum planet size + 5 blocks'+#13+#10+'Please change minimum planet spawn height, ground level or minimum planet size','Error',mb_ok);
    exit;
  end;
  if (temp_min_spawn+temp_min_size+6)>256 then
  begin
    messagebox(settings.Handle,'Minimum planet spawn height must be less than 250 - minimum planet size'+#13+#10+'Please change maximum planet spawn height or minimum planet size','Error',mb_ok);
    exit;
  end;

  if (temp_max_spawn+temp_min_size+6)>256 then
  begin
    messagebox(settings.Handle,'Maximum planet spawn height must be less than 250 - minimum planet size'+#13+#10+'Please change maximum planet spawn height or minimum planet size','Error',mb_ok);
    exit;
  end;

  if temp_min_size>temp_max_size then
  begin
    messagebox(settings.Handle,'Minimum planet size must be less than maximum planet size'+#13+#10+'Please change maximum or minimum planet size','Error',mb_ok);
    exit;
  end;

  ground_level:=temp_ground_level;
  spawn_min:=temp_min_spawn;
  spawn_max:=temp_max_spawn;
  size_min:=temp_min_size;
  size_max:=temp_max_size;
  planet_density:=temp_density;
  distance:=temp_distance;
  map_type:=settings.ComboBox1.ItemIndex;
  planet_type:=settings.ComboBox2.ItemIndex;
  gen_wall:=settings.CheckBox1.Checked;

  modalresult:=mrOK;
end;

procedure Tsettings.FormShow(Sender: TObject);
begin
  settings.ComboBox1.ItemIndex:=map_type;
  settings.Edit1.Text:=inttostr(ground_level);
  settings.ComboBox2.ItemIndex:=planet_type;
  settings.Edit4.Text:=inttostr(planet_density);
  settings.Edit2.Text:=inttostr(size_min);
  settings.Edit3.Text:=inttostr(size_max);
  settings.Edit5.Text:=inttostr(distance);
  settings.Edit6.Text:=inttostr(spawn_min);
  settings.Edit7.Text:=inttostr(spawn_max);
  settings.CheckBox1.Checked:=gen_wall;

  temp_ground_level:=ground_level;
  temp_min_spawn:=spawn_min;
  temp_max_spawn:=spawn_max;
  temp_min_size:=size_min;
  temp_max_size:=size_max;
  temp_density:=planet_density;
  temp_distance:=distance;

  settings.ComboBox1Change(settings);
end;

procedure Tsettings.Edit1KeyPress(Sender: TObject; var Key: Char);
var str:string;
begin
  if (key=#24)or(key=#3)or(key=#22) then exit;

  if not(((key>=#48)and(key<=#57))or(key=#8)or(key=#46)) then
  begin
    key:=#0;
    exit;
  end;

  str:=settings.Edit1.Text;
  if (length(str)>=3)and(key<>#8)and(key<>#46)and(settings.Edit1.SelLength<1) then key:=#0;
end;

procedure Tsettings.Edit4KeyPress(Sender: TObject; var Key: Char);
var str:string;
begin
  if (key=#24)or(key=#3)or(key=#22) then exit;

  if not(((key>=#48)and(key<=#57))or(key=#8)or(key=#46)) then
  begin
    key:=#0;
    exit;
  end;

  str:=settings.Edit4.Text;
  if (length(str)>=3)and(key<>#8)and(key<>#46)and(settings.Edit4.SelLength<1) then key:=#0;
end;

procedure Tsettings.Edit2KeyPress(Sender: TObject; var Key: Char);
var str:string;
begin
  if (key=#24)or(key=#3)or(key=#22) then exit;

  if not(((key>=#48)and(key<=#57))or(key=#8)or(key=#46)) then
  begin
    key:=#0;
    exit;
  end;

  str:=settings.Edit2.Text;
  if (length(str)>=3)and(key<>#8)and(key<>#46)and(settings.Edit2.SelLength<1) then key:=#0;
end;

procedure Tsettings.Edit3KeyPress(Sender: TObject; var Key: Char);
var str:string;
begin
  if (key=#24)or(key=#3)or(key=#22) then exit;

  if not(((key>=#48)and(key<=#57))or(key=#8)or(key=#46)) then
  begin
    key:=#0;
    exit;
  end;

  str:=settings.Edit3.Text;
  if (length(str)>=3)and(key<>#8)and(key<>#46)and(settings.Edit3.SelLength<1) then key:=#0;
end;

procedure Tsettings.Edit5KeyPress(Sender: TObject; var Key: Char);
var str:string;
begin
  if (key=#24)or(key=#3)or(key=#22) then exit;

  if not(((key>=#48)and(key<=#57))or(key=#8)or(key=#46)) then
  begin
    key:=#0;
    exit;
  end;

  str:=settings.Edit5.Text;
  if (length(str)>=3)and(key<>#8)and(key<>#46)and(settings.Edit5.SelLength<1) then key:=#0;
end;

procedure Tsettings.ComboBox1Change(Sender: TObject);
begin
  if settings.ComboBox1.ItemIndex=0 then
  begin
    settings.Edit1.Text:='0';
    settings.Edit1.Enabled:=false;
    temp_ground_level:=1;
  end
  else
  begin
    settings.Edit1.Enabled:=true;
    settings.Edit1.Text:=inttostr(temp_ground_level);
  end;
end;

procedure Tsettings.Edit6KeyPress(Sender: TObject; var Key: Char);
var str:string;
begin
  if (key=#24)or(key=#3)or(key=#22) then exit;

  if not(((key>=#48)and(key<=#57))or(key=#8)or(key=#46)) then
  begin
    key:=#0;
    exit;
  end;

  str:=settings.Edit6.Text;
  if (length(str)>=3)and(key<>#8)and(key<>#46)and(settings.Edit6.SelLength<1) then key:=#0;
end;

procedure Tsettings.Edit7KeyPress(Sender: TObject; var Key: Char);
var str:string;
begin
  if (key=#24)or(key=#3)or(key=#22) then exit;

  if not(((key>=#48)and(key<=#57))or(key=#8)or(key=#46)) then
  begin
    key:=#0;
    exit;
  end;

  str:=settings.Edit7.Text;
  if (length(str)>=3)and(key<>#8)and(key<>#46)and(settings.Edit7.SelLength<1) then key:=#0;
end;

procedure Tsettings.Edit1Exit(Sender: TObject);
var i:integer;
b:boolean;
begin
  if settings.Edit1.Text='' then settings.Edit1.Text:='1';
  i:=strtoint(settings.Edit1.Text);
  b:=false;
  if (i<1)or(i>192) then
  begin
    messagebox(settings.Handle,'Ground level must be between 1 and 192','Error',mb_ok);
    b:=true;
  end;
  {if (temp_max_spawn-temp_min_size)<(i+5) then
  begin
    messagebox(settings.Handle,'Ground level is too high to spawn any planets','Error',mb_ok);
    b:=true;
  end;   }

  if b=true then
  begin
    settings.Edit1.SelStart:=0;
    settings.Edit1.SelLength:=length(settings.Edit1.Text);
    settings.Edit1.SetFocus;
    exit;
  end;

  temp_ground_level:=i;

  //izmenaem minimalniy spaun
  //if (temp_ground_level+temp_min_size+5)>strtoint(settings.Edit6.Text) then
  //  settings.Edit6.Text:=inttostr(temp_ground_level+temp_min_size+5);   
end;

procedure Tsettings.Edit4Exit(Sender: TObject);
var i:integer;
begin
  if settings.Edit4.Text='' then settings.Edit4.Text:='50';
  i:=strtoint(settings.Edit4.Text);
  if (i<5)or(i>95) then
  begin
    messagebox(settings.Handle,'Planet density must be between 5% and 95%','Error',mb_ok);
    settings.Edit4.SelStart:=0;
    settings.Edit4.SelLength:=length(settings.Edit4.Text);
    settings.Edit4.SetFocus;
    exit;
  end;

  temp_density:=i;
end;

procedure Tsettings.Edit6Exit(Sender: TObject);
var i:integer;
b:boolean;
begin
  if settings.Edit6.Text='' then settings.Edit6.Text:='10';
  i:=strtoint(settings.Edit6.Text);
  b:=false;
  if (i<10)or(i>245) then
  begin
    messagebox(settings.Handle,'Minimum planet spawn height must be between 10 and 245','Error',mb_ok);
    b:=true;
  end;
  {if i>temp_max_spawn then
  begin
    messagebox(settings.Handle,'Minimum planet spawn height must be less than maximum planet spawn height','Error',mb_ok);
    b:=true
  end;
  if (i-temp_min_size-5)<temp_ground_level then
  begin
    messagebox(settings.Handle,'Minimum planet spawn height must be greater than ground level + minimum planet size + 5 blocks','Error',mb_ok);
    b:=true;
  end;  }

  if b=true then
  begin
    settings.Edit6.SelStart:=0;
    settings.Edit6.SelLength:=length(settings.Edit6.Text);
    settings.Edit6.SetFocus;
    exit;
  end;

  temp_min_spawn:=i;
end;

procedure Tsettings.Edit7Exit(Sender: TObject);
var i:integer;
b:boolean;
begin
  if settings.Edit7.Text='' then settings.Edit7.Text:='245';
  i:=strtoint(settings.Edit7.Text);
  b:=false;
  if (i<10)or(i>245) then
  begin
    messagebox(settings.Handle,'Maximum planet spawn height must be between 5 and 245','Error',mb_ok);
    b:=true;
  end;
  {if i<temp_min_spawn then
  begin
    messagebox(settings.Handle,'Maximum planet spawn height must be greater than minimum planet spawn height','Error',mb_ok);
    b:=true
  end;
  if (i+temp_min_size+6)>256 then
  begin
    messagebox(settings.Handle,'Maximum planet spawn height is too high'+#13+#10+'Maximum planet spawn height must be less than 250 - minimum planet size','Error',mb_ok);
    b:=true
  end;}

  if b=true then
  begin
    settings.Edit7.SelStart:=0;
    settings.Edit7.SelLength:=length(settings.Edit7.Text);
    settings.Edit7.SetFocus;
    exit;
  end;

  temp_max_spawn:=i;
end;

procedure Tsettings.Edit2Exit(Sender: TObject);
var i:integer;
b:boolean;
begin
  if settings.Edit2.Text='' then settings.Edit2.Text:='10';
  i:=strtoint(settings.Edit2.Text);
  b:=false;
  if (i<5)or(i>80) then
  begin
    messagebox(settings.Handle,'Minimum planet size must be between 5 and 80','Error',mb_ok);
    b:=true;
  end;
  {if i>temp_max_size then
  begin
    messagebox(settings.Handle,'Minimum planet size must be less than maximum planet size','Error',mb_ok);
    b:=true;
  end;
  if ((temp_max_spawn-i-5)<temp_ground_level)or((temp_min_spawn+i+6)>256) then
  begin
    messagebox(settings.Handle,'Minimum planet size is too high to spawn any planets using current paremeters','Error',mb_ok);
    b:=true;
  end;  }

  if b=true then
  begin
    settings.Edit2.SelStart:=0;
    settings.Edit2.SelLength:=length(settings.Edit2.Text);
    settings.Edit2.SetFocus;
    exit;
  end;

  temp_min_size:=i;
end;

procedure Tsettings.Edit3Exit(Sender: TObject);
var i:integer;
b:boolean;
begin
  if settings.Edit3.Text='' then settings.Edit3.Text:='15';
  i:=strtoint(settings.Edit3.Text);
  b:=false;
  if (i<6)or(i>80) then
  begin
    messagebox(settings.Handle,'Maximum planet size must be between 6 and 80','Error',mb_ok);
    b:=true;
  end;
  {if i<temp_min_size then
  begin
    messagebox(settings.Handle,'Maximum planet size must be greater than minimum planet size','Error',mb_ok);
    b:=true;
  end;  }

  if b=true then
  begin
    settings.Edit3.SelStart:=0;
    settings.Edit3.SelLength:=length(settings.Edit3.Text);
    settings.Edit3.SetFocus;
    exit;
  end;

  temp_max_size:=i;
end;

procedure Tsettings.Edit5Exit(Sender: TObject);
var i:integer;
begin
  if settings.Edit5.Text='' then settings.Edit5.Text:='4';
  i:=strtoint(settings.Edit5.Text);
  if (i<4)or(i>250) then
  begin
    messagebox(settings.Handle,'Minimum planet dustance must be between 4 and 250','Error',mb_ok);
    settings.Edit5.SelStart:=0;
    settings.Edit5.SelLength:=length(settings.Edit5.Text);
    settings.Edit5.SetFocus;
    exit;
  end;

  temp_distance:=i;
end;

procedure Tsettings.ComboBox2Exit(Sender: TObject);
begin
  if settings.ComboBox2.ItemIndex<>0 then
  begin
    messagebox(settings.Handle,'This planet type is not supported yet. Changing to default.','Error',mb_ok);
    settings.ComboBox2.ItemIndex:=0;
  end;
end;

end.

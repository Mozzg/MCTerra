unit settingsf;

interface

uses
  Forms, StdCtrls, Controls, Classes, generation, Buttons, Windows, SysUtils;

type
  Tsettings = class(TForm)
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    ListBox1: TListBox;
    Button3: TButton;
    Button5: TButton;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Button9: TButton;
    Button4: TButton;
    ComboBox3: TComboBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ComboBox1: TComboBox;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure Edit3Exit(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure Edit5KeyPress(Sender: TObject; var Key: Char);
    procedure Edit5Exit(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  settings: Tsettings;

lay:layers_ar;
selected:integer;
count:integer;
schetchik:integer;

procedure init_form(hndl:LongWord);

implementation

{$R *.dfm}  

type TColor = -$7FFFFFFF-1..$7FFFFFFF;

const WM_NEXTDLGCTL = $0028;
  clGray = TColor($808080);
  clBlack = TColor($000000);   

procedure init_parameters;
begin
  setlength(sloi,4);

  sloi[0].start_alt:=0;
  sloi[0].width:=1;
  sloi[0].material:=7;
  sloi[0].material_data:=0;
  sloi[0].name:='Bedrock';
  sloi[1].start_alt:=1;
  sloi[1].width:=60;
  sloi[1].material:=1;
  sloi[1].name:='Stone layer';
  sloi[1].material_data:=0;
  sloi[2].start_alt:=61;
  sloi[2].width:=3;
  sloi[2].material:=3;
  sloi[2].material_data:=0;
  sloi[2].name:='Dirt layer';
  sloi[3].start_alt:=64;
  sloi[3].width:=1;
  sloi[3].material:=2;
  sloi[3].material_data:=0;
  sloi[3].name:='Grass layer';
end;

procedure init_form(hndl:LongWord);
begin
  Application.Handle:=hndl;  
  settings:=TSettings.Create(Application);
  init_parameters;
end;

procedure otobrazhenie;
var i:integer;
begin
  settings.ListBox1.Clear;
  for i:=0 to length(lay)-1 do
  begin
    settings.ListBox1.Items.Insert(0,lay[i].name);
  end;
  settings.ListBox1.Selected[selected]:=true;
end;

procedure Tsettings.Button2Click(Sender: TObject);
begin
  modalresult:=mrCancel;
end;

procedure Tsettings.Button1Click(Sender: TObject);
var j:integer;
begin
  setlength(sloi,length(lay));
  for j:=0 to length(lay)-1 do
    sloi[j]:=lay[j];

  {for j:=0 to length(sloi)-1 do
  begin
    postmessage(app_hndl,WM_USER+307,sloi[j].material,sloi[j].material_data);
    //mess_to_manager:=pchar('Layer #'+inttostr(j)+': Material='+inttostr(sloi[j].material)+' ;  Data_value='+inttostr(sloi[j].material_data));
    mess_to_manager_str:='Layer #'+inttostr(j)+':'+sloi[j].name;
    mess_to_manager:=pchar(mess_to_manager_str);
    postmessage(app_hndl,WM_USER+309,integer(mess_to_manager),0);
  end;

  mess_to_manager:=pchar('--------------------');
  postmessage(app_hndl,WM_USER+309,integer(mess_to_manager),0); }

  ModalResult := mrOK;
end;

procedure Tsettings.FormShow(Sender: TObject);
var i:integer;
begin
  setlength(lay,length(sloi));
  for i:=0 to length(lay)-1 do
  begin
    lay[i]:=sloi[i];
  end;

  count:=length(lay);
  selected:=count-1;

  schetchik:=1;

  otobrazhenie;
end;

procedure Tsettings.FormHide(Sender: TObject);
begin
  setlength(lay,0);
end;

procedure change_data_combo;
var i,j,k:integer;
str:string;
begin
  i:=count-selected-1;
  if lay[i].material_data=0 then
  begin
    settings.ComboBox1.ItemIndex:=0;
    exit;
  end;

  str:=settings.ComboBox3.Text;
  for k:=length(str) downto 1 do
    if str[k]='(' then
    begin
      delete(str,k-1,length(str));
      break;
    end;
  j:=getblockid(str);

  for k:=0 to length(blocks_ids[j].data)-1 do
    if lay[i].material_data=blocks_ids[j].data[k].data_id then
    begin
      settings.ComboBox1.ItemIndex:=k;
      break;
    end;
end;

procedure Tsettings.ListBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var s:string;
templeft,temptop,i:integer;
begin
  with (Control as TListBox).Canvas do
  begin
    FillRect(Rect);
    TempLeft := Rect.Left+3;
    TempTop := Rect.Top;
    s := (Control as TListBox).Items[Index];
    if index=(length(lay)-1) then font.Color:=clgray;
    TextOut(TempLeft, TempTop, s);

    if (odSelected in State) then
    begin
      selected:=index;
      //flatmap.Memo1.Lines.Add('Selected='+inttostr(index));
      i:=count-selected-1;
      settings.Edit3.Text:=lay[i].name;
      settings.Edit4.Text:=inttostr(lay[i].start_alt);
      settings.Edit5.Text:=inttostr(lay[i].width);
      s:=getblockname(lay[i].material)+' ('+inttostr(lay[i].material)+')';
      settings.ComboBox3.ItemIndex:=settings.ComboBox3.Items.IndexOf(s);
      if settings.ComboBox3.ItemIndex=-1 then settings.ComboBox3.ItemIndex:=0;

      settings.ComboBox3Change(settings);

      change_data_combo;

      if i=0 then
      begin
        settings.Edit3.Enabled:=false;
        settings.Edit5.Enabled:=false;
        settings.ComboBox3.Enabled:=false;
        settings.ComboBox3.Font.Color:=clgray;
        settings.ComboBox1.Enabled:=false;
        settings.ComboBox1.Font.Color:=clgray;
        settings.Button5.Enabled:=false;
        settings.BitBtn1.Enabled:=false;
        settings.BitBtn2.Enabled:=false;
      end
      else if i=1 then
      begin
        settings.Edit3.Enabled:=true;
        settings.Edit5.Enabled:=true;
        settings.ComboBox3.Enabled:=true;
        settings.ComboBox3.Font.Color:=clblack;
        settings.ComboBox1.Enabled:=true;
        settings.ComboBox1.Font.Color:=clblack;
        settings.Button5.Enabled:=true;
        settings.BitBtn1.Enabled:=true;
        settings.BitBtn2.Enabled:=false;
      end
      else if i=count-1 then
      begin
        settings.Edit3.Enabled:=true;
        settings.Edit5.Enabled:=true;
        settings.ComboBox3.Enabled:=true;
        settings.ComboBox3.Font.Color:=clblack;
        settings.ComboBox1.Enabled:=true;
        settings.ComboBox1.Font.Color:=clblack;
        settings.Button5.Enabled:=true;
        settings.BitBtn1.Enabled:=false;
        settings.BitBtn2.Enabled:=true;
      end
      else
      begin
        settings.Edit3.Enabled:=true;
        settings.Edit5.Enabled:=true;
        settings.ComboBox3.Enabled:=true;
        settings.ComboBox3.Font.Color:=clblack;
        settings.ComboBox1.Enabled:=true;
        settings.ComboBox1.Font.Color:=clblack;
        settings.Button5.Enabled:=true;
        settings.BitBtn1.Enabled:=true;
        settings.BitBtn2.Enabled:=true;
      end;
    end;
  end;
end;

procedure Tsettings.BitBtn1Click(Sender: TObject);
var i,j:integer;
temp:layer;
begin
  i:=count-selected-1;
  temp:=lay[i+1];
  lay[i+1]:=lay[i];
  lay[i]:=temp;

  for j:=i to length(lay)-1 do
    lay[j].start_alt:=lay[j-1].start_alt+lay[j-1].width;

  dec(selected);

  otobrazhenie;
end;

procedure Tsettings.BitBtn2Click(Sender: TObject);
var i,j:integer;
temp:layer;
begin
  i:=count-selected-1;
  temp:=lay[i-1];
  lay[i-1]:=lay[i];
  lay[i]:=temp;

  for j:=i-1 to length(lay)-1 do
    lay[j].start_alt:=lay[j-1].start_alt+lay[j-1].width;

  inc(selected);

  otobrazhenie;
end;

procedure Tsettings.Button3Click(Sender: TObject);
var s:string;
i:integer;
begin
  s:='Layer '+inttostr(schetchik);

  i:=length(lay);

  if lay[i-1].start_alt+lay[i-1].width=255 then
  begin
    application.MessageBox('You cannot add more layers, bacause the map is full','Notice');
    exit;
  end;

  setlength(lay,i+1);
  lay[i].start_alt:=lay[i-1].start_alt+lay[i-1].width;
  lay[i].width:=1;
  lay[i].material:=1;
  lay[i].material_data:=0;
  lay[i].name:=s;

  settings.ListBox1.Items.Insert(0,s);
  inc(count);
  dec(selected);
  inc(schetchik);
end;

procedure Tsettings.Button5Click(Sender: TObject);
var i,j:integer;
begin
  i:=count-selected-1;
  if i=count-1 then
  begin
    setlength(lay,count-1);
  end
  else
  begin
    move(lay[i+1],lay[i],sizeof(layer)*selected);
    setlength(lay,count-1);

    for j:=i to length(lay)-1 do
      lay[j].start_alt:=lay[j-1].start_alt+lay[j-1].width;
  end;

  dec(count);

  otobrazhenie;
end;

procedure Tsettings.Button9Click(Sender: TObject);
var s:string;
i,j:integer;
begin
  s:='Layer '+inttostr(schetchik);

  i:=length(lay);

  if lay[i-1].start_alt+lay[i-1].width=255 then
  begin
    application.MessageBox('You cannot add more layers, bacause the map os full','Notice');
    exit;
  end;

  setlength(lay,length(lay)+1);
  if selected=0 then
  begin
    i:=length(lay)-1;
    lay[i].start_alt:=lay[i-1].start_alt+lay[i-1].width;
    lay[i].width:=1;
    lay[i].material:=1;
    lay[i].material_data:=0;
    lay[i].name:=s;
  end
  else
  begin
    i:=count-selected;
    move(lay[i],lay[i+1],sizeof(layer)*(selected));
    lay[i].width:=1;
    lay[i].material:=1;
    lay[i].material_data:=0;
    lay[i].name:=s;
    for j:=i to length(lay)-1 do
      lay[j].start_alt:=lay[j-1].start_alt+lay[j-1].width;
  end;

  settings.ListBox1.Items.Insert(selected,s);
  inc(count);
  dec(selected);
  inc(schetchik);
end;

procedure Tsettings.Button4Click(Sender: TObject);
begin
  setlength(lay,4);
  lay[0].start_alt:=0;
  lay[0].width:=1;
  lay[0].material:=7;
  lay[0].name:='Bedrock';
  lay[1].start_alt:=1;
  lay[1].width:=60;
  lay[1].material:=1;
  lay[1].name:='Stone layer';
  lay[2].start_alt:=61;
  lay[2].width:=3;
  lay[2].material:=3;
  lay[2].name:='Dirt layer';
  lay[3].start_alt:=64;
  lay[3].width:=1;
  lay[3].material:=2;
  lay[3].name:='Grass layer';

  count:=length(lay);
  selected:=count-1;

  schetchik:=1;

  otobrazhenie;
end;

procedure Tsettings.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
  if (length(settings.Edit3.Text)>=26)and(key<>#13)and(key<>#8)and(key<>#46) then key:=#0;

  if Key = Chr(VK_RETURN) then
  begin
    Perform(WM_NEXTDLGCTL,0,0);
    key:= #0;
  end;
end;

procedure Tsettings.Edit3Exit(Sender: TObject);
var i:integer;
s:string;
begin
  s:=settings.Edit3.Text;
  i:=count-selected-1;
  lay[i].name:=s;
  settings.ListBox1.Items.Strings[selected]:=s;
end;   

procedure Tsettings.ComboBox3Change(Sender: TObject);
var i,j,k:integer;
str:string;
begin
  i:=count-selected-1;
  str:=settings.ComboBox3.Text;
  for k:=length(str) downto 1 do
    if str[k]='(' then
    begin
      delete(str,k-1,length(str));
      break;
    end;
  //j:=getblockid(settings.ComboBox3.Text);
  j:=getblockid(str);
  lay[i].material:=j;
  settings.ComboBox1.Items.Clear;
  j:=getblockindexbyname(str);
  if length(blocks_ids[j].data)<>0 then
  begin
    for k:=0 to length(blocks_ids[j].data)-1 do
      settings.ComboBox1.Items.Add(blocks_ids[j].data[k].data_name);
  end
  else
    settings.ComboBox1.Items.Add('Item data not available');   

  settings.ComboBox1.ItemIndex:=0;

  //settings.ComboBox1.ItemIndex:=lay[i].material_data;

end;

procedure Tsettings.Edit5KeyPress(Sender: TObject; var Key: Char);
begin
  if not(((key>=#48) and (key<=#57))or (key=#8)or(key=#46)or(key=#13)) then key:=#0;

  if (length(settings.Edit5.Text)>=5)and(key<>#13)and(key<>#8)and(key<>#46) then key:=#0;

  if Key = Chr(VK_RETURN) then
  begin
    Perform(WM_NEXTDLGCTL,0,0);
    //flatmap.ComboBox3.SetFocus;
    key:= #0;
  end;
end;

procedure Tsettings.Edit5Exit(Sender: TObject);
var i,j,k,z:integer;
s:string;
begin
  s:=settings.Edit5.Text;
  if (s='')or(s='0') then
  begin
    s:='1';
    settings.Edit5.Text:=s;
  end;
  j:=strtoint(s);
  i:=count-selected-1;

  k:=lay[i].width;

  if j>k then
  begin
    z:=j-k;
    if (lay[length(lay)-1].start_alt+lay[length(lay)-1].width+z)>255 then
    begin
      application.MessageBox('Width of the whole map is too high','Error');
      settings.Edit5.SelStart:=0;
      settings.Edit5.SelLength:=length(settings.Edit5.Text);
      settings.Edit5.SetFocus;
      exit;
    end;
  end;

  lay[i].width:=j;

  if i<length(lay)-1 then
    for j:=i+1 to length(lay)-1 do
      lay[j].start_alt:=lay[j-1].start_alt+lay[j-1].width;
end;

procedure Tsettings.ComboBox1Change(Sender: TObject);
var i,j:integer;
str:string;
begin
  i:=count-selected-1;
  //i:=lay[i].material;
  i:=getblockindexbyid(lay[i].material);
  str:=settings.ComboBox1.Text;
  for j:=0 to length(blocks_ids[i].data)-1 do
    if blocks_ids[i].data[j].data_name=str then
    begin
      lay[count-selected-1].material_data:=blocks_ids[i].data[j].data_id;
      exit;
    end;

  lay[count-selected-1].material_data:=0;
end;

end.

unit desert_propf;

interface

uses Forms, StdCtrls, Classes, Controls, ExtCtrls, sysutils, windows;

const WM_NEXTDLGCTL = $0028;

type
  Tdesert = class(TForm)
    Button1: TButton;
    Button2: TButton;
    GroupBox2: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    Edit2: TEdit;
    ComboBox1: TComboBox;
    Label4: TLabel;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    GroupBox1: TGroupBox;
    CheckBox7: TCheckBox;
    GroupBox4: TGroupBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    GroupBox5: TGroupBox;
    ListBox1: TListBox;
    Label5: TLabel;
    Edit4: TEdit;
    Button3: TButton;
    Button4: TButton;
    Label6: TLabel;
    Edit5: TEdit;
    GroupBox6: TGroupBox;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    CheckBox15: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
    procedure Edit4Exit(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure CheckBox7Click(Sender: TObject);
    procedure CheckBox6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  desert: Tdesert;

implementation

uses mainf, generation_obsh;

{$R *.dfm}

var names:array of string[15];
selected,count,schetchik:integer;

procedure otobrazhenie;
var i:integer;
begin
  desert.ListBox1.Clear;
  for i:=0 to length(names)-1 do
  begin
    desert.ListBox1.Items.Add(names[i])
  end;
  desert.ListBox1.Selected[selected]:=true;

  desert.Edit5.Text:=inttostr(count);
end;

function proverka_desert:integer;
var i:integer;
begin
  try
      i:=strtoint(desert.Edit2.Text);
      if (i=0)or(i>100) then
      begin
        result:=2;
        exit;
      end;

    if (desert.CheckBox8.Checked=false)and
    (desert.CheckBox9.Checked=false)and
    (desert.CheckBox10.Checked=false)and
    (desert.CheckBox11.Checked=false)and
    (desert.CheckBox12.Checked=false) then
    begin
      result:=3;
      exit;
    end;
  except
    on e:exception do
    begin
      result:=-1;
      exit;
    end;
  end;
  result:=0;
end;

procedure Tdesert.Button1Click(Sender: TObject);
var i:integer;
begin
  case proverka_desert of
  0:begin
      main.biomes_desert_prop.gen_cactus:=desert.CheckBox1.Checked;
      main.biomes_desert_prop.gen_shrubs:=desert.CheckBox5.Checked;
      main.biomes_desert_prop.gen_oasises:=desert.CheckBox2.Checked;
      main.biomes_desert_prop.gen_pyr:=desert.CheckBox3.Checked;
      main.biomes_desert_prop.gen_volcano:=desert.CheckBox4.Checked;
      main.biomes_desert_prop.gen_preview:=desert.CheckBox6.Checked;
      main.biomes_desert_prop.gen_prev_oasis:=desert.CheckBox13.Checked;
      main.biomes_desert_prop.gen_prev_vil:=desert.CheckBox14.Checked;
      main.biomes_desert_prop.gen_only_prev:=desert.CheckBox15.Checked;
      main.biomes_desert_prop.under_block:=getblockid(desert.ComboBox1.Text);
      main.biomes_desert_prop.gen_vil:=desert.CheckBox7.Checked;
      main.biomes_desert_prop.vil_types.ruied:=desert.CheckBox8.Checked;
      main.biomes_desert_prop.vil_types.normal:=desert.CheckBox9.Checked;
      main.biomes_desert_prop.vil_types.normal_veg:=desert.CheckBox10.Checked;
      main.biomes_desert_prop.vil_types.fortif:=desert.CheckBox11.Checked;
      main.biomes_desert_prop.vil_types.hidden:=desert.CheckBox12.Checked;

        //main.biomes_desert_prop.gen_oasis_den:=false;
        main.biomes_desert_prop.oasis_count:=strtoint(desert.Edit2.Text);

      //main.biomes_desert_prop.flat_koef:=strtofloat(desert.Edit3.Text);

      setlength(main.biomes_desert_prop.vil_names,count);
      for i:=0 to count-1 do
        main.biomes_desert_prop.vil_names[i]:=names[i];

      main.biomes_desert_prop.vil_count:=length(main.biomes_desert_prop.vil_names);

      modalresult:=mrOK;
    end;
  1:begin
      application.MessageBox('Oasis density must be between 5 and 100','Error');
    end;
  2:begin
      application.MessageBox('Oasis count must be between 1 and 100','Error');
    end;
  3:begin
      application.MessageBox('You must choose at least one type of village','Error');
    end
  else
    begin
      application.MessageBox('Unknown error','Error');
    end;
  end;
end;

procedure Tdesert.Button2Click(Sender: TObject);
begin
  modalresult:=mrcancel;
end;

procedure Tdesert.FormShow(Sender: TObject);
var str:string;
i:integer;
begin
  desert.CheckBox1.Checked:=main.biomes_desert_prop.gen_cactus;
  desert.CheckBox5.Checked:=main.biomes_desert_prop.gen_shrubs;
  desert.CheckBox2.Checked:=main.biomes_desert_prop.gen_oasises;

  desert.Edit2.Text:=inttostr(main.biomes_desert_prop.oasis_count);
  desert.CheckBox3.Checked:=main.biomes_desert_prop.gen_pyr;
  desert.CheckBox4.Checked:=main.biomes_desert_prop.gen_volcano;
  desert.CheckBox6.Checked:=main.biomes_desert_prop.gen_preview;
  desert.CheckBox13.Checked:=main.biomes_desert_prop.gen_prev_oasis;
  desert.CheckBox14.Checked:=main.biomes_desert_prop.gen_prev_vil;
  desert.CheckBox15.Checked:=main.biomes_desert_prop.gen_only_prev;
  desert.CheckBox8.Checked:=main.biomes_desert_prop.vil_types.ruied;
  desert.CheckBox9.Checked:=main.biomes_desert_prop.vil_types.normal;
  desert.CheckBox10.Checked:=main.biomes_desert_prop.vil_types.normal_veg;
  desert.CheckBox11.Checked:=main.biomes_desert_prop.vil_types.fortif;
  desert.CheckBox12.Checked:=main.biomes_desert_prop.vil_types.hidden;
  desert.CheckBox7.Checked:=main.biomes_desert_prop.gen_vil;

  str:=getblockname(main.biomes_desert_prop.under_block);
  desert.ComboBox1.ItemIndex:=desert.ComboBox1.Items.IndexOf(str);

  setlength(names,length(main.biomes_desert_prop.vil_names));
  for i:=0 to length(names)-1 do
  begin
    names[i]:=main.biomes_desert_prop.vil_names[i];
  end;
                                                  
  count:=length(names);
  selected:=0;
  schetchik:=1;

  otobrazhenie;

  desert.CheckBox7Click(self);
  desert.CheckBox2Click(self);
  desert.CheckBox6Click(self);
end;

procedure Tdesert.CheckBox2Click(Sender: TObject);
begin
  if desert.CheckBox2.Checked then
  begin
    desert.Label2.Enabled:=true;
    desert.Edit2.Enabled:=true;
  end
  else
  begin
    desert.Label2.Enabled:=false;
    desert.Edit2.Enabled:=false;
  end;
end; 

procedure Tdesert.ListBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var s:string;
templeft,temptop:integer;
begin              
  with (Control as TListBox).Canvas do
  begin
    FillRect(Rect);
    TempLeft := Rect.Left+3;
    TempTop := Rect.Top;
    s := (Control as TListBox).Items[Index];
    TextOut(TempLeft, TempTop, s);

    if (odSelected in State) then
    begin
      selected:=index;
      desert.Edit4.Text:=names[selected];
    end;
  end;    
end;

procedure Tdesert.Edit4KeyPress(Sender: TObject; var Key: Char);
begin
  if (length(desert.Edit4.Text)>=15)and(key<>#13)and(key<>#8)and(key<>#46) then key:=#0;

  if Key = Chr(VK_RETURN) then
  begin
    Perform(WM_NEXTDLGCTL,0,0);
    key:= #0;
  end;
end;

procedure Tdesert.Edit4Exit(Sender: TObject);
var s:string;
begin
  s:=desert.Edit4.Text;
  if length(s)=0 then
  begin
    desert.Edit4.SelStart:=0;
    desert.Edit4.SelLength:=length(desert.Edit4.Text);
    desert.Edit4.SetFocus;
    application.MessageBox('Name of the village can''t be empty','Error');
    exit;
  end;

  names[selected]:=s;
  desert.ListBox1.Items.Strings[selected]:=s;
end;

procedure Tdesert.Button3Click(Sender: TObject);
var i:integer;
s:string;
begin
  i:=length(names);
  if i>=40 then
  begin
    application.MessageBox('You can''t add more than 40 villages','Error');
    exit;
  end;
  setlength(names,i+1);
  s:='New village'+inttostr(schetchik);
  names[i]:=s;

  selected:=i;
  
  inc(schetchik);
  inc(count);

  desert.ListBox1.Items.Add(s);
  desert.ListBox1.Selected[selected]:=true;

  desert.Edit5.Text:=inttostr(count);
  //otobrazhenie;
end;

procedure Tdesert.Button4Click(Sender: TObject);
type a1=string[15];
var i:integer;
begin
  i:=selected;

  if count=1 then
  begin
    application.MessageBox('You can''t delete the last village name.'+#13+#10+'If you don''t want any villages, uncheck an option "Generate villages"','Error');
    exit;
  end;

  if i=(count-1) then
  begin
    setlength(names,count-1);
    dec(selected);
  end
  else
  begin
    move(names[i+1],names[i],sizeof(a1)*(count-selected-1));
    setlength(names,count-1);
    //dec(selected);
  end;

  dec(count);

  otobrazhenie;
end;

procedure Tdesert.CheckBox7Click(Sender: TObject);
begin
  if desert.CheckBox7.Checked then
  begin
    desert.CheckBox8.Enabled:=true;
    {desert.CheckBox9.Enabled:=true;
    desert.CheckBox10.Enabled:=true;
    desert.CheckBox11.Enabled:=true;
    desert.CheckBox12.Enabled:=true; }
    desert.Label6.Enabled:=true;
    desert.ListBox1.Enabled:=true;
    desert.Label5.Enabled:=true;
    desert.Edit4.Enabled:=true;
    desert.Button3.Enabled:=true;
    desert.Button4.Enabled:=true;
  end
  else
  begin
    desert.CheckBox8.Enabled:=false;
    {desert.CheckBox9.Enabled:=false;
    desert.CheckBox10.Enabled:=false;
    desert.CheckBox11.Enabled:=false;
    desert.CheckBox12.Enabled:=false; }
    desert.Label6.Enabled:=false;
    desert.ListBox1.Enabled:=false;
    desert.Label5.Enabled:=false;
    desert.Edit4.Enabled:=false;
    desert.Button3.Enabled:=false;
    desert.Button4.Enabled:=false;
  end;
end;

procedure Tdesert.CheckBox6Click(Sender: TObject);
begin
  if desert.CheckBox6.Checked then
  begin
    desert.CheckBox13.Enabled:=true;
    desert.CheckBox14.Enabled:=true;
    desert.CheckBox15.Enabled:=true;
  end
  else
  begin
    desert.CheckBox13.Enabled:=false;
    desert.CheckBox14.Enabled:=false;
    desert.CheckBox15.Enabled:=false;
  end;
end;

end.

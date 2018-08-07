unit blocksf;

interface

uses
   SysUtils, Controls, Forms, StdCtrls, Buttons, Classes, types_mct, Windows;

type
  Tblocks = class(TForm)
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    ListBox1: TListBox;
    Label1: TLabel;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    ListBox2: TListBox;
    Label4: TLabel;
    Edit4: TEdit;
    Button7: TButton;
    Button8: TButton;
    Label5: TLabel;
    ComboBox1: TComboBox;
    Label6: TLabel;
    Edit5: TEdit;
    ComboBox2: TComboBox;
    Label7: TLabel;
    Label8: TLabel;
    Edit6: TEdit;
    Button9: TButton;
    Button10: TButton;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure Edit6KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure Edit6Exit(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure Edit3Exit(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure Edit6Enter(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ListBox2DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
    procedure Edit5KeyPress(Sender: TObject; var Key: Char);
    procedure Button9Click(Sender: TObject);
    procedure Edit4Enter(Sender: TObject);
    procedure Edit4Exit(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox1KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox2KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox2Change(Sender: TObject);
    procedure Edit5Enter(Sender: TObject);
    procedure Edit5Exit(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  blocks: Tblocks;

implementation

uses blocks_mct, mainf;

type TColor = -$7FFFFFFF-1..$7FFFFFFF;
const clGray = TColor($808080);
clBlack = TColor($000000);

{$R *.dfm}

var blocks_temp:TBlock_set_ar;
blocks_change_temp:TBlock_change_ar;
selected:integer;
selected_change:integer;

id_temp:integer;
name_temp:string;

id_from_temp:integer;
id_to_temp:integer;  

function proverka_dublicate_id(id:integer):boolean;
var i:integer;
begin
  for i:=0 to length(blocks_temp)-1 do
    if (blocks_temp[i].id=id)and(i<>selected) then
    begin
      result:=true;
      exit;
    end;
  result:=false;
end;

procedure otobrazhenie;
var i:integer;
begin
  blocks.ListBox1.Items.Clear;
  for i:=0 to length(blocks_temp)-1 do
    blocks.ListBox1.Items.Add(blocks_temp[i].name+' ('+inttostr(blocks_temp[i].id)+')');

  blocks.ListBox1.Selected[selected]:=true;
end;

function formir_change(index:integer):string;
var str:string;
j,k:integer;
begin
  {str:='FromID:'+inttostr(blocks_change_temp[index].fromID)+'(Data:';
  if blocks_change_temp[index].fromData=16 then str:=str+'Any)'
  else str:=str+inttostr(blocks_change_temp[index].fromData)+')';
  j:=19-length(str);
  for k:=0 to j do str:=str+' ';
  str:=str+'-> ToID:'+inttostr(blocks_change_temp[index].toID)+'(Data:';
  if blocks_change_temp[index].toData=16 then str:=str+'Same)'
  else str:=str+inttostr(blocks_change_temp[index].toData)+')';    }
  str:='ID:'+inttostr(blocks_change_temp[index].fromID)+'(Data:';
  if blocks_change_temp[index].fromData=16 then str:=str+'Any)'
  else str:=str+inttostr(blocks_change_temp[index].fromData)+')';
  j:=15-length(str);
  for k:=0 to j do str:=str+' ';
  str:=str+'-> ID:'+inttostr(blocks_change_temp[index].toID)+'(Data:';
  if blocks_change_temp[index].toData=16 then str:=str+'Same)'
  else str:=str+inttostr(blocks_change_temp[index].toData)+')';
  result:=str;
end;

procedure otobrazhenie_change;
var i,j,k:integer;
str:string;
begin
  blocks.ListBox2.Items.Clear;
  
  for i:=0 to length(blocks_change_temp)-1 do
  begin
    {str:='FromID:'+inttostr(blocks_change_temp[i].fromID)+'(Data:';
    if blocks_change_temp[i].fromData=16 then str:=str+'Any)'
    else str:=str+inttostr(blocks_change_temp[i].fromData)+')';
    j:=19-length(str);
    for k:=0 to j do str:=str+' ';
    str:=str+'-> ToID:'+inttostr(blocks_change_temp[i].toID)+'(Data:';
    if blocks_change_temp[i].toData=16 then str:=str+'Same)'
    else str:=str+inttostr(blocks_change_temp[i].toData)+')';  }
    blocks.ListBox2.Items.Add(formir_change(i));
  end;

  if length(blocks_change_temp)<>0 then blocks.ListBox2.Selected[selected_change]:=true;
end;

procedure sortirovka;
var i,j,k:integer;
min:integer;
t_block:TBlock_set;
begin
  //sortirovka
  for i:=1 to length(blocks_temp)-2 do
  begin
    min:=i;
    for j:=i+1 to length(blocks_temp)-1 do
      if blocks_temp[min].id>blocks_temp[j].id then min:=j;

    if min<>i then
    begin
      setlength(t_block.data,length(blocks_temp[min].data));
      for k:=0 to length(t_block.data)-1 do
      begin
        t_block.data[k].data_id:=blocks_temp[min].data[k].data_id;
        t_block.data[k].data_name:=blocks_temp[min].data[k].data_name;
      end;
      t_block:=blocks_temp[min];

      setlength(blocks_temp[min].data,length(blocks_temp[i].data));
      for k:=0 to length(blocks_temp[min].data)-1 do
      begin
        blocks_temp[min].data[k].data_id:=blocks_temp[i].data[k].data_id;
        blocks_temp[min].data[k].data_name:=blocks_temp[i].data[k].data_name;
      end;
      blocks_temp[min]:=blocks_temp[i];

      setlength(blocks_temp[i].data,length(t_block.data));
      for k:=0 to length(t_block.data)-1 do
      begin
        blocks_temp[i].data[k].data_id:=t_block.data[k].data_id;
        blocks_temp[i].data[k].data_name:=t_block.data[k].data_name;
      end;
      blocks_temp[i]:=t_block;
    end;
  end;
end;

procedure Tblocks.Button1Click(Sender: TObject);
var i,j,k:integer;
dubl:array of integer;
mnozh:set_trans_blocks;
begin
  sortirovka;

  //perepisivaem bloki
  setlength(blocks_id,length(blocks_temp));
  for i:=0 to length(blocks_temp)-1 do
  begin
    blocks_id[i].id:=blocks_temp[i].id;
    blocks_id[i].name:=blocks_temp[i].name;
    blocks_id[i].solid:=blocks_temp[i].solid;
    blocks_id[i].transparent:=blocks_temp[i].transparent;
    blocks_id[i].diffuse:=blocks_temp[i].diffuse;
    blocks_id[i].tile:=blocks_temp[i].tile;
    blocks_id[i].light_level:=blocks_temp[i].light_level;
    blocks_id[i].diffuse_level:=blocks_temp[i].diffuse_level;

    setlength(blocks_id[i].data,length(blocks_temp[i].data));
    for j:=0 to length(blocks_temp[i].data)-1 do
    begin
      blocks_id[i].data[j].data_id:=blocks_temp[i].data[j].data_id;
      blocks_id[i].data[j].data_name:=blocks_temp[i].data[j].data_name;
    end;
  end;

  //proveraem na dublikati spisok smeni blokov
  setlength(dubl,0);
  mnozh:=[];

  for i:=0 to length(blocks_change_temp)-2 do
    for j:=i+1 to length(blocks_change_temp)-1 do
      if (blocks_change_temp[i].fromID=blocks_change_temp[j].fromID)and
      //(blocks_change_temp[i].toID=blocks_change_temp[j].toID)and
      (blocks_change_temp[i].fromData=blocks_change_temp[j].fromData)and
      //(blocks_change_temp[i].toData=blocks_change_temp[j].toData)and
      (not(j in mnozh))then
      begin
        k:=length(dubl);
        setlength(dubl,k+1);
        dubl[k]:=j;
        include(mnozh,j);
      end;

  mnozh:=[];

  for k:=0 to length(dubl)-1 do
  begin
    for i:=dubl[k] to length(blocks_change_temp)-2 do
      blocks_change_temp[i]:=blocks_change_temp[i+1];
    for i:=k+1 to length(dubl)-1 do
      dec(dubl[i]);
  end;

  setlength(blocks_change_temp,length(blocks_change_temp)-length(dubl));

  if length(dubl)<>0 then
    application.MessageBox('There are dublicates in block changes.'+#13+#10+'Removed dublicates entries.','Notice');

  //perepisivaem spikok change_blocks
  setlength(blocks_change_id,length(blocks_change_temp));
  for i:=0 to length(blocks_change_temp)-1 do
    blocks_change_id[i]:=blocks_change_temp[i];

  modalresult:=mrOK;
end;

procedure Tblocks.Button2Click(Sender: TObject);
begin
  modalresult:=mrCancel;
end;

procedure Tblocks.FormShow(Sender: TObject);
var i,j:integer;
begin
  //blokiruem kontroli dla smeni blokov po defoltu
  blocks.Button8.Enabled:=false;
  blocks.Button9.Enabled:=false;
  blocks.Edit4.Enabled:=false;
  blocks.Edit5.Enabled:=false;
  blocks.ComboBox1.ItemIndex:=0;
  blocks.ComboBox2.ItemIndex:=0;
  blocks.ComboBox1.Font.Color:=clGray;
  blocks.ComboBox2.Font.Color:=clGray;
  blocks.ComboBox1.Enabled:=false;
  blocks.ComboBox2.Enabled:=false;
  blocks.BitBtn1.Enabled:=false;
  blocks.BitBtn2.Enabled:=false;

  //perepisivaem bloki
  setlength(blocks_temp,length(blocks_id));
  for i:=0 to length(blocks_id)-1 do
  begin
    blocks_temp[i].id:=blocks_id[i].id;
    blocks_temp[i].name:=blocks_id[i].name;
    blocks_temp[i].solid:=blocks_id[i].solid;
    blocks_temp[i].transparent:=blocks_id[i].transparent;
    blocks_temp[i].diffuse:=blocks_id[i].diffuse;
    blocks_temp[i].tile:=blocks_id[i].tile;
    blocks_temp[i].light_level:=blocks_id[i].light_level;
    blocks_temp[i].diffuse_level:=blocks_id[i].diffuse_level;

    setlength(blocks_temp[i].data,length(blocks_id[i].data));
    for j:=0 to length(blocks_id[i].data)-1 do
    begin
      blocks_temp[i].data[j].data_id:=blocks_id[i].data[j].data_id;
      blocks_temp[i].data[j].data_name:=blocks_id[i].data[j].data_name;
    end;
  end;

  if length(blocks_temp)=1 then selected:=0
  else selected:=1;

  otobrazhenie;


  //perepisivaem change_blocks
  setlength(blocks_change_temp,length(blocks_change_id));
  for i:=0 to length(blocks_change_temp)-1 do
    blocks_change_temp[i]:=blocks_change_id[i];
  selected_change:=0;
  otobrazhenie_change;
end;

procedure Tblocks.ListBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var templeft, temptop:integer;
s:string;
begin
  with (Control as TListBox).Canvas do
  begin
    FillRect(Rect);
    TempLeft := Rect.Left+3;
    TempTop := Rect.Top;
    s := (Control as TListBox).Items[Index];
    if index=0 then font.Color:=clgray;
    //if index=(length(lay)-1) then font.Color:=clgray;
    TextOut(TempLeft, TempTop, s);

    if (odSelected in State) then
    begin
      selected:=index;
      blocks.Edit6.Text:=inttostr(blocks_temp[index].id);
      blocks.Edit1.Text:=blocks_temp[index].name;
      blocks.Edit2.Text:=inttostr(blocks_temp[index].light_level);
      blocks.Edit3.Text:=inttostr(blocks_temp[index].diffuse_level);

      blocks.CheckBox2.Checked:=blocks_temp[index].transparent;
      blocks.CheckBox1.Checked:=blocks_temp[index].solid;
      blocks.CheckBox3.Checked:=blocks_temp[index].diffuse;

      blocks.CheckBox2Click(blocks);
      blocks.CheckBox3Click(blocks);

      //blocks.Memo1.Lines.Add('Index='+inttostr(index));
      //selected:=index;
      //flatmap.Memo1.Lines.Add('Selected='+inttostr(index));
      //i:=count-selected-1;
      {settings.Edit3.Text:=lay[i].name;
      settings.Edit4.Text:=inttostr(lay[i].start_alt);
      settings.Edit5.Text:=inttostr(lay[i].width);
      s:=getblockname(lay[i].material)+' ('+inttostr(lay[i].material)+')';
      settings.ComboBox3.ItemIndex:=settings.ComboBox3.Items.IndexOf(s);
      if settings.ComboBox3.ItemIndex=-1 then settings.ComboBox3.ItemIndex:=0; }

      if index=0 then
      begin
        blocks.CheckBox1.Enabled:=false;
        blocks.CheckBox2.Enabled:=false;
        blocks.CheckBox3.Enabled:=false;
        blocks.Edit1.Enabled:=false;
        //blocks.Edit1.Font.Color:=clgray;
        blocks.Edit2.Enabled:=false;
        //blocks.Edit2.Font.Color:=clgray;
        blocks.Edit3.Enabled:=false;
        //blocks.Edit3.Font.Color:=clgray;
        blocks.Edit6.Enabled:=false;
        //blocks.Edit6.Font.Color:=clgray;
        blocks.Button4.Enabled:=false;
      end
      else
      begin
        blocks.CheckBox1.Enabled:=true;
        blocks.CheckBox2.Enabled:=true;
        //blocks.CheckBox3.Enabled:=true;
        blocks.Edit1.Enabled:=true;
        //blocks.Edit1.Font.Color:=clblack;
        blocks.Edit2.Enabled:=true;
        //blocks.Edit2.Font.Color:=clblack;
        //blocks.Edit3.Enabled:=true;
        //blocks.Edit3.Font.Color:=clblack;
        blocks.Edit6.Enabled:=true;
        //blocks.Edit6.Font.Color:=clblack;
        blocks.Button4.Enabled:=true;
      end;
    end;
  end;
end;

procedure Tblocks.Edit6KeyPress(Sender: TObject; var Key: Char);
var str:string;
begin
  if (key=#24)or(key=#3)or(key=#22) then exit;

  if not(((key>=#48)and(key<=#57))or(key=#8)or(key=#46)or(key=#13)) then
  begin
    key:=#0;
    exit;
  end;

  str:=blocks.Edit6.Text;
  if (length(str)>=5)and(key<>#8)and(key<>#13)and(key<>#46)and(blocks.Edit6.SelLength<1) then key:=#0;

  if Key = Chr(VK_RETURN) then
  begin
    Perform(WM_NEXTDLGCTL,0,0);
    key:=#0;
  end;
end;

procedure Tblocks.Edit1KeyPress(Sender: TObject; var Key: Char);
var str:string;
begin
  str:=blocks.Edit1.Text;
  if (length(str)>=35)and(key<>#8)and(key<>#13)and(key<>#46)and(blocks.Edit1.SelLength<1) then key:=#0;

  if Key = Chr(VK_RETURN) then
  begin
    Perform(WM_NEXTDLGCTL,0,0);
    key:= #0;
  end;
end;

procedure Tblocks.Edit2KeyPress(Sender: TObject; var Key: Char);
var str:string;
begin
  if (key=#24)or(key=#3)or(key=#22) then exit;

  if not(((key>=#48)and(key<=#57))or(key=#8)or(key=#46)or(key=#13)) then
  begin
    key:=#0;
    exit;
  end;

  str:=blocks.Edit2.Text;
  if (length(str)>=2)and(key<>#8)and(key<>#13)and(key<>#46)and(blocks.Edit2.SelLength<1) then key:=#0;

  if Key = Chr(VK_RETURN) then
  begin
    Perform(WM_NEXTDLGCTL,0,0);
    key:= #0;
  end;
end;

procedure Tblocks.Edit3KeyPress(Sender: TObject; var Key: Char);
var str:string;
begin
  if (key=#24)or(key=#3)or(key=#22) then exit;

  if not(((key>=#48)and(key<=#57))or(key=#8)or(key=#46)or(key=#13)) then
  begin
    key:=#0;
    exit;
  end;

  str:=blocks.Edit3.Text;
  if (length(str)>=2)and(key<>#8)and(key<>#13)and(key<>#46)and(blocks.Edit3.SelLength<1) then key:=#0;

  if Key = Chr(VK_RETURN) then
  begin
    Perform(WM_NEXTDLGCTL,0,0);
    key:= #0;
  end;
end;

procedure Tblocks.Edit6Exit(Sender: TObject);
var i:integer;
str:string;
begin
  i:=strtoint(blocks.Edit6.Text);
  if proverka_dublicate_id(i)=true then
  begin
    application.MessageBox('There is a block with this ID','Error');
    blocks.Edit6.SelStart:=0;
    blocks.Edit6.SelLength:=length(blocks.Edit6.Text);
    blocks.Edit6.SetFocus;
    exit;
  end
  else
    if i<>id_temp then
    begin
      blocks_temp[selected].id:=i;

      str:=blocks_temp[selected].name+' ('+inttostr(i)+')';

      sortirovka;

      otobrazhenie;

      //application.MessageBox(pchar(inttostr(blocks.ListBox1.Items.IndexOf(str))),'')

      blocks.ListBox1.Selected[blocks.ListBox1.Items.IndexOf(str)]:=true;

      //blocks.ListBox1.Items.Delete(id_temp);
      //blocks.ListBox1.Items.Insert(i,blocks_temp[selected].name+' ('+inttostr(blocks_temp[selected].id)+')');
    end;
end;

procedure Tblocks.Edit2Exit(Sender: TObject);
begin
  blocks_temp[selected].light_level:=strtoint(blocks.Edit2.Text);
end;

procedure Tblocks.Edit3Exit(Sender: TObject);
begin
  blocks_temp[selected].diffuse_level:=strtoint(blocks.Edit3.Text);
end;

procedure Tblocks.CheckBox2Click(Sender: TObject);
var b:boolean;
begin
  b:=blocks.CheckBox2.Checked;
  blocks_temp[selected].transparent:=b;
  if b=true then blocks.CheckBox3.Enabled:=true
  else
  begin
    blocks.CheckBox3.Checked:=false;
    blocks.CheckBox3.Enabled:=false;
  end;
end;

procedure Tblocks.CheckBox1Click(Sender: TObject);
begin
  blocks_temp[selected].solid:=blocks.CheckBox1.Checked;
end;

procedure Tblocks.CheckBox3Click(Sender: TObject);
var b:boolean;
begin
  b:=blocks.CheckBox3.Checked;
  blocks_temp[selected].diffuse:=b;
  if b=true then blocks.Edit3.Enabled:=true
  else blocks.Edit3.Enabled:=false;
end;

procedure Tblocks.Edit6Enter(Sender: TObject);
begin
  id_temp:=strtoint(blocks.Edit6.Text);
end;

procedure Tblocks.Edit1Enter(Sender: TObject);
begin
  name_temp:=blocks.Edit1.Text;
end;

procedure Tblocks.Button5Click(Sender: TObject);
begin
  fill_standard_blocks(@blocks_temp);

  selected:=1;
  otobrazhenie;
end;

procedure Tblocks.Button6Click(Sender: TObject);
var i:integer;
begin
  for i:=0 to length(blocks_temp)-1 do
    setlength(blocks_temp[i].data,0);
  setlength(blocks_temp,1);

  selected:=0;
  otobrazhenie;
end;

procedure Tblocks.Button3Click(Sender: TObject);
var i,j,k:integer;
begin
  j:=0;
  for i:=0 to length(blocks_temp)-1 do
  begin
    if blocks_temp[i].id<>j then
    begin
      setlength(blocks_temp,length(blocks_temp)+1);
      for k:=length(blocks_temp)-1 downto i+1 do
        blocks_temp[k]:=blocks_temp[k-1];
      selected:=i;
      blocks_temp[i].id:=j;
      blocks_temp[i].name:='New block';
      blocks_temp[i].solid:=false;
      blocks_temp[i].transparent:=false;
      blocks_temp[i].diffuse:=false;
      blocks_temp[i].tile:=false;
      blocks_temp[i].light_level:=0;
      blocks_temp[i].diffuse_level:=0;
      setlength(blocks_temp[i].data,0);

      blocks.ListBox1.Items.Insert(selected,'New block ('+inttostr(j)+')');
      blocks.ListBox1.Selected[selected]:=true;

      //otobrazhenie;
      break;
    end
    else
      inc(j);
  end;

  if j=length(blocks_temp) then
  begin
    setlength(blocks_temp,length(blocks_temp)+1);
    i:=length(blocks_temp)-1;
    selected:=i;
    blocks_temp[i].id:=j;
    blocks_temp[i].name:='New block';
    blocks_temp[i].solid:=false;
    blocks_temp[i].transparent:=false;
    blocks_temp[i].diffuse:=false;
    blocks_temp[i].tile:=false;
    blocks_temp[i].light_level:=0;
    blocks_temp[i].diffuse_level:=0;
    setlength(blocks_temp[i].data,0);

    blocks.ListBox1.Items.Add('New block ('+inttostr(j)+')');
    blocks.ListBox1.Selected[selected]:=true;
    //otobrazhenie;
  end;
end;

procedure Tblocks.Button4Click(Sender: TObject);
var i,j:integer;
begin
  for i:=selected to length(blocks_temp)-2 do
  begin
    setlength(blocks_temp[i].data,length(blocks_temp[i+1].data));
    for j:=0 to length(blocks_temp[i].data)-1 do
    begin
      blocks_temp[i].data[j].data_id:=blocks_temp[i+1].data[j].data_id;
      blocks_temp[i].data[j].data_name:=blocks_temp[i+1].data[j].data_name;
    end;
    blocks_temp[i]:=blocks_temp[i+1];
  end;

  i:=length(blocks_temp);
  if selected=(i-1) then
  begin
    blocks.ListBox1.Items.Delete(selected);
    dec(selected);
    blocks.ListBox1.Selected[selected]:=true;
  end
  else
  begin
    blocks.ListBox1.Items.Delete(selected);
    blocks.ListBox1.Selected[selected]:=true;
  end;

  setlength(blocks_temp,i-1);
end;

procedure Tblocks.ListBox2DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var templeft,temptop:integer;
s:string;
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
      selected_change:=index;

      blocks.Button8.Enabled:=true;
      blocks.Button9.Enabled:=true;
      blocks.Edit4.Enabled:=true;
      blocks.Edit5.Enabled:=true;
      blocks.ComboBox1.Enabled:=true;
      blocks.ComboBox2.Enabled:=true;

      blocks.ComboBox1.Font.Color:=clBlack;
      blocks.ComboBox2.Font.Color:=clBlack;

      blocks.Edit4.Text:=inttostr(blocks_change_temp[index].fromID);
      blocks.Edit5.Text:=inttostr(blocks_change_temp[index].toID);
      if blocks_change_temp[index].fromData=16 then blocks.ComboBox1.ItemIndex:=0
      else blocks.ComboBox1.ItemIndex:=blocks_change_temp[index].fromData+1;
      if blocks_change_temp[index].toData=16 then blocks.ComboBox2.ItemIndex:=0
      else blocks.ComboBox2.ItemIndex:=blocks_change_temp[index].toData+1;

      if selected_change=0 then
        blocks.BitBtn1.Enabled:=false
      else
        blocks.BitBtn1.Enabled:=true;

      if selected_change=length(blocks_change_temp)-1 then
        blocks.BitBtn2.Enabled:=false
      else
        blocks.BitBtn2.Enabled:=true;
    end;
  end;
end;

procedure Tblocks.Edit4KeyPress(Sender: TObject; var Key: Char);
var str:string;
begin
  if (key=#24)or(key=#3)or(key=#22) then exit;

  if not(((key>=#48)and(key<=#57))or(key=#8)or(key=#46)or(key=#13)) then
  begin
    key:=#0;
    exit;
  end;

  str:=blocks.Edit4.Text;
  if (length(str)>=5)and(key<>#8)and(key<>#13)and(key<>#46)and(blocks.Edit4.SelLength<1) then key:=#0;

  if Key = Chr(VK_RETURN) then
  begin
    Perform(WM_NEXTDLGCTL,0,0);
    key:=#0;
  end;
end;

procedure Tblocks.Edit5KeyPress(Sender: TObject; var Key: Char);
var str:string;
begin
  if (key=#24)or(key=#3)or(key=#22) then exit;

  if not(((key>=#48)and(key<=#57))or(key=#8)or(key=#46)or(key=#13)) then
  begin
    key:=#0;
    exit;
  end;

  str:=blocks.Edit5.Text;
  if (length(str)>=5)and(key<>#8)and(key<>#13)and(key<>#46)and(blocks.Edit5.SelLength<1) then key:=#0;

  if Key = Chr(VK_RETURN) then
  begin
    Perform(WM_NEXTDLGCTL,0,0);
    key:=#0;
  end;
end;

procedure Tblocks.Button9Click(Sender: TObject);
begin
  setlength(blocks_change_temp,0);
  selected_change:=0;
  otobrazhenie_change;

  //blokiruem kontroli dla smeni blokov po defoltu
  blocks.Button8.Enabled:=false;
  blocks.Button9.Enabled:=false;
  blocks.Edit4.Enabled:=false;
  blocks.Edit5.Enabled:=false;
  blocks.ComboBox1.ItemIndex:=0;
  blocks.ComboBox2.ItemIndex:=0;
  blocks.ComboBox1.Font.Color:=clGray;
  blocks.ComboBox2.Font.Color:=clGray;
  blocks.ComboBox1.Enabled:=false;
  blocks.ComboBox2.Enabled:=false;
  blocks.BitBtn1.Enabled:=false;
  blocks.BitBtn2.Enabled:=false;
  blocks.Edit4.Text:='';
  blocks.Edit5.Text:='';
end;

procedure Tblocks.Edit4Enter(Sender: TObject);
begin
  id_from_temp:=strtoint(blocks.Edit4.Text);
end;

procedure Tblocks.Edit4Exit(Sender: TObject);
var i,j,k:integer;
str:string;
begin
  i:=strtoint(blocks.Edit4.Text);

  if i=0 then
  begin
    application.MessageBox('You can''t replace Air','Error');
    blocks.Edit4.SelStart:=0;
    blocks.Edit4.SelLength:=length(blocks.Edit6.Text);
    blocks.Edit4.SetFocus;
    exit;
  end;

  blocks_change_temp[selected_change].fromID:=i;
  if i<>id_from_temp then
    blocks.ListBox2.Items.Strings[selected_change]:=formir_change(selected_change);
end;

procedure Tblocks.ComboBox1Change(Sender: TObject);
var i:integer;
begin
  i:=blocks.ComboBox1.ItemIndex;
  if i=0 then i:=16
  else dec(i);
  blocks_change_temp[selected_change].fromData:=i;
  blocks.ListBox2.Items.Strings[selected_change]:=formir_change(selected_change);
end;

procedure Tblocks.ComboBox1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(VK_RETURN) then
  begin
    Perform(WM_NEXTDLGCTL,0,0);
    key:=#0;
  end;
end;

procedure Tblocks.ComboBox2KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(VK_RETURN) then
  begin
    Perform(WM_NEXTDLGCTL,0,0);
    key:=#0;
  end;
end;

procedure Tblocks.ComboBox2Change(Sender: TObject);
var i:integer;
begin
  i:=blocks.ComboBox2.ItemIndex;
  if i=0 then i:=16
  else dec(i);
  blocks_change_temp[selected_change].toData:=i;
  blocks.ListBox2.Items.Strings[selected_change]:=formir_change(selected_change);
end;

procedure Tblocks.Edit5Enter(Sender: TObject);
begin
  id_to_temp:=strtoint(blocks.Edit5.Text);
end;

procedure Tblocks.Edit5Exit(Sender: TObject);
var i:integer;
begin
  i:=strtoint(blocks.Edit5.Text);

  blocks_change_temp[selected_change].toID:=i;
  if i<>id_to_temp then
    blocks.ListBox2.Items.Strings[selected_change]:=formir_change(selected_change);
end;

procedure Tblocks.Edit1Change(Sender: TObject);
var str:string;
begin
  str:=blocks.Edit1.Text;
  blocks_temp[selected].name:=str;
  if str<>name_temp then
  begin
    str:=str+' ('+inttostr(blocks_temp[selected].id)+')';
    blocks.ListBox1.Items.Strings[selected]:=str;
  end;
end;

procedure Tblocks.Button7Click(Sender: TObject);
var i:integer;
begin
  i:=length(blocks_change_temp);
  setlength(blocks_change_temp,i+1);

  blocks_change_temp[i].fromID:=1;
  blocks_change_temp[i].toID:=1;
  blocks_change_temp[i].fromData:=16;
  blocks_change_temp[i].toData:=16;

  blocks.ListBox2.Items.Add(formir_change(i));
  selected_change:=i;
  blocks.ListBox2.Selected[selected_change]:=true;
end;

procedure Tblocks.Button10Click(Sender: TObject);
var i,j:integer;
begin
  i:=length(blocks_change_temp);
  setlength(blocks_change_temp,i+1);

  for j:=length(blocks_change_temp)-2 downto selected_change do
    blocks_change_temp[j+1]:=blocks_change_temp[j];
  //move(blocks_change_temp[selected_change],blocks_change_temp[selected_change+1],i-selected_change);
  blocks_change_temp[selected_change].fromID:=1;
  blocks_change_temp[selected_change].toID:=1;
  blocks_change_temp[selected_change].fromData:=16;
  blocks_change_temp[selected_change].toData:=16;
  blocks.ListBox2.Items.Insert(selected_change,formir_change(selected_change));
  blocks.ListBox2.Selected[selected_change]:=true;

  {if i<>0 then blocks.ListBox2.Items.Insert(selected_change+1,formir_change(i))
  else blocks.ListBox2.Items.Insert(selected_change,formir_change(i));
  if i<>0 then inc(selected_change);
  blocks.ListBox2.Selected[selected_change]:=true;   }
end;

procedure Tblocks.Button8Click(Sender: TObject);
var i:integer;
begin
  for i:=selected_change to length(blocks_change_temp)-2 do
    blocks_change_temp[i]:=blocks_change_temp[i+1];

  i:=length(blocks_change_temp);
  if i=0 then exit;
  setlength(blocks_change_temp,i-1);

  blocks.ListBox2.Items.Delete(selected_change);
  if i<>1 then
  begin
    if selected_change=i-1 then dec(selected_change);
    blocks.ListBox2.Selected[selected_change]:=true;
  end
  else
  begin
    //blokiruem kontroli dla smeni blokov po defoltu
  blocks.Button8.Enabled:=false;
  blocks.Button9.Enabled:=false;
  blocks.Edit4.Enabled:=false;
  blocks.Edit5.Enabled:=false;
  blocks.ComboBox1.ItemIndex:=0;
  blocks.ComboBox2.ItemIndex:=0;
  blocks.ComboBox1.Font.Color:=clGray;
  blocks.ComboBox2.Font.Color:=clGray;
  blocks.ComboBox1.Enabled:=false;
  blocks.ComboBox2.Enabled:=false;
  blocks.BitBtn1.Enabled:=false;
  blocks.BitBtn2.Enabled:=false;
  blocks.Edit4.Text:='';
  blocks.Edit5.Text:='';
  end;
end;

procedure Tblocks.BitBtn1Click(Sender: TObject);
var temp_ch:TBlock_change;
begin
  temp_ch:=blocks_change_temp[selected_change];
  blocks_change_temp[selected_change]:=blocks_change_temp[selected_change-1];
  blocks_change_temp[selected_change-1]:=temp_ch;  

  blocks.ListBox2.Items.Move(selected_change,selected_change-1);
  dec(selected_change);
  blocks.ListBox2.Selected[selected_change]:=true;
end;

procedure Tblocks.BitBtn2Click(Sender: TObject);
var temp_ch:TBlock_change;
begin
  temp_ch:=blocks_change_temp[selected_change];
  blocks_change_temp[selected_change]:=blocks_change_temp[selected_change+1];
  blocks_change_temp[selected_change+1]:=temp_ch;

  blocks.ListBox2.Items.Move(selected_change,selected_change+1);
  inc(selected_change);
  blocks.ListBox2.Selected[selected_change]:=true;
end;

procedure Tblocks.FormCreate(Sender: TObject);
begin
  if save_opt.save_enabled=true then
    if (save_opt.blocks_f.top<>-1)and(save_opt.blocks_f.left<>-1) then
    begin
      blocks.Top:=save_opt.blocks_f.top;
      blocks.Left:=save_opt.blocks_f.left;
    end;
end;

end.

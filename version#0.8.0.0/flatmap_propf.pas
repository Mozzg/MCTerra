unit flatmap_propf;

interface

uses
  Windows, SysUtils, Forms,
  Buttons, Controls, StdCtrls, Classes;

type
  Tflatmap = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ListBox1: TListBox;
    Button3: TButton;
    Button5: TButton;
    Edit3: TEdit;
    Label5: TLabel;
    Edit4: TEdit;
    Label6: TLabel;
    Edit5: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Button9: TButton;
    Button4: TButton;
    ComboBox3: TComboBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    ComboBox1: TComboBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure Button9Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Edit3Exit(Sender: TObject);
    procedure Edit5Exit(Sender: TObject);
    procedure ComboBox3Exit(Sender: TObject);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure Edit5KeyPress(Sender: TObject; var Key: Char);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox1Exit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  flatmap: Tflatmap;

implementation

uses mainf, generation_obsh;

{$R *.dfm}
type TColor = -$7FFFFFFF-1..$7FFFFFFF;

const WM_NEXTDLGCTL = $0028;
  clGray = TColor($808080);
  clBlack = TColor($000000);

var lay:layers_ar;
selected:integer;
count:integer;
schetchik:integer; 

procedure otobrazhenie;
var i:integer;
begin
  flatmap.ListBox1.Clear;
  for i:=0 to length(lay)-1 do
  begin
    //flatmap.ListBox1.Items.Add(lay[i].name);
    flatmap.ListBox1.Items.Insert(0,lay[i].name);
  end;
  //flatmap.ListBox1.ItemIndex:=length(lay)-count-1;
  flatmap.ListBox1.Selected[selected]:=true;
end;

{function proverka_flatmap:integer;  //funkciya proverki pravilnosti vvoda
var i:integer;
begin
  result:=-1;
  try
  
  except
    on E: Exception do
    begin
      result:=-1;
      exit;
    end;
  end;
  result:=0;
end;  }

procedure Tflatmap.Button1Click(Sender: TObject);
var i,j:integer;
str:string;
begin
  i:=0;
  case i of
  0:begin
      setlength(main.flatmap_prop.sloi,length(lay));
      for j:=0 to length(lay)-1 do
      begin
        main.flatmap_prop.sloi[j]:=lay[j];
      end;

      ModalResult := mrOK;
    end;
  1:begin
      application.MessageBox('Ground level must be between 0 and 127','Error');
    end;
  2:begin
      application.MessageBox('Water level must be between 0 and 127','Error');
    end;
  3:begin
      application.MessageBox('You cannot place sand or gravel on top of the water','Error'); 
    end;
  4:begin
      application.MessageBox('Ground level too low for 2 layers of material.'+#13+#10+'If you want a thin level, uncheck "Dirt on top" parameter.','Error');
    end
  else
    begin
      application.MessageBox('You entered wrong numbers','Error');
    end;
  end;
end;

procedure Tflatmap.Button2Click(Sender: TObject);
begin
  modalresult:=mrCancel;
end;

procedure Tflatmap.FormShow(Sender: TObject);
var i:integer;
begin
  setlength(lay,length(main.flatmap_prop.sloi));
  for i:=0 to length(lay)-1 do
  begin
    lay[i]:=main.flatmap_prop.sloi[i];
  end;

  count:=length(lay);
  selected:=count-1;

  schetchik:=1;

  otobrazhenie;
end;

procedure Tflatmap.Button3Click(Sender: TObject);
var s:string;
i:integer;
begin   
  s:='Layer '+inttostr(schetchik);

  i:=length(lay);

  if lay[i-1].start_alt+lay[i-1].width=127 then
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

  flatmap.ListBox1.Items.Insert(0,s);
  inc(count);
  dec(selected);
  inc(schetchik)
end;

procedure Tflatmap.ListBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var s:string;
templeft,temptop,i,j,k:integer;
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
      flatmap.Edit3.Text:=lay[i].name;
      flatmap.Edit4.Text:=inttostr(lay[i].start_alt);
      flatmap.Edit5.Text:=inttostr(lay[i].width);
      s:=getblockname(lay[i].material);
      flatmap.ComboBox3.ItemIndex:=flatmap.ComboBox3.Items.IndexOf(s);
      if flatmap.ComboBox3.ItemIndex=-1 then flatmap.ComboBox3.ItemIndex:=0;

      flatmap.ComboBox3Change(flatmap);   

      if i=0 then
      begin
        flatmap.Edit3.Enabled:=false;
        flatmap.Edit5.Enabled:=false;
        flatmap.ComboBox3.Enabled:=false;
        flatmap.ComboBox3.Font.Color:=clgray;
        flatmap.ComboBox1.Enabled:=false;
        flatmap.ComboBox1.Font.Color:=clgray;
        flatmap.Button5.Enabled:=false;
        flatmap.BitBtn1.Enabled:=false;
        flatmap.BitBtn2.Enabled:=false;
      end
      else if i=1 then
      begin
        flatmap.Edit3.Enabled:=true;
        flatmap.Edit5.Enabled:=true;
        flatmap.ComboBox3.Enabled:=true;
        flatmap.ComboBox3.Font.Color:=clblack;
        flatmap.ComboBox1.Enabled:=true;
        flatmap.ComboBox1.Font.Color:=clblack;
        flatmap.Button5.Enabled:=true;
        flatmap.BitBtn1.Enabled:=true;
        flatmap.BitBtn2.Enabled:=false;
      end
      else if i=count-1 then
      begin
        flatmap.Edit3.Enabled:=true;
        flatmap.Edit5.Enabled:=true;
        flatmap.ComboBox3.Enabled:=true;
        flatmap.ComboBox3.Font.Color:=clblack;
        flatmap.ComboBox1.Enabled:=true;
        flatmap.ComboBox1.Font.Color:=clblack;
        flatmap.Button5.Enabled:=true;
        flatmap.BitBtn1.Enabled:=false;
        flatmap.BitBtn2.Enabled:=true;
      end
      else
      begin
        flatmap.Edit3.Enabled:=true;
        flatmap.Edit5.Enabled:=true;
        flatmap.ComboBox3.Enabled:=true;
        flatmap.ComboBox3.Font.Color:=clblack;
        flatmap.ComboBox1.Enabled:=true;
        flatmap.ComboBox1.Font.Color:=clblack;
        flatmap.Button5.Enabled:=true;
        flatmap.BitBtn1.Enabled:=true;
        flatmap.BitBtn2.Enabled:=true;
      end;
    end;
  end;    
end;

procedure Tflatmap.Button9Click(Sender: TObject);
var s:string;
i,j:integer;
begin
  s:='Layer '+inttostr(schetchik);

  i:=length(lay);

  if lay[i-1].start_alt+lay[i-1].width=127 then
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
    move(lay[i],lay[i+1],sizeof(layers)*(selected));
    lay[i].width:=1;
    lay[i].material:=1;
    lay[i].material_data:=0;
    lay[i].name:=s;
    for j:=i to length(lay)-1 do
      lay[j].start_alt:=lay[j-1].start_alt+lay[j-1].width;
  end;

  flatmap.ListBox1.Items.Insert(selected,s);
  inc(count);
  dec(selected);
  inc(schetchik);
end;

procedure Tflatmap.FormDestroy(Sender: TObject);
begin
  setlength(lay,0);
end;

procedure Tflatmap.Edit3Exit(Sender: TObject);
var i:integer;
s:string;
begin
  //flatmap.Memo1.Lines.Add('OnExit');
  s:=flatmap.Edit3.Text;
  i:=count-selected-1;
  lay[i].name:=s;
  flatmap.ListBox1.Items.Strings[selected]:=s;
end;

procedure Tflatmap.Edit5Exit(Sender: TObject);
var i,j,k,z:integer;
s:string;
begin
  s:=flatmap.Edit5.Text;
  if (s='')or(s='0') then
  begin
    s:='1';
    flatmap.Edit5.Text:=s;
  end;
  j:=strtoint(s);
  i:=count-selected-1;

  k:=lay[i].width;

  if j>k then
  begin
  z:=j-k;
  if (lay[length(lay)-1].start_alt+lay[length(lay)-1].width+z)>127 then
  begin
    application.MessageBox('Width is too high for this altitude','Error');
    //flatmap.Edit5.SelText:=flatmap.Edit5.Text;
    flatmap.Edit5.SelStart:=0;
    flatmap.Edit5.SelLength:=length(flatmap.Edit5.Text);
    flatmap.Edit5.SetFocus;
    exit;
  end;
  end;

  lay[i].width:=j;

  if i<length(lay)-1 then
    for j:=i+1 to length(lay)-1 do
      lay[j].start_alt:=lay[j-1].start_alt+lay[j-1].width;
end;

procedure Tflatmap.ComboBox3Exit(Sender: TObject);
var i,j:integer;
begin
  i:=count-selected-1;
  lay[i].material:=getblockid(flatmap.ComboBox3.Text);
end;

procedure Tflatmap.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
  if (length(flatmap.Edit3.Text)>=26)and(key<>#13)and(key<>#8)and(key<>#46) then key:=#0;

  if Key = Chr(VK_RETURN) then
  begin
    Perform(WM_NEXTDLGCTL,0,0);
    key:= #0;
  end;
end;

procedure Tflatmap.Edit5KeyPress(Sender: TObject; var Key: Char);
begin
  if not(((key>=#48) and (key<=#57))or (key=#8)or(key=#46)or(key=#13)) then key:=#0;

  if (length(flatmap.Edit5.Text)>=5)and(key<>#13)and(key<>#8)and(key<>#46) then key:=#0;

  if Key = Chr(VK_RETURN) then
  begin
    Perform(WM_NEXTDLGCTL,0,0);
    //flatmap.ComboBox3.SetFocus;
    key:= #0;
  end;
end;

procedure Tflatmap.Button4Click(Sender: TObject);
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

procedure Tflatmap.Button5Click(Sender: TObject);
var i,j:integer;
begin
  i:=count-selected-1;
  if i=count-1 then
  begin
    setlength(lay,count-1);
  end
  else
  begin
    move(lay[i+1],lay[i],sizeof(layers)*selected);
    setlength(lay,count-1);

    for j:=i to length(lay)-1 do
      lay[j].start_alt:=lay[j-1].start_alt+lay[j-1].width;
  end;

  dec(count);

  otobrazhenie;
end;

procedure Tflatmap.BitBtn2Click(Sender: TObject);
var i,j:integer;
temp:layers;
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

procedure Tflatmap.BitBtn1Click(Sender: TObject);
var i,j:integer;
temp:layers;
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

procedure Tflatmap.ComboBox3Change(Sender: TObject);
var i,j,k:integer;
begin
  i:=count-selected-1;
  j:=getblockid(flatmap.ComboBox3.Text);
  flatmap.ComboBox1.Items.Clear;
      case j of
      17,18:begin  //wood, leaves
              for k:=1 to length(wood_data) do
                flatmap.ComboBox1.Items.Add(wood_data[k]);
            end;
      29,33:begin  //pistons
              for k:=1 to length(pistons_data) do
                flatmap.ComboBox1.Items.Add(pistons_data[k]);
            end;
      35:begin  //wool
           for k:=1 to length(wool_data) do
             flatmap.ComboBox1.Items.Add(wool_data[k]);
         end;
      43,44:begin  //double slabs, slabs
              for k:=1 to length(slabs_data) do
                flatmap.ComboBox1.Items.Add(slabs_data[k]);
            end;
      86,91:begin  //pumpkin, jack-o-lantern
              for k:=1 to length(pumpkin_data) do
                flatmap.ComboBox1.Items.Add(pumpkin_data[k]);
            end;
      97:begin  //silverfish
           for k:=1 to length(silverfish_data) do
             flatmap.ComboBox1.Items.Add(silverfish_data[k]);
         end;
      98:begin  //stone brick
           for k:=1 to length(stonebrick_data) do
             flatmap.ComboBox1.Items.Add(stonebrick_data[k]);
         end;
      99,100:begin  //huge mushrooms
               for k:=1 to length(mushroom_data) do
                 flatmap.ComboBox1.Items.Add(mushroom_data[k]);
             end;
      else
        //if flatmap.ComboBox1.Items.Count<>1 then
        begin
          flatmap.ComboBox1.Items.Add('Item data not available');
        end;
      end;
  flatmap.ComboBox1.ItemIndex:=lay[i].material_data;
end;

procedure Tflatmap.ComboBox1Exit(Sender: TObject);
var i:integer;
begin
  i:=count-selected-1;
  lay[i].material_data:=flatmap.ComboBox1.ItemIndex;
end;

end.

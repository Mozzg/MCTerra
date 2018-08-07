unit border_propf;

interface

uses
  SysUtils, StdCtrls, ExtCtrls, Forms, Controls,
  jpeg, Classes;

type
  TBorder = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    ComboBox1: TComboBox;
    GroupBox5: TGroupBox;
    Panel1: TPanel;
    Image1: TImage;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    ComboBox2: TComboBox;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    Edit2: TEdit;
    GroupBox3: TGroupBox;
    CheckBox1: TCheckBox;
    Edit3: TEdit;
    Label4: TLabel;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Label6: TLabel;
    Edit4: TEdit;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    ComboBox3: TComboBox;
    Label7: TLabel;
    CheckBox5: TCheckBox;
    CheckBox7: TCheckBox;
    Label8: TLabel;
    ComboBox4: TComboBox;
    CheckBox8: TCheckBox;
    Label9: TLabel;
    ComboBox5: TComboBox;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    CheckBox9: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox1Change(Sender: TObject);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox7Click(Sender: TObject);
    procedure CheckBox8Click(Sender: TObject);
    procedure CheckBox9Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Border: TBorder;

implementation

uses mainf, generation_obsh;

{$R *.dfm}

function proverka_border:integer;
var i:integer;
begin
  result:=-1;
  try
  i:=strtoint(border.Edit1.Text);
  if (i<1)or(i>16) then
  begin
    result:=1;
    exit;
  end;
  i:=strtoint(border.Edit2.Text);
  if (i<1)or(i>255) then
  begin
    result:=2;
    exit;
  end;
  i:=strtoint(border.Edit3.Text);
  if (i<1)or(i>255) then
  begin
    result:=2;
    exit;
  end;
  i:=strtoint(border.Edit4.Text);
  if (i<1)or(i>255) then
  begin
    result:=3;
    exit;
  end;
  except
    on e:exception do
    begin
      exit;
    end;
  end;
  result:=0;
end;

procedure TBorder.Button1Click(Sender: TObject);
var i:integer;
str:string;
begin
  i:=proverka_border;
  case i of
  0:begin
      {if (main.ComboBox1.ItemIndex=5)and(border.ComboBox1.ItemIndex=3) then
      begin
        application.MessageBox('You cannot use this type of border with Planetoid type map','Error');
        exit;
      end; }
      if (main.ComboBox1.ItemIndex=7)and(border.ComboBox1.ItemIndex=3) then
      begin
        application.MessageBox('You cannot use this type of border with Golden Tunnels type map','Error');
        exit;
      end;

      main.border_prop.border_type:=border.ComboBox1.ItemIndex;
      main.border_prop.wall_thickness:=strtoint(border.Edit1.Text);
      main.border_prop.wall_void_thickness:=strtoint(border.Edit3.Text);
      main.border_prop.void_thickness:=strtoint(border.Edit2.Text);
      main.border_prop.wall_void:=border.CheckBox1.Checked;

      main.border_prop.cwall_gen_towers:=border.CheckBox3.Checked;
      main.border_prop.cwall_towers_type:=border.ComboBox3.ItemIndex;
      //main.border_prop.cwall_towers_gen_chastokol:=border.CheckBox4.Checked;
      //main.border_prop.cwall_walls_gen_chastokol:=border.CheckBox6.Checked;
      main.border_prop.cwall_gen_interior:=border.CheckBox5.Checked;
      main.border_prop.cwall_gen_rails:=border.CheckBox2.Checked;
      main.border_prop.cwall_gen_boinici:=border.CheckBox7.Checked;
      main.border_prop.cwall_boinici_type:=border.ComboBox4.ItemIndex;
      main.border_prop.cwall_gen_gates:=border.CheckBox8.Checked;
      main.border_prop.cwall_gates_type:=border.ComboBox5.ItemIndex;
      main.border_prop.cwall_gen_void:=border.CheckBox9.Checked;
      main.border_prop.cwall_void_width:=strtoint(border.Edit4.text);

      str:=border.ComboBox2.Text;
      main.border_prop.wall_material:=getblockid(str);

      {case border.ComboBox2.ItemIndex of
      0:main.border_prop.wall_material:=1;
      1:main.border_prop.wall_material:=3;
      2:main.border_prop.wall_material:=4;
      3:main.border_prop.wall_material:=5;
      4:main.border_prop.wall_material:=7;
      5:main.border_prop.wall_material:=9;
      6:main.border_prop.wall_material:=11;
      7:main.border_prop.wall_material:=12;
      8:main.border_prop.wall_material:=24;
      9:main.border_prop.wall_material:=13;
      10:main.border_prop.wall_material:=20;
      11:main.border_prop.wall_material:=49;
      12:main.border_prop.wall_material:=79;
      13:main.border_prop.wall_material:=80;
      end; }
      ModalResult := mrOK;
    end;
  1:begin
      application.MessageBox('Wall thickness must be between 1 and 16','Error');
    end;
  2:begin
      application.MessageBox('Void thickness must be between 1 and 255','Error');
    end;
  3:begin
      application.MessageBox('Void thickness behind a castle wall must be between 1 and 255','Error');
    end
  else
    application.MessageBox('You have entered wrong number','Error');
  end;
end;

procedure TBorder.Button2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TBorder.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if not(((key>=#48) and (key<=#57))or (key=#8)) then key:=#0;
end;

procedure TBorder.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if not(((key>=#48) and (key<=#57))or (key=#8)) then key:=#0;
end;

procedure TBorder.ComboBox1Change(Sender: TObject);
begin
  case border.ComboBox1.ItemIndex of
  0:begin
      border.GroupBox1.Visible:=false;
      border.GroupBox2.Visible:=false;
      border.GroupBox3.Visible:=false;
      border.Image1.Canvas.Draw(0,0,border.Image2.Picture.Graphic);
    end;
  1:begin
      border.GroupBox1.Visible:=true;
      border.GroupBox2.Visible:=false;
      border.GroupBox3.Visible:=false;
      border.Image1.Canvas.Draw(0,0,border.Image3.Picture.Graphic);
    end;
  2:begin
      border.GroupBox1.Visible:=false;
      border.GroupBox2.Visible:=true;
      border.GroupBox3.Visible:=false;
      border.Image1.Canvas.Draw(0,0,border.Image4.Picture.Graphic);
    end;
  3:begin
      border.GroupBox1.Visible:=false;
      border.GroupBox2.Visible:=false;
      border.GroupBox3.Visible:=true;
      border.Image1.Canvas.Draw(0,0,border.Image5.Picture.Graphic);
    end;
  end;

  if (border.ComboBox1.ItemIndex<>0)and(main.biosfer_prop.underwater=true) then
  begin
    main.biosfer_prop.underwater:=false;
    main.biosfer_prop.gen_skyholes:=false;
    application.MessageBox('You cannot use this type of border with BioSpheres underwater option.'+#13+#10+'BioSphere underwater option changed to default.','Notice');
  end;
end;

procedure TBorder.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
  if not(((key>=#48) and (key<=#57))or (key=#8)) then key:=#0;
end;

procedure TBorder.CheckBox1Click(Sender: TObject);
begin
  if border.CheckBox1.Checked then
  begin
    border.Label4.Enabled:=true;
    border.Edit3.Enabled:=true;
  end
  else
  begin
    border.Label4.Enabled:=false;
    border.Edit3.Enabled:=false;
  end;
end;

procedure TBorder.FormShow(Sender: TObject);
var str:string;
begin
  //peredacha parametrov
  border.ComboBox1.ItemIndex:=main.border_prop.border_type;
  border.Edit1.Text:=inttostr(main.border_prop.wall_thickness);
  border.CheckBox1.Checked:=main.border_prop.wall_void;
  border.Edit3.Text:=inttostr(main.border_prop.wall_void_thickness);
  border.Edit2.Text:=inttostr(main.border_prop.void_thickness);

  border.CheckBox3.Checked:=main.border_prop.cwall_gen_towers;
  border.ComboBox3.ItemIndex:=main.border_prop.cwall_towers_type;
  //border.CheckBox4.Checked:=main.border_prop.cwall_towers_gen_chastokol;
  //border.CheckBox6.Checked:=main.border_prop.cwall_walls_gen_chastokol;
  border.CheckBox5.Checked:=main.border_prop.cwall_gen_interior;
  border.CheckBox2.Checked:=main.border_prop.cwall_gen_rails;
  border.CheckBox7.Checked:=main.border_prop.cwall_gen_boinici;
  border.ComboBox4.ItemIndex:=main.border_prop.cwall_boinici_type;
  border.CheckBox8.Checked:=main.border_prop.cwall_gen_gates;
  border.ComboBox5.ItemIndex:=main.border_prop.cwall_gates_type;
  border.CheckBox9.Checked:=main.border_prop.cwall_gen_void;
  border.Edit4.Text:=inttostr(main.border_prop.cwall_void_width);

  border.CheckBox3Click(self);
  border.CheckBox7Click(self);
  border.CheckBox5Click(self);
  border.CheckBox8Click(self);
  border.CheckBox9Click(self);

  border.ComboBox1Change(self);

  str:=getblockname(main.border_prop.wall_material);
  border.ComboBox2.ItemIndex:=border.ComboBox2.Items.IndexOf(str);
  if border.ComboBox2.ItemIndex=-1 then border.ComboBox2.ItemIndex:=0;

  {case main.border_prop.wall_material of
  1:border.ComboBox2.ItemIndex:=0;
  3:border.ComboBox2.ItemIndex:=1;
  4:border.ComboBox2.ItemIndex:=2;
  5:border.ComboBox2.ItemIndex:=3;
  7:border.ComboBox2.ItemIndex:=4;
  9:border.ComboBox2.ItemIndex:=5;
  11:border.ComboBox2.ItemIndex:=6;
  12:border.ComboBox2.ItemIndex:=7;
  24:border.ComboBox2.ItemIndex:=8;
  13:border.ComboBox2.ItemIndex:=9;
  20:border.ComboBox2.ItemIndex:=10;
  49:border.ComboBox2.ItemIndex:=11;
  79:border.ComboBox2.ItemIndex:=12;
  80:border.ComboBox2.ItemIndex:=13;
  else
    border.ComboBox2.ItemIndex:=0;
  end;    }
end;

procedure TBorder.FormCreate(Sender: TObject);
begin
  border.Image1.Canvas.Draw(0,0,border.Image2.Picture.Graphic);
end;

procedure TBorder.Edit4KeyPress(Sender: TObject; var Key: Char);
begin
  if not(((key>=#48) and (key<=#57))or (key=#8)) then key:=#0;
end;

procedure TBorder.CheckBox3Click(Sender: TObject);
begin
  if border.CheckBox3.Checked then
  begin
    border.Label7.Enabled:=true;
    border.ComboBox3.Enabled:=true;
    border.CheckBox2.Enabled:=true;
  end
  else
  begin
    border.Label7.Enabled:=false;
    border.ComboBox3.Enabled:=false;
    border.CheckBox2.Checked:=false;
    border.CheckBox2.Enabled:=false;
  end;
end;

procedure TBorder.CheckBox7Click(Sender: TObject);
begin
  if border.CheckBox7.Checked then
  begin
    border.Label8.Enabled:=true;
    border.ComboBox4.Enabled:=true;
  end
  else
  begin
    border.Label8.Enabled:=false;
    border.ComboBox4.Enabled:=false;
  end;
end;

procedure TBorder.CheckBox8Click(Sender: TObject);
begin
  if border.CheckBox8.Checked then
  begin
    border.Label9.Enabled:=true;
    border.ComboBox5.Enabled:=true;
  end
  else
  begin
    border.Label9.Enabled:=false;
    border.ComboBox5.Enabled:=false;
  end;
end;

procedure TBorder.CheckBox9Click(Sender: TObject);
begin
  if border.CheckBox9.Checked then
  begin
    border.Label6.Enabled:=true;
    border.Edit4.Enabled:=true;
  end
  else
  begin
    border.Label6.Enabled:=false;
    border.Edit4.Enabled:=false;
  end;
end;

procedure TBorder.CheckBox5Click(Sender: TObject);
begin
  if border.CheckBox5.Checked then
  begin
    border.CheckBox7.Enabled:=true;
    border.CheckBox7Click(self);
    //border.Label8.Enabled:=true;
    //border.ComboBox4.Enabled:=true;
  end
  else
  begin
    border.CheckBox7.Enabled:=false;
    //border.CheckBox7Click(self);
    border.Label8.Enabled:=false;
    border.ComboBox4.Enabled:=false;
  end;
end;

end.

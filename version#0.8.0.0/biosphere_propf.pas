unit biosphere_propf;

interface

uses
  SysUtils, Forms, Classes, Controls, StdCtrls;

type
  Tbiosf = class(TForm)
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Label2: TLabel;
    ComboBox2: TComboBox;
    GroupBox3: TGroupBox;
    Label3: TLabel;
    ComboBox3: TComboBox;
    Label4: TLabel;
    Label5: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    CheckBox4: TCheckBox;
    GroupBox4: TGroupBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  biosf: Tbiosf;
  gen_br,gen_el:boolean;
  sf_dist:integer;

implementation

uses mainf, generation_obsh;

{$R *.dfm}


function proverka_biosphere:integer;
var i:integer;
begin
  result:=-1;
  try
  i:=strtoint(biosf.Edit1.Text);
  if (i<4)or(i>10) then
  begin
    result:=1;
    exit;
  end;
  if (i and 1)=1 then
  begin
    result:=3;
    exit;
  end;
  i:=strtoint(biosf.Edit2.Text);
  if (i<20)or(i>300) then
  begin
    result:=2;
    exit;
  end;

  if (biosf.CheckBox5.Checked=false)and
  (biosf.CheckBox6.Checked=false)and
  (biosf.CheckBox7.Checked=false)and
  (biosf.CheckBox8.Checked=false)and
  (biosf.CheckBox9.Checked=false)and
  (biosf.CheckBox10.Checked=false)and
  (biosf.CheckBox11.Checked=false)and
  (biosf.CheckBox12.Checked=false) then
  begin
    result:=4;
    exit;
  end;

  except
    on E: Exception do
    begin
      result:=-1;
      exit;
    end;
  end;
  result:=0;
end;

procedure Tbiosf.Button1Click(Sender: TObject);
var str:string;
begin
  case proverka_biosphere of
  0:begin
      main.biosfer_prop.original_gen:=biosf.CheckBox1.Checked;
      main.biosfer_prop.underwater:=biosf.CheckBox2.Checked;
      main.biosfer_prop.gen_skyholes:=biosf.CheckBox14.Checked;
      main.biosfer_prop.gen_noise:=biosf.CheckBox3.Checked;
      main.biosfer_prop.gen_bridges:=biosf.CheckBox4.Checked;

      main.biosfer_prop.sphere_ellipse:=biosf.CheckBox13.Checked;
      main.biosfer_prop.biomes.forest:=biosf.CheckBox5.Checked;
      main.biosfer_prop.biomes.rainforest:=biosf.CheckBox6.Checked;
      main.biosfer_prop.biomes.desert:=biosf.CheckBox7.Checked;
      main.biosfer_prop.biomes.plains:=biosf.CheckBox8.Checked;
      main.biosfer_prop.biomes.taiga:=biosf.CheckBox9.Checked;
      main.biosfer_prop.biomes.ice_desert:=biosf.CheckBox10.Checked;
      main.biosfer_prop.biomes.tundra:=biosf.CheckBox11.Checked;
      main.biosfer_prop.biomes.hell:=biosf.CheckBox12.Checked;

      main.biosfer_prop.bridge_width:=strtoint(biosf.Edit1.Text);
      main.biosfer_prop.sphere_distance:=strtoint(biosf.Edit2.Text);

      str:=biosf.ComboBox1.Text;
      main.biosfer_prop.bridge_material:=getblockid(str);
      str:=biosf.ComboBox2.Text;
      main.biosfer_prop.bridge_rail_material:=getblockid(str);
      str:=biosf.ComboBox3.Text;
      main.biosfer_prop.sphere_material:=getblockid(str);

      modalresult:=mrOK;
    end;
  1:begin
      application.MessageBox('Bridge width must be between 4 and 10','Error');
    end;
  2:begin
      application.MessageBox('Distance must be between 20 and 300','Error');
    end;
  3:begin
      application.MessageBox('Bridge width must be even number','Error');
    end;
  4:begin
      application.MessageBox('You must choose to generate at least one of the biomes','Error');
    end
  else
    begin
      application.MessageBox('Unknown error','Error');
    end;
  end;
end;

procedure Tbiosf.Button2Click(Sender: TObject);
begin
  modalresult:=mrCancel;
end;

procedure Tbiosf.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if not(((key>=#48) and (key<=#57))or (key=#8)) then key:=#0;
end;

procedure Tbiosf.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if not(((key>=#48) and (key<=#57))or (key=#8)) then key:=#0;
end;

procedure Tbiosf.FormShow(Sender: TObject);
var str:string;
begin
  biosf.CheckBox1.Checked:=main.biosfer_prop.original_gen;
  biosf.CheckBox2.Checked:=main.biosfer_prop.underwater;
  biosf.CheckBox14.Checked:=main.biosfer_prop.gen_skyholes;
  biosf.CheckBox3.Checked:=main.biosfer_prop.gen_noise;
  biosf.CheckBox4.Checked:=main.biosfer_prop.gen_bridges;

  str:=GetBlockName(main.biosfer_prop.bridge_material);  
  biosf.ComboBox1.ItemIndex:=biosf.ComboBox1.Items.IndexOf(str);
  if biosf.ComboBox1.ItemIndex=-1 then biosf.ComboBox1.ItemIndex:=0;

  str:=GetBlockName(main.biosfer_prop.bridge_rail_material);
  biosf.ComboBox2.ItemIndex:=biosf.ComboBox2.Items.IndexOf(str);
  if biosf.ComboBox2.ItemIndex=-1 then biosf.ComboBox2.ItemIndex:=0;

  str:=GetBlockName(main.biosfer_prop.sphere_material);
  biosf.ComboBox3.ItemIndex:=biosf.ComboBox3.Items.IndexOf(str);
  if biosf.ComboBox3.ItemIndex=-1 then biosf.ComboBox3.ItemIndex:=0;

  biosf.Edit1.Text:=inttostr(main.biosfer_prop.bridge_width);
  biosf.Edit2.Text:=inttostr(main.biosfer_prop.sphere_distance);
  biosf.CheckBox13.Checked:=main.biosfer_prop.sphere_ellipse;

  biosf.CheckBox5.Checked:=main.biosfer_prop.biomes.forest;
  biosf.CheckBox6.Checked:=main.biosfer_prop.biomes.rainforest;
  biosf.CheckBox7.Checked:=main.biosfer_prop.biomes.desert;
  biosf.CheckBox8.Checked:=main.biosfer_prop.biomes.plains;
  biosf.CheckBox9.Checked:=main.biosfer_prop.biomes.taiga;
  biosf.CheckBox10.Checked:=main.biosfer_prop.biomes.ice_desert;
  biosf.CheckBox11.Checked:=main.biosfer_prop.biomes.tundra;
  biosf.CheckBox12.Checked:=main.biosfer_prop.biomes.hell;

  biosf.CheckBox1Click(self);
  biosf.CheckBox2Click(self);
end;

procedure Tbiosf.CheckBox1Click(Sender: TObject);
begin
  if biosf.CheckBox1.Checked then
  begin
    gen_br:=biosf.CheckBox4.checked;
    gen_el:=biosf.CheckBox13.checked;
    sf_dist:=strtoint(biosf.Edit2.Text);

    biosf.CheckBox4.Checked:=true;
    biosf.CheckBox4.Enabled:=false;
    biosf.Label4.Enabled:=false;
    biosf.Edit2.Text:='150';
    biosf.Edit2.Enabled:=false;
    biosf.CheckBox13.Checked:=false;
    biosf.CheckBox13.Enabled:=false;
  end
  else
  begin
    biosf.CheckBox4.Enabled:=true;
    biosf.Label4.Enabled:=true;
    biosf.Edit2.Enabled:=true;
    biosf.CheckBox13.Enabled:=true;

    biosf.CheckBox4.Checked:=gen_br;
    biosf.Edit2.Text:=inttostr(sf_dist);
    biosf.CheckBox13.Checked:=gen_el;
  end;
end;

procedure Tbiosf.CheckBox2Click(Sender: TObject);
begin
  if biosf.CheckBox2.Checked then
  begin
    if main.border_prop.border_type<>0 then
    begin
      application.MessageBox('You cannot use this option with selected type of border','Error');
      biosf.CheckBox2.Checked:=false;
      exit;
    end;
    biosf.CheckBox14.Enabled:=true;
  end
  else
  begin
    biosf.CheckBox14.Enabled:=false;
    biosf.CheckBox14.Checked:=false;
  end;
end;

procedure Tbiosf.FormCreate(Sender: TObject);
begin
  gen_br:=true;
  gen_el:=false;
  sf_dist:=100;
end;

end.

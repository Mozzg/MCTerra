unit biomes_propf;

interface

uses Forms, StdCtrls, Classes, Controls, ExtCtrls;

type
  Tbiomes = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ComboBox1: TComboBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    GroupBox3: TGroupBox;
    RadioGroup1: TRadioGroup;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  biomes: Tbiomes;

implementation

{$R *.dfm}

procedure Tbiomes.Button1Click(Sender: TObject);
begin
  modalresult:=mrOK;
end;

procedure Tbiomes.Button2Click(Sender: TObject);
begin
  modalresult:=mrcancel;
end;

procedure Tbiomes.RadioGroup1Click(Sender: TObject);
begin
  if biomes.RadioGroup1.ItemIndex=0 then
  begin
    biomes.Label2.Enabled:=false;
    biomes.Edit2.Enabled:=false;
    biomes.Label1.Enabled:=true;
    biomes.Edit1.Enabled:=true;
  end
  else
  begin
    biomes.Label2.Enabled:=true;
    biomes.Edit2.Enabled:=true;
    biomes.Label1.Enabled:=false;
    biomes.Edit1.Enabled:=false;
  end;
end;

procedure Tbiomes.FormShow(Sender: TObject);
begin
  biomes.RadioGroup1Click(self);
end;

end.

unit tunnels_propf;

interface

uses
  SysUtils, Forms, StdCtrls, ExtCtrls, Classes, Controls;

type
  Ttunnels = class(TForm)
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label5: TLabel;
    Edit5: TEdit;
    GroupBox2: TGroupBox;
    Label6: TLabel;
    Edit6: TEdit;
    Label7: TLabel;
    ListBox1: TListBox;
    CheckBox2: TCheckBox;
    GroupBox3: TGroupBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    Label8: TLabel;
    Edit7: TEdit;
    Label9: TLabel;
    Edit8: TEdit;
    CheckBox6: TCheckBox;
    ComboBox1: TComboBox;
    Label10: TLabel;
    Bevel1: TBevel;
    CheckBox7: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
    procedure Edit5KeyPress(Sender: TObject; var Key: Char);
    procedure Edit6KeyPress(Sender: TObject; var Key: Char);
    procedure Edit7KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure Edit8KeyPress(Sender: TObject; var Key: Char);
    procedure CheckBox6Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  tunnels: Ttunnels;

implementation

uses mainf;

{$R *.dfm}

function proverka_tun:integer;
var i:integer;
begin
  result:=-1;
  try
    i:=strtoint(tunnels.Edit1.Text);
    if (i<5)or(i>30) then
    begin
      result:=1;
      exit;
    end;
    i:=strtoint(tunnels.Edit2.Text);
    if (i<5)or(i>30) then
    begin
      result:=1;
      exit;
    end;
    i:=strtoint(tunnels.Edit3.Text);
    if (i<5)or(i>30) then
    begin
      result:=1;
      exit;
    end;
    i:=strtoint(tunnels.Edit4.Text);
    if (i<5)or(i>30) then
    begin
      result:=1;
      exit;
    end;
    i:=strtoint(tunnels.Edit5.Text);
    if (i<5)or(i>95) then
    begin
      result:=2;
      exit;
    end;
    i:=strtoint(tunnels.Edit6.Text);
    if (i<5)or(i>95) then
    begin
      result:=3;
      exit;
    end;
    i:=strtoint(tunnels.Edit7.Text);
    if (i<5)or(i>95) then
    begin
      result:=4;
      exit;
    end;
    i:=strtoint(tunnels.Edit8.Text);
    if (i<5)or(i>200) then
    begin
      result:=5;
      exit;
    end;

    if (tunnels.CheckBox2.Checked=false)and(tunnels.CheckBox6.Checked=false) then
    begin
      result:=6;
      exit;
    end;
  except
    on E:exception do
      exit;
  end;
  result:=0;
end;

procedure Ttunnels.Button1Click(Sender: TObject);
var i,j:integer;
begin
  case proverka_tun of
  0:begin
      main.tunnel_prop.round_tun:=tunnels.CheckBox1.Checked;
      main.tunnel_prop.r_hor_min:=strtoint(tunnels.Edit1.Text);
      main.tunnel_prop.r_hor_max:=strtoint(tunnels.Edit3.Text);
      main.tunnel_prop.r_vert_min:=strtoint(tunnels.Edit2.Text);
      main.tunnel_prop.r_vert_max:=strtoint(tunnels.Edit4.Text);
      main.tunnel_prop.round_tun_density:=strtoint(tunnels.Edit5.Text);
      main.tunnel_prop.light_density:=strtoint(tunnels.Edit6.Text);
      main.tunnel_prop.tun_density:=strtoint(tunnels.Edit7.Text);
      main.tunnel_prop.skyholes_density:=strtoint(tunnels.Edit8.Text);
      main.tunnel_prop.gen_sun_holes:=tunnels.CheckBox2.Checked;
      main.tunnel_prop.gen_hub:=tunnels.CheckBox3.Checked;
      main.tunnel_prop.gen_seperate:=tunnels.CheckBox4.Checked;
      main.tunnel_prop.gen_flooded:=tunnels.CheckBox5.Checked;
      main.tunnel_prop.gen_lights:=tunnels.CheckBox6.Checked;
      main.tunnel_prop.light_blocks_type:=tunnels.ComboBox1.ItemIndex;
      main.tunnel_prop.gen_tall_grass:=tunnels.CheckBox7.Checked;

      setlength(main.tunnel_prop.light_blocks,tunnels.ListBox1.SelCount);
      j:=0;
      for i:=0 to tunnels.ListBox1.Items.Count-1 do
        if tunnels.ListBox1.Selected[i]=true then
        begin
          case i of
            0:main.tunnel_prop.light_blocks[j]:=89;
            1:main.tunnel_prop.light_blocks[j]:=11;
            2:main.tunnel_prop.light_blocks[j]:=91;
            3:main.tunnel_prop.light_blocks[j]:=87;
            4:main.tunnel_prop.light_blocks[j]:=50;
            5:main.tunnel_prop.light_blocks[j]:=74;
          end;
        inc(j);
        end;
      modalresult:=mrOK;
    end;
  1:begin
      application.MessageBox('Tunnel radius mus be between 5 and 30','Error');
    end;
  2:begin
      application.MessageBox('Percent of round tunnels must be between 5 and 95','Error');
    end;
  3:begin
      application.MessageBox('Lightsource density must be between 5 and 95','Error');
    end;
  4:begin
      application.MessageBox('Tunnel density must be between 5 and 95','Error');
    end;
  5:begin
      application.MessageBox('Skyholes density must be between 5 and 200','Error');
    end;
  6:begin
      application.MessageBox('You must use the generation of light sourse or skyholes,'+#13+#10+'or the tunnels will be pitch black.','Error');
    end
  else
    begin
      application.MessageBox('You have entered wrong number','Error');
    end;
  end;


end;

procedure Ttunnels.Button2Click(Sender: TObject);
begin
  modalresult:=mrcancel;
end;

procedure Ttunnels.FormCreate(Sender: TObject);
begin
  tunnels.ListBox1.Selected[0]:=true;
end;

procedure Ttunnels.FormShow(Sender: TObject);
var i:integer;
begin
  tunnels.CheckBox1.Checked:=main.tunnel_prop.round_tun;
  tunnels.CheckBox3.Checked:=main.tunnel_prop.gen_hub;
  tunnels.CheckBox4.Checked:=main.tunnel_prop.gen_seperate;
  tunnels.CheckBox5.Checked:=main.tunnel_prop.gen_flooded;
  tunnels.CheckBox7.Checked:=main.tunnel_prop.gen_tall_grass;
  tunnels.Edit1.Text:=inttostr(main.tunnel_prop.r_hor_min);
  tunnels.Edit3.Text:=inttostr(main.tunnel_prop.r_hor_max);
  tunnels.Edit2.Text:=inttostr(main.tunnel_prop.r_vert_min);
  tunnels.Edit4.Text:=inttostr(main.tunnel_prop.r_vert_max);
  tunnels.Edit5.Text:=inttostr(main.tunnel_prop.round_tun_density);
  tunnels.Edit6.Text:=inttostr(main.tunnel_prop.light_density);
  tunnels.Edit7.Text:=inttostr(main.tunnel_prop.tun_density);
  tunnels.Edit8.Text:=inttostr(main.tunnel_prop.skyholes_density);
  tunnels.ComboBox1.ItemIndex:=main.tunnel_prop.light_blocks_type;

  //chekboksi
  tunnels.CheckBox6.Checked:=main.tunnel_prop.gen_lights;
  tunnels.CheckBox2.Checked:=main.tunnel_prop.gen_sun_holes;

  tunnels.CheckBox6Click(self);
  tunnels.CheckBox2Click(self);

  //round tunnels
  if tunnels.CheckBox1.Checked then
  begin
    tunnels.Label2.Enabled:=false;
    tunnels.Label5.Enabled:=false;
    tunnels.Edit2.Text:=tunnels.Edit1.Text;
    tunnels.Edit4.Text:=tunnels.Edit3.Text;
    tunnels.Edit2.Enabled:=false;
    tunnels.Edit4.Enabled:=false;
    tunnels.Edit5.Enabled:=false;
  end
  else
  begin
    tunnels.Label2.Enabled:=true;
    tunnels.Label5.Enabled:=true;
    tunnels.Edit2.Enabled:=true;
    tunnels.Edit4.Enabled:=true;
    tunnels.Edit5.Enabled:=true;
  end;

  for i:=0 to tunnels.ListBox1.Items.Count-1 do
    tunnels.ListBox1.Selected[i]:=false;

  //spisok
  for i:=0 to length(main.tunnel_prop.light_blocks)-1 do
    case main.tunnel_prop.light_blocks[i] of
    89:tunnels.ListBox1.Selected[0]:=true;
    11:tunnels.ListBox1.Selected[1]:=true;
    91:tunnels.ListBox1.Selected[2]:=true;
    87:tunnels.ListBox1.Selected[3]:=true;
    50:tunnels.ListBox1.Selected[4]:=true;
    74:tunnels.ListBox1.Selected[5]:=true;
    end;
end;

procedure Ttunnels.CheckBox1Click(Sender: TObject);
begin
  if tunnels.CheckBox1.Checked then
  begin
    tunnels.Label2.Enabled:=false;
    tunnels.Label5.Enabled:=false;
    tunnels.Edit2.Text:=tunnels.Edit1.Text;
    tunnels.Edit4.Text:=tunnels.Edit3.Text;
    tunnels.Edit2.Enabled:=false;
    tunnels.Edit4.Enabled:=false;
    tunnels.Edit5.Enabled:=false;
  end
  else
  begin
    tunnels.Label2.Enabled:=true;
    tunnels.Label5.Enabled:=true;
    tunnels.Edit2.Enabled:=true;
    tunnels.Edit4.Enabled:=true;
    tunnels.Edit5.Enabled:=true;
  end;
end;

procedure Ttunnels.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if not(((key>=#48) and (key<=#57))or (key=#8)) then key:=#0;
end;

procedure Ttunnels.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
  if not(((key>=#48) and (key<=#57))or (key=#8)) then key:=#0;
end;

procedure Ttunnels.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if not(((key>=#48) and (key<=#57))or (key=#8)) then key:=#0;
end;

procedure Ttunnels.Edit4KeyPress(Sender: TObject; var Key: Char);
begin
  if not(((key>=#48) and (key<=#57))or (key=#8)) then key:=#0;
end;

procedure Ttunnels.Edit5KeyPress(Sender: TObject; var Key: Char);
begin
  if not(((key>=#48) and (key<=#57))or (key=#8)) then key:=#0;
end;

procedure Ttunnels.Edit6KeyPress(Sender: TObject; var Key: Char);
begin
  if not(((key>=#48) and (key<=#57))or (key=#8)) then key:=#0;
end;

procedure Ttunnels.Edit7KeyPress(Sender: TObject; var Key: Char);
begin
  if not(((key>=#48) and (key<=#57))or (key=#8)) then key:=#0;
end;

procedure Ttunnels.Edit1Change(Sender: TObject);
begin
  if tunnels.CheckBox1.Checked then
    tunnels.edit2.Text:=tunnels.edit1.Text;
end;

procedure Ttunnels.Edit3Change(Sender: TObject);
begin
  if tunnels.CheckBox1.Checked then
    tunnels.edit4.Text:=tunnels.edit3.Text;
end;

procedure Ttunnels.Edit8KeyPress(Sender: TObject; var Key: Char);
begin
  if not(((key>=#48) and (key<=#57))or (key=#8)) then key:=#0;
end;

procedure Ttunnels.CheckBox6Click(Sender: TObject);
begin
  if tunnels.CheckBox6.Checked then
  begin
    tunnels.Label6.Enabled:=true;
    tunnels.Edit6.Enabled:=true;
    {tunnels.Label7.Enabled:=true;
    tunnels.Label10.Enabled:=true;
    tunnels.ComboBox1.Enabled:=true;
    tunnels.ListBox1.Enabled:=true;  }
  end
  else
  begin
    tunnels.Label6.Enabled:=false;
    tunnels.Edit6.Enabled:=false;
    {tunnels.Label7.Enabled:=false;
    tunnels.Label10.Enabled:=false;
    tunnels.ComboBox1.Enabled:=false;
    tunnels.ListBox1.Enabled:=false; }
  end;
end;

procedure Ttunnels.CheckBox2Click(Sender: TObject);
begin
  if tunnels.CheckBox2.Checked then
  begin
    tunnels.Label9.Enabled:=true;
    tunnels.Edit8.Enabled:=true;
  end
  else
  begin
    tunnels.Label9.Enabled:=false;
    tunnels.Edit8.Enabled:=false;
  end;
end;

end.

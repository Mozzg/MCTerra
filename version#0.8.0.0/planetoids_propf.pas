unit planetoids_propf;

interface

uses
  SysUtils, Forms, Classes, Controls, StdCtrls;

type
  Tplanet = class(TForm)
    Label1: TLabel;
    ComboBox1: TComboBox;
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Label5: TLabel;
    Edit4: TEdit;
    Button1: TButton;
    Button2: TButton;
    Label6: TLabel;
    Edit5: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label7: TLabel;
    ComboBox2: TComboBox;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  planet: Tplanet;

implementation

uses mainf;

{$R *.dfm}   

procedure Tplanet.Button2Click(Sender: TObject);
begin
  modalresult:=mrcancel;
end;

procedure Tplanet.Button1Click(Sender: TObject);
begin
  if strtoint(planet.Edit5.text)>64 then
  begin
    application.MessageBox('Ground level must be between 0 and 64','Error');
    exit;
  end;

  if (strtoint(planet.Edit5.text)<0)and(planet.ComboBox1.ItemIndex<>0) then
  begin
    application.MessageBox('Ground level must be between 0 and 64 in that type of map','Error');
    exit;
  end;

  main.planet_prop.map_type:=planet.ComboBox1.ItemIndex;
  main.planet_prop.planets_type:=planet.ComboBox2.ItemIndex;
  main.planet_prop.min:=strtoint(planet.Edit2.Text);
  main.planet_prop.max:=strtoint(planet.Edit3.Text);
  main.planet_prop.distance:=strtoint(planet.Edit1.Text);
  main.planet_prop.density:=strtoint(planet.Edit4.Text);
  main.planet_prop.groundlevel:=strtoint(planet.Edit5.text);

  if (main.planet_prop.map_type=0)and(main.planet_prop.groundlevel<>0)then
  begin
    main.planet_prop.groundlevel:=0;
    //application.MessageBox('Ground level changed to 0 due to map type','Notice');
  end;

  if main.planet_prop.density<5 then
  begin
    main.planet_prop.density:=5;
    application.MessageBox('Planet density changed to minimum (5%)','Notice');
  end
  else if main.planet_prop.density>95 then
  begin
    main.planet_prop.density:=95;
    application.MessageBox('Planet density changed to maximum (95%)','Notice');
  end;

  if main.planet_prop.min<5 then
  begin
    main.planet_prop.min:=5;
    application.MessageBox('Minimum planet radius must be larger, than 5.'+#10+#13+'Changed to minimum (5).','Notice');
  end;

  if main.planet_prop.max*2>(128-main.planet_prop.groundlevel+3-main.planet_prop.distance*2) then
  begin
    main.planet_prop.max:=((128-main.planet_prop.groundlevel+3-main.planet_prop.distance*2)-5)div 2;
    application.MessageBox(pchar('Maximum planet radius is too big for this settings.'+#13+#10+'Maximum planet radius changed to '+inttostr(main.planet_prop.max)+'.'),'Notice')
  end;

  if main.planet_prop.min*2>(128-main.planet_prop.groundlevel+3-main.planet_prop.distance*2) then
  begin
    main.planet_prop.min:=((128-main.planet_prop.groundlevel+3-main.planet_prop.distance*2)-5)div 2;
    application.MessageBox(pchar('Minimum planet radius is too big for this settings.'+#13+#10+'Minimum planet radius changed to '+inttostr(main.planet_prop.min)+'.'),'Notice')
  end;

  if main.planet_prop.min>main.planet_prop.max then
  begin
    main.planet_prop.max:=main.planet_prop.min;
    application.MessageBox(pchar('Maximum planet radius cannot be less, than minimum, changed to minimum ('+inttostr(main.planet_prop.min)+')'),'Notice');
  end;

  if main.planet_prop.distance<4 then
  begin
    main.planet_prop.distance:=4;
    application.MessageBox('Minimum planet distance must be larger, than 4.'+#10+#13+'Changed to minimum (4).','Notice');
  end;

  modalresult:=mrok;
end;

procedure Tplanet.FormShow(Sender: TObject);
begin
  planet.ComboBox1.ItemIndex:=main.planet_prop.map_type;
  planet.ComboBox2.ItemIndex:=main.planet_prop.planets_type;
  planet.Edit1.Text:=inttostr(main.planet_prop.distance);
  planet.Edit2.Text:=inttostr(main.planet_prop.min);
  planet.Edit3.Text:=inttostr(main.planet_prop.max);
  planet.Edit4.Text:=inttostr(main.planet_prop.density);
  planet.Edit5.Text:=inttostr(main.planet_prop.groundlevel);
  planet.ComboBox1Change(self);
end;

procedure Tplanet.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if not(((key>=#48) and (key<=#57))or (key=#8)) then key:=#0;
end;

procedure Tplanet.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if not(((key>=#48) and (key<=#57))or (key=#8)) then key:=#0;
end;

procedure Tplanet.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
  if not(((key>=#48) and (key<=#57))or (key=#8)) then key:=#0;
end;

procedure Tplanet.Edit4KeyPress(Sender: TObject; var Key: Char);
begin
  if not(((key>=#48) and (key<=#57))or (key=#8)) then key:=#0;
end;

procedure Tplanet.ComboBox1Change(Sender: TObject);
begin
  if planet.ComboBox1.ItemIndex=0 then
  begin
    planet.Label6.Visible:=false;
    planet.Edit5.Visible:=false;
  end
  else
  begin
    planet.Label6.Visible:=true;
    planet.Edit5.Visible:=true;
  end;
end;

end.

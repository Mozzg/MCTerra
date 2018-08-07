unit playerf;

interface

uses
  Forms, Controls, StdCtrls, Classes, sysutils;

type
  Tplayer = class(TForm)
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Edit3: TEdit;
    Button3: TButton;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    CheckBox1: TCheckBox;
    Label4: TLabel;
    Edit4: TEdit;
    Label5: TLabel;
    Edit5: TEdit;
    Label6: TLabel;
    Edit6: TEdit;
    Label7: TLabel;
    Edit7: TEdit;
    Label8: TLabel;
    Edit8: TEdit;
    Label9: TLabel;
    Edit9: TEdit;
    GroupBox5: TGroupBox;
    Label10: TLabel;
    GroupBox6: TGroupBox;
    Edit10: TEdit;
    Label11: TLabel;
    Edit11: TEdit;
    Label12: TLabel;
    Edit12: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
    procedure Edit5KeyPress(Sender: TObject; var Key: Char);
    procedure Edit6KeyPress(Sender: TObject; var Key: Char);
    procedure Edit7KeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit10KeyPress(Sender: TObject; var Key: Char);
    procedure Edit8KeyPress(Sender: TObject; var Key: Char);
    procedure Edit8Exit(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Edit11KeyPress(Sender: TObject; var Key: Char);
    procedure Edit12KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure Edit3Exit(Sender: TObject);
    procedure Edit7Exit(Sender: TObject);
    procedure Edit10Exit(Sender: TObject);
    procedure Edit11Exit(Sender: TObject);
    procedure Edit12Exit(Sender: TObject);
    procedure Edit4Exit(Sender: TObject);
    procedure Edit5Exit(Sender: TObject);
    procedure Edit6Exit(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure Edit6Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  player: Tplayer;

implementation

uses mainf;

{$R *.dfm}

function count_score(level:integer; xp:double):integer;
begin
  result:=level*64+round(xp*0.64); 
end;

function proverka_player:integer;
var i:integer;
d:extended;
begin
  result:=-1;
  try
    i:=strtoint(player.Edit1.Text);
    if (i<0)or(i>100) then
    begin
      result:=1;
      exit;
    end;
    d:=strtofloat(player.Edit2.text);
    if (d<0)or(d>=100) then
    begin
      result:=2;
      exit;
    end;
    i:=strtoint(player.Edit3.Text);
    if (i<0)or(i>1000000) then
    begin
      result:=3;
      exit;
    end;
    d:=strtofloat(player.Edit4.text);
    d:=strtofloat(player.Edit5.text);
    if(d<1)or(d>127) then
    begin
      result:=5;
      exit;
    end;
    d:=strtofloat(player.Edit6.text);

    i:=strtoint(player.Edit7.Text);
    if (i<0)or(i>20) then
    begin
      result:=4;
      exit;
    end;

    i:=strtoint(player.Edit10.Text);
    if (i<0)or(i>20) then
    begin
      result:=6;
      exit;
    end;

    d:=strtofloat(player.Edit11.text);
    if (d<-360)or(d>360) then
    begin
      result:=7;
      exit;
    end;

    d:=strtofloat(player.Edit12.text);
    if (d<-90)or(d>90) then
    begin
      result:=8;
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

procedure Tplayer.Button1Click(Sender: TObject);
var d:extended;
i:integer;
b:boolean;
begin
  case proverka_player of
  0:begin
      i:=strtoint(player.Edit1.Text);
      main.level_settings.player.xplevel:=i;
      d:=strtofloat(player.Edit2.Text)*0.64;
      //main.level_settings.player.xp:=round(d);
      main.level_settings.player.xp:=strtofloat(player.Edit2.Text)/100;
      main.level_settings.player.totalxp:=i*64+round(d);

      main.level_settings.player.score:=strtoint(player.Edit3.Text);
      b:=player.CheckBox1.Checked;
      main.level_settings.player.overrite_pos:=b;
      if b=true then
      begin
        main.level_settings.player.pos[0]:=strtofloat(player.Edit4.Text);
        main.level_settings.player.pos[1]:=strtofloat(player.Edit5.Text);
        main.level_settings.player.pos[2]:=strtofloat(player.Edit6.Text);
      end;

      main.level_settings.player.food_level:=strtoint(player.Edit7.Text);
      main.level_settings.player.food_sat_level:=strtofloat(player.Edit8.Text);
      main.level_settings.player.food_ex_level:=strtofloat(player.Edit9.Text);

      main.level_settings.player.health:=strtoint(player.Edit10.Text);

      main.level_settings.player.rotation[0]:=strtofloat(player.Edit11.Text);
      main.level_settings.player.rotation[1]:=strtofloat(player.Edit12.Text);

      modalresult:=mrOK;
    end;
  1:begin
      application.MessageBox('Level must be between 0 and 100','Error');
    end;
  2:begin
      application.MessageBox('Experience must be between 0 and 100','Error');
    end;
  3:begin
      application.MessageBox('Score must be between 0 and 1000000','Error');
    end;
  4:begin
      application.MessageBox('Food level must be between 0 and 20','Error');
    end;
  5:begin
      application.MessageBox('Y position must be between 1 and 127','Error');
    end;
  6:begin
      application.MessageBox('Health level must be between 0 and 20','Error');
    end;
  7:begin
      application.MessageBox('Players Yaw must be between -360 and 360','Error');
    end;
  8:begin
      application.MessageBox('Players Pitch must be between -90 and 90','Error');
    end
  else
    begin
      application.MessageBox('Unknown error','Error');
    end;
  end;
end;

procedure Tplayer.Button2Click(Sender: TObject);
begin
  modalresult:=mrcancel;
end;

procedure Tplayer.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if not(((key>=#48) and (key<=#57))or (key=#8)) then key:=#0;
end;

procedure Tplayer.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if key=#46 then key:=#44;

  if (key=#44) then
    if pos(',',player.Edit2.Text)<>0 then
    begin
      key:=#0;
      exit;
    end;

  if not(((key>=#48) and (key<=#57))or (key=#8)or(key=#44)) then key:=#0;
end;

procedure Tplayer.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
  if not(((key>=#48) and (key<=#57))or (key=#8)) then key:=#0;
end;

procedure Tplayer.Edit4KeyPress(Sender: TObject; var Key: Char);
begin
  if key=#45 then
    if player.Edit4.SelStart<>0 then
    begin
      key:=#0;
      exit;
    end;

  if not(((key>=#48) and (key<=#57))or (key=#8)or(key=#45)) then key:=#0;
end;

procedure Tplayer.Edit5KeyPress(Sender: TObject; var Key: Char);
begin
  if not(((key>=#48) and (key<=#57))or (key=#8)) then key:=#0;
end;

procedure Tplayer.Edit6KeyPress(Sender: TObject; var Key: Char);
begin
  if key=#45 then
    if player.Edit6.SelStart<>0 then
    begin
      key:=#0;
      exit;
    end;

  if not(((key>=#48) and (key<=#57))or (key=#8)or(key=#45)) then key:=#0;
end;

procedure Tplayer.Edit7KeyPress(Sender: TObject; var Key: Char);
begin
  if not(((key>=#48) and (key<=#57))or (key=#8)) then key:=#0;
end;

procedure Tplayer.FormShow(Sender: TObject);
var i:integer;
d:double;
begin
  player.Edit1.Text:=inttostr(main.level_settings.player.xplevel);
  i:=main.level_settings.player.xplevel*64;
  i:=main.level_settings.player.totalxp-i;
  d:=(i/64)*100;
  //player.Edit2.Text:=floattostr(d);
  player.Edit2.Text:=floattostr(main.level_settings.player.xp*100);

  player.Edit3.Text:=inttostr(main.level_settings.player.score);
  player.CheckBox1.Checked:=main.level_settings.player.overrite_pos;
  player.Edit4.Text:=floattostr(main.level_settings.player.pos[0]);
  player.Edit5.Text:=floattostr(main.level_settings.player.pos[1]);
  player.Edit6.Text:=floattostr(main.level_settings.player.pos[2]);

  player.Edit7.Text:=inttostr(main.level_settings.player.food_level);
  player.Edit8.Text:=floattostr(main.level_settings.player.food_ex_level);
  player.Edit9.Text:=floattostr(main.level_settings.player.food_sat_level);

  player.Edit10.Text:=inttostr(main.level_settings.player.health);

  player.Edit11.Text:=floattostr(main.level_settings.player.rotation[0]);
  player.Edit12.Text:=floattostr(main.level_settings.player.rotation[1]);

  player.CheckBox1Click(player);
end;

procedure Tplayer.CheckBox1Click(Sender: TObject);
begin
  if player.CheckBox1.Checked then
  begin
    player.Edit4.Enabled:=true;
    player.Edit5.Enabled:=true;
    player.Edit6.Enabled:=true;
    player.Label4.Enabled:=true;
    player.Label5.Enabled:=true;
    player.Label6.Enabled:=true;
  end
  else
  begin
    player.Edit4.Enabled:=false;
    player.Edit5.Enabled:=false;
    player.Edit6.Enabled:=false;
    player.Label4.Enabled:=false;
    player.Label5.Enabled:=false;
    player.Label6.Enabled:=false;
  end;
end;

procedure Tplayer.Edit1Change(Sender: TObject);
var i:integer;
begin
  if length(player.Edit1.Text)=0 then exit;
  i:=proverka_player;

  if (i<>1)and(i<>2) then
    if i=-1 then
      player.Edit3.Text:=inttostr(count_score(0,strtofloat(player.Edit2.Text)))
    else
      player.Edit3.Text:=inttostr(count_score(strtoint(player.Edit1.Text),strtofloat(player.Edit2.Text)));
end;

procedure Tplayer.Edit2Change(Sender: TObject);
var i:integer;
begin
  if length(player.Edit2.Text)=0 then exit;
  i:=proverka_player;

  if (i<>1)and(i<>2) then
    if i=-1 then
      player.Edit3.Text:=inttostr(count_score(strtoint(player.Edit1.Text),0))
    else
      player.Edit3.Text:=inttostr(count_score(strtoint(player.Edit1.Text),strtofloat(player.Edit2.Text)));
end;

procedure Tplayer.Edit10KeyPress(Sender: TObject; var Key: Char);
begin
  if not(((key>=#48) and (key<=#57))or (key=#8)) then key:=#0;
end;

procedure Tplayer.Edit8KeyPress(Sender: TObject; var Key: Char);
var i,j:integer;
begin
  if not(((key>=#48) and (key<=#57))or (key=#8)or(key=#44)or(key=#46)) then
  begin
    key:=#0;
    exit;
  end;   

  i:=pos('.',player.Edit8.Text);
  j:=pos(',',player.Edit8.Text);

  if ((i<>0)or(j<>0))and((key=#44)or(key=#46)) then
  begin
    key:=#0;
    exit;
  end;   
end;

procedure Tplayer.Edit8Exit(Sender: TObject);
var str:string;
i:integer;
begin
  str:=player.Edit8.Text;
  i:=pos(',',str);
  if i<>0 then
  begin
    str[i]:='.';
    player.Edit8.Text:=str;
  end;
end;

procedure Tplayer.Button3Click(Sender: TObject);
begin
  application.MessageBox('Not ready yet','Notice');
end;

procedure Tplayer.Edit11KeyPress(Sender: TObject; var Key: Char);
begin
  //application.MessageBox(pchar(inttostr(ord(key))),'');

  if key=#46 then key:=#44;

  if (key=#44) then
    if pos(',',player.Edit11.Text)<>0 then
    begin
      key:=#0;
      exit;
    end;

  if key=#45 then
    if player.Edit11.SelStart<>0 then
    begin
      key:=#0;
      exit;
    end;

  if not(((key>=#48) and (key<=#57))or (key=#8)or(key=#44)or(key=#45)) then key:=#0;
end;

procedure Tplayer.Edit12KeyPress(Sender: TObject; var Key: Char);
begin
  if key=#46 then key:=#44;

  if (key=#44) then
    if pos(',',player.Edit12.Text)<>0 then
    begin
      key:=#0;
      exit;
    end;

  if key=#45 then
    if player.Edit11.SelStart<>0 then
    begin
      key:=#0;
      exit;
    end;

  if not(((key>=#48) and (key<=#57))or (key=#8)or(key=#44)or(key=#45)) then key:=#0;
end;

procedure Tplayer.Edit1Exit(Sender: TObject);
begin
  if length(player.Edit1.Text)=0 then player.Edit1.Text:='0'; 
end;

procedure Tplayer.Edit2Exit(Sender: TObject);
begin
  if length(player.Edit2.Text)=0 then player.Edit2.Text:='0';
end;

procedure Tplayer.Edit3Exit(Sender: TObject);
begin
  if length(player.Edit3.Text)=0 then player.Edit3.Text:='0';
end;

procedure Tplayer.Edit7Exit(Sender: TObject);
begin
  if length(player.Edit7.Text)=0 then player.Edit7.Text:='20';
end;

procedure Tplayer.Edit10Exit(Sender: TObject);
begin
  if length(player.Edit10.Text)=0 then player.Edit10.Text:='20';
end;

procedure Tplayer.Edit11Exit(Sender: TObject);
begin
  if length(player.Edit11.Text)=0 then player.Edit11.Text:='0';

  if player.Edit11.Text='-' then player.Edit11.Text:='0';
end;

procedure Tplayer.Edit12Exit(Sender: TObject);
begin
  if length(player.Edit12.Text)=0 then player.Edit12.Text:='0';

  if player.Edit12.Text='-' then player.Edit12.Text:='0';
end;

procedure Tplayer.Edit4Exit(Sender: TObject);
begin
  if length(player.Edit4.Text)=0 then player.Edit4.Text:='0';

  if player.Edit4.Text='-' then player.Edit4.Text:='0';
end;

procedure Tplayer.Edit5Exit(Sender: TObject);
begin
  if length(player.Edit5.Text)=0 then player.Edit5.Text:='64';
end;

procedure Tplayer.Edit6Exit(Sender: TObject);
begin
  if length(player.Edit6.Text)=0 then player.Edit6.Text:='0';

  if player.Edit6.Text='-' then player.Edit6.Text:='0';
end;

procedure Tplayer.Edit4Change(Sender: TObject);
var str:string;
t,i:integer;
begin
  str:=player.Edit4.Text;
  if pos('-',str)<>0 then i:=10
  else i:=9;
  if length(str)>i then
  begin
    setlength(str,i);
    t:=player.Edit4.SelStart;
    player.Edit4.Text:=str;
    player.Edit4.SelStart:=t;
  end;
end;

procedure Tplayer.Edit6Change(Sender: TObject);
var str:string;
t,i:integer;
begin
  str:=player.Edit6.Text;
  if pos('-',str)<>0 then i:=10
  else i:=9;
  if length(str)>i then
  begin
    setlength(str,i);
    t:=player.Edit6.SelStart;
    player.Edit6.Text:=str;
    player.Edit6.SelStart:=t;
  end;
end;

end.

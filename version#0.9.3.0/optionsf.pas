unit optionsf;

interface

uses
  Forms, Classes, Controls, StdCtrls;

type
  Toptions = class(TForm)
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    ComboBox1: TComboBox;
    CheckBox2: TCheckBox;
    Button3: TButton;
    Button4: TButton;
    CheckBox3: TCheckBox;
    Button5: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  options: Toptions;


procedure Save_options_ini;

implementation

uses mainf, aboutf, borderf, blocksf, inifiles, sysutils;

{$R *.dfm}

procedure Save_options_ini;
var f:tinifile;
begin
      f:=tinifile.Create(extractfilepath(paramstr(0))+'MCTerra.ini');
      f.WriteString('General','MCTerraVersion',FileVersion(paramstr(0)));
      f.WriteString('General','MapName',main.Edit1.Text);
      f.WriteInteger('General','MapType',main.ComboBox1.ItemIndex);
      f.WriteInteger('General','MapWidth',strtoint(main.Edit3.Text));
      f.WriteInteger('General','MapLength',strtoint(main.Edit4.Text));
      f.WriteInteger('General','TimeHours',strtoint(main.Edit8.Text));
      f.WriteInteger('General','TimeMinutes',strtoint(main.Edit9.Text));
      f.WriteBool('General','PopulateChunks',main.CheckBox1.Checked);
      f.WriteBool('General','GenerateStructures',main.CheckBox2.Checked);
      f.WriteInteger('General','GameMode',main.ComboBox2.ItemIndex);
      f.WriteInteger('General','Weather',main.ComboBox3.ItemIndex);
      f.WriteInteger('General','RainTime',strtoint(main.Edit5.Text));
      f.WriteInteger('General','ThunderTime',strtoint(main.Edit6.Text));
      f.WriteBool('General','ShowLog',main.CheckBox3.Checked);
      f.WriteString('General','SID',inttostr(map_sid));

      //save options
      f.WriteBool('General','EnableSave',true);
      f.WriteInteger('General','SaveType',save_opt.save_type);
      f.WriteBool('General','FastLoad',save_opt.fast_load);
      f.WriteBool('General','ChangeDisabled',save_opt.change_disabled);

      //main form
      f.WriteInteger('MainForm','Top',main.Top);
      f.WriteInteger('MainForm','Left',main.Left);

      //about form
      f.WriteInteger('AboutForm','Top',about.Top);
      f.WriteInteger('AboutForm','Left',about.Left);

      //border form
      f.WriteInteger('BorderForm','Top',border.Top);
      f.WriteInteger('BorderForm','Left',border.Left);

      //blocks form
      f.WriteInteger('BlocksForm','Top',blocks.Top);
      f.WriteInteger('BlocksForm','Left',blocks.Left);

      //options form
      f.WriteInteger('OptionsForm','Top',options.Top);
      f.WriteInteger('OptionsForm','Left',options.Left); 

      f.Free;
end;

procedure Toptions.Button1Click(Sender: TObject);
begin
  save_opt.save_enabled:=options.CheckBox1.Checked;
  save_opt.save_type:=options.ComboBox1.ItemIndex;
  save_opt.fast_load:=options.CheckBox2.Checked;
  if (save_opt.change_disabled=false)and(options.CheckBox3.Checked=true) then
  begin
    save_opt.change_disabled:=options.CheckBox3.Checked;
    save_options_ini;
  end
  else
    save_opt.change_disabled:=options.CheckBox3.Checked;

  modalresult:=mrOK;
end;

procedure Toptions.Button2Click(Sender: TObject);
begin
  modalresult:=mrCancel;
end;

procedure Toptions.FormShow(Sender: TObject);
begin
  options.CheckBox1.Checked:=save_opt.save_enabled;
  options.ComboBox1.ItemIndex:=save_opt.save_type;
  options.CheckBox2.Checked:=save_opt.fast_load;
  options.CheckBox3.Checked:=save_opt.change_disabled;

  options.CheckBox1Click(options);
end;

procedure Toptions.CheckBox1Click(Sender: TObject);
begin
  if options.CheckBox1.Checked then
  begin
    options.ComboBox1.Enabled:=true;
    options.CheckBox2.Enabled:=true;
    options.CheckBox3.Enabled:=true;
    options.Button3.Enabled:=true;
    //options.Button5.Enabled:=true;
  end
  else
  begin
    options.ComboBox1.Enabled:=false;
    options.CheckBox2.Enabled:=false;
    options.CheckBox3.Enabled:=false;
    options.Button3.Enabled:=false;
    //options.Button5.Enabled:=false;
  end;
end;

procedure Toptions.FormCreate(Sender: TObject);
begin
  if save_opt.save_enabled=true then
    if (save_opt.options_f.top<>-1)and(save_opt.options_f.left<>-1) then
    begin
      options.Top:=save_opt.options_f.top;
      options.Left:=save_opt.options_f.left;
    end;
end;

procedure Toptions.Button3Click(Sender: TObject);
begin
  save_opt.save_enabled:=options.CheckBox1.Checked;
  save_opt.save_type:=options.ComboBox1.ItemIndex;
  save_opt.fast_load:=options.CheckBox2.Checked;
  save_opt.change_disabled:=options.CheckBox3.Checked;
  
  save_options_ini;
end;

procedure Toptions.Button5Click(Sender: TObject);
begin
  if fileexists(extractfilepath(paramstr(0))+'MCTerra.ini') then
  begin
    deletefile(extractfilepath(paramstr(0))+'MCTerra.ini');
    application.MessageBox('Deleted sucsessfuly','Notice');
  end
  else
  begin
    application.MessageBox('There are no options saved','Notice');
  end;
end;

procedure Toptions.Button4Click(Sender: TObject);
begin
  //save options
  options.CheckBox1.Checked:=false;
  options.CheckBox2.Checked:=false;
  options.CheckBox3.Checked:=false;
  options.CheckBox1Click(options);

  //osnovnie nastroyki
  main.Edit1.Text:='New map';
  main.ComboBox1.ItemIndex:=0;
  main.Edit3.Text:='20';
  main.Edit4.Text:='20';
  main.ComboBox1Change(main);
  main.Edit8.Text:='6';
  main.Edit9.Text:='0';
  main.CheckBox1.Checked:=false;
  main.CheckBox2.Checked:=false;
  main.ComboBox2.ItemIndex:=0;
  main.ComboBox3.ItemIndex:=0;
  main.Edit5.Text:='2500';
  main.Edit6.Text:='8000';
  main.CheckBox3.Checked:=false;
  main.CheckBox3Click(main);
  //sid
  main.Button2Click(main);

  //formi
  main.Left:=round(screen.Width/2-main.Width/2);
  main.Top:=round(screen.Height/2-main.Height/2);
  about.Left:=round(screen.Width/2-about.Width/2);
  about.Top:=round(screen.Height/2-about.Height/2);
  blocks.Top:=173;
  blocks.Left:=288;
  border.Top:=261;
  border.Left:=275;
  options.Top:=350;
  options.Left:=464;
end;

end.

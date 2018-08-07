unit mainf;

interface

uses
  Forms, Windows, Menus, Classes, Controls,
  RandomMCT, SysUtils, types_mct, ComCtrls, StdCtrls, ExtCtrls, Dialogs;

type
  Tmain = class(TForm)
    MainMenu1: TMainMenu;
    MCTerra1: TMenuItem;
    About1: TMenuItem;
    Loadedplugins1: TMenuItem;
    Exit1: TMenuItem;
    StatusBar1: TStatusBar;
    Memo1: TMemo;
    Button1: TButton;
    GroupBox1: TGroupBox;
    GroupBox5: TGroupBox;
    Panel1: TPanel;
    Image1: TImage;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Button2: TButton;
    GroupBox2: TGroupBox;
    ComboBox1: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    GroupBox9: TGroupBox;
    Label13: TLabel;
    Label14: TLabel;
    Edit8: TEdit;
    Edit9: TEdit;
    Label7: TLabel;
    ComboBox2: TComboBox;
    Label8: TLabel;
    ComboBox3: TComboBox;
    Label9: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    Label10: TLabel;
    Button3: TButton;
    Button4: TButton;
    GroupBox3: TGroupBox;
    Button5: TButton;
    ComboBox4: TComboBox;
    GroupBox6: TGroupBox;
    Button6: TButton;
    GroupBox4: TGroupBox;
    Button7: TButton;
    Label11: TLabel;
    Label12: TLabel;
    Label15: TLabel;
    GroupBox7: TGroupBox;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Button9: TButton;
    Button13: TButton;
    ProgressBar1: TProgressBar;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    CheckBox3: TCheckBox;
    Label24: TLabel;
    Label25: TLabel;
    SaveDialog1: TSaveDialog;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    StatusBar2: TStatusBar;
    StatusBar3: TStatusBar;
    ProgressBar2: TProgressBar;
    ProgressBar3: TProgressBar;
    Button17: TButton;
    Label36: TLabel;
    Button12: TButton;
    Button16: TButton;
    Options1: TMenuItem;
    Button10: TButton;
    procedure AppMes(var Msg: TMsg; var Handled: Boolean);
    procedure Exit1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2Change(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure CheckBox3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
    procedure Edit8KeyPress(Sender: TObject; var Key: Char);
    procedure Edit9KeyPress(Sender: TObject; var Key: Char);
    procedure Edit5KeyPress(Sender: TObject; var Key: Char);
    procedure Edit6KeyPress(Sender: TObject; var Key: Char);
    procedure Edit8Exit(Sender: TObject);
    procedure Edit9Exit(Sender: TObject);
    procedure Edit5Exit(Sender: TObject);
    procedure Edit5Change(Sender: TObject);
    procedure Edit6Exit(Sender: TObject);
    procedure Edit6Change(Sender: TObject);
    procedure Loadedplugins1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Edit3Exit(Sender: TObject);
    procedure Edit4Exit(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure ComboBox1Exit(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Options1Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  main: Tmain;
  map_sid:int64;
  map_sid_rnd:rnd;

  landscape_plugins, border_plugins, structures_plugins:TPlugin_ar;

  land_sel,border_sel,struct_sel:integer;

  label_chetchik_land:integer = 0;
  label_chetchik_border:integer = 0;
  label_chetchik_structures:integer = 0;

  generation_settings:TGen_settings;
  wait_init_thread_hndl:cardinal;
  wait_level_thread_hndl:cardinal;
  init_threads:THNDL_ar;
  gen_threads:THNDL_ar;
  stop_thread_hndl:cardinal = 0;
  gen_stopped:boolean;
  land_stopped,border_stopped,struct_stopped:boolean;
  //status generacii
  //0 - v ozhidanii generacii
  //1 - nazhata generaciya, no eshe ne zapusheni potoki
  //2 - inicializaciya plaginov
  //3 - posle okonchaniya inicializacii, no do nachala samoy generacii
  //4 - generaciya chankov
  //5 - posle generacii chankov pri sozdanii level.dat i dopolnitelnih faylov
  gen_status:byte;

  gen_timestamp:cardinal;

  path_str,name_str:string;

  save_opt:save_options_type;
  

procedure Delay(ms:cardinal);
function wait_level_thread(p:pointer):integer;
function stop_gen_thread(p:pointer):integer;
function bintoint(s:string):int64;
function hextobin(s:string):string;
procedure btolendian(var i:integer);
function FileVersion(AFileName: string): string;
function convert_time(hours,minutes:byte):integer;

implementation

uses aboutf, borderf, generation, NBT, zlibex, blocksf, blocks_mct,
crc32_u, inifiles, optionsf;

var init_thread_hndl:integer;

procedure Delay(ms:cardinal);
var time:cardinal;
begin
  time:=GetTickCount+ms;
  while (time>GetTickCount)and not(Application.Terminated) do
    application.ProcessMessages;
end;

{$R *.dfm}

function FileVersion(AFileName: string): string;
var
  szName: array[0..255] of Char;
  P: Pointer;
  Value: Pointer;
  Len: UINT;
  GetTranslationString: string;
  FFileName: PChar;
  FValid: boolean;
  FSize: DWORD;
  FHandle: DWORD;
  FBuffer: PChar;
begin
  try
    FFileName := StrPCopy(StrAlloc(Length(AFileName) + 1), AFileName);
    FValid := False;
    FSize := GetFileVersionInfoSize(FFileName, FHandle);
    if FSize > 0 then
    try
      GetMem(FBuffer, FSize);
      FValid := GetFileVersionInfo(FFileName, FHandle, FSize, FBuffer);
    except
      FValid := False;
      raise;
    end;
    Result := '';
    if FValid then
      VerQueryValue(FBuffer, '\VarFileInfo\Translation', p, Len)
    else
      p := nil;
    if P <> nil then
      GetTranslationString := IntToHex(MakeLong(HiWord(Longint(P^)),
        LoWord(Longint(P^))), 8);
    if FValid then
    begin
      StrPCopy(szName, '\StringFileInfo\' + GetTranslationString +
        '\FileVersion');
      if VerQueryValue(FBuffer, szName, Value, Len) then
        Result := StrPas(PChar(Value));
    end;
  finally
    try
      if FBuffer <> nil then
        FreeMem(FBuffer, FSize);
    except
    end;
    try
      StrDispose(FFileName);
    except
    end;
  end;
end;

//funkciya iz modula StrUtils
function PosEx(const SubStr, S: string; Offset: Cardinal = 1): Integer;
var
  I,X: Integer;
  Len, LenSubStr: Integer;
begin
  if Offset = 1 then
    Result := Pos(SubStr, S)
  else
  begin
    I := Offset;
    LenSubStr := Length(SubStr);
    Len := Length(S) - LenSubStr + 1;
    while I <= Len do
    begin
      if S[I] = SubStr[1] then
      begin
        X := 1;
        while (X < LenSubStr) and (S[I + X] = SubStr[X + 1]) do
          Inc(X);
        if (X = LenSubStr) then
        begin
          Result := I;
          exit;
        end;
      end;
      Inc(I);
    end;
    Result := 0;
  end;
end;

function proverka_int64(str:string):boolean;
var s:string;
b:boolean;
begin
  s:=str;
  if s='' then
  begin
    result:=false;
    exit;
  end;

  if s[1]='-' then
  begin
    delete(s,1,1);
    b:=true;
  end
  else
    b:=false;

  if ((s>'9223372036854775808')and(b=true)and(length(s)>=19))or
  ((s>'9223372036854775807')and(b=false)and(length(s)>=19)) then
    result:=true
  else
    result:=false;
end;

function step(chislo, stepen:byte):int64;
var sum:int64;
i:integer;
begin
  if stepen=0 then sum:=1
  else sum:=chislo;
  for i:=2 to stepen do
    sum:=sum*chislo;
  result:=sum;
end;

function bintoint(s:string):int64;
var j,sum:int64;
i:integer;
begin
  j:=0;
  sum:=0;
  for i:=length(s) downto 1 do
  begin
    if s[i]='1' then sum:=sum+step(2,j);
    j:=j+1;
  end;
  result:=sum;
end;

function hextobin(s:string):string;
var str:string;
i:integer;
begin
  str:='';
  for i:=1 to length(s) do
    case s[i] of
      '0':str:=str+'0000';
      '1':str:=str+'0001';
      '2':str:=str+'0010';
      '3':str:=str+'0011';
      '4':str:=str+'0100';
      '5':str:=str+'0101';
      '6':str:=str+'0110';
      '7':str:=str+'0111';
      '8':str:=str+'1000';
      '9':str:=str+'1001';
      'a','A':str:=str+'1010';
      'b','B':str:=str+'1011';
      'c','C':str:=str+'1100';
      'd','D':str:=str+'1101';
      'e','E':str:=str+'1110';
      'f','F':str:=str+'1111';
    end;
  result:=str;
end;

procedure btolendian(var i:integer);
var s,s1:string;
j:integer;
begin
  s:=inttohex(i,8);
  s1:=s;
  for j:=1 to 4 do
  begin
    s1[2*(4-j)+1]:=s[2*(j-1)+1];
    s1[2*(4-j)+2]:=s[2*(j-1)+2];
  end;
  i:=bintoint(hextobin(s1));
end;

function convert_time(hours,minutes:byte):integer;
var i:integer;
begin
  i:=hours*1000;
  i:=round(i+minutes*time_const);
  dec(i,6000);
  if i<0 then inc(i,24000);
  result:=i mod 24000;
end;

procedure disable_controls;   //vizivaetsa pri nachale generacii
begin
  //main.Label1.Enabled:=false;
  main.Edit1.Enabled:=false;
  //main.Label2.Enabled:=false;
  main.Edit2.Enabled:=false;
  main.Button2.Enabled:=false;
  //main.Label6.Enabled:=false;
  main.ComboBox1.Enabled:=false;
  //main.Label3.Enabled:=false;
  main.Edit3.Enabled:=false;
  //main.Label4.Enabled:=false;
  main.Edit4.Enabled:=false;
  main.CheckBox1.Enabled:=false;
  main.CheckBox2.Enabled:=false;
  //main.Label7.Enabled:=false;
  main.ComboBox2.Enabled:=false;
  //main.Label8.Enabled:=false;
  main.ComboBox3.Enabled:=false;
  //main.Label9.Enabled:=false;
  //main.Label10.Enabled:=false;
  main.Edit5.Enabled:=false;
  main.Edit6.Enabled:=false;
  //main.Label13.Enabled:=false;
  main.Edit8.Enabled:=false;
  //main.Label14.Enabled:=false;
  main.Edit9.Enabled:=false;
  main.Button3.Enabled:=false;
  main.Button4.Enabled:=false;
  main.Button6.Enabled:=false;
  main.Button7.Enabled:=false;
  main.ComboBox4.Enabled:=false;
  main.Button5.Enabled:=false;
  main.Button9.Enabled:=false;

  main.Button13.Enabled:=true;
end;

procedure enable_controls;    //vizivaetsa pri ostanovke generacii
begin
  //main.Label1.Enabled:=true;
  main.Edit1.Enabled:=true;
  //main.Label2.Enabled:=true;
  main.Edit2.Enabled:=true;
  main.Button2.Enabled:=true;
  //main.Label6.Enabled:=true;
  main.ComboBox1.Enabled:=true;
  //main.Label3.Enabled:=true;
  main.Edit3.Enabled:=true;
  //main.Label4.Enabled:=true;
  main.Edit4.Enabled:=true;
  main.CheckBox1.Enabled:=true;
  main.CheckBox2.Enabled:=true;
  //main.Label7.Enabled:=true;
  main.ComboBox2.Enabled:=true;
  //main.Label8.Enabled:=true;
  main.ComboBox3.Enabled:=true;
  //main.Label9.Enabled:=true;
  //main.Label10.Enabled:=true;
  main.Edit5.Enabled:=true;
  main.Edit6.Enabled:=true;
  //main.Label13.Enabled:=true;
  main.Edit8.Enabled:=true;
  //main.Label14.Enabled:=true;
  main.Edit9.Enabled:=true;
  main.Button3.Enabled:=true;
  main.Button4.Enabled:=true;
  main.Button6.Enabled:=true;
  main.Button7.Enabled:=true;
  main.ComboBox4.Enabled:=true;
  main.Button5.Enabled:=true;
  main.Button9.Enabled:=true;

  main.Button13.Enabled:=false;
end;

function wait_level_thread(p:pointer):integer;
var i:integer;
time:cardinal;
rez:byte_ar;
str,str1,strcompress:string;
f:file;
search:_WIN32_FIND_DATAA;
id:cardinal;

b:boolean;
begin
  main.Memo1.Lines.Add('Wait for level gen finish thread enter');

  for i:=0 to length(gen_threads)-1 do
    if gen_threads[i]<>0 then waitforsingleobject(gen_threads[i],infinite);

  //izmenaem status generacii
  gen_status:=5;

  setlength(gen_threads,0);

  str:=generation_settings.Name;
  if gen_stopped=false then
  begin
    nbtcompress_level(generation_settings,@rez);

    setlength(str,length(rez));
    move(rez[0],str[1],length(rez));

    i:=zcrc32(0,str[1],length(str));

    zcompressstringex(strcompress,str,zcmax);

    str:=copy(strcompress,1,4);
    delete(strcompress,1,4);
    delete(strcompress,1,2);

    delete(strcompress,length(strcompress)-3,4);

    str1:=chr(i and $FF);
    str1:=str1+chr((i shr 8) and $FF);
    str1:=str1+chr((i shr 16) and $FF);
    str1:=str1+chr((i shr 24) and $FF);

    strcompress:=strcompress+str1+str;

    strcompress:=#31+#139+#8+#0+#0+#0+#0+#0+#2+#0+strcompress;

    str:=generation_settings.Path;
    str1:=generation_settings.Name;

    str:=str+str1+'\level.dat';
    assignfile(f,str);
    rewrite(f,1);
    blockwrite(f,strcompress[1],length(strcompress));
    closefile(f);
  end;

  SetCurrentDirectory(pchar(extractfilepath(paramstr(0))));

  time:=getcurrenttime-gen_timestamp;
  main.Memo1.Lines.Add('Time spend ms='+inttostr(time));
  time:=round(time/1000);
  str:='Time, spend on generation: ';
  if time>=60 then
    if ((time div 60) mod 10)=1 then str:=str+inttostr(time div 60)+' minute '
    else str:=str+inttostr(time div 60)+' minutes ';

  if (time mod 10)=1 then str:=str+inttostr(time mod 60)+' second'
  else str:=str+inttostr(time mod 60)+' seconds';

  //v konce posilaem vsem potokam soobshenie, chtobi oni ochistili vse
  landscape_plugins[land_sel].stop_gen(1);
  if border_sel<>0 then border_plugins[border_sel].stop_gen(1);
  if struct_sel<>0 then structures_plugins[struct_sel].stop_gen(1);

  if gen_stopped=false then
  begin
    application.MessageBox(pchar('Map generation complete'+#13+#10+str),'Generation');
    //application.MessageBox(pchar(str),'Generation');
    main.Memo1.Lines.Add('Map generation complete: '+str);
  end
  else
  begin
    (*//ochishaem katalog
    str1:=main.SaveDialog1.FileName;
    //izvlekaem put'
    str1:=extractfilepath(str1);
    str1:=str1+main.Edit1.Text;

    if directoryexists(str1+'\region') then
        begin
          id:=findfirstfile(pchar(str1+'\region\*.*'),search);
          if id<>INVALID_HANDLE_VALUE then
          begin
            repeat
              if (search.cFileName[0]<>'.') then
              b:=windows.deletefile(pchar(str1+'\region\'+search.cFileName));
              main.Memo1.Lines.Add('Deleting file:'+str1+'\region\'+search.cFileName+'   Deleted:'+booltostr(b,true));
            until findnextfile(id,search)=false;
            Windows.findclose(i);
          end;
        end;
    //udalaem fayl settings
    //if fileexists(str1+'\settings.txt') then
    //  deletefile(str1+'\settings.txt');
    //udalaem katalogi   
    RemoveDirectory(pchar(str1+'\region'));
    RemoveDirectory(pchar(str1));   *)

    //ochishaem katalog
    str1:=main.SaveDialog1.FileName;
    //izvlekaem put'
    str1:=extractfilepath(str1);

    if directoryexists(str1+main.Edit1.Text+'\region') then
        begin
          i:=findfirstfile(pchar(str1+main.Edit1.Text+'\region\*.*'),search);
          if i<>INVALID_HANDLE_VALUE then
          begin
            repeat
              if (search.cFileName[0]<>'.') then
              windows.deletefile(pchar(str1+main.Edit1.Text+'\region\'+search.cFileName));
            until findnextfile(i,search)=false;
            Windows.findclose(i);
          end;
        end;
    //udalaem katalogi
    RemoveDirectory(pchar(str1+main.Edit1.Text+'\region'));
    RemoveDirectory(pchar(str1+main.Edit1.Text));

    application.MessageBox(pchar('Map generation aborted'+#13+#10+str),'Generation');
    main.Memo1.Lines.Add('Map generation aborted: '+str);
  end;

  //izmenaem status generacii
  gen_status:=0;
  //gen_stopped:=false;

  enable_controls;

  //ochishaem panel'
  postmessage(main.Handle,WM_USER+300,0,0);

  //vozvrashaem potoki v pervonachalniy vid
  setlength(gen_threads,0);
  setlength(init_threads,0);
  wait_init_thread_hndl:=0;
  wait_level_thread_hndl:=0;

  endthread(2);
end;

function stop_gen_thread(p:pointer):integer;
var i:integer;
time,time1:cardinal;
id:cardinal;
begin
  land_stopped:=false;
  border_stopped:=false;
  struct_stopped:=false;

  main.Memo1.Lines.Add('Stop thread enter, status='+inttostr(gen_status));

  //proveraem, na kakom etape nahodimsa
  if gen_status=0 then endthread(2);

  if gen_status=1 then   //esli eshe ne zapusheni potoki, to zhdem ih zapuska
    repeat
      sleep(50);
    until gen_status<>1;

  if gen_status=2 then  //esli idet procedura inicializacii
  begin
    gen_stopped:=true;
    //posilaem soobshenie ob ostanovke v plagini
    landscape_plugins[land_sel].stop_gen(0);
    if border_sel<>0 then border_plugins[border_sel].stop_gen(0)
    else border_stopped:=true;
    if struct_sel<>0 then structures_plugins[struct_sel].stop_gen(0)
    else struct_stopped:=true;

    //zapominaem vrema
    time:=getcurrenttime;
    time1:=time;

    //zhdem poka plagini ne poshlut soobsheniya o tom, chto oni ostanovleni
    //while (land_stopped=false)or(border_stopped=false)or(struct_stopped=false)or((time1-time)>10000) do
    repeat
      begin
      time1:=getcurrenttime;
      sleep(50);
      end;
    until ((land_stopped=true)and(border_stopped=true)and(struct_stopped=true))or((time1-time)>10000);

    //esli proshlo mnogo vremeni
    if (time1-time)>10000 then
    begin
      for i:=0 to length(init_threads)-1 do
        TerminateThread(init_threads[i],1);
    end;
    //else
    //begin   //esli proshlo normal'no vremeni, znachit inicializaciya bol'she ne idet
      wait_level_thread_hndl:=beginthread(nil,0,@wait_level_thread,nil,0,id);
    //end;
  end;

  if gen_status=3 then
    repeat
      sleep(50);
    until gen_status<>3;

  if gen_status>3 then gen_stopped:=true;

  stop_thread_hndl:=0;

  endthread(2);
end;

procedure allign_labels1;
begin
  main.Label20.Left:=main.Label22.Left+main.Label22.Width+5;
  //main.Label21.Left:=main.Label20.Left+main.Label20.Width+5;
  main.Label21.Left:=main.Label22.Left+main.Label22.Width+5+main.Label20.Width+5;
end;

procedure allign_labels2;
begin
  main.Label27.Left:=main.Label29.Left+main.Label29.Width+5;
  main.Label28.Left:=main.Label27.Left+main.Label27.Width+5;
end;

procedure allign_labels3;
begin
  main.Label32.Left:=main.Label34.Left+main.Label34.Width+5;
  main.Label33.Left:=main.Label32.Left+main.Label32.Width+5;
end;

procedure Tmain.AppMes(var Msg: TMsg; var Handled: Boolean);
var pstr:pchar;
str:string;
i:integer;
begin
  if (msg.message>=WM_USER+300)and(msg.message<=WM_USER+400) then
  begin
    //main.Memo1.Lines.Add('Reseived message WM_USER+'+inttostr(msg.message-WM_USER));
    case msg.message of
    WM_USER+300:begin  //ochishenie layblov i progress bara
                  case msg.wParam of
                  0:begin  //otpravlaet plagin generacii landshafta
                      main.Label22.Caption:='';
                      main.Label20.Caption:='';
                      main.Label21.Caption:='';
                      main.Label23.Caption:='';
                      label_chetchik_land:=0;
                      allign_labels1;
                      main.ProgressBar1.Position:=0;
                      main.ProgressBar1.Max:=0;
                    end;
                  1:begin  //otpravlaet plagin generacii granici
                      main.Label29.Caption:='';
                      main.Label27.Caption:='';
                      main.Label28.Caption:='';
                      main.Label30.Caption:='';
                      label_chetchik_border:=0;
                      allign_labels2;
                      main.ProgressBar2.Position:=0;
                      main.ProgressBar2.Max:=0;
                    end;
                  2:begin  //otpravlaet plagin generacii structur
                      main.Label34.Caption:='';
                      main.Label32.Caption:='';
                      main.Label33.Caption:='';
                      main.Label35.Caption:='';
                      label_chetchik_structures:=0;
                      allign_labels3;
                      main.ProgressBar3.Position:=0;
                      main.ProgressBar3.Max:=0;
                    end;
                  end;

                  {if msg.wParam=0 then
                  begin     //otpravlaet plagin generacii landshafta
                  //znachit ochishaem glavnuyu panel'
                    main.Label22.Caption:='';
                    main.Label20.Caption:='';
                    main.Label21.Caption:='';
                    main.Label23.Caption:='';
                    label_chetchik_land:=0;
                    allign_labels1;
                    main.ProgressBar1.Position:=0;
                    main.ProgressBar1.Max:=0;
                  end
                  else if msg.wParam=1 then
                  begin   //otpravlaet plagin generacii granici
                  end;  }
                end;
    WM_USER+301:begin  //sbros progressbara
                  case msg.wParam of
                  0:begin
                      main.ProgressBar1.Position:=0;
                      main.ProgressBar1.Max:=0;
                    end;
                  1:begin
                      main.ProgressBar2.Position:=0;
                      main.ProgressBar2.Max:=0;
                    end;
                  2:begin
                      main.ProgressBar3.Position:=0;
                      main.ProgressBar3.Max:=0;
                    end;
                  end;
                  {if msg.wParam=0 then
                  begin  //otpravlaet plagin generacii landshafta
                  end
                  else if msg.wParam=1 then
                  begin  //otpravlaet plagin generacii granici
                  end;  }
                end;
    WM_USER+302:begin   //dobavlenie maksimuma k progressbaru
                  case msg.lParam of
                  0:main.ProgressBar1.Max:=main.ProgressBar1.Max+msg.wParam;
                  1:main.ProgressBar2.Max:=main.ProgressBar2.Max+msg.wParam;
                  2:main.ProgressBar3.Max:=main.ProgressBar3.Max+msg.wParam;
                  end;
                  {if msg.lParam=0 then
                  begin
                    main.ProgressBar1.Max:=main.ProgressBar1.Max+msg.wParam;
                  end
                  else if msg.lParam=1 then
                  begin
                  end; }
                end;
    WM_USER+303:begin   //izmenenie pozicii progressbara
                  {case msg.lParam of
                  0:main.ProgressBar1.Position:=main.ProgressBar1.Position+msg.wParam;
                  1:main.ProgressBar2.Position:=main.ProgressBar2.Position+msg.wParam;
                  2:main.ProgressBar3.Position:=main.ProgressBar3.Position+msg.wParam;
                  end;  }
                  case msg.lParam of
                  0:main.ProgressBar1.Position:=msg.wParam;
                  1:main.ProgressBar2.Position:=msg.wParam;
                  2:main.ProgressBar3.Position:=msg.wParam;
                  end;
                  {if msg.lParam=0 then
                  begin
                    main.ProgressBar1.Position:=main.ProgressBar1.Position+msg.wParam;
                  end
                  else if msg.lParam=1 then
                  begin
                  end;}
                end;
    WM_USER+304:begin   //izmenenie chislovoy nadpisi
                  i:=msg.wParam;
                  case msg.lParam of
                  0:begin    //land
                      //i:=label_chetchik_land+msg.wParam;
                      if length(main.Label20.Caption)<>length(inttostr(i)) then
                      begin
                        main.Label20.Caption:=inttostr(i);
                        allign_labels1;
                      end
                      else
                        main.Label20.Caption:=inttostr(i);
                      label_chetchik_land:=i;
                    end;
                  1:begin   //border
                      //i:=label_chetchik_border+msg.wParam;
                      if length(main.Label27.Caption)<>length(inttostr(i)) then
                      begin
                        main.Label27.Caption:=inttostr(i);
                        allign_labels2;
                      end
                      else
                        main.Label27.Caption:=inttostr(i);
                      label_chetchik_border:=i;
                    end;
                  2:begin   //structures
                      //i:=label_chetchik_structures+msg.wParam;
                      if length(main.Label32.Caption)<>length(inttostr(i)) then
                      begin
                        main.Label32.Caption:=inttostr(i);
                        allign_labels2;
                      end
                      else
                        main.Label32.Caption:=inttostr(i);
                      label_chetchik_structures:=i;
                    end;
                  end;
                end;
    WM_USER+305:begin   //izmenenie tekstovoy nadpisi
                  pstr:=pchar(msg.wParam);
                  str:=pstr;
                  case msg.lParam of
                  1:begin
                      main.Label22.Caption:=str;
                      allign_labels1;
                    end;
                  2:begin
                      main.Label20.Caption:=str;
                      allign_labels1;
                    end;
                  3:begin
                      main.Label21.Caption:=str;
                      allign_labels1;
                    end;
                  4:main.Label23.Caption:=str; 
                  5:main.Label29.Caption:=str;
                  6:main.Label27.Caption:=str;
                  7:main.Label28.Caption:=str;
                  8:main.Label30.Caption:=str;
                  9:main.Label34.Caption:=str;
                  10:main.Label32.Caption:=str;
                  11:main.Label33.Caption:=str;
                  12:main.Label35.Caption:=str;
                  end;
                end;
    WM_USER+306:begin   //izmenenie spauna igroka
                  if (msg.wParam>=0)and(msg.wParam<=2) then
                    generation_settings.Spawn_pos[msg.wParam]:=msg.lParam;
                end;
    WM_USER+307:begin  //peredacha dannih dla zapisi v log
                  main.Memo1.Lines.Add('Reseived data: '+inttostr(msg.wParam)+'; '+inttostr(msg.lParam));
                end;
    WM_USER+308:begin  //peredacha razmera fayla dla zapisi v nastroyki generacii
                  inc(generation_settings.Files_size,msg.wParam); 
                end;
    WM_USER+309:begin   //peredacha stroki dla zapisi v log
                  pstr:=pchar(msg.wParam);
                  str:=pstr;
                  main.Memo1.Lines.Add('Reseived string from plugin #'+inttostr(msg.lParam)+'='+str);
                end;
    WM_USER+310:begin   //soobshenie ob okonchanii generacii ot plagina
                  case msg.wParam of
                    0:land_stopped:=true;
                    1:border_stopped:=true;
                    2:struct_stopped:=true;
                  end;
                end;
    WM_USER+311:begin  //timestamp dla otladki plaginov
                  main.Memo1.Lines.Add('Reseived timestamp from plugin #'+inttostr(msg.wParam)+'  time='+inttostr(getcurrenttime));
                end;
    end;
  end;
end;

procedure Tmain.Exit1Click(Sender: TObject);
begin
  halt(0);
end;

procedure Tmain.Button1Click(Sender: TObject);
begin
  main.Memo1.Clear;
end;

procedure show_border_status;
begin
  main.StatusBar2.Top:=0;
  main.StatusBar2.Align:=alBottom;
  main.Height:=main.Height+23;
  main.StatusBar2.Visible:=true;
end;

procedure hide_border_status;
begin
  main.StatusBar2.Visible:=false;
  main.Height:=main.Height-23;
  main.StatusBar2.Align:=alNone;
end;

procedure show_structure_status;
begin
  main.StatusBar3.Top:=0;
  main.StatusBar3.Align:=alBottom;
  main.Height:=main.Height+23;
  main.StatusBar3.Visible:=true;
end;

procedure hide_structure_status;
begin
  main.StatusBar3.Visible:=false;
  main.Height:=main.Height-23;
  main.StatusBar3.Align:=alNone;
end;

procedure Tmain.FormCreate(Sender: TObject);
var str,str1:string;
i:integer;
f:tinifile;
str_list:tstrings;
begin
  str:=FileVersion(paramstr(0));

  //proveraem est' li nastroyki i ih pravil'nost'
  i:=0;
  save_opt.save_type:=-1;
  //proverka INI
  if fileexists(extractfilepath(paramstr(0))+'MCTerra.ini') then
  begin
    save_opt.save_type:=0;
    f:=tinifile.Create(extractfilepath(paramstr(0))+'MCTerra.ini');
    str_list:=tstringlist.Create;

    //f.ReadSections(main.Memo1.Lines);
    f.ReadSections(str_list);
    if (str_list.IndexOf('General')=-1)or
    (str_list.IndexOf('MainForm')=-1)or
    (str_list.IndexOf('AboutForm')=-1)or
    (str_list.IndexOf('BorderForm')=-1)or
    (str_list.IndexOf('BlocksForm')=-1)or
    (str_list.IndexOf('OptionsForm')=-1)
      then i:=-1
    else
    begin
      if f.ReadString('General','MCTerraVersion','MagicVersion')<>FileVersion(paramstr(0)) then i:=-1;
      if f.ReadBool('General','EnableSave',false)=false then i:=-1;
    end;

    str_list.Free;
    f.Free;
  end
  else   //proverka registry
  begin
    i:=-1;
  end;

  if (i=0)and(save_opt.save_type<>-1) then save_opt.save_enabled:=true
  else save_opt.save_enabled:=false;

  //analiz poluchennih rezultatov
  //if i=-1 then  //ispol'zuem defoltnie nastroyki
  if save_opt.save_enabled=false then
  begin
    //save_opt.save_enabled:=false;
    save_opt.save_type:=0;
    save_opt.fast_load:=false;
    save_opt.change_disabled:=false;
    save_opt.sid:=0;

    //defoltnoe znachenie loga
    main.CheckBox3.Checked:=false;

    //defoltnie znacheniya glavnogo okna
    save_opt.main_f.top:=round(screen.Height/2-main.Height/2);
    save_opt.main_f.left:=round(screen.Width/2-main.Width/2);
  end
  else
  begin   //zagruzhaem nastroyki iz hranilisha
    //save_opt.save_enabled:=true;
    
    if save_opt.save_type=0 then
    begin  //INI
      f:=tinifile.Create(extractfilepath(paramstr(0))+'MCTerra.ini');
      //osnovnie nastroyki
      main.Edit1.Text:=f.ReadString('General','MapName','New map');
      main.ComboBox1.ItemIndex:=f.ReadInteger('General','MapType',0);
      main.Edit3.Text:=inttostr(f.ReadInteger('General','MapWidth',20));
      main.Edit4.Text:=inttostr(f.ReadInteger('General','MapLength',20));
      main.Edit8.Text:=inttostr(f.ReadInteger('General','TimeHours',6));
      main.Edit9.Text:=inttostr(f.ReadInteger('General','TimeMinutes',0));
      main.CheckBox1.Checked:=f.ReadBool('General','PopulateChunks',false);
      main.CheckBox2.Checked:=f.ReadBool('General','GenerateStructures',false);
      main.ComboBox2.ItemIndex:=f.ReadInteger('General','GameMode',0);
      main.ComboBox3.ItemIndex:=f.ReadInteger('General','Weather',0);
      main.Edit5.Text:=inttostr(f.ReadInteger('General','RainTime',2500));
      main.Edit6.Text:=inttostr(f.ReadInteger('General','ThunderTime',8000));
      main.CheckBox3.Checked:=f.ReadBool('General','ShowLog',false);
      //sid
      str1:=f.ReadString('General','SID','1234567890');
      save_opt.sid:=strtoint64(str1);

      //save options
      save_opt.save_type:=f.ReadInteger('General','SaveType',0);
      save_opt.fast_load:=f.ReadBool('General','FastLoad',false);
      save_opt.change_disabled:=f.ReadBool('General','ChangeDisabled',false);

      //form options
      save_opt.main_f.top:=f.ReadInteger('MainForm','Top',round(screen.Height/2-main.Height/2));
      save_opt.main_f.left:=f.ReadInteger('MainForm','Left',round(screen.Width/2-main.Width/2));
      save_opt.about_f.top:=f.ReadInteger('AboutForm','Top',-1);
      save_opt.about_f.left:=f.ReadInteger('AboutForm','Left',-1);
      save_opt.options_f.top:=f.ReadInteger('OptionsForm','Top',-1);
      save_opt.options_f.left:=f.ReadInteger('OptionsForm','Left',-1);
      save_opt.border_f.top:=f.ReadInteger('BorderForm','Top',-1);
      save_opt.border_f.left:=f.ReadInteger('BorderForm','Left',-1);
      save_opt.blocks_f.top:=f.ReadInteger('BlocksForm','Top',-1);
      save_opt.blocks_f.left:=f.ReadInteger('BlocksForm','Left',-1); 

      f.Free;
    end
    else
    begin  //REGISTRY
    end;
  end;

  //beginthread
  {i:=SetThreadAffinityMask(getcurrentthread,1);
  if i<>0 then main.Memo1.Lines.Add('Setting main form affinity mask sucsessful with return='+inttostr(i))
  else main.Memo1.Lines.Add('Setting main form affinity mask failed');  }

  if Setpriorityclass(getcurrentprocess,HIGH_PRIORITY_CLASS)=true then
    main.Memo1.Lines.Add('Setting application priority sucsessful')
  else
    main.Memo1.Lines.Add('Setting application priority failed');

  //prisvaivaem obrabotchik soobshenie
  application.OnMessage:=AppMes;

  //zapolnaem massiv blokov standartnimi blokami
  fill_standard_blocks(@blocks_id);

  //inicializiruem massiv zameni blokov
  setlength(blocks_change_id,0);

  //zapolnaem mnozhestva blokov
  fill_sets;

  //inicializiruem priznak ostanovki generacii
  gen_stopped:=false;

  //inicializiruem status generacii
  gen_status:=0;

  //ochishaem vse hendli potokov
  setlength(gen_threads,0);
  setlength(init_threads,0);
  wait_init_thread_hndl:=0;
  wait_level_thread_hndl:=0;

  //zapis' versii programmi v leybl
  //str:=FileVersion(paramstr(0));
  if str='10.100.1000.0' then main.Label19.Caption:='MCTerra debug version'
  else main.Label19.Caption:='MCTerra v'+str;

  //inicializiruem random dla sida i sid
  map_sid_rnd:=rnd.Create;
  if save_opt.save_enabled=true then
    map_sid:=save_opt.sid
  else
    map_sid:=map_sid_rnd.nextLong;
  main.Edit2.Text:=inttostr(map_sid);


  //zadaem shirinu melkih paneley dla pervogo statusbara
  main.StatusBar1.Panels.Items[0].Width:=round((main.StatusBar1.Width/100)*21.829);
  main.StatusBar1.Panels.Items[1].Width:=round((main.StatusBar1.Width/100)*33.942);
  main.StatusBar1.Panels.Items[2].Width:=round((main.StatusBar1.Width/100)*28.428);
  //zadaem shirinu melkih paneley dla vtorogo statusbara
  main.StatusBar2.Panels.Items[0].Width:=round((main.StatusBar1.Width/100)*21.829);
  main.StatusBar2.Panels.Items[1].Width:=round((main.StatusBar1.Width/100)*33.942);
  main.StatusBar2.Panels.Items[2].Width:=round((main.StatusBar1.Width/100)*28.428);
  //zadaem shirinu melkih paneley dla tret'ego statusbara
  main.StatusBar3.Panels.Items[0].Width:=round((main.StatusBar1.Width/100)*21.829);
  main.StatusBar3.Panels.Items[1].Width:=round((main.StatusBar1.Width/100)*33.942);
  main.StatusBar3.Panels.Items[2].Width:=round((main.StatusBar1.Width/100)*28.428);

  //prisvaivaem ustanovlenniy shrift nuzhnim leyblam
  main.Label19.Font.Name:='FMPTSR-Credits';
  main.Label20.Font.Name:='FMPTSR-Credits';
  main.Label21.Font.Name:='FMPTSR-Credits';
  main.Label22.Font.Name:='FMPTSR-Credits';
  main.Label23.Font.Name:='FMPTSR-Credits';

  main.Label26.Font.Name:='FMPTSR-Credits';
  main.Label27.Font.Name:='FMPTSR-Credits';
  main.Label28.Font.Name:='FMPTSR-Credits';
  main.Label29.Font.Name:='FMPTSR-Credits';
  main.Label30.Font.Name:='FMPTSR-Credits';

  main.Label31.Font.Name:='FMPTSR-Credits';
  main.Label32.Font.Name:='FMPTSR-Credits';
  main.Label33.Font.Name:='FMPTSR-Credits';
  main.Label34.Font.Name:='FMPTSR-Credits';
  main.Label35.Font.Name:='FMPTSR-Credits';


  //vstavlaem progressbari v statusbari
  with ProgressBar1 do
  begin
    Parent := StatusBar1;
    //Position := ;
    Top := 2;
    Left := 0;
    Height := StatusBar1.Height - Top;
    Width := StatusBar1.Panels[0].Width - Left;
  end;
  with ProgressBar2 do
  begin
    Parent := StatusBar2;
    //Position := ;
    Top := 2;
    Left := 0;
    Height := StatusBar2.Height - Top;
    Width := StatusBar2.Panels[0].Width - Left;
  end;
  with ProgressBar3 do
  begin
    Parent := StatusBar3;
    //Position := ;
    Top := 2;
    Left := 0;
    Height := StatusBar3.Height - Top;
    Width := StatusBar3.Panels[0].Width - Left;
  end;

//perviy statusbar
  //vstavlaem perviy label s statusbar1
  main.Label22.Parent:=statusbar1;              //generationg chunk
  main.Label22.Top:=3;
  main.Label22.Left:=main.StatusBar1.Panels.Items[0].Width+5;
  main.Label22.Height:=StatusBar1.Height - label22.Top-1;   
  //vstavlaem vtoroy label v statusbar1
  main.Label20.Parent:=statusbar1;              //10000
  main.Label20.Top:=3;
  main.Label20.Height:=StatusBar1.Height - label20.Top-1;
  //vstavlaem tretiy label v statusbar1
  main.Label21.Parent:=statusbar1;              //out of 10000
  main.Label21.Top:=3;
  main.Label21.Height:=StatusBar1.Height - label21.Top-1;
  //viravnivaem leybli
  allign_labels1;
  //vstavlaem chetvertiy label v statusbar1
  main.Label23.Parent:=statusbar1;              //generating chunks in region 0,0
  main.Label23.Top:=3;
  main.Label23.Left:=main.StatusBar1.Panels.Items[0].Width+main.StatusBar1.Panels.Items[1].Width+5;
  main.Label23.Height:=StatusBar1.Height - label23.Top-1;
  //vstavlaem versiyu s statusbar1
  main.Label19.Parent:=statusbar1;              //version
  main.Label19.Top:=3;
  main.Label19.Left:=main.StatusBar1.Panels.Items[0].Width+main.StatusBar1.Panels.Items[1].Width+main.StatusBar1.Panels.Items[2].Width+5;
  main.Label19.Height:=StatusBar1.Height - label19.Top-1;

//vtoroy statusbar
  //vstavlaem perviy label s statusbar2
  main.Label29.Parent:=statusbar2;              //generationg chunk
  main.Label29.Top:=3;
  main.Label29.Left:=main.StatusBar2.Panels.Items[0].Width+5;
  main.Label29.Height:=StatusBar2.Height - label29.Top-1;
  //vstavlaem vtoroy label v statusbar2
  main.Label27.Parent:=statusbar2;              //10000
  main.Label27.Top:=3;
  main.Label27.Height:=StatusBar2.Height - label27.Top-1;
  //vstavlaem tretiy label v statusbar2
  main.Label28.Parent:=statusbar2;              //out of 10000
  main.Label28.Top:=3;
  main.Label28.Height:=StatusBar2.Height - label28.Top-1;
  //viravnivaem leybli
  allign_labels2;
  //vstavlaem chetvertiy label v statusbar2
  main.Label30.Parent:=statusbar2;              //generating chunks in region 0,0
  main.Label30.Top:=3;
  main.Label30.Left:=main.StatusBar2.Panels.Items[0].Width+main.StatusBar2.Panels.Items[1].Width+5;
  main.Label30.Height:=StatusBar2.Height - label30.Top-1;
  //vstavlaem versiyu s statusbar2
  main.Label26.Parent:=statusbar2;              //version
  main.Label26.Top:=3;
  main.Label26.Left:=main.StatusBar2.Panels.Items[0].Width+main.StatusBar2.Panels.Items[1].Width+main.StatusBar2.Panels.Items[2].Width+5;
  main.Label26.Height:=StatusBar2.Height - label26.Top-1;

//tretiy statusbar
  //vstavlaem perviy label s statusbar3
  main.Label34.Parent:=statusbar3;              //generationg chunk
  main.Label34.Top:=3;
  main.Label34.Left:=main.StatusBar3.Panels.Items[0].Width+5;
  main.Label34.Height:=StatusBar3.Height - label34.Top-1;
  //vstavlaem vtoroy label v statusbar3
  main.Label32.Parent:=statusbar3;              //10000
  main.Label32.Top:=3;
  main.Label32.Height:=StatusBar3.Height - label32.Top-1;
  //vstavlaem tretiy label v statusbar3
  main.Label33.Parent:=statusbar3;              //out of 10000
  main.Label33.Top:=3;
  main.Label33.Height:=StatusBar3.Height - label33.Top-1;
  //viravnivaem leybli
  allign_labels3;
  //vstavlaem chetvertiy label v statusbar3
  main.Label35.Parent:=statusbar3;              //generating chunks in region 0,0
  main.Label35.Top:=3;
  main.Label35.Left:=main.StatusBar3.Panels.Items[0].Width+main.StatusBar3.Panels.Items[1].Width+5;
  main.Label35.Height:=StatusBar3.Height - label35.Top-1;
  //vstavlaem versiyu s statusbar3
  main.Label31.Parent:=statusbar3;              //version
  main.Label31.Top:=3;
  main.Label31.Left:=main.StatusBar3.Panels.Items[0].Width+main.StatusBar3.Panels.Items[1].Width+main.StatusBar3.Panels.Items[2].Width+5;
  main.Label31.Height:=StatusBar3.Height - label31.Top-1;

  //ochishaem paneli pri pomoshi soobsheniy
  postmessage(main.Handle,WM_USER+300,0,0);
  postmessage(main.Handle,WM_USER+300,1,0);
  postmessage(main.Handle,WM_USER+300,2,0);

  //razvorachivaem formu pri otladke
  main.CheckBox3Click(self);

  //viravnivaem okno poseredine ekrana
  {main.Left:=round(screen.Width/2-main.Width/2);
  main.Top:=round(screen.Height/2-main.Height/2); }
  main.Top:=save_opt.main_f.top;
  main.Left:=save_opt.main_f.left;
end;

procedure Tmain.FormDestroy(Sender: TObject);
begin
  map_sid_rnd.Free;
end;

procedure Tmain.Button2Click(Sender: TObject);
begin
  map_sid:=map_sid_rnd.nextLong;
  main.Edit2.Text:=inttostr(map_sid);
end;

procedure Tmain.Edit2Exit(Sender: TObject);
begin
  if proverka_int64(main.Edit2.Text)=true then
  begin
    application.MessageBox('You have entered wrong SID.'+#13+#10+'SID must be between -9223372036854775808 and 9223372036854775807','Error');
    main.Edit2.SelStart:=0;
    main.Edit2.SelLength:=length(main.Edit2.Text);
    main.Edit2.SetFocus;
    exit;
  end;

  map_sid:=strtoint64(main.Edit2.Text);
end;

procedure Tmain.Edit2KeyPress(Sender: TObject; var Key: Char);
var str:string;
begin
  if (key=#24)or(key=#3)or(key=#22) then exit;

  if not(((key>=#48)and(key<=#57))or(key=#45)or(key=#8)or(key=#46)) then
  begin
    key:=#0;
    exit;
  end;

  if (main.Edit2.SelStart<>0)and(key=#45) then
  begin
    key:=#0;
    exit;
  end;

  str:=main.Edit2.Text;
  if (length(str)>=20)and(key<>#8)and(key<>#46)and(main.Edit2.SelLength<1) then key:=#0;
end;

procedure Tmain.Edit2Change(Sender: TObject);
var str:string;
i:integer;
begin
  str:=main.Edit2.Text;
  if length(str)>=21 then
  begin
    setlength(str,21);
    main.Edit2.Text:=str;
  end;

  i:=posex('-',str,2);
  if i<>0 then
  begin
    while i<>0 do
    begin
      delete(str,i,1);
      i:=posex('-',str,2);
    end;
    main.Edit2.Text:=str;
  end;
end;

procedure Tmain.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if not(((key>=#48) and (key<=#57))
  or (key=#8)
  or ((key>=#65) and (key<=#90))
  or ((key>=#97) and (key<=#122))
  or (key=#95)) then key:=#0;
end;

procedure Tmain.CheckBox3Click(Sender: TObject);
begin
  if main.CheckBox3.Checked then
  begin
    if main.Height<500 then main.Height:=main.Height+250;
    main.Memo1.Visible:=true;
  end
  else
  begin
    if main.Height>650 then main.Height:=main.Height-250;
    main.Memo1.Visible:=false;
  end;
end;

procedure Tmain.Button5Click(Sender: TObject);
begin
  if landscape_plugins[land_sel].active then
  begin
    //formiruem nastroyki karti
    generation_settings.Landscape_gen:=landscape_plugins[land_sel].plugrec;
    generation_settings.Border_gen:=border_plugins[border_sel].plugrec;
    generation_settings.Buildings_gen:=structures_plugins[struct_sel].plugrec;
    path_str:='';
    name_str:=main.Edit1.Text;
    generation_settings.Path:=pchar(path_str);
    generation_settings.Name:=pchar(name_str);
    generation_settings.Map_type:=main.ComboBox1.ItemIndex;
    generation_settings.Width:=strtoint(main.Edit3.Text);
    generation_settings.Length:=strtoint(main.Edit4.Text);
    generation_settings.Game_type:=main.ComboBox2.ItemIndex;
    generation_settings.SID:=map_sid;
    generation_settings.Populate_chunks:=main.CheckBox1.Checked;
    generation_settings.Generate_structures:=main.CheckBox2.Checked;
    generation_settings.Game_time:=convert_time(strtoint(main.Edit8.Text),strtoint(main.Edit9.Text));
    case main.ComboBox3.ItemIndex of
    0:begin
        generation_settings.Raining:=false;
        generation_settings.Thundering:=false;
      end;
    1:begin
        generation_settings.Raining:=true;
        generation_settings.Thundering:=false;
      end;
    2:begin
        generation_settings.Raining:=true;
        generation_settings.Thundering:=true;
      end;
    end;
    //perevodim iz sekund v takti minecrafta
    generation_settings.Rain_time:=strtoint(main.Edit5.Text)*20;
    generation_settings.Thunder_time:=strtoint(main.Edit6.Text)*20;
    
    generation_settings.Files_size:=0;
    generation_settings.Spawn_pos[0]:=0;
    generation_settings.Spawn_pos[1]:=64;
    generation_settings.Spawn_pos[2]:=0;
    
    landscape_plugins[land_sel].show_settings_wnd(generation_settings);
  end;
end;

procedure Tmain.ComboBox4Change(Sender: TObject);
var i:integer;
rect:TRect;
begin
  if length(landscape_plugins)=0 then exit;

  i:=main.ComboBox4.ItemIndex;
  main.Label18.Caption:=landscape_plugins[i].plug_full_name;
  main.Label17.Caption:=landscape_plugins[i].plug_author;
  main.Label16.Caption:=landscape_plugins[i].plug_version;
  main.Label25.Caption:=landscape_plugins[i].plug_file;

  land_sel:=i;

  if landscape_plugins[i].active=false then
  begin
    main.Label36.Visible:=true;
    main.Button9.Enabled:=false;
  end
  else
  begin
    main.Label36.Visible:=false;
    main.Button9.Enabled:=true;
  end;

  if landscape_plugins[i].info.has_preview then
    main.Image1.Canvas.Draw(0,0,landscape_plugins[i].preview)
  else
  begin
    rect.Left:=0;
    rect.Top:=0;
    rect.Bottom:=200;
    rect.Right:=250;
    main.Image1.Canvas.FillRect(rect);
    main.Image1.Canvas.TextOut(80,90,'No preview available');
  end;
end;

procedure Tmain.About1Click(Sender: TObject);
begin
  about.ShowModal;
end;

procedure Tmain.Button7Click(Sender: TObject);
begin
  application.MessageBox('Not ready yet','');
end;

procedure Tmain.Button6Click(Sender: TObject);
begin
  border.ShowModal;
end;

procedure Tmain.ComboBox1Change(Sender: TObject);
begin
  if main.ComboBox1.ItemIndex=0 then
  begin
    main.Edit4.Text:=main.Edit3.Text;
    main.Label4.Enabled:=false;
    main.Edit4.Enabled:=false;
    main.Button9.Enabled:=true;
  end
  else
  if main.ComboBox1.ItemIndex=2 then
  begin
    main.Button9.Enabled:=false;
  end
  else
  begin
    main.Label4.Enabled:=true;
    main.Edit4.Enabled:=true;
    main.Button9.Enabled:=true;
  end;
end;

procedure Tmain.Edit3Change(Sender: TObject);
begin
  if main.ComboBox1.ItemIndex=0 then
    main.Edit4.Text:=main.Edit3.Text;
end;

procedure Tmain.FormShow(Sender: TObject);
begin
  main.ComboBox1Change(self);
end;

procedure Tmain.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
  if not(((key>=#48) and (key<=#57))or (key=#8)) then key:=#0;
end;

procedure Tmain.Edit4KeyPress(Sender: TObject; var Key: Char);
begin
  if not(((key>=#48) and (key<=#57))or (key=#8)) then key:=#0;
end;

procedure Tmain.Edit8KeyPress(Sender: TObject; var Key: Char);
var str:string;
begin
  if not(((key>=#48) and (key<=#57))or (key=#8)) then
  begin
    key:=#0;
    exit;
  end;

  str:=main.Edit8.Text;
  if (length(str)>=2)and(key<>#8)and(key<>#46)and(main.Edit8.SelLength<1) then key:=#0;
end;

procedure Tmain.Edit9KeyPress(Sender: TObject; var Key: Char);
var str:string;
begin
  if not(((key>=#48) and (key<=#57))or (key=#8)) then
  begin
    key:=#0;
    exit;
  end;

  str:=main.Edit9.Text;
  if (length(str)>=2)and(key<>#8)and(key<>#46)and(main.Edit9.SelLength<1) then key:=#0;
end;

procedure Tmain.Edit5KeyPress(Sender: TObject; var Key: Char);
var str:string;
begin
  if (key=#24)or(key=#3)or(key=#22) then exit;

  if not(((key>=#48)and(key<=#57))or(key=#8)or(key=#46)) then
  begin
    key:=#0;
    exit;
  end;

  str:=main.Edit5.Text;
  if (length(str)>=8)and(key<>#8)and(key<>#46)and(main.Edit5.SelLength<1) then key:=#0;
end;

procedure Tmain.Edit6KeyPress(Sender: TObject; var Key: Char);
var str:string;
begin
  if (key=#24)or(key=#3)or(key=#22) then exit;

  if not(((key>=#48)and(key<=#57))or(key=#8)or(key=#46)) then
  begin
    key:=#0;
    exit;
  end;

  str:=main.Edit6.Text;
  if (length(str)>=8)and(key<>#8)and(key<>#46)and(main.Edit6.SelLength<1) then key:=#0;
end;

procedure Tmain.Edit8Exit(Sender: TObject);
var i:integer;
begin
  if main.Edit8.Text='' then
  begin
    i:=0;
    main.Edit8.Text:='0';
  end
  else i:=strtoint(main.Edit8.Text);
  if (i>23)or(i<0) then
  begin
    application.MessageBox('Hours must be between 0 and 23','Error');
    main.Edit8.SelStart:=0;
    main.Edit8.SelLength:=length(main.Edit8.Text);
    main.Edit8.SetFocus;
    exit;
  end;
end;

procedure Tmain.Edit9Exit(Sender: TObject);
var i:integer;
begin
  if main.Edit9.Text='' then
  begin
    i:=0;
    main.Edit9.Text:='0';
  end
  else i:=strtoint(main.Edit9.Text);
  if (i>59)or(i<0) then
  begin
    application.MessageBox('Minutes must be between 0 and 59','Error');
    main.Edit9.SelStart:=0;
    main.Edit9.SelLength:=length(main.Edit9.Text);
    main.Edit9.SetFocus;
    exit;
  end;
end;

procedure Tmain.Edit5Exit(Sender: TObject);
begin
  if main.Edit5.Text='' then
    main.Edit5.Text:='2500';
end;

procedure Tmain.Edit5Change(Sender: TObject);
var str:string;
begin
  str:=main.Edit5.Text;
  if length(str)>=8 then
  begin
    setlength(str,8);
    main.Edit5.Text:=str;
  end;
end;

procedure Tmain.Edit6Exit(Sender: TObject);
begin
  if main.Edit6.Text='' then
    main.Edit6.Text:='8000';
end;

procedure Tmain.Edit6Change(Sender: TObject);
var str:string;
begin
  str:=main.Edit6.Text;
  if length(str)>=8 then
  begin
    setlength(str,8);
    main.Edit6.Text:=str;
  end;
end;

procedure Tmain.Loadedplugins1Click(Sender: TObject);
var str:string;
i:integer;
begin
  str:='Landscape plugins:'+#13+#10;
  if length(landscape_plugins)=0 then
    str:=str+'None'+#13+#10
  else
  for i:=0 to length(landscape_plugins)-1 do
    str:=str+landscape_plugins[i].plug_full_name+' in file "'+landscape_plugins[i].plug_file+'" ("'+landscape_plugins[i].plug_name+'"), Author:'+landscape_plugins[i].plug_author+', Version:'+landscape_plugins[i].plug_version+#13+#10;

  str:=str+#13+#10;

  str:=str+'Border plugins:'+#13+#10;
  if length(border_plugins)=0 then
    str:=str+'None'+#13+#10
  else
  for i:=0 to length(border_plugins)-1 do
    str:=str+border_plugins[i].plug_full_name+' in file "'+border_plugins[i].plug_file+'" ("'+border_plugins[i].plug_name+'"), Author:'+border_plugins[i].plug_author+', Version:'+border_plugins[i].plug_version+#13+#10;

  str:=str+#13+#10;

  str:=str+'Structure plugins:'+#13+#10;
  if length(structures_plugins)=0 then
    str:=str+'None'
  else
  for i:=0 to length(structures_plugins)-1 do
    str:=str+structures_plugins[i].plug_full_name+' in file "'+structures_plugins[i].plug_file+'" ("'+structures_plugins[i].plug_name+'"), Author:'+structures_plugins[i].plug_author+', Version:'+structures_plugins[i].plug_version+#13+#10;

  application.MessageBox(pchar(str),'Info');
end;

procedure Tmain.Button3Click(Sender: TObject);
begin
  application.MessageBox('Not ready yet','');
end;

procedure Tmain.Button4Click(Sender: TObject);
var i:integer;
begin
  if blocks.ShowModal=mrOK then
  begin
    for i:=0 to length(landscape_plugins)-1 do
      landscape_plugins[i].set_block_id(blocks_id);
    for i:=1 to length(border_plugins)-1 do
      border_plugins[i].set_block_id(blocks_id);
    for i:=1 to length(structures_plugins)-1 do
      structures_plugins[i].set_block_id(blocks_id);

    fill_sets;
  end;
end;

procedure Tmain.Button9Click(Sender: TObject);
var str:string;
i:integer;
id:cardinal;
search:_WIN32_FIND_DATAA;
begin
  //pokachto prisvaivaem tekushemu plaginu struktur 0, t.k. dannie plagini ne rabotayut
  struct_sel:=0;

  //proverka na maksimum i minimum
  if (strtoint(main.Edit3.Text)<10)or(strtoint(main.Edit3.Text)>30000)or
  (strtoint(main.Edit4.Text)<10)or(strtoint(main.Edit4.Text)>30000) then
  begin
    application.MessageBox('Size of the map must be between 10 and 30000 chunks','Error');
    exit;
  end;

  //proverka na chetnost'
  if ((strtoint(main.Edit3.Text) mod 2)<>0) or((strtoint(main.Edit4.Text) mod 2)<>0) then
  begin
    application.MessageBox('You must enter even number in map size section','Error');
    exit;
  end;

  //izmenaem nazvanie fayla tak, chtobi ono bilo kak nazvanie karti
  main.SaveDialog1.FileName:=main.Edit1.Text+'.dat';

  //vizivaem dialog
  if main.SaveDialog1.Execute then
  begin
    str:=main.SaveDialog1.FileName;
    //izvlekaem put'
    main.Memo1.Lines.Add('Raw path:'+str);
    str:=extractfilepath(str);
    main.Memo1.Lines.Add('Path:'+str);

    //proverka na sushestvovanie karti (tochnee fayla level.dat)
    if fileexists(str+main.Edit1.Text+'\level.dat') then
      if messagedlg('Map already exists. Are you sure you want to rewrite it?',mtConfirmation,mbOKCancel,0)=mrCancel then
        exit;

    //udalit' fayli regionov v papke, esli papka est'
    if directoryexists(str+main.Edit1.Text+'\region') then
    begin
      main.Memo1.Lines.Add('Directory "region" exists, trying to delete region files');
      id:=findfirstfile(pchar(str+main.Edit1.Text+'\region\*.mca'),search);
      if id<>INVALID_HANDLE_VALUE then
      begin
        repeat
          windows.deletefile(pchar(str+main.Edit1.Text+'\region\'+search.cFileName));
        until findnextfile(id,search)=false;
        Windows.findclose(i);
      end;
    end;

    //izmenaem status generacii
    gen_status:=1;

    //formiruem nastroyki karti
    generation_settings.Landscape_gen:=landscape_plugins[land_sel].plugrec;
    generation_settings.Border_gen:=border_plugins[border_sel].plugrec;
    generation_settings.Buildings_gen:=structures_plugins[struct_sel].plugrec;
    path_str:=str;
    name_str:=main.Edit1.Text;
    generation_settings.Path:=pchar(path_str);
    generation_settings.Name:=pchar(name_str);
    generation_settings.Map_type:=main.ComboBox1.ItemIndex;
    generation_settings.Width:=strtoint(main.Edit3.Text);
    generation_settings.Length:=strtoint(main.Edit4.Text);
    generation_settings.border_in:=0;
    generation_settings.border_out:=0;
    generation_settings.Game_type:=main.ComboBox2.ItemIndex;
    generation_settings.SID:=map_sid;
    generation_settings.Populate_chunks:=main.CheckBox1.Checked;
    generation_settings.Generate_structures:=main.CheckBox2.Checked;
    generation_settings.Game_time:=convert_time(strtoint(main.Edit8.Text),strtoint(main.Edit9.Text));
    case main.ComboBox3.ItemIndex of
    0:begin
        generation_settings.Raining:=false;
        generation_settings.Thundering:=false;
      end;
    1:begin
        generation_settings.Raining:=true;
        generation_settings.Thundering:=false;
      end;
    2:begin
        generation_settings.Raining:=true;
        generation_settings.Thundering:=true;
      end;
    end;
    //perevodim iz sekund v takti minecrafta
    generation_settings.Rain_time:=strtoint(main.Edit5.Text)*20;
    generation_settings.Thunder_time:=strtoint(main.Edit6.Text)*20;
    
    generation_settings.Files_size:=0;
    generation_settings.Spawn_pos[0]:=0;
    generation_settings.Spawn_pos[1]:=64;
    generation_settings.Spawn_pos[2]:=0;

    gen_stopped:=false;
    gen_timestamp:=getcurrenttime;

    disable_controls;

    setlength(init_threads,1);
    init_threads[0]:=0;
    //for i:=0 to 2 do
    //  init_threads[i]:=0;


    init_threads[0]:=beginthread(nil,0,@init_thread,@landscape_plugins[land_sel],0,id);
    //if length(border_plugins)<>0 then
    if border_sel<>0 then
    begin
      setlength(init_threads,length(init_threads)+1);
      init_threads[length(init_threads)-1]:=beginthread(nil,0,@init_thread,@border_plugins[border_sel],0,id);
    end;
    //if length(structures_plugins)<>0 then
    if struct_sel<>0 then
    begin
      setlength(init_threads,length(init_threads)+1);
      init_threads[length(init_threads)-1]:=beginthread(nil,0,@init_thread,@structures_plugins[struct_sel],0,id);
    end;

    wait_init_thread_hndl:=beginthread(nil,0,@wait_init_thread,nil,0,id);

    //izmenaem status generacii
    gen_status:=2;
  end;
end;

procedure Tmain.Edit3Exit(Sender: TObject);
begin
  if main.Edit3.Text='' then main.Edit3.Text:='20';
end;

procedure Tmain.Edit4Exit(Sender: TObject);
begin
  if main.Edit4.Text='' then main.Edit4.Text:='20';
end;

procedure Tmain.Button13Click(Sender: TObject);
var id:cardinal;
begin
  stop_thread_hndl:=beginthread(nil,0,@stop_gen_thread,nil,0,id);
  main.Button13.Enabled:=false;
end;

procedure Tmain.ComboBox1Exit(Sender: TObject);
begin
  {application.MessageBox('This map type is not supported','Test');
  main.ComboBox1.SetFocus;
  main.ComboBox1.DroppedDown:=true;   }
end;

procedure Tmain.Button17Click(Sender: TObject);
var i:integer;
str:string;
begin
  {trans_bl:=[];
  light_bl:=[];
  diff_bl:=[];
  solid_bl:=[];
  for i:=0 to length(blocks_id)-1 do
  begin
    if blocks_id[i].transparent then include(trans_bl,i);
    if blocks_id[i].light_level>0 then include(light_bl,i);
    if blocks_id[i].diffuse then include(diff_bl,i);
    if blocks_id[i].solid then include(solid_bl,i);
  end;  }

  str:='';
  for i:=low(for_set) to high(for_set) do
  begin
    if (i in trans_bl) then str:=str+inttostr(i)+',';
  end;
  main.Memo1.Lines.Add('Trans blocks: '+str);

  str:='';
  for i:=low(for_set) to high(for_set) do
  begin
    if (i in light_bl) then str:=str+inttostr(i)+',';
  end;
  main.Memo1.Lines.Add('Light blocks: '+str);

  str:='';
  for i:=low(for_set) to high(for_set) do
  begin
    if (i in diff_bl) then str:=str+inttostr(i)+',';
  end;
  main.Memo1.Lines.Add('Diffuse blocks: '+str);

  str:='';
  for i:=low(for_set) to high(for_set) do
  begin
    if (i in solid_bl) then str:=str+inttostr(i)+',';
  end;
  main.Memo1.Lines.Add('Solid blocks: '+str);
end;

procedure Tmain.Button12Click(Sender: TObject);
var t:_SYSTEM_INFO;
i,j:cardinal;
int:integer;
b:longbool;
begin
  main.Memo1.Lines.Add('------------');
  //beginthread
  getsysteminfo(t);
  main.Memo1.Lines.Add('OEM id='+inttostr(t.dwOemId));
  main.Memo1.Lines.Add('Arcitecture='+inttostr(t.wProcessorArchitecture));
  main.Memo1.Lines.Add('Pagesize='+inttostr(t.dwPageSize));
  main.Memo1.Lines.Add('Active processor mask='+inttostr(t.dwActiveProcessorMask));
  main.Memo1.Lines.Add('Processor number='+inttostr(t.dwNumberOfProcessors));
  main.Memo1.Lines.Add('Proc. type='+inttostr(t.dwProcessorType));
  main.Memo1.Lines.Add('AllocationGranularity='+inttostr(t.dwAllocationGranularity));
  main.Memo1.Lines.Add('Proc. level='+inttostr(t.wProcessorLevel));
  main.Memo1.Lines.Add('Proc. revision='+inttostr(t.wProcessorRevision));

  i:=GetPriorityClass(GetCurrentProcess);
  main.Memo1.Lines.Add('Priority:');
  case i of
    HIGH_PRIORITY_CLASS:main.Memo1.Lines.Add('Process has high priority ('+inttohex(i,8)+')');
    NORMAL_PRIORITY_CLASS:main.Memo1.Lines.Add('Process has normal priority ('+inttohex(i,8)+')');
    IDLE_PRIORITY_CLASS:main.Memo1.Lines.Add('Process has idle priority ('+inttohex(i,8)+')');
    REALTIME_PRIORITY_CLASS:main.Memo1.Lines.Add('Process has realtime priority ('+inttohex(i,8)+')')
    else
      main.Memo1.Lines.Add('Process priority='+inttohex(i,8));
  end;

  main.Memo1.Lines.Add('AffinityMask:');
  if GetProcessAffinityMask(getcurrentprocess,i,j)=true then
  begin
    main.Memo1.Lines.Add('Process affinitymask:'+inttostr(i));
    main.Memo1.Lines.Add('Systemaffinitymask:'+inttostr(j));
  end
  else
    main.Memo1.Lines.Add('GetAffinityMask failed');

  int:=GetThreadPriority(getcurrentthread);
  main.Memo1.Lines.Add('Thread priority:');
  case int of
    THREAD_PRIORITY_ABOVE_NORMAL:main.Memo1.Lines.Add('Above normal:'+inttostr(int));
    THREAD_PRIORITY_BELOW_NORMAL:main.Memo1.Lines.Add('Below normal:'+inttostr(int));
    THREAD_PRIORITY_HIGHEST:main.Memo1.Lines.Add('Highest:'+inttostr(int));
    THREAD_PRIORITY_IDLE:main.Memo1.Lines.Add('IDLE:'+inttostr(int));
    THREAD_PRIORITY_LOWEST:main.Memo1.Lines.Add('Lowest:'+inttostr(int));
    THREAD_PRIORITY_NORMAL:main.Memo1.Lines.Add('Normal:'+inttostr(int));
    THREAD_PRIORITY_TIME_CRITICAL:main.Memo1.Lines.Add('Time critical:'+inttostr(int));
    else
      main.Memo1.Lines.Add('Unknown priority:'+inttostr(int));
  end;

  GetProcessPriorityBoost(getcurrentprocess,b);
  main.Memo1.Lines.Add('Disable priority boost:'+booltostr(b,true));
end;

procedure Tmain.Button16Click(Sender: TObject);
var MS: TMemoryStatus;
begin
  ms.dwLength:=sizeof(TMemoryStatus);
  GlobalMemoryStatus(MS);

  main.Memo1.Lines.Add('Memory load:'+inttostr(ms.dwMemoryLoad));
  main.Memo1.Lines.Add('Total phys:'+inttostr(ms.dwTotalPhys));
  main.Memo1.Lines.Add('Avail phys:'+inttostr(ms.dwAvailPhys));
  main.Memo1.Lines.Add('Spend phys:'+inttostr(ms.dwTotalPhys-ms.dwAvailPhys));
  main.Memo1.Lines.Add('Total page file:'+inttostr(ms.dwTotalPageFile));
  main.Memo1.Lines.Add('Avail page file:'+inttostr(ms.dwAvailPageFile));
  main.Memo1.Lines.Add('Spend page file:'+inttostr(ms.dwTotalPageFile-ms.dwAvailPageFile));
  main.Memo1.Lines.Add('Total virtual:'+inttostr(ms.dwTotalVirtual));
  main.Memo1.Lines.Add('Avail virtual:'+inttostr(ms.dwAvailVirtual));
  main.Memo1.Lines.Add('Spend virtual:'+inttostr(ms.dwTotalVirtual-ms.dwAvailVirtual));
end;

procedure Tmain.Options1Click(Sender: TObject);
begin
  options.ShowModal;
end;

procedure Tmain.Button10Click(Sender: TObject);
begin
  main.Memo1.Lines.Add('Save type='+inttostr(save_opt.save_type));
end;

procedure Tmain.FormClose(Sender: TObject; var Action: TCloseAction);
var f:tinifile;
begin
  //sohranaem nastroyki esli nuzhno
  if save_opt.save_enabled then
  begin
    if (save_opt.save_type=0)and(save_opt.change_disabled=false) then  //INI
    begin
      (*f:=tinifile.Create(extractfilepath(paramstr(0))+'MCTerra.ini');
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

      f.Free;  *)
      save_options_ini;
    end
    else
    begin  //REGISTRY
    end;
  end
  else
  begin
    if fileexists(extractfilepath(paramstr(0))+'MCTerra.ini')=true then
    begin
      f:=tinifile.Create(extractfilepath(paramstr(0))+'MCTerra.ini');
      f.WriteBool('General','EnableSave',false);
      f.Free;
    end;
  end;
end;

end.

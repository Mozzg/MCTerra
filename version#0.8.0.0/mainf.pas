unit mainf;

interface

uses Forms, Classes, windows, Menus, SysUtils,
   generation_obsh, StdCtrls, Controls, jpeg, ExtCtrls, ComCtrls,
   NBT, Dialogs;                     

type
  Tmain = class(TForm)
    MainMenu1: TMainMenu;
    About1: TMenuItem;
    File1: TMenuItem;
    About2: TMenuItem;
    Exit1: TMenuItem;
    GroupBox1: TGroupBox;
    Button1: TButton;
    Memo1: TMemo;
    Button9: TButton;
    SaveDialog1: TSaveDialog;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    GroupBox3: TGroupBox;
    ProgressBar1: TProgressBar;
    StatusBar1: TStatusBar;
    Label4: TLabel;
    Label5: TLabel;
    Button10: TButton;
    GroupBox4: TGroupBox;
    ComboBox1: TComboBox;
    Image1: TImage;
    GroupBox5: TGroupBox;
    flatmap_p: TImage;
    like_notch_p: TImage;
    settings_p: TImage;
    desert_p: TImage;
    floating_islands_p: TImage;
    planetoids_p: TImage;
    biospheres_p: TImage;
    Panel1: TPanel;
    GroupBox6: TGroupBox;
    Button2: TButton;
    GroupBox7: TGroupBox;
    Button3: TButton;
    GroupBox8: TGroupBox;
    Button4: TButton;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Edit4: TEdit;
    Button6: TButton;
    tunnels_p: TImage;
    Label9: TLabel;
    Button8: TButton;
    Button13: TButton;
    CheckBox2: TCheckBox;
    Label10: TLabel;
    ComboBox2: TComboBox;
    CheckBox3: TCheckBox;
    Label11: TLabel;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    Label12: TLabel;
    Edit6: TEdit;
    Edit7: TEdit;
    GroupBox9: TGroupBox;
    Label13: TLabel;
    Label14: TLabel;
    Edit8: TEdit;
    Edit9: TEdit;
    Button14: TButton;
    Button5: TButton;
    procedure Exit1Click(Sender: TObject);
    procedure About2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure CheckBox1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure AppMes(var Msg: TMsg; var Handled: Boolean);
    procedure Button10Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
    procedure Edit4Change(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Edit4Exit(Sender: TObject);
    procedure Edit6KeyPress(Sender: TObject; var Key: Char);
    procedure Edit7KeyPress(Sender: TObject; var Key: Char);
    procedure CheckBox4Click(Sender: TObject);
    procedure Edit8KeyPress(Sender: TObject; var Key: Char);
    procedure Edit9KeyPress(Sender: TObject; var Key: Char);
    procedure Edit8Exit(Sender: TObject);
    procedure Edit9Exit(Sender: TObject);
    procedure Edit6Exit(Sender: TObject);
    procedure Edit6Change(Sender: TObject);
    procedure Edit7Change(Sender: TObject);
    procedure Edit7Exit(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
  flatmap_prop:flatmap_settings_type;
  border_prop:border_settings_type;
  planet_prop:planetoids_settings_type;
  tunnel_prop:tunnels_settings_type;
  biosfer_prop:bio_settings_type;
  biomes_desert_prop:biomes_desert_settings_type;
  original_prop:original_settings_type;
  level_settings:level_set;
    { Public declarations }
  end;

var
  main: Tmain;

const time_const:extended=1000/60;

procedure Delay(ms:cardinal);    

implementation

uses aboutf, flatmap_propf, border_propf, math, planetoids_propf,
  tunnels_propf, load_sidf, biosphere_propf, RandomMCT, playerf, generation,
  NoiseGeneratorOctaves_u, previewf, desert_propf,
  ChunkProviderGenerate_u, BiomeGenBase_u;

type TColor = -$7FFFFFFF-1..$7FFFFFFF;

const clSystemColor = $FF000000;
  clBlack = TColor($000000);
  clGray = TColor($808080);
  clBtnFace = TColor(clSystemColor or COLOR_BTNFACE);
  clWhite = TColor($FFFFFF);

var kol1,kol2,kol3,kol4:integer;
pos1,pos2,pos3,pos4:integer;
tun_kol:integer;
time:longint;
hndl:integer;
wait_hndl:integer;
id:cardinal;
thread_exit:boolean;
thread_exit_type:integer;
sid_rand:rnd;

procedure Delay(ms:cardinal);
var time:cardinal;
begin
  time:=GetTickCount+ms;
  while (time>GetTickCount)and not(Application.Terminated) do
    application.ProcessMessages;
end;

{$R *.dfm}

{type
  PRGBTripleArray = ^TRGBTripleArray;
  TRGBTripleArray = array[0..32767] of TRGBTriple;

procedure FadeIn(bitmap_input:tgraphic);
var
  Bitmap, BaseBitmap: TBitmap;
  Row, BaseRow: PRGBTripleArray;
  x, y, step: integer;
begin
  // Bitmaps vorbereiten / Preparing the Bitmap //
  Bitmap := TBitmap.Create;
  try
    Bitmap.PixelFormat := pf24bit; // oder pf24bit / or pf24bit //
    bitmap.Width:=250;
    bitmap.Height:=200;
    bitmap.Canvas.Draw(0,0,bitmap_input);
    //Bitmap.Canvas.Draw(0,0,main.biospheres_p.Picture.Graphic);
    BaseBitmap := TBitmap.Create;
    try
      BaseBitmap.PixelFormat := pf32bit;
      BaseBitmap.Assign(Bitmap);
      // Fading //
      for step := 0 to 32 do
      begin
        //delay(100);
        for y := 0 to (Bitmap.Height - 1) do
        begin
          BaseRow := BaseBitmap.Scanline[y];
          // Farben vom Endbild holen / Getting colors from final image //
          Row := Bitmap.Scanline[y];
          // Farben vom aktuellen Bild / Colors from the image as it is now //
          for x := 0 to (Bitmap.Width - 1) do
          begin
            Row[x].rgbtRed := (step * BaseRow[x].rgbtRed) shr 5;
            Row[x].rgbtGreen := (step * BaseRow[x].rgbtGreen) shr 5;
              // Fading //
            Row[x].rgbtBlue := (step * BaseRow[x].rgbtBlue) shr 5;
          end;
        end;
        main.Image1.Canvas.Draw(0, 0, Bitmap);
          // neues Bild ausgeben / Output new image //
        main.Image1.Update;
        application.ProcessMessages;
        delay(10);
        //InvalidateRect(main.Handle, nil, False);
        // Fenster neu zeichnen / Redraw window //
        //RedrawWindow(Form1.Handle, nil, 0, RDW_UPDATENOW);
      end;
    finally
      BaseBitmap.Free;
    end;
  finally
    Bitmap.Free;
  end;
end;

procedure FadeOut;
var
  Bitmap, BaseBitmap: TBitmap;
  Row, BaseRow: PRGBTripleArray;
  x, y, step: integer;
begin
  // Bitmaps vorbereiten / Preparing the Bitmap //
  Bitmap := TBitmap.Create;
  try
    Bitmap.PixelFormat := pf24bit; // oder pf24bit / or pf24bit //
    //Bitmap.LoadFromFile(ImageFileName);
    bitmap.Width:=250;
    bitmap.Height:=200;
    bitmap.Canvas.Draw(0,0,main.Image1.Picture.Graphic);
    
    BaseBitmap := TBitmap.Create;
    try
      BaseBitmap.PixelFormat := pf32bit;
      BaseBitmap.Assign(Bitmap);
      // Fading //
      for step := 32 downto 0 do
      begin
        for y := 0 to (Bitmap.Height - 1) do
        begin
          BaseRow := BaseBitmap.Scanline[y];
          // Farben vom Endbild holen / Getting colors from final image //
          Row := Bitmap.Scanline[y];
          // Farben vom aktuellen Bild / Colors from the image as it is now //
          for x := 0 to (Bitmap.Width - 1) do
          begin
            Row[x].rgbtRed := (step * BaseRow[x].rgbtRed) shr 5;
            Row[x].rgbtGreen := (step * BaseRow[x].rgbtGreen) shr 5;
              // Fading //
            Row[x].rgbtBlue := (step * BaseRow[x].rgbtBlue) shr 5;
          end;
        end;
        main.Image1.Canvas.Draw(0, 0, Bitmap);
          // neues Bild ausgeben / Output new image //
        main.Image1.Update;
        application.ProcessMessages;
        delay(10);
        //InvalidateRect(Form1.Handle, nil, False);
        // Fenster neu zeichnen / Redraw window //
        //RedrawWindow(Form1.Handle, nil, 0, RDW_UPDATENOW);
      end;
    finally
      BaseBitmap.Free;
    end;
  finally
    Bitmap.Free;
  end;
end;    }


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

function convert_time(hours,minutes:byte):integer;
var i:integer;
begin
  i:=hours*1000;
  i:=round(i+minutes*time_const);
  dec(i,6000);
  if i<0 then inc(i,24000);
  result:=i mod 24000;
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

function wait_level_thread(p:pointer):integer;
var str,str1:string;
i:cardinal;
search:_WIN32_FIND_DATAA;
size:int64;
begin
  main.Memo1.Lines.Add('Wait level thread enter');
  waitforsingleobject(hndl,infinite);
  if thread_exit=false then
  begin
    generate_level(main.level_settings);
  end;
  main.Memo1.Lines.Add('Wait level thread end');

  SetCurrentDirectory(pchar(extractfilepath(paramstr(0))));

  time:=getcurrenttime-time;
  time:=round(time/1000);
  str:='Time, spend on generation: ';
  if time>=60 then
    if ((time div 60) mod 10)=1 then str:=str+inttostr(time div 60)+' minute '
    else str:=str+inttostr(time div 60)+' minutes ';

  if (time mod 10)=1 then str:=str+inttostr(time mod 60)+' second'
  else str:=str+inttostr(time mod 60)+' seconds';

  if thread_exit=false then
    application.MessageBox(pchar('Map generation complete'+#13+#10+str),'Generation')
  else
  begin
    //ochishaem katalog
    str1:=main.SaveDialog1.FileName;
    //izvlekaem put'
    str1:=extractfilepath(str1);

    //SetCurrentDirectory(pchar(str1));

    if directoryexists(str1+main.Edit3.Text+'\region') then
        begin
          i:=findfirstfile(pchar(str1+main.Edit3.Text+'\region\*.*'),search);
          if i<>INVALID_HANDLE_VALUE then
          begin
            repeat
              if (search.cFileName[0]<>'.') then
              windows.deletefile(pchar(str1+main.Edit3.Text+'\region\'+search.cFileName));
            until findnextfile(i,search)=false;
            Windows.findclose(i);
          end;
        end;
    //udalaem fayl settings
    if fileexists(str1+main.Edit3.Text+'\settings.txt') then
      deletefile(str1+main.Edit3.Text+'\settings.txt');
    //udalaem katalogi
    RemoveDirectory(pchar(str1+main.Edit3.Text+'\region'));
    RemoveDirectory(pchar(str1+main.Edit3.Text));

    application.MessageBox(pchar('Map generation aborted'+#13+#10+str),'Generation');
  end;
  main.ProgressBar1.Position:=0;
  main.Label5.Caption:='';
  main.Label6.Caption:='';
  main.Label7.Caption:='';
  main.Label9.Caption:='';
  main.Memo1.Lines.Add('Time:'+inttostr(time));

  main.Button1.Enabled:=true;
  main.ComboBox1.Enabled:=true;
  main.Button4.Enabled:=true;
  main.Button3.Enabled:=true;
  main.Button2.Enabled:=true;
  main.Edit3.Enabled:=true;
  main.GroupBox3.Enabled:=true;
  main.Edit4.Enabled:=true;
  main.Button6.Enabled:=true;
  main.Button8.Enabled:=true;
  main.Button9.Enabled:=true;
  main.CheckBox2.Enabled:=true;
  main.CheckBox3.Enabled:=true;
  main.CheckBox4.Enabled:=true;
  main.CheckBox5.Enabled:=true;
  main.Edit6.Enabled:=true;
  main.Edit7.Enabled:=true;
  main.ComboBox2.Enabled:=true;
  main.ComboBox2.Font.Color:=clblack;
  main.CheckBox4Click(main);
  main.Edit8.Enabled:=true;
  main.Edit9.Enabled:=true;

  main.Button13.Enabled:=false;

  endthread(0);
end;

function wait_thread(p:pointer):integer;
begin
  main.Memo1.Lines.Add('Wait thread enter');
  waitforsingleobject(hndl,infinite);
  main.Memo1.Lines.Add('Wait thread end');

  time:=getcurrenttime-time;
  application.MessageBox('Map generation complete','Generation');
  main.ProgressBar1.Position:=0;
  main.Label5.Caption:='';
  main.Label6.Caption:='';
  main.Label7.Caption:='';
  main.Label9.Caption:='';
  main.Memo1.Lines.Add('Time:'+inttostr(time));

  endthread(0);
end;

procedure Tmain.Exit1Click(Sender: TObject);
begin
  halt(0);
end;

procedure Tmain.About2Click(Sender: TObject);
begin
  about.ShowModal;
end;

procedure Tmain.Button1Click(Sender: TObject);
begin
  case main.ComboBox1.ItemIndex of
  0:begin
      flatmap.ShowModal;
      {if flatmap.ShowModal=idOK then
        application.MessageBox('Settings set','Flatmap generation');  }
    end;
  1:begin
      application.MessageBox('There are no settings yet.','Notice');
    end;
  3:begin
      desert.ShowModal;
    end;
  5:begin
      planet.ShowModal;
    end;
  6:begin
      biosf.ShowModal;
    end;
  7:begin
      tunnels.ShowModal;
    end
  else
    application.MessageBox('Map settings not yet implemented','Error');
  end;
end;

procedure Tmain.AppMes(var Msg: TMsg; var Handled: Boolean);
var i,j:integer;
begin
  if (msg.message>=WM_USER+300)and(msg.message<=WM_USER+400) then
  begin
    case msg.message of
    WM_USER+300:begin                      //Generation procedure inicialization
                  if msg.wParam=0 then
                  begin
                    //main.Memo1.Lines.Add('Generation started');
                    main.ProgressBar1.Position:=0;
                    main.ProgressBar1.Max:=0;
                    pos1:=0;
                    pos2:=0;
                    pos3:=0;
                    pos4:=0;
                    //main.Label5.Caption:='Generated chunk 0 out of '+inttostr(main.ProgressBar1.Max);
                    main.Label5.Width:=180;
                    main.Label5.Caption:='Prepearing blocks information';
                    main.Label5.BringToFront;

                    //delaem vse pola vikluchenimi
                    main.Button1.Enabled:=false;
                    main.ComboBox1.Enabled:=false;
                    main.Button4.Enabled:=false;
                    main.Button3.Enabled:=false;
                    main.Button2.Enabled:=false;
                    main.Edit3.Enabled:=false;
                    main.GroupBox3.Enabled:=false;
                    main.Edit4.Enabled:=false;
                    main.Button6.Enabled:=false;
                    main.Button8.Enabled:=false;
                    main.Button9.Enabled:=false;
                    main.CheckBox2.Enabled:=false;
                    main.CheckBox3.Enabled:=false;
                    main.CheckBox4.Enabled:=false;
                    main.CheckBox5.Enabled:=false;
                    main.Edit6.Enabled:=false;
                    main.Edit7.Enabled:=false;
                    main.ComboBox2.Font.Color:=clgray;
                    main.ComboBox2.Enabled:=false;
                    main.Edit8.Enabled:=false;
                    main.Edit9.Enabled:=false;
                    //vkluchaem knopku stop
                    main.Button13.Enabled:=true;
                  end;
                  if msg.wParam=1 then     //signal of starting generation
                  begin
                    main.ProgressBar1.Position:=0;
                    main.Label5.Caption:='Generated chunk';
                    main.Label6.Caption:='0';
                    main.Label7.Caption:='out of '+inttostr(main.ProgressBar1.Max);
                  end;
                end;
    WM_USER+301:begin                    //Thread done message
                  main.Memo1.Lines.Add('Thread '+inttostr(msg.wParam)+' done');
                  case msg.wParam of
                  1:pos1:=kol1;
                  2:pos2:=kol2;
                  3:pos3:=kol3;
                  4:pos4:=kol4;
                  end;
                end;
    WM_USER+302:begin                    //Thread initialization message with chunk count (from inside thread)
                  main.Memo1.Lines.Add('Thread number='+inttostr(msg.wParam)+'  Chunk count='+inttostr(msg.lParam));
                  case msg.wParam of
                  1:kol1:=msg.lParam;
                  2:kol2:=msg.lParam;
                  3:kol3:=msg.lParam;
                  4:kol4:=msg.lParam;
                  end;
                  main.ProgressBar1.Max:=main.ProgressBar1.Max+msg.lParam;
                  //main.Label5.Caption:='Generated chunk 0 out of '+inttostr(main.ProgressBar1.Max);
                  for i:=2 to 7 do
                    if intpower(10,i)> main.ProgressBar1.Max  then
                      break;
                  main.Label6.Left:=314;
                  main.Label6.width:=i*8;
                  main.Label7.Left:=210+5+102+(i*8);
                  main.Label5.Caption:='Prepearing blocks information';
                  main.Label5.BringToFront;
                end;
    WM_USER+303:begin                    //Thread Update (kol-vo sgenerirovannih chankov)
                  case msg.wParam of
                  1:pos1:=msg.lParam;
                  2:pos2:=msg.lParam;
                  3:pos3:=msg.lParam;
                  4:pos4:=msg.lParam;
                  end;
                  main.ProgressBar1.Position:=pos1+pos2+pos3+pos4;
                  main.Label6.Caption:=inttostr(main.ProgressBar1.Position);
                end;
    WM_USER+304:begin                   //Data from Thread
                  main.Memo1.Lines.Add('Data from thread '+inttostr(msg.wParam)+'  Data='+inttostr(msg.lParam));
                end;
    WM_USER+305:begin                   //Data from Thread in Chunk koordinates
                  main.Memo1.Lines.Add('Chunk '+inttostr(msg.wParam)+','+inttostr(msg.lParam));
                end;
    WM_USER+306:begin                   //Starting chunk generation with region numbers
                  main.Label9.Caption:='Writing chunks for region '+inttostr(msg.wParam)+', '+inttostr(msg.lParam);
                end;
    WM_USER+307:begin                   //Start of initial planets generation
                  main.Label9.Caption:='Generating planets for map';
                end;
    WM_USER+308:begin                   //Peredacha parametrov dla generacii level.dat
                  case msg.wParam of
                    1:main.level_settings.spawnx:=msg.lParam;//X
                    2:main.level_settings.spawny:=msg.lParam-1;//Y
                    3:main.level_settings.spawnz:=msg.lParam;//Z
                  end;
                end;
    WM_USER+309:begin                   //Generating blocks for region...
                  main.Label9.Caption:='Generating blocks for region '+inttostr(msg.wParam)+', '+inttostr(msg.lParam);
                end;
    WM_USER+310:begin                   //Light recalculate
                  main.Label9.Caption:='Calculating lights for region '+inttostr(msg.wParam)+', '+inttostr(msg.lParam);
                end;
    WM_USER+311:begin                   //Time message for Time measures
                  main.Memo1.Lines.Add('Current time:'+inttostr(getcurrenttime));
                end;
    WM_USER+312:begin                //Start of tunnel generation
                  main.Label9.Caption:='Generating tunnels for map';
                end;
    WM_USER+313:begin               //Tunnel generation in chain initialization
                  main.Label5.Caption:='Generating tunnel';
                  main.Label6.Caption:='0';
                  main.Label7.Caption:='in chain 0';
                  main.Label6.Left:=322;
                  main.Label7.Left:=322+4+8;
                  main.Label6.Width:=8;
                  tun_kol:=0;
                end;
    WM_USER+314:begin        //Tunnel generation update
                  if msg.wParam<>0 then
                  begin
                    for i:=1 to 5 do
                      if intpower(10,i)> msg.wParam then
                        break;
                    for j:=1 to 5 do
                      if intpower(10,j)> tun_kol then
                        break;

                    if i>j then
                    begin
                      main.Label6.Width:=i*8;
                      main.Label7.Left:=322+4+i*8;
                    end;
                    tun_kol:=msg.wParam;
                    main.Label6.Caption:=inttostr(msg.wParam);
                  end;
                  if msg.lParam<>0 then main.Label7.Caption:='in chain '+inttostr(msg.lParam);
                end;
    WM_USER+315:begin        //Tunnel generation end
                  main.Label5.Caption:='';
                  main.Label6.Caption:='';
                  main.Label7.Caption:='';
                end;
    WM_USER+316:begin      //Progress bar initialization
                  main.ProgressBar1.Max:=msg.wParam;
                  main.ProgressBar1.Position:=0;
                end;
    WM_USER+317:begin      //Progress bar change
                  main.ProgressBar1.Position:=msg.wParam;
                end;
    WM_USER+318:begin      //BioSphere start generation
                  main.Label9.Caption:='Generating Spheres';
                end;
    WM_USER+319:begin      //file size update
                  main.level_settings.size:=main.level_settings.size+msg.lParam;
                  main.Memo1.Lines.Add('Added file size '+inttostr(msg.lParam)+'. Overall files size: '+inttostr(main.level_settings.size));
                end;
    WM_USER+320:begin      //preview width and length change
                  preview.Image1.Width:=msg.wParam;
                  preview.Image1.Height:=msg.lParam;
                  //PatBlt(image1.Canvas.Handle, 0, 0, image1.ClientWidth, image1.ClientHeight, WHITENESS);
                  //preview.Image1.Picture.Width:=msg.wParam;
                  //preview.Image1.Picture.Height:=msg.lparam;
                end;
    WM_USER+321:begin      //preview form show
                  preview.Show;
                  preview.BringToFront;
                  main.Enabled:=true;
                end;
    WM_USER+322:begin      //preview pixel color transfer
                  i:=(msg.wParam shr 16)and $FFFF;
                  j:=msg.wParam and $FFFF;
                  j:=preview.Image1.Height-j-1;
                  preview.Image1.Canvas.Pixels[i,j]:=msg.lParam;
                end;
    WM_USER+323:begin      //main form disabling
                  main.Enabled:=false;
                end;
    WM_USER+324:begin      //main form enabling
                  main.Enabled:=true;
                end;
    WM_USER+325:begin      //starting of heightmap generation
                  main.Label9.Caption:='Generating heightmap';
                end;
    WM_USER+326:begin      //starting generation of oasis heightmap
                  main.Label6.Caption:='';
                  main.Label7.Caption:='';
                  main.Label5.Caption:='Generating presice heightmap for oasises';
                end;
    WM_USER+327:begin      //starting generation of village heightmap
                  main.Label6.Caption:='';
                  main.Label7.Caption:='';
                  main.Label5.Caption:='Generating presice heightmap for villages';
                end;
    WM_USER+328:begin      //prepearing preview
                  main.Label5.Caption:='';
                  main.Label6.Caption:='';
                  main.Label7.Caption:='';
                  main.Label9.Caption:='Prepearing preview';
                  main.Enabled:=false;
                end;
    end;
    handled:=true;
  end;
end;

procedure Tmain.FormCreate(Sender: TObject);
var t:int64;
begin   
  //delaem SID
  randomize;  

  sid_rand:=rnd.Create;

  //l:=random(4294967290);
  //l1:=random(4294967290);
  //main.Edit4.Text:=inttohex(l,8)+inttohex(l1,8);

  main.Edit4.Text:=inttostr(sid_rand.nextLong);

  //risuem prevyu
  main.Image1.Canvas.Draw(0,0,main.flatmap_p.Picture.Graphic);

  //prisvaivaem ustanovlenniy shrift nuzhnim leyblam
  main.Label4.Font.Name:='FMPTSR-Credits';
  main.Label5.Font.Name:='FMPTSR-Credits';
  main.Label6.Font.Name:='FMPTSR-Credits';
  main.Label7.Font.Name:='FMPTSR-Credits';
  main.Label9.Font.Name:='FMPTSR-Credits';

  //main.Memo1.Lines.Add('Priority:'+booltostr(Setthreadpriority(GetCurrentProcess,THREAD_PRIORITY_HIGHEST),true));
  //main.Memo1.Lines.Add('Priority class:'+booltostr(setpriorityclass(GetCurrentProcess,HIGH_PRIORITY_CLASS),true));

  //inicializaciya obrabotchika soobsheniy
  application.OnMessage:=AppMes;

  //vstavlaem progressbar v statusbar
  with ProgressBar1 do
  begin
    Parent := StatusBar1;
    //Position := ;
    Top := 2;
    Left := 0;
    Height := StatusBar1.Height - Top;
    Width := StatusBar1.Panels[0].Width - Left;
  end;

  //vstavlaem Label s statusbar (nazvanie programmi i versiya)
  main.Label4.Parent:=statusbar1;
  label4.Top:=3;
  label4.Left:=810+5;
  label4.Height:=StatusBar1.Height - label4.Top-1;

  //vstavlaem Label s statusbar (generaciya chankov)
  main.Label5.Parent:=statusbar1;              //generationg chunk
  label5.Top:=3;
  label5.Left:=210+5;
  label5.Height:=StatusBar1.Height - label5.Top-1;
  label5.Width:=120;
  label5.Caption:='';

  main.Label6.Parent:=statusbar1;                //10000
  label6.Top:=3;
  //label6.Left:=210+5+103;
  label6.Left:=620;
  label6.Height:=StatusBar1.Height - label6.Top-1;
  label6.Width:=32;
  label6.Caption:='';

  main.Label7.Parent:=statusbar1;                //outof 10000
  label7.Top:=3;
  //label7.Left:=210+5+139;
  label7.Left:=600;
  label7.Height:=StatusBar1.Height - label7.Top-1;
  label7.Width:=70;
  label7.Caption:='';

  main.Label9.Parent:=statusbar1;                //generation chunks for region
  label9.Top:=3;
  //label7.Left:=210+5+139;
  label9.Left:=580;
  label9.Height:=StatusBar1.Height - label7.Top-1;
  label9.Width:=220;
  label9.Caption:='';

  main.CheckBox4Click(self);

  //inicializaciya nastroek generacii ploskoy karti
  setlength(main.flatmap_prop.sloi,4);
  main.flatmap_prop.sloi[0].start_alt:=0;
  main.flatmap_prop.sloi[0].width:=1;
  main.flatmap_prop.sloi[0].material:=7;
  main.flatmap_prop.sloi[0].material_data:=0;
  main.flatmap_prop.sloi[0].name:='Bedrock';
  main.flatmap_prop.sloi[1].start_alt:=1;
  main.flatmap_prop.sloi[1].width:=60;
  main.flatmap_prop.sloi[1].material:=1;
  main.flatmap_prop.sloi[1].name:='Stone layer';
  main.flatmap_prop.sloi[1].material_data:=0;
  main.flatmap_prop.sloi[2].start_alt:=61;
  main.flatmap_prop.sloi[2].width:=3;
  main.flatmap_prop.sloi[2].material:=3;
  main.flatmap_prop.sloi[2].material_data:=0;
  main.flatmap_prop.sloi[2].name:='Dirt layer';
  main.flatmap_prop.sloi[3].start_alt:=64;
  main.flatmap_prop.sloi[3].width:=1;
  main.flatmap_prop.sloi[3].material:=2;
  main.flatmap_prop.sloi[3].material_data:=0;
  main.flatmap_prop.sloi[3].name:='Grass layer';

  main.flatmap_prop.handle:=main.Handle;
  main.flatmap_prop.width:=20;
  main.flatmap_prop.len:=20;

  //inicializaciya nastroek granici karti
  main.border_prop.border_type:=0;
  main.border_prop.wall_material:=1;
  main.border_prop.wall_thickness:=1;
  main.border_prop.wall_void_thickness:=10;
  main.border_prop.wall_void:=false;
  main.border_prop.void_thickness:=10;
  main.border_prop.cwall_gen_towers:=true;
  main.border_prop.cwall_towers_type:=0;
  main.border_prop.cwall_towers_gen_chastokol:=true;
  main.border_prop.cwall_walls_gen_chastokol:=true;
  main.border_prop.cwall_gen_interior:=false;
  main.border_prop.cwall_gen_rails:=false;
  main.border_prop.cwall_gen_boinici:=false;
  main.border_prop.cwall_boinici_type:=1;
  main.border_prop.cwall_gen_gates:=false;
  main.border_prop.cwall_gates_type:=0;
  main.border_prop.cwall_gen_void:=false;
  main.border_prop.cwall_void_width:=10;

  //inicializaciya nastoek generacii karti Planetoids
  main.planet_prop.width:=20;
  main.planet_prop.len:=20;
  main.planet_prop.planets_type:=0;
  main.planet_prop.map_type:=0;
  main.planet_prop.min:=10;
  main.planet_prop.max:=20;
  main.planet_prop.distance:=5;
  main.planet_prop.density:=50;
  main.planet_prop.groundlevel:=0;
  main.planet_prop.handle:=main.Handle;

  //inicializaciya nastroek generaci karti Golden Tunnels
  main.tunnel_prop.width:=20;
  main.tunnel_prop.len:=20;
  main.tunnel_prop.round_tun:=true;
  main.tunnel_prop.r_hor_min:=10;
  main.tunnel_prop.r_hor_max:=15;
  main.tunnel_prop.r_vert_min:=10;
  main.tunnel_prop.r_vert_max:=10;
  main.tunnel_prop.round_tun_density:=80;
  main.tunnel_prop.light_density:=80;
  main.tunnel_prop.gen_tall_grass:=true;
  main.tunnel_prop.gen_sun_holes:=false;
  main.tunnel_prop.gen_hub:=false;
  main.tunnel_prop.gen_seperate:=false;
  main.tunnel_prop.gen_flooded:=false;
  main.tunnel_prop.handle:=main.Handle;
  main.tunnel_prop.tun_density:=90;
  main.tunnel_prop.gen_lights:=true;
  main.tunnel_prop.skyholes_density:=50;
  main.tunnel_prop.light_blocks_type:=0;
  setlength(main.tunnel_prop.light_blocks,1);
  main.tunnel_prop.light_blocks[0]:=89;

  //inicializiruem nastroyki karti BioSphere
  main.biosfer_prop.handle:=main.Handle;
  main.biosfer_prop.width:=20;
  main.biosfer_prop.len:=20;
  main.biosfer_prop.original_gen:=false;
  main.biosfer_prop.underwater:=false;
  main.biosfer_prop.gen_skyholes:=false;
  main.biosfer_prop.gen_noise:=true;
  main.biosfer_prop.gen_bridges:=true;
  main.biosfer_prop.bridge_material:=1;
  main.biosfer_prop.bridge_rail_material:=4;
  main.biosfer_prop.bridge_width:=4;
  main.biosfer_prop.sphere_material:=20;
  main.biosfer_prop.sphere_distance:=100;
  main.biosfer_prop.sphere_ellipse:=false;
  main.biosfer_prop.biomes.forest:=true;
  main.biosfer_prop.biomes.rainforest:=true;
  main.biosfer_prop.biomes.desert:=true;
  main.biosfer_prop.biomes.plains:=true;
  main.biosfer_prop.biomes.taiga:=true;
  main.biosfer_prop.biomes.ice_desert:=true;
  main.biosfer_prop.biomes.tundra:=true;
  main.biosfer_prop.biomes.hell:=true;
  main.biosfer_prop.bridge_material:=5;
  main.biosfer_prop.bridge_rail_material:=85;
  main.biosfer_prop.sphere_material:=20;

  //inicializiruem nastroyki karti Biomes: desert
  main.biomes_desert_prop.handle:=main.Handle;
  main.biomes_desert_prop.width:=20;
  main.biomes_desert_prop.len:=20;
  main.biomes_desert_prop.gen_cactus:=true;
  main.biomes_desert_prop.gen_shrubs:=true;
  main.biomes_desert_prop.gen_oasises:=true;
  main.biomes_desert_prop.gen_pyr:=false;
  main.biomes_desert_prop.gen_volcano:=false;
  main.biomes_desert_prop.gen_preview:=false;
  main.biomes_desert_prop.gen_prev_oasis:=true;
  main.biomes_desert_prop.gen_prev_vil:=true;
  main.biomes_desert_prop.gen_only_prev:=false;
  main.biomes_desert_prop.under_block:=1;
  //main.biomes_desert_prop.gen_oasis_den:=false;
  //main.biomes_desert_prop.oasis_den:=10;
  main.biomes_desert_prop.oasis_count:=5;
  main.biomes_desert_prop.gen_vil:=false;
  main.biomes_desert_prop.vil_types.ruied:=true;
  main.biomes_desert_prop.vil_types.normal:=false;
  main.biomes_desert_prop.vil_types.normal_veg:=false;
  main.biomes_desert_prop.vil_types.fortif:=false;
  main.biomes_desert_prop.vil_types.hidden:=false;
  setlength(main.biomes_desert_prop.vil_names,9);
  main.biomes_desert_prop.vil_names[0]:='al-Waha';
  main.biomes_desert_prop.vil_names[1]:='al-Akhdhar';
  main.biomes_desert_prop.vil_names[2]:='al-Aswad';
  main.biomes_desert_prop.vil_names[3]:='Maa';
  main.biomes_desert_prop.vil_names[4]:='Qarya Sagheerah';
  main.biomes_desert_prop.vil_names[5]:='al-Doua';
  main.biomes_desert_prop.vil_names[6]:='al-Mazraa';
  main.biomes_desert_prop.vil_names[7]:='Marhaban';
  main.biomes_desert_prop.vil_names[8]:='Riyadh';
  main.biomes_desert_prop.vil_count:=length(main.biomes_desert_prop.vil_names);

  //initializiruem nastroyki katri like-Notch
  main.original_prop.version:=1;
  main.original_prop.width:=20;
  main.original_prop.len:=20;
  main.original_prop.handle:=main.Handle;
  main.original_prop.potok_exit:=false;
  main.original_prop.pop_chunks:=false;

  //inicializaciya nastroek igroka
  main.level_settings.player.xp:=0;
  main.level_settings.player.totalxp:=0;
  main.level_settings.player.xplevel:=0;
  main.level_settings.player.score:=0;
  main.level_settings.player.food_level:=20;
  main.level_settings.player.food_tick_timer:=0;
  main.level_settings.player.food_ex_level:=1;
  main.level_settings.player.food_sat_level:=5;
  main.level_settings.player.rotation[0]:=0;
  main.level_settings.player.rotation[1]:=0;
  main.level_settings.player.overrite_pos:=false;
  main.level_settings.player.pos[0]:=0;
  main.level_settings.player.pos[1]:=64;
  main.level_settings.player.pos[2]:=0;
  main.level_settings.player.health:=20;
end;

procedure Tmain.Button9Click(Sender: TObject);
var str:string;
i:integer;
search:_WIN32_FIND_DATAA;
begin
  if (main.Edit1.Text='')or(main.Edit2.Text='') then
  begin
    application.MessageBox('You entered wrong general settings','Error');
  end
  else
  begin
    //proverka na maksimum i minimum
    if (strtoint(main.Edit1.Text)<6)or(strtoint(main.Edit1.Text)>1024)or
    (strtoint(main.Edit2.Text)<6)or(strtoint(main.Edit2.Text)>1024) then
    begin
      application.MessageBox('Size of the map must be between 6 and 1024','Error');
      exit;
    end;

    //proverka na minimal'noe kol-vo chankov dla BioSphere
    if ((strtoint(main.Edit1.Text)<50)or(strtoint(main.Edit2.Text)<50))and
    (main.ComboBox1.ItemIndex=6) then
    begin
      application.MessageBox('Size of the BioSphere map must be greater then 50','Error');
      exit;
    end;   

    //proverka na chetnost'
    if ((strtoint(main.Edit1.Text) mod 2)<>0) or((strtoint(main.Edit2.Text) mod 2)<>0) then
    begin
      application.MessageBox('You must enter even number in map size section','Error');
      exit;
    end;

    if main.SaveDialog1.Execute then
    begin
      str:=main.SaveDialog1.FileName;
      //izvlekaem put'
      main.Memo1.Lines.Add('Raw path:'+str);
      str:=extractfilepath(str);
      main.Memo1.Lines.Add('Path:'+str);

      //proverka na sushestvovanie karti (tochnee fayla level.dat)
      if fileexists(str+main.Edit3.Text+'\level.dat') then
      begin
        if messagedlg('Map already exists. Are you sure you want to rewrite it?',mtConfirmation,mbOKCancel,0)=mrCancel then
          exit
        else
        //udalit' fayli regionov v papke, esli papka est'
        if directoryexists(str+main.Edit3.Text+'\region') then
        begin
          main.Memo1.Lines.Add('File exists and directory exists');
          i:=findfirstfile(pchar(str+main.Edit3.Text+'\region\*.mcr'),search);
          if i<>INVALID_HANDLE_VALUE then
          begin
            repeat
              windows.deletefile(pchar(str+main.Edit3.Text+'\region\'+search.cFileName));
            until findnextfile(i,search)=false;
            Windows.findclose(i);
          end;
        end;
      end;

      thread_exit_type:=main.ComboBox1.ItemIndex;
      //opredelenie tipa generiruemoy karti
      //case main.RadioGroup1.ItemIndex of
      case main.ComboBox1.ItemIndex of
      0:begin //ploskaya karta
          main.flatmap_prop.width:=strtoint(main.Edit1.Text);
          main.flatmap_prop.len:=strtoint(main.Edit2.Text);
          //main.flatmap_prop.sid:=bintoint(hextobin(main.Edit4.text));
          main.flatmap_prop.sid:=strtoint64(main.Edit4.text);
          main.flatmap_prop.potok_exit:=false;
          main.flatmap_prop.pop_chunks:=main.CheckBox2.Checked;

          //i:=generate_flat(str,main.Edit3.Text,strtoint(main.Edit1.Text),strtoint(main.Edit2.Text), main.flatmap_prop);
          //main.Memo1.Lines.Add('Time:'+inttostr(getcurrenttime));
          time:=getcurrenttime;
          //gotovim strukturu dla generacii level.dat
          main.level_settings.name:=main.Edit3.Text;
          main.level_settings.path:=str;
          main.level_settings.spawnx:=0;
          main.level_settings.spawnz:=0;
          //level_settings.spawny:=main.flatmap_prop.groundlevel;
          main.level_settings.spawny:=main.flatmap_prop.sloi[length(main.flatmap_prop.sloi)-1].start_alt+main.flatmap_prop.sloi[length(main.flatmap_prop.sloi)-1].width-1;
          //level_settings.sid:=bintoint(hextobin(main.Edit4.text));
          main.level_settings.sid:=strtoint64(main.Edit4.text);
          main.level_settings.size:=0;
          main.level_settings.game_type:=main.ComboBox2.ItemIndex;
          if main.CheckBox3.Checked=true then
            main.level_settings.map_features:=1
          else
            main.level_settings.map_features:=0;
          if main.CheckBox4.Checked=true then
            main.level_settings.raining:=1
          else
            main.level_settings.raining:=0;
          main.level_settings.rain_time:=strtoint(main.Edit6.Text);
          if main.CheckBox5.Checked=true then
            main.level_settings.thundering:=1
          else
            main.level_settings.thundering:=0;
          main.level_settings.thunder_time:=strtoint(main.Edit7.Text);
          main.level_settings.game_time:=convert_time(strtoint(main.Edit8.Text),strtoint(main.Edit9.Text));

          i:=gen_flat(str,main.Edit3.Text,main.flatmap_prop,main.border_prop,main.level_settings);

          //i:=waitforsingleobject(i,infinite);

          hndl:=i;

          thread_exit:=false;
          wait_hndl:=beginthread(nil,0,@wait_level_thread,nil,0,id);

          main.Memo1.Lines.Add('i='+inttostr(i));
          main.Memo1.Lines.Add('Flatmap Done');
        end;
      1:begin
          //i:=gen_flat('C:\MinecraftWorlds\2x2 test','TestFlat',main.flatmap_prop);
          //application.MessageBox('Not ready yet','Error');

          main.original_prop.width:=strtoint(main.Edit1.Text);
          main.original_prop.len:=strtoint(main.Edit2.Text);
          //main.flatmap_prop.sid:=bintoint(hextobin(main.Edit4.text));
          main.original_prop.sid:=strtoint64(main.Edit4.text);
          main.original_prop.potok_exit:=false;
          main.original_prop.pop_chunks:=main.CheckBox2.Checked;

          //main.Memo1.Lines.Add('Time:'+inttostr(getcurrenttime));
          time:=getcurrenttime;
          //gotovim strukturu dla generacii level.dat
          main.level_settings.name:=main.Edit3.Text;
          main.level_settings.path:=str;
          main.level_settings.spawnx:=0;
          main.level_settings.spawnz:=0;
          //level_settings.spawny:=main.flatmap_prop.groundlevel;
          main.level_settings.spawny:=120;
          //level_settings.sid:=bintoint(hextobin(main.Edit4.text));
          main.level_settings.sid:=strtoint64(main.Edit4.text);
          main.level_settings.size:=0;
          main.level_settings.game_type:=main.ComboBox2.ItemIndex;
          if main.CheckBox3.Checked=true then
            main.level_settings.map_features:=1
          else
            main.level_settings.map_features:=0;
          if main.CheckBox4.Checked=true then
            main.level_settings.raining:=1
          else
            main.level_settings.raining:=0;
          main.level_settings.rain_time:=strtoint(main.Edit6.Text);
          if main.CheckBox5.Checked=true then
            main.level_settings.thundering:=1
          else
            main.level_settings.thundering:=0;
          main.level_settings.thunder_time:=strtoint(main.Edit7.Text);
          main.level_settings.game_time:=convert_time(strtoint(main.Edit8.Text),strtoint(main.Edit9.Text));

          i:=gen_original(str,main.Edit3.Text,main.original_prop,main.border_prop,main.level_settings);

          //i:=waitforsingleobject(i,infinite);

          hndl:=i;

          thread_exit:=false;
          wait_hndl:=beginthread(nil,0,@wait_level_thread,nil,0,id);

          main.Memo1.Lines.Add('i='+inttostr(i));
          main.Memo1.Lines.Add('Original Done');
        end;
      2:begin
          application.MessageBox('Not ready yet','Error');
        end;
      3:begin  //desert
          main.biomes_desert_prop.width:=strtoint(main.Edit1.Text);
          main.biomes_desert_prop.len:=strtoint(main.Edit2.Text);
          //main.flatmap_prop.sid:=bintoint(hextobin(main.Edit4.text));
          main.biomes_desert_prop.sid:=strtoint64(main.Edit4.text);
          main.biomes_desert_prop.potok_exit:=false;
          main.biomes_desert_prop.pop_chunks:=main.CheckBox2.Checked;

          //main.Memo1.Lines.Add('Time:'+inttostr(getcurrenttime));
          time:=getcurrenttime;
          //gotovim strukturu dla generacii level.dat
          main.level_settings.name:=main.Edit3.Text;
          main.level_settings.path:=str;
          main.level_settings.spawnx:=0;
          main.level_settings.spawnz:=0;
          //level_settings.spawny:=main.flatmap_prop.groundlevel;
          main.level_settings.spawny:=120;
          //level_settings.sid:=bintoint(hextobin(main.Edit4.text));
          main.level_settings.sid:=strtoint64(main.Edit4.text);
          main.level_settings.size:=0;
          main.level_settings.game_type:=main.ComboBox2.ItemIndex;
          if main.CheckBox3.Checked=true then
            main.level_settings.map_features:=1
          else
            main.level_settings.map_features:=0;
          if main.CheckBox4.Checked=true then
            main.level_settings.raining:=1
          else
            main.level_settings.raining:=0;
          main.level_settings.rain_time:=strtoint(main.Edit6.Text);
          if main.CheckBox5.Checked=true then
            main.level_settings.thundering:=1
          else
            main.level_settings.thundering:=0;
          main.level_settings.thunder_time:=strtoint(main.Edit7.Text);
          main.level_settings.game_time:=convert_time(strtoint(main.Edit8.Text),strtoint(main.Edit9.Text));

          i:=gen_biome_desert(str,main.Edit3.Text,main.biomes_desert_prop,main.border_prop,main.level_settings);

          //i:=waitforsingleobject(i,infinite);

          hndl:=i;

          thread_exit:=false;
          wait_hndl:=beginthread(nil,0,@wait_level_thread,nil,0,id);

          main.Memo1.Lines.Add('i='+inttostr(i));
          main.Memo1.Lines.Add('Biomes Done');
        end;
      4:begin
          application.MessageBox('Not ready yet','Error');
        end;
      5:begin   //Planetoids
          main.planet_prop.width:=strtoint(main.Edit1.Text);
          main.planet_prop.len:=strtoint(main.Edit2.Text);
          //main.planet_prop.sid:=bintoint(hextobin(main.Edit4.text));
          main.planet_prop.sid:=strtoint64(main.Edit4.text);
          main.planet_prop.potok_exit:=false;
          main.planet_prop.pop_chunks:=main.CheckBox2.Checked;

          time:=getcurrenttime;
          //gotovim strukturu dla generacii level.dat
          main.level_settings.name:=main.Edit3.Text;
          main.level_settings.path:=str;
          main.level_settings.spawnx:=0;
          main.level_settings.spawnz:=0;
          main.level_settings.spawny:=main.planet_prop.groundlevel+1;
          //level_settings.sid:=bintoint(hextobin(main.Edit4.text));
          main.level_settings.sid:=strtoint64(main.Edit4.text);
          main.level_settings.size:=0;
          main.level_settings.game_type:=main.ComboBox2.ItemIndex;
          if main.CheckBox3.Checked=true then
            main.level_settings.map_features:=1
          else
            main.level_settings.map_features:=0;
          if main.CheckBox4.Checked=true then
            main.level_settings.raining:=1
          else
            main.level_settings.raining:=0;
          main.level_settings.rain_time:=strtoint(main.Edit6.Text);
          if main.CheckBox5.Checked=true then
            main.level_settings.thundering:=1
          else
            main.level_settings.thundering:=0;
          main.level_settings.thunder_time:=strtoint(main.Edit7.Text);
          main.level_settings.game_time:=convert_time(strtoint(main.Edit8.Text),strtoint(main.Edit9.Text));

          i:=gen_planets(str,main.Edit3.Text,main.planet_prop,main.border_prop,main.level_settings);

          hndl:=i;
          //beginthread(nil,0,@wait_thread,nil,0,id);
          thread_exit:=false;
          wait_hndl:=beginthread(nil,0,@wait_level_thread,nil,0,id);

          main.Memo1.Lines.Add('i='+inttostr(i));
          main.Memo1.Lines.Add('Planetoids Done');
        end;
      6:begin     //BioSpheres
          main.biosfer_prop.width:=strtoint(main.Edit1.Text);
          main.biosfer_prop.len:=strtoint(main.Edit2.Text);
          //main.biosfer_prop.sid:=bintoint(hextobin(main.Edit4.text));
          main.biosfer_prop.sid:=strtoint64(main.Edit4.text);
          main.biosfer_prop.potok_exit:=false;
          main.biosfer_prop.pop_chunks:=main.CheckBox2.Checked;

          time:=getcurrenttime;
          //gotovim strukturu dla generacii level.dat
          main.level_settings.name:=main.Edit3.Text;
          main.level_settings.path:=str;
          main.level_settings.spawnx:=0;
          main.level_settings.spawnz:=0;
          main.level_settings.spawny:=120;
          //level_settings.sid:=bintoint(hextobin(main.Edit4.text));
          main.level_settings.sid:=strtoint64(main.Edit4.text);
          main.level_settings.size:=0;
          main.level_settings.game_type:=main.ComboBox2.ItemIndex;
          if main.CheckBox3.Checked=true then
            main.level_settings.map_features:=1
          else
            main.level_settings.map_features:=0;
          if main.CheckBox4.Checked=true then
            main.level_settings.raining:=1
          else
            main.level_settings.raining:=0;
          main.level_settings.rain_time:=strtoint(main.Edit6.Text);
          if main.CheckBox5.Checked=true then
            main.level_settings.thundering:=1
          else
            main.level_settings.thundering:=0;
          main.level_settings.thunder_time:=strtoint(main.Edit7.Text);
          main.level_settings.game_time:=convert_time(strtoint(main.Edit8.Text),strtoint(main.Edit9.Text));

          i:=gen_biosphere(str,main.Edit3.Text,main.biosfer_prop,main.border_prop,main.level_settings);

          //i:=waitforsingleobject(i,infinite);

          hndl:=i;

          thread_exit:=false;
          wait_hndl:=beginthread(nil,0,@wait_level_thread,nil,0,id);

          main.Memo1.Lines.Add('i='+inttostr(i));
          main.Memo1.Lines.Add('BioSphere Done');
        end;
      7:begin    //Golden tunnels
          main.tunnel_prop.width:=strtoint(main.Edit1.Text);
          main.tunnel_prop.len:=strtoint(main.Edit2.Text);
          //main.tunnel_prop.sid:=bintoint(hextobin(main.Edit4.text));
          main.tunnel_prop.sid:=strtoint64(main.Edit4.text);
          main.tunnel_prop.potok_exit:=false;
          main.tunnel_prop.pop_chunks:=main.CheckBox2.Checked;

          time:=getcurrenttime;
          //gotovim strukturu dla generacii level.dat
          main.level_settings.name:=main.Edit3.Text;
          main.level_settings.path:=str;
          main.level_settings.spawnx:=0;
          main.level_settings.spawnz:=0;
          main.level_settings.spawny:=64;
          //level_settings.sid:=bintoint(hextobin(main.Edit4.text));
          main.level_settings.sid:=strtoint64(main.Edit4.text);
          main.level_settings.size:=0;
          main.level_settings.game_type:=main.ComboBox2.ItemIndex;
          if main.CheckBox3.Checked=true then
            main.level_settings.map_features:=1
          else
            main.level_settings.map_features:=0;
          if main.CheckBox4.Checked=true then
            main.level_settings.raining:=1
          else
            main.level_settings.raining:=0;
          main.level_settings.rain_time:=strtoint(main.Edit6.Text);
          if main.CheckBox5.Checked=true then
            main.level_settings.thundering:=1
          else
            main.level_settings.thundering:=0;
          main.level_settings.thunder_time:=strtoint(main.Edit7.Text);
          main.level_settings.game_time:=convert_time(strtoint(main.Edit8.Text),strtoint(main.Edit9.Text));

          i:=gen_tunnels(str,main.Edit3.Text,main.tunnel_prop,main.border_prop,main.level_settings);

          hndl:=i;
          //beginthread(nil,0,@wait_thread,nil,0,id);
          thread_exit:=false;
          wait_hndl:=beginthread(nil,0,@wait_level_thread,nil,0,id);

          main.Memo1.Lines.Add('i='+inttostr(i));
          main.Memo1.Lines.Add('Tunnels Done');
        end;
      end;
    end;
  end;
end;

procedure Tmain.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if not(((key>=#48) and (key<=#57))or (key=#8)) then key:=#0;
end;

procedure Tmain.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if not(((key>=#48) and (key<=#57))or (key=#8)) then key:=#0;
end;

procedure Tmain.CheckBox1Click(Sender: TObject);
begin
  if main.CheckBox1.Checked then
  begin
    main.Edit2.Text:=main.Edit1.Text;
    main.Label2.Enabled:=false;
    main.Edit2.Enabled:=false;  
  end
  else
  begin
    main.Label2.Enabled:=true;
    main.Edit2.Enabled:=true;
  end
end;

procedure Tmain.Edit1Change(Sender: TObject);
begin
  if main.CheckBox1.Checked then
    main.Edit2.Text:=main.Edit1.Text;
end;

procedure Tmain.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
  if not(((key>=#48) and (key<=#57))
  or (key=#8)
  or ((key>=#65) and (key<=#90))
  or ((key>=#97) and (key<=#122))
  or (key=#95)) then key:=#0;
end;

procedure Tmain.Button10Click(Sender: TObject);
begin
  main.Memo1.Clear;
end;

procedure Tmain.ComboBox1Change(Sender: TObject);
var rect:trect;
i:integer;
begin
  case main.ComboBox1.ItemIndex of
  0:begin
      main.Image1.Canvas.Draw(0,0,main.flatmap_p.Picture.Graphic);
    end;
  1:begin
      main.Image1.Canvas.Draw(0,0,main.like_notch_p.Picture.Graphic);
      //main.Image1.Canvas.TextOut(20,170,'Not actual preview');
    end;
  2:begin
      main.Image1.Canvas.Draw(0,0,main.settings_p.Picture.Graphic);
      main.Image1.Canvas.TextOut(20,170,'Not actual preview');
    end;
  3:begin
      main.Image1.Canvas.Draw(0,0,main.desert_p.Picture.Graphic);
    end;
  5:begin
      main.Image1.Canvas.Draw(0,0,main.planetoids_p.Picture.Graphic);
      {if main.border_prop.border_type=3 then
      begin
        main.border_prop.border_type:=0;  
        application.MessageBox('You cannot use this type of border with Planetoid type map'+#13+#10+'Border type changed to "Normal transition"','Notice');
      end;  }
    end;
  6:begin
      if (main.border_prop.border_type<>0)and(main.biosfer_prop.underwater=true) then
      begin
        main.biosfer_prop.underwater:=false;
        main.biosfer_prop.gen_skyholes:=false;
        application.MessageBox('You cannot use this type of border with BioSphere underwater map.'+#13+#10+'BioSphere underwater option changed to default.','Notice');
      end;
      main.Image1.Canvas.Draw(0,0,main.biospheres_p.Picture.Graphic);
    end;
  7:begin
      main.Image1.Canvas.Draw(0,0,main.tunnels_p.Picture.Graphic);
      if main.border_prop.border_type=3 then
      begin
        main.border_prop.border_type:=0;
        application.MessageBox('You cannot use this type of border with Golden Tunnels type map'+#13+#10+'Border type changed to "Normal transition"','Notice');
      end;
    end
  else
    begin  
      rect.Left:=0;
      rect.Top:=0;
      rect.Bottom:=200;
      rect.Right:=250;
      main.Image1.Canvas.FillRect(rect);
      main.Image1.Canvas.TextOut(80,90,'Not yet implemented');
    end;
  end;
end;

procedure Tmain.Button2Click(Sender: TObject);
begin
  border.ShowModal;
end;

procedure Tmain.Button3Click(Sender: TObject);
begin
  application.MessageBox('Not ready yet','');
end;

procedure Tmain.Button4Click(Sender: TObject);
begin
  //application.MessageBox('Not ready yet','');
  player.ShowModal;
end;

procedure Tmain.Button6Click(Sender: TObject);
var l,l1:longword;
begin
  //delaem SID
  {randomize;
  l:=random(4294967290);
  l1:=random(4294967290);
  main.Edit4.Text:=inttohex(l,8)+inttohex(l1,8); }
  main.Edit4.Text:=inttostr(sid_rand.nextLong);
end;

procedure Tmain.Button8Click(Sender: TObject);
begin
  load.ShowModal;
  //application.MessageBox('Load settings not functioning in this version.'+#13+#10+'It will be available in further versions.','Notice');
end;

procedure Tmain.Button13Click(Sender: TObject);
begin
  //TerminateThread(wait_hndl,100);
  //TerminateThread(hndl,100);
  thread_exit:=true;
  case thread_exit_type of
  0:main.flatmap_prop.potok_exit:=true;
  1:main.original_prop.potok_exit:=true;
  2:;
  3:main.biomes_desert_prop.potok_exit:=true;
  4:;
  5:main.planet_prop.potok_exit:=true;
  6:main.biosfer_prop.potok_exit:=true;
  7:main.tunnel_prop.potok_exit:=true;
  end;

  main.Memo1.Lines.Add('Termination done');
end;

procedure Tmain.Edit4KeyPress(Sender: TObject; var Key: Char);
var str:string;
begin
//  main.Memo1.Lines.Add('Key='+inttostr(ord(key)));
  if (key=#24)or(key=#3)or(key=#22) then exit;

  if not(((key>=#48)and(key<=#57))or(key=#45)or(key=#8)or(key=#46)) then
  begin
    key:=#0;
    exit;
  end;

  if (main.Edit4.SelStart<>0)and(key=#45) then
  begin
    key:=#0;
    exit;
  end;

  str:=main.Edit4.Text;
  if (length(str)>=20)and(key<>#8)and(key<>#46)and(main.Edit4.SelLength<1) then key:=#0;

  {if not(((key>=#48) and (key<=#57))or (
  key=#8)or
  ((key>=#65) and (key<=#70))or
  ((key>=#97) and (key<=#102))) then key:=#0;  }
end;

procedure Tmain.Edit4Change(Sender: TObject);
var str:string;
i:integer;
begin
  str:=main.Edit4.Text;
  if length(str)>=21 then
  begin
    setlength(str,21);
    main.Edit4.Text:=str;
  end;

  i:=posex('-',str,2);
  if i<>0 then
  begin
    while i<>0 do
    begin
      delete(str,i,1);
      i:=posex('-',str,2);
    end;
    main.Edit4.Text:=str;
  end;
end;

procedure Tmain.FormDestroy(Sender: TObject);
begin
  sid_rand.Free;
end;

procedure Tmain.Edit4Exit(Sender: TObject);
begin
  if proverka_int64(main.Edit4.Text)=true then
  begin
    application.MessageBox('You have entered wrong SID.'+#13+#10+'SID must be between -9223372036854775808 and 9223372036854775807','Error');
    main.Edit4.SelStart:=0;
    main.Edit4.SelLength:=length(main.Edit4.Text);
    main.Edit4.SetFocus;
    exit;
  end;
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

procedure Tmain.Edit7KeyPress(Sender: TObject; var Key: Char);
var str:string;
begin
  if (key=#24)or(key=#3)or(key=#22) then exit;

  if not(((key>=#48)and(key<=#57))or(key=#8)or(key=#46)) then
  begin
    key:=#0;
    exit;
  end;

  str:=main.Edit7.Text;
  if (length(str)>=8)and(key<>#8)and(key<>#46)and(main.Edit7.SelLength<1) then key:=#0;
end;

procedure Tmain.CheckBox4Click(Sender: TObject);
begin
  if main.CheckBox4.Checked then
    main.CheckBox5.Enabled:=true
  else
  begin
    main.CheckBox5.Checked:=false;
    main.CheckBox5.Enabled:=false;
  end;
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

procedure Tmain.Edit6Exit(Sender: TObject);
begin
  if main.Edit6.Text='' then
    main.Edit6.Text:='0';
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

procedure Tmain.Edit7Change(Sender: TObject);
var str:string;
begin
  str:=main.Edit7.Text;
  if length(str)>=8 then
  begin
    setlength(str,8);
    main.Edit7.Text:=str;
  end;
end;

procedure Tmain.Edit7Exit(Sender: TObject);
begin
  if main.Edit7.Text='' then
    main.Edit7.Text:='0';
end;

procedure WaitAWhile(n: cardinal);
var
  StartTime: cardinal;
begin
  StartTime := gettickcount;
  while gettickcount < StartTime + n do
    ;
end;


procedure Tmain.Button14Click(Sender: TObject);
begin
  preview.Show;
end;

procedure Tmain.Button5Click(Sender: TObject);
var provider:ChunkProviderGenerate;
biomes:ar_BiomeGenBase;
mas:ar_type;
i,j:integer;
str:string;
x,y,z:integer;
chx,chy:integer;
map:region;
begin
  chx:=0;
  chy:=0;

  {setlength(map,36);
  for i:=0 to 35 do
    setlength(map[i],36);

  for i:=0 to 35 do
    for j:=0 to 35 do
    begin
      setlength(map[i][j].blocks,32768);
      setlength(map[i][j].data,32768);
      setlength(map[i][j].light,32768);
      setlength(map[i][j].skylight,32768);
      setlength(map[i][j].heightmap,256);
    end;}

  provider:=ChunkProviderGenerate.Create(12345,false);
  setlength(mas,16*16*128);
  //biomes:=provider.provideChunk(mas,chx,chy);

  //provider.populate(map,0,-1,chx,chy);

  {main.Memo1.Lines.Add('Biomes for chunk '+inttostr(chx)+','+inttostr(chy));

  if length(biomes)=100 then
  begin
  str:='';
  for x:=0 to 9 do
  begin
    if (x=3)or(x=7) then main.Memo1.Lines.Add('');
    for z:=0 to 9 do
    begin
          str:=str+inttostr(biomes[z+x*10].biomeID);
          if (z=2)or(z=6) then str:=str+'  '
          else str:=str+',';

          if z=9 then
          begin
            main.Memo1.Lines.Add(str);
            str:='';
          end;
    end;
  end;
  end;

  if length(biomes)=256 then
  begin
  str:='';
  for x:=0 to 15 do
    for z:=0 to 15 do
    begin
          str:=str+inttostr(biomes[z+x*16].biomeID)+',';
          if z=15 then
          begin
            main.Memo1.Lines.Add(str);
            str:='';
          end;
    end;
  end;  }

  chx:=0;
  chy:=0;
  biomes:=provider.provideChunk(mas,chx,chy);
  provider.Clear;

  if length(biomes)=100 then
  begin
  str:='';
  for x:=0 to 9 do
  begin
    if (x=3)or(x=7) then main.Memo1.Lines.Add('');
    for z:=0 to 9 do
    begin
          str:=str+inttostr(biomes[z+x*10].biomeID);
          if (z=2)or(z=6) then str:=str+'  '
          else str:=str+',';

          if z=9 then
          begin
            main.Memo1.Lines.Add(str);
            str:='';
          end;
    end;
  end;
  end;

  if length(biomes)=256 then
  begin
  str:='';
  for x:=0 to 15 do
    for z:=0 to 15 do
    begin
          str:=str+inttostr(biomes[z+x*16].biomeID)+',';
          if z=15 then
          begin
            main.Memo1.Lines.Add(str);
            str:='';
          end;
    end;
  end;

  main.Memo1.Lines.Add('Blocks for chunk '+inttostr(chx)+','+inttostr(chy));

  str:='';
  for z:=0 to 15 do
    for x:=0 to 15 do
      for y:=0 to 127 do
      begin
        if mas[y+(z*128+(x*2048))]=0 then
        begin
          //main.Memo1.Lines.Add(inttostr(y-1)+',');
          str:=str+inttostr(y-1)+',';
          if x=15 then
          begin
            main.Memo1.Lines.Add(str);
            str:='';
          end;
          break;
        end;
      end;

  chx:=1;
  chy:=0;
  biomes:=provider.provideChunk(mas,chx,chy);
  provider.Clear;

  if length(biomes)=100 then
  begin
  str:='';
  for x:=0 to 9 do
  begin
    if (x=3)or(x=7) then main.Memo1.Lines.Add('');
    for z:=0 to 9 do
    begin
          str:=str+inttostr(biomes[z+x*10].biomeID);
          if (z=2)or(z=6) then str:=str+'  '
          else str:=str+',';

          if z=9 then
          begin
            main.Memo1.Lines.Add(str);
            str:='';
          end;
    end;
  end;
  end;

  if length(biomes)=256 then
  begin
  str:='';
  for x:=0 to 15 do
    for z:=0 to 15 do
    begin
          str:=str+inttostr(biomes[z+x*16].biomeID)+',';
          if z=15 then
          begin
            main.Memo1.Lines.Add(str);
            str:='';
          end;
    end;
  end;

  main.Memo1.Lines.Add('Blocks for chunk '+inttostr(chx)+','+inttostr(chy));

  str:='';
  for z:=0 to 15 do
    for x:=0 to 15 do
      for y:=0 to 127 do
      begin
        if mas[y+(z*128+(x*2048))]=0 then
        begin
          //main.Memo1.Lines.Add(inttostr(y-1)+',');
          str:=str+inttostr(y-1)+',';
          if x=15 then
          begin
            main.Memo1.Lines.Add(str);
            str:='';
          end;
          break;
        end;
      end;

  provider.Free;
end;

end.

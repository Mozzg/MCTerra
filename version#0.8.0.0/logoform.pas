unit logoform;

interface

uses
  Windows, Forms, jpeg, Classes, Graphics, ExtCtrls, Controls;

type
  Tlogof = class(TForm)
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  logof: Tlogof;

implementation

uses zlibex, registry, sysutils;

{$R *.dfm}

procedure Delay(ms:cardinal);
var time:cardinal;
begin
  time:=GetTickCount+ms;
  while (time>GetTickCount)and not(Application.Terminated) do
    application.ProcessMessages;
end;

function BitmapToRegion(Bitmap: TBitmap; TransColor: TColor): HRGN;
var X, Y: Integer;
    XStart: Integer;
begin
 Result := 0;
 with Bitmap do
 for Y := 0 to Height - 1 do
  begin
   X := 0;
   while X < Width do
    begin
     // Пропускаем прозрачные точки
     while (X < Width) and (Canvas.Pixels[X, Y] = TransColor) do
      Inc(X);
      if X >= Width then
      Break;
      XStart := X;
     // Пропускаем непрозрачные точки
     while (X < Width) and (Canvas.Pixels[X, Y] <> TransColor) do
      Inc(X);
      // Создаём новый прямоугольный регион и добавляем его к
      // региону всей картинки
      if Result = 0 then
       Result := CreateRectRgn(XStart, Y, X, Y + 1)
     else           
       CombineRgn(Result, Result,
       CreateRectRgn(XStart, Y, X, Y + 1), RGN_OR);
     end;
  end;
end;


procedure Tlogof.FormCreate(Sender: TObject);
var bit:TBitmap;
begin
  bit:=TBitmap.Create;
  image1.Width:=Image1.Picture.Bitmap.Width;
  image1.Height:=Image1.Picture.Bitmap.Height;
  logof.Width:=Image1.Width+50;
  logof.Height:=Image1.Height+50;
  logof.Left:=round(screen.Width/2-image1.Width/2);
  logof.Top:=round(screen.Height/2-image1.Height/2);
  bit:=logof.Image1.Picture.Bitmap;
  SetWindowRgn(Self.Handle, BitmapToRegion(bit,clwhite), True);
end;

procedure Tlogof.FormShow(Sender: TObject);
var fstr:tfilestream;
compr:tzdecompressionstream;
res:TResourceStream;
pch:pchar;
str:string;
hreg:tregistry;
i:integer;
begin
  AnimateWindow(Handle, 300, AW_ACTIVATE or AW_BLEND);

  try
  //raspakovivaem shrift
  windows.deletefile('FMPTSR-1.TTF');
  res:=tresourcestream.Create(hInstance, 'MY_FONT', Pchar('FMP'));
  fstr:=tfilestream.Create('FMPTSR-1.TTF',$FFFF or $0002);    //create, openreadwrite
  compr:=tzdecompressionstream.Create(res);
  compr.Position:=0;
  fstr.CopyFrom(compr,compr.Size);

  //osvobozhdaem potoki
  compr.Free;
  res.Free;
  fstr.Free;

  //pomeshaem shrift v papku shriftov vindows
  pch := StrAlloc(MAX_PATH);
  i := GetWindowsDirectory(pch, MAX_PATH);
  if i=0 then
  begin
    application.MessageBox('Font instalation failed','Error');
    halt(0);
  end;
  //if Res > 0 then
  str := StrPas(pch);
  str:=str+'\Fonts\';
  copyfile('FMPTSR-1.TTF',pchar(str+'FMPTSR-1.TTF'),true);

  //udalaem uzhe nenuzhniy fayl
  windows.deletefile('FMPTSR-1.TTF');

  //zapisivaem v reestr infu pro shrift
  hReg := TRegistry.Create; 
  hReg.RootKey := HKEY_LOCAL_MACHINE; 
  hReg.LazyWrite := false; 
  hReg.OpenKey('Software\Microsoft\Windows NT\CurrentVersion\Fonts',
               false); 
  hReg.WriteString('FMPTSR-Credits Bold (TrueType)','FMPTSR-1.TTF');
  hReg.CloseKey;
  hReg.free;

  //dobavlaem shrift v sistemu
  AddFontResource(pchar(str+'FMPTSR-1.TTF'));

  //uvedomlaem prilozheniya, chto izmenilis shrifti
  postMessage($FFFF, $001D, 0, 0);     //WM_FONTCHANGE

  except
    on e:exception do
    begin
      MessageBox(logof.Handle,'The program couldn''t install nessesary font, because it has no permission to do that. Some text may be misplaced.'+#13+#10+'To allow this program to install the font, run it with administrator rights.','WARNING',MB_OK	or MB_ICONEXCLAMATION);
      //application.MessageBox('You must run this program with admin rights','Error');
      //halt(0);
    end;
  end;


  //shrifti nadpisey izmenayutsa v sootvetstvuyushih im procedurah FormCreate dla form

end;

procedure Tlogof.FormHide(Sender: TObject);
begin
  AnimateWindow(Handle, 300, AW_BLEND or AW_HIDE);
end;

end.

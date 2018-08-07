unit previewf;

interface

uses
  Controls, Classes, StdCtrls, ExtCtrls, Forms, Dialogs;

type
  Tpreview = class(TForm)
    Image1: TImage;
    Button1: TButton;
    Button2: TButton;
    SaveDialog1: TSaveDialog;
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  preview: Tpreview;

procedure init_form_preview(hndl:LongWord);

implementation

uses Graphics, Windows, generation;

procedure init_form_preview(hndl:LongWord);
begin
  Application.Handle:=hndl;
  preview:=Tpreview.Create(Application);
end;

{$R *.dfm}

procedure Tpreview.Button2Click(Sender: TObject);
begin
  modalresult:=mrCancel;
end;

procedure Tpreview.FormShow(Sender: TObject);
var scr_wid,scr_hei:integer;
x,z:integer;
begin
  scr_wid:=screen.Width;
  scr_hei:=screen.Height;

  x:=preview.Image1.Left+preview.Image1.Width;
  z:=preview.Image1.Top+preview.Image1.Height;
  if x<180 then x:=180;
  inc(x,30);
  inc(z,30);

  //proverka, ne slishkom li bol'shoe okno
  if x>(scr_wid-100) then x:=scr_wid-100;
  if z>(scr_hei-100) then z:=scr_hei-100;

  //application.MessageBox(pchar('Width='+inttostr(x)),'');

  preview.Width:=x;
  preview.Height:=z;

  preview.Top:=round(scr_hei/2-preview.Height/2);
  preview.Left:=round(scr_wid/2-preview.Width/2);  
end;

procedure Tpreview.Button1Click(Sender: TObject);
var s:string;
begin
  if preview.SaveDialog1.Execute then
  begin
    //preview.Image1.Picture.SaveToFile('prev.bmp');
    preview.Image1.Picture.SaveToFile(preview.SaveDialog1.FileName);
    messagebox(app_hndl,'Save complete','Notice',MB_OK);
  end;
end;

end.

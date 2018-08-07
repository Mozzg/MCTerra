unit previewf;

interface

uses
  Graphics, Forms, Controls, Dialogs, StdCtrls, ExtCtrls, Classes;

type
  Tpreview = class(TForm)
    Image1: TImage;
    Button1: TButton;
    Button2: TButton;
    SaveDialog1: TSaveDialog;
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  preview: Tpreview;

implementation

{$R *.dfm}

procedure Tpreview.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  if (newwidth>preview.Image1.Width+28) then newwidth:=preview.Image1.Width+28;
  if (newheight>preview.Image1.Height+88) then newheight:=preview.Image1.Height+88;

  if newwidth<245 then newwidth:=245;
  if newheight<200 then newheight:=200;

  if (newwidth<preview.Image1.Width+28) then
    if (preview.Image1.Width+28)>800 then newwidth:=800
    else newwidth:=preview.Image1.Width+28;
  if (newheight<preview.Image1.Height+88) then
    if (preview.Image1.Height+88)>600 then newheight:=600
    else newheight:=preview.Image1.Height+88;

  resize:=true;
end;

procedure Tpreview.Button1Click(Sender: TObject);
begin
  if preview.SaveDialog1.Execute then
  begin
    preview.Image1.Picture.SaveToFile(preview.SaveDialog1.FileName);
  end;
end;

procedure Tpreview.Button2Click(Sender: TObject);
begin
  preview.Hide;
end;

procedure Tpreview.FormHide(Sender: TObject);
begin    
  image1.Picture:=nil;
end;

procedure Tpreview.FormShow(Sender: TObject);
var newwidth,newheight:integer;
a1,a2:integer;
begin
  newwidth:=preview.Width;
  newheight:=preview.Height;
  a1:=newwidth;
  a2:=newheight;

  if (newwidth>preview.Image1.Width+28) then newwidth:=preview.Image1.Width+28;
  if (newheight>preview.Image1.Height+88) then newheight:=preview.Image1.Height+88;

  if newwidth<245 then a1:=245;
  if newheight<200 then a2:=200;

  if (newwidth<preview.Image1.Width+28) then
    if (preview.Image1.Width+28)>800 then a1:=800
    else a1:=preview.Image1.Width+28;
  if (newheight<preview.Image1.Height+88) then
    if (preview.Image1.Height+88)>600 then a2:=600
    else a2:=preview.Image1.Height+88;

  if (a1<>newwidth) then preview.Width:=a1;
  if (a2<>newheight) then preview.Height:=a2;
end;

end.

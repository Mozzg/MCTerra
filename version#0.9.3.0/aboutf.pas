unit aboutf;

interface

uses
  Forms, Controls, StdCtrls, Classes;

type
  Tabout = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  about: Tabout;

implementation

uses mainf;

{$R *.dfm}

procedure Tabout.Button1Click(Sender: TObject);
begin
  modalresult:=mrok;
end;

procedure Tabout.FormShow(Sender: TObject);
begin
  about.Label1.Font.Name:='FMPTSR-Credits';
  about.Label2.Font.Name:='FMPTSR-Credits';
  about.Label3.Font.Name:='FMPTSR-Credits';
end;

procedure Tabout.FormCreate(Sender: TObject);
begin
  {about.Left:=round(screen.Width/2-about.Width/2);
  about.Top:=round(screen.Height/2-about.Height/2);  }
  if save_opt.save_enabled=true then
    if (save_opt.about_f.top<>-1)and(save_opt.about_f.left<>-1) then
    begin
      about.Top:=save_opt.about_f.top;
      about.Left:=save_opt.about_f.left;
    end;
end;

end.

unit aboutf;

interface

uses
 Forms, Classes, Controls, StdCtrls;

type
  Tabout = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Button1: TButton;
    Label6: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  about: Tabout;

implementation

{$R *.dfm}

procedure Tabout.Button1Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure Tabout.FormCreate(Sender: TObject);
begin
  about.Label1.Font.Name:='FMPTSR-Credits';
  about.Label2.Font.Name:='FMPTSR-Credits';
  about.Label3.Font.Name:='FMPTSR-Credits';
end;

end.

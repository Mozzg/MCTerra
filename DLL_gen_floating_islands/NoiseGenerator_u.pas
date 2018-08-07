unit NoiseGenerator_u;

interface

uses RandomMCT;

type NoiseGenerator=class(TObject)
     public
       constructor Create(rand:rnd); overload; virtual; abstract;
       constructor Create; overload; virtual; abstract;
     end;

implementation

end.

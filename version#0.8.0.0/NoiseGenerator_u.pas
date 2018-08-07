unit NoiseGenerator_u;

interface

uses randomMCT;

type NoiseGenerator=class(TObject)
     public
       constructor Create(random:rnd); overload;virtual;abstract;
       constructor Create; overload;virtual; abstract;
     end;    

implementation

end.

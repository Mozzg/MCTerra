unit WorldGenerator_u;

interface

uses generation, RandomMCT;

type WorldGenerator=class(TObject)
     public
       function generate(xreg,yreg:integer; map:region; rand:rnd; i,j,k:integer):boolean; virtual; abstract;
       procedure func_517_a(d,d1,d2:double); virtual;
     end;

implementation

procedure WorldGenerator.func_517_a(d,d1,d2:double);
begin
end;

end.

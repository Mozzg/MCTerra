unit WorldGenerator_u;

interface

uses generation_obsh, RandomMCT;

type  WorldGenerator=class(TObject)
      public
        constructor Create; virtual;
        function generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean; virtual; abstract;
        procedure func_517_a(d,d1,d2:double); virtual;
      end;

implementation

constructor WorldGenerator.Create;
begin
end;

procedure WorldGenerator.func_517_a(d,d1,d2:double);
begin
end;

end.

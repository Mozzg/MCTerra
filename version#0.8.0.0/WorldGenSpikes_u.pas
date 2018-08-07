unit WorldGenSpikes_u;

interface

uses WorldGenerator_u, generation_obsh, RandomMCT;

type  WorldGenSpikes=class(WorldGenerator)
      private
        field_40197_a:integer;
      public
        constructor Create(i:integer); reintroduce;
        function generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean; override;
      end;

implementation

constructor WorldGenSpikes.Create(i:integer);
begin
  field_40197_a:=i;
end;

function WorldGenSpikes.generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean;
begin
  //todo:
  result:=true;
end;

end.

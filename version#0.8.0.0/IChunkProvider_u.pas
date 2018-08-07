unit IChunkProvider_u;

interface

uses generation_obsh, BiomeGenBase_u, NBT;

type  IChunkProvider=class(TObject)
      public
        function provideChunk(abyte0:ar_type; i,j:integer):ar_BiomeGenBase; virtual; abstract;
        procedure populate(map:region; xreg,yreg,i,j:integer); virtual; abstract;
      end;

implementation

end.

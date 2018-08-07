unit IChunkProvider_u;

interface

uses generation;

type IChunkProvider=class(TObject)
     public
       function provideChunk(abyte0:ar_byte; i,j:integer; biomes:ar_byte):boolean; virtual; abstract;
     end;

implementation

end.

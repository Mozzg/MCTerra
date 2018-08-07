unit crc32_u;

interface  

procedure CalcCRC32(p:pointer; nbyte: WORD; var CRCvalue: LongInt);

implementation

var
  CRCtable: array[0..255] of cardinal;

procedure CalcCRC32(p:pointer; nbyte: WORD; var CRCvalue: LongInt);
type t_ar=array[1..65521] of byte;
var q:^t_ar;
i:integer;
begin
  q := p;
  CRCvalue:=$FFFFFFFF;
  for i := 1 to nBYTE do
    CRCvalue := (CRCvalue shr 8) xor CRCtable[q^[i] xor (CRCvalue and $000000FF)];
end; 

procedure CRCInit;
var
  c: cardinal;
  i, j: integer;
begin
  for i := 0 to 255 do
  begin
    c := i;
    for j := 1 to 8 do
      if odd(c) then
        c := (c shr 1) xor $EDB88320
      else
        c := (c shr 1);
    CRCtable[i] := c;
  end;
end;


initialization
  crcinit;
end.

unit LongHashMapEntry_u;

interface

type  LongHashMapEntry=class(TObject)
      public
        field_35832_b:TObject;
        field_35833_c:LongHashMapEntry;
        field_35831_d:integer;
        field_35834_a:int64;
        constructor Create(i:integer; l:int64; obj:TObject; Hash:LongHashMapEntry);
        function func_35830_a:int64;
        function func_35829_b:TObject;
        function equals(obj:TObject):boolean;
      end;

      ar_LongHashMapEntry=array of LongHashMapEntry;

implementation

constructor LongHashMapEntry.Create(i:integer; l:int64; obj:TObject; Hash:LongHashMapEntry);
begin
  field_35832_b:= obj;
  field_35833_c:= Hash;
  field_35834_a:= l;
  field_35831_d:= i;
end;

function LongHashMapEntry.func_35830_a:int64;
begin
  result:=field_35834_a;
end;

function LongHashMapEntry.func_35829_b:TObject;
begin
  result:=field_35832_b;
end;

function LongHashMapEntry.equals(obj:TObject):boolean;
begin
  if not(obj is LongHashMapEntry) then
  begin
    result:=false;
    exit;
  end;

  if (func_35830_a=LongHashMapEntry(obj).func_35830_a)and
  (func_35829_b=LongHashMapEntry(obj).func_35829_b) then
    result:=true
  else
    result:=false;
end;

end.

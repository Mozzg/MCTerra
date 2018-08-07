unit LongHashMapEntry_u;

interface

type LongHashMapEntry=class(TObject)
     public
       key:int64;
       value:TObject;
       nextEntry:LongHashMapEntry;
       field_35831_d:integer;
       constructor Create(i:integer; l:int64; obj:TObject; longhashentry:LongHashMapEntry);
       function func_35830_a:int64;
       function func_35829_b:TObject;
       function equals(obj:TObject):boolean;
     end;

     ar_LongHashMapEntry = array of LongHashMapEntry;

implementation

constructor LongHashMapEntry.Create(i:integer; l:int64; obj:TObject; longhashentry:LongHashMapEntry);
begin
  value:=obj;
  nextEntry:=longhashentry;
  key:=l;
  field_35831_d:=i;
end;

function LongHashMapEntry.func_35830_a:int64;
begin
  result:=key;
end;

function LongHashMapEntry.func_35829_b:TObject;
begin
  result:=value;
end;

function LongHashMapEntry.equals(obj:TObject):boolean;
begin
  if not(obj is LongHashMapEntry)then
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

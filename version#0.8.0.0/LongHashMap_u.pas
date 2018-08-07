unit LongHashMap_u;

interface

uses LongHashMapEntry_u;

type  LongHashMap=class(TObject)
      private
        ListEntries:ar_LongHashMapEntry;
        numHashElements,capacity,field_35581_e:integer;
        percent:double;
        function getHashedKey(l:int64):integer;
        function hash(i:integer):integer;
        function getHashIndex(i,j:integer):integer;
        procedure createKey(i:integer; l:int64; obj:TObject; j:integer);
        procedure resizeTable(i:integer);
        procedure copyHashTableTo(alonghashmapentry:ar_LongHashMapEntry);
      public
        constructor Create; reintroduce;
        destructor Destroy; override;
        function getNumHashElements:integer;
        function getValueByKey(l:int64):TObject;
        function func_35575_b(l:int64):boolean;
        function func_35569_c(l:int64):LongHashMapEntry;
        procedure add(l:int64; obj:TObject);
        function remove(l:int64):TObject;
        function removeKey(l:int64):LongHashMapEntry;
        function getHashCode(l:int64):integer;
      end;

implementation

constructor LongHashMap.Create;
begin
  percent:=0.75;
  capacity:=12;
  setlength(ListEntries,16);
end;

destructor LongHashMap.Destroy;
begin
  setlength(ListEntries,0);
end;

function LongHashMap.getHashedKey(l:int64):integer;
begin
  result:=hash(l xor(l shr 32));
end;

function LongHashMap.hash(i:integer):integer;
begin
  i:=i xor ((i shr 20)xor(i shr 12));
  result:=i xor(i shr 7)xor(i shr 4);
end;

function LongHashMap.getHashIndex(i,j:integer):integer;
begin
  result:=i and (j-1);
end;

function LongHashMap.getNumHashElements:integer;
begin
  result:=numHashElements;
end;

function LongHashMap.getValueByKey(l:int64):TObject;
var i:integer;
entry:LongHashMapEntry;
begin
  i:=getHashedKey(l);
  entry:=ListEntries[getHashIndex(i, length(ListEntries))];
  while entry<>nil do
  begin
    if(entry.field_35834_a=l) then
    begin
      result:=entry.field_35832_b;
      exit;
    end;
    entry:=entry.field_35833_c;
  end;
  result:=nil;
end;

function LongHashMap.func_35575_b(l:int64):boolean;
begin
  result:=(func_35569_c(l)<>nil);
end;

function LongHashMap.func_35569_c(l:int64):LongHashMapEntry;
var i:integer;
entry:LongHashMapEntry;
begin
  i:=getHashedKey(l);
  entry:=ListEntries[getHashIndex(i, length(ListEntries))];
  while entry<>nil do
  begin
    if(entry.field_35834_a=l) then
    begin
      result:=entry;
      exit;
    end;
    entry:=entry.field_35833_c;
  end;
  result:=nil;
end;

procedure LongHashMap.add(l:int64; obj:TObject);
var i,j:integer;
entry:LongHashMapEntry;
begin
  i:=getHashedKey(l);
  j:=getHashIndex(i, length(ListEntries));
  entry:=ListEntries[j];
  while entry<>nil do
  begin
    if(entry.field_35834_a=l) then
    begin
      entry.field_35832_b:=obj;
    end;
    entry:=entry.field_35833_c;
  end;
  inc(field_35581_e);
  createKey(i, l, obj, j);
end;

procedure LongHashMap.resizeTable(i:integer);
var alonghashmapentry,alonghashmapentry1:ar_LongHashMapEntry;
j:integer;
begin
  alonghashmapentry:=ListEntries;
  j:=length(alonghashmapentry);
  if(j=$40000000) then
    capacity:=$7fffffff
  else
  begin
    setlength(alonghashmapentry1,i);
    copyHashTableTo(alonghashmapentry1);
    ListEntries:=alonghashmapentry1;
    capacity:=trunc(i*percent);
  end;
end;

procedure LongHashMap.copyHashTableTo(alonghashmapentry:ar_LongHashMapEntry);
var alonghashmapentry1:ar_LongHashMapEntry;
hashmapentry,hashmapentry1:LongHashMapEntry;
i,j,k:integer;
begin
  alonghashmapentry1:=ListEntries;
  i:=length(alonghashmapentry);
  for j:=0 to length(alonghashmapentry1)-1 do
  begin
    hashmapentry:=alonghashmapentry1[j];
    if(hashmapentry=nil) then continue;
    alonghashmapentry1[j]:=nil;
    repeat
      hashmapentry1:=hashmapentry.field_35833_c;
      k:=getHashIndex(hashmapentry.field_35831_d, i);
      hashmapentry.field_35833_c:=alonghashmapentry[k];
      alonghashmapentry[k]:=hashmapentry;
      hashmapentry:=hashmapentry1;
    until hashmapentry=nil;
  end;
end;

function LongHashMap.remove(l:int64):TObject;
var entry:LongHashMapEntry;
begin
  entry:=removeKey(l);
  if entry<>nil then result:=entry.field_35832_b
  else result:=nil;
end;

function LongHashMap.removeKey(l:int64):LongHashMapEntry;
var hashmapentry,hashmapentry1,hashmapentry2:LongHashMapEntry;
i,j:integer;
begin
  i:=getHashedKey(l);
  j:=getHashIndex(i, length(ListEntries));
  hashmapentry:=ListEntries[j];
  hashmapentry1:=hashmapentry;
  while hashmapentry1<>nil do
  begin
    hashmapentry2:=hashmapentry1.field_35833_c;
    if(hashmapentry1.field_35834_a=l) then
    begin
      inc(field_35581_e);
      dec(numHashElements);
      if(hashmapentry=hashmapentry1) then
        ListEntries[j]:=hashmapentry2
      else
        hashmapentry.field_35833_c:=hashmapentry2;
      result:=hashmapentry1;
      exit;
    end;
    hashmapentry:=hashmapentry1;

    hashmapentry1:=hashmapentry2;
  end;
  result:=hashmapentry1;
end;

procedure LongHashMap.createKey(i:integer; l:int64; obj:TObject; j:integer);
var entry:LongHashMapEntry;
begin
  entry:=ListEntries[j];
  ListEntries[j]:=LongHashMapEntry.Create(i,l,obj,entry);
  if(numHashElements>=capacity) then
    resizeTable(2 * length(ListEntries));
  inc(numHashElements);
end;

function LongHashMap.getHashCode(l:int64):integer;
begin
  result:=getHashedKey(l);
end;

end.

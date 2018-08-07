unit LongHashMap_u;

interface

uses LongHashMapEntry_u;

type LongHashMap=class(TObject)
     private
       hashArray:ar_LongHashMapEntry;
       numHashElements,modCount,capacity:integer;
       percent:double;
       function hash(i:integer):integer;
       function getHashedKey(l:int64):integer;
       function getHashIndex(i,j:integer):integer;
       procedure resizeTable(i:integer);
       procedure copyHashTableTo(alonghashmapentry:ar_LongHashMapEntry);
       procedure createKey(i:integer; l:int64; obj:TObject; j:integer);
     public
       constructor Create;
       destructor Destroy; override;
       function getNumHashElements:integer;
       function getValueByKey(l:int64):TObject;
       function containsKey(l:int64):boolean;
       function getEntry(l:int64):LongHashMapEntry;
       procedure add(l:int64; obj:TObject);
       function remove(l:int64):TObject;
       function removeKey(l:int64):LongHashMapEntry;
       function getHashCode(l:int64):integer;
     end;

implementation

constructor LongHashMap.Create;
begin
  capacity:=12;
  percent:=0.75;
  setlength(hashArray,16);
end;

destructor LongHashMap.Destroy;
var t:integer;
begin
  for t:=0 to length(hashArray)-1 do
    if hashArray[t]<>nil then hashArray[t].Free;
  setlength(hashArray,0);
  inherited;
end;

function LongHashMap.getHashedKey(l:int64):integer;
begin
  //return hash((int)(l ^ l >>> 32));
  result:=hash(l xor(l shr 32));
end;

function LongHashMap.hash(i:integer):integer;
begin
  {i ^= i >>> 20 ^ i >>> 12;
  return i ^ i >>> 7 ^ i >>> 4;}
  i:=i xor ((i shr 20)xor(i shr 12));
  result:=i xor(i shr 7)xor(i shr 4);
end;

function LongHashMap.getHashIndex(i,j:integer):integer;
begin
  result:=i and (j - 1);
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
  //for (LongHashMapEntry longhashmapentry = hashArray[getHashIndex(i, hashArray.length)]; longhashmapentry != null; longhashmapentry = longhashmapentry.nextEntry)
  entry:=hashArray[getHashIndex(i, length(hashArray))];
  while entry<>nil do
  begin
    if entry.key=l then
    begin
      result:=entry.value;
      exit;
    end;
    entry:=entry.nextEntry;
  end;
  result:=nil;
end;

function LongHashMap.containsKey(l:int64):boolean;
begin
  result:=getEntry(l)<>nil;
end;

function LongHashMap.getEntry(l:int64):LongHashMapEntry;
var i:integer;
entry:LongHashMapEntry;
begin
  i:=getHashedKey(l);
  //for (LongHashMapEntry longhashmapentry = hashArray[getHashIndex(i, hashArray.length)]; longhashmapentry != null; longhashmapentry = longhashmapentry.nextEntry)
  entry:=hashArray[getHashIndex(i, length(hashArray))];
  while entry<>nil do
  begin
    if entry.key=l then
    begin
      result:=entry;
      exit;
    end;
    entry:=entry.nextEntry;
  end;
  result:=nil;
end;

procedure LongHashMap.add(l:int64; obj:TObject);
var i,j:integer;
entry:LongHashMapEntry;
begin
  i:=getHashedKey(l);
  j:=getHashIndex(i, length(hashArray));
  //for (LongHashMapEntry longhashmapentry = hashArray[j]; longhashmapentry != null; longhashmapentry = longhashmapentry.nextEntry)
  entry:=hashArray[j];
  while entry<>nil do
  begin
    if (entry.key = l) then
    begin
      entry.value:=obj;
    end;
    entry:=entry.nextEntry;
  end;
  inc(modCount);
  createKey(i, l, obj, j);
end;

procedure LongHashMap.resizeTable(i:integer);
var j:integer;
alonghashmapentry1:ar_LongHashMapEntry;
begin
  j:=length(hashArray);
  if (j = $40000000)then
    capacity:=$7fffffff
  else
  begin
    //LongHashMapEntry alonghashmapentry1[] = new LongHashMapEntry[i];
    setlength(alonghashmapentry1,i);
    copyHashTableTo(alonghashmapentry1);
    hashArray:=alonghashmapentry1;
    capacity:=trunc(i * percent); 
  end;
end;

procedure LongHashMap.copyHashTableTo(alonghashmapentry:ar_LongHashMapEntry);
var alonghashmapentry1:ar_LongHashMapEntry;
hashmapentry,hashmapentry1:LongHashMapEntry;
i,j,k:integer;
begin
  alonghashmapentry1:=hashArray;
  i:=length(alonghashmapentry);
  for j:=0 to length(alonghashmapentry1)-1 do
  begin
    hashmapentry:=alonghashmapentry1[j];
    if hashmapentry=nil then continue;
    alonghashmapentry1[j]:=nil;
    repeat
      hashmapentry1:=hashmapentry.nextEntry;
      k:=getHashIndex(hashmapentry.field_35831_d, i);
      hashmapentry.nextEntry:=alonghashmapentry[k];
      alonghashmapentry[k]:=hashmapentry;
      hashmapentry:=hashmapentry1;
    until hashmapentry=nil;
  end;
end;

function LongHashMap.remove(l:int64):TObject;
var entry:LongHashMapEntry;
begin
  entry:=removeKey(l);
  if entry<>nil then result:=entry.value
  else result:=nil;
end;

function LongHashMap.removeKey(l:int64):LongHashMapEntry;
var i,j:integer;
entry,entry1,entry2:LongHashMapEntry;
begin
  i:=getHashedKey(l);
  j:=getHashIndex(i, length(hashArray));
  entry:=hashArray[j];
  //for (longhashmapentry1 = longhashmapentry; longhashmapentry1 != null; longhashmapentry1 = longhashmapentry2)
  entry1:=entry;
  while entry1<>nil do
  begin
    entry2:=entry1.nextEntry;
    if (entry1.key = l) then
    begin
      inc(modCount);
      dec(numHashElements);
      if (entry = entry1)then
        hashArray[j]:=entry2
      else
        entry.nextEntry:=entry2;
      result:=entry1;
      exit;
    end;
    entry:=entry1;

    entry1:=entry2;
  end;

  result:=entry1;
end;

procedure LongHashMap.createKey(i:integer; l:int64; obj:TObject; j:integer);
var entry:LongHashMapEntry;
begin
  entry:=hashArray[j];
  hashArray[j]:=LongHashMapEntry.Create(i, l, obj, entry);
  if (numHashElements >= capacity)then
  begin
    inc(numHashElements);
    resizeTable(2 * length(hashArray));
  end
  else
    inc(numHashElements);
end;

function LongHashMap.getHashCode(l:int64):integer;
begin
  result:=getHashedKey(l);
end;

end.

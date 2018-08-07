unit RandomMCT;

interface

type rand=class(TObject)
     private
       seed:int64;
       seed_orig:int64;
       function next(bits:integer):integer; virtual; abstract;
     public
       constructor Create; overload;virtual; abstract;
       constructor Create(SID:int64); overload;virtual; abstract;
       procedure SetSeed(SID:int64);
       function GetSeed:int64;
     end;

     Rnd=class(rand)
     private
       function next(bits:integer):integer; override;
     public
       constructor Create; overload; override;
       constructor Create(SID:int64); overload; override;
       function nextInt:integer; overload;
       function nextInt(n:integer):integer; overload;
       function nextLong:int64;
       function nextFloat:single;
       function nextDouble:double;
     end;


implementation

uses Windows;

procedure Rand.SetSeed(SID:int64);
begin
  seed:=(SID xor $5DEECE66D) and $FFFFFFFFFFFF;
  seed_orig:=SID;
end;

function Rand.GetSeed:int64;
begin
  result:=seed_orig;
end;

function Rnd.next(bits:integer):integer;
begin
  seed:=(seed * $5DEECE66D + $B)and $FFFFFFFFFFFF;
  result:=seed shr (48-bits);
end;

constructor Rnd.Create;
begin
  SetSeed(getcurrenttime);
end;

constructor Rnd.Create(SID:int64);
begin
  seed:=(SID xor $5DEECE66D) and $FFFFFFFFFFFF;
  seed_orig:=SID;
end;

function Rnd.nextInt:integer;
begin
  result:=next(32);
end;

function Rnd.nextInt(n:integer):integer;
var bits,val:integer;
begin
  if n<=0 then
  begin
    result:=0;
  end
  else
    if (n and -n)= n then result:=integer( (n * int64(next(31)) shr 31 ))
    else
    begin
    //val:=0;
      repeat
        bits:=next(31);
        val:=bits mod n;
      until (bits - val + (n-1) >= 0);
    result:=val;
    end;

end;

function Rnd.nextLong:int64;
begin
  result:=(int64(next(32)) shl 32) + next(32);
end;

function Rnd.nextFloat:single;
begin
  result:=next(24)/$1000000;
end;

function Rnd.nextDouble:double;
begin
  result:=((int64(next(26)) shl 27) + next(27))/$20000000000000;
end;

end.

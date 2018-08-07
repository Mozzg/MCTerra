unit WorldGenMinable_u;


interface

uses WorldGenerator_u, generation_obsh, RandomMCT;

type  WorldGenMinable=class(WorldGenerator)
      private
        minableBlockId,numberOfBlocks:integer;
      public
        constructor Create(i,j:integer); reintroduce;
        function generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean; override;
      end;
                               
implementation

uses generation_spec, MathHelper_u;

constructor WorldGenMinable.Create(i,j:integer);
begin
  minableBlockId:=i;
  numberOfBlocks:=j;
end;

function WorldGenMinable.generate(map:region; xreg,yreg:integer; r:rnd; x,y,z:integer):boolean;
var f:double;
d,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14:extended;
l,i1,j1,k1,l1,i2,j2,k2,l2,i3:integer;
begin
  {if minableBlockId=16 then
  begin
    main.Memo1.Lines.Add('Coal coordinates:'+inttostr(x)+','+inttostr(y)+','+inttostr(z));
  end;   }
  f:=r.nextFloat*3.141593;
  d:=(x+8)+(MathHelper_u.math_sin(f)*numberOfBlocks)/8;
  d1:=(x+8)-(MathHelper_u.math_sin(f)*numberOfBlocks)/8;
  d2:=(z+8)+(MathHelper_u.math_cos(f)*numberOfBlocks)/8;
  d3:=(z+8)-(MathHelper_u.math_cos(f)*numberOfBlocks)/8;
  d4:=(y+r.nextInt(3))-2;
  d5:=(y+r.nextInt(3))-2;

  for l:=0 to numberOfBlocks do
  begin
    d6:=d+((d1-d)*l)/numberOfBlocks;
    d7:=d4+((d5-d4)*l)/numberOfBlocks;
    d8:=d2+((d3-d2)*l)/numberOfBlocks;
    d9:=(r.nextDouble*numberOfBlocks)/16;
    d10:=(MathHelper_u.math_sin((l * 3.141593) / numberOfBlocks) + 1) * d9 + 1;
    d11:=(MathHelper_u.math_sin((l * 3.141593) / numberOfBlocks) + 1) * d9 + 1;
    i1:=trunc(d6-d10/2);
    j1:=trunc(d7-d11/2);
    k1:=trunc(d8-d10/2);
    l1:=trunc(d6+d10/2);
    i2:=trunc(d7+d11/2);
    j2:=trunc(d8+d10/2);

    for k2:=i1 to l1 do
    begin
      d12:=((k2 + 0.5) - d6) / (d10 / 2);
      if (d12*d12)>=1 then continue;

      for l2:=j1 to i2 do
      begin
        d13:=((l2 + 0.5) - d7) / (d11 / 2);
        if (d12*d12+d13*d13)>=1 then continue;

        for i3:=k1 to j2 do
        begin
          d14:=((i3 + 0.5) - d8) / (d10 / 2);
          if ((d12*d12+d13*d13+d14*d14)<1)and(get_block_id(map,xreg,yreg,k2,l2,i3)=1) then
            set_block_id(map,xreg,yreg,k2,l2,i3,minableBlockId);
        end;
      end;
    end;
  end;

  result:=true;
end;

end.

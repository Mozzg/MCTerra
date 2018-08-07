unit GenLayerDownfall_u;

interface

uses GenLayer_u, generation_obsh;

type  GenLayerDownfall=class(GenLayer)
      public
        constructor Create(gen:GenLayer);
        function func_35500_a(i,j,k,l:integer):ar_int; override;
      end;

implementation

uses BiomeGenBase_u, IntCache_u;

constructor GenLayerDownfall.Create(gen:GenLayer);
begin
  inherited Create(0);
  parent:=gen;
end;

function GenLayerDownfall.func_35500_a(i,j,k,l:integer):ar_int;
var ai:ar_int;
ai1:par_int;
i1:integer;
begin
  ai:=parent.func_35500_a(i,j,k,l);
  ai1:=IntCache_u.getIntCache(k * l);

  for i1:=0 to k*l-1 do
    ai1^[i1]:=BiomeGenBase_u.biomeList[ai[i1]].func_35476_e;

  //setlength(ai,0);
  result:=ai1^;
end;

end.

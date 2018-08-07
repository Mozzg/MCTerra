unit GenLayerVillageLandscape_u;

interface

uses GenLayer_u, generation_obsh, BiomeGenBase_u;

type  GenLayerVillageLandscape=class(GenLayer)
      private
        allowedBiomes:ar_BiomeGenBase;
      public
        constructor Create(l:int64; gen:GenLayer);
        destructor Destroy; override;
        function func_35500_a(i,j,k,l:integer):ar_int; override;
      end;

implementation

uses IntCache_u;

constructor GenLayerVillageLandscape.Create(l:int64; gen:GenLayer);
begin
  inherited Create(l);
  setlength(allowedBiomes,6);
  allowedBiomes[0]:=BiomeGenBase_u.desert_b;
  allowedBiomes[1]:=BiomeGenBase_u.forest_b;
  allowedBiomes[2]:=BiomeGenBase_u.hills_b;
  allowedBiomes[3]:=BiomeGenBase_u.swampland_b;
  allowedBiomes[4]:=BiomeGenBase_u.plains_b;
  allowedBiomes[5]:=BiomeGenBase_u.taiga_b;
  parent:=gen;
end;

destructor GenLayerVillageLandscape.Destroy;
begin
  inherited;
  setlength(allowedBiomes,0);
end;

function GenLayerVillageLandscape.func_35500_a(i,j,k,l:integer):ar_int;
var ai:ar_int;
ai1:par_int;
i1,j1,k1:integer;
begin
  ai:=parent.func_35500_a(i, j, k, l);
  ai1:=IntCache_u.getIntCache(k * l);
  for i1:=0 to l-1 do
    for j1:=0 to k-1 do
    begin
      func_35499_a(j1 + i, i1 + j);

      k1:= ai[j1 + i1 * k];
      if(k1 = 0) then
      begin
        ai1^[j1 + i1 * k]:= 0;
        continue;
      end;
      if(k1 = BiomeGenBase_u.mushroomIsland_b.biomeID) then
      begin
        ai1^[j1 + i1 * k]:= k1;
        continue;
      end;
      if(k1 = 1) then
        ai1^[j1 + i1 * k]:= allowedBiomes[nextInt(length(allowedBiomes))].biomeID
      else
        ai1^[j1 + i1 * k]:= BiomeGenBase_u.icePlains_b.biomeID;

      (*if (ai[j1 + i1 * k] <= 0) then ai1^[j1 + i1 * k]:=0
      else ai1^[j1 + i1 * k]:=field_35509_b[nextInt(length(field_35509_b))].biomeID;*)
    end;

  //setlength(ai,0);
  result:=ai1^;
end;

end.

unit GenLayer_u;

interface

uses generation_obsh;

type  GenLayer=class;

      ar_GenLayer=array of GenLayer;

      GenLayer=class(TObject)
      private
        worldGendSeed,chunkSeed,baseSeed:int64;
      protected
        parent:GenLayer;
      public
        constructor Create(l:int64);
        destructor Destroy; override;
        procedure func_35496_b(l:int64); virtual;
        procedure func_35499_a(l,l1:int64);
        function nextInt(i:integer):integer;
        function func_35500_a(i,j,k,l:integer):ar_int; virtual; abstract;
        function func_35497_a(l:int64):ar_GenLayer;
      end;
      

implementation

uses LayerIsland_u, GenLayerZoomFuzzy_u, GenLayerIsland_u, GenLayerZoom_u,
GenLayerRiverInit_u, GenLayerRiver_u, GenLayerSmooth_u,
GenLayerVillageLandscape_u, GenLayerTemperature_u, GenLayerDownfall_u,
GenLayerSmoothZoom_u, GenLayerTemperatureMix_u, GenLayerDownfallMix_u,
GenLayerRiverMix_u, GenLayerZoomVoronoi_u, GenLayerSnow_u,
GenLayerMushroomIsland_u, GenLayerShore_u;

constructor GenLayer.Create(l:int64);
begin
  baseSeed:= l;
  baseSeed:=baseSeed*(baseSeed*$5851f42d4c957f2d+$14057b7ef767814f);
  baseSeed:=baseSeed+l;
  baseSeed:=baseSeed*(baseSeed*$5851f42d4c957f2d+$14057b7ef767814f);
  baseSeed:=baseSeed+l;
  baseSeed:=baseSeed*(baseSeed*$5851f42d4c957f2d+$14057b7ef767814f);
  baseSeed:=baseSeed+l;
  chunkSeed:=0;
end;

destructor GenLayer.Destroy;
begin
  parent.Free;
end;

procedure GenLayer.func_35496_b(l:int64);
begin
  worldGendSeed:=l;
  if parent<>nil then parent.func_35496_b(l);
  worldGendSeed:=worldGendSeed*(worldGendSeed*$5851f42d4c957f2d+$14057b7ef767814f);
  worldGendSeed:=worldGendSeed+baseSeed;
  worldGendSeed:=worldGendSeed*(worldGendSeed*$5851f42d4c957f2d+$14057b7ef767814f);
  worldGendSeed:=worldGendSeed+baseSeed;
  worldGendSeed:=worldGendSeed*(worldGendSeed*$5851f42d4c957f2d+$14057b7ef767814f);
  worldGendSeed:=worldGendSeed+baseSeed;
end;

procedure GenLayer.func_35499_a(l,l1:int64);
begin
  chunkSeed:= worldGendSeed;
  chunkSeed:=chunkSeed*(chunkSeed*$5851f42d4c957f2d+$14057b7ef767814f);
  chunkSeed:=chunkSeed+l;
  chunkSeed:=chunkSeed*(chunkSeed*$5851f42d4c957f2d+$14057b7ef767814f);
  chunkSeed:=chunkSeed+l1;
  chunkSeed:=chunkSeed*(chunkSeed*$5851f42d4c957f2d+$14057b7ef767814f);
  chunkSeed:=chunkSeed+l;
  chunkSeed:=chunkSeed*(chunkSeed*$5851f42d4c957f2d+$14057b7ef767814f);
  chunkSeed:=chunkSeed+l1;
end;

function GenLayer.nextInt(i:integer):integer;
var j:integer;
l:int64;
begin
  l:=shrr_l(chunkSeed,24);
  l:=l mod i;
  //j:=integer((shrr(field_35503_c,24) mod int64(i)));
  j:=l;
  if j<0 then j:=j+i;
  chunkSeed:=chunkSeed*(chunkSeed*$5851f42d4c957f2d+$14057b7ef767814f);
  chunkSeed:=chunkSeed+worldGendSeed;
  result:=j;
end;

(*function GenLayer.func_35497_a(l:int64):ar_GenLayer;
var ret_ar:ar_GenLayer;
obj,obj1,obj2,obj3,obj4:GenLayer;
genlayerzoomvoronoi_var:genlayerzoomvoronoi;
byte0:byte;
layerzoom:GenLayerZoom;
LayerSmoothZoom:GenLayerSmoothZoom;
i:integer;
begin
  obj:= LayerIsland.Create(1);
  obj:= GenLayerZoomFuzzy.Create(2000, obj);
  obj:= GenLayerIsland.Create(1, obj);
  obj:= GenLayerZoom.Create(2001, obj);
  obj:= GenLayerIsland.Create(2, obj);
  obj:= GenLayerZoom.Create(2002, obj);
  obj:= GenLayerIsland.Create(3, obj);
  obj:= GenLayerZoom.Create(2003, obj);
  obj:= GenLayerIsland.Create(3, obj);
  obj:= GenLayerZoom.Create(2004, obj);
  obj:= GenLayerIsland.Create(3, obj);
  byte0:= 4;
  obj1:= obj;
  obj1:= LayerZoom.func_35515_a(1000, obj1, 0);
  obj1:= GenLayerRiverInit.Create(100, obj1);
  obj1:= LayerZoom.func_35515_a(1000, obj1, byte0 + 2);
  obj1:= GenLayerRiver.Create(1, obj1);
  obj1:= GenLayerSmooth.Create(1000, obj1);
  obj2:= obj;
  obj2:= LayerZoom.func_35515_a(1000, obj2, 0);
  obj2:= GenLayerVillageLandscape.Create(200, obj2);
  obj2:= LayerZoom.func_35515_a(1000, obj2, 2);
  obj3:= GenLayerTemperature.Create(obj2);
  obj4:= GenLayerDownfall.Create(obj2);
  for i:=0 to byte0-1 do
  begin
    obj2:= GenLayerZoom.Create(1000 + i, obj2);
    if(i = 0) then obj2:= GenLayerIsland.Create(3, obj2);
    obj3:= GenLayerSmoothZoom.Create(1000 + i, obj3);
    obj3:= GenLayerTemperatureMix.Create(obj3, obj2, i);
    obj4:= GenLayerSmoothZoom.Create(1000 + i, obj4);
    obj4:= GenLayerDownfallMix.Create(obj4, obj2, i);
  end;
  obj2:= GenLayerSmooth.Create(1000, obj2);
  obj2:= GenLayerRiverMix.Create(100, obj2, obj1);
  obj3:= LayerSmoothZoom.func_35517_a(1000, obj3, 2);
  obj4:= LayerSmoothZoom.func_35517_a(1000, obj4, 2);
  genlayerzoomvoronoi_var:= GenLayerZoomVoronoi.Create(10, obj2);
  obj2.func_35496_b(l);
  obj3.func_35496_b(l);
  obj4.func_35496_b(l);
  genlayerzoomvoronoi_var.func_35496_b(l);
  setlength(ret_ar,4);
  ret_ar[0]:=obj2;
  ret_ar[1]:=genlayerzoomvoronoi_var;
  ret_ar[2]:=obj3;
  ret_ar[3]:=obj4;

  result:=ret_ar;
end; *)

function GenLayer.func_35497_a(l:int64):ar_GenLayer;
var ret_ar:ar_GenLayer;
obj,obj1,obj2,obj3,obj4:GenLayer;
byte0:byte;
LayerZoom:GenLayerZoom;
LayerRiverMix:GenLayerRiverMix;
LayerSmoothZoom:GenLayerSmoothZoom;
LayerZoomVoronoi:GenLayerZoomVoronoi;
i:integer;
begin
  obj:=LayerIsland.Create(1);
  obj:=GenLayerZoomFuzzy.Create(2000,obj);
  obj:=GenLayerIsland.Create(1,obj);
  obj:=GenLayerZoom.Create(2001,obj);
  obj:=GenLayerIsland.Create(2,obj);
  obj:=GenLayerSnow.Create(2,obj);
  obj:=GenLayerZoom.Create(2002,obj);
  obj:=GenLayerIsland.Create(3,obj);
  obj:=GenLayerZoom.Create(2003,obj);
  obj:=GenLayerIsland.Create(4,obj);
  obj:=GenLayerMushroomIsland.Create(5,obj);
  byte0:=4;
  obj1:=obj;
  obj1:=LayerZoom.func_35515_a(1000,obj1,0);
  obj1:=GenLayerRiverInit.Create(100,obj1);
  obj1:=LayerZoom.func_35515_a(1000,obj1,byte0 + 2);
  obj1:=GenLayerRiver.Create(1,obj1);
  obj1:=GenLayerSmooth.Create(1000,obj1);
  obj2:=obj;
  obj2:=LayerZoom.func_35515_a(1000,obj2,0);
  obj2:=GenLayerVillageLandscape.Create(200,obj2);
  obj2:=LayerZoom.func_35515_a(1000,obj2,2);
  obj3:=GenLayerTemperature.Create(obj2);
  obj4:=GenLayerDownfall.Create(obj2);
  for i:=0 to byte0-1 do
  begin
    obj2:=GenLayerZoom.Create(1000 + i,obj2);
    if(i=0) then
      obj2:=GenLayerIsland.Create(3,obj2);
    if(i=0) then
      obj2:=GenLayerShore.Create(1000,obj2);
    obj3:=GenLayerSmoothZoom.Create(1000 + i,obj3);
    obj3:=GenLayerTemperatureMix.Create(obj3,obj2,i);
    obj4:=GenLayerSmoothZoom.Create(1000 + i,obj4);
    obj4:=GenLayerDownfallMix.Create(obj4,obj2,i);
  end;
  obj2:=GenLayerSmooth.Create(1000,obj2);
  LayerRiverMix:=GenLayerRiverMix.Create(100,obj2,obj1);
  obj2:=LayerRiverMix;
  obj3:=LayerSmoothZoom.func_35517_a(1000,obj3,2);
  obj4:=LayerSmoothZoom.func_35517_a(1000,obj4,2);
  LayerZoomVoronoi:=GenLayerZoomVoronoi.Create(10,obj2);
  obj2.func_35496_b(l);
  obj3.func_35496_b(l);
  obj4.func_35496_b(l);
  LayerZoomVoronoi.func_35496_b(l);
  setlength(ret_ar,5);
  ret_ar[0]:=obj2;
  ret_ar[1]:=LayerZoomVoronoi;
  ret_ar[2]:=obj3;
  ret_ar[3]:=obj4;
  ret_ar[4]:=LayerRiverMix;

  result:=ret_ar;
end;

end.

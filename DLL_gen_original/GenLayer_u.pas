unit GenLayer_u;

interface

uses generation;

type GenLayer=class;

     ar_GenLayer=array of GenLayer;
     par_GenLayer=^ar_GenLayer;

     GenLayer=class(TObject)
     private
       worldGenSeed,chunkSeed,baseSeed:int64;
     protected
       parent:GenLayer;
       function nextInt(i:integer):integer;
     public
       constructor Create(l:int64);
       destructor Destroy; override;
       procedure initWorldGenSeed(l:int64); virtual;
       procedure initChunkSeed(l,l1:int64);
       function getInts(i,j,k,l:integer):ar_int; virtual; abstract;
     end;

function func_35497_a(l:int64):ar_GenLayer;
procedure Free_layers;

implementation

uses LayerIsland_u, GenLayerZoomFuzzy_u, GenLayerIsland_u,
GenLayerZoom_u, GenLayerSnow_u, GenLayerMushroomIsland_u,
GenLayerRiverInit_u, GenLayerRiver_u, GenLayerSmooth_u,
GenLayerVillageLandscape_u, GenLayerHills_u, GenLayerTemperature_u,
GenLayerDownfall_u, GenLayerShore_u, GenLayerSwampRivers_u,
GenLayerSmoothZoom_u, GenLayerTemperatureMix_u, GenLayerDownfallMix_u,
GenLayerRiverMix_u, GenLayerZoomVoronoi_u;

var layers_arr:array of GenLayer;

constructor GenLayer.Create(l:int64);
begin
  baseSeed:=l;
  baseSeed:=baseSeed*(baseSeed * $5851f42d4c957f2d + $14057b7ef767814f);
  baseSeed:=baseSeed+l;
  baseSeed:=baseSeed*(baseSeed * $5851f42d4c957f2d + $14057b7ef767814f);
  baseSeed:=baseSeed+l;
  baseSeed:=baseSeed*(baseSeed * $5851f42d4c957f2d + $14057b7ef767814f);
  baseSeed:=baseSeed+l;
  worldGenSeed:=0;
  chunkSeed:=0;

  parent:=nil;
end;

destructor GenLayer.Destroy;
begin
  //if parent<>nil then parent.Free;
  //parent:=nil;
  inherited;
end;

procedure GenLayer.initWorldGenSeed(l:int64);
begin
  worldGenSeed:=l;
  if (parent <> nil)then parent.initWorldGenSeed(l);
  worldGenSeed:=worldGenSeed*(worldGenSeed * $5851f42d4c957f2d + $14057b7ef767814f);
  worldGenSeed:=worldGenSeed+baseSeed;
  worldGenSeed:=worldGenSeed*(worldGenSeed * $5851f42d4c957f2d + $14057b7ef767814f);
  worldGenSeed:=worldGenSeed+baseSeed;
  worldGenSeed:=worldGenSeed*(worldGenSeed * $5851f42d4c957f2d + $14057b7ef767814f);
  worldGenSeed:=worldGenSeed+baseSeed;
end;

procedure GenLayer.initChunkSeed(l,l1:int64);
begin
  chunkSeed:=worldGenSeed;
  chunkSeed:=chunkSeed*(chunkSeed * $5851f42d4c957f2d + $14057b7ef767814f);
  chunkSeed:=chunkSeed+l;
  chunkSeed:=chunkSeed*(chunkSeed * $5851f42d4c957f2d + $14057b7ef767814f);
  chunkSeed:=chunkSeed+l1;
  chunkSeed:=chunkSeed*(chunkSeed * $5851f42d4c957f2d + $14057b7ef767814f);
  chunkSeed:=chunkSeed+l;
  chunkSeed:=chunkSeed*(chunkSeed * $5851f42d4c957f2d + $14057b7ef767814f);
  chunkSeed:=chunkSeed+l1;
end;

function GenLayer.nextInt(i:integer):integer;
var j:integer;
begin
  //int j = (int)((chunkSeed >> 24) % (long)i);
  j:=shrr(chunkSeed,24) mod i;
  if (j < 0) then inc(j,i);
  chunkSeed:=chunkSeed*(chunkSeed * $5851f42d4c957f2d + $14057b7ef767814f);
  chunkSeed:=chunkSeed+worldGenSeed;
  result:=j;
end;

function func_35497_a(l:int64):ar_GenLayer;
var obj,obj1,obj2,obj3,obj4:GenLayer;
byte0,i,t:integer;
LayerZoom:GenLayerZoom;
LayerSmoothZoom:GenLayerSmoothZoom;
genrivermix:GenLayerRiverMix;
genzoomvoronoi:GenLayerZoomVoronoi;
ret_ar:ar_GenLayer;
begin
  obj:=LayerIsland.Create(1);
  t:=length(layers_arr);
  setlength(layers_arr,t+1);
  layers_arr[t]:=obj;
  obj:=GenLayerZoomFuzzy.Create(2000, obj);
  t:=length(layers_arr);
  setlength(layers_arr,t+1);
  layers_arr[t]:=obj;
  obj:=GenLayerIsland.Create(1, obj);
  t:=length(layers_arr);
  setlength(layers_arr,t+1);
  layers_arr[t]:=obj;
  obj:=GenLayerZoom.Create(2001, obj);
  t:=length(layers_arr);
  setlength(layers_arr,t+1);
  layers_arr[t]:=obj;
  obj:=GenLayerIsland.Create(2, obj);
  t:=length(layers_arr);
  setlength(layers_arr,t+1);
  layers_arr[t]:=obj;
  obj:=GenLayerSnow.Create(2, obj);
  t:=length(layers_arr);
  setlength(layers_arr,t+1);
  layers_arr[t]:=obj;
  obj:=GenLayerZoom.Create(2002, obj);
  t:=length(layers_arr);
  setlength(layers_arr,t+1);
  layers_arr[t]:=obj;
  obj:=GenLayerIsland.Create(3, obj);
  t:=length(layers_arr);
  setlength(layers_arr,t+1);
  layers_arr[t]:=obj;
  obj:=GenLayerZoom.Create(2003, obj);
  t:=length(layers_arr);
  setlength(layers_arr,t+1);
  layers_arr[t]:=obj;
  obj:=GenLayerIsland.Create(4, obj);
  t:=length(layers_arr);
  setlength(layers_arr,t+1);
  layers_arr[t]:=obj;
  obj:=GenLayerMushroomIsland.Create(5, obj);
  t:=length(layers_arr);
  setlength(layers_arr,t+1);
  layers_arr[t]:=obj;
  byte0:=4;
  obj1:=obj;
/////////////////////////////////
  obj1:=LayerZoom.func_35515_a(1000, obj1, 0, @layers_arr);
  obj1:=GenLayerRiverInit.Create(100, obj1);
  t:=length(layers_arr);
  setlength(layers_arr,t+1);
  layers_arr[t]:=obj1;
///////////////////////////////////
  obj1:=LayerZoom.func_35515_a(1000, obj1, byte0 + 2, @layers_arr);
  obj1:=GenLayerRiver.Create(1, obj1);
  t:=length(layers_arr);
  setlength(layers_arr,t+1);
  layers_arr[t]:=obj1;
  obj1:=GenLayerSmooth.Create(1000, obj1);
  t:=length(layers_arr);
  setlength(layers_arr,t+1);
  layers_arr[t]:=obj1;
  obj2:=obj;
////////////////////////////////////
  obj2:=LayerZoom.func_35515_a(1000, obj2, 0, @layers_arr);
  obj2:=GenLayerVillageLandscape.Create(200, obj2);
  t:=length(layers_arr);
  setlength(layers_arr,t+1);
  layers_arr[t]:=obj2;
/////////////////////////////////////
  obj2:=LayerZoom.func_35515_a(1000, obj2, 2, @layers_arr);
  obj2:=GenLayerHills.Create(1000, obj2);
  t:=length(layers_arr);
  setlength(layers_arr,t+1);
  layers_arr[t]:=obj2;
  obj3:=GenLayerTemperature.Create(obj2);
  t:=length(layers_arr);
  setlength(layers_arr,t+1);
  layers_arr[t]:=obj3;
  obj4:=GenLayerDownfall.Create(obj2);
  t:=length(layers_arr);
  setlength(layers_arr,t+1);
  layers_arr[t]:=obj4;
  for i:=0 to byte0-1 do
  begin
    obj2:=GenLayerZoom.Create(1000 + i, obj2);
    t:=length(layers_arr);
    setlength(layers_arr,t+1);
    layers_arr[t]:=obj2;
    if (i = 0)then
    begin
      obj2:=GenLayerIsland.Create(3, obj2);
      t:=length(layers_arr);
      setlength(layers_arr,t+1);
      layers_arr[t]:=obj2;
    end;
    if (i = 1)then
    begin
      obj2:=GenLayerShore.Create(1000, obj2);
      t:=length(layers_arr);
      setlength(layers_arr,t+1);
      layers_arr[t]:=obj2;
    end;
    if (i = 1)then
    begin
      obj:=GenLayerSwampRivers.Create(1000, obj2);
      t:=length(layers_arr);
      setlength(layers_arr,t+1);
      layers_arr[t]:=obj;
    end;
    obj3:=GenLayerSmoothZoom.Create(1000 + i, obj3);
    t:=length(layers_arr);
    setlength(layers_arr,t+1);
    layers_arr[t]:=obj3;
    obj3:=GenLayerTemperatureMix.Create(obj3, obj2, i);
    t:=length(layers_arr);
    setlength(layers_arr,t+1);
    layers_arr[t]:=obj3;
    obj4:=GenLayerSmoothZoom.Create(1000 + i, obj4);
    t:=length(layers_arr);
    setlength(layers_arr,t+1);
    layers_arr[t]:=obj4;
    obj4:=GenLayerDownfallMix.Create(obj4, obj2, i);
    t:=length(layers_arr);
    setlength(layers_arr,t+1);
    layers_arr[t]:=obj4;
  end;

  obj2:=GenLayerSmooth.Create(1000, obj2);
  t:=length(layers_arr);
  setlength(layers_arr,t+1);
  layers_arr[t]:=obj2;
  obj2:=GenLayerRiverMix.Create(100, obj2, obj1);
  t:=length(layers_arr);
  setlength(layers_arr,t+1);
  layers_arr[t]:=obj2;
  genrivermix:=GenLayerRiverMix(obj2);
/////////////////////////////
  obj3:=LayerSmoothZoom.func_35517_a(1000, obj3, 2, @layers_arr);
////////////////////////////////
  obj4:=LayerSmoothZoom.func_35517_a(1000, obj4, 2, @layers_arr);
  genzoomvoronoi:=GenLayerZoomVoronoi.Create(10, obj2);
  t:=length(layers_arr);
  setlength(layers_arr,t+1);
  layers_arr[t]:=genzoomvoronoi;
  obj2.initWorldGenSeed(l);
  obj3.initWorldGenSeed(l);
  obj4.initWorldGenSeed(l);
  genzoomvoronoi.initWorldGenSeed(l);
  setlength(ret_ar,5);
  ret_ar[0]:=obj2;
  ret_ar[1]:=genzoomvoronoi;
  ret_ar[2]:=obj3;
  ret_ar[3]:=obj4;
  ret_ar[4]:=genrivermix;
  result:=ret_ar;
end;

procedure Free_layers;
var i:integer;
begin
  for i:=0 to length(layers_arr)-1 do
    layers_arr[i].Free;
  setlength(layers_arr,0);
end;

end.

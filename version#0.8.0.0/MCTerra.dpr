program MCTerra;

uses
  Forms,
  mainf in 'mainf.pas' {main},
  logoform in 'logoform.pas' {logof},
  aboutf in 'aboutf.pas' {about},
  flatmap_propf in 'flatmap_propf.pas' {flatmap},
  generation in 'generation.pas',
  border_propf in 'border_propf.pas' {Border},
  planetoids_propf in 'planetoids_propf.pas' {planet},
  tunnels_propf in 'tunnels_propf.pas' {tunnels},
  NBT in 'NBT.pas',
  F_Version in 'F_Version.pas',
  load_sidf in 'load_sidf.pas' {load},
  RandomMCT in 'RandomMCT.pas',
  NoiseGenerator_u in 'NoiseGenerator_u.pas',
  NoiseGeneratorOctaves_u in 'NoiseGeneratorOctaves_u.pas',
  NoiseGeneratorPerlin_u in 'NoiseGeneratorPerlin_u.pas',
  biosphere_propf in 'biosphere_propf.pas' {biosf},
  playerf in 'playerf.pas' {player},
  generation_obsh in 'generation_obsh.pas',
  generation_spec in 'generation_spec.pas',
  generation_flat in 'generation_flat.pas',
  generation_planet in 'generation_planet.pas',
  generation_biosf in 'generation_biosf.pas',
  generation_tunnel in 'generation_tunnel.pas',
  generation_cwall in 'generation_cwall.pas',
  generation_biome_desert in 'generation_biome_desert.pas',
  desert_propf in 'desert_propf.pas' {desert},
  previewf in 'previewf.pas' {preview},
  original_propf in 'original_propf.pas' {original},
  generation_original in 'generation_original.pas',
  WorldGenTrees_u in 'WorldGenTrees_u.pas',
  BiomeCacheBlock_u in 'BiomeCacheBlock_u.pas',
  BiomeDecorator_u in 'BiomeDecorator_u.pas',
  BiomeEndDecorator_u in 'BiomeEndDecorator_u.pas',
  BiomeGenBase_u in 'BiomeGenBase_u.pas',
  BiomeGenDesert_u in 'BiomeGenDesert_u.pas',
  BiomeGenEnd_u in 'BiomeGenEnd_u.pas',
  BiomeGenForest_u in 'BiomeGenForest_u.pas',
  BiomeGenHell_u in 'BiomeGenHell_u.pas',
  BiomeGenHills_u in 'BiomeGenHills_u.pas',
  BiomeGenMushroomIsland_u in 'BiomeGenMushroomIsland_u.pas',
  BiomeGenOcean_u in 'BiomeGenOcean_u.pas',
  BiomeGenPlains_u in 'BiomeGenPlains_u.pas',
  BiomeGenRiver_u in 'BiomeGenRiver_u.pas',
  BiomeGenSnow_u in 'BiomeGenSnow_u.pas',
  BiomeGenSwamp_u in 'BiomeGenSwamp_u.pas',
  BiomeGenTaiga_u in 'BiomeGenTaiga_u.pas',
  ChunkProviderGenerate_u in 'ChunkProviderGenerate_u.pas',
  GenLayer_u in 'GenLayer_u.pas',
  GenLayerDownfall_u in 'GenLayerDownfall_u.pas',
  GenLayerDownfallMix_u in 'GenLayerDownfallMix_u.pas',
  GenLayerIsland_u in 'GenLayerIsland_u.pas',
  GenLayerMushroomIsland_u in 'GenLayerMushroomIsland_u.pas',
  GenLayerRiver_u in 'GenLayerRiver_u.pas',
  GenLayerRiverInit_u in 'GenLayerRiverInit_u.pas',
  GenLayerRiverMix_u in 'GenLayerRiverMix_u.pas',
  GenLayerShore_u in 'GenLayerShore_u.pas',
  GenLayerSmooth_u in 'GenLayerSmooth_u.pas',
  GenLayerSmoothZoom_u in 'GenLayerSmoothZoom_u.pas',
  GenLayerSnow_u in 'GenLayerSnow_u.pas',
  GenLayerTemperature_u in 'GenLayerTemperature_u.pas',
  GenLayerTemperatureMix_u in 'GenLayerTemperatureMix_u.pas',
  GenLayerVillageLandscape_u in 'GenLayerVillageLandscape_u.pas',
  GenLayerZoom_u in 'GenLayerZoom_u.pas',
  GenLayerZoomFuzzy_u in 'GenLayerZoomFuzzy_u.pas',
  GenLayerZoomVoronoi_u in 'GenLayerZoomVoronoi_u.pas',
  IChunkProvider_u in 'IChunkProvider_u.pas',
  IntCache_u in 'IntCache_u.pas',
  LayerIsland_u in 'LayerIsland_u.pas',
  LongHashMap_u in 'LongHashMap_u.pas',
  LongHashMapEntry_u in 'LongHashMapEntry_u.pas',
  MapGenBase_u in 'MapGenBase_u.pas',
  MapGenCaves_u in 'MapGenCaves_u.pas',
  MapGenRavine_u in 'MapGenRavine_u.pas',
  MapGenWaterlily_u in 'MapGenWaterlily_u.pas',
  MathHelper_u in 'MathHelper_u.pas',
  WorldChunkManager_u in 'WorldChunkManager_u.pas',
  WorldGenBigMushroom_u in 'WorldGenBigMushroom_u.pas',
  WorldGenBigTree_u in 'WorldGenBigTree_u.pas',
  WorldGenCactus_u in 'WorldGenCactus_u.pas',
  WorldGenClay_u in 'WorldGenClay_u.pas',
  WorldGenDeadBush_u in 'WorldGenDeadBush_u.pas',
  WorldGenDungeons_u in 'WorldGenDungeons_u.pas',
  WorldGenerator_u in 'WorldGenerator_u.pas',
  WorldGenFlowers_u in 'WorldGenFlowers_u.pas',
  WorldGenForest_u in 'WorldGenForest_u.pas',
  WorldGenLakes_u in 'WorldGenLakes_u.pas',
  WorldGenLiquids_u in 'WorldGenLiquids_u.pas',
  WorldGenMinable_u in 'WorldGenMinable_u.pas',
  WorldGenPumpkin_u in 'WorldGenPumpkin_u.pas',
  WorldGenReed_u in 'WorldGenReed_u.pas',
  WorldGenSand_u in 'WorldGenSand_u.pas',
  WorldGenSpikes_u in 'WorldGenSpikes_u.pas',
  WorldGenSwamp_u in 'WorldGenSwamp_u.pas',
  WorldGenTaiga1_u in 'WorldGenTaiga1_u.pas',
  WorldGenTaiga2_u in 'WorldGenTaiga2_u.pas',
  WorldGenTallGrass_u in 'WorldGenTallGrass_u.pas',
  BiomeCache_u in 'BiomeCache_u.pas';

{$R *.res}
{$R font.res}

begin
  Application.Initialize;
  Application.Title := 'MCTerra';
  Application.CreateForm(Tlogof, logof);
  Application.CreateForm(Tabout, about);
  Application.CreateForm(Tflatmap, flatmap);
  Application.CreateForm(TBorder, Border);
  Application.CreateForm(Tplanet, planet);
  Application.CreateForm(Ttunnels, tunnels);
  Application.CreateForm(Tload, load);
  Application.CreateForm(Tbiosf, biosf);
  Application.CreateForm(Tplayer, player);
  Application.CreateForm(Tdesert, desert);
  Application.CreateForm(Tpreview, preview);
  Application.CreateForm(Toriginal, original);
  logof.Show;   //inicializaciya vsego v procedure formshow
    logof.Update;
    delay(4000);
    //delay(200);
    logof.Free;
  Application.CreateForm(Tmain, main);
  Application.Run;
end.

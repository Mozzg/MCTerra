program MCTerra;

uses
  Sharemem,
  Forms,
  mainf in 'mainf.pas' {main},
  logof in 'logof.pas' {logo},
  aboutf in 'aboutf.pas' {about},
  borderf in 'borderf.pas' {border},
  generation in 'generation.pas',
  NBT in 'NBT.pas',
  types_mct in 'types_mct.pas',
  blocksf in 'blocksf.pas' {blocks},
  blocks_mct in 'blocks_mct.pas',
  RandomMCT in 'RandomMCT.pas',
  crc32_u in 'crc32_u.pas',
  optionsf in 'optionsf.pas' {options};

{$R *.res}
{$R font.res}
{$R flatmap_gen.res}

begin
  Application.Initialize;
  Application.Title := 'MCTerra';
  Application.CreateForm(Tmain, main);
  Application.CreateForm(Tabout, about);
  Application.CreateForm(Tlogo, logo);
  Application.CreateForm(Tborder, border);
  Application.CreateForm(Tblocks, blocks);
  Application.CreateForm(Toptions, options);  
  logo.Show;       //inicializaciya vsego v procedure formshow
    logo.Update;
    logo.Activate_plugins;
    if save_opt.fast_load=true then delay(150)
    else delay(3500);
    //delay(3500);
    //delay(200);
  logo.Free;

  Application.Run;
end.

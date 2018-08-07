unit logof;

interface

uses
  Windows, Forms, Classes, Graphics, ExtCtrls, Controls, JPEG;

type
  Tlogo = class(TForm)
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Activate_plugins;
  end;

var
  logo: Tlogo;

implementation

uses zlibex, registry, sysutils, mainf, RandomMCT, borderf, types_mct,
blocks_mct, crc32_u;

{$R *.dfm}

var temp_plug:TPlugin_type;

function BitmapToRegion(Bitmap: TBitmap; TransColor: TColor): HRGN;
var X, Y: Integer;
    XStart: Integer;
begin
 Result := 0;
 with Bitmap do
 for Y := 0 to Height - 1 do
  begin
   X := 0;
   while X < Width do
    begin
     // Пропускаем прозрачные точки
     while (X < Width) and (Canvas.Pixels[X, Y] = TransColor) do
      Inc(X);
      if X >= Width then
      Break;
      XStart := X;
     // Пропускаем непрозрачные точки
     while (X < Width) and (Canvas.Pixels[X, Y] <> TransColor) do
      Inc(X);
      // Создаём новый прямоугольный регион и добавляем его к
      // региону всей картинки
      if Result = 0 then
       Result := CreateRectRgn(XStart, Y, X, Y + 1)
     else           
       CombineRgn(Result, Result,
       CreateRectRgn(XStart, Y, X, Y + 1), RGN_OR);
     end;
  end;
end;

function check_repeat_plugin(plugin:TPlugin_type):boolean;
//false - plagina net v spiskah
//true - plagin est' v spiskah
var i,k:integer;
str,str1:array[0..2]of string;
begin
  k:=plugin.info.plugin_type and 7;
  case k of
  0:for i:=0 to length(landscape_plugins)-1 do
    begin
      if (plugin.info.plugin_type=landscape_plugins[i].info.plugin_type)and
      (plugin.info.aditional_type=landscape_plugins[i].info.aditional_type)and
      (plugin.info.maj_v=landscape_plugins[i].info.maj_v)and
      (plugin.info.min_v=landscape_plugins[i].info.min_v)and
      (plugin.info.rel_v=landscape_plugins[i].info.rel_v)and
      (plugin.info.has_preview=landscape_plugins[i].info.has_preview)then
      begin
        str[0]:=plugin.info.full_name;
        str1[0]:=landscape_plugins[i].info.full_name;
        str[1]:=plugin.info.name;
        str1[1]:=landscape_plugins[i].info.name;
        str[2]:=plugin.info.author;
        str1[2]:=landscape_plugins[i].info.author;
        if (str[0]=str1[0])and
        (str[1]=str1[1])and
        (str[2]=str1[2]) then
        begin
          result:=true;
          exit;
        end;
      end;
    end;
  1:for i:=0 to length(border_plugins)-1 do
    begin
      if (plugin.info.plugin_type=border_plugins[i].info.plugin_type)and
      (plugin.info.aditional_type=border_plugins[i].info.aditional_type)and
      (plugin.info.maj_v=border_plugins[i].info.maj_v)and
      (plugin.info.min_v=border_plugins[i].info.min_v)and
      (plugin.info.rel_v=border_plugins[i].info.rel_v)and
      (plugin.info.has_preview=border_plugins[i].info.has_preview)then
      begin
        str[0]:=plugin.info.full_name;
        str1[0]:=border_plugins[i].info.full_name;
        str[1]:=plugin.info.name;
        str1[1]:=border_plugins[i].info.name;
        str[2]:=plugin.info.author;
        str1[2]:=border_plugins[i].info.author;
        if (str[0]=str1[0])and
        (str[1]=str1[1])and
        (str[2]=str1[2]) then
        begin
          result:=true;
          exit;
        end;
      end;
    end;
  2:for i:=0 to length(structures_plugins)-1 do
    begin
      if (plugin.info.plugin_type=structures_plugins[i].info.plugin_type)and
      (plugin.info.aditional_type=structures_plugins[i].info.aditional_type)and
      (plugin.info.maj_v=structures_plugins[i].info.maj_v)and
      (plugin.info.min_v=structures_plugins[i].info.min_v)and
      (plugin.info.rel_v=structures_plugins[i].info.rel_v)and
      (plugin.info.has_preview=structures_plugins[i].info.has_preview)then
      begin
        str[0]:=plugin.info.full_name;
        str1[0]:=structures_plugins[i].info.full_name;
        str[1]:=plugin.info.name;
        str1[1]:=structures_plugins[i].info.name;
        str[2]:=plugin.info.author;
        str1[2]:=structures_plugins[i].info.author;
        if (str[0]=str1[0])and
        (str[1]=str1[1])and
        (str[2]=str1[2]) then
        begin
          result:=true;
          exit;
        end;
      end;
    end
  else
    begin
      result:=true;
      exit;
    end;
  end;
  result:=false;
end;

procedure plug_plugins;
var sr:TSearchRec;
str,str1:string;
i,j,k,z:integer;
b:boolean;
sovpad:array of array of integer;

//dla zagruzki preview
reshandle,memhandle:cardinal;
resptr:^byte;
memstream:TMemoryStream;
begin
  //str:=extractfiledir(paramstr(0))+'\*.dll';
  str1:='*.dll';
  if findfirst(str1,faAnyFile,sr)=0 then
  begin
    repeat
      main.Memo1.Lines.Add('########################');
      str:=sr.Name;

      if uppercase(ExtractFileExt(str))<>'.DLL' then continue;

      main.Memo1.Lines.Add('Found library '+ExpandFileName(str));

      //zagruzhaem biblioteku
      temp_plug.handle:=LoadLibrary(pchar(str));
      if temp_plug.handle=0 then
      begin
        main.Memo1.Lines.Add('Failed to load library '+str);
        continue;
      end;
      main.Memo1.Lines.Add('Library '+str+' loaded sucsessfuly');

      //zagruzhaem funkciyu dla protokola
      temp_plug.get_protocol:=nil;
      @temp_plug.get_protocol:=GetProcAddress(temp_plug.handle, 'get_protocol');
      if not(assigned(temp_plug.get_protocol)) then
      begin
        main.Memo1.Lines.Add('Could not find function "get_protocol" in library '+str);
        FreeLibrary(temp_plug.handle);
        continue;
      end;
      main.Memo1.Lines.Add('Loaded function "get_protocol" in library '+str);

      //vizivaem funkcuyu protokola i sravnivaem s nashim
      i:=temp_plug.get_protocol(PROTOCOL);
      if i<>PROTOCOL then
      begin
        main.Memo1.Lines.Add('Protocol mismatch in library '+str);
        FreeLibrary(temp_plug.handle);
        continue;
      end;
      main.Memo1.Lines.Add('Protocol matches in library '+str);

      //zagruzhaem funkcuyu polucheniya informacii o plagine
      temp_plug.get_info:=nil;
      @temp_plug.get_info:=GetProcAddress(temp_plug.handle, 'get_info');
      if not(assigned(temp_plug.get_info)) then
      begin
        main.Memo1.Lines.Add('Could not find function "get_info" in library '+str);
        FreeLibrary(temp_plug.handle);
        continue;
      end;
      main.Memo1.Lines.Add('Loaded function "get_info" in library '+str);

      //vizivaem finkciyu zagruzki informacii i proveraem razmer zapisi
      temp_plug.plugrec:=temp_plug.get_info;
      if temp_plug.plugrec.size_info<>plug_size then
      begin
        main.Memo1.Lines.Add('Size of info mismatch in library '+str);
        FreeLibrary(temp_plug.handle);
        continue;
      end;
      if temp_plug.plugrec.size_flux<>flux_size then
      begin
        main.Memo1.Lines.Add('Size of TFlux mismatch in library '+str);
        FreeLibrary(temp_plug.handle);
        continue;
      end;
      if temp_plug.plugrec.size_gen_settings<>gen_settings_size then
      begin
        main.Memo1.Lines.Add('Size of TGen_Settings mismatch in library '+str);
        FreeLibrary(temp_plug.handle);
        continue;
      end;
      if temp_plug.plugrec.size_chunk<>chunk_size then
      begin
        main.Memo1.Lines.Add('Size of Chunk mismatch in library '+str);
        FreeLibrary(temp_plug.handle);
        continue;
      end;
      if temp_plug.plugrec.size_change_block<>change_block_size then
      begin
        main.Memo1.Lines.Add('Size of TChange_block mismatch in library '+str);
        FreeLibrary(temp_plug.handle);
        continue;
      end;
      main.Memo1.Lines.Add('Size of infoes matches in library '+str);

      //perenosim informaciyu v lokalnuyu peremennuyu
      temp_plug.info.plugin_type:=pTPlugSettings(temp_plug.plugrec.data)^.plugin_type;
      temp_plug.info.aditional_type:=pTPlugSettings(temp_plug.plugrec.data)^.aditional_type;
      temp_plug.info.full_name:=pTPlugSettings(temp_plug.plugrec.data)^.full_name;
      temp_plug.info.name:=pTPlugSettings(temp_plug.plugrec.data)^.name;
      temp_plug.info.author:=pTPlugSettings(temp_plug.plugrec.data)^.author;
      temp_plug.info.dll_path:=pTPlugSettings(temp_plug.plugrec.data)^.dll_path;
      temp_plug.info.maj_v:=pTPlugSettings(temp_plug.plugrec.data)^.maj_v;
      temp_plug.info.min_v:=pTPlugSettings(temp_plug.plugrec.data)^.min_v;
      temp_plug.info.rel_v:=pTPlugSettings(temp_plug.plugrec.data)^.rel_v;
      temp_plug.info.has_preview:=pTPlugSettings(temp_plug.plugrec.data)^.has_preview;
      for i:=1 to 21 do
        temp_plug.info.change_par[i]:=pTPlugSettings(temp_plug.plugrec.data)^.change_par[i];


      //vivodim informacuyu v log
      main.Memo1.Lines.Add('Loaded plugin info from library '+str);
      main.Memo1.Lines.Add('Info from library '+str+':');
      main.Memo1.Lines.Add('Plugin type='+inttostr(temp_plug.info.plugin_type));
      main.Memo1.Lines.Add('Aditional type='+inttostr(temp_plug.info.aditional_type));
      main.Memo1.Lines.Add('Full name='+temp_plug.info.full_name);
      main.Memo1.Lines.Add('Name='+temp_plug.info.name);
      main.Memo1.Lines.Add('Author='+temp_plug.info.author);
      main.Memo1.Lines.Add('Dll path='+temp_plug.info.dll_path);
      main.Memo1.Lines.Add('Major version='+inttostr(temp_plug.info.maj_v));
      main.Memo1.Lines.Add('Minor version='+inttostr(temp_plug.info.min_v));
      main.Memo1.Lines.Add('Release version='+inttostr(temp_plug.info.rel_v));
      main.Memo1.Lines.Add('Has preview='+booltostr(temp_plug.info.has_preview,true));
      main.Memo1.Lines.Add('Parameters:');
      for i:=1 to 21 do
        main.Memo1.Lines.Add('    #'+inttostr(i)+'='+booltostr(temp_plug.info.change_par[i],true));

      //proveraem, est' li povtoreniya v plaginah
      if check_repeat_plugin(temp_plug)=true then
      begin
        main.Memo1.Lines.Add('Plugin in library '+str+' already in a plugin list, ignoring');
        FreeLibrary(temp_plug.handle);
        continue;
      end;

      //delaem priznak avtorizacii
      if ((temp_plug.info.plugin_type and 8)<>0)and
      ((temp_plug.info.plugin_type and 32)<>0)and
      ((temp_plug.info.plugin_type and 128)<>0)then
        temp_plug.auth:=true
      else
        temp_plug.auth:=false;

      //zagruzhaem vse ostalnie funkcii biblioteki
      //i proveraem, est' li oni voobshe
      //snachala obnulaem ukazateli na funkcii
      temp_plug.init:=nil;
      temp_plug.get_different_settings:=nil;
      temp_plug.get_compatible:=nil;
      temp_plug.get_last_error:=nil;
      temp_plug.init_gen:=nil;
      temp_plug.gen_chunk:=nil;
      temp_plug.get_chunk_add:=nil;
      temp_plug.stop_gen:=nil;
      temp_plug.show_settings_wnd:=nil;
      temp_plug.gen_region:=nil;
      //poluchaem adresa funkciy
      temp_plug.init:=GetProcAddress(temp_plug.handle, 'Init');
      temp_plug.get_different_settings:=GetProcAddress(temp_plug.handle, 'get_different_settings');
      temp_plug.get_compatible:=GetProcAddress(temp_plug.handle, 'get_compatible');
      temp_plug.get_last_error:=GetProcAddress(temp_plug.handle, 'get_last_error');
      temp_plug.init_gen:=GetProcAddress(temp_plug.handle, 'Init_gen');
      if temp_plug.auth=true then temp_plug.gen_chunk2:=GetProcAddress(temp_plug.handle, 'gen_chunk')
      else temp_plug.gen_chunk:=GetProcAddress(temp_plug.handle, 'gen_chunk');
      temp_plug.get_chunk_add:=GetProcAddress(temp_plug.handle, 'get_chunk_add');
      temp_plug.stop_gen:=GetProcAddress(temp_plug.handle, 'stop_gen');
      temp_plug.set_block_id:=GetProcAddress(temp_plug.handle, 'set_block_id');
      temp_plug.show_settings_wnd:=GetProcAddress(temp_plug.handle, 'show_settings_wnd');
      temp_plug.gen_region:=GetProcAddress(temp_plug.handle, 'gen_region');
      //proveraem, est' li funkcii
      if not(assigned(temp_plug.init)and
      assigned(temp_plug.get_different_settings)and
      assigned(temp_plug.get_compatible)and
      assigned(temp_plug.get_last_error)and
      assigned(temp_plug.init_gen)and
      (assigned(temp_plug.gen_chunk) or assigned(temp_plug.gen_chunk2))and
      assigned(temp_plug.get_chunk_add)and
      assigned(temp_plug.stop_gen)and
      assigned(temp_plug.set_block_id)and
      assigned(temp_plug.show_settings_wnd)and
      assigned(temp_plug.gen_region)) then
      begin
        main.Memo1.Lines.Add('Failed to load nessesary functions in library '+str);
        FreeLibrary(temp_plug.handle);
        continue;
      end;
      main.Memo1.Lines.Add('Loaded all nessesary functions in library '+str);

      //zagruzka preview esli est'
      main.Memo1.Lines.Add('Starting to load preview for library '+str);
      if temp_plug.info.has_preview=true then
      begin
        ResHandle := FindResource(temp_plug.handle, PChar('PREVIEW'), 'JPEG');
        if ResHandle=0 then
        begin
          main.Memo1.Lines.Add('Library '+str+' doesnt have preview, but it seem so that it does. Unloading library.');
          FreeLibrary(temp_plug.handle);
          continue;
        end
        else
        begin
          main.Memo1.Lines.Add('Library '+str+' does have preview, loading.');
          MemHandle:=LoadResource(temp_plug.handle, ResHandle);
          ResPtr:=LockResource(MemHandle);
          MemStream:=TMemoryStream.Create;
          temp_plug.preview:=TJPEGImage.Create;
          k := SizeOfResource(temp_plug.handle, ResHandle);
          MemStream.SetSize(k);
          MemStream.Write(ResPtr^, k);
          FreeResource(MemHandle);
          MemStream.Seek(0, 0);
          temp_plug.preview.LoadFromStream(MemStream);
          MemStream.Free;
          main.Memo1.Lines.Add('Loaded preview from library '+str);
          //temp
          main.Image1.Canvas.Draw(0,0,temp_plug.preview);
        end;
      end
      else
        main.Memo1.Lines.Add('Info says that in library '+str+' has no preview');

      //stavim flag, chto plagin poka aktiven
      temp_plug.active:=true;

      //delaem stroki
      temp_plug.plug_version:=inttostr(temp_plug.info.maj_v)+'.'+inttostr(temp_plug.info.min_v)+'.'+inttostr(temp_plug.info.rel_v)+'.0';
      temp_plug.plug_file:=str;
      temp_plug.plug_full_name:=strpas(temp_plug.info.full_name);
      temp_plug.plug_name:=strpas(temp_plug.info.name);
      temp_plug.plug_author:=strpas(temp_plug.info.author);

      //dobavlaem plagin k nuzhnomu spisku
      k:=temp_plug.info.plugin_type and 7;
      case k of
        0:begin  //landscape
            i:=length(landscape_plugins);
            setlength(landscape_plugins,i+1);
            landscape_plugins[i]:=temp_plug;
          end;
        1:begin  //border
            i:=length(border_plugins);
            setlength(border_plugins,i+1);
            border_plugins[i]:=temp_plug;
          end;
        2:begin  //structures
            i:=length(structures_plugins);
            setlength(structures_plugins,i+1);
            structures_plugins[i]:=temp_plug;
          end
        else
          begin
            main.Memo1.Lines.Add('Wrong plugin type in library '+str);
            FreeLibrary(temp_plug.handle);
            continue;
          end;
      end;
      main.Memo1.Lines.Add('Added plugin to plugins list from library '+str);


    until findnext(sr)<>0;
    findclose(sr);
  end;

  setlength(sovpad,0);
  //pereimenovivaem sovpadayushie plagini generacii landshafta
  for i:=0 to length(landscape_plugins)-2 do
  begin
    //ishem, ne vnesli li mi uze nomer v spisok
    b:=false;
    for k:=0 to length(sovpad)-1 do
      for z:=0 to length(sovpad[k])-1 do
        if sovpad[k][z]=i then b:=true;

    if b=true then break;

    k:=length(sovpad);
    setlength(sovpad,k+1);
    setlength(sovpad[k],1);
    sovpad[k][0]:=i;
    for j:=i+1 to length(landscape_plugins)-1 do
    begin
      str:=(landscape_plugins[i].plug_name);
      str1:=(landscape_plugins[j].plug_name);
      if str=str1 then
      begin
        z:=length(sovpad[k]);
        setlength(sovpad[k],z+1);
        sovpad[k][z]:=j;
      end;
    end;
  end;

  for i:=0 to length(sovpad)-1 do
    if length(sovpad[i])>1 then
      for j:=0 to length(sovpad[i])-1 do
        if j>0 then
        begin
          str:=landscape_plugins[sovpad[i][j]].plug_name+'('+inttostr(j)+')';
          landscape_plugins[sovpad[i][j]].plug_name:=str;
        end;

  for i:=0 to length(sovpad)-1 do
    setlength(sovpad[i],0);
  setlength(sovpad,0);

  //pereimenovivaem sovpadayushie plagini generacii granici karti
  for i:=0 to length(border_plugins)-2 do
  begin
    //ishem, ne vnesli li mi uze nomer v spisok
    b:=false;
    for k:=0 to length(sovpad)-1 do
      for z:=0 to length(sovpad[k])-1 do
        if sovpad[k][z]=i then b:=true;

    if b=true then break;

    k:=length(sovpad);
    setlength(sovpad,k+1);
    setlength(sovpad[k],1);
    sovpad[k][0]:=i;
    for j:=i+1 to length(border_plugins)-1 do
    begin
      str:=(border_plugins[i].plug_name);
      str1:=(border_plugins[j].plug_name);
      if str=str1 then
      begin
        z:=length(sovpad[k]);
        setlength(sovpad[k],z+1);
        sovpad[k][z]:=j;
      end;
    end;
  end;

  for i:=0 to length(sovpad)-1 do
    if length(sovpad[i])>1 then
      for j:=0 to length(sovpad[i])-1 do
        if j>0 then
        begin
          str:=border_plugins[sovpad[i][j]].plug_name+'('+inttostr(j)+')';
          border_plugins[sovpad[i][j]].plug_name:=str;
        end;

  for i:=0 to length(sovpad)-1 do
    setlength(sovpad[i],0);
  setlength(sovpad,0);

  //pereimenovivaem sovpadayushie plagini generacii structur karti
  for i:=0 to length(structures_plugins)-2 do
  begin
    //ishem, ne vnesli li mi uze nomer v spisok
    b:=false;
    for k:=0 to length(sovpad)-1 do
      for z:=0 to length(sovpad[k])-1 do
        if sovpad[k][z]=i then b:=true;

    if b=true then break;

    k:=length(sovpad);
    setlength(sovpad,k+1);
    setlength(sovpad[k],1);
    sovpad[k][0]:=i;
    for j:=i+1 to length(structures_plugins)-1 do
    begin
      str:=(structures_plugins[i].plug_name);
      str1:=(structures_plugins[j].plug_name);
      if str=str1 then
      begin
        z:=length(sovpad[k]);
        setlength(sovpad[k],z+1);
        sovpad[k][z]:=j;
      end;
    end;
  end;

  for i:=0 to length(sovpad)-1 do
    if length(sovpad[i])>1 then
      for j:=0 to length(sovpad[i])-1 do
        if j>0 then
        begin
          str:=structures_plugins[sovpad[i][j]].plug_name+'('+inttostr(j)+')';
          structures_plugins[sovpad[i][j]].plug_name:=str;
        end;

  for i:=0 to length(sovpad)-1 do
    setlength(sovpad[i],0);
  setlength(sovpad,0);
end;

procedure init_plugins;
var i,j:integer;
temp,temp1,temp2:integer;
t_crc:int64;
r:rnd;
begin
  main.Memo1.Lines.Add('******************************************');

  //landscape plugins
  for i:=0 to length(landscape_plugins)-1 do
  begin
    //proveraem biti 3,5,7 na nalichie bit autefikacii
    if (((landscape_plugins[i].info.plugin_type and 8)shr 3)=1)and
    (((landscape_plugins[i].info.plugin_type and 32)shr 5)=1)and
    (((landscape_plugins[i].info.plugin_type and 128)shr 7)=1) then
    begin
      //vichislaem kontrolnuyu summu informacii

      //vichislaem crc32 ot nashey infi o plagine
      //temp:=zcrc32(0,landscape_plugins[i].info,sizeof(landscape_plugins[i].info));
      calcCRC32(@landscape_plugins[i].info,sizeof(landscape_plugins[i].info),temp);

      //delaem randomnuyu dobavku
      r:=rnd.Create;
      temp1:=r.nextInt;

      //berem iz dobavki 4 opredelennih bita i skladivaem ih v chislo
      //eto kol-vo vizivov randoma do nastoyashego vizova, t.e. esli chislo=6, to nuzhno 6 raz vizvat' random, a 7 raz budet zapisan v pole dla plagina
      //biti 5,14,19,26 sprava, schitaya ot 1
      temp2:=((temp1 shr 4)and 1)+((temp1 shr 13) and 2)+((temp1 shr 18)and 4)+((temp1 shr 26) and 8);

      //delaem kontrol'nuyu summu sidom randoma
      r.SetSeed(temp);

      //vizivaem random opredelennoe kol-vo raz
      for j:=1 to temp2 do
        r.nextInt;

      //vizivaem random eshe raz dla zapisi etogo chisla v pole
      temp:=r.nextInt;

      //teper' est' izmenenniy crc (temp) i randomnoe opredelayushee chislo (temp1)
      //t_crc:=(temp shl 32)+temp1;
      t_crc:=temp;
      t_crc:=t_crc shl 32;
      t_crc:=t_crc or ((int64(temp1)shl 32)shr 32);
      //r.SetSeed(t_crc);
      landscape_plugins[i].crc_info:=t_crc;
      r.Free;
    end
    else
    begin
      //v protivnom sluchae - peredaem randomnoe chislo
      r:=rnd.Create;
      landscape_plugins[i].crc_info:=r.nextLong;
      r.Free;
    end;

    //vizivaem proceduru inicializacii
    if landscape_plugins[i].init(application.Handle,landscape_plugins[i].crc_info)=false then
    begin
      main.Memo1.Lines.Add('Pri inicializacii plagina '+landscape_plugins[i].info.full_name+' proizoshla oshibka');
      main.Memo1.Lines.Add('Soobshenie oshibki='+landscape_plugins[i].get_last_error);
      landscape_plugins[i].active:=false;
    end
    else
      main.Memo1.Lines.Add('Inicializaciya plagina "'+landscape_plugins[i].info.full_name+'" proshla uspeshno');

    //vizivaem proceduru peredachi defoltnih blokov
    if landscape_plugins[i].set_block_id(blocks_id)=false then
    begin
      main.Memo1.Lines.Add('Pri peredache massiva blokov v plagin '+landscape_plugins[i].info.full_name+' proizoshla oshibka');
      main.Memo1.Lines.Add('Soobshenie oshibki='+landscape_plugins[i].get_last_error);
      landscape_plugins[i].active:=false;
    end
    else
      main.Memo1.Lines.Add('Peredacha massiva blokov v plagin "'+landscape_plugins[i].info.full_name+'" proshla uspeshno');

    main.Memo1.Lines.Add('------------------------');
  end;

  //border plugins
  for i:=1 to length(border_plugins)-1 do
  begin
    //proveraem biti 3,5,7 na nalichie bit autefikacii
    if (((border_plugins[i].info.plugin_type and 8)shr 3)=1)and
    (((border_plugins[i].info.plugin_type and 32)shr 5)=1)and
    (((border_plugins[i].info.plugin_type and 128)shr 7)=1) then
    begin
      //vichislaem kontrolnuyu summu informacii

      //vichislaem crc32 ot nashey infi o plagine
      //temp:=zcrc32(0,landscape_plugins[i].info,sizeof(landscape_plugins[i].info));
      calcCRC32(@landscape_plugins[i].info,sizeof(landscape_plugins[i].info),temp);

      //delaem randomnuyu dobavku
      r:=rnd.Create;
      temp1:=r.nextInt;

      //berem iz dobavki 4 opredelennih bita i skladivaem ih v chislo
      //eto kol-vo vizivov randoma do nastoyashego vizova, t.e. esli chislo=6, to nuzhno 6 raz vizvat' random, a 7 raz budet zapisan v pole dla plagina
      //biti 5,14,19,26 sprava, schitaya ot 1
      temp2:=((temp1 shr 4)and 1)+((temp1 shr 13) and 2)+((temp1 shr 18)and 4)+((temp1 shr 26) and 8);

      //delaem kontrol'nuyu summu sidom randoma
      r.SetSeed(temp);

      //vizivaem random opredelennoe kol-vo raz
      for j:=1 to temp2 do
        r.nextInt;

      //vizivaem random eshe raz dla zapisi etogo chisla v pole
      temp:=r.nextInt;

      //teper' est' izmenenniy crc (temp) i randomnoe opredelayushee chislo (temp1)
      //t_crc:=(temp shl 32)+temp1;
      t_crc:=temp;
      t_crc:=t_crc shl 32;
      t_crc:=t_crc or ((int64(temp1)shl 32)shr 32);
      //r.SetSeed(t_crc);
      border_plugins[i].crc_info:=t_crc;
      r.Free;

      //border_plugins[i].crc_info:=1;
    end
    else
    begin
      //v protivnom sluchae - peredaem randomnoe chislo
      r:=rnd.Create;
      border_plugins[i].crc_info:=r.nextLong;
      r.Free;
    end;

    //vizivaem proceduru inicializacii
    if border_plugins[i].init(application.Handle,border_plugins[i].crc_info)=false then
    begin
      main.Memo1.Lines.Add('Pri inicializacii plagina '+border_plugins[i].info.full_name+' proizoshla oshibka');
      main.Memo1.Lines.Add('Soobshenie oshibki='+border_plugins[i].get_last_error);
      border_plugins[i].active:=false;
    end
    else
      main.Memo1.Lines.Add('Inicializaciya plagina "'+border_plugins[i].info.full_name+'" proshla uspeshno');

    //vizivaem proceduru peredachi defoltnih blokov
    if border_plugins[i].set_block_id(blocks_id)=false then
    begin
      main.Memo1.Lines.Add('Pri peredache massiva blokov v plagin '+border_plugins[i].info.full_name+' proizoshla oshibka');
      main.Memo1.Lines.Add('Soobshenie oshibki='+border_plugins[i].get_last_error);
      border_plugins[i].active:=false;
    end
    else
      main.Memo1.Lines.Add('Peredacha massiva blokov v plagin "'+border_plugins[i].info.full_name+'" proshla uspeshno');

    main.Memo1.Lines.Add('------------------------');
  end;
end;

procedure Tlogo.FormCreate(Sender: TObject);
var bit:TBitmap;
begin
  bit:=TBitmap.Create;
  image1.Width:=Image1.Picture.Bitmap.Width;
  image1.Height:=Image1.Picture.Bitmap.Height;
  logo.Width:=Image1.Width+50;
  logo.Height:=Image1.Height+50;
  logo.Left:=round(screen.Width/2-image1.Width/2);
  logo.Top:=round(screen.Height/2-image1.Height/2);
  bit:=logo.Image1.Picture.Bitmap;
  SetWindowRgn(Self.Handle, BitmapToRegion(bit,clwhite), True);
end;

procedure Tlogo.Activate_plugins;
var i:integer;
begin
  //inicializiruem massivi plaginov
  setlength(landscape_plugins,0);
  //setlength(border_plugins,0);
  //setlength(structures_plugins,0);

  //delaem standartnie pustie plagini dla granici i struktur
  //border
  setlength(border_plugins,1);
  border_plugins[0].active:=true;
  border_plugins[0].handle:=0;
  border_plugins[0].plug_version:='1.0';
  border_plugins[0].plug_file:='';
  border_plugins[0].plug_full_name:='Normal transition';
  border_plugins[0].plug_name:='(No border)';
  border_plugins[0].plug_author:='Mozzg';
  border_plugins[0].preview:=TJPEGImage(border.Image2.Picture.Graphic);
  border_plugins[0].info.plugin_type:=1;
  border_plugins[0].info.full_name:='Normal transition';
  border_plugins[0].info.name:='(No border)';
  border_plugins[0].info.author:='Mozzg';
  border_plugins[0].info.dll_path:='';
  border_plugins[0].info.maj_v:=1;
  border_plugins[0].info.min_v:=0;
  border_plugins[0].info.rel_v:=0;
  border_plugins[0].auth:=false;
  for i:=1 to 21 do
    border_plugins[0].info.change_par[i]:=true;
  border_plugins[0].info.has_preview:=true;
  border_plugins[0].plugrec.size_info:=0;
  border_plugins[0].plugrec.data:=nil;

  //structures
  setlength(structures_plugins,1);
  structures_plugins[0].active:=true;
  structures_plugins[0].handle:=0;
  structures_plugins[0].plug_version:='1.0';
  structures_plugins[0].plug_file:='';
  structures_plugins[0].plug_full_name:='No structures';
  structures_plugins[0].plug_name:='(No structures)';
  structures_plugins[0].plug_author:='Mozzg';
  structures_plugins[0].preview:=nil;
  structures_plugins[0].info.plugin_type:=2;
  structures_plugins[0].info.full_name:='No structures';
  structures_plugins[0].info.name:='(No structures)';
  structures_plugins[0].info.author:='Mozzg';
  structures_plugins[0].info.dll_path:='';
  structures_plugins[0].info.maj_v:=1;
  structures_plugins[0].info.min_v:=0;
  structures_plugins[0].info.rel_v:=0;
  structures_plugins[0].auth:=false;
  for i:=1 to 21 do
    structures_plugins[0].info.change_par[i]:=true;
  structures_plugins[0].info.has_preview:=false;
  structures_plugins[0].plugrec.size_info:=0;
  structures_plugins[0].plugrec.data:=nil;

  //podkluchaem plagini
  plug_plugins;

  //inicializaciya plaginov
  init_plugins;

  //zapolnenie spiskov
  for i:=0 to length(landscape_plugins)-1 do
    main.ComboBox4.Items.Add(landscape_plugins[i].plug_name);
  main.ComboBox4.ItemIndex:=0;
  main.ComboBox4Change(main);

  {if length(border_plugins)=0 then
  begin
    border.ComboBox1.Items.Add('(No plugins available)');
  end
  else
  begin  }
    for i:=0 to length(border_plugins)-1 do
      border.ComboBox1.Items.Add(border_plugins[i].plug_name);
  //end;
  border.ComboBox1.ItemIndex:=0;
  border.ComboBox1Change(border);
end;

procedure Tlogo.FormHide(Sender: TObject);
begin
  AnimateWindow(Handle, 300, AW_BLEND or AW_HIDE);
end;

procedure Tlogo.FormShow(Sender: TObject);
var fstr:tfilestream;
compr:tzdecompressionstream;
res:TResourceStream;
pch:pchar;
str:string;
hreg:tregistry;
i:integer;
begin
  AnimateWindow(Handle, 300, AW_ACTIVATE or AW_BLEND);

  try
  //raspakovivaem shrift
  windows.deletefile('FMPTSR-1.TTF');
  res:=tresourcestream.Create(hInstance, 'MY_FONT', Pchar('FMP'));
  fstr:=tfilestream.Create('FMPTSR-1.TTF',$FFFF or $0002);    //create, openreadwrite
  compr:=tzdecompressionstream.Create(res);
  compr.Position:=0;
  fstr.CopyFrom(compr,compr.Size);

  //osvobozhdaem potoki
  compr.Free;
  res.Free;
  fstr.Free;

  //pomeshaem shrift v papku shriftov vindows
  pch := StrAlloc(MAX_PATH);
  i := GetWindowsDirectory(pch, MAX_PATH);
  if i=0 then
  begin
    application.MessageBox('Font instalation failed','Error');
    //halt(0);
    exit;
  end;
  //if Res > 0 then
  str := StrPas(pch);
  str:=str+'\Fonts\';
  copyfile('FMPTSR-1.TTF',pchar(str+'FMPTSR-1.TTF'),true);

  //udalaem uzhe nenuzhniy fayl
  windows.deletefile('FMPTSR-1.TTF');

  //zapisivaem v reestr infu pro shrift
  hReg := TRegistry.Create; 
  hReg.RootKey := HKEY_LOCAL_MACHINE; 
  hReg.LazyWrite := false; 
  hReg.OpenKey('Software\Microsoft\Windows NT\CurrentVersion\Fonts',
               false); 
  hReg.WriteString('FMPTSR-Credits Bold (TrueType)','FMPTSR-1.TTF');
  hReg.CloseKey;
  hReg.free;

  //dobavlaem shrift v sistemu
  AddFontResource(pchar(str+'FMPTSR-1.TTF'));

  //uvedomlaem prilozheniya, chto izmenilis shrifti
  postMessage($FFFF, $001D, 0, 0);     //WM_FONTCHANGE

  except
    on e:exception do
    begin
      MessageBox(logo.Handle,'The program couldn''t install nessesary font, because it has no permission to do that. Some text may be misplaced.'+#13+#10+'To allow this program to install the font, run it with administrator rights.','WARNING',MB_OK	or MB_ICONEXCLAMATION);
      //application.MessageBox('You must run this program with admin rights','Error');
      //halt(0);
    end;
  end;

  //sozdaem standartniy plagin ploskoy karti
  try
    windows.deletefile('flatmap_mct.dll');
    res:=tresourcestream.Create(hInstance, 'FLATMAP_GEN', Pchar('DLL'));
    res.SaveToFile('flatmap_mct.dll');
    res.Free; 
  except
    on e:exception do
    begin
      MessageBox(logo.Handle,pchar('The program couldn''t install plugin DLL.'+#13+#10+'Please report this error to the creator of this program:'+#13+#10+e.message),'ERROR',MB_OK	or MB_ICONERROR);
    end;
  end; 

  //Activate_plug;
end;

end.

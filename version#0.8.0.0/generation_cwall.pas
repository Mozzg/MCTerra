unit generation_cwall;

interface

uses NBT, generation_obsh;

procedure gen_border_cwall_boinici(tip,storona:integer; var blocks,data:ar_type);
procedure gen_cwall_border_towers(xkoord,ykoord,width,len:integer; par_border:border_settings_type; var blocks,data:ar_type; entities:par_entity_type; tileentities:par_tile_entity_type);

implementation

procedure gen_cwall_border_towers(xkoord,ykoord,width,len:integer; par_border:border_settings_type; var blocks,data:ar_type; entities:par_entity_type; tileentities:par_tile_entity_type);
var i,j,k:integer;
tempx,tempy,tempk,tempz:integer;
kolx,kolz:integer;
tekchotx,tekchdox,tekchoty,tekchdoy:integer;
tekint,tekintotn:integer;
shagx,shagz,tekush:double;
b:boolean;
begin
  if par_border.cwall_gen_void=true then
  begin
    tempx:=-(width div 2)+par_border.cwall_void_width;
    tempy:=-(len div 2)+par_border.cwall_void_width;
    tempk:=(width div 2)-1-par_border.cwall_void_width;
    tempz:=(len div 2)-1-par_border.cwall_void_width;
  end
  else
  begin
    tempx:=-(width div 2);
    tempy:=-(len div 2);
    tempk:=(width div 2)-1;
    tempz:=(len div 2)-1;
  end;

  //esli uglovoy chank, to vihod
  if ((xkoord=tempx)and(ykoord=tempy))or
  ((xkoord=tempx)and(ykoord=tempz))or
  ((xkoord=tempk)and(ykoord=tempy))or
  ((xkoord=tempk)and(ykoord=tempz)) then
    exit;

  //schitaem kol-vo bashen na kazhdoy iz storon karti
  kolx:=((tempk-tempx+1) div 10)-1;
  kolz:=((tempz-tempy+1) div 10)-1;

  if (kolx<0)or(kolz<0) then exit;

  //vichislaem shag v blokah ot kazhdoy bashni do sleduyushey
  shagx:=(tempk-tempx-1)*16;
  shagz:=(tempz-tempy-1)*16;
  shagx:=shagx/(kolx+1);
  shagz:=shagz/(kolz+1);

  //vishiclaem kraynie bloki tekushego chanka
  tekchotx:=xkoord*16;
  tekchoty:=ykoord*16;
  tekchdox:=tekchotx+15;
  tekchdoy:=tekchoty+15;

  if (xkoord=tempx)or(xkoord=tempk) then   //esli levaya ili pravaya stenka
  begin
    tekush:=(tempy+1)*16+shagz;
    while tekush<((tempz-1)*16) do
    begin  
      tekint:=round(tekush);
      if ((tekint-9)<tekchdoy)or((tekint+8)>tekchoty) then
      begin
        //vichislaem otnositelnie koordinati centra
        tekintotn:=tekint-tekchoty;
        if (par_border.cwall_gen_interior=true)and(par_border.cwall_gen_boinici=true) then
        begin
        //smotrim, est' li boinici radom
        b:=false;
        for j:=tekintotn-8 to tekintotn+7 do //Z
        begin
          if (j<0)or(j>15)or(b=true)or((j<>(tekintotn-8))and(j<>(tekintotn+7))) then continue;
          for k:=91 to 99 do  //Y
            if blocks[k+(j*128+(3*2048))]<>4 then
            begin
              b:=true;
              break;
            end;
        end;
        //esli est', to ochishaem ih
        if b=true then
        for j:=0 to 15 do   //Z
          for k:=91 to 99 do
          begin
            blocks[k+(j*128+(3*2048))]:=4;
            blocks[k+(j*128+(12*2048))]:=4;
            blocks[k+(j*128+(4*2048))]:=0;
            blocks[k+(j*128+(11*2048))]:=0;
            data[k+(j*128+(4*2048))]:=0;
            data[k+(j*128+(11*2048))]:=0;
          end;
        end;
        //otrisovivaem bashnu
        for j:=tekintotn-7 to tekintotn+6 do //Z
        begin
          if (j<0)or(j>15) then continue;
          for k:=1 to 110 do  //Y
            for i:=1 to 14 do  //X
              blocks[k+(j*128+(i*2048))]:=4;
        end;
        //virezaem komnatu
        for j:=tekintotn-6 to tekintotn+5 do //Z
        begin
          if (j<0)or(j>15) then continue;
          for k:=101 to 109 do  //Y
            for i:=2 to 13 do  //X
              blocks[k+(j*128+(i*2048))]:=0;
        end;
        //virezaem komnatu na 0 etazhe
        if par_border.cwall_gen_interior=true then
        for j:=tekintotn-6 to tekintotn+5 do //Z
        begin
          if (j<0)or(j>15) then continue;
          for k:=91 to 99 do  //Y
            for i:=2 to 13 do  //X
              blocks[k+(j*128+(i*2048))]:=0;
        end;
        //virezaem arki-prohodi
        for j:=tekintotn-7 to tekintotn+6 do //Z
        begin
          if (j<0)or(j>15)or((j<>(tekintotn-7))and(j<>(tekintotn+6))) then continue;
          for k:=101 to 104 do  //Y   //na 1 etazhe
            for i:=6 to 9 do  //X
              blocks[k+(j*128+(i*2048))]:=0;
          if par_border.cwall_gen_interior=true then
          for k:=91 to 94 do  //Y     //na 0 etazhe
            for i:=6 to 9 do  //X
              blocks[k+(j*128+(i*2048))]:=0;
        end;
        //delaem fakeli vnutri komnati na 1 etazhe i vnutri i snaruzhi komnati na 0 etazhe
        for j:=tekintotn-8 to tekintotn+7 do //Z
        begin
          if (j<0)or(j>15) then continue;
          if par_border.cwall_gen_interior=true then
          begin
          if (j=tekintotn-8) then
          begin
            blocks[92+(j*128+(5*2048))]:=50;
            blocks[92+(j*128+(10*2048))]:=50;
            data[92+(j*128+(5*2048))]:=4;
            data[92+(j*128+(10*2048))]:=4;
          end;
          if (j=tekintotn+7) then
          begin
            blocks[92+(j*128+(5*2048))]:=50;
            blocks[92+(j*128+(10*2048))]:=50;
            data[92+(j*128+(5*2048))]:=3;
            data[92+(j*128+(10*2048))]:=3;
          end;
          end;
          if (j=tekintotn-6) then
          begin
            if par_border.cwall_gen_interior=true then
            begin
            blocks[92+(j*128+(5*2048))]:=50;
            blocks[92+(j*128+(10*2048))]:=50;
            data[92+(j*128+(5*2048))]:=3;
            data[92+(j*128+(10*2048))]:=3;
            end;
            blocks[102+(j*128+(5*2048))]:=50;
            blocks[102+(j*128+(10*2048))]:=50;
            data[102+(j*128+(5*2048))]:=3;
            data[102+(j*128+(10*2048))]:=3;
          end;
          if (j=tekintotn+5) then
          begin
            if par_border.cwall_gen_interior=true then
            begin
            blocks[92+(j*128+(5*2048))]:=50;
            blocks[92+(j*128+(10*2048))]:=50;
            data[92+(j*128+(5*2048))]:=4;
            data[92+(j*128+(10*2048))]:=4;
            end;
            blocks[102+(j*128+(5*2048))]:=50;
            blocks[102+(j*128+(10*2048))]:=50;
            data[102+(j*128+(5*2048))]:=4;
            data[102+(j*128+(10*2048))]:=4;
          end;
        end;
        //delaem relsi naskvoz' bashni
        if par_border.cwall_gen_rails=true then
        begin
        for j:=tekintotn-8 to tekintotn+7 do //Z
        begin
          if (j<0)or(j>15) then continue;
          if (j=tekintotn-8)or(j=tekintotn+7) then
          begin
            blocks[101+(j*128+(7*2048))]:=66;
            blocks[101+(j*128+(8*2048))]:=66;
            data[101+(j*128+(7*2048))]:=6;
            data[101+(j*128+(8*2048))]:=8;
          end
          else if (j=tekintotn) then
          begin
            blocks[101+(j*128+(7*2048))]:=66;
            blocks[101+(j*128+(8*2048))]:=66;
            data[101+(j*128+(7*2048))]:=9;
            data[101+(j*128+(8*2048))]:=7;
          end
          else if (j>tekintotn-8)and(j<tekintotn) then
          begin
            blocks[101+(j*128+(7*2048))]:=27;
            data[101+(j*128+(7*2048))]:=8;
            if (j=tekintotn-4) then
            begin
              blocks[101+(j*128+(6*2048))]:=76;
              data[101+(j*128+(6*2048))]:=5;
              blocks[101+(j*128+(9*2048))]:=76;
              data[101+(j*128+(9*2048))]:=5;
            end;
          end
          else if (j>tekintotn)and(j<tekintotn+7) then
          begin
            blocks[101+(j*128+(8*2048))]:=27;
            data[101+(j*128+(8*2048))]:=8;
            if (j=tekintotn+3) then
            begin
              blocks[101+(j*128+(6*2048))]:=76;
              data[101+(j*128+(6*2048))]:=5;
              blocks[101+(j*128+(9*2048))]:=76;
              data[101+(j*128+(9*2048))]:=5;
            end;
          end;
        end;
        //delaem busteri
        for j:=tekintotn-7 to tekintotn+6 do //Z
        begin
          if (j<0)or(j>15) then continue;
          if (j>=tekintotn-7)and(j<=tekintotn-2) then
          begin
            blocks[101+(j*128+(8*2048))]:=27;
            data[101+(j*128+(8*2048))]:=8;
          end
          else if (j>=tekintotn+2)and(j<=tekintotn+6) then
          begin
            blocks[101+(j*128+(7*2048))]:=27;
            data[101+(j*128+(7*2048))]:=8;
          end
          else if (j=tekintotn-1) then
          begin
            for i:=9 to 11 do
            begin
              blocks[101+(j*128+(i*2048))]:=27;
              data[101+(j*128+(i*2048))]:=1;
            end;
            blocks[101+(j*128+(12*2048))]:=27;
            data[101+(j*128+(12*2048))]:=2;
            blocks[101+(j*128+(13*2048))]:=4;
            blocks[102+(j*128+(13*2048))]:=4;
            blocks[101+(j*128+(8*2048))]:=66;
            data[101+(j*128+(8*2048))]:=9;
          end
          else if (j=tekintotn) then
          begin
            blocks[101+(j*128+(9*2048))]:=4;
            blocks[101+(j*128+(6*2048))]:=4;
            blocks[102+(j*128+(9*2048))]:=50;
            blocks[102+(j*128+(6*2048))]:=50;
            data[102+(j*128+(9*2048))]:=5;
            data[102+(j*128+(6*2048))]:=5;
            blocks[101+(j*128+(10*2048))]:=77;
            data[101+(j*128+(10*2048))]:=1;
            blocks[101+(j*128+(5*2048))]:=77;
            data[101+(j*128+(5*2048))]:=2;
          end
          else if (j=tekintotn+1) then
          begin
            for i:=4 to 6 do
            begin
              blocks[101+(j*128+(i*2048))]:=27;
              data[101+(j*128+(i*2048))]:=1;
            end;
            blocks[101+(j*128+(3*2048))]:=27;
            data[101+(j*128+(3*2048))]:=3;
            blocks[101+(j*128+(2*2048))]:=4;
            blocks[102+(j*128+(2*2048))]:=4;
            blocks[101+(j*128+(7*2048))]:=66;
            data[101+(j*128+(7*2048))]:=7;
          end;
          //delaem sunduki
          if (tileentities<>nil)and((j=tekintotn-6)or(j=tekintotn+5)) then
          begin
            i:=length(tileentities^);
            setlength(tileentities^,i+1);
            tileentities^[i].id:='Chest';
            if (j=tekintotn-6) then
            begin
              tileentities^[i].x:=xkoord*16+2;
              tileentities^[i].y:=101;
              tileentities^[i].z:=ykoord*16+j;
              blocks[101+(j*128+(2*2048))]:=54;
            end
            else if (j=tekintotn+5) then
            begin
              tileentities^[i].x:=xkoord*16+13;
              tileentities^[i].y:=101;
              tileentities^[i].z:=ykoord*16+j;
              blocks[101+(j*128+(13*2048))]:=54;
            end;
            new(pchest_tile_entity_data(tileentities^[i].dannie));
            setlength(pchest_tile_entity_data(tileentities^[i].dannie)^.items,5);
            for k:=0 to 4 do
            begin
              pchest_tile_entity_data(tileentities^[i].dannie)^.items[k].id:=328;
              pchest_tile_entity_data(tileentities^[i].dannie)^.items[k].damage:=0;
              pchest_tile_entity_data(tileentities^[i].dannie)^.items[k].count:=1;
              pchest_tile_entity_data(tileentities^[i].dannie)^.items[k].slot:=k;
            end;
          end;
        end;
        end;
        //delaem lestnicu ot 1 etazha na krishu
        for j:=tekintotn-6 to tekintotn+5 do //Z
        begin
          if (j<0)or(j>15) then continue;
          if (j=tekintotn-6) then
            for k:=101 to 110 do
            begin
              blocks[k+(j*128+(13*2048))]:=65;
              data[k+(j*128+(13*2048))]:=3;
            end;
          if (j=tekintotn+5) then
            for k:=101 to 110 do
            begin
              blocks[k+(j*128+(2*2048))]:=65;
              data[k+(j*128+(2*2048))]:=2;
            end;
        end;
        //delaem lestnicu ot 0 etazha na 1 etazh
        if par_border.cwall_gen_interior=true then
        begin
        for j:=tekintotn-6 to tekintotn+5 do //Z
        begin
          if (j<0)or(j>15) then continue;
          if (j=tekintotn-6) then
            for k:=91 to 100 do
            begin
              blocks[k+(j*128+(13*2048))]:=65;
              data[k+(j*128+(13*2048))]:=3;
            end;
          if (j=tekintotn+5) then
            for k:=91 to 100 do
            begin
              blocks[k+(j*128+(2*2048))]:=65;
              data[k+(j*128+(2*2048))]:=2;
            end;
        end;
        //delaem boinici
        if par_border.cwall_gen_boinici=true then
        for j:=tekintotn-2 to tekintotn+2 do //Z
        begin
          if (j<0)or(j>15) then continue;
          case par_border.cwall_boinici_type of
          0:begin  //line
              if (j=tekintotn-1)or(j=tekintotn+1) then
              begin
                for k:=2 to 5 do
                begin
                  blocks[(90+k)+(j*128+(1*2048))]:=43;
                  blocks[(90+k)+(j*128+(14*2048))]:=43;
                  blocks[(101+k)+(j*128+(1*2048))]:=43;
                  blocks[(101+k)+(j*128+(14*2048))]:=43;
                end;
              end
              else if j=tekintotn then
              begin
                blocks[91+(j*128+(1*2048))]:=43;
                blocks[92+(j*128+(1*2048))]:=44;
                blocks[93+(j*128+(1*2048))]:=0;
                blocks[94+(j*128+(1*2048))]:=0;
                blocks[95+(j*128+(1*2048))]:=0;
                blocks[96+(j*128+(1*2048))]:=43;
                blocks[91+(j*128+(14*2048))]:=43;
                blocks[92+(j*128+(14*2048))]:=44;
                blocks[93+(j*128+(14*2048))]:=0;
                blocks[94+(j*128+(14*2048))]:=0;
                blocks[95+(j*128+(14*2048))]:=0;
                blocks[96+(j*128+(14*2048))]:=43;
                blocks[102+(j*128+(1*2048))]:=43;
                blocks[103+(j*128+(1*2048))]:=44;
                blocks[104+(j*128+(1*2048))]:=0;
                blocks[105+(j*128+(1*2048))]:=0;
                blocks[106+(j*128+(1*2048))]:=0;
                blocks[107+(j*128+(1*2048))]:=43;
                blocks[102+(j*128+(14*2048))]:=43;
                blocks[103+(j*128+(14*2048))]:=44;
                blocks[104+(j*128+(14*2048))]:=0;
                blocks[105+(j*128+(14*2048))]:=0;
                blocks[106+(j*128+(14*2048))]:=0;
                blocks[107+(j*128+(14*2048))]:=43;
              end;
            end;
          1:begin  //cross
              if (j=tekintotn-2)or(j=tekintotn+2) then
              begin
                blocks[94+(j*128+(1*2048))]:=43;
                blocks[94+(j*128+(14*2048))]:=43;
                blocks[105+(j*128+(1*2048))]:=43;
                blocks[105+(j*128+(14*2048))]:=43;
              end
              else if (j=tekintotn-1)or(j=tekintotn+1) then
              begin
                blocks[92+(j*128+(1*2048))]:=43;
                blocks[93+(j*128+(1*2048))]:=43;
                blocks[94+(j*128+(1*2048))]:=44;
                blocks[95+(j*128+(1*2048))]:=43;
                blocks[92+(j*128+(14*2048))]:=43;
                blocks[93+(j*128+(14*2048))]:=43;
                blocks[94+(j*128+(14*2048))]:=44;
                blocks[95+(j*128+(14*2048))]:=43;
                blocks[103+(j*128+(1*2048))]:=43;
                blocks[104+(j*128+(1*2048))]:=43;
                blocks[105+(j*128+(1*2048))]:=44;
                blocks[106+(j*128+(1*2048))]:=43;
                blocks[103+(j*128+(14*2048))]:=43;
                blocks[104+(j*128+(14*2048))]:=43;
                blocks[105+(j*128+(14*2048))]:=44;
                blocks[106+(j*128+(14*2048))]:=43;
              end
              else if j=tekintotn then
              begin
                blocks[91+(j*128+(1*2048))]:=43;
                blocks[92+(j*128+(1*2048))]:=44;
                blocks[93+(j*128+(1*2048))]:=0;
                blocks[94+(j*128+(1*2048))]:=0;
                blocks[95+(j*128+(1*2048))]:=0;
                blocks[96+(j*128+(1*2048))]:=43;
                blocks[91+(j*128+(14*2048))]:=43;
                blocks[92+(j*128+(14*2048))]:=44;
                blocks[93+(j*128+(14*2048))]:=0;
                blocks[94+(j*128+(14*2048))]:=0;
                blocks[95+(j*128+(14*2048))]:=0;
                blocks[96+(j*128+(14*2048))]:=43;
                blocks[102+(j*128+(1*2048))]:=43;
                blocks[103+(j*128+(1*2048))]:=44;
                blocks[104+(j*128+(1*2048))]:=0;
                blocks[105+(j*128+(1*2048))]:=0;
                blocks[106+(j*128+(1*2048))]:=0;
                blocks[107+(j*128+(1*2048))]:=43;
                blocks[102+(j*128+(14*2048))]:=43;
                blocks[103+(j*128+(14*2048))]:=44;
                blocks[104+(j*128+(14*2048))]:=0;
                blocks[105+(j*128+(14*2048))]:=0;
                blocks[106+(j*128+(14*2048))]:=0;
                blocks[107+(j*128+(14*2048))]:=43;
              end;
            end;
          2:begin  //square
              if (j=tekintotn-2)or(j=tekintotn+1) then
              begin
                blocks[93+(j*128+(1*2048))]:=43;
                blocks[93+(j*128+(14*2048))]:=43;
                blocks[94+(j*128+(1*2048))]:=43;
                blocks[94+(j*128+(14*2048))]:=43;
                blocks[103+(j*128+(1*2048))]:=43;
                blocks[103+(j*128+(14*2048))]:=43;
                blocks[104+(j*128+(1*2048))]:=43;
                blocks[104+(j*128+(14*2048))]:=43;
              end
              else if (j=tekintotn-1)or(j=tekintotn) then
              begin
                blocks[92+(j*128+(1*2048))]:=43;
                blocks[95+(j*128+(1*2048))]:=43;
                blocks[93+(j*128+(1*2048))]:=44;
                blocks[94+(j*128+(1*2048))]:=0;
                blocks[92+(j*128+(14*2048))]:=43;
                blocks[95+(j*128+(14*2048))]:=43;
                blocks[93+(j*128+(14*2048))]:=44;
                blocks[94+(j*128+(14*2048))]:=0;
                blocks[102+(j*128+(1*2048))]:=43;
                blocks[105+(j*128+(1*2048))]:=43;
                blocks[103+(j*128+(1*2048))]:=44;
                blocks[104+(j*128+(1*2048))]:=0;
                blocks[102+(j*128+(14*2048))]:=43;
                blocks[105+(j*128+(14*2048))]:=43;
                blocks[103+(j*128+(14*2048))]:=44;
                blocks[104+(j*128+(14*2048))]:=0;
              end;
            end;
          end;
        end;
        end;
        //delaem fakeli na boinicah s vnutrenney storoni
        for j:=tekintotn-2 to tekintotn+2 do //Z
        begin
          if (j<0)or(j>15) then continue;
          for k:=91 to 107 do
          begin
            if blocks[k+(j*128+(2048))]=43 then
            begin
              blocks[k+(j*128+(2*2048))]:=50;
              data[k+(j*128+(2*2048))]:=1;
            end;
            if blocks[k+(j*128+(14*2048))]=43 then
            begin
              blocks[k+(j*128+(13*2048))]:=50;
              data[k+(j*128+(13*2048))]:=2;
            end;
          end;
        end;
        //delaem rasshirenie naverhu bashni dla chastokola + chastokol
        for j:=tekintotn-8 to tekintotn+7 do //Z
        begin
          if (j<0)or(j>15) then continue;
          for k:=109 to 110 do  //Y
            for i:=0 to 15 do  //X
            begin
              if (j<>(tekintotn-8))and(j<>(tekintotn+7))and(i<>0)and(i<>15) then continue;
              blocks[k+(j*128+(i*2048))]:=4;     //rasshirenie
              if k=110 then         //chastokol + fakeli
              begin
                if (j=(tekintotn-8))or(j=(tekintotn+7)) then
                  if ((i and 1)=1) then
                  begin
                    blocks[k+1+(j*128+(i*2048))]:=4;
                    blocks[k+2+(j*128+(i*2048))]:=50;
                    data[k+2+(j*128+(i*2048))]:=5;
                  end
                  else
                  begin
                    blocks[k+1+(j*128+(i*2048))]:=44;
                    data[k+1+(j*128+(i*2048))]:=3;
                  end;

                if (i=0)or(i=15) then
                  if ((j and 1)=1)then
                  begin
                    blocks[k+1+(j*128+(i*2048))]:=4;
                    blocks[k+2+(j*128+(i*2048))]:=50;
                    data[k+2+(j*128+(i*2048))]:=5;
                  end
                  else
                  begin
                    blocks[k+1+(j*128+(i*2048))]:=44;
                    data[k+1+(j*128+(i*2048))]:=3;
                  end;

                //otdelno ugli
                if ((i=0)and(j=(tekintotn-8)))or
                ((i=0)and(j=(tekintotn+7)))or
                ((i=15)and(j=(tekintotn-8)))or
                ((i=15)and(j=(tekintotn+7))) then
                begin
                  blocks[k+1+(j*128+(i*2048))]:=4;
                  blocks[k+2+(j*128+(i*2048))]:=50;
                  data[k+2+(j*128+(i*2048))]:=5;
                end;
              end;
            end;
        end;
      end;
      tekush:=tekush+shagz;
    end;
  end;

  if (ykoord=tempy)or(ykoord=tempz) then   //esli verhnaya ili nizhnaya stena
  begin
    tekush:=(tempx+1)*16+shagx;
    while tekush<((tempk-1)*16) do
    begin
      tekint:=round(tekush);
      if ((tekint-9)<tekchdox)or((tekint+8)>tekchotx) then
      begin
        //vichislaem otnositelnie koordinati centra
        tekintotn:=tekint-tekchotx;
        //smotrim, est' li boinici radom
        if (par_border.cwall_gen_interior=true)and(par_border.cwall_gen_boinici=true) then
        begin
        b:=false;
        for j:=tekintotn-8 to tekintotn+7 do //X
        begin
          if (j<0)or(j>15)or(b=true)or((j<>(tekintotn-8))and(j<>(tekintotn+7))) then continue;
          for k:=91 to 99 do  //Y
            if blocks[k+(3*128+(j*2048))]<>4 then
            begin
              b:=true;
              break;
            end;
        end;
        //esli est', to ochishaem ih
        if b=true then
        for j:=0 to 15 do   //X
          for k:=91 to 99 do
          begin
            blocks[k+(3*128+(j*2048))]:=4;
            blocks[k+(12*128+(j*2048))]:=4;
            blocks[k+(4*128+(j*2048))]:=0;
            blocks[k+(11*128+(j*2048))]:=0;
            data[k+(4*128+(j*2048))]:=0;
            data[k+(11*128+(j*2048))]:=0;
          end;
        end;
        //otrisovivaem bashnu
        for j:=tekintotn-7 to tekintotn+6 do //X
        begin
          if (j<0)or(j>15) then continue;
          for k:=1 to 110 do  //Y
            for i:=1 to 14 do  //Z
              blocks[k+(i*128+(j*2048))]:=4;
        end;
        //virezaem komnatu
        for j:=tekintotn-6 to tekintotn+5 do //X
        begin
          if (j<0)or(j>15) then continue;
          for k:=101 to 109 do  //Y
            for i:=2 to 13 do  //Z
              blocks[k+(i*128+(j*2048))]:=0;
        end;
        //virezaem komnatu na 0 etazhe
        if par_border.cwall_gen_interior=true then
        for j:=tekintotn-6 to tekintotn+5 do //X
        begin
          if (j<0)or(j>15) then continue;
          for k:=91 to 99 do  //Y
            for i:=2 to 13 do  //X
              blocks[k+(i*128+(j*2048))]:=0;
        end;
        //virezaem arki-prohodi
        for j:=tekintotn-7 to tekintotn+6 do //X
        begin
          if (j<0)or(j>15)or((j<>(tekintotn-7))and(j<>(tekintotn+6))) then continue;
          for k:=101 to 104 do  //Y   //na 1 etazhe
            for i:=6 to 9 do  //Z
              blocks[k+(i*128+(j*2048))]:=0;
          if par_border.cwall_gen_interior=true then
          for k:=91 to 94 do  //Y     //na 0 etazhe
            for i:=6 to 9 do  //X
              blocks[k+(i*128+(j*2048))]:=0;
        end;
        //delaem fakeli vnutri komnati na 1 etazhe i vnutri i snaruzhi komnati na 0 etazhe
        for j:=tekintotn-8 to tekintotn+7 do //X
        begin
          if (j<0)or(j>15) then continue;
          if par_border.cwall_gen_interior=true then
          begin
          if (j=tekintotn-8) then
          begin
            blocks[92+(5*128+(j*2048))]:=50;
            blocks[92+(10*128+(j*2048))]:=50;
            data[92+(5*128+(j*2048))]:=2;
            data[92+(10*128+(j*2048))]:=2;
          end;
          if (j=tekintotn+7) then
          begin
            blocks[92+(5*128+(j*2048))]:=50;
            blocks[92+(10*128+(j*2048))]:=50;
            data[92+(5*128+(j*2048))]:=1;
            data[92+(10*128+(j*2048))]:=1;
          end;
          end;
          if (j=tekintotn-6) then
          begin
            if par_border.cwall_gen_interior=true then
            begin
            blocks[92+(5*128+(j*2048))]:=50;
            blocks[92+(10*128+(j*2048))]:=50;
            data[92+(5*128+(j*2048))]:=1;
            data[92+(10*128+(j*2048))]:=1;
            end;
            blocks[102+(5*128+(j*2048))]:=50;
            blocks[102+(10*128+(j*2048))]:=50;
            data[102+(5*128+(j*2048))]:=1;
            data[102+(10*128+(j*2048))]:=1;
          end;
          if (j=tekintotn+5) then
          begin
            if par_border.cwall_gen_interior=true then
            begin
            blocks[92+(5*128+(j*2048))]:=50;
            blocks[92+(10*128+(j*2048))]:=50;
            data[92+(5*128+(j*2048))]:=2;
            data[92+(10*128+(j*2048))]:=2;
            end;
            blocks[102+(5*128+(j*2048))]:=50;
            blocks[102+(10*128+(j*2048))]:=50;
            data[102+(5*128+(j*2048))]:=2;
            data[102+(10*128+(j*2048))]:=2;
          end;
        end;
        //delaem relsi naskvoz' bashni
        if par_border.cwall_gen_rails=true then
        begin
        for j:=tekintotn-8 to tekintotn+7 do //Z
        begin
          if (j<0)or(j>15) then continue;
          if (j=tekintotn-8)or(j=tekintotn+7) then
          begin
            blocks[101+(7*128+(j*2048))]:=66;
            blocks[101+(8*128+(j*2048))]:=66;
            data[101+(7*128+(j*2048))]:=7;
            data[101+(8*128+(j*2048))]:=9;
          end
          else if (j=tekintotn) then
          begin
            blocks[101+(7*128+(j*2048))]:=66;
            blocks[101+(8*128+(j*2048))]:=66;
            data[101+(7*128+(j*2048))]:=6;
            data[101+(8*128+(j*2048))]:=8;
          end
          else if (j>tekintotn-8)and(j<tekintotn) then
          begin
            blocks[101+(8*128+(j*2048))]:=27;
            data[101+(8*128+(j*2048))]:=9;
            if (j=tekintotn-4) then
            begin
              blocks[101+(6*128+(j*2048))]:=76;
              data[101+(6*128+(j*2048))]:=5;
              blocks[101+(9*128+(j*2048))]:=76;
              data[101+(9*128+(j*2048))]:=5;
            end;
          end
          else if (j>tekintotn)and(j<tekintotn+7) then
          begin
            blocks[101+(7*128+(j*2048))]:=27;
            data[101+(7*128+(j*2048))]:=9;
            if (j=tekintotn+3) then
            begin
              blocks[101+(6*128+(j*2048))]:=76;
              data[101+(6*128+(j*2048))]:=5;
              blocks[101+(9*128+(j*2048))]:=76;
              data[101+(9*128+(j*2048))]:=5;
            end;
          end;
        end;
        //delaem busteri
        for j:=tekintotn-7 to tekintotn+6 do //Z
        begin
          if (j<0)or(j>15) then continue;
          if (j>=tekintotn-7)and(j<=tekintotn-2) then
          begin
            blocks[101+(7*128+(j*2048))]:=27;
            data[101+(7*128+(j*2048))]:=9;
          end
          else if (j>=tekintotn+2)and(j<=tekintotn+6) then
          begin
            blocks[101+(8*128+(j*2048))]:=27;
            data[101+(8*128+(j*2048))]:=9;
          end
          else if (j=tekintotn-1) then
          begin
            for i:=4 to 6 do
            begin
              blocks[101+(i*128+(j*2048))]:=27;
              data[101+(i*128+(j*2048))]:=0;
            end;
            blocks[101+(3*128+(j*2048))]:=27;
            data[101+(3*128+(j*2048))]:=4;
            blocks[101+(2*128+(j*2048))]:=4;
            blocks[102+(2*128+(j*2048))]:=4;
            blocks[101+(7*128+(j*2048))]:=66;
            data[101+(7*128+(j*2048))]:=8;
          end
          else if (j=tekintotn) then
          begin
            blocks[101+(9*128+(j*2048))]:=4;
            blocks[101+(6*128+(j*2048))]:=4;
            blocks[102+(9*128+(j*2048))]:=50;
            blocks[102+(6*128+(j*2048))]:=50;
            data[102+(9*128+(j*2048))]:=5;
            data[102+(6*128+(j*2048))]:=5;
            blocks[101+(10*128+(j*2048))]:=77;
            data[101+(10*128+(j*2048))]:=3;
            blocks[101+(5*128+(j*2048))]:=77;
            data[101+(5*128+(j*2048))]:=4;
          end
          else if (j=tekintotn+1) then
          begin
            for i:=9 to 11 do
            begin
              blocks[101+(i*128+(j*2048))]:=27;
              data[101+(i*128+(j*2048))]:=0;
            end;
            blocks[101+(12*128+(j*2048))]:=27;
            data[101+(12*128+(j*2048))]:=5;
            blocks[101+(13*128+(j*2048))]:=4;
            blocks[102+(13*128+(j*2048))]:=4;
            blocks[101+(8*128+(j*2048))]:=66;
            data[101+(8*128+(j*2048))]:=6;
          end;
          //delaem sunduki
          if (tileentities<>nil)and((j=tekintotn-6)or(j=tekintotn+5)) then
          begin
            i:=length(tileentities^);
            setlength(tileentities^,i+1);
            tileentities^[i].id:='Chest';
            if (j=tekintotn-6) then
            begin
              tileentities^[i].x:=xkoord*16+j;
              tileentities^[i].y:=101;
              tileentities^[i].z:=ykoord*16+2;
              blocks[101+(2*128+(j*2048))]:=54;
            end
            else if (j=tekintotn+5) then
            begin
              tileentities^[i].x:=xkoord*16+j;
              tileentities^[i].y:=101;
              tileentities^[i].z:=ykoord*16+13;
              blocks[101+(13*128+(j*2048))]:=54;
            end;
            new(pchest_tile_entity_data(tileentities^[i].dannie));
            setlength(pchest_tile_entity_data(tileentities^[i].dannie)^.items,5);
            for k:=0 to 4 do
            begin
              pchest_tile_entity_data(tileentities^[i].dannie)^.items[k].id:=328;
              pchest_tile_entity_data(tileentities^[i].dannie)^.items[k].damage:=0;
              pchest_tile_entity_data(tileentities^[i].dannie)^.items[k].count:=1;
              pchest_tile_entity_data(tileentities^[i].dannie)^.items[k].slot:=k;
            end;
          end;
        end;
        end;
        //delaem lestnicu ot 1 etazha na krishu
        for j:=tekintotn-6 to tekintotn+5 do //Z
        begin
          if (j<0)or(j>15) then continue;
          if (j=tekintotn-6) then
            for k:=101 to 110 do
            begin
              blocks[k+(13*128+(j*2048))]:=65;
              data[k+(13*128+(j*2048))]:=5;
            end;
          if (j=tekintotn+5) then
            for k:=101 to 110 do
            begin
              blocks[k+(2*128+(j*2048))]:=65;
              data[k+(2*128+(j*2048))]:=4;
            end;
        end;
        if par_border.cwall_gen_interior=true then
        begin
        //delaem lestnicu ot 0 etazha na 1 etazh
        for j:=tekintotn-6 to tekintotn+5 do //Z
        begin
          if (j<0)or(j>15) then continue;
          if (j=tekintotn-6) then
            for k:=91 to 100 do
            begin
              blocks[k+(13*128+(j*2048))]:=65;
              data[k+(13*128+(j*2048))]:=5;
            end;
          if (j=tekintotn+5) then
            for k:=91 to 100 do
            begin
              blocks[k+(2*128+(j*2048))]:=65;
              data[k+(2*128+(j*2048))]:=4;
            end;
        end;
        //delaem boinici
        if par_border.cwall_gen_boinici=true then
        for j:=tekintotn-2 to tekintotn+2 do //Z
        begin
          if (j<0)or(j>15) then continue;
          case par_border.cwall_boinici_type of
          0:begin  //line
              if (j=tekintotn-1)or(j=tekintotn+1) then
              begin
                for k:=2 to 5 do
                begin
                  blocks[(90+k)+(1*128+(j*2048))]:=43;
                  blocks[(90+k)+(14*128+(j*2048))]:=43;
                  blocks[(101+k)+(1*128+(j*2048))]:=43;
                  blocks[(101+k)+(14*128+(j*2048))]:=43;
                end;
              end
              else if j=tekintotn then
              begin
                blocks[91+(1*128+(j*2048))]:=43;
                blocks[92+(1*128+(j*2048))]:=44;
                blocks[93+(1*128+(j*2048))]:=0;
                blocks[94+(1*128+(j*2048))]:=0;
                blocks[95+(1*128+(j*2048))]:=0;
                blocks[96+(1*128+(j*2048))]:=43;
                blocks[91+(14*128+(j*2048))]:=43;
                blocks[92+(14*128+(j*2048))]:=44;
                blocks[93+(14*128+(j*2048))]:=0;
                blocks[94+(14*128+(j*2048))]:=0;
                blocks[95+(14*128+(j*2048))]:=0;
                blocks[96+(14*128+(j*2048))]:=43;
                blocks[102+(1*128+(j*2048))]:=43;
                blocks[103+(1*128+(j*2048))]:=44;
                blocks[104+(1*128+(j*2048))]:=0;
                blocks[105+(1*128+(j*2048))]:=0;
                blocks[106+(1*128+(j*2048))]:=0;
                blocks[107+(1*128+(j*2048))]:=43;
                blocks[102+(14*128+(j*2048))]:=43;
                blocks[103+(14*128+(j*2048))]:=44;
                blocks[104+(14*128+(j*2048))]:=0;
                blocks[105+(14*128+(j*2048))]:=0;
                blocks[106+(14*128+(j*2048))]:=0;
                blocks[107+(14*128+(j*2048))]:=43;
              end;
            end;
          1:begin  //cross
              if (j=tekintotn-2)or(j=tekintotn+2) then
              begin
                blocks[94+(1*128+(j*2048))]:=43;
                blocks[94+(14*128+(j*2048))]:=43;
                blocks[105+(1*128+(j*2048))]:=43;
                blocks[105+(14*128+(j*2048))]:=43;
              end
              else if (j=tekintotn-1)or(j=tekintotn+1) then
              begin
                blocks[92+(1*128+(j*2048))]:=43;
                blocks[93+(1*128+(j*2048))]:=43;
                blocks[94+(1*128+(j*2048))]:=44;
                blocks[95+(1*128+(j*2048))]:=43;
                blocks[92+(14*128+(j*2048))]:=43;
                blocks[93+(14*128+(j*2048))]:=43;
                blocks[94+(14*128+(j*2048))]:=44;
                blocks[95+(14*128+(j*2048))]:=43;
                blocks[103+(1*128+(j*2048))]:=43;
                blocks[104+(1*128+(j*2048))]:=43;
                blocks[105+(1*128+(j*2048))]:=44;
                blocks[106+(1*128+(j*2048))]:=43;
                blocks[103+(14*128+(j*2048))]:=43;
                blocks[104+(14*128+(j*2048))]:=43;
                blocks[105+(14*128+(j*2048))]:=44;
                blocks[106+(14*128+(j*2048))]:=43;
              end
              else if j=tekintotn then
              begin
                blocks[91+(1*128+(j*2048))]:=43;
                blocks[92+(1*128+(j*2048))]:=44;
                blocks[93+(1*128+(j*2048))]:=0;
                blocks[94+(1*128+(j*2048))]:=0;
                blocks[95+(1*128+(j*2048))]:=0;
                blocks[96+(1*128+(j*2048))]:=43;
                blocks[91+(14*128+(j*2048))]:=43;
                blocks[92+(14*128+(j*2048))]:=44;
                blocks[93+(14*128+(j*2048))]:=0;
                blocks[94+(14*128+(j*2048))]:=0;
                blocks[95+(14*128+(j*2048))]:=0;
                blocks[96+(14*128+(j*2048))]:=43;
                blocks[102+(1*128+(j*2048))]:=43;
                blocks[103+(1*128+(j*2048))]:=44;
                blocks[104+(1*128+(j*2048))]:=0;
                blocks[105+(1*128+(j*2048))]:=0;
                blocks[106+(1*128+(j*2048))]:=0;
                blocks[107+(1*128+(j*2048))]:=43;
                blocks[102+(14*128+(j*2048))]:=43;
                blocks[103+(14*128+(j*2048))]:=44;
                blocks[104+(14*128+(j*2048))]:=0;
                blocks[105+(14*128+(j*2048))]:=0;
                blocks[106+(14*128+(j*2048))]:=0;
                blocks[107+(14*128+(j*2048))]:=43;
              end;
            end;
          2:begin  //square
              if (j=tekintotn-2)or(j=tekintotn+1) then
              begin
                blocks[93+(1*128+(j*2048))]:=43;
                blocks[93+(14*128+(j*2048))]:=43;
                blocks[94+(1*128+(j*2048))]:=43;
                blocks[94+(14*128+(j*2048))]:=43;
                blocks[103+(1*128+(j*2048))]:=43;
                blocks[103+(14*128+(j*2048))]:=43;
                blocks[104+(1*128+(j*2048))]:=43;
                blocks[104+(14*128+(j*2048))]:=43;
              end
              else if (j=tekintotn-1)or(j=tekintotn) then
              begin
                blocks[92+(1*128+(j*2048))]:=43;
                blocks[95+(1*128+(j*2048))]:=43;
                blocks[93+(1*128+(j*2048))]:=44;
                blocks[94+(1*128+(j*2048))]:=0;
                blocks[92+(14*128+(j*2048))]:=43;
                blocks[95+(14*128+(j*2048))]:=43;
                blocks[93+(14*128+(j*2048))]:=44;
                blocks[94+(14*128+(j*2048))]:=0;
                blocks[102+(1*128+(j*2048))]:=43;
                blocks[105+(1*128+(j*2048))]:=43;
                blocks[103+(1*128+(j*2048))]:=44;
                blocks[104+(1*128+(j*2048))]:=0;
                blocks[102+(14*128+(j*2048))]:=43;
                blocks[105+(14*128+(j*2048))]:=43;
                blocks[103+(14*128+(j*2048))]:=44;
                blocks[104+(14*128+(j*2048))]:=0;
              end;
            end;
          end;
        end;
        end;
        //delaem fakeli na boinicah s vnutrenney storoni
        for j:=tekintotn-2 to tekintotn+2 do //Z
        begin
          if (j<0)or(j>15) then continue;
          for k:=91 to 107 do
          begin
            if blocks[k+(128+(j*2048))]=43 then
            begin
              blocks[k+(2*128+(j*2048))]:=50;
              data[k+(2*128+(j*2048))]:=3;
            end;
            if blocks[k+(14*128+(j*2048))]=43 then
            begin
              blocks[k+(13*128+(j*2048))]:=50;
              data[k+(13*128+(j*2048))]:=4;
            end;
          end;
        end;
        //delaem rasshirenie naverhu bashni dla chastokola + chastokol
        for j:=tekintotn-8 to tekintotn+7 do //X
        begin
          if (j<0)or(j>15) then continue;
          for k:=109 to 110 do  //Y
            for i:=0 to 15 do  //Z
            begin
              if (j<>(tekintotn-8))and(j<>(tekintotn+7))and(i<>0)and(i<>15) then continue;
              blocks[k+(i*128+(j*2048))]:=4;   //rasshirenie
              if k=110 then       //chastokol + fakeli
              begin
                if (j=(tekintotn-8))or(j=(tekintotn+7)) then
                  if ((i and 1)=1) then
                  begin
                    blocks[k+1+(i*128+(j*2048))]:=4;
                    blocks[k+2+(i*128+(j*2048))]:=50;
                    data[k+2+(i*128+(j*2048))]:=5;
                  end
                  else
                  begin
                    blocks[k+1+(i*128+(j*2048))]:=44;
                    data[k+1+(i*128+(j*2048))]:=3;
                  end;

                if (i=0)or(i=15) then
                  if ((j and 1)=1)then
                  begin
                    blocks[k+1+(i*128+(j*2048))]:=4;
                    blocks[k+2+(i*128+(j*2048))]:=50;
                    data[k+2+(i*128+(j*2048))]:=5;
                  end
                  else
                  begin
                    blocks[k+1+(i*128+(j*2048))]:=44;
                    data[k+1+(i*128+(j*2048))]:=3;
                  end;

                //otdelno ugli
                if ((i=0)and(j=(tekintotn-8)))or
                ((i=0)and(j=(tekintotn+7)))or
                ((i=15)and(j=(tekintotn-8)))or
                ((i=15)and(j=(tekintotn+7))) then
                begin
                  blocks[k+1+(i*128+(j*2048))]:=4;
                  blocks[k+2+(i*128+(j*2048))]:=50;
                  data[k+2+(i*128+(j*2048))]:=5;
                end;
              end;
            end;
        end;
      end;
      tekush:=tekush+shagx;
    end;
  end;
end;

procedure gen_border_cwall_boinici(tip,storona:integer; var blocks,data:ar_type);
var i:integer;
begin
  //storoni:
  //1=levaya nizhnaya
  //2=levaya verhnaya
  //3=pravaya nizhnaya
  //4=pravaya verhnaya
  for i:=1 to 14 do
    begin
      if (i<>1)and(i<>14)then continue;

      case tip of
      0:begin  //line
          //2 etazh
            //air
            blocks[114+(7*128+(i*2048))]:=0;
            blocks[115+(7*128+(i*2048))]:=0;
            blocks[116+(7*128+(i*2048))]:=0;
            //single slab
            blocks[113+(7*128+(i*2048))]:=44;
            //double slab
            blocks[112+(7*128+(i*2048))]:=43;
            blocks[113+(6*128+(i*2048))]:=43;
            blocks[113+(8*128+(i*2048))]:=43;
            blocks[114+(6*128+(i*2048))]:=43;
            blocks[114+(8*128+(i*2048))]:=43;
            blocks[115+(6*128+(i*2048))]:=43;
            blocks[115+(8*128+(i*2048))]:=43;
            blocks[116+(6*128+(i*2048))]:=43;
            blocks[116+(8*128+(i*2048))]:=43;
            blocks[117+(7*128+(i*2048))]:=43;

            //air
            blocks[114+(i*128+(7*2048))]:=0;
            blocks[115+(i*128+(7*2048))]:=0;
            blocks[116+(i*128+(7*2048))]:=0;
            //single slab
            blocks[113+(i*128+(7*2048))]:=44;
            //double slab
            blocks[112+(i*128+(7*2048))]:=43;
            blocks[113+(i*128+(6*2048))]:=43;
            blocks[113+(i*128+(8*2048))]:=43;
            blocks[114+(i*128+(6*2048))]:=43;
            blocks[114+(i*128+(8*2048))]:=43;
            blocks[115+(i*128+(6*2048))]:=43;
            blocks[115+(i*128+(8*2048))]:=43;
            blocks[116+(i*128+(6*2048))]:=43;
            blocks[116+(i*128+(8*2048))]:=43;
            blocks[117+(i*128+(7*2048))]:=43;

          //0 i 1 etazhi
          if (((storona=1)or(storona=2))and(i=1))or
          (((storona=3)or(storona=4))and(i=14)) then
          begin
            //air
            blocks[104+(7*128+(i*2048))]:=0;
            blocks[105+(7*128+(i*2048))]:=0;
            blocks[106+(7*128+(i*2048))]:=0;
            //single slab
            blocks[103+(7*128+(i*2048))]:=44;
            //double slab
            blocks[102+(7*128+(i*2048))]:=43;
            blocks[103+(6*128+(i*2048))]:=43;
            blocks[103+(8*128+(i*2048))]:=43;
            blocks[104+(6*128+(i*2048))]:=43;
            blocks[104+(8*128+(i*2048))]:=43;
            blocks[105+(6*128+(i*2048))]:=43;
            blocks[105+(8*128+(i*2048))]:=43;
            blocks[106+(6*128+(i*2048))]:=43;
            blocks[106+(8*128+(i*2048))]:=43;
            blocks[107+(7*128+(i*2048))]:=43;

            //air
            blocks[93+(7*128+(i*2048))]:=0;
            blocks[94+(7*128+(i*2048))]:=0;
            blocks[95+(7*128+(i*2048))]:=0;
            //single slab
            blocks[92+(7*128+(i*2048))]:=44;
            //double slab
            blocks[91+(7*128+(i*2048))]:=43;
            blocks[92+(6*128+(i*2048))]:=43;
            blocks[92+(8*128+(i*2048))]:=43;
            blocks[93+(6*128+(i*2048))]:=43;
            blocks[93+(8*128+(i*2048))]:=43;
            blocks[94+(6*128+(i*2048))]:=43;
            blocks[94+(8*128+(i*2048))]:=43;
            blocks[95+(6*128+(i*2048))]:=43;
            blocks[95+(8*128+(i*2048))]:=43;
            blocks[96+(7*128+(i*2048))]:=43;
          end;
          if (((storona=1)or(storona=3))and(i=1))or
          (((storona=2)or(storona=4))and(i=14)) then
          begin
            //air
            blocks[104+(i*128+(7*2048))]:=0;
            blocks[105+(i*128+(7*2048))]:=0;
            blocks[106+(i*128+(7*2048))]:=0;
            //single slab
            blocks[103+(i*128+(7*2048))]:=44;
            //double slab
            blocks[102+(i*128+(7*2048))]:=43;
            blocks[103+(i*128+(6*2048))]:=43;
            blocks[103+(i*128+(8*2048))]:=43;
            blocks[104+(i*128+(6*2048))]:=43;
            blocks[104+(i*128+(8*2048))]:=43;
            blocks[105+(i*128+(6*2048))]:=43;
            blocks[105+(i*128+(8*2048))]:=43;
            blocks[106+(i*128+(6*2048))]:=43;
            blocks[106+(i*128+(8*2048))]:=43;
            blocks[107+(i*128+(7*2048))]:=43;

            //air
            blocks[93+(i*128+(7*2048))]:=0;
            blocks[94+(i*128+(7*2048))]:=0;
            blocks[95+(i*128+(7*2048))]:=0;
            //single slab
            blocks[92+(i*128+(7*2048))]:=44;
            //double slab
            blocks[91+(i*128+(7*2048))]:=43;
            blocks[92+(i*128+(6*2048))]:=43;
            blocks[92+(i*128+(8*2048))]:=43;
            blocks[93+(i*128+(6*2048))]:=43;
            blocks[93+(i*128+(8*2048))]:=43;
            blocks[94+(i*128+(6*2048))]:=43;
            blocks[94+(i*128+(8*2048))]:=43;
            blocks[95+(i*128+(6*2048))]:=43;
            blocks[95+(i*128+(8*2048))]:=43;
            blocks[96+(i*128+(7*2048))]:=43;
          end;
        end;
      1:begin  //cross
            //2 etazh
            //air
            blocks[114+(7*128+(i*2048))]:=0;
            blocks[115+(7*128+(i*2048))]:=0;
            blocks[116+(7*128+(i*2048))]:=0;
            //single slab
            blocks[113+(7*128+(i*2048))]:=44;
            blocks[115+(6*128+(i*2048))]:=44;
            blocks[115+(8*128+(i*2048))]:=44;
            //double slab
            blocks[112+(7*128+(i*2048))]:=43;
            blocks[113+(6*128+(i*2048))]:=43;
            blocks[113+(8*128+(i*2048))]:=43;
            blocks[114+(6*128+(i*2048))]:=43;
            blocks[114+(8*128+(i*2048))]:=43;
            blocks[115+(5*128+(i*2048))]:=43;
            blocks[115+(9*128+(i*2048))]:=43;
            blocks[116+(6*128+(i*2048))]:=43;
            blocks[116+(8*128+(i*2048))]:=43;
            blocks[117+(7*128+(i*2048))]:=43;

            //air
            blocks[114+(i*128+(7*2048))]:=0;
            blocks[115+(i*128+(7*2048))]:=0;
            blocks[116+(i*128+(7*2048))]:=0;
            //single slab
            blocks[113+(i*128+(7*2048))]:=44;
            blocks[115+(i*128+(6*2048))]:=44;
            blocks[115+(i*128+(8*2048))]:=44;
            //double slab
            blocks[112+(i*128+(7*2048))]:=43;
            blocks[113+(i*128+(6*2048))]:=43;
            blocks[113+(i*128+(8*2048))]:=43;
            blocks[114+(i*128+(6*2048))]:=43;
            blocks[114+(i*128+(8*2048))]:=43;
            blocks[115+(i*128+(5*2048))]:=43;
            blocks[115+(i*128+(9*2048))]:=43;
            blocks[116+(i*128+(6*2048))]:=43;
            blocks[116+(i*128+(8*2048))]:=43;
            blocks[117+(i*128+(7*2048))]:=43;

          //0 i 1 etazhi
          if (((storona=1)or(storona=2))and(i=1))or
          (((storona=3)or(storona=4))and(i=14)) then
          begin
            //air
            blocks[104+(7*128+(i*2048))]:=0;
            blocks[105+(7*128+(i*2048))]:=0;
            blocks[106+(7*128+(i*2048))]:=0;
            //single slab
            blocks[103+(7*128+(i*2048))]:=44;
            blocks[105+(6*128+(i*2048))]:=44;
            blocks[105+(8*128+(i*2048))]:=44;
            //double slab
            blocks[102+(7*128+(i*2048))]:=43;
            blocks[103+(6*128+(i*2048))]:=43;
            blocks[103+(8*128+(i*2048))]:=43;
            blocks[104+(6*128+(i*2048))]:=43;
            blocks[104+(8*128+(i*2048))]:=43;
            blocks[105+(5*128+(i*2048))]:=43;
            blocks[105+(9*128+(i*2048))]:=43;
            blocks[106+(6*128+(i*2048))]:=43;
            blocks[106+(8*128+(i*2048))]:=43;
            blocks[107+(7*128+(i*2048))]:=43;

            //air
            blocks[93+(7*128+(i*2048))]:=0;
            blocks[94+(7*128+(i*2048))]:=0;
            blocks[95+(7*128+(i*2048))]:=0;
            //single slab
            blocks[92+(7*128+(i*2048))]:=44;
            blocks[94+(6*128+(i*2048))]:=44;
            blocks[94+(8*128+(i*2048))]:=44;
            //double slab
            blocks[91+(7*128+(i*2048))]:=43;
            blocks[92+(6*128+(i*2048))]:=43;
            blocks[92+(8*128+(i*2048))]:=43;
            blocks[93+(6*128+(i*2048))]:=43;
            blocks[93+(8*128+(i*2048))]:=43;
            blocks[94+(5*128+(i*2048))]:=43;
            blocks[94+(9*128+(i*2048))]:=43;
            blocks[95+(6*128+(i*2048))]:=43;
            blocks[95+(8*128+(i*2048))]:=43;
            blocks[96+(7*128+(i*2048))]:=43;
          end;
          if (((storona=1)or(storona=3))and(i=1))or
          (((storona=2)or(storona=4))and(i=14)) then
          begin
            //air
            blocks[104+(i*128+(7*2048))]:=0;
            blocks[105+(i*128+(7*2048))]:=0;
            blocks[106+(i*128+(7*2048))]:=0;
            //single slab
            blocks[103+(i*128+(7*2048))]:=44;
            blocks[105+(i*128+(6*2048))]:=44;
            blocks[105+(i*128+(8*2048))]:=44;
            //double slab
            blocks[102+(i*128+(7*2048))]:=43;
            blocks[103+(i*128+(6*2048))]:=43;
            blocks[103+(i*128+(8*2048))]:=43;
            blocks[104+(i*128+(6*2048))]:=43;
            blocks[104+(i*128+(8*2048))]:=43;
            blocks[105+(i*128+(5*2048))]:=43;
            blocks[105+(i*128+(9*2048))]:=43;
            blocks[106+(i*128+(6*2048))]:=43;
            blocks[106+(i*128+(8*2048))]:=43;
            blocks[107+(i*128+(7*2048))]:=43;

            //air
            blocks[93+(i*128+(7*2048))]:=0;
            blocks[94+(i*128+(7*2048))]:=0;
            blocks[95+(i*128+(7*2048))]:=0;
            //single slab
            blocks[92+(i*128+(7*2048))]:=44;
            blocks[94+(i*128+(6*2048))]:=44;
            blocks[94+(i*128+(8*2048))]:=44;
            //double slab
            blocks[91+(i*128+(7*2048))]:=43;
            blocks[92+(i*128+(6*2048))]:=43;
            blocks[92+(i*128+(8*2048))]:=43;
            blocks[93+(i*128+(6*2048))]:=43;
            blocks[93+(i*128+(8*2048))]:=43;
            blocks[94+(i*128+(5*2048))]:=43;
            blocks[94+(i*128+(9*2048))]:=43;
            blocks[95+(i*128+(6*2048))]:=43;
            blocks[95+(i*128+(8*2048))]:=43;
            blocks[96+(i*128+(7*2048))]:=43;
          end;
        end;
      2:begin  //square
            //2 etazh
            //air
            blocks[114+(7*128+(i*2048))]:=0;
            blocks[114+(8*128+(i*2048))]:=0;
            //single slab
            blocks[113+(7*128+(i*2048))]:=44;
            blocks[113+(8*128+(i*2048))]:=44;
            //double slab
            blocks[112+(7*128+(i*2048))]:=43;
            blocks[112+(8*128+(i*2048))]:=43;
            blocks[113+(6*128+(i*2048))]:=43;
            blocks[113+(9*128+(i*2048))]:=43;
            blocks[114+(6*128+(i*2048))]:=43;
            blocks[114+(9*128+(i*2048))]:=43;
            blocks[115+(7*128+(i*2048))]:=43;
            blocks[115+(8*128+(i*2048))]:=43;

            //air
            blocks[114+(i*128+(7*2048))]:=0;
            blocks[114+(i*128+(8*2048))]:=0;
            //single slab
            blocks[113+(i*128+(7*2048))]:=44;
            blocks[113+(i*128+(8*2048))]:=44;
            //double slab
            blocks[112+(i*128+(7*2048))]:=43;
            blocks[112+(i*128+(8*2048))]:=43;
            blocks[113+(i*128+(6*2048))]:=43;
            blocks[113+(i*128+(9*2048))]:=43;
            blocks[114+(i*128+(6*2048))]:=43;
            blocks[114+(i*128+(9*2048))]:=43;
            blocks[115+(i*128+(7*2048))]:=43;
            blocks[115+(i*128+(8*2048))]:=43;

          //0 i 1 etazhi
          if (((storona=1)or(storona=2))and(i=1))or
          (((storona=3)or(storona=4))and(i=14)) then
          begin
            //air
            blocks[104+(7*128+(i*2048))]:=0;
            blocks[104+(8*128+(i*2048))]:=0;
            //single slab
            blocks[103+(7*128+(i*2048))]:=44;
            blocks[103+(8*128+(i*2048))]:=44;
            //double slab
            blocks[102+(7*128+(i*2048))]:=43;
            blocks[102+(8*128+(i*2048))]:=43;
            blocks[103+(6*128+(i*2048))]:=43;
            blocks[103+(9*128+(i*2048))]:=43;
            blocks[104+(6*128+(i*2048))]:=43;
            blocks[104+(9*128+(i*2048))]:=43;
            blocks[105+(7*128+(i*2048))]:=43;
            blocks[105+(8*128+(i*2048))]:=43;

            //air
            blocks[94+(7*128+(i*2048))]:=0;
            blocks[94+(8*128+(i*2048))]:=0;
            //single slab
            blocks[93+(7*128+(i*2048))]:=44;
            blocks[93+(8*128+(i*2048))]:=44;
            //double slab
            blocks[92+(7*128+(i*2048))]:=43;
            blocks[92+(8*128+(i*2048))]:=43;
            blocks[93+(6*128+(i*2048))]:=43;
            blocks[93+(9*128+(i*2048))]:=43;
            blocks[94+(6*128+(i*2048))]:=43;
            blocks[94+(9*128+(i*2048))]:=43;
            blocks[95+(7*128+(i*2048))]:=43;
            blocks[95+(8*128+(i*2048))]:=43;
          end;
          if (((storona=1)or(storona=3))and(i=1))or
          (((storona=2)or(storona=4))and(i=14)) then
          begin
            //air
            blocks[104+(i*128+(7*2048))]:=0;
            blocks[104+(i*128+(8*2048))]:=0;
            //single slab
            blocks[103+(i*128+(7*2048))]:=44;
            blocks[103+(i*128+(8*2048))]:=44;
            //double slab
            blocks[102+(i*128+(7*2048))]:=43;
            blocks[102+(i*128+(8*2048))]:=43;
            blocks[103+(i*128+(6*2048))]:=43;
            blocks[103+(i*128+(9*2048))]:=43;
            blocks[104+(i*128+(6*2048))]:=43;
            blocks[104+(i*128+(9*2048))]:=43;
            blocks[105+(i*128+(7*2048))]:=43;
            blocks[105+(i*128+(8*2048))]:=43;

            //air
            blocks[94+(i*128+(7*2048))]:=0;
            blocks[94+(i*128+(8*2048))]:=0;
            //single slab
            blocks[93+(i*128+(7*2048))]:=44;
            blocks[93+(i*128+(8*2048))]:=44;
            //double slab
            blocks[92+(i*128+(7*2048))]:=43;
            blocks[92+(i*128+(8*2048))]:=43;
            blocks[93+(i*128+(6*2048))]:=43;
            blocks[93+(i*128+(9*2048))]:=43;
            blocks[94+(i*128+(6*2048))]:=43;
            blocks[94+(i*128+(9*2048))]:=43;
            blocks[95+(i*128+(7*2048))]:=43;
            blocks[95+(i*128+(8*2048))]:=43;
          end;
        end;
      end;
    end;
end;

end.

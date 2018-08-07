unit generation_tunnel;

interface

function gen_tunnels_thread(Parameter:pointer):integer;

implementation

uses generation_obsh, NBT, generation_spec, windows, math, RandomMCT, zlibex, sysutils;

function tunnel_angle(ar_tun:array of tunnels_settings; i1,i2:integer):double;
var d:extended;
x1,y1,z1,x2,y2,z2,x3,y3,z3,x4,y4,z4:integer;
begin
  {x1:=ar_tun[i1].x2;
  y1:=ar_tun[i1].y2;
  z1:=ar_tun[i1].z2;
  x3:=x1;
  y3:=y1;
  z3:=z1;
  x2:=ar_tun[i1].x1;
  y2:=ar_tun[i1].y1;
  z2:=ar_tun[i1].z1;

  x4:=ar_tun[i2].x2;
  y4:=ar_tun[i2].y2;
  z4:=ar_tun[i2].z2;  }
  
  x1:=ar_tun[i1].x1;
  y1:=ar_tun[i1].y1;
  z1:=ar_tun[i1].z1;
  x2:=ar_tun[i1].x2;
  y2:=ar_tun[i1].y2;
  z2:=ar_tun[i1].z2;
  x3:=ar_tun[i2].x1;
  y3:=ar_tun[i2].y1;
  z3:=ar_tun[i2].z1;
  x4:=ar_tun[i2].x2;
  y4:=ar_tun[i2].y2;
  z4:=ar_tun[i2].z2;

  d:=(x2-x1)*(x4-x3)+(y2-y1)*(y4-y3)+(z2-z1)*(z4-z3);
  d:=d/(sqrt(sqr(x2-x1)+sqr(y2-y1)+sqr(z2-z1))*sqrt(sqr(x4-x3)+sqr(y4-y3)+sqr(z4-z3)));
  if d>=1 then d:=d-0.0000000001;
  if d<=-1 then d:=d+0.0000000001;
  d:=arccos(d);
  d:=radtodeg(d);
  result:=d;
end;

function tunnel_intersection2(ar_tun:array of tunnels_settings; indeks:integer; iskl:array of integer):boolean;
var b_ind,b_var:boolean;
fromind,toind,fromvar,tovar:integer;
d,x1,y1,z1,x2,y2,z2:extended;
i,j,k:integer;
begin
  if length(ar_tun)<=2 then
  begin
    result:=false;
    exit;
  end;

  //opredelenie granis i osi po indeksu
  if abs(ar_tun[indeks].x1-ar_tun[indeks].x2)<abs(ar_tun[indeks].z1-ar_tun[indeks].z2) then
  begin
    b_ind:=true;
    fromind:=min(ar_tun[indeks].z1,ar_tun[indeks].z2);
    toind:=max(ar_tun[indeks].z1,ar_tun[indeks].z2);
  end
  else
  begin
    b_ind:=false;
    fromind:=min(ar_tun[indeks].x1,ar_tun[indeks].x2);
    toind:=max(ar_tun[indeks].x1,ar_tun[indeks].x2);
  end;

  for i:=0 to length(ar_tun)-1 do
  begin
    //opredelaem isklucheniya
    b_var:=false;
    for j:=0 to length(iskl)-1 do
      if iskl[j]=i then b_var:=true;

    if (b_var=true)or(i=indeks) then continue;

    //opredelenie granic i osi po i-tomu tunelu
    if abs(ar_tun[i].x1-ar_tun[i].x2)<abs(ar_tun[i].z1-ar_tun[i].z2) then
    begin
      b_var:=true;
      fromvar:=min(ar_tun[i].z1,ar_tun[i].z2);
      tovar:=max(ar_tun[i].z1,ar_tun[i].z2);
    end
    else
    begin
      b_var:=false;
      fromvar:=min(ar_tun[i].x1,ar_tun[i].x2);
      tovar:=max(ar_tun[i].x1,ar_tun[i].x2);
    end;

    for j:=fromind to toind do
      for k:=fromvar to tovar do
      begin
        //schitaem koordinati pervoy tochki, kotoraya otnositsa k indeksu
        if b_ind=true then
        begin
          z1:=j;
          x1:=ar_tun[indeks].x1+(ar_tun[indeks].x2-ar_tun[indeks].x1)*((z1-ar_tun[indeks].z1)/(ar_tun[indeks].z2-ar_tun[indeks].z1));
          y1:=ar_tun[indeks].y1+(ar_tun[indeks].y2-ar_tun[indeks].y1)*((z1-ar_tun[indeks].z1)/(ar_tun[indeks].z2-ar_tun[indeks].z1));
        end
        else
        begin
          x1:=j;
          y1:=ar_tun[indeks].y1+(ar_tun[indeks].y2-ar_tun[indeks].y1)*((x1-ar_tun[indeks].x1)/(ar_tun[indeks].x2-ar_tun[indeks].x1));
          z1:=ar_tun[indeks].z1+(ar_tun[indeks].z2-ar_tun[indeks].z1)*((x1-ar_tun[indeks].x1)/(ar_tun[indeks].x2-ar_tun[indeks].x1));
        end;

        //schitaem koordinati vtoroy tochki, kotoraya otnositsa k i
        if b_var=true then
        begin
          z2:=k;
          x2:=ar_tun[i].x1+(ar_tun[i].x2-ar_tun[i].x1)*((z2-ar_tun[i].z1)/(ar_tun[i].z2-ar_tun[i].z1));
          y2:=ar_tun[i].y1+(ar_tun[i].y2-ar_tun[i].y1)*((z2-ar_tun[i].z1)/(ar_tun[i].z2-ar_tun[i].z1));
        end
        else
        begin
          x2:=k;
          y2:=ar_tun[i].y1+(ar_tun[i].y2-ar_tun[i].y1)*((x2-ar_tun[i].x1)/(ar_tun[i].x2-ar_tun[i].x1));
          z2:=ar_tun[i].z1+(ar_tun[i].z2-ar_tun[i].z1)*((x2-ar_tun[i].x1)/(ar_tun[i].x2-ar_tun[i].x1));
        end;

        //vichislaem rasstoyanie
          d:=sqrt(sqr(x2-x1)+sqr(y2-y1)+sqr(z2-z1));
          if d<(max(ar_tun[i].radius_horiz,ar_tun[i].radius_vert)+max(ar_tun[indeks].radius_horiz,ar_tun[indeks].radius_vert)+15) then
          begin
            result:=true;
            exit;
          end;
      end;
  end;
  result:=false;
end;

function tunnel_length(ar_tun:array of tunnels_settings; i1:integer):double;
begin
  result:=sqrt(sqr(ar_tun[i1].x2-ar_tun[i1].x1)+sqr(ar_tun[i1].y2-ar_tun[i1].y1)+sqr(ar_tun[i1].z2-ar_tun[i1].z1));
end;

function tunnel_flat_angle(ar_tun:array of tunnels_settings; i1:integer):double;
var d:extended;
x1,y1,z1,x2,y2,z2,x3,y3,z3,x4,y4,z4:integer;
begin
  x1:=ar_tun[i1].x2;
  y1:=ar_tun[i1].y2;
  z1:=ar_tun[i1].z2;
  x3:=x1;
  y3:=y1;
  z3:=z1;
  x2:=ar_tun[i1].x1;
  y2:=ar_tun[i1].y1;
  z2:=ar_tun[i1].z1;

  x4:=ar_tun[i1].x1;
  y4:=y3;
  z4:=ar_tun[i1].z1;

  d:=(x2-x1)*(x4-x3)+(y2-y1)*(y4-y3)+(z2-z1)*(z4-z3);
  d:=d/(sqrt(sqr(x2-x1)+sqr(y2-y1)+sqr(z2-z1))*sqrt(sqr(x4-x3)+sqr(y4-y3)+sqr(z4-z3)));
  d:=arccos(d);
  d:=radtodeg(d);
  result:=d;
end;

function tunnel_intersection(ar_tun:array of tunnels_settings; indeks:integer; iskl:array of integer):boolean;
var i,j,k:integer;
b:boolean;
d,x1,y1,z1,x2,y2,z2:double;
fromk,tok:integer;
fromki,toki:integer;
begin
  if length(ar_tun)<=2 then
  begin
    result:=false;
    exit;
  end;

  if ar_tun[indeks].x1<ar_tun[indeks].x2 then
  begin
    fromki:=ar_tun[indeks].x1;
    toki:=ar_tun[indeks].x2;
  end
  else
  begin
    fromki:=ar_tun[indeks].x2;
    toki:=ar_tun[indeks].x1;
  end;

  for i:=0 to length(ar_tun)-1 do
  begin
    b:=false;
    for j:=0 to length(iskl)-1 do
      if iskl[j]=i then
      begin
        b:=true;
        break;
      end;
    if i=indeks then b:=true;

    if b=true then continue;

    b:=false;  //po X
    if abs(ar_tun[i].x2-ar_tun[i].x1)<abs(ar_tun[i].z2-ar_tun[i].z1) then b:=true;


    if b=false then //po X
    begin
      if ar_tun[i].x1<ar_tun[i].x2 then
      begin
        fromk:=ar_tun[i].x1;
        tok:=ar_tun[i].x2;
      end
      else
      begin
        fromk:=ar_tun[i].x2;
        tok:=ar_tun[i].x1;
      end;

      for j:=fromk to tok do
        for k:=fromki to toki do
        begin
          //vichislaem ostal'nie koordinati
          x1:=j;
          x2:=k;
          y1:=(ar_tun[i].y2-ar_tun[i].y1)*(((j-ar_tun[i].x1)/(ar_tun[i].x2-ar_tun[i].x1))+(ar_tun[i].y1/(ar_tun[i].y2-ar_tun[i].y1)));
          z1:=(ar_tun[i].z2-ar_tun[i].z1)*(((j-ar_tun[i].x1)/(ar_tun[i].x2-ar_tun[i].x1))+(ar_tun[i].z1/(ar_tun[i].z2-ar_tun[i].z1)));
          y2:=(ar_tun[indeks].y2-ar_tun[indeks].y1)*(((k-ar_tun[indeks].x1)/(ar_tun[indeks].x2-ar_tun[indeks].x1))+(ar_tun[indeks].y1/(ar_tun[indeks].y2-ar_tun[indeks].y1)));
          z2:=(ar_tun[indeks].z2-ar_tun[indeks].z1)*(((k-ar_tun[indeks].x1)/(ar_tun[indeks].x2-ar_tun[indeks].x1))+(ar_tun[indeks].z1/(ar_tun[indeks].z2-ar_tun[indeks].z1)));
          //vichislaem rasstoyanie
          d:=sqrt(sqr(x2-x1)+sqr(y2-y1)+sqr(z2-z1));
          if d<(ar_tun[i].radius_horiz+ar_tun[indeks].radius_horiz+5) then
          begin
            result:=true;
            exit;
          end;
        end;
    end
    else  //po Z
    begin
      if ar_tun[i].z1<ar_tun[i].z2 then
      begin
        fromk:=ar_tun[i].z1;
        tok:=ar_tun[i].z2;
      end
      else
      begin
        fromk:=ar_tun[i].z2;
        tok:=ar_tun[i].z1;
      end;

      for j:=fromk to tok do
        for k:=fromki to toki do
        begin
          //vichislaem ostal'nie koordinati
          z1:=j;
          x2:=k;
          y1:=(ar_tun[i].y2-ar_tun[i].y1)*(((j-ar_tun[i].z1)/(ar_tun[i].z2-ar_tun[i].z1))+(ar_tun[i].y1/(ar_tun[i].y2-ar_tun[i].y1)));
          x1:=(ar_tun[i].x2-ar_tun[i].x1)*(((j-ar_tun[i].z1)/(ar_tun[i].z2-ar_tun[i].z1))+(ar_tun[i].x1/(ar_tun[i].x2-ar_tun[i].x1)));

          y2:=(ar_tun[indeks].y2-ar_tun[indeks].y1)*(((k-ar_tun[indeks].x1)/(ar_tun[indeks].x2-ar_tun[indeks].x1))+(ar_tun[indeks].y1/(ar_tun[indeks].y2-ar_tun[indeks].y1)));
          z2:=(ar_tun[indeks].z2-ar_tun[indeks].z1)*(((k-ar_tun[indeks].x1)/(ar_tun[indeks].x2-ar_tun[indeks].x1))+(ar_tun[indeks].z1/(ar_tun[indeks].z2-ar_tun[indeks].z1)));
          //vichislaem rasstoyanie
          d:=sqrt(sqr(x2-x1)+sqr(y2-y1)+sqr(z2-z1));
          if d<(ar_tun[i].radius_horiz+ar_tun[indeks].radius_horiz+5) then
          begin
            result:=true;
            exit;
          end;
        end;
    end
  end;
  result:=false;
end;

procedure gen_tun_holes(map:region; xreg,yreg:integer; pr_koord:ar_tprostr_koord);
var tempxot,tempyot,tempxdo,tempydo:integer;
chx,chy:integer;
i,j,k:integer;
x,y,z,t:integer;
b:boolean;
begin
  //schitaem koordinati nachalnih i konechnih chankov v regione
  if xreg<0 then
  begin
    tempxot:=(xreg+1)*32-32;
    tempxdo:=(xreg+1)*32+3;
  end
  else
  begin
    tempxot:=xreg*32;
    tempxdo:=(xreg*32)+35;
  end;

  if yreg<0 then
  begin
    tempyot:=(yreg+1)*32-32;
    tempydo:=(yreg+1)*32+3;
  end
  else
  begin
    tempyot:=yreg*32;
    tempydo:=(yreg*32)+35;
  end;

  dec(tempxot,2);
  dec(tempxdo,2);
  dec(tempyot,2);
  dec(tempydo,2);

  for i:=0 to length(pr_koord)-1 do
  begin
    if pr_koord[i].z=1000 then continue;

    if (pr_koord[i].x<(xreg*512-10))or(pr_koord[i].x>(xreg*512+522))or
    (pr_koord[i].y<(yreg*512-10))or(pr_koord[i].y>(yreg*512+522)) then continue;

    //proveraem, umeshaetsa li lovushka
    b:=true;
    for j:=pr_koord[i].x-3 to pr_koord[i].x+3 do
      for k:=pr_koord[i].y-3 to pr_koord[i].y+3 do
      begin
        if b=false then break;
        //opredelaem, k kakomu chanku otnositsa
        chx:=j;
        chy:=k;
        if chx<0 then inc(chx);
        if chy<0 then inc(chy);
        chx:=chx div 16;
        chy:=chy div 16;
        if (chx<=0)and(j<0) then dec(chx);
        if (chy<=0)and(k<0) then dec(chy);

        //uslovie
        if (chx>=tempxot)and(chx<=tempxdo)and(chy>=tempyot)and(chy<=tempydo) then
        begin
          //perevodim v koordinati chanka
          x:=j mod 16;
          z:=k mod 16;
          if x<0 then inc(x,16);
          if z<0 then inc(z,16);
          chx:=chx-tempxot;
          chy:=chy-tempyot;

          for y:=127 downto 119 do
          begin
            t:=map[chx][chy].blocks[y+(z*128+(x*2048))];
            if (t<>1)and(t<>7)and(t<>10)and(t<>20) then
            begin
              b:=false;
              break;
            end;
          end;
        end;
      end;

    if b=false then
    begin
      pr_koord[i].z:=1000;
      continue;
    end;


    (*for j:=pr_koord[i].x-3 to pr_koord[i].x+3 do
      for k:=pr_koord[i].y-3 to pr_koord[i].y+3 do
        if (j=pr_koord[i].x)and(k=pr_koord[i].y) then
        begin
          chx:=j;
          chy:=k;
          if chx<0 then inc(chx);
          if chy<0 then inc(chy);
          chx:=chx div 16;
          chy:=chy div 16;
          if (chx<=0)and(j<0) then dec(chx);
          if (chy<=0)and(k<0) then dec(chy);

          //uslovie
          if (chx>=tempxot)and(chx<=tempxdo)and(chy>=tempyot)and(chy<=tempydo) then
          begin
            //perevodim v koordinati chanka
            x:=j mod 16;
            z:=k mod 16;
            if x<0 then inc(x,16);
            if z<0 then inc(z,16);
            chx:=chx-tempxot;
            chy:=chy-tempyot;

            for y:=127 downto 123 do
              map[chx][chy].blocks[y+(z*128+(x*2048))]:=0;

            //map[chx][chy].blocks[121+(z*128+(x*2048))]:=1;
            y:=122;
            b:=true;
            while b=true do
            begin
              t:=map[chx][chy].blocks[y+(z*128+(x*2048))];
              if (t<>1)or(y=0) then b:=false
              else
                map[chx][chy].blocks[y+(z*128+(x*2048))]:=20;
              dec(y);
            end;

            inc(y);
            b:=true;
            while b=true do
            begin
              t:=map[chx][chy].blocks[y+(z*128+(x*2048))];
              if (t=1)or(y=0) then b:=false
              else
                map[chx][chy].blocks[y+(z*128+(x*2048))]:=0;
              dec(y);
            end;

            map[chx][chy].blocks[120+(z*128+(x*2048))]:=76;
            map[chx][chy].data[120+(z*128+(x*2048))]:=5;

          end;
        end
        else
        begin
          //opredelaem, k kakomu chanku otnositsa
          chx:=j;
          chy:=k;
          if chx<0 then inc(chx);
          if chy<0 then inc(chy);
          chx:=chx div 16;
          chy:=chy div 16;
          if (chx<=0)and(j<0) then dec(chx);
          if (chy<=0)and(k<0) then dec(chy);

          //uslovie
          if (chx>=tempxot)and(chx<=tempxdo)and(chy>=tempyot)and(chy<=tempydo) then
          begin
            //perevodim v koordinati chanka
            x:=j mod 16;
            z:=k mod 16;
            if x<0 then inc(x,16);
            if z<0 then inc(z,16);
            chx:=chx-tempxot;
            chy:=chy-tempyot;

            if (j=pr_koord[i].x-3)or(j=pr_koord[i].x+3)or
            (k=pr_koord[i].y-3)or(k=pr_koord[i].y+3) then
            begin
              for y:=127 downto 120 do
                map[chx][chy].blocks[y+(z*128+(x*2048))]:=7;
            end
            else if (j=pr_koord[i].x)and(k=pr_koord[i].y+1) then
            begin
              //redstone
              map[chx][chy].blocks[120+(z*128+(x*2048))]:=55;
              map[chx][chy].data[120+(z*128+(x*2048))]:=15;
              //bedrock
              map[chx][chy].blocks[121+(z*128+(x*2048))]:=7;
              //lava
              map[chx][chy].blocks[122+(z*128+(x*2048))]:=10;
              //air
              for y:=123 to 126 do
                map[chx][chy].blocks[y+(z*128+(x*2048))]:=0;
              //TNT
              map[chx][chy].blocks[127+(z*128+(x*2048))]:=46;
            end
            else if (j=pr_koord[i].x)and(k=pr_koord[i].y+2) then
            begin
              //stone
              map[chx][chy].blocks[120+(z*128+(x*2048))]:=1;
              map[chx][chy].blocks[122+(z*128+(x*2048))]:=1;
              map[chx][chy].blocks[124+(z*128+(x*2048))]:=1;
              //redstone torch
              map[chx][chy].blocks[121+(z*128+(x*2048))]:=75;
              map[chx][chy].data[121+(z*128+(x*2048))]:=5;
              map[chx][chy].blocks[123+(z*128+(x*2048))]:=76;
              map[chx][chy].data[123+(z*128+(x*2048))]:=5;
              map[chx][chy].blocks[127+(z*128+(x*2048))]:=75;
              map[chx][chy].data[127+(z*128+(x*2048))]:=2;
              //air
              for y:=125 to 126 do
                map[chx][chy].blocks[y+(z*128+(x*2048))]:=0;
            end
            else if (j=pr_koord[i].x+1)and(k=pr_koord[i].y+2) then
            begin
              //redstone torch
              map[chx][chy].blocks[124+(z*128+(x*2048))]:=75;
              map[chx][chy].data[124+(z*128+(x*2048))]:=1;
              map[chx][chy].blocks[126+(z*128+(x*2048))]:=76;
              map[chx][chy].data[126+(z*128+(x*2048))]:=5;
              //stone
              map[chx][chy].blocks[125+(z*128+(x*2048))]:=1;
              //map[chx][chy].blocks[127+(z*128+(x*2048))]:=7;
              //lava
              for y:=122 to 122 do
                map[chx][chy].blocks[y+(z*128+(x*2048))]:=10;
              //glass
              map[chx][chy].blocks[120+(z*128+(x*2048))]:=20;
              map[chx][chy].blocks[121+(z*128+(x*2048))]:=20;
              //air
              map[chx][chy].blocks[123+(z*128+(x*2048))]:=0;
            end
            else if ((j=pr_koord[i].x+1)or((j=pr_koord[i].x-1)))and(k=pr_koord[i].y+1) then
            begin
              //glass
              map[chx][chy].blocks[120+(z*128+(x*2048))]:=20;
              //lava
              map[chx][chy].blocks[121+(z*128+(x*2048))]:=10;
              map[chx][chy].blocks[122+(z*128+(x*2048))]:=10;
              //air
              for y:=123 to 126 do
                map[chx][chy].blocks[y+(z*128+(x*2048))]:=0;
              //bedrock
              map[chx][chy].blocks[127+(z*128+(x*2048))]:=7;
            end
            else if ((j=pr_koord[i].x+1)and(k=pr_koord[i].y))or
            ((j=pr_koord[i].x-1)and(k=pr_koord[i].y))or
            ((j=pr_koord[i].x)and(k=pr_koord[i].y-1)) then
            begin
              //bedrock
              map[chx][chy].blocks[120+(z*128+(x*2048))]:=7;
              map[chx][chy].blocks[127+(z*128+(x*2048))]:=7;
              //lava
              map[chx][chy].blocks[121+(z*128+(x*2048))]:=10;
              map[chx][chy].blocks[122+(z*128+(x*2048))]:=10;
              //air
              for y:=123 to 126 do
                map[chx][chy].blocks[y+(z*128+(x*2048))]:=0;
            end
            else if (j=pr_koord[i].x-1)and(k=pr_koord[i].y+2) then
            begin
              //glass
              map[chx][chy].blocks[120+(z*128+(x*2048))]:=20;
              map[chx][chy].blocks[121+(z*128+(x*2048))]:=20;
              //lava
              map[chx][chy].blocks[122+(z*128+(x*2048))]:=10;
              //air
              for y:=123 to 126 do
                map[chx][chy].blocks[y+(z*128+(x*2048))]:=0;
              //bedrock
              map[chx][chy].blocks[127+(z*128+(x*2048))]:=7;
            end
            else
            begin
              //air
              for y:=123 to 126 do
                map[chx][chy].blocks[y+(z*128+(x*2048))]:=0;
              //lava
              map[chx][chy].blocks[121+(z*128+(x*2048))]:=10;
              map[chx][chy].blocks[122+(z*128+(x*2048))]:=10;
              //bedrock
              map[chx][chy].blocks[120+(z*128+(x*2048))]:=7;
             // map[chx][chy].blocks[127+(z*128+(x*2048))]:=7;
            end;
            {else
              for y:=120 to 126 do
                map[chx][chy].blocks[y+(z*128+(x*2048))]:=0;   }

            y:=119;
            map[chx][chy].blocks[y+(z*128+(x*2048))]:=7;
          end;
        end;   *)


    for j:=pr_koord[i].x-6 to pr_koord[i].x+6 do
      for k:=pr_koord[i].y-6 to pr_koord[i].y+6 do
        if (j=pr_koord[i].x)and(k=pr_koord[i].y) then
        begin
          //opredelaem, k kakomu chanku otnositsa
          chx:=j;
          chy:=k;
          if chx<0 then inc(chx);
          if chy<0 then inc(chy);
          chx:=chx div 16;
          chy:=chy div 16;
          if (chx<=0)and(j<0) then dec(chx);
          if (chy<=0)and(k<0) then dec(chy);

          //uslovie
          if (chx>=tempxot)and(chx<=tempxdo)and(chy>=tempyot)and(chy<=tempydo) then
          begin
            //perevodim v koordinati chanka
            x:=j mod 16;
            z:=k mod 16;
            if x<0 then inc(x,16);
            if z<0 then inc(z,16);
            chx:=chx-tempxot;
            chy:=chy-tempyot;

            y:=127;
            map[chx][chy].blocks[y+(z*128+(x*2048))]:=1;
            b:=true;
            while b=true do
            begin
              t:=map[chx][chy].blocks[y+(z*128+(x*2048))];
              if (t<>1)or(y=0) then b:=false
              else
                map[chx][chy].blocks[y+(z*128+(x*2048))]:=20;
              dec(y);
            end;

            inc(y);
            b:=true;
            while b=true do
            begin
              t:=map[chx][chy].blocks[y+(z*128+(x*2048))];
              //if (t=1)or(t=8)or(t=9)or(t=12)or(t=2)or(t=3)or(t=13)or(t=78)or(t=17)or(t=18)or(t=31)or(y=0) then b:=false
              if (t in trans_bl)or(y=0) then b:=false
              else
                map[chx][chy].blocks[y+(z*128+(x*2048))]:=0;
              dec(y);
            end;
          end;
        end
        else
        begin
          //opredelaem, k kakomu chanku otnositsa
          chx:=j;
          chy:=k;
          if chx<0 then inc(chx);
          if chy<0 then inc(chy);
          chx:=chx div 16;
          chy:=chy div 16;
          if (chx<=0)and(j<0) then dec(chx);
          if (chy<=0)and(k<0) then dec(chy);

          //uslovie
          if (chx>=tempxot)and(chx<=tempxdo)and(chy>=tempyot)and(chy<=tempydo) then
          begin
            //perevodim v koordinati chanka
            x:=j mod 16;
            z:=k mod 16;
            if x<0 then inc(x,16);
            if z<0 then inc(z,16);
            chx:=chx-tempxot;
            chy:=chy-tempyot;

            if (j=pr_koord[i].x-6)or(j=pr_koord[i].x+6)or
            (k=pr_koord[i].y-6)or(k=pr_koord[i].y+6) then t:=7
            else t:=11;

            if map[chx][chy].blocks[127+(z*128+(x*2048))]=11 then t:=11;

            for y:=127 downto 123 do
              map[chx][chy].blocks[y+(z*128+(x*2048))]:=t;
            y:=122;
            map[chx][chy].blocks[y+(z*128+(x*2048))]:=7; 
          end;
        end;
  end;
end;

procedure gen_tun_lights(map:region; xreg,yreg:integer; pr_koord:ar_tlights_koord);
var rx,ry,i:integer;
tempxot,tempyot,tempxdo,tempydo:integer;
chx,chy:integer;
x,y,z,t,id:integer;
x1,y1,z1:integer;
vih:boolean;
begin
  //schitaem koordinati nachalnih i konechnih chankov v regione
  if xreg<0 then
  begin
    tempxot:=(xreg+1)*32-32;
    tempxdo:=(xreg+1)*32+3;
  end
  else
  begin
    tempxot:=xreg*32;
    tempxdo:=(xreg*32)+35;
  end;

  if yreg<0 then
  begin
    tempyot:=(yreg+1)*32-32;
    tempydo:=(yreg+1)*32+3;
  end
  else
  begin
    tempyot:=yreg*32;
    tempydo:=(yreg*32)+35;
  end;

  dec(tempxot,2);
  dec(tempxdo,2);
  dec(tempyot,2);
  dec(tempydo,2);

  {inc(tempxot);
  inc(tempyot);
  dec(tempxdo);
  dec(tempydo); }

  for i:=0 to length(pr_koord)-1 do
  begin
    //opredelaem, k kakomu chanku otnositsa
    chx:=pr_koord[i].x;
    chy:=pr_koord[i].z;

    if chx<0 then inc(chx);
    if chy<0 then inc(chy);

    chx:=chx div 16;
    chy:=chy div 16;

    if (chx<=0)and(pr_koord[i].x<0) then dec(chx);
    if (chy<=0)and(pr_koord[i].z<0) then dec(chy);

    //uslovie
    if (chx>=tempxot)and(chx<=tempxdo)and(chy>=tempyot)and(chy<=tempydo) then
    begin
      //proverka na pravilnoe raspolozhenie istochnikov
      vih:=false;
      x:=pr_koord[i].x;
      y:=pr_koord[i].y;
      z:=pr_koord[i].z;
      id:=pr_koord[i].id;

      //po x
      t:=get_block_id(map,xreg,yreg,x-1,y,z);
      if (t<>0)and(t<>17)and(t<>18)and(t<>20)and
      (t<>31)and(t<>8)and(t<>9)and
      (t<>39)and(t<>40)and(t<>13)and(t<>79)and(t<>78) then
      begin
        if t=id then continue;
        vih:=true;
      end;
      t:=get_block_id(map,xreg,yreg,x+1,y,z);
      if (t<>0)and(t<>17)and(t<>18)and(t<>20)and
      (t<>31)and(t<>8)and(t<>9)and
      (t<>39)and(t<>40)and(t<>13)and(t<>79)and(t<>78) then
      begin
        if t=id then continue;
        vih:=true;
      end;
      //po y
      t:=get_block_id(map,xreg,yreg,x,y-1,z);
      if (t<>0)and(t<>17)and(t<>18)and(t<>20)and
      (t<>31)and(t<>8)and(t<>9)and
      (t<>39)and(t<>40)and(t<>13)and(t<>79)and(t<>78) then
      begin
        if t=id then continue;
        vih:=true;
      end;
      t:=get_block_id(map,xreg,yreg,x,y+1,z);
      if (t<>0)and(t<>17)and(t<>18)and(t<>20)and
      (t<>31)and(t<>8)and(t<>9)and
      (t<>39)and(t<>40)and(t<>13)and(t<>79)and(t<>78) then
      begin
        if t=id then continue;
        vih:=true;
      end;
      //po z
      t:=get_block_id(map,xreg,yreg,x,y,z-1);
      if (t<>0)and(t<>17)and(t<>18)and(t<>20)and
      (t<>31)and(t<>8)and(t<>9)and
      (t<>39)and(t<>40)and(t<>13)and(t<>79)and(t<>78) then
      begin
        if t=id then continue;
        vih:=true;
      end;
      t:=get_block_id(map,xreg,yreg,x,y,z+1);
      if (t<>0)and(t<>17)and(t<>18)and(t<>20)and
      (t<>31)and(t<>8)and(t<>9)and
      (t<>39)and(t<>40)and(t<>13)and(t<>79)and(t<>78) then
      begin
        if t=id then continue;
        vih:=true;
      end;

      if vih=true then
      for x1:=x-1 to x+1 do
        for y1:=y-1 to y+1 do
          for z1:=z-1 to z+1 do
          begin
            t:=get_block_id(map,xreg,yreg,x1,y1,z1);
            if (t=id) then vih:=false;
            if (t=81)and((x1=x)or(z1=z))and(y1=y) then vih:=false;
          end;

      if vih=true then
      begin
        //perevodim v koordinati chanka
        x:=pr_koord[i].x mod 16;
        z:=pr_koord[i].z mod 16;
        if x<0 then inc(x,16);
        if z<0 then inc(z,16);
        y:=pr_koord[i].y;

        //perevodim koordinati chanka v koordinati otnositelno regiona
        chx:=chx-tempxot;
        chy:=chy-tempyot;

        t:=map[chx][chy].blocks[y+(z*128+(x*2048))];
        if (t=0)or(t=8)or(t=9) then
        //if t=1 then
          map[chx][chy].blocks[y+(z*128+(x*2048))]:=id;
      end;  
    end;
  end;


  (*
  for rx:=0 to 35 do
    for ry:=0 to 35 do
    begin
      if xreg<0 then tempx:=((xreg+1)*32-(32-rx))
      else tempx:=(xreg*32)+rx;

      if yreg<0 then  tempy:=((yreg*32)+ry)
      else tempy:=(yreg+1)*32-(32-ry);

      dec(tempx,2);
      dec(tempy,2);

      otx:=tempx*16;
      oty:=tempy*16;
      dox:=otx+15;
      doy:=oty+15;

      for i:=0 to length(pr_koord)-1 do
      begin
        if (pr_koord[i].x>otx)and(pr_koord[i].x<dox)and
        (pr_koord[i].z>oty)and(pr_koord[i].z<doy) then
        begin
          {x:=(pr_koord[i].x div 16);
          z:=(pr_koord[i].z div 16);
          if x<0 then dec(x);
          if z<0 then dec(z);
          x:=x+(pr_koord[i].x mod 16);
          z:=z+(pr_koord[i].z mod 16); }
          x:=pr_koord[i].x mod 16;
          z:=pr_koord[i].z mod 16;
          if x<0 then inc(x,16);
          if z<0 then inc(z,16);
          y:=pr_koord[i].y;
          map[rx][ry].blocks[y+(z*128+(x*2048))]:=89;
        end;
      end;
    end;  *)
end;

procedure calc_tun_dirt(var map:region; xreg,yreg:integer;var pr_dirt:ar_elipse_settings; sid:int64);
var i,j,z1:integer;
xxr,yyr,zzr,xx,yy,zz,count:integer;
x,y,z:integer;
tempx,tempy,tempk,tempz:integer;
r:rnd;
begin
  r:=rnd.Create;
  for z1:=0 to length(pr_dirt)-1 do
  begin
    r.SetSeed(sid+i);

    if pr_dirt[z1].radius_vert<>0 then continue;

    if pr_dirt[z1].fill_material=2 then count:=10
    else count:=r.nextInt(21)+10;
    
    x:=pr_dirt[z1].x;
    y:=pr_dirt[z1].y;
    z:=pr_dirt[z1].z;

    //sozdaetsa ellips
    //delaem randomnie radiusi
    if pr_dirt[z1].fill_material=2 then
    begin
      xxr:=(r.nextInt(count-10)+10)div 2;
      yyr:=((r.nextInt(count-10)+10)shr 2)div 2;
      zzr:=(r.nextInt(count-10)+10)div 2;
    end
    else
    begin
      xxr:=r.nextInt(count-10)+10;
      yyr:=(r.nextInt(count-10)+10)shr 2;
      zzr:=r.nextInt(count-10)+10;
    end;

    if yyr<3 then yyr:=3;
    
    //vichislaem koordinati centra po y
    i:=0;
    for j:=y+1 to y+yyr*2-2 do
      if get_block_id(map,-1,-1,x,j,z)=1 then inc(i);

    if i>3 then yyr:=(yyr*2-i+3)div 2;
    yy:=y-2+yyr;

    zz:=z;
    xx:=x;

    //izmenaem radius po x
    i:=0;
    for j:=xx downto xx-xxr do
      if get_block_id(map,-1,-1,j,yy,zz)=1 then inc(i);
    if i>3 then xxr:=xxr-(i-3);
    i:=0;
    for j:=xx to xx+xxr do
      if get_block_id(map,-1,-1,j,yy,zz)=1 then inc(i);
    if i>3 then xxr:=xxr-(i-3);

    //izmenaem radius po z
    i:=0;
    for j:=zz downto zz-zzr do
      if get_block_id(map,-1,-1,xx,yy,j)=1 then inc(i);
    if i>3 then zzr:=zzr-(i-3);
    i:=0;
    for j:=zz to zz+zzr do
      if get_block_id(map,-1,-1,xx,yy,j)=1 then inc(i);
    if i>3 then zzr:=zzr-(i-3);

    if (xxr<5)or(yyr<3)or(zzr<5) then
      continue
    else
    begin
      //zapolnaem dannie
      pr_dirt[z1].x:=xx;
      pr_dirt[z1].y:=yy;
      pr_dirt[z1].z:=zz;
      pr_dirt[z1].radius_x:=xxr;
      pr_dirt[z1].radius_z:=zzr;
      pr_dirt[z1].radius_vert:=yyr;
      
      //zapolnaem chanki
      //opredelaem kraynie koordinati po dvum osam
      tempx:=pr_dirt[z1].x-pr_dirt[z1].radius_x;
      tempk:=pr_dirt[z1].x+pr_dirt[z1].radius_x;
      tempy:=pr_dirt[z1].z-pr_dirt[z1].radius_z;
      tempz:=pr_dirt[z1].z+pr_dirt[z1].radius_z;

      //perevodim koordinati v chanki
      if tempx<0 then inc(tempx);
      if tempk<0 then inc(tempk);
      if tempy<0 then inc(tempy);
      if tempz<0 then inc(tempz);

      //zapisivaem koordinati
      tempx:=tempx div 16;
      tempk:=tempk div 16;
      tempy:=tempy div 16;
      tempz:=tempz div 16;

      //zapisivaem massiv koordinat v tekushuyu zapis'
      //popravka na minusovie chanki
      if (tempx<=0)and((pr_dirt[z1].x-pr_dirt[z1].radius_x)<0) then tempx:=tempx-1;
      if (tempk<=0)and((pr_dirt[z1].x+pr_dirt[z1].radius_x)<0) then tempk:=tempk-1;
      if (tempy<=0)and((pr_dirt[z1].z-pr_dirt[z1].radius_z)<0) then tempy:=tempy-1;
      if (tempz<=0)and((pr_dirt[z1].z+pr_dirt[z1].radius_z)<0) then tempz:=tempz-1;

      //videlaem pamat'
      setlength(pr_dirt[z1].chunks,(tempk-tempx+1)*(tempz-tempy+1));

      //zapisivaem
      z:=0;
      for i:=tempx to tempk do
        for j:=tempy to tempz do
        begin
          pr_dirt[z1].chunks[z].x:=i;
          pr_dirt[z1].chunks[z].y:=j;
          inc(z);
        end;

    end;
  end;
  r.Free;
end;

procedure gen_elipse(xkoord,ykoord:integer; var blocks:array of byte; var sferi:ar_elipse_settings; trees,pr_koord:par_tlights_koord; pr_res:par_tlights_koord; pop,gen_l:boolean; light_den:byte; tip:byte);
var i,j,k,l,z11,z22,t,t1,t2:integer;
x1,y1,z1,r_x,r_z,r_y:integer;
mat:byte;
temp:extended;
vih:boolean;
mas_koord:ar_tprostr_koord;
mas_koord_res:ar_tlights_koord;
r:rnd;
sid:int64;
id:integer;
begin
  setlength(mas_koord,0);
  setlength(mas_koord_res,0);
  r:=rnd.Create;

  for k:=0 to length(sferi)-1 do
  begin
    vih:=true;
    for i:=0 to length(sferi[k].chunks)-1 do
    if (sferi[k].chunks[i].x=xkoord)and(sferi[k].chunks[i].y=ykoord) then vih:=false;

    if vih=true then continue;

    sid:=sferi[k].x*3169+sferi[k].y*9214+sferi[k].z*2467+sferi[k].radius_x*34647;
    r.SetSeed(sid);
    sid:=r.nextInt(1000);
    case sid of
      0..23:id:=14;
      24..113:id:=15;
      114..227:id:=16;
      228..239:id:=21;
      240..287:if r.nextDouble>0.1 then id:=73 else id:=74;
      288..299:id:=56;
      300..390:id:=82
    else id:=0;
    end;

    mat:=sferi[k].fill_material;
    x1:=xkoord*16;
    z1:=ykoord*16;
    x1:=sferi[k].x-x1;
    z1:=sferi[k].z-z1;
    y1:=sferi[k].y;
    r_x:=sferi[k].radius_x;
    r_z:=sferi[k].radius_z;
    r_y:=sferi[k].radius_vert;

    {if sferi[k].fill_material=1 then vih:=false
    else if sferi[k].fill_material=2 then vih:=true;    }
    if (tip=1)and(sferi[k].fill_material=1) then id:=1   //dirt
    else if (tip=1)and(sferi[k].fill_material=2) then id:=2  //gravel
    else if (tip=1)and(sferi[k].fill_material=3) then id:=3  //sand
    else if (tip=1)and(sferi[k].fill_material=4) then id:=4  //snow
    else id:=0;

    for i:=0 to 15 do  //Z        //levo pravo
      for j:=y1-round((r_y/3)*2) to y1+round((r_y/3)*2) do   //Y
      begin
        temp:=sqr(r_x)*(1-sqr((j-y1)/r_y)-sqr((i-z1)/r_z));
        if temp<0 then continue;
        z11:=x1+round(sqrt(temp));
        z22:=x1-round(sqrt(temp));
        for l:=z22 to z11 do
          if (l>=0)and(l<=15) then
          begin
            if (l=z22)or(l=z11) then
            begin
              if (pop=false)and(id<>0) then
              begin
                t:=length(mas_koord_res);
                setlength(mas_koord_res,t+1);
                if (l=z22)and(id<>82) then
                begin
                  mas_koord_res[t].x:=l-1;
                  mas_koord_res[t].y:=j;
                  mas_koord_res[t].z:=i;
                  mas_koord_res[t].id:=id;
                end
                else if (l=z11)and(id<>82) then
                begin
                  mas_koord_res[t].x:=l+1;
                  mas_koord_res[t].y:=j;
                  mas_koord_res[t].z:=i;
                  mas_koord_res[t].id:=id;
                end;
              end;
              if (gen_l=true) then
              begin
                t:=length(mas_koord);
                setlength(mas_koord,t+1);
                mas_koord[t].x:=l;
                mas_koord[t].y:=j;
                mas_koord[t].z:=i;
              end;
            end;
            if tip=0 then
              if (sferi[k].flooded=true)and(j<=sferi[k].waterlevel) then
                blocks[j+(i*128+(l*2048))]:=9
              else
                blocks[j+(i*128+(l*2048))]:=mat
            //else if (tip=1)and(vih=false) then
            else if id=1 then
            begin
              t:=blocks[j+(i*128+(l*2048))];
              if (t<>0)and(t<>9)and(t<>82)and(t<>78)and(t<>86)and(blocks[j+1+(i*128+(l*2048))]=0) then
                blocks[j+(i*128+(l*2048))]:=2
              else if (t<>0)and(t<>9)and(t<>82)and(t<>78)and(t<>86) then
                blocks[j+(i*128+(l*2048))]:=3;
            end
            //else if (tip=1)and(vih=true) then
            else if id=2 then
            begin
              t:=blocks[j+(i*128+(l*2048))];
              if (t<>0)and(t<>2)and(t<>3)and(t<>9)and(t<>82)and(t<>78)and(t<>86) then
                blocks[j+(i*128+(l*2048))]:=13;
            end
            else if id=3 then
            begin
              t:=blocks[j+(i*128+(l*2048))];
              if (t<>0)and(t<>2)and(t<>3)and(t<>9)and(t<>78)and(t<>82)and(t<>86)and(t<>13) then
                blocks[j+(i*128+(l*2048))]:=12;
            end
            else if id=4 then
            begin
              t:=blocks[j+(i*128+(l*2048))];
              if (t<>0)and(t<>9)and(t<>86)and(t<>82)and(t<>78)and(blocks[j+1+(i*128+(l*2048))]=0) then
              begin
                blocks[j+(i*128+(l*2048))]:=2;
                //blocks[j+1+(i*128+(l*2048))]:=78;
              end
              else if (t<>0)and(t<>9)and(t<>86)and(t<>82)and(t<>78) then
                blocks[j+(i*128+(l*2048))]:=3;
            end;
          end;
      end;

    for i:=0 to 15 do  //X            //pered zad
      for j:=y1-round((r_y/3)*2) to y1+round((r_y/3)*2) do   //Y
      begin
        temp:=sqr(r_z)*(1-sqr((i-x1)/r_x)-sqr((j-y1)/r_y));
        if temp<0 then continue;
        z11:=z1+round(sqrt(temp));
        z22:=z1-round(sqrt(temp));
        for l:=z22 to z11 do
          if (l>=0)and(l<=15) then
          begin
            if (l=z22)or(l=z11) then
            begin
              if (pop=false)and(id<>0) then
              begin
                t:=length(mas_koord_res);
                setlength(mas_koord_res,t+1);
                if (l=z22)and(id<>82) then
                begin
                  mas_koord_res[t].x:=i;
                  mas_koord_res[t].y:=j;
                  mas_koord_res[t].z:=l-1;
                  mas_koord_res[t].id:=id;
                end
                else if (l=z11)and(id<>82) then
                begin
                  mas_koord_res[t].x:=i;
                  mas_koord_res[t].y:=j;
                  mas_koord_res[t].z:=l+1;
                  mas_koord_res[t].id:=id;
                end;
              end;
              if (gen_l=true) then
              begin
                t:=length(mas_koord);
                setlength(mas_koord,t+1);
                mas_koord[t].x:=i;
                mas_koord[t].y:=j;
                mas_koord[t].z:=l;
              end;
            end;
            if tip=0 then
              if (sferi[k].flooded=true)and(j<=sferi[k].waterlevel) then
                blocks[j+(l*128+(i*2048))]:=9
              else
                blocks[j+(l*128+(i*2048))]:=mat
            //else if (tip=1)and(vih=false) then
            else if id=1 then
            begin
              t:=blocks[j+(l*128+(i*2048))];
              if (t<>0)and(t<>9)and(t<>82)and(t<>86)and(t<>78)and(blocks[j+1+(l*128+(i*2048))]=0) then
                blocks[j+(l*128+(i*2048))]:=2
              else if (t<>0)and(t<>9)and(t<>86)and(t<>82)and(t<>78) then
                blocks[j+(l*128+(i*2048))]:=3;
            end
            //else if (tip=1)and(vih=true) then
            else if id=2 then
            begin
              t:=blocks[j+(l*128+(i*2048))];
              if (t<>0)and(t<>2)and(t<>3)and(t<>86)and(t<>9)and(t<>82)and(t<>78) then
                blocks[j+(l*128+(i*2048))]:=13;
            end
            else if id=3 then
            begin
              t:=blocks[j+(l*128+(i*2048))];
              if (t<>0)and(t<>2)and(t<>3)and(t<>86)and(t<>9)and(t<>82)and(t<>13)and(t<>78) then
                blocks[j+(l*128+(i*2048))]:=12;
            end
            else if id=4 then
            begin
              t:=blocks[j+(l*128+(i*2048))];
              if (t<>0)and(t<>9)and(t<>82)and(t<>86)and(t<>78)and(blocks[j+1+(l*128+(i*2048))]=0) then
              begin
                blocks[j+(l*128+(i*2048))]:=2;
                //blocks[j+1+(l*128+(i*2048))]:=78;
              end
              else if (t<>0)and(t<>9)and(t<>82)and(t<>86)and(t<>78) then
                blocks[j+(l*128+(i*2048))]:=3;
            end;
          end;
      end;

    for i:=0 to 15 do  //X               verh niz
      for j:=0 to 15 do //Z
      begin
        temp:=sqr(r_y)*(1-sqr((i-x1)/r_x)-sqr((j-z1)/r_z));
        if temp<0 then continue;
        z11:=y1+round(sqrt(temp));
        z22:=y1-round(sqrt(temp));
        for l:=z22 to z11 do
        begin
            if (l=z22)or(l=z11) then
            begin
              if (pop=false)and(id<>0) then
              begin
                t:=length(mas_koord_res);
                setlength(mas_koord_res,t+1);
                if l=z22 then
                begin
                  mas_koord_res[t].x:=i;
                  mas_koord_res[t].y:=l-1;
                  mas_koord_res[t].z:=j;
                  mas_koord_res[t].id:=id;
                end
                else if l=z11 then
                begin
                  mas_koord_res[t].x:=i;
                  mas_koord_res[t].y:=l+1;
                  mas_koord_res[t].z:=j;
                  mas_koord_res[t].id:=id;
                end;
              end;
              if (gen_l=true) then
              begin
                t:=length(mas_koord);
                setlength(mas_koord,t+1);
                mas_koord[t].x:=i;
                mas_koord[t].y:=l;
                mas_koord[t].z:=j;
              end;
            end;

            if tip=0 then
              if (sferi[k].flooded=true)and(l<=sferi[k].waterlevel) then
                blocks[l+(j*128+(i*2048))]:=9
              else
                blocks[l+(j*128+(i*2048))]:=mat
            //else if (tip=1)and(vih=false) then   //zemla
            else if id=1 then
            begin     
                t:=blocks[l+(j*128+(i*2048))];
                if (t<>0)and(t<>9)and(t<>82)and(t<>86)and(t<>78)and(blocks[l+1+(j*128+(i*2048))]=0) then
                begin
                  blocks[l+(j*128+(i*2048))]:=2;
                  t1:=i+xkoord*16;
                  t2:=j+ykoord*16;
                  if t1>0 then dec(t1);
                  if t2>0 then dec(t2);
                  {t1:=abs(t1);
                  t2:=abs(t2);
                  while t1>512 do
                    dec(t1,512);
                  while t2>512 do
                    dec(t2,512);   }
                  t1:=abs(t1 mod 512);
                  t2:=abs(t2 mod 512);

                  if (random<0.06)and(t1>4)and(t1<508)and(t2>4)and(t2<508) then
                  begin
                    t1:=length(trees^);       //derevo
                    setlength(trees^,t1+1);
                    trees^[t1].x:=i+xkoord*16;
                    trees^[t1].z:=j+ykoord*16;
                    trees^[t1].y:=l+1;
                    trees^[t1].id:=0;
                  end
                  else
                  if random<0.2 then    //trava
                  begin
                    t1:=length(trees^);
                    setlength(trees^,t1+1);
                    trees^[t1].x:=i+xkoord*16;
                    trees^[t1].z:=j+ykoord*16;
                    trees^[t1].y:=l+1;
                    if random<0.12 then
                    begin
                      if random<0.5 then
                        trees^[t1].id:=7
                      else
                        trees^[t1].id:=8;
                    end
                    else
                      trees^[t1].id:=1;
                  end;
                end
                else if (t<>0)and(t<>9)and(t<>82)and(t<>86)and(t<>78) then
                  blocks[l+(j*128+(i*2048))]:=3;
            end
            //else if (tip=1)and(vih=true) then    //graviy
            else if id=2 then
            begin
              t:=blocks[l+(j*128+(i*2048))];
              if (t<>0)and(t<>9)and(t<>2)and(t<>86)and(t<>3)and(t<>82)and(t<>78)and(blocks[l+1+(j*128+(i*2048))]=0) then
              begin
                blocks[l+(j*128+(i*2048))]:=13;
                if random<0.07 then
                begin
                  t1:=length(trees^);       //grib
                  setlength(trees^,t1+1);
                  trees^[t1].x:=i+xkoord*16;
                  trees^[t1].z:=j+ykoord*16;
                  trees^[t1].y:=l+1;
                  if random<0.5 then trees^[t1].id:=2
                  else trees^[t1].id:=3;
                end;
              end
              else if (t<>0)and(t<>9)and(t<>86)and(t<>2)and(t<>3)and(t<>82)and(t<>78) then
                blocks[l+(j*128+(i*2048))]:=13;
            end
            else if id=3 then           //pesok
            begin
              t:=blocks[l+(j*128+(i*2048))];
              if (t<>0)and(t<>9)and(t<>2)and(t<>86)and(t<>3)and(t<>82)and(t<>78)and(t<>13)and(blocks[l+1+(j*128+(i*2048))]=0) then
              begin
                if l>1 then t1:=blocks[l-1+(j*128+(i*2048))]
                else t1:=12;

                if t1=0 then blocks[l+(j*128+(i*2048))]:=24
                else blocks[l+(j*128+(i*2048))]:=12;

                if (random<0.03)and(t1<>0) then
                begin
                  t1:=length(trees^);       //kaktus
                  setlength(trees^,t1+1);
                  trees^[t1].x:=i+xkoord*16;
                  trees^[t1].z:=j+ykoord*16;
                  trees^[t1].y:=l+1;
                  trees^[t1].id:=4;
                end;
              end
              else if (t<>0)and(t<>9)and(t<>2)and(t<>86)and(t<>3)and(t<>82)and(t<>78)and(t<>13) then
              begin
                if l>1 then t1:=blocks[l-1+(j*128+(i*2048))]
                else t1:=12;

                if t1=0 then blocks[l+(j*128+(i*2048))]:=24
                else blocks[l+(j*128+(i*2048))]:=12;
              end;
            end
            else if id=4 then       //sneg
            begin
              t:=blocks[l+(j*128+(i*2048))];
              if (t<>0)and(t<>9)and(t<>82)and(t<>86)and(t<>78)and(t<>79)and(blocks[l+1+(j*128+(i*2048))]=0) then
              begin
                blocks[l+(j*128+(i*2048))]:=2;
                blocks[l+1+(j*128+(i*2048))]:=78;
                t1:=i+xkoord*16;
                t2:=j+ykoord*16;
                if t1>0 then dec(t1);
                if t2>0 then dec(t2);
                t1:=abs(t1 mod 512);
                t2:=abs(t2 mod 512);

                if (random<0.08)and(t1>4)and(t1<508)and(t2>4)and(t2<508) then
                begin
                  t1:=length(trees^);       //taezhnoe derevo
                  setlength(trees^,t1+1);
                  trees^[t1].x:=i+xkoord*16;
                  trees^[t1].z:=j+ykoord*16;
                  trees^[t1].y:=l+1;
                  if random<0.5 then trees^[t1].id:=5
                  else trees^[t1].id:=6;
                end;
              end
              else if (t=9)and(blocks[l+1+(j*128+(i*2048))]=0) then
                blocks[l+(j*128+(i*2048))]:=79
              else if (t<>0)and(t<>9)and(t<>82)and(t<>86)and(t<>78) then
                blocks[l+(j*128+(i*2048))]:=3;
            end;
        end;
      end;
  end;

  //rabota s koordinatami osvesheniya+++++++++++++++++
  if (gen_l=true)and(tip=0)and(pop=false) then
  begin

  for i:=0 to length(mas_koord)-2 do
  begin
    if mas_koord[i].y=1000 then continue;
    for j:=i+1 to length(mas_koord)-1 do
    begin
      if mas_koord[j].y=1000 then continue;

      if (mas_koord[i].x=mas_koord[j].x)and
      (mas_koord[i].y=mas_koord[j].y)and
      (mas_koord[i].z=mas_koord[j].z) then
        mas_koord[j].y:=1000;
    end;
  end;
  //perevodim v obshie koordinati
  for i:=0 to length(mas_koord)-1 do
    if mas_koord[i].y<>1000 then
    begin
      mas_koord[i].x:=mas_koord[i].x+xkoord*16;
      mas_koord[i].z:=mas_koord[i].z+ykoord*16;
    end;

    //sravnivaem s obshim massivom na ravenstvo
    for i:=0 to length(mas_koord)-1 do
    begin
      if mas_koord[i].y=1000 then continue;
      for j:=0 to length(pr_koord^)-1 do
        if (mas_koord[i].x=pr_koord^[j].x)and
        (mas_koord[i].y=pr_koord^[j].y)and
        (mas_koord[i].z=pr_koord^[j].z) then
        begin
          mas_koord[i].y:=1000;
          break;
        end;
    end;
    for i:=0 to length(mas_koord)-1 do
    begin
      if mas_koord[i].y=1000 then continue;
      if (random<(light_den/5000)) then
      begin
        j:=length(pr_koord^);
        setlength(pr_koord^,j+1);
        pr_koord^[j].x:=mas_koord[i].x;
        pr_koord^[j].y:=mas_koord[i].y;
        pr_koord^[j].z:=mas_koord[i].z;
        pr_koord^[j].id:=89;
      end;
    end;
  end;


  //rabota s koordinatami resursov++++++++++++++++++++++
  //udalaem povtori
  if (tip=0)and(pop=false) then
  begin

  for i:=0 to length(mas_koord_res)-2 do
  begin
    if mas_koord_res[i].y=1000 then continue;
    for j:=i+1 to length(mas_koord_res)-1 do
    begin
      if mas_koord_res[j].y=1000 then continue;

      if (mas_koord_res[i].x=mas_koord_res[j].x)and
      (mas_koord_res[i].y=mas_koord_res[j].y)and
      (mas_koord_res[i].z=mas_koord_res[j].z)and
      (mas_koord_res[i].id<>82)and(mas_koord_res[j].id<>82) then
        mas_koord_res[j].y:=1000
      else
      if (mas_koord_res[i].x=mas_koord_res[j].x)and
      (mas_koord_res[i].z=mas_koord_res[j].z)and
      (mas_koord_res[i].id=82)and(mas_koord_res[j].id=82) then
        mas_koord_res[j].y:=1000;
    end;
  end;
  //perevodim v obshie koordinati
  for i:=0 to length(mas_koord_res)-1 do
    if mas_koord_res[i].y<>1000 then
    begin
      mas_koord_res[i].x:=mas_koord_res[i].x+xkoord*16;
      mas_koord_res[i].z:=mas_koord_res[i].z+ykoord*16;
    end;

    //kopiruem v obshiy massiv
    for i:=0 to length(mas_koord_res)-1 do
    begin
      if (random<0.01)and(mas_koord_res[i].y<>1000)and(mas_koord_res[i].id<>82) then
      begin
        t:=length(pr_res^);
        setlength(pr_res^,t+1);
        pr_res^[t].x:=mas_koord_res[i].x;
        pr_res^[t].y:=mas_koord_res[i].y;
        pr_res^[t].z:=mas_koord_res[i].z;
        pr_res^[t].id:=mas_koord_res[i].id;
      end
      else if (random<0.1)and(mas_koord_res[i].y<>1000)and(mas_koord_res[i].id=82) then
      begin
        t:=length(pr_res^);
        setlength(pr_res^,t+1);
        pr_res^[t].x:=mas_koord_res[i].x;
        pr_res^[t].y:=mas_koord_res[i].y;
        pr_res^[t].z:=mas_koord_res[i].z;
        pr_res^[t].id:=mas_koord_res[i].id;
      end;
    end;
  end;

  setlength(mas_koord,0);
  setlength(mas_koord_res,0);
  r.Free;
end;

procedure gen_tun(xkoord,ykoord:integer; var blocks:array of byte; var tun:array of tunnels_settings; pr_koord:par_tlights_koord; pr_koord_holes:par_tprostr_koord; pr_koord_dirt:par_elipse_settings; pr_koord_res:par_tlights_koord; pop,gen_l,gen_s:boolean; light_den,skyholes_den:byte);
var k,t,t1,t2:integer;
i,j,z:integer;
x1,z1,y1:integer;
f:byte;
dl1:extended;
xx,yy,zz,d:extended;
koef:extended;
vih:boolean;
mas_koord:ar_tprostr_koord;
mas_koord_holes:ar_tkoord;
begin
  setlength(mas_koord,0);
  setlength(mas_koord_holes,0);

  for k:=0 to length(tun)-1 do
  begin
    vih:=true;
    for t:=0 to length(tun[k].chunks)-1 do
      if (tun[k].chunks[t].x=xkoord)and(tun[k].chunks[t].y=ykoord) then
      begin
        vih:=false;
        break;
      end;
    //dla otladki
    //vih:=false;

    if vih=true then continue;

    //zapolnaem chank steklom dla otladki
    //fillchar(blocks[0],length(blocks),20);

    //zapominaem material zalivki
    f:=tun[k].fill_material;

    //vichisaem otnositelnie koordinati
    x1:=xkoord*16;
    z1:=ykoord*16;

    x1:=tun[k].x1-x1;
    z1:=tun[k].z1-z1;
    y1:=tun[k].y1;

    dl1:=sqrt(sqr(tun[k].x2-tun[k].x1)+sqr(tun[k].y2-tun[k].y1)+sqr(tun[k].z2-tun[k].z1));


    for z:=1 to 127 do  //Y
      for i:=0 to 15 do  //X
        for j:=0 to 15 do  //Z
        begin
          xx:=(i-x1)*tun[k].c2x+(z-y1)*tun[k].c2y+(j-z1)*tun[k].c2z;
          yy:=(i-x1)*tun[k].c1x+(z-y1)*tun[k].c1y+(j-z1)*tun[k].c1z;
          zz:=(i-x1)*tun[k].c3x+(z-y1)*tun[k].c3y+(j-z1)*tun[k].c3z;

          if (yy>=dl1)or(yy<0) then continue;

          d:=sqr(xx)/sqr(tun[k].radius_horiz)+sqr(zz)/sqr(tun[k].radius_vert);

          koef:=1.425+(min(tun[k].radius_horiz,tun[k].radius_vert)-5)*(-0.0138);

          //ToDO: vozmozhno dobavit' 2 sloya zapolneniya iz raznih materialov
          //proverat' rasstoyanie ot poluchennoy tochki do osi Y (centra cilindra)
          //if d<=sqr(cyl[k].radius) then
          if (d<=koef) then
          begin

            {if (d>=1)and(d<koef)and(gen_l=true)and(random<(light_den/5000)) then
            begin
              t:=length(mas_koord);
              setlength(mas_koord,t+1);
              mas_koord[t].x:=i;
              mas_koord[t].y:=z;
              mas_koord[t].z:=j;
            end;   }
            if (d>=0.8)and(d<1)and(gen_l=true)and(random<(light_den/5000)) then
            begin
              t:=length(mas_koord);
              setlength(mas_koord,t+1);
              mas_koord[t].x:=i;
              mas_koord[t].y:=z;
              mas_koord[t].z:=j;
            end;  

            if (d>=1)and(d<=koef)and(random<0.00034)and(zz>0) then
            begin
              t:=xkoord;
              t1:=ykoord;
              if t>0 then dec(t);
              if t1>0 then dec(t1);
              t:=abs(xkoord mod 32);
              t1:=abs(ykoord mod 32);
              if (t>2)and(t<30)and(t1>2)and(t1<30) then
              begin
                t:=length(pr_koord_dirt^);
                setlength(pr_koord_dirt^,t+1);
                pr_koord_dirt^[t].x:=i+xkoord*16;
                pr_koord_dirt^[t].y:=z;
                pr_koord_dirt^[t].z:=j+ykoord*16;
                {if random<0.12 then pr_koord_dirt^[t].fill_material:=2  //gravel
                else pr_koord_dirt^[t].fill_material:=1; //dirt }
                t2:=random(100);
                case t2 of
                  0..7:pr_koord_dirt^[t].fill_material:=3; //sand
                  8..20:pr_koord_dirt^[t].fill_material:=4;  //snow
                  21..30:pr_koord_dirt^[t].fill_material:=2; //gravel
                  31..99:pr_koord_dirt^[t].fill_material:=1; //dirt
                end;
              end;
            end;
            if (d>=1)and(d<=koef)and(random<0.00011) then
            begin
              t:=length(pr_koord_res^);
              setlength(pr_koord_res^,t+1);
              pr_koord_res^[t].x:=i+xkoord*16;
              pr_koord_res^[t].z:=j+ykoord*16;
              pr_koord_res^[t].y:=z;
              t1:=random(106);
              case t1 of
                0..7:pr_koord_res^[t].id:=14;   //Gold
                8..37:pr_koord_res^[t].id:=15;  //Iron
                38..75:pr_koord_res^[t].id:=16;  //Coal
                76..79:pr_koord_res^[t].id:=21;  //Lapiz
                80..95:if random>0.1 then pr_koord_res^[t].id:=73 else pr_koord_res^[t].id:=74;  //Redstone
                96..99:pr_koord_res^[t].id:=56;  //Dimond
                100..105:pr_koord_res^[t].id:=86;  //Pumpkin
              end;
            end;
            if (d>=0.3)and(d<=0.4)and
            (random<(skyholes_den/10000))and(pop=false)and(gen_s=true)and
            (yy<(dl1-10))and(yy>10) then
            begin
              t:=length(mas_koord_holes);
              setlength(mas_koord_holes,t+1);
              mas_koord_holes[t].x:=i;
              mas_koord_holes[t].y:=j;
            end;

            if d<=1 then
            begin
              if ((tun[k].flooded_nat=true)or(tun[k].flooded_unnat=true))
              and(z<=max(tun[k].waterlevel_nat,tun[k].waterlevel_unnat)) then
              //if (tun[k].flooded_unnat=true)and(z<=tun[k].waterlevel_unnat) then
                blocks[z+(j*128+(i*2048))]:=9
              else
                blocks[z+(j*128+(i*2048))]:=f;

              {if (tun[k].flooded_unnat=true)
              and(z<=tun[k].waterlevel_unnat) then
                blocks[z+(j*128+(i*2048))]:=9
              else
                blocks[z+(j*128+(i*2048))]:=f;   }
            end
            else if (d>1)and(d<=koef)and(tun[k].flooded_nat=true)and(z<=tun[k].waterlevel_nat+2) then
              if blocks[z+(j*128+(i*2048))]=1 then
                blocks[z+(j*128+(i*2048))]:=12;
          end;
        end;

    if pop=false then
    begin
      //perenosim koordinati v massiv dirok
      for i:=0 to length(mas_koord_holes)-1 do
      begin
        t:=length(pr_koord_holes^);
        setlength(pr_koord_holes^,t+1);
        pr_koord_holes^[t].x:=mas_koord_holes[i].x+xkoord*16;
        pr_koord_holes^[t].y:=mas_koord_holes[i].y+ykoord*16;
      end;

    for i:=0 to length(mas_koord)-1 do
      //if random<(light_den/5000) then
      begin
        //prisvaivanie materiala

        z:=89;

        //vih:=true;
        {vih:=false;
        if (mas_koord[i].x<>0) then
        begin
          t:=blocks[mas_koord[i].y+(mas_koord[i].z*128+((mas_koord[i].x-1)*2048))];
          if t=z then continue;
          if t<>0 then vih:=true;
        end;

        if (mas_koord[i].x<>15)and(vih=false) then
        begin
          t:=blocks[mas_koord[i].y+(mas_koord[i].z*128+((mas_koord[i].x+1)*2048))];
          if t=z then continue;
          if t<>0 then vih:=true;
        end;

        if (mas_koord[i].z<>0)and(vih=false) then
        begin
          t:=blocks[mas_koord[i].y+((mas_koord[i].z-1)*128+(mas_koord[i].x*2048))];
          if t=z then continue;
          if t<>0 then vih:=true;
        end;

        if (mas_koord[i].z<>15)and(vih=false) then
        begin
          t:=blocks[mas_koord[i].y+((mas_koord[i].z+1)*128+(mas_koord[i].x*2048))];
          if t=z then continue;
          if t<>0 then vih:=true;
        end;

        if (mas_koord[i].y<>0)and(vih=false) then
        begin
          t:=blocks[(mas_koord[i].y-1)+(mas_koord[i].z*128+(mas_koord[i].x*2048))];
          if t=z then continue;
          if t<>0 then vih:=true;
        end;

        if (mas_koord[i].y<>127)and(vih=false) then
        begin
          t:=blocks[(mas_koord[i].y+1)+(mas_koord[i].z*128+(mas_koord[i].x*2048))];
          if t=z then continue;
          if t<>0 then vih:=true;
        end;  }

        //if vih=true then
        begin
          //blocks[mas_koord[i].y+(mas_koord[i].z*128+(mas_koord[i].x*2048))]:=z;
          //perevodim koordinati v obshie
          t:=length(pr_koord^);
          setlength(pr_koord^,t+1);
          pr_koord^[t].x:=xkoord*16+mas_koord[i].x;
          pr_koord^[t].z:=ykoord*16+mas_koord[i].z;
          pr_koord^[t].y:=mas_koord[i].y;
          pr_koord^[t].id:=z;
        end;
      end;
    end;

    setlength(mas_koord,0);
    setlength(mas_koord_holes,0);
  end;
end;

function gen_flooded(var ar_tun:ar_tun_settings; var map:region):boolean;
var
  chxot,chyot:integer;
  pereh:boolean;
  temp_ind_tun:tunnels_settings;
  temp_tun1,temp_tun2:array of tunnels_settings;
  temp_sf:ar_elipse_settings;
  t_lights:ar_tlights_koord;
  t_holes:ar_tprostr_koord;
  t_res:ar_tlights_koord;
  t_dirt:ar_elipse_settings;

  function get_tun_ind(tun:tunnels_settings; ar_tun:array of tunnels_settings):integer;
  var i,ind:integer;
  begin
    ind:=0;
    for i:= 0 to length(ar_tun)-1 do
      if (ar_tun[i].x1=tun.x1)and
      (ar_tun[i].z1=tun.z1)and
      (ar_tun[i].y1=tun.y1) then
      begin
        ind:=i;
        break;
      end;
    result:=ind;
  end;

  function check_water(var map:region):boolean;
  var chx,chy,x,y,z,t:integer;
  b:boolean;
  begin
    b:=false;
    for chx:=0 to 16 do
      for chy:=0 to 16 do
      begin
        if b=true then break;
        for x:=0 to 15 do
          for z:=0 to 15 do
            for y:=1 to 126 do
            begin
              t:=map[chx][chy].blocks[y+(z*128+(x*2048))];
              if (t=9)or(t=8) then
              begin
                if map[chx][chy].blocks[y-1+(z*128+(x*2048))]=0 then b:=true;

                if (x=0)and(chx<>0) then
                  if map[chx-1][chy].blocks[y+(z*128+(15*2048))]=0 then b:=true;
                if x<>0 then
                  if map[chx][chy].blocks[y+(z*128+((x-1)*2048))]=0 then b:=true;

                if (x=15)and(chx<>16) then
                  if map[chx+1][chy].blocks[y+(z*128)]=0 then b:=true;
                if x<>15 then
                  if map[chx][chy].blocks[y+(z*128+((x+1)*2048))]=0 then b:=true;

                if (z=0)and(chy<>0) then
                  if map[chx][chy-1].blocks[y+(15*128+(x*2048))]=0 then b:=true;
                if z<>0 then
                  if map[chx][chy].blocks[y+((z-1)*128+(x*2048))]=0 then b:=true;

                if (z=15)and(chy<>16) then
                  if map[chx][chy+1].blocks[y+(x*2048)]=0 then b:=true;
                if z<>15 then
                  if map[chx][chy].blocks[y+((z+1)*128+(x*2048))]=0 then b:=true;
              end;
            end;
      end;
    result:=b;
  end;

  function get_temp_tun(tun:tunnels_settings; ind:integer; nachalo:boolean):tunnels_settings;
  var temp:tunnels_settings;
  begin
    if nachalo=true then
    begin
      temp.x1:=tun.svazi_nach[ind]^.x1;
      temp.y1:=tun.svazi_nach[ind]^.y1;
      temp.z1:=tun.svazi_nach[ind]^.z1;
      temp.x2:=tun.svazi_nach[ind]^.x2;
      temp.y2:=tun.svazi_nach[ind]^.y2;
      temp.z2:=tun.svazi_nach[ind]^.z2;
    end
    else
    begin
      temp.x1:=tun.svazi_kon[ind]^.x1;
      temp.y1:=tun.svazi_kon[ind]^.y1;
      temp.z1:=tun.svazi_kon[ind]^.z1;
      temp.x2:=tun.svazi_kon[ind]^.x2;
      temp.y2:=tun.svazi_kon[ind]^.y2;
      temp.z2:=tun.svazi_kon[ind]^.z2;
      temp.c1x:=tun.svazi_kon[ind]^.c1x;
      temp.c1y:=tun.svazi_kon[ind]^.c1y;
      temp.c1z:=tun.svazi_kon[ind]^.c1z;
      temp.c2x:=tun.svazi_kon[ind]^.c2x;
      temp.c2y:=tun.svazi_kon[ind]^.c2y;
      temp.c2z:=tun.svazi_kon[ind]^.c2z;
      temp.c3x:=tun.svazi_kon[ind]^.c3x;
      temp.c3y:=tun.svazi_kon[ind]^.c3y;
      temp.c3z:=tun.svazi_kon[ind]^.c3z;
      temp.radius_horiz:=tun.svazi_kon[ind]^.radius_horiz;
      temp.radius_vert:=tun.svazi_kon[ind]^.radius_vert;
      temp.fill_material:=tun.svazi_kon[ind]^.fill_material;
      temp.waterlevel_nat:=tun.svazi_kon[ind]^.waterlevel_nat;
      temp.flooded_nat:=tun.svazi_kon[ind]^.flooded_nat;
      temp.waterlevel_unnat:=tun.svazi_kon[ind]^.waterlevel_unnat;
      temp.flooded_unnat:=tun.svazi_kon[ind]^.flooded_unnat;
    end;
    setlength(temp.svazi_nach,0);
    setlength(temp.svazi_kon,0);
    setlength(temp.chunks,0);
    temp.nach_sfera:=nil;
    temp.kon_sfera:=nil;

    result:=temp;
  end;

  function calc_tun_flood(ar_tun:par_tun_settings; napr,waterlevel,ind:integer):integer;
  var sum,i,j,t,chx,chy,k,z,t1:integer;
  begin
    ar_tun^[ind].flooded_unnat:=true;
    ar_tun^[ind].waterlevel_unnat:=waterlevel;
    ar_tun^[ind].flooded_nat:=false;
    ar_tun^[ind].waterlevel_nat:=0;
    result:=1;
    if napr=0 then
    begin
      if ar_tun^[ind].y1<ar_tun^[ind].y2 then
      begin
        for i:=0 to length(ar_tun^[ind].svazi_nach)-1 do
        begin
          t1:=get_tun_ind(ar_tun^[ind].svazi_nach[i]^,ar_tun^);
          if (ar_tun^[ind].x1=ar_tun^[ind].svazi_nach[i]^.x1) then
            result:=result+calc_tun_flood(ar_tun,1,waterlevel,t1)
          else
            result:=result+calc_tun_flood(ar_tun,0,waterlevel,t1);
        end;
      end
      else
      begin
        for i:=0 to length(ar_tun^[ind].svazi_nach)-1 do
        begin
          t:=min(ar_tun^[ind].svazi_nach[i]^.y1,ar_tun^[ind].svazi_nach[i]^.y2);
          if (t-ar_tun^[ind].svazi_nach[i]^.radius_vert)>waterlevel then continue;
          if (t=ar_tun^[ind].y1)and((t-ar_tun^[ind].svazi_nach[i]^.radius_vert)<waterlevel) then
          begin
            t1:=get_tun_ind(ar_tun^[ind].svazi_nach[i]^,ar_tun^);
            if (ar_tun^[ind].x1=ar_tun^[ind].svazi_nach[i]^.x1) then
              result:=result+calc_tun_flood(ar_tun,1,waterlevel,t1)
            else
              result:=result+calc_tun_flood(ar_tun,0,waterlevel,t1);
          end
          else
          begin    //stroim
            setlength(temp_tun1,1);
            temp_tun1[0]:=ar_tun^[ind];
            setlength(temp_tun2,1);
            temp_tun2[0]:=ar_tun^[ind].svazi_nach[i]^;
            setlength(temp_sf,1);
            temp_sf[0]:=ar_tun^[ind].nach_sfera^;

            calc_cos_tun(temp_tun1);
            calc_cos_tun(temp_tun2);

            fill_tun_chunks(temp_tun1);
            fill_tun_chunks(temp_tun2);
            fill_el_chunks(temp_sf);

            chx:=ar_tun^[ind].x1;
            chy:=ar_tun^[ind].z1;
            if chx<0 then inc(chx);
            if chy<0 then inc(chy);
            chx:=chx div 16;
            chy:=chy div 16;
            if (chx<=0)and(ar_tun^[ind].x1<0) then dec(chx);
            if (chy<=0)and(ar_tun^[ind].z1<0) then dec(chy);
            chxot:=chx-8;
            chyot:=chy-8;

            for k:=0 to 16 do
              for z:=0 to 16 do
              begin
                fillchar(map[k][z].blocks[0],length(map[k][z].blocks),1);
                //poradok generirovaniya: vtoroy tunel, sfera, perviy tunel
                gen_tun(chxot+k,chyot+z,map[k][z].blocks,temp_tun2,@t_lights,@t_holes,@t_dirt,@t_res,true,false,false,50,50);
                gen_elipse(chxot+k,chyot+z,map[k][z].blocks,temp_sf,nil,@t_lights,@t_res,true,false,50,0);
                gen_tun(chxot+k,chyot+z,map[k][z].blocks,temp_tun1,@t_lights,@t_holes,@t_dirt,@t_res,true,false,false,50,50);

                //gen_tun(tempx-2,tempy-2,map[k][z].blocks,ar_tun,@pr_koord_lights,@pr_koord_holes,@pr_koord_dirt,@pr_koord_res,b1,par.tunnel_par^.gen_lights,par.tunnel_par^.gen_sun_holes,par.tunnel_par^.light_density,par.tunnel_par^.skyholes_density);
                //gen_elipse(tempx-2,tempy-2,map[k][z].blocks,ar_el,nil,@pr_koord_lights,@pr_koord_res,b1,par.tunnel_par^.gen_lights,par.tunnel_par^.light_density,0);
              end;

            //proveraem, est' li voda bez stenok...
            if check_water(map)=true then
            begin
              t1:=get_tun_ind(ar_tun^[ind].svazi_nach[i]^,ar_tun^);
              if (ar_tun^[ind].x1=ar_tun^[ind].svazi_nach[i]^.x1) then
                result:=result+calc_tun_flood(ar_tun,1,waterlevel,t1)
              else
                result:=result+calc_tun_flood(ar_tun,0,waterlevel,t1);
            end;
          end;
        end;
      end;
    end
    else
    begin
      if ar_tun^[ind].y1>ar_tun^[ind].y2 then
      begin
        for i:=0 to length(ar_tun^[ind].svazi_kon)-1 do
        begin
          temp_ind_tun:=get_temp_tun(ar_tun^[ind],i,false);
          //t1:=get_tun_ind(ar_tun[ind].svazi_kon[i]^,ar_tun);
          t1:=get_tun_ind(temp_ind_tun,ar_tun^);
          if (ar_tun^[ind].x2=ar_tun^[ind].svazi_kon[i]^.x1) then
            result:=result+calc_tun_flood(ar_tun,1,waterlevel,t1)
          else
            result:=result+calc_tun_flood(ar_tun,0,waterlevel,t1);
        end;
      end
      else
      begin
        for i:=0 to length(ar_tun^[ind].svazi_kon)-1 do
        begin
          t:=min(ar_tun^[ind].svazi_kon[i]^.y1,ar_tun^[ind].svazi_kon[i]^.y2);
          if (t-ar_tun^[ind].svazi_kon[i]^.radius_vert)>waterlevel then continue;
          if (t=ar_tun^[ind].y2)and((t-ar_tun^[ind].svazi_kon[i]^.radius_vert)<waterlevel) then
          begin
            t1:=get_tun_ind(ar_tun^[ind].svazi_kon[i]^,ar_tun^);
            if (ar_tun^[ind].x1=ar_tun^[ind].svazi_kon[i]^.x1) then
              result:=result+calc_tun_flood(ar_tun,1,waterlevel,t1)
            else
              result:=result+calc_tun_flood(ar_tun,0,waterlevel,t1);
          end
          else
          begin    //stroim
            setlength(temp_tun1,1);
            temp_tun1[0]:=ar_tun^[ind];
            setlength(temp_tun2,1);
            //temp_tun2[0]:=ar_tun^[ind].svazi_kon[i]^;
            temp_tun2[0]:=get_temp_tun(ar_tun^[ind],i,false);
            setlength(temp_sf,1);
            temp_sf[0]:=ar_tun^[ind].kon_sfera^;

            calc_cos_tun(temp_tun1);
            calc_cos_tun(temp_tun2);

            fill_tun_chunks(temp_tun1);
            fill_tun_chunks(temp_tun2);
            fill_el_chunks(temp_sf);

            chx:=ar_tun^[ind].x2;
            chy:=ar_tun^[ind].z2;
            if chx<0 then inc(chx);
            if chy<0 then inc(chy);
            chx:=chx div 16;
            chy:=chy div 16;
            if (chx<=0)and(ar_tun^[ind].x2<0) then dec(chx);
            if (chy<=0)and(ar_tun^[ind].z2<0) then dec(chy);
            chxot:=chx-8;
            chyot:=chy-8;

            for k:=0 to 16 do
              for z:=0 to 16 do
              begin
                fillchar(map[k][z].blocks[0],length(map[k][z].blocks),1);
                //poradok generirovaniya: vtoroy tunel, sfera, perviy tunel
                gen_tun(chxot+k,chyot+z,map[k][z].blocks,temp_tun2,@t_lights,@t_holes,@t_dirt,@t_res,true,false,false,50,50);
                gen_elipse(chxot+k,chyot+z,map[k][z].blocks,temp_sf,nil,@t_lights,@t_res,true,false,50,0);
                gen_tun(chxot+k,chyot+z,map[k][z].blocks,temp_tun1,@t_lights,@t_holes,@t_dirt,@t_res,true,false,false,50,50);

                //gen_tun(tempx-2,tempy-2,map[k][z].blocks,ar_tun,@pr_koord_lights,@pr_koord_holes,@pr_koord_dirt,@pr_koord_res,b1,par.tunnel_par^.gen_lights,par.tunnel_par^.gen_sun_holes,par.tunnel_par^.light_density,par.tunnel_par^.skyholes_density);
                //gen_elipse(tempx-2,tempy-2,map[k][z].blocks,ar_el,nil,@pr_koord_lights,@pr_koord_res,b1,par.tunnel_par^.gen_lights,par.tunnel_par^.light_density,0);
              end;

            //proveraem, est' li voda bez stenok...
            if check_water(map)=true then
            begin
              t1:=get_tun_ind(ar_tun^[ind].svazi_kon[i]^,ar_tun^);
              if (ar_tun^[ind].x2=ar_tun^[ind].svazi_kon[i]^.x1) then
                result:=result+calc_tun_flood(ar_tun,1,waterlevel,t1)
              else
                result:=result+calc_tun_flood(ar_tun,0,waterlevel,t1);
            end;
          end;
        end;
      end;
    end;

    setlength(temp_tun1,0);
    setlength(temp_tun2,0);
    setlength(temp_sf,0);
    result:=sum;
  end;

var i,j,level:integer;
//point:ptunnels_settings;
begin
  for i:=0 to length(ar_tun)-1 do
  begin
    if ar_tun[i].flooded_nat=true then continue;
    j:=max(ar_tun[i].y1,ar_tun[i].y2)-min(ar_tun[i].y1,ar_tun[i].y2)-ar_tun[i].radius_vert*2;
    if j<5 then continue;
    level:=min(ar_tun[i].y1,ar_tun[i].y2)+ar_tun[i].radius_vert+random(j);
    if level>60 then continue;
    if ar_tun[i].y1<ar_tun[i].y2 then
      calc_tun_flood(@ar_tun,0,level,i)
    else
      calc_tun_flood(@ar_tun,1,level,i);
    break;
  end;
end;

function gen_tunnels_thread(Parameter:pointer):integer;
var regx_nach,regy_nach,regx,regy:integer;
i,j,k,z:integer;
otx,oty,dox,doy:integer;
tempx,tempy,tempk,tempz:integer;
id:word;
param:ptparam_tunnel;
par:tparam_tunnel;
map:region;
head:mcheader;
str,strcompress:string;
fdata,rez:ar_type;
hndl:cardinal;
count:dword;
co,co1:integer;
waterlevel:integer;
ar_tun:ar_tun_settings;
//ar_sf:array of planets_settings;
ar_el:ar_elipse_settings;
cep_tun:ar_cep_tunnel;
b,b1,sp:boolean;
angle,angle2:extended;
iskluch:array of integer;
pr_koord_lights:ar_tlights_koord;
pr_koord_holes,pr_koord_holes_obsh:ar_tprostr_koord;
pr_koord_res:ar_tlights_koord;
pr_koord_dirt:ar_elipse_settings;
pr_koord_trees:ar_tlights_koord;
pop_koord:ar_tkoord;
label nach;

procedure thread_exit(p:ptparam_tunnel);
var i,j:integer;
begin
  if p^.tunnel_par^.potok_exit=true then
  begin
    //++++++++OCHISHENIE PAMATI++++++++++++=
  //ochishaem pamat ot massiva resultata dla nbtcompress
  setlength(rez,0);

  //ochishaem pamat' ot massiva sfer
  {for i:=0 to length(ar_sf)-1 do
    setlength(ar_sf[i].chunks,0);
  setlength(ar_sf,0); }

  //oschishaem pamat' ot massiva tuneley
  for i:=0 to length(ar_tun)-1 do
  begin
    setlength(ar_tun[i].svazi_nach,0);
    setlength(ar_tun[i].svazi_kon,0);
    setlength(ar_tun[i].chunks,0);
  end;
  setlength(ar_tun,0);

  //ochishaem pamat' ot massiva populated dla sveta i skyholes
  setlength(pop_koord,0);

  //ochishaem pamat ot massiva elipsov
  for i:=0 to length(ar_el)-1 do
    setlength(ar_el[i].chunks,0);
  setlength(ar_el,0);

  //ochishaem pamat ot massiva cepey tuneley
  setlength(cep_tun,0);

  //ochishaem massiv isklucheniy
  setlength(iskluch,0);

  //oschishaem massiv dla zemli
  for i:=0 to length(pr_koord_dirt)-1 do
    setlength(pr_koord_dirt[i].chunks,0);
  setlength(pr_koord_dirt,0);

  //ochishaem massivi koordinat dla sveta,skyholes,resursov,derevev
  setlength(pr_koord_lights,0);
  setlength(pr_koord_holes,0);
  setlength(pr_koord_holes_obsh,0);
  setlength(pr_koord_res,0);
  setlength(pr_koord_trees,0);

  //ochishaem pamat ot karti
  for i:=0 to 35 do
    for j:=0 to 35 do
    begin
      clear_all_entities(@map[k][z].entities,@map[k][z].tile_entities);
      setlength(map[i][j].blocks,0);
      setlength(map[i][j].data,0);
      setlength(map[i][j].light,0);
      setlength(map[i][j].skylight,0);
      setlength(map[i][j].heightmap,0);
    end;
  for i:=0 to 35 do
    setlength(map[i],0);
  setlength(map,0);
    endthread(0);
  end;
end;

begin
  param:=parameter;
  par:=param^;

  //smotrim border
  case par.border_par^.border_type of
  1:begin  //wall
      if par.border_par^.wall_void=false then
      begin
        par.border_par^.wall_void:=true;
        par.border_par^.wall_void_thickness:=15;
      end
      else if par.border_par^.wall_void_thickness<15 then
        par.border_par^.wall_void_thickness:=15;
    end;
  2:begin
      par.border_par^.border_type:=1;
      par.border_par^.wall_material:=7;
      par.border_par^.wall_thickness:=1;
      par.border_par^.wall_void:=true;
      if par.border_par^.void_thickness>15 then
        par.border_par^.wall_void_thickness:=par.border_par^.void_thickness
      else
        par.border_par^.wall_void_thickness:=15;
    end
  else
    begin
      par.border_par^.border_type:=1;
      par.border_par^.wall_material:=7;
      par.border_par^.wall_thickness:=1;
      par.border_par^.wall_void_thickness:=15;
      par.border_par^.wall_void:=true;
    end;
  end;

  //kol:=0;
  waterlevel:=10;

  //opredelaem kol-vo region faylov, kotoroe sozdavat
  tempx:=(par.tox-par.fromx+1);      //kol-vo chankov po osam
  tempy:=(par.toy-par.fromy+1);

  //postmessage(par.handle,WM_USER+302,par.id,tempx*tempy);

  postmessage(par.handle,WM_USER+312,0,0);
  //postmessage(par.handle,WM_USER+307,0,0);

  //videlaem pamat pod massiv NBT dla generacii
  setlength(rez,82360);
  //setlength(heightmap,256);

  //videlaem pamat pod kartu
  setlength(map,36);
  for i:=0 to 35 do
    setlength(map[i],36);

  for i:=0 to 35 do
    for j:=0 to 35 do
    begin
      setlength(map[i][j].blocks,32768);
      setlength(map[i][j].data,32768);
      setlength(map[i][j].light,32768);
      setlength(map[i][j].skylight,32768);
      setlength(map[i][j].heightmap,256);
    end;


  {if (par.fromx+par.tox+1)=0 then  //tolko po X, t.k. nuzhno razdelit raznie osi
  begin
    regx:=(tempx div 2) div 32;
    if ((tempx div 2) mod 32)<>0 then inc(regx);
    regx_nach:=-regx;
    regx:=regx*2;
  end
  else
  begin
    regx:= tempx div 32;
    if (tempx mod 32)<>0 then inc(regx);
    if par.fromx<0 then regx_nach:=-regx
    else regx_nach:=0;
  end;

  if (par.fromy+par.toy+1)=0 then  //tolko po Y
  begin
    regy:=(tempy div 2) div 32;
    if ((tempy div 2) mod 32)<>0 then inc(regy);
    regy_nach:=-regy;
    regy:=regy*2;
  end
  else
  begin
    regy:= tempy div 32;
    if (tempy mod 32)<>0 then inc(regy);
    if par.fromy<0 then regy_nach:=-regy
    else regy_nach:=0;
  end;    }

  //postmessage(par.handle,WM_USER+300,1,0);

  RandSeed:=par.sid;
  //sozdaem randomnuyu cep tuneley
  //kol-vo tuneley
  //j:=3+random(5);

  //opredelaem obshee kol-vo chankov na karte
  i:=tempx*tempy;

  //opredelaem kol-vo tuneley, kotoroe nado generit' ishoda iz sootnosheniya 10 chankov=1 tunel
  //j:=i div 10;
  //100% = 1 tunel' na 10 chankov + neskolko ne sgeneriruyutsa

  j:=round((par.tunnel_par^.tun_density/1000)*i);
  j:=round(j+(10*(random*j/100))-(10*(random*j/100)));
  postmessage(par.handle,WM_USER+304,10001,j);

  //j:=j div 3;

  //opredelaem kol-vo cepey tuneley i zapolnaem kol-vom tuneley v kazhdoy cepi
  b1:=false;
  k:=0;
  z:=0;
  tempz:=0; //obshaya summa
  while b1=false do
  begin
    setlength(cep_tun,k+1);
    z:=6+random(13);
    if (tempz+z)>j then z:=j-tempz;

    if z<3 then
    begin
      setlength(cep_tun,k);
      b1:=true;
    end
    else
      cep_tun[k].len:=z;

    inc(k);
    inc(tempz,z);
  end;

  //opredelaem granici koordinat
  tempx:=abs(par.fromx*16);
  tempy:=abs(par.fromy*16);
  //tempk:=(par.tox+1)*16-1;
  //tempz:=(par.toy+1)*16-1;

  //zapolnaem cepi tuneley tunelami
  //setlength(ar_tun,j);
  setlength(ar_tun,0);

  postmessage(par.handle,WM_USER+313,0,0);

  id:=0;

  //cikl po vsem cepam
  for k:=0 to length(cep_tun)-1 do
  begin
    thread_exit(param);

    postmessage(par.handle,WM_USER+314,0,k+1);

    //opredelaem indeks novogo tunela
    if k=0 then cep_tun[k].nach:=0
    else
      cep_tun[k].nach:=cep_tun[k-1].nach+cep_tun[k-1].len;

    inc(id);
    postmessage(par.handle,WM_USER+314,id,0);

    //delaem perviy tunel' v cepi
    setlength(ar_tun,length(ar_tun)+1);
    b1:=true;
    setlength(iskluch,0);
    while b1=true do
    begin
      thread_exit(param);
      ar_tun[cep_tun[k].nach].radius_horiz:=par.tunnel_par^.r_hor_min+random(par.tunnel_par^.r_hor_max-par.tunnel_par^.r_hor_min);
      ar_tun[cep_tun[k].nach].radius_vert:=ar_tun[cep_tun[k].nach].radius_horiz;

      ar_tun[cep_tun[k].nach].x1:=random(tempx-ar_tun[cep_tun[k].nach].radius_horiz-5)-random(tempx-ar_tun[cep_tun[k].nach].radius_horiz-5);
      ar_tun[cep_tun[k].nach].z1:=random(tempy-ar_tun[cep_tun[k].nach].radius_horiz-5)-random(tempy-ar_tun[cep_tun[k].nach].radius_horiz-5);
      ar_tun[cep_tun[k].nach].x2:=random(tempx-ar_tun[cep_tun[k].nach].radius_horiz-5)-random(tempx-ar_tun[cep_tun[k].nach].radius_horiz-5);
      ar_tun[cep_tun[k].nach].z2:=random(tempy-ar_tun[cep_tun[k].nach].radius_horiz-5)-random(tempy-ar_tun[cep_tun[k].nach].radius_horiz-5);
      ar_tun[cep_tun[k].nach].y1:=random(127-2*(ar_tun[cep_tun[k].nach].radius_vert+5))+ar_tun[cep_tun[k].nach].radius_vert+5;
      ar_tun[cep_tun[k].nach].y2:=random(127-2*(ar_tun[cep_tun[k].nach].radius_vert+5))+ar_tun[cep_tun[k].nach].radius_vert+5;
      ar_tun[cep_tun[k].nach].fill_material:=0;

      if ar_tun[cep_tun[k].nach].x1=ar_tun[cep_tun[k].nach].x2 then inc(ar_tun[cep_tun[k].nach].x2);
      if ar_tun[cep_tun[k].nach].y1=ar_tun[cep_tun[k].nach].y2 then inc(ar_tun[cep_tun[k].nach].y2);
      if ar_tun[cep_tun[k].nach].z1=ar_tun[cep_tun[k].nach].z2 then inc(ar_tun[cep_tun[k].nach].z2);

      b1:=tunnel_intersection(ar_tun,cep_tun[k].nach,iskluch);

      if (tunnel_flat_angle(ar_tun,cep_tun[k].nach)>60)or
      (tunnel_length(ar_tun,cep_tun[k].nach)<70) then b1:=true;

      if (b1=false) then
      begin
        setlength(ar_tun[cep_tun[k].nach].svazi_nach,0);
        setlength(ar_tun[cep_tun[k].nach].svazi_kon,0);
      end;
    end;

    //delaem ostal'nie tuneli v cepi
    setlength(iskluch,1);
    for z:=cep_tun[k].nach+1 to cep_tun[k].nach+cep_tun[k].len-1 do
    begin
      thread_exit(param);
      
      inc(id);
      postmessage(par.handle,WM_USER+314,id,0);

      postmessage(par.handle,WM_USER+316,1000,0);

      iskluch[0]:=z-1;
      setlength(ar_tun,length(ar_tun)+1);
      tempz:=1;

      if par.tunnel_par^.round_tun=true then
        b:=true
      else if random(100)<par.tunnel_par^.round_tun_density then
        b:=true
      else b:=false;

      if b=true then
      begin
        ar_tun[z].radius_horiz:=par.tunnel_par^.r_hor_min+random(par.tunnel_par^.r_hor_max-par.tunnel_par^.r_hor_min);
        ar_tun[z].radius_vert:=ar_tun[z].radius_horiz;
      end
      else
      begin
        ar_tun[z].radius_horiz:=par.tunnel_par^.r_hor_min+random(par.tunnel_par^.r_hor_max-par.tunnel_par^.r_hor_min);
        ar_tun[z].radius_vert:=par.tunnel_par^.r_vert_min+random(par.tunnel_par^.r_vert_max-par.tunnel_par^.r_vert_min);
      end;

    nach:
      postmessage(par.handle,WM_USER+317,tempz,0);

      //ar_tun[z].x1:=random(tempx-ar_tun[z].radius_horiz-5)-random(tempx-ar_tun[z].radius_horiz-5);
      ar_tun[z].x1:=ar_tun[z-1].x2;
      ar_tun[z].x2:=random(tempx-ar_tun[z].radius_horiz-5)-random(tempx-ar_tun[z].radius_horiz-5);
      //ar_tun[z].z1:=random(tempx-ar_tun[z].radius_horiz-5)-random(tempx-ar_tun[z].radius_horiz-5);
      ar_tun[z].z1:=ar_tun[z-1].z2;
      ar_tun[z].z2:=random(tempy-ar_tun[z].radius_horiz-5)-random(tempy-ar_tun[z].radius_horiz-5);
      //ar_tun[z].y1:=random(127-2*(ar_tun[z].radius_vert+5))+ar_tun[z].radius_vert+5;
      ar_tun[z].y1:=ar_tun[z-1].y2;
      ar_tun[z].y2:=random(127-2*(max(ar_tun[z].radius_vert,ar_tun[z].radius_horiz)+5))+max(ar_tun[z].radius_vert,ar_tun[z].radius_horiz)+5;
      ar_tun[z].fill_material:=0;

      if ar_tun[z].x1=ar_tun[z].x2 then inc(ar_tun[z].x2);
      if ar_tun[z].y1=ar_tun[z].y2 then inc(ar_tun[z].y2);
      if ar_tun[z].z1=ar_tun[z].z2 then inc(ar_tun[z].z2);

      angle:=tunnel_length(ar_tun,z);
      if (angle<70)or(angle>600) then goto nach;

      b1:=tunnel_intersection2(ar_tun,z,iskluch);

      if (tempz mod 1000)=0 then
      begin
        postmessage(par.handle,WM_USER+305,z,12345);
        dec(id);
        setlength(ar_tun,length(ar_tun)-1);
        //cep_tun[k].len:=length(ar_tun);
        if k=0 then cep_tun[k].len:=length(ar_tun)
          else cep_tun[k].len:=z-cep_tun[k].nach;
        break;
      end;

      if b1=true then
      begin
        inc(tempz);
        goto nach;
      end;

      postmessage(par.handle,WM_USER+304,z+2000,round(angle));

      angle:=180-tunnel_angle(ar_tun,z-1,z);
      postmessage(par.handle,WM_USER+304,z,round(angle));
      if angle<30 then goto nach;

      angle:=tunnel_flat_angle(ar_tun,z);
      postmessage(par.handle,WM_USER+304,z+1000,round(angle));
      if angle>60 then goto nach;

      postmessage(par.handle,WM_USER+317,1000,0);

      if ((min(ar_tun[z].y1,ar_tun[z].y2)-5-max(ar_tun[z].radius_horiz,ar_tun[z].radius_vert))<0)or
      ((max(ar_tun[z].y1,ar_tun[z].y2)+5+max(ar_tun[z].radius_horiz,ar_tun[z].radius_vert))>126) then
      begin
        ar_tun[z].radius_horiz:=ar_tun[z-1].radius_horiz;
        ar_tun[z].radius_vert:=ar_tun[z-1].radius_vert;
      end;

      tempk:=length(ar_tun[z-1].svazi_kon);
      setlength(ar_tun[z-1].svazi_kon,tempk+1);
      ar_tun[z-1].svazi_kon[tempk]:=@ar_tun[z];

      tempk:=length(ar_tun[z].svazi_nach);
      setlength(ar_tun[z].svazi_nach,tempk+1);
      ar_tun[z].svazi_nach[tempk]:=@ar_tun[z-1];
    end;

  end;

  setlength(iskluch,0);

  //soedinaem neskolko cepey tuneley esli ne postavlena galochka v forme nastroek
  if par.tunnel_par^.gen_seperate=false then
  for i:=0 to length(cep_tun)-2 do
    for tempz:=i+1 to length(cep_tun)-1 do
  begin
    b1:=false;
    z:=length(ar_tun);
    setlength(ar_tun,z+1);

    //soedinaem cep' i s i+1
    for j:=cep_tun[i].nach to cep_tun[i].nach+cep_tun[i].len-1 do
    begin
      if b1=true then break;
      for k:=cep_tun[tempz].nach to cep_tun[tempz].nach+cep_tun[tempz].len-1 do
      begin
        thread_exit(param);

        tempx:=2;
        if j<>cep_tun[i].nach then inc(tempx);
        if k<>cep_tun[tempz].nach then inc(tempx);
        setlength(iskluch,tempx);
        tempx:=0;
        iskluch[tempx]:=j;
        inc(tempx);
        iskluch[tempx]:=k;
        inc(tempx);
        if j<>cep_tun[i].nach then
        begin
          iskluch[tempx]:=j-1;
          inc(tempx);
        end;
        if k<>cep_tun[tempz].nach then
          iskluch[tempx]:=k-1;

        //soedinaem nachalo s nachalom
        ar_tun[z].x1:=ar_tun[j].x1;
        ar_tun[z].y1:=ar_tun[j].y1;
        ar_tun[z].z1:=ar_tun[j].z1;
        ar_tun[z].x2:=ar_tun[k].x1;
        ar_tun[z].y2:=ar_tun[k].y1;
        ar_tun[z].z2:=ar_tun[k].z1;
        ar_tun[z].radius_horiz:=max(max(ar_tun[j].radius_horiz,ar_tun[k].radius_horiz),max(ar_tun[j].radius_vert,ar_tun[k].radius_vert));
        ar_tun[z].radius_vert:=ar_tun[z].radius_horiz;
        ar_tun[z].fill_material:=0;
        if ar_tun[z].x1=ar_tun[z].x2 then inc(ar_tun[z].x2);
        if ar_tun[z].y1=ar_tun[z].y2 then inc(ar_tun[z].y2);
        if ar_tun[z].z1=ar_tun[z].z2 then inc(ar_tun[z].z2);

        angle2:=tunnel_angle(ar_tun,z,j);
        angle:=180-tunnel_angle(ar_tun,z,k);
        if angle<angle2 then angle2:=angle;
        if j<>cep_tun[i].nach then angle:=180-tunnel_angle(ar_tun,z,j-1);
        if angle<angle2 then angle2:=angle;
        if k<>cep_tun[tempz].nach then angle:=tunnel_angle(ar_tun,z,k-1);
        if angle<angle2 then angle2:=angle;

        if (tunnel_intersection2(ar_tun,z,iskluch)=false)and
        (tunnel_flat_angle(ar_tun,z)<60)and
        (tunnel_length(ar_tun,z)>30)and
        (angle2>30) then
        begin
          b1:=true;
          inc(id);
          postmessage(par.handle,WM_USER+314,id,0);
          //prisoedinili tunel' k nachalu tunela j i nachalu tunela k
          //prisoedinaem tunel' k nachalu tunela j
          tempk:=length(ar_tun[j].svazi_nach);
          setlength(ar_tun[j].svazi_nach,tempk+1);
          ar_tun[j].svazi_nach[tempk]:=@ar_tun[z];
          //prisoedinaem tunel' k koncu tunela j-1 esli on est'
          if j<>cep_tun[i].nach then
          begin
            tempk:=length(ar_tun[j-1].svazi_kon);
            setlength(ar_tun[j-1].svazi_kon,tempk+1);
            ar_tun[j-1].svazi_kon[tempk]:=@ar_tun[z];
          end;
          //prisoedinaem tunel' k nachalu tunela k
          tempk:=length(ar_tun[k].svazi_nach);
          setlength(ar_tun[k].svazi_nach,tempk+1);
          ar_tun[k].svazi_nach[tempk]:=@ar_tun[z];
          //prisoedinaem tunel' k konsu tunela k-1 esli on est'
          if k<>cep_tun[tempz].nach then
          begin
            tempk:=length(ar_tun[k-1].svazi_kon);
            setlength(ar_tun[k-1].svazi_kon,tempk+1);
            ar_tun[k-1].svazi_kon[tempk]:=@ar_tun[z];
          end;
          break;
        end
        else
        begin
          //soedinaem nachalo s koncom
          tempx:=2;
          if j<>cep_tun[i].nach then inc(tempx);
          if k<>(cep_tun[tempz].nach+cep_tun[tempz].len-1) then inc(tempx);
          setlength(iskluch,tempx);
          tempx:=0;
          iskluch[tempx]:=j;
          inc(tempx);
          iskluch[tempx]:=k;
          inc(tempx);
          if j<>cep_tun[i].nach then
          begin
            iskluch[tempx]:=j-1;
            inc(tempx);
          end;
          if k<>(cep_tun[tempz].nach+cep_tun[tempz].len-1) then
            iskluch[tempx]:=k+1;

          ar_tun[z].x1:=ar_tun[j].x1;
          ar_tun[z].y1:=ar_tun[j].y1;
          ar_tun[z].z1:=ar_tun[j].z1;
          ar_tun[z].x2:=ar_tun[k].x2;
          ar_tun[z].y2:=ar_tun[k].y2;
          ar_tun[z].z2:=ar_tun[k].z2;
          ar_tun[z].radius_horiz:=max(max(ar_tun[j].radius_horiz,ar_tun[k].radius_horiz),max(ar_tun[j].radius_vert,ar_tun[k].radius_vert));
          ar_tun[z].radius_vert:=ar_tun[z].radius_horiz;
          ar_tun[z].fill_material:=0;
          if ar_tun[z].x1=ar_tun[z].x2 then inc(ar_tun[z].x2);
          if ar_tun[z].y1=ar_tun[z].y2 then inc(ar_tun[z].y2);
          if ar_tun[z].z1=ar_tun[z].z2 then inc(ar_tun[z].z2);

          angle2:=tunnel_angle(ar_tun,z,j);
          angle:=tunnel_angle(ar_tun,z,k);
          if angle<angle2 then angle2:=angle;
          if j<>cep_tun[i].nach then angle:=180-tunnel_angle(ar_tun,z,j-1);
          if angle<angle2 then angle2:=angle;
          if k<>(cep_tun[tempz].nach+cep_tun[tempz].len-1) then angle:=180-tunnel_angle(ar_tun,z,k+1);
          if angle<angle2 then angle2:=angle;

          if (tunnel_intersection2(ar_tun,z,iskluch)=false)and
          (tunnel_flat_angle(ar_tun,z)<60)and
          (tunnel_length(ar_tun,z)>30)and
          (angle>30) then
          begin
            b1:=true;
            inc(id);
            postmessage(par.handle,WM_USER+314,id,0);
            //prisoedinili tunel' k nachalu tunela j i nachalu tunela k
            //prisoedinaem tunel' k nachalu tunela j
            tempk:=length(ar_tun[j].svazi_nach);
            setlength(ar_tun[j].svazi_nach,tempk+1);
            ar_tun[j].svazi_nach[tempk]:=@ar_tun[z];
            //prisoedinaem tunel' k koncu tunela j-1 esli on est'
            if j<>cep_tun[i].nach then
            begin
              tempk:=length(ar_tun[j-1].svazi_kon);
              setlength(ar_tun[j-1].svazi_kon,tempk+1);
              ar_tun[j-1].svazi_kon[tempk]:=@ar_tun[z];
            end;
            //prisoedinaem tunel' k koncu tunela k
            tempk:=length(ar_tun[k].svazi_kon);
            setlength(ar_tun[k].svazi_kon,tempk+1);
            ar_tun[k].svazi_kon[tempk]:=@ar_tun[z];
            //prisoedinaem tunel' k nachalu tunela k+1 esli on est'
            if k<>(cep_tun[tempz].nach+cep_tun[tempz].len-1) then
            begin
              tempk:=length(ar_tun[k+1].svazi_nach);
              setlength(ar_tun[k+1].svazi_nach,tempk+1);
              ar_tun[k+1].svazi_nach[tempk]:=@ar_tun[z];
            end;
            break;
          end
          else
          begin
            //soedinaem konec s nachalom
            tempx:=2;
            if j<>(cep_tun[i].nach+cep_tun[i].len-1) then inc(tempx);
            if k<>cep_tun[tempz].nach then inc(tempx);
            setlength(iskluch,tempx);
            tempx:=0;
            iskluch[tempx]:=j;
            inc(tempx);
            iskluch[tempx]:=k;
            inc(tempx);
            if j<>(cep_tun[i].nach+cep_tun[i].len-1) then
            begin
              iskluch[tempx]:=j+1;
              inc(tempx);
            end;
            if k<>cep_tun[tempz].nach then
              iskluch[tempx]:=k-1;

            ar_tun[z].x1:=ar_tun[j].x2;
            ar_tun[z].y1:=ar_tun[j].y2;
            ar_tun[z].z1:=ar_tun[j].z2;
            ar_tun[z].x2:=ar_tun[k].x1;
            ar_tun[z].y2:=ar_tun[k].y1;
            ar_tun[z].z2:=ar_tun[k].z1;
            ar_tun[z].radius_horiz:=max(max(ar_tun[j].radius_horiz,ar_tun[k].radius_horiz),max(ar_tun[j].radius_vert,ar_tun[k].radius_vert));
            ar_tun[z].radius_vert:=ar_tun[z].radius_horiz;
            ar_tun[z].fill_material:=0;
            if ar_tun[z].x1=ar_tun[z].x2 then inc(ar_tun[z].x2);
            if ar_tun[z].y1=ar_tun[z].y2 then inc(ar_tun[z].y2);
            if ar_tun[z].z1=ar_tun[z].z2 then inc(ar_tun[z].z2);

            angle2:=180-tunnel_angle(ar_tun,z,j);
            angle:=180-tunnel_angle(ar_tun,z,k);
            if angle<angle2 then angle2:=angle;
            if j<>(cep_tun[i].nach+cep_tun[i].len-1) then angle:=tunnel_angle(ar_tun,z,j+1);
            if angle<angle2 then angle2:=angle;
            if k<>cep_tun[tempz].nach then angle:=tunnel_angle(ar_tun,z,k-1);
            if angle<angle2 then angle2:=angle;

            if (tunnel_intersection2(ar_tun,z,iskluch)=false)and
            (tunnel_flat_angle(ar_tun,z)<60)and
            (tunnel_length(ar_tun,z)>30)and
            (angle>30) then
            begin
              b1:=true;
              inc(id);
              postmessage(par.handle,WM_USER+314,id,0);
              //prisoedinaem tunel' k koncu tunela j
              tempk:=length(ar_tun[j].svazi_kon);
              setlength(ar_tun[j].svazi_kon,tempk+1);
              ar_tun[j].svazi_kon[tempk]:=@ar_tun[z];
              //prisoedinaem tunel' k nachalu tunela j+1 esli on est'
              if j<>(cep_tun[i].nach+cep_tun[i].len-1) then
              begin
                tempk:=length(ar_tun[j+1].svazi_nach);
                setlength(ar_tun[j+1].svazi_nach,tempk+1);
                ar_tun[j+1].svazi_nach[tempk]:=@ar_tun[z];
              end;
              //prisoedinaem tunel' k nachalu tunela k
              tempk:=length(ar_tun[k].svazi_nach);
              setlength(ar_tun[k].svazi_nach,tempk+1);
              ar_tun[k].svazi_nach[tempk]:=@ar_tun[z];
              //prisoedinaem tunel' k koncu tunela k-1 esli on est'
              if k<>cep_tun[tempz].nach then
              begin
                tempk:=length(ar_tun[k-1].svazi_kon);
                setlength(ar_tun[k-1].svazi_kon,tempk+1);
                ar_tun[k-1].svazi_kon[tempk]:=@ar_tun[z];
              end;
              break;
            end
            else
            begin
              //soedinaem konec s koncom
              tempx:=2;
              if j<>(cep_tun[i].nach+cep_tun[i].len-1) then inc(tempx);
              if k<>(cep_tun[tempz].nach+cep_tun[tempz].len-1) then inc(tempx);
              setlength(iskluch,tempx);
              tempx:=0;
              iskluch[tempx]:=j;
              inc(tempx);
              iskluch[tempx]:=k;
              inc(tempx);
              if j<>(cep_tun[i].nach+cep_tun[i].len-1) then
              begin
                iskluch[tempx]:=j-1;
                inc(tempx);
              end;
              if k<>(cep_tun[tempz].nach+cep_tun[tempz].len-1) then
                iskluch[tempx]:=k-1;

              ar_tun[z].x1:=ar_tun[j].x2;
              ar_tun[z].y1:=ar_tun[j].y2;
              ar_tun[z].z1:=ar_tun[j].z2;
              ar_tun[z].x2:=ar_tun[k].x2;
              ar_tun[z].y2:=ar_tun[k].y2;
              ar_tun[z].z2:=ar_tun[k].z2;
              ar_tun[z].radius_horiz:=max(max(ar_tun[j].radius_horiz,ar_tun[k].radius_horiz),max(ar_tun[j].radius_vert,ar_tun[k].radius_vert));
              ar_tun[z].radius_vert:=ar_tun[z].radius_horiz;
              ar_tun[z].fill_material:=0;
              if ar_tun[z].x1=ar_tun[z].x2 then inc(ar_tun[z].x2);
              if ar_tun[z].y1=ar_tun[z].y2 then inc(ar_tun[z].y2);
              if ar_tun[z].z1=ar_tun[z].z2 then inc(ar_tun[z].z2);

              angle2:=180-tunnel_angle(ar_tun,z,j);
              angle:=tunnel_angle(ar_tun,z,k);
              if angle<angle2 then angle2:=angle;
              if j<>(cep_tun[i].nach+cep_tun[i].len-1) then angle:=tunnel_angle(ar_tun,z,j+1);
              if angle<angle2 then angle2:=angle;
              if k<>(cep_tun[tempz].nach+cep_tun[tempz].len-1) then angle:=180-tunnel_angle(ar_tun,z,k+1);
              if angle<angle2 then angle2:=angle;

              if (tunnel_intersection2(ar_tun,z,iskluch)=false)and
              (tunnel_flat_angle(ar_tun,z)<60)and
              (tunnel_length(ar_tun,z)>30)and
              (angle>30) then
              begin
                b1:=true;
                inc(id);
                postmessage(par.handle,WM_USER+314,id,0);
                //prisoedinaem tunel' k koncu tunela j
                tempk:=length(ar_tun[j].svazi_kon);
                setlength(ar_tun[j].svazi_kon,tempk+1);
                ar_tun[j].svazi_kon[tempk]:=@ar_tun[z];
                //prisoedinaem tunel' k nachalu tunela j+1 esli on est'
                if j<>(cep_tun[i].nach+cep_tun[i].len-1) then
                begin
                  tempk:=length(ar_tun[j+1].svazi_nach);
                  setlength(ar_tun[j+1].svazi_nach,tempk+1);
                  ar_tun[j+1].svazi_nach[tempk]:=@ar_tun[z];
                end;
                //prisoedinaem tunel' k koncu tunela k
                tempk:=length(ar_tun[k].svazi_kon);
                setlength(ar_tun[k].svazi_kon,tempk+1);
                ar_tun[k].svazi_kon[tempk]:=@ar_tun[z];
                //prisoedinaem tunel' k nachalu tunela k+1 esli on est'
                if k<>(cep_tun[tempz].nach+cep_tun[tempz].len-1) then
                begin
                  tempk:=length(ar_tun[k+1].svazi_nach);
                  setlength(ar_tun[k+1].svazi_nach,tempk+1);
                  ar_tun[k+1].svazi_nach[tempk]:=@ar_tun[z];
                end;
                break;
              end;
            end;
          end;
        end;

      end;
    end;
    if b1=false then setlength(ar_tun,z);

  end;

  setlength(iskluch,0);

  //ishem vtoruyu po glubine tochku tuneley
  tempx:=127;
  tempy:=127;

  for i:=0 to length(ar_tun)-1 do
  begin
    if ar_tun[i].y1<tempx then tempx:=ar_tun[i].y1;
    if ar_tun[i].y2<tempx then tempx:=ar_tun[i].y2;
  end;

  for i:=0 to length(ar_tun)-1 do
  begin
    if (ar_tun[i].y1<tempy)and(ar_tun[i].y1<>tempx) then tempy:=ar_tun[i].y1;
    if (ar_tun[i].y2<tempy)and(ar_tun[i].y2<>tempx) then tempy:=ar_tun[i].y2;
  end;

  if tempy>40 then waterlevel:=0
  else waterlevel:=tempy;

  for i:=0 to length(ar_tun)-1 do
    if ((ar_tun[i].y1-ar_tun[i].radius_vert)<waterlevel)or
    ((ar_tun[i].y2-ar_tun[i].radius_vert)<waterlevel) then
    begin
      ar_tun[i].flooded_nat:=true;
      ar_tun[i].waterlevel_nat:=waterlevel;
      ar_tun[i].flooded_unnat:=false;
      ar_tun[i].waterlevel_unnat:=0;
    end
    else
    begin
      ar_tun[i].flooded_nat:=false;
      ar_tun[i].waterlevel_nat:=0;
      ar_tun[i].flooded_unnat:=false;
      ar_tun[i].waterlevel_unnat:=0;
    end;
            
  postmessage(par.handle,WM_USER+316,0,0);


  {setlength(ar_tun,3);

  ar_tun[0].x1:=-20;
  ar_tun[0].y1:=80;
  ar_tun[0].z1:=50;
  ar_tun[0].x2:=-70;
  ar_tun[0].y2:=50;
  ar_tun[0].z2:=-50;
  ar_tun[0].radius_horiz:=12;
  ar_tun[0].radius_vert:=12;
  ar_tun[0].fill_material:=0;
  setlength(ar_tun[0].svazi_kon,1);
  ar_tun[0].svazi_kon[0]:=@ar_tun[1];
  ar_tun[0].waterlevel:=0;

  ar_tun[1].x1:=-70;
  ar_tun[1].y1:=50;
  ar_tun[1].z1:=-50;
  ar_tun[1].x2:=40;
  ar_tun[1].y2:=60;
  ar_tun[1].z2:=-40;
  ar_tun[1].radius_horiz:=30;
  ar_tun[1].radius_vert:=30;
  ar_tun[1].fill_material:=0;
  setlength(ar_tun[1].svazi_nach,1);
  ar_tun[1].svazi_nach[0]:=@ar_tun[0];
  setlength(ar_tun[1].svazi_kon,1);
  ar_tun[1].svazi_kon[0]:=@ar_tun[2];
  ar_tun[1].waterlevel:=0;

  ar_tun[2].x1:=40;
  ar_tun[2].y1:=60;
  ar_tun[2].z1:=-40;
  ar_tun[2].x2:=20;
  ar_tun[2].y2:=70;
  ar_tun[2].z2:=80;
  ar_tun[2].radius_horiz:=8;
  ar_tun[2].radius_vert:=8;
  ar_tun[2].fill_material:=0;
  setlength(ar_tun[2].svazi_nach,1);
  ar_tun[2].svazi_nach[0]:=@ar_tun[1];
  ar_tun[3].waterlevel:=0;

  {setlength(ar_tun,1);

  ar_tun[0].x1:=10;
  ar_tun[0].y1:=80;
  ar_tun[0].z1:=10;
  ar_tun[0].x2:=50;
  ar_tun[0].y2:=80;
  ar_tun[0].z2:=50;
  ar_tun[0].radius_horiz:=5;
  ar_tun[0].radius_vert:=5;
  ar_tun[0].fill_material:=0;  }


  //for i:=cep_tun[0].nach to cep_tun[0].nach+cep_tun[0].len-1 do
  // ar_tun[i].fill_material:=20;
  

  (*setlength(ar_sf,length(ar_tun)+1);

  ar_sf[0].x:=ar_tun[0].x1;
  ar_sf[0].z:=ar_tun[0].z1;
  ar_sf[0].y:=ar_tun[0].y1;
  ar_sf[0].radius:=max(ar_tun[0].radius_horiz,ar_tun[0].radius_vert)-1;
  ar_sf[0].material_shell:=0;
  ar_sf[0].material_fill:=0;
  ar_sf[0].material_thick:=1;
  ar_sf[0].fill_level:=ar_sf[0].radius*2-1;

  for i:=0 to length(ar_tun)-1 do
  begin
    ar_sf[i+1].x:=ar_tun[i].x2;
    ar_sf[i+1].y:=ar_tun[i].y2;
    ar_sf[i+1].z:=ar_tun[i].z2;
    k:=max(ar_tun[i].radius_horiz,ar_tun[i].radius_vert);
    for j:=0 to length(ar_tun[i].svazi_kon)-1 do
      if max(ar_tun[i].svazi_kon[j]^.radius_horiz,ar_tun[i].svazi_kon[j]^.radius_vert)>k
      then k:=max(ar_tun[i].svazi_kon[j]^.radius_horiz,ar_tun[i].svazi_kon[j]^.radius_vert);
    ar_sf[i+1].radius:=k-1;
    ar_sf[i+1].material_shell:=0;
    ar_sf[i+1].material_fill:=0;
    ar_sf[i+1].material_thick:=1;
    ar_sf[i+1].fill_level:=ar_sf[i+1].radius*2-1;
  end;   *)

  {if par.tunnel_par^.gen_hub=true then
  begin
    k:=1;
    setlength(ar_el,k);
    //testovaya sfera haba
    ar_el[0].x:=0;
    ar_el[0].y:=64;
    ar_el[0].z:=0;
    ar_el[0].radius_x:=53;
    ar_el[0].radius_z:=53;
    ar_el[0].radius_vert:=53;
    ar_el[0].fill_material:=0;
    ar_el[0].flooded:=true;
    ar_el[0].waterlevel:=0;
  end
  else
  begin   }
    k:=0;
    setlength(ar_el,k);
  //end;

  for i:=0 to length(ar_tun)-1 do
  begin
    if ar_tun[i].nach_sfera=nil then
    begin
      inc(k);
      setlength(ar_el,k);
      ar_el[k-1].x:=ar_tun[i].x1;
      ar_el[k-1].y:=ar_tun[i].y1;
      ar_el[k-1].z:=ar_tun[i].z1;
      z:=max(ar_tun[i].radius_horiz,ar_tun[i].radius_vert);
      for j:=0 to length(ar_tun[i].svazi_nach)-1 do
        if max(ar_tun[i].svazi_nach[j]^.radius_horiz,ar_tun[i].svazi_nach[j]^.radius_vert)>z then
          z:=max(ar_tun[i].svazi_nach[j]^.radius_horiz,ar_tun[i].svazi_nach[j]^.radius_vert);
      ar_el[k-1].radius_x:=z-1;
      ar_el[k-1].radius_z:=z-1;
      ar_el[k-1].radius_vert:=z-1;
      ar_el[k-1].fill_material:=0;

      b:=(ar_tun[i].flooded_nat=true)or(ar_tun[i].flooded_unnat=true);
      tempx:=max(ar_tun[i].waterlevel_nat,ar_tun[i].waterlevel_unnat);
      for j:=0 to length(ar_tun[i].svazi_nach)-1 do
        if (ar_tun[i].svazi_nach[j]^.flooded_nat)or(ar_tun[i].svazi_nach[j]^.flooded_unnat) then
        begin
          b:=true;
          tempx:=max(tempx,max(ar_tun[i].svazi_nach[j]^.waterlevel_nat,ar_tun[i].svazi_nach[j]^.waterlevel_unnat));
        end;
      if b=true then
      begin
        ar_el[k-1].flooded:=true;
        ar_el[k-1].waterlevel:=tempx;
      end
      else
        ar_el[k-1].flooded:=false;

      ar_tun[i].nach_sfera:=@ar_el[k-1];
      for j:=0 to length(ar_tun[i].svazi_nach)-1 do
        if (ar_tun[i].svazi_nach[j]^.x1=ar_el[k-1].x)and
        (ar_tun[i].svazi_nach[j]^.y1=ar_el[k-1].y)and
        (ar_tun[i].svazi_nach[j]^.z1=ar_el[k-1].z) then
          ar_tun[i].svazi_nach[j]^.nach_sfera:=@ar_el[k-1]
        else
          ar_tun[i].svazi_nach[j]^.kon_sfera:=@ar_el[k-1];
    end;

    if ar_tun[i].kon_sfera=nil then
    begin
      inc(k);
      setlength(ar_el,k);
      ar_el[k-1].x:=ar_tun[i].x2;
      ar_el[k-1].y:=ar_tun[i].y2;
      ar_el[k-1].z:=ar_tun[i].z2;
      z:=max(ar_tun[i].radius_horiz,ar_tun[i].radius_vert);
      for j:=0 to length(ar_tun[i].svazi_kon)-1 do
        if max(ar_tun[i].svazi_kon[j]^.radius_horiz,ar_tun[i].svazi_kon[j]^.radius_vert)>z then
          z:=max(ar_tun[i].svazi_kon[j]^.radius_horiz,ar_tun[i].svazi_kon[j]^.radius_vert);
      ar_el[k-1].radius_x:=z-1;
      ar_el[k-1].radius_z:=z-1;
      ar_el[k-1].radius_vert:=z-1;
      ar_el[k-1].fill_material:=0;

      b:=(ar_tun[i].flooded_nat=true)or(ar_tun[i].flooded_unnat=true);
      tempx:=max(ar_tun[i].waterlevel_nat,ar_tun[i].waterlevel_unnat);
      for j:=0 to length(ar_tun[i].svazi_kon)-1 do
        if (ar_tun[i].svazi_kon[j]^.flooded_nat)or(ar_tun[i].svazi_kon[j]^.flooded_unnat) then
        begin
          b:=true;
          tempx:=max(tempx,max(ar_tun[i].svazi_kon[j]^.waterlevel_nat,ar_tun[i].svazi_kon[j]^.waterlevel_unnat));
        end;
      if b=true then
      begin
        ar_el[k-1].flooded:=true;
        ar_el[k-1].waterlevel:=tempx;
      end
      else
        ar_el[k-1].flooded:=false;

      ar_tun[i].kon_sfera:=@ar_el[k-1];
      for j:=0 to length(ar_tun[i].svazi_kon)-1 do
        if (ar_tun[i].svazi_kon[j]^.x1=ar_el[k-1].x)and
        (ar_tun[i].svazi_kon[j]^.y1=ar_el[k-1].y)and
        (ar_tun[i].svazi_kon[j]^.z1=ar_el[k-1].z) then
          ar_tun[i].svazi_kon[j]^.nach_sfera:=@ar_el[k-1]
        else
          ar_tun[i].svazi_kon[j]^.kon_sfera:=@ar_el[k-1];
    end;
  end;

  //ishem sovpadayushie sferi
  for i:=0 to length(ar_el)-2 do
  begin
    //if ar_el[i].y=1000 then continue;
    for k:=i+1 to length(ar_el)-1 do
    begin
      //if ar_el[k].y=1000 then continue;

      if (ar_el[i].x=ar_el[k].x)and(ar_el[i].y=ar_el[k].y)and
      (ar_el[i].z=ar_el[k].z) then
      begin
        if (ar_el[i].flooded=true)or(ar_el[k].flooded=true) then
        begin
          ar_el[i].flooded:=true;
          ar_el[i].waterlevel:=max(ar_el[i].waterlevel,ar_el[k].waterlevel);
          ar_el[k].flooded:=true;
          ar_el[k].waterlevel:=max(ar_el[i].waterlevel,ar_el[k].waterlevel);
        end;
        //ar_el[k].y:=1000;
        //break;
      end;
    end;
  end;

  {//udalaem lishnie sferi
  k:=0;
  repeat
    if ar_el[k].y=1000 then
    begin
      //setlength(arobsh[k].chunks,0);
      if k<>(length(ar_el)-1) then
        move(ar_el[k+1],ar_el[k],(length(ar_el)-k-1)*sizeof(elipse_settings));
      setlength(ar_el,length(ar_el)-1);
    end
    else
      inc(k);
  until k>(length(ar_el)-1);  }



  {setlength(ar_el,length(ar_tun)+1);

  ar_el[0].x:=ar_tun[0].x1;
  ar_el[0].z:=ar_tun[0].z1;
  ar_el[0].y:=ar_tun[0].y1;
  ar_el[0].radius_x:=max(ar_tun[0].radius_horiz,ar_tun[0].radius_vert)-1;
  ar_el[0].radius_z:=ar_el[0].radius_x;
  ar_el[0].radius_vert:=ar_el[0].radius_x;
  ar_el[0].fill_material:=0;

  for i:=0 to length(ar_tun)-1 do
  begin
    ar_el[i+1].x:=ar_tun[i].x2;
    ar_el[i+1].y:=ar_tun[i].y2;
    ar_el[i+1].z:=ar_tun[i].z2;
    k:=max(ar_tun[i].radius_horiz,ar_tun[i].radius_vert);
    for j:=0 to length(ar_tun[i].svazi_kon)-1 do
      if max(ar_tun[i].svazi_kon[j]^.radius_horiz,ar_tun[i].svazi_kon[j]^.radius_vert)>k
      then k:=max(ar_tun[i].svazi_kon[j]^.radius_horiz,ar_tun[i].svazi_kon[j]^.radius_vert);
    ar_el[i+1].radius_x:=k-1;
    ar_el[i+1].radius_z:=ar_el[i+1].radius_x;
    ar_el[i+1].radius_vert:=ar_el[i+1].radius_x;
    ar_el[i+1].fill_material:=0;
  end;  }

  calc_cos_tun(ar_tun);

  {for i:=0 to length(ar_tun)-1 do
    tunnel_sphere_intersection(ar_tun,i,@ar_sf);}

  {setlength(ar_el,1);

  ar_el[0].x:=20;
  ar_el[0].y:=50;
  ar_el[0].z:=20;
  ar_el[0].radius_x:=10;
  ar_el[0].radius_z:=7;
  ar_el[0].radius_vert:=4;
  ar_el[0].fill_material:=0;

  setlength(ar_el[0].chunks,4);
  ar_el[0].chunks[0].x:=0;
  ar_el[0].chunks[0].y:=0;
  ar_el[0].chunks[1].x:=1;
  ar_el[0].chunks[1].y:=0;
  ar_el[0].chunks[2].x:=0;
  ar_el[0].chunks[2].y:=1;
  ar_el[0].chunks[3].x:=1;
  ar_el[0].chunks[3].y:=1;     }

  {i:=length(ar_sf);
  setlength(ar_sf,i+1);

  ar_sf[i].x:=40;
  ar_sf[i].z:=-38;
  ar_sf[i].y:=60;
  ar_sf[i].radius:=10;
  ar_sf[i].material_shell:=3;
  ar_sf[i].material_fill:=0;
  ar_sf[i].material_thick:=1;
  ar_sf[i].fill_level:=ar_sf[i].radius*2-1; }

  {ar_tun[0].x1:=100;
  ar_tun[0].z1:=10;
  ar_tun[0].y1:=80;
  ar_tun[0].x2:=-10;
  ar_tun[0].z2:=10;
  ar_tun[0].y2:=50;
  ar_tun[0].radius_horiz:=5;
  ar_tun[0].radius_vert:=5;
  ar_tun[0].fill_material:=0;
  //sdelat' chanki

  ar_tun[1].x1:=-10;
  ar_tun[1].z1:=10;
  ar_tun[1].y1:=50;
  ar_tun[1].x2:=100;
  ar_tun[1].z2:=10;
  ar_tun[1].y2:=20;
  ar_tun[1].radius_horiz:=5;
  ar_tun[1].radius_vert:=5;
  ar_tun[1].fill_material:=0;   }
  //sdelat' chanki

  //delaem testovie sferi
  {setlength(ar_sf,1);
  ar_sf[0].x:=60;
  ar_sf[0].z:=30;
  ar_sf[0].y:=70;
  ar_sf[0].radius:=5;
  ar_sf[0].material_shell:=0;
  ar_sf[0].material_fill:=0;
  ar_sf[0].material_thick:=1;
  ar_sf[0].fill_level:=ar_sf[0].radius*2-1;    }


  //angle:=tunnel_angle(ar_tun,0,1);
  //postmessage(par.handle,WM_USER+304,6666,round(angle));

  fill_tun_chunks(ar_tun);
 { for k:=0 to length(ar_tun)-1 do
  begin
    //opredelaem kraynie koordinati po dvum osam

      tempx:=min(ar_tun[k].x1,ar_tun[k].x2)-ar_tun[k].radius_horiz;
      tempk:=max(ar_tun[k].x1,ar_tun[k].x2)+ar_tun[k].radius_horiz;
      tempy:=min(ar_tun[k].z1,ar_tun[k].z2)-ar_tun[k].radius_horiz;
      tempz:=max(ar_tun[k].z1,ar_tun[k].z2)+ar_tun[k].radius_horiz;

      //perevodim koordinati v chanki
      if tempx<0 then inc(tempx);
      if tempk<0 then inc(tempk);
      if tempy<0 then inc(tempy);
      if tempz<0 then inc(tempz);

      //zapisivaem koordinati
      tempx:=tempx div 16;
      tempk:=tempk div 16;
      tempy:=tempy div 16;
      tempz:=tempz div 16;

      //zapisivaem massiv koordinat v tekushuyu zapis'
      //popravka na minusovie chanki
      if (tempx<=0)and((min(ar_tun[k].x1,ar_tun[k].x2)-ar_tun[k].radius_horiz)<0) then tempx:=tempx-1;
      if (tempk<=0)and((max(ar_tun[k].x1,ar_tun[k].x2)+ar_tun[k].radius_horiz)<0) then tempk:=tempk-1;
      if (tempy<=0)and((min(ar_tun[k].z1,ar_tun[k].z2)-ar_tun[k].radius_horiz)<0) then tempy:=tempy-1;
      if (tempz<=0)and((max(ar_tun[k].z1,ar_tun[k].z2)+ar_tun[k].radius_horiz)<0) then tempz:=tempz-1;

      //videlaem pamat'
      setlength(ar_tun[k].chunks,(tempk-tempx+1)*(tempz-tempy+1));

      //zapisivaem
      z:=0;
      for i:=tempx to tempk do
        for j:=tempy to tempz do
        begin
          ar_tun[k].chunks[z].x:=i;
          ar_tun[k].chunks[z].y:=j;
          inc(z);
        end;
  end;  }

  (*for k:=0 to length(ar_sf)-1 do
  begin
    //opredelaem kraynie koordinati po dvum osam
      tempx:=ar_sf[k].x-ar_sf[k].radius;
      tempk:=ar_sf[k].x+ar_sf[k].radius;
      tempy:=ar_sf[k].z-ar_sf[k].radius;
      tempz:=ar_sf[k].z+ar_sf[k].radius;

      //perevodim koordinati v chanki
      if tempx<0 then inc(tempx);
      if tempk<0 then inc(tempk);
      if tempy<0 then inc(tempy);
      if tempz<0 then inc(tempz);

      //zapisivaem koordinati
      tempx:=tempx div 16;
      tempk:=tempk div 16;
      tempy:=tempy div 16;
      tempz:=tempz div 16;

      //zapisivaem massiv koordinat v tekushuyu zapis'
      //popravka na minusovie chanki
      if (tempx<=0)and((ar_sf[k].x-ar_sf[k].radius)<0) then tempx:=tempx-1;
      if (tempk<=0)and((ar_sf[k].x+ar_sf[k].radius)<0) then tempk:=tempk-1;
      if (tempy<=0)and((ar_sf[k].z-ar_sf[k].radius)<0) then tempy:=tempy-1;
      if (tempz<=0)and((ar_sf[k].z+ar_sf[k].radius)<0) then tempz:=tempz-1;

      //videlaem pamat'
      setlength(ar_sf[k].chunks,(tempk-tempx+1)*(tempz-tempy+1));

      //zapisivaem
      z:=0;
      for i:=tempx to tempk do
        for j:=tempy to tempz do
        begin
          ar_sf[k].chunks[z].x:=i;
          ar_sf[k].chunks[z].y:=j;
          inc(z);
        end;
  end; *)

  fill_el_chunks(ar_el);
  {for k:=0 to length(ar_el)-1 do
  begin
    //opredelaem kraynie koordinati po dvum osam
      tempx:=ar_el[k].x-ar_el[k].radius_x;
      tempk:=ar_el[k].x+ar_el[k].radius_x;
      tempy:=ar_el[k].z-ar_el[k].radius_z;
      tempz:=ar_el[k].z+ar_el[k].radius_z;

      //perevodim koordinati v chanki
      if tempx<0 then inc(tempx);
      if tempk<0 then inc(tempk);
      if tempy<0 then inc(tempy);
      if tempz<0 then inc(tempz);

      //zapisivaem koordinati
      tempx:=tempx div 16;
      tempk:=tempk div 16;
      tempy:=tempy div 16;
      tempz:=tempz div 16;

      //zapisivaem massiv koordinat v tekushuyu zapis'
      //popravka na minusovie chanki
      if (tempx<=0)and((ar_el[k].x-ar_el[k].radius_x)<0) then tempx:=tempx-1;
      if (tempk<=0)and((ar_el[k].x+ar_el[k].radius_x)<0) then tempk:=tempk-1;
      if (tempy<=0)and((ar_el[k].z-ar_el[k].radius_z)<0) then tempy:=tempy-1;
      if (tempz<=0)and((ar_el[k].z+ar_el[k].radius_z)<0) then tempz:=tempz-1;

      //videlaem pamat'
      setlength(ar_el[k].chunks,(tempk-tempx+1)*(tempz-tempy+1));

      //zapisivaem
      z:=0;
      for i:=tempx to tempk do
        for j:=tempy to tempz do
        begin
          ar_el[k].chunks[z].x:=i;
          ar_el[k].chunks[z].y:=j;
          inc(z);
        end;
  end;    }

  if par.tunnel_par^.gen_flooded=true then
  begin
    gen_flooded(ar_tun,map);

    for i:=0 to length(ar_tun)-1 do
    begin
      //nach sfera
      if (ar_tun[i].flooded_nat=true)or(ar_tun[i].flooded_unnat=true) then
        tempx:=max(ar_tun[i].waterlevel_nat,ar_tun[i].waterlevel_unnat)
      else
        tempx:=0;
      for j:=0 to length(ar_tun[i].svazi_nach)-1 do
        if ((ar_tun[i].svazi_nach[j]^.flooded_nat)or(ar_tun[i].svazi_nach[j]^.flooded_unnat))and
        (max(ar_tun[i].svazi_nach[j]^.waterlevel_nat,ar_tun[i].svazi_nach[j]^.waterlevel_unnat)>tempx) then
          tempx:=max(ar_tun[i].svazi_nach[j]^.waterlevel_nat,ar_tun[i].svazi_nach[j]^.waterlevel_unnat);

      if tempx<>0 then
      begin
        ar_tun[i].nach_sfera^.flooded:=true;
        ar_tun[i].nach_sfera^.waterlevel:=tempx;
      end;

      //kon sfera
      if (ar_tun[i].flooded_nat)or(ar_tun[i].flooded_unnat) then
        tempx:=max(ar_tun[i].waterlevel_nat,ar_tun[i].waterlevel_unnat)
      else
        tempx:=0;
      for j:=0 to length(ar_tun[i].svazi_kon)-1 do
        if ((ar_tun[i].svazi_kon[j]^.flooded_nat)or(ar_tun[i].svazi_kon[j]^.flooded_unnat))and
        (max(ar_tun[i].svazi_kon[j]^.waterlevel_nat,ar_tun[i].svazi_kon[j]^.waterlevel_unnat)>tempx) then
          tempx:=max(ar_tun[i].svazi_kon[j]^.waterlevel_nat,ar_tun[i].svazi_kon[j]^.waterlevel_unnat);

      if tempx<>0 then
      begin
        ar_tun[i].kon_sfera^.flooded:=true;
        ar_tun[i].kon_sfera^.waterlevel:=tempx;
      end;
    end;

   { //ishem sovpadayushie sferi
  for i:=0 to length(ar_el)-2 do
  begin
    //if ar_el[i].y=1000 then continue;
    for k:=i+1 to length(ar_el)-1 do
    begin
      //if ar_el[k].y=1000 then continue;

      if (ar_el[i].x=ar_el[k].x)and(ar_el[i].y=ar_el[k].y)and
      (ar_el[i].z=ar_el[k].z) then
      begin
        if (ar_el[i].flooded=true)or(ar_el[k].flooded=true) then
        begin
          ar_el[i].flooded:=true;
          ar_el[i].waterlevel:=max(ar_el[i].waterlevel,ar_el[k].waterlevel);
          ar_el[k].flooded:=true;
          ar_el[k].waterlevel:=max(ar_el[i].waterlevel,ar_el[k].waterlevel);
        end;
        //ar_el[k].y:=1000;
        //break;
      end;
    end;
  end;   }
  
  end;

  //izmenaem spawn
  {if par.tunnel_par^.gen_hub=true then
  begin
    tempx:=ar_el[1].x;
    tempy:=ar_el[1].y-ar_el[1].radius_vert;
    tempz:=ar_el[1].z;
  end
  else
  begin  }
    tempx:=ar_el[0].x;
    tempy:=ar_el[0].y-ar_el[0].radius_vert;
    tempz:=ar_el[0].z;
  //end;

  for i:=0 to length(ar_el)-1 do
    if ar_el[i].flooded=false then
    begin
      tempx:=ar_el[i].x;
      tempy:=ar_el[i].y-ar_el[i].radius_vert;
      tempz:=ar_el[i].z;

      setlength(pr_koord_dirt,1);
      pr_koord_dirt[0].x:=tempx;
      pr_koord_dirt[0].y:=tempy;
      pr_koord_dirt[0].z:=tempz;
      pr_koord_dirt[0].fill_material:=1;
      pr_koord_dirt[0].radius_vert:=ar_el[i].radius_vert+5;
      pr_koord_dirt[0].radius_x:=ar_el[i].radius_vert+5;
      pr_koord_dirt[0].radius_z:=ar_el[i].radius_vert+5;
      if (pr_koord_dirt[0].y-pr_koord_dirt[0].radius_vert)<2 then
        pr_koord_dirt[0].radius_vert:=pr_koord_dirt[0].y-2;
      fill_el_chunks(pr_koord_dirt);
      break;
    end;  
             
  postmessage(par.handle,WM_USER+308,1,tempx); //x
  postmessage(par.handle,WM_USER+308,2,tempy); //y
  postmessage(par.handle,WM_USER+308,3,tempz); //z
  sp:=false;

  postmessage(par.handle,WM_USER+315,0,0);

  co:=0;
  co1:=0;

  {for i:=0 to length(ar_tun)-1 do
    if ar_tun[i].waterlevel=0 then ar_tun[i].flooded:=false
    else ar_tun[i].flooded:=true;  }

  //pereschitivaem nachalo i konec regionov i chankov, dla generacii granici karti
  if par.border_par^.border_type<>0 then
  begin
    case par.border_par^.border_type of
    1:if par.border_par^.wall_void=true then
        begin
          par.fromx:=par.fromx-par.border_par^.wall_void_thickness;
          par.tox:=par.tox+par.border_par^.wall_void_thickness;
          par.fromy:=par.fromy-par.border_par^.wall_void_thickness;
          par.toy:=par.toy+par.border_par^.wall_void_thickness;
        end;
    2:begin
        par.fromx:=par.fromx-par.border_par^.void_thickness;
        par.tox:=par.tox+par.border_par^.void_thickness;
        par.fromy:=par.fromy-par.border_par^.void_thickness;
        par.toy:=par.toy+par.border_par^.void_thickness;
      end
    end;

    //opredelaem kol-vo region faylov, kotoroe sozdavat
    tempx:=(par.tox-par.fromx+1);      //kol-vo chankov po osam
    tempy:=(par.toy-par.fromy+1);
  end;

    if (par.fromx+par.tox+1)=0 then  //tolko po X, t.k. nuzhno razdelit raznie osi
    begin
      regx:=(tempx div 2) div 32;
      if ((tempx div 2) mod 32)<>0 then inc(regx);
      regx_nach:=-regx;
      regx:=regx*2;
    end
    else
    begin
      regx:= tempx div 32;
      if (tempx mod 32)<>0 then inc(regx);
      if par.fromx<0 then regx_nach:=-regx
      else regx_nach:=0;
    end;

    if (par.fromy+par.toy+1)=0 then  //tolko po Y
    begin
      regy:=(tempy div 2) div 32;
      if ((tempy div 2) mod 32)<>0 then inc(regy);
      regy_nach:=-regy;
      regy:=regy*2;
    end
    else
    begin
      regy:= tempy div 32;
      if (tempy mod 32)<>0 then inc(regy);
      if par.fromy<0 then regy_nach:=-regy
      else regy_nach:=0;
    end;
  

  //opredelaem kol-vo region faylov, kotoroe sozdavat
  tempx:=(par.tox-par.fromx+1);      //kol-vo chankov po osam
  tempy:=(par.toy-par.fromy+1);

  postmessage(par.handle,WM_USER+302,par.id,tempx*tempy);

  postmessage(par.handle,WM_USER+300,1,0);

  for i:=regx_nach to regx_nach+regx-1 do
    for j:=regy_nach to regy_nach+regy-1 do
    begin
      thread_exit(param);

      //opredelaem nachalnie i konechnie chanki
      id:=1;
      if (i<0)and(j>=0) then id:=2
      else if (i<0)and(j<0) then id:=3
      else if (i>=0)and(j<0) then id:=4;

      if id=1 then
      begin
        //po osi X
        if i=regx_nach+regx-1 then
        begin
          otx:=0;
          dox:=par.tox mod 32;
        end
        else
        begin
          otx:=0;
          dox:=31;
        end;
        //po osi Y
        if j=regy_nach+regy-1 then
        begin
          oty:=0;
          doy:=par.toy mod 32;
        end
        else
        begin
          oty:=0;
          doy:=31;
        end;
      end;
      if id=2 then
      begin
        //po osi X
        if (i=regx_nach)and((par.fromx mod 32)<>0) then
        begin
          otx:=32+(par.fromx mod 32);
          dox:=31;
        end
        else
        begin
          otx:=0;
          dox:=31;
        end;
        //po osi Y
        if j=regy_nach+regy-1 then
        begin
          oty:=0;
          doy:=par.toy mod 32;
        end
        else
        begin
          oty:=0;
          doy:=31;
        end;
      end;
      if id=3 then
      begin
        //po osi X
        if (i=regx_nach)and((par.fromx mod 32)<>0) then
        begin
          otx:=32+(par.fromx mod 32);
          dox:=31;
        end
        else
        begin
          otx:=0;
          dox:=31;
        end;
        //po osi Y
        if (j=regy_nach)and((par.fromy mod 32)<>0) then
        begin
          oty:=32+(par.fromy mod 32);
          doy:=31;
        end
        else
        begin
          oty:=0;
          doy:=31;
        end;
      end;
      if id=4 then
      begin
        //po osi X
        if i=regx_nach+regx-1 then
        begin
          otx:=0;
          dox:=par.tox mod 32;
        end
        else
        begin
          otx:=0;
          dox:=31;
        end;
        //po osi Y
        if (j=regy_nach)and((par.fromy mod 32)<>0) then
        begin
          oty:=32+(par.fromy mod 32);
          doy:=31;
        end
        else
        begin
          oty:=0;
          doy:=31;
        end;
      end;

      //peredaem soobshenie o nachale zapisi blokov
      postmessage(par.handle,WM_USER+309,i,j);

      //ochishaem kartu
      for k:=0 to 35 do
        for z:=0 to 35 do
        begin
          fillchar(map[k][z].blocks[0],length(map[k][z].blocks),1);
          //zapolnaem niz i verh adminiumom i 1 sloy lavoy
          for tempx:=0 to 15 do  //x
            for tempz:=0 to 15 do  //z
            begin
              map[k][z].blocks[tempz*128+(tempx*2048)]:=7;
              map[k][z].blocks[127+(tempz*128+(tempx*2048))]:=7;
              map[k][z].blocks[1+(tempz*128+(tempx*2048))]:=10;
            end;
          //delaem steni iz adminiuma
          {if i<0 then tempx:=((i+1)*32-(32-k))
          else tempx:=(i*32)+k;
          if j<0 then  tempy:=((j*32)+z)
          else tempy:=(j+1)*32-(32-z);
          dec(tempx,2);
          dec(tempy,2);
          if (tempx=par.fromx) then
            for tempk:=0 to 127 do   //y
              for tempz:=0 to 15 do   //z
                map[k][z].blocks[tempk+(tempz*128)]:=7;
          if (tempx=par.tox) then
            for tempk:=0 to 127 do      //y
              for tempz:=0 to 15 do      //z
                map[k][z].blocks[tempk+(tempz*128+(15*2048))]:=7;
          if (tempy=par.fromy) then
            for tempk:=0 to 127 do      //y
              for tempz:=0 to 15 do      //x
                map[k][z].blocks[tempk+(tempz*2048)]:=7;
          if (tempy=par.toy) then
            for tempk:=0 to 127 do      //y
              for tempz:=0 to 15 do      //x
                map[k][z].blocks[tempk+(15*128+(tempz*2048))]:=7; }

          zeromemory(map[k][z].data,length(map[k][z].data));
          zeromemory(map[k][z].light,length(map[k][z].light));
          zeromemory(map[k][z].heightmap,length(map[k][z].heightmap));
          fillchar(map[k][z].skylight[0],length(map[k][z].skylight),0);
          clear_all_entities(@map[k][z].entities,@map[k][z].tile_entities);
        end;

      //ochishaem head
      for k:=1 to 1024 do
      begin
        head.mclocations[k]:=0;
        head.mctimestamp[k]:=0;
      end;

      //zapolnaem head
      tempx:=2;
      for k:=otx to dox do
        for z:=oty to doy do
        begin
          str:=inttohex(tempx,6)+inttohex(1,2);
          tempy:=bintoint(hextobin(str));
          btolendian(tempy);
          head.mclocations[(k+(z*32))+1]:=tempy;
          inc(tempx);
        end;

      //generiruem bloki
      for k:=0 to 35 do
        for z:=0 to 35 do
        begin
          thread_exit(param);

          if i<0 then tempx:=((i+1)*32-(32-k))
          else tempx:=(i*32)+k;

          if j<0 then  tempy:=((j*32)+z)
          else tempy:=(j+1)*32-(32-z);

          b1:=false;
          for tempz:=0 to length(pop_koord)-1 do
            if (pop_koord[tempz].x=(tempx-2))and
            (pop_koord[tempz].y=(tempy-2)) then
            begin
              b1:=true;
              break;
            end;

          if b1=false then
          begin
            tempz:=length(pop_koord);
            setlength(pop_koord,tempz+1);
            pop_koord[tempz].x:=tempx-2;
            pop_koord[tempz].y:=tempy-2;
          end;

          gen_border(tempx-2,tempy-2,par.tox-par.fromx+1,par.toy-par.fromy+1,par.border_par^,map[k][z].blocks,map[k][z].data,nil,nil);
          if map[k][z].blocks[0]=0 then continue;

          //try
          //gen_sphere(tempx-2,tempy-2,map[k][z].blocks,ar_sf,0,3);
          gen_tun(tempx-2,tempy-2,map[k][z].blocks,ar_tun,@pr_koord_lights,@pr_koord_holes,@pr_koord_dirt,@pr_koord_res,b1,par.tunnel_par^.gen_lights,par.tunnel_par^.gen_sun_holes,par.tunnel_par^.light_density,par.tunnel_par^.skyholes_density);
          gen_elipse(tempx-2,tempy-2,map[k][z].blocks,ar_el,nil,@pr_koord_lights,@pr_koord_res,b1,par.tunnel_par^.gen_lights,par.tunnel_par^.light_density,0);
          {if (tempx-2>=-5)and(tempx-2<=5)and
          (tempy-2>=-5)and(tempy-2<=5)
          then gen_plosk(tempx-2,tempy-2,map[k][z].blocks); }
          {except
            on e:exception do messagebox(par.handle,pchar(e.Message+#13+#10+'Koordinati='+inttostr(k)+','+inttostr(z)),'Error',MB_OK);
          end;   }
          inc(co1);
          //postmessage(par.handle,WM_USER+304,par.id,co1);
        end;

      //ishem blizkie koordinati dirok
      for k:=0 to length(pr_koord_holes)-2 do
      begin
        if pr_koord_holes[k].z=1000 then continue;
        for z:=k+1 to length(pr_koord_holes)-1 do
        begin
          if pr_koord_holes[k].z=1000 then continue;
          if ((pr_koord_holes[k].x-7)<=pr_koord_holes[z].x)and
          ((pr_koord_holes[k].x+7)>=pr_koord_holes[z].x)and
          ((pr_koord_holes[k].y-7)<=pr_koord_holes[z].y)and
          ((pr_koord_holes[k].y+7)>=pr_koord_holes[z].y) then
            if random<0.5 then
              pr_koord_holes[k].z:=1000
            else
              pr_koord_holes[z].z:=1000;
        end;
      end;

      if length(pr_koord_holes_obsh)=0 then
      begin
        for k:=0 to length(pr_koord_holes)-1 do
          if (pr_koord_holes[k].z<>1000) then
          begin
            z:=length(pr_koord_holes_obsh);
            setlength(pr_koord_holes_obsh,z+1);
            pr_koord_holes_obsh[z]:=pr_koord_holes[k];
          end;
      end
      else
      begin
        for k:=0 to length(pr_koord_holes)-1 do
        begin
          if pr_koord_holes[k].z=1000 then continue;
          for z:=0 to length(pr_koord_holes_obsh)-1 do
            if ((pr_koord_holes[k].x-7)<=pr_koord_holes_obsh[z].x)and
            ((pr_koord_holes[k].x+7)>=pr_koord_holes_obsh[z].x)and
            ((pr_koord_holes[k].y-7)<=pr_koord_holes_obsh[z].y)and
            ((pr_koord_holes[k].y+7)>=pr_koord_holes_obsh[z].y)and
            (pr_koord_holes_obsh[z].z<>1000) then
            begin
              pr_koord_holes[k].z:=1000;
              break;
            end;
        end;

        for k:=0 to length(pr_koord_holes)-1 do
          if (pr_koord_holes[k].z<>1000) then
          begin
            z:=length(pr_koord_holes_obsh);
            setlength(pr_koord_holes_obsh,z+1);
            pr_koord_holes_obsh[z]:=pr_koord_holes[k];
          end;
      end;

      setlength(pr_koord_holes,0);

      //generim resursi
      {if (i=-1)and(j=-1) then
      begin
        k:=length(pr_koord_res);
        setlength(pr_koord_res,k+1);
        pr_koord_res[k].x:=-88;
        pr_koord_res[k].y:=30;
        pr_koord_res[k].z:=-37;
        pr_koord_res[k].id:=86;
        (*//gen_resourses(map,par.tunnel_par^.sid,29,30,15,32,14,20,0,600);  //y=33
        gen_resourses(map,par.tunnel_par^.sid,29,30,-35,36,-50,3,1,40);
        //gen_resourses2(map,i,j,-70,20,-50,20,300);
        gen_tree_notch(map,par.tunnel_par^.sid,-29,38,-50);
        gen_tree_notch(map,par.tunnel_par^.sid,-33,38,-52);
        gen_tree_notch(map,par.tunnel_par^.sid,-41,37,-52);
        gen_tree_notch(map,par.tunnel_par^.sid,-35,37,-48); *)
      end;  }

      gen_resourses3(map,i,j,pr_koord_res,0,par.tunnel_par^.sid,1);

      calc_tun_dirt(map,i,j,pr_koord_dirt,par.tunnel_par^.sid);

      //todo: udalenie lishnih sfer zemli

      //risuem zemlu, graviy, pesok ili sneg
      for k:=0 to 35 do
        for z:=0 to 35 do
        begin
          if i<0 then tempx:=((i+1)*32-(32-k))
          else tempx:=(i*32)+k;

          if j<0 then  tempy:=((j*32)+z)
          else tempy:=(j+1)*32-(32-z);

          gen_elipse(tempx-2,tempy-2,map[k][z].blocks,pr_koord_dirt,@pr_koord_trees,nil,nil,true,false,0,1);
        end;

      //delaem derevya
      for k:=0 to length(pr_koord_trees)-1 do
      begin
        if get_block_id(map,i,j,pr_koord_trees[k].x,pr_koord_trees[k].y,pr_koord_trees[k].z)=255 then continue;
        if pr_koord_trees[k].id=0 then
          gen_tree_notch(map,i,j,par.tunnel_par^.sid+k,pr_koord_trees[k].x,pr_koord_trees[k].y,pr_koord_trees[k].z,sp,waterlevel,par.handle,0)
        else if (pr_koord_trees[k].id=1)and(par.tunnel_par^.gen_tall_grass=true) then
        begin
          tempx:=random(1000);
          if get_block_id(map,i,j,pr_koord_trees[k].x,pr_koord_trees[k].y-1,pr_koord_trees[k].z)=2 then
          if tempx<3 then
            set_block_id_data(map,i,j,pr_koord_trees[k].x,pr_koord_trees[k].y,pr_koord_trees[k].z,31,0)
          else if tempx<8 then
            set_block_id_data(map,i,j,pr_koord_trees[k].x,pr_koord_trees[k].y,pr_koord_trees[k].z,31,2)
          else
            set_block_id_data(map,i,j,pr_koord_trees[k].x,pr_koord_trees[k].y,pr_koord_trees[k].z,31,1);
        end
        else if pr_koord_trees[k].id=4 then //cactus
        begin
          //postmessage(par.handle,WM_USER+304,1,0);
          //postmessage(par.handle,WM_USER+305,pr_koord_trees[k].x,pr_koord_trees[k].z);
          gen_cactus(map,i,j,pr_koord_trees[k].x,pr_koord_trees[k].y,pr_koord_trees[k].z,par.sid+k);
        end
        else if pr_koord_trees[k].id=5 then //taigatree1
        begin
          //postmessage(par.handle,WM_USER+304,2,0);
          //postmessage(par.handle,WM_USER+305,pr_koord_trees[k].x,pr_koord_trees[k].z);
          gen_taigatree1_notch(map,i,j,pr_koord_trees[k].x,pr_koord_trees[k].y,pr_koord_trees[k].z,par.sid+k);
        end
        else if pr_koord_trees[k].id=6 then //taigatree2
        begin
          //postmessage(par.handle,WM_USER+304,2,0);
          //postmessage(par.handle,WM_USER+305,pr_koord_trees[k].x,pr_koord_trees[k].z);
          gen_taigatree2_notch(map,i,j,pr_koord_trees[k].x,pr_koord_trees[k].y,pr_koord_trees[k].z,par.sid+k);
        end
        else if pr_koord_trees[k].id=7 then
        begin
          //postmessage(par.handle,WM_USER+304,2,0);
          //postmessage(par.handle,WM_USER+305,pr_koord_trees[k].x,pr_koord_trees[k].z);
          tempk:=get_block_id(map,i,j,pr_koord_trees[k].x,pr_koord_trees[k].y-1,pr_koord_trees[k].z);
          tempz:=get_block_id(map,i,j,pr_koord_trees[k].x,pr_koord_trees[k].y,pr_koord_trees[k].z);
          if (tempk=2)and((tempz=0)or(tempz=31)) then
            set_block_id(map,i,j,pr_koord_trees[k].x,pr_koord_trees[k].y,pr_koord_trees[k].z,37);
        end
        else if pr_koord_trees[k].id=8 then
        begin
          //postmessage(par.handle,WM_USER+304,2,0);
          //postmessage(par.handle,WM_USER+305,pr_koord_trees[k].x,pr_koord_trees[k].z);
          tempk:=get_block_id(map,i,j,pr_koord_trees[k].x,pr_koord_trees[k].y-1,pr_koord_trees[k].z);
          tempz:=get_block_id(map,i,j,pr_koord_trees[k].x,pr_koord_trees[k].y,pr_koord_trees[k].z);
          if (tempk=2)and((tempz=0)or(tempz=31)) then
            set_block_id(map,i,j,pr_koord_trees[k].x,pr_koord_trees[k].y,pr_koord_trees[k].z,38);
        end;
      end;

      //gen_resourses3(map,i,j,pr_koord_dirt,1,par.tunnel_par^.sid);

      //otladka
      {begin
        pr_koord_lights[0].x:=-69;
        pr_koord_lights[0].y:=21;
        pr_koord_lights[0].z:=-45;
        setlength(pr_koord_lights,1);
      end;   }

      gen_tun_lights(map,i,j,pr_koord_lights);
      gen_tun_holes(map,i,j,pr_koord_holes_obsh);

      //gen_tun_waterlevel(map,waterlevel);

      postmessage(par.handle,WM_USER+310,i,j);
      
      //schitaem skylight srazu dla vsego regiona
      //postmessage(par.handle,WM_USER+311,0,0);
      calc_skylight(map,otx,oty,dox,doy);
      //postmessage(par.handle,WM_USER+311,0,0);

      //schitaem blocklight
      //postmessage(par.handle,WM_USER+311,0,0);
      calc_blocklight(map,otx,oty,dox,doy);
      //postmessage(par.handle,WM_USER+311,0,0);

      //delaem gribi
      for k:=0 to length(pr_koord_trees)-1 do
      begin
        if (pr_koord_trees[k].id=2)or(pr_koord_trees[k].id=3) then
        begin
          //postmessage(par.handle,WM_USER+305,0,9999999);
          gen_mushroom(map,i,j,pr_koord_trees[k].x,pr_koord_trees[k].y,pr_koord_trees[k].z,pr_koord_trees[k].id);
        end;
      end;

      //ispolzuem massiv dla hraneniya informacii, kotoruyu budem zapisivat' v fayl
      setlength(fdata,0);

      //peredaem soobshenie o nachale zapisi chankov na disk
      postmessage(par.handle,WM_USER+306,i,j);

      tempk:=2;
      for k:=otx to dox do
        for z:=oty to doy do
        begin
          thread_exit(param);

          //opredelaem obshie koordinati chanka
          if i<0 then tempx:=((i+1)*32-(32-k))
          else tempx:=(i*32)+k;

          if j<0 then  tempy:=((j*32)+z)
          else tempy:=(j+1)*32-(32-z);

          //zeromemory(heightmap,length(heightmap));
          //calc_heightmap(map[k+2][z+2].blocks,heightmap);

          nbtcompress2(tempx,tempy,map[k+2][z+2].blocks,map[k+2][z+2].data,map[k+2][z+2].skylight,map[k+2][z+2].light,map[k+2][z+2].heightmap,map[k+2][z+2].entities,map[k+2][z+2].tile_entities,not(par.tunnel_par^.pop_chunks),@rez);

          setlength(str,length(rez));
          move(rez[0],str[1],length(rez));

          strcompress:=zcompressstr(str);

          tempx:=length(strcompress)+1;
          str:=inttohex(tempx,8);
          str:=chr(bintoint(hextobin(copy(str,1,2))))+chr(bintoint(hextobin(copy(str,3,2))))+
            chr(bintoint(hextobin(copy(str,5,2))))+chr(bintoint(hextobin(copy(str,7,2))));
          str:=str+#2;
          str:=str+strcompress;
          while (length(str) mod 4096)<>0 do
            str:=str+#0;

          //dobavlaem blok dannih v obshiy massiv
          tempx:=length(fdata);
          setlength(fdata,length(fdata)+length(str));

          move(str[1],fdata[tempx],length(str));

          //izmenaem head
          tempx:=length(str) div 4096;
          //if tempx>1 then
            str:=inttohex(tempk,6)+inttohex(tempx,2);
            tempy:=bintoint(hextobin(str));
            btolendian(tempy);
            head.mclocations[(k+(z*32))+1]:=tempy;
            if tempx>1 then
              inc(tempk,tempx-1);

          inc(tempk);
          inc(co);
          postmessage(par.handle,WM_USER+303,par.id,co);
        end;

      hndl:=createfile(pchar('r.'+inttostr(i)+'.'+inttostr(j)+'.mcr'),
      GENERIC_WRITE,
      0,
      nil,
      CREATE_ALWAYS,
      FILE_ATTRIBUTE_NORMAL,
      0);

      if hndl=INVALID_HANDLE_VALUE then
        postmessage(par.handle,WM_USER+304,300,-2000);

      if writefile(hndl,head,sizeof(head),count,nil)=false then
        postmessage(par.handle,WM_USER+304,300,-4000);

      writefile(hndl,fdata[0],length(fdata),count,nil);

      closehandle(hndl);

      postmessage(par.handle,WM_USER+319,0,length(fdata));

      setlength(fdata,0);

      thread_exit(param);
    end;

  //soobsheniya o dlinne massivov
  //postmessage(par.handle,WM_USER+304,11112222,length(pr_koord_dirt));
  //postmessage(par.handle,WM_USER+304,11112222,length(pr_koord_trees));


  //++++++++OCHISHENIE PAMATI++++++++++++=
  //ochishaem pamat ot massiva resultata dla nbtcompress
  setlength(rez,0);

  //ochishaem pamat' ot massiva sfer
  {for i:=0 to length(ar_sf)-1 do
    setlength(ar_sf[i].chunks,0);
  setlength(ar_sf,0);  }

  //oschishaem pamat' ot massiva tuneley
  for i:=0 to length(ar_tun)-1 do
  begin
    setlength(ar_tun[i].svazi_nach,0);
    setlength(ar_tun[i].svazi_kon,0);
    setlength(ar_tun[i].chunks,0);
  end;
  setlength(ar_tun,0);

  //ochishaem pamat' ot massiva populated dla sveta i skyholes
  setlength(pop_koord,0);

  //ochishaem pamat ot massiva elipsov
  for i:=0 to length(ar_el)-1 do
    setlength(ar_el[i].chunks,0);
  setlength(ar_el,0);

  //ochishaem pamat ot massiva cepey tuneley
  setlength(cep_tun,0);

  //ochishaem massiv isklucheniy
  setlength(iskluch,0);

  //oschishaem massiv dla zemli
  for i:=0 to length(pr_koord_dirt)-1 do
    setlength(pr_koord_dirt[i].chunks,0);
  setlength(pr_koord_dirt,0);

  //ochishaem massivi koordinat dla sveta,skyholes,resursov,derevev
  setlength(pr_koord_lights,0);
  setlength(pr_koord_holes,0);
  setlength(pr_koord_holes_obsh,0);
  setlength(pr_koord_res,0);
  setlength(pr_koord_trees,0);

  //ochishaem pamat ot karti
  for i:=0 to 35 do
    for j:=0 to 35 do
    begin
      clear_all_entities(@map[k][z].entities,@map[k][z].tile_entities);
      setlength(map[i][j].blocks,0);
      setlength(map[i][j].data,0);
      setlength(map[i][j].light,0);
      setlength(map[i][j].skylight,0);
      setlength(map[i][j].heightmap,0);
    end;
  for i:=0 to 35 do
    setlength(map[i],0);
  setlength(map,0);

  endthread(0);
end;

end.

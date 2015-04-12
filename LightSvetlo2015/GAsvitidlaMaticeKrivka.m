clear;
clc;
close;
%Reseni vyzarovaci char. pomoci genetickeho algoritmu. Na zacatku se zvoli
%pocet svitidel a jejich rozmisteni.
%DNA: vyjadruje koeficienty goniometrickeho polynomu a exponent.
%Krizeni: jednobodove (udat pravdepodobnost)
                pop.kriz = 0.9;
%Mutace (pomerna hodnota):
                pop.mut = 0.05;
%Pocet generací:
                pop.gen = 50;
%Velikost populace:
                pop.N = 200;
%Pocet jedincu v turnaji:
                pop.N_turnament = 4;
%krok pozice:
                pop.stepPar = 0.1;
%krok svitivosti:
                pop.stepI0 = 100;
%Royerz mistnosti v m:
                mstn.x = 10;
                mstn.y = 5;
%Vyska mistnosti (m):
                mstn.z = 4;
%Pocet bodu na stenach v ose x:
                mstn.Nx = 20;
%Pocet bodu na stenach v ose y:
                mstn.Ny = 10;
%Pocet bodu na stenach v ose z:
                mstn.Nz = 8;
%Pocatecni fitness
                pop.fitness = zeros(1, pop.gen);
%--------------------------------------------------------------------------
%Fenotyp - cilove paramety
%Pocet bodu na stenach v ose z:
                target.Eavg = 500;
%Pocatecni fitness
                target.Uo = 0.6;
%Navic minimalizujeme celkovy tok svitidla
%--------------------------------------------------------------------------
%PARAMETRY STEN
%Cinitel odrazu stropu:
                mstn.COstr = 0.7;
%Cinitel odrazu sten:
                mstn.COste = 0.5;
%Cinitel odrazu podlahy:
                mstn.COpod = 0.2;
%Uvazovany pocet odrazu:
                mstn.Nodr = 3;
%Vyska srovnavaci roviny:
                mstn.sRov = 0.8;
                
%--------------------------------------------------------------------------
%PARAMETRY SVITIDEL
%Souradnice svitidel (pozor, at nejsou svitidla mimo prostor mistnosti):
                svt.x = [1, 5, 9, 1, 5, 9];
                svt.y = [2, 2, 2, 3, 3, 3];
                svt.z = [3.5, 3.5, 3.5, 3.5, 3.5, 3.5];
%Pocet svitidel:
                svt.N = length(svt.x);
                svt.theta = pi:-pi/359:0;

%%
%--------------------------------------------------------------------------
%GENEROVANI BODU JEDNOTLIVYCH STEN
%Deleni jednotlivych os:
mstn.bx = ((1:mstn.Nx).*mstn.x - mstn.x/2)./mstn.Nx;
mstn.by = ((1:mstn.Ny).*mstn.y - mstn.y/2)./mstn.Ny;
mstn.bz = ((1:mstn.Nz).*mstn.z - mstn.z/2)./mstn.Nz;

%Generovani souradnic
%x, y, z... souradnice
%A... plocha bodu
for i= 1:1:mstn.Ny
    podlaha.x((((i-1)*mstn.Nx)+1):(i*mstn.Nx)) = mstn.bx;
    podlaha.y((((i-1)*mstn.Nx)+1):(i*mstn.Nx)) = ones(1, mstn.Nx).*mstn.by(i);
    podlaha.z((((i-1)*mstn.Nx)+1):(i*mstn.Nx)) = zeros(1, mstn.Nx);
end
podlaha.A = ones(1, mstn.Nx*mstn.Ny).* (mstn.x*mstn.y)/ mstn.Nx/ mstn.Ny;

for i= 1:1:mstn.Ny
    strop.x((((i-1)*mstn.Nx)+1):(i*mstn.Nx)) = mstn.bx;
    strop.y((((i-1)*mstn.Nx)+1):(i*mstn.Nx)) = ones(1, mstn.Nx).*mstn.by(i);
    strop.z((((i-1)*mstn.Nx)+1):(i*mstn.Nx)) = ones(1, mstn.Nx).*mstn.z;
end
strop.A = ones(1, mstn.Nx*mstn.Ny).*(mstn.x*mstn.y)/ mstn.Nx/ mstn.Ny;

for i= 1:1:mstn.Nz
    stenaJ.x((((i-1)*mstn.Nx)+1):(i*mstn.Nx)) = mstn.bx;
    stenaJ.y((((i-1)*mstn.Nx)+1):(i*mstn.Nx)) = zeros(1, mstn.Nx);
    stenaJ.z((((i-1)*mstn.Nx)+1):(i*mstn.Nx)) = ones(1, mstn.Nx).*mstn.bz(i);
end
stenaJ.A = ones(1, mstn.Nx*mstn.Nz).*(mstn.x*mstn.z)/ mstn.Nx/ mstn.Nz;

for i= 1:1:mstn.Nz
    stenaS.x((((i-1)*mstn.Nx)+1):(i*mstn.Nx)) = mstn.bx;
    stenaS.y((((i-1)*mstn.Nx)+1):(i*mstn.Nx)) = ones(1, mstn.Nx).*mstn.y;
    stenaS.z((((i-1)*mstn.Nx)+1):(i*mstn.Nx)) = ones(1, mstn.Nx).*mstn.bz(i);
end
stenaS.A = ones(1, mstn.Nx*mstn.Nz).*(mstn.x*mstn.z)/ mstn.Nx/ mstn.Nz;

for i= 1:1:mstn.Nz
    stenaZ.x((((i-1)*mstn.Ny)+1):(i*mstn.Ny)) = zeros(1, mstn.Ny);
    stenaZ.y((((i-1)*mstn.Ny)+1):(i*mstn.Ny)) = mstn.by;
    stenaZ.z((((i-1)*mstn.Ny)+1):(i*mstn.Ny)) = ones(1, mstn.Ny).*mstn.bz(i);
end
stenaZ.A = ones(1, mstn.Ny*mstn.Nz).*(mstn.y*mstn.z)/ mstn.Ny/ mstn.Nz;

for i= 1:1:mstn.Nz
    stenaV.x((((i-1)*mstn.Ny)+1):(i*mstn.Ny)) = ones(1, mstn.Ny).*mstn.x;
    stenaV.y((((i-1)*mstn.Ny)+1):(i*mstn.Ny)) = mstn.by;
    stenaV.z((((i-1)*mstn.Ny)+1):(i*mstn.Ny)) = ones(1, mstn.Ny).*mstn.bz(i);
end
stenaV.A = ones(1, mstn.Ny*mstn.Nz).*(mstn.y*mstn.z)/ mstn.Ny/ mstn.Nz;

%pole vsech souradnic a uchovani hodnoty posledniho indexu pro dane roviny
bod.x= [podlaha.x strop.x stenaJ.x stenaS.x stenaZ.x stenaV.x];
bod.y= [podlaha.y strop.y stenaJ.y stenaS.y stenaZ.y stenaV.y];
bod.z= [podlaha.z strop.z stenaJ.z stenaS.z stenaZ.z stenaV.z];
bod.A= [podlaha.A strop.A stenaJ.A stenaS.A stenaZ.A stenaV.A];
bod.podIDX= length(podlaha.x);
bod.strIDX= bod.podIDX + length(strop.x);
bod.stJIDX= bod.strIDX + length(stenaJ.x);
bod.stSIDX= bod.stJIDX + length(stenaS.x);
bod.stZIDX= bod.stSIDX + length(stenaZ.x);
bod.stVIDX= length(bod.x);
%posledni index je roven delce pole

clear podlaha;
clear strop;
clear stenaJ;
clear stenaS;
clear stenaV;
clear stenaZ;

%--------------------------------------------------------------------------
%GENEROVANI DNA POCATECNICH POPULACI
%DNA:
% [A2, A1, EA, B2, B1, EB, I0]
% A1,B1... <-1, 1>
% A2,B2... <1, 2>
% EA,EB... <1, 3> maximalni exponent stejny jako u cosinu
% I0... <10, 10000>
%Pocatecni populace je nahodna:
pop.dnaMax = [1 2 3 1 2 3 10000];
pop.dnaMin = [-1 1 1 -1 1 1 10];
pop.dna = [-1 + 2*rand(pop.N, 1), 1 + rand(pop.N, 1), 1 + 2*rand(pop.N, 1), -1 + 2*rand(pop.N, 1), 1 + rand(pop.N, 1), 1 + 2*rand(pop.N, 1), 10 + 99990*rand(pop.N, 1)];
pop.DNAlength = length(pop.dna(1,:));
%--------------------------------------------------------------------------
%SMYCKA GENETICKEHO ALGORITMU
%--------------------------------------------------------------------------
%inicializace promenych
pop.Eavg = zeros(1,pop.N);
pop.Essq = zeros(1,pop.N);
pop.prVyb = zeros(1,pop.N);
%opakovat tolikrat, kolik je pozadovano generaci
for generace = 1:1:pop.gen
    %pocatecni osvetlenost a tok jsou nulovi
    bod.E = zeros(pop.N,bod.stVIDX);
    svt.Fi= zeros(pop.N,1);
    %----------------------------------------------------------------------
    %Vypocet osvetleni vsech bodu pro kazdeho clena populace
    for clen = 1:1:pop.N
        %------------------------------------------------------------------
        %Vsechna svitidla tohoto clena populace vuci vsem bodum
        %------------------------------------------------------------------
  
            x= svt.x'*ones(1, bod.stVIDX);
            y= svt.y'*ones(1, bod.stVIDX);
            z= svt.z'*ones(1, bod.stVIDX);
            
            %1) vzdalenost bodu od svitidla
            lSB = (((x-ones(svt.N, 1)*bod.x).^2 + (y-ones(svt.N, 1)*bod.y).^2 + (z-ones(svt.N, 1)*bod.z).^2)).^0.5+eps;
            
            %2) cosiny a siny uhlu 
            %od normaly svitidla
            %jen tady lze pocitat cosinus bez absolutni hodnoty
            cosTh = (z-ones(svt.N, 1)*bod.z)./lSB;
            sinTh = (1 - cosTh.^2).^0.5;
            
            %od normaly plosky
            cosDelta = [(z(:,1:bod.strIDX)-ones(svt.N, 1)*bod.z(:,1:bod.strIDX)), (y(:,(bod.strIDX+1):bod.stSIDX)-ones(svt.N, 1)*bod.y(:,(bod.strIDX+1):bod.stSIDX)), (x(:,(bod.stSIDX+1):bod.stVIDX)-ones(svt.N, 1)*bod.x(:,(bod.stSIDX+1):bod.stVIDX))];
            cosDelta = abs(cosDelta)./lSB;
            
            %3) urceni svitivosti v jednotlivych uhlech
            %smazat zaporne cosiny (uhel > 90)
            %vsechny zaporne hodnoty jsou rovny nule
            cosfi = cosTh .* (cosTh > 0);
            bod.I = pop.dna(clen, 7) .* (polyval([pop.dna(clen, 1:2) 0], cosfi).^pop.dna(clen, 3) + polyval([pop.dna(clen, 4:5) 0], sinTh).^pop.dna(clen, 6));
            
            %4) vypocet osvetleni
            bod.E(clen,:)= sum(bod.I .* cosDelta ./ lSB.^2, 1);
            
        %------------------------------------------------------------------
        %Vsechny svitici body tohoto clena populace vuci vsem bodum
        %Ev... vysledna osvetlenost vsech sten v danem odrazu
        %Eo... osvetlenost prispivajici k novemu odrazu
        %------------------------------------------------------------------
        %pocatecni osvetlenost generujici odrazy
        bod.Eo = bod.E(clen,:);
        %opakovani podle poctu odrazu
        for odraz = 1:1:mstn.Nodr
            %pocatecni vysledna osvetlenost je nulova
            bod.Ev = zeros(1,bod.stVIDX);
            
            %svitici body na podlaze
          
                %1) vzdalenost sviticiho a osvetlovaneho bodu
                %pouziva se jako jmenovatel, promenna eps zamezi deleni
                %nulou
                lSB= ((bod.x(1:bod.podIDX)'*ones(1, bod.stVIDX)-ones(mstn.Nx*mstn.Ny, 1)*bod.x).^2 + (bod.y(1:bod.podIDX)'*ones(1, bod.stVIDX)-ones(mstn.Nx*mstn.Ny, 1)*bod.y).^2 + (bod.z(1:bod.podIDX)'*ones(1, bod.stVIDX)-ones(mstn.Nx*mstn.Ny, 1)*bod.z).^2).^0.5+eps;
                
                %2) kosiny a siny uhlu 
                %od normaly sviticiho bodu
                cosTh = abs(bod.z(1:bod.podIDX)'*ones(1, bod.stVIDX)-ones(mstn.Nx*mstn.Ny, 1)*bod.z)./lSB;
                
                %od normaly osvetlovane plosky
                cosDelta = [(bod.z(1:bod.podIDX)'*ones(1, bod.strIDX)-ones(mstn.Nx*mstn.Ny, 1)*bod.z(1:bod.strIDX)), (bod.y(1:bod.podIDX)'*ones(1, bod.stSIDX-bod.strIDX)-ones(mstn.Nx*mstn.Ny, 1)*bod.y(bod.strIDX+1:bod.stSIDX)), (bod.x(1:bod.podIDX)'*ones(1, bod.stVIDX-bod.stSIDX)-ones(mstn.Nx*mstn.Ny, 1)*bod.x(bod.stSIDX+1:bod.stVIDX))];
                cosDelta = abs(cosDelta)./lSB;
                
                %3) svitivost bodu v jednotlivych uhlech
                bod.I = ((bod.Eo(1:bod.podIDX) .* mstn.COpod .* bod.A(1:bod.podIDX)./ pi)'*ones(1, bod.stVIDX)).* cosTh;
                
                %4) Vypocet osveteni
                bod.Ev = sum(bod.I .* cosDelta ./ lSB.^2, 1);
                
            %svitici body na strope
            
                %1) vzdalenost sviticiho a osvetlovaneho bodu
                %pouziva se jako jmenovatel, promenna eps zamezi deleni
                %nulou
                lSB= ((bod.x(bod.podIDX+1:bod.strIDX)'*ones(1, bod.stVIDX)-ones(mstn.Nx*mstn.Ny, 1)*bod.x).^2 + (bod.y(bod.podIDX+1:bod.strIDX)'*ones(1, bod.stVIDX)-ones(mstn.Nx*mstn.Ny, 1)*bod.y).^2 + (bod.z(bod.podIDX+1:bod.strIDX)'*ones(1, bod.stVIDX)-ones(mstn.Nx*mstn.Ny, 1)*bod.z).^2).^0.5+eps;
                
                %2) kosiny a siny uhlu 
                %od normaly sviticiho bodu
                cosTh = abs(bod.z(bod.podIDX+1:bod.strIDX)'*ones(1, bod.stVIDX)-ones(mstn.Nx*mstn.Ny, 1)*bod.z)./lSB;
                
                %od normaly osvetlovane plosky
                cosDelta = [(bod.z(bod.podIDX+1:bod.strIDX)'*ones(1, bod.strIDX)-ones(mstn.Nx*mstn.Ny, 1)*bod.z(1:bod.strIDX)), (bod.y(bod.podIDX+1:bod.strIDX)'*ones(1, bod.stSIDX-bod.strIDX)-ones(mstn.Nx*mstn.Ny, 1)*bod.y(bod.strIDX+1:bod.stSIDX)), (bod.x(bod.podIDX+1:bod.strIDX)'*ones(1, bod.stVIDX-bod.stSIDX)-ones(mstn.Nx*mstn.Ny, 1)*bod.x(bod.stSIDX+1:bod.stVIDX))];
                cosDelta = abs(cosDelta)./lSB;
                
                %3) svitivost bodu v jednotlivych uhlech
                bod.I = ((bod.Eo(bod.podIDX+1:bod.strIDX) .* mstn.COstr .* bod.A(bod.podIDX+1:bod.strIDX)./ pi)'*ones(1, bod.stVIDX)).*cosTh;
                
                %4) Vypocet osveteni
                bod.Ev = bod.Ev + sum(bod.I .* cosDelta ./ lSB.^2, 1);
                
            %svitici body na stenach JIH a SEVER
     
                %1) vzdalenost sviticiho a osvetlovaneho bodu
                %pouziva se jako jmenovatel, promenna eps zamezi deleni
                %nulou
                lSB= ((bod.x(bod.strIDX+1:bod.stSIDX)'*ones(1, bod.stVIDX)-ones(2*mstn.Nx*mstn.Nz, 1)*bod.x).^2 + (bod.y(bod.strIDX+1:bod.stSIDX)'*ones(1, bod.stVIDX)-ones(2*mstn.Nx*mstn.Nz, 1)*bod.y).^2 + (bod.z(bod.strIDX+1:bod.stSIDX)'*ones(1, bod.stVIDX)-ones(2*mstn.Nx*mstn.Nz, 1)*bod.z).^2).^0.5+eps;
                
                %2) kosiny a siny uhlu 
                %od normaly sviticiho bodu
                cosTh = abs(bod.y(bod.strIDX+1:bod.stSIDX)'*ones(1, bod.stVIDX)-ones(2*mstn.Nx*mstn.Nz, 1)*bod.y)./lSB;
                
                %od normaly osvetlovane plosky
                cosDelta = [(bod.z(bod.strIDX+1:bod.stSIDX)'*ones(1, bod.strIDX)-ones(2*mstn.Nx*mstn.Nz, 1)*bod.z(1:bod.strIDX)), (bod.y(bod.strIDX+1:bod.stSIDX)'*ones(1, bod.stSIDX-bod.strIDX)-ones(2*mstn.Nx*mstn.Nz, 1)*bod.y(bod.strIDX+1:bod.stSIDX)), (bod.x(bod.strIDX+1:bod.stSIDX)'*ones(1, bod.stVIDX-bod.stSIDX)-ones(2*mstn.Nx*mstn.Nz, 1)*bod.x(bod.stSIDX+1:bod.stVIDX))];
                cosDelta = abs(cosDelta)./lSB;
                
                %3) svitivost bodu v jednotlivych uhlech
                bod.I = ((bod.Eo(bod.strIDX+1:bod.stSIDX) .* mstn.COste .* bod.A(bod.strIDX+1:bod.stSIDX)./ pi)'*ones(1, bod.stVIDX)).*cosTh;
                
                %4) Vypocet osveteni
                bod.Ev = bod.Ev + sum(bod.I .* cosDelta ./ lSB.^2, 1);
                
            %svitici body na stenach ZAPAD a VYCHOD

                %1) vzdalenost sviticiho a osvetlovaneho bodu
                %pouziva se jako jmenovatel, promenna eps zamezi deleni
                %nulou
                lSB= ((bod.x(bod.stSIDX+1:bod.stVIDX)'*ones(1, bod.stVIDX)-ones(2*mstn.Ny*mstn.Nz, 1)*bod.x).^2 + (bod.y(bod.stSIDX+1:bod.stVIDX)'*ones(1, bod.stVIDX)-ones(2*mstn.Ny*mstn.Nz, 1)*bod.y).^2 + (bod.z(bod.stSIDX+1:bod.stVIDX)'*ones(1, bod.stVIDX)-ones(2*mstn.Ny*mstn.Nz, 1)*bod.z).^2).^0.5+eps;
                
                %2) kosiny a siny uhlu 
                %od normaly sviticiho bodu
                cosTh = abs(bod.x(bod.stSIDX+1:bod.stVIDX)'*ones(1, bod.stVIDX)-ones(2*mstn.Ny*mstn.Nz, 1)*bod.x)./lSB;
                
                %od normaly osvetlovane plosky
                cosDelta = [(bod.z(bod.stSIDX+1:bod.stVIDX)'*ones(1, bod.strIDX)-ones(2*mstn.Ny*mstn.Nz, 1)*bod.z(1:bod.strIDX)), (bod.y(bod.stSIDX+1:bod.stVIDX)'*ones(1, bod.stSIDX-bod.strIDX)-ones(2*mstn.Ny*mstn.Nz, 1)*bod.y(bod.strIDX+1:bod.stSIDX)), (bod.x(bod.stSIDX+1:bod.stVIDX)'*ones(1, bod.stVIDX-bod.stSIDX)-ones(2*mstn.Ny*mstn.Nz, 1)*bod.x(bod.stSIDX+1:bod.stVIDX))];
                cosDelta = abs(cosDelta)./lSB;
                
                %3) svitivost bodu v jednotlivych uhlech
                bod.I = ((bod.Eo(bod.stSIDX+1:bod.stVIDX) .* mstn.COste .* bod.A(bod.stSIDX+1:bod.stVIDX)./ pi)'*ones(1, bod.stVIDX)).*cosTh;
                
                %4) Vypocet osveteni
                bod.Ev = bod.Ev + sum(bod.I .* cosDelta ./ lSB.^2, 1);
                
            %Pricteni prirustku k celkove osvetlenosti
            bod.E(clen,:) = bod.E(clen,:) + bod.Ev;
            %Aktualizace osvetlenosti generujici odrazy
            bod.Eo = bod.Ev;
        end
        
        %------------------------------------------------------------------
        %Urceni Osvetlenosti bodu ve srovnavaci rovine od svitidel
        %------------------------------------------------------------------
        %nastaveni pocatecnich podminek
        %pocatecni osvetlenost vsech sten
        bod.Eo = bod.E(clen,:);
        %vynulovani osvetlenosti pod urovni sledovane roviny (mstn.sRov v m)
        bod.Eo = bod.Eo .* (bod.z > mstn.sRov);

        %Pozice svitidel
        x= svt.x'*ones(1, bod.podIDX);
        y= svt.y'*ones(1, bod.podIDX);
        z= svt.z'*ones(1, bod.podIDX);
        
        %1) vzdalenost bodu od svitidla
        lSB = (((x-ones(svt.N, 1)*bod.x(1:bod.podIDX)).^2 + (y-ones(svt.N, 1)*bod.y(1:bod.podIDX)).^2 + (z-ones(svt.N, 1)*bod.z(1:bod.podIDX)-mstn.sRov).^2)).^0.5+eps;

        %2) cosiny a siny uhlu 
        %od normaly svitidla
        %jen tady lze pocitat cosinus bez absolutni hodnoty
        cosTh = (z-ones(svt.N, 1)*bod.z(1:bod.podIDX)-mstn.sRov)./lSB;
        sinTh = (1 - cosTh.^2).^0.5;

        %od normaly plosky
        cosDelta = (z-ones(svt.N, 1)*bod.z(:,1:bod.podIDX)-mstn.sRov);
        cosDelta = abs(cosDelta)./lSB;

        %3) urceni svitivosti v jednotlivych uhlech
        %smazat zaporne cosiny (uhel > 90)
        %vsechny zaporne hodnoty jsou rovny nule
        cosfi = cosTh .* (cosTh > 0);
        bod.I = pop.dna(clen, 7) .* (polyval([pop.dna(clen, 1:2) 0], cosfi).^pop.dna(clen, 3) + polyval([pop.dna(clen, 4:5) 0], sinTh).^pop.dna(clen, 6));

        %4) vypocet osvetleni
        bod.E(clen,1:bod.podIDX)= sum(bod.I .* cosDelta ./ lSB.^2, 1);
        
        %------------------------------------------------------------------
        %Urceni osvetlenosti bodu ve srovnavaci rovine od sten
        %------------------------------------------------------------------

        %STROP
        %1) vzdalenost sviticiho a osvetlovaneho bodu
        %pouziva se jako jmenovatel, promenna eps zamezi deleni
        %nulou
        lSB = ((bod.x(bod.podIDX+1:bod.strIDX)'*ones(1, bod.podIDX)-ones(mstn.Nx*mstn.Ny, 1)*bod.x(1:bod.podIDX)).^2 + (bod.y(bod.podIDX+1:bod.strIDX)'*ones(1, bod.podIDX)-ones(mstn.Nx*mstn.Ny, 1)*bod.y(1:bod.podIDX)).^2 + (bod.z(bod.podIDX+1:bod.strIDX)'*ones(1, bod.podIDX)-ones(mstn.Nx*mstn.Ny, 1)*bod.z(1:bod.podIDX) - mstn.sRov).^2).^0.5+eps;

        %2) kosiny a siny uhlu 
        %od normaly sviticiho bodu
        cosTh = abs(bod.z(bod.podIDX+1:bod.strIDX)'*ones(1, bod.podIDX)-ones(mstn.Nx*mstn.Ny, 1)*bod.z(1:bod.podIDX) - mstn.sRov)./lSB;

        %od normaly osvetlovane plosky
        cosDelta = bod.z(bod.podIDX+1:bod.strIDX)'*ones(1, bod.podIDX)-ones(mstn.Nx*mstn.Ny, 1)*bod.z(1:bod.podIDX) - mstn.sRov;
        cosDelta = abs(cosDelta)./lSB;

        %3) svitivost bodu v jednotlivych uhlech (Eo pod srovnavaci rovinou je nula)
        bod.I = ((bod.Eo(bod.podIDX+1:bod.strIDX) .* mstn.COstr .* bod.A(bod.podIDX+1:bod.strIDX)./ pi)'*ones(1, bod.podIDX)).*cosTh;

        %4) Vypocet osveteni
        bod.Ev = sum(bod.I .* cosDelta ./ lSB.^2, 1);

        %STENY JIH a SEVER
        %1) vzdalenost sviticiho a osvetlovaneho bodu
        %pouziva se jako jmenovatel, promenna eps zamezi deleni
        %nulou
        lSB= ((bod.x(bod.strIDX+1:bod.stSIDX)'*ones(1, bod.podIDX)-ones(2*mstn.Nx*mstn.Nz, 1)*bod.x(1:bod.podIDX)).^2 + (bod.y(bod.strIDX+1:bod.stSIDX)'*ones(1, bod.podIDX)-ones(2*mstn.Nx*mstn.Nz, 1)*bod.y(1:bod.podIDX)).^2 + (bod.z(bod.strIDX+1:bod.stSIDX)'*ones(1, bod.podIDX)-ones(2*mstn.Nx*mstn.Nz, 1)*bod.z(1:bod.podIDX) - mstn.sRov).^2).^0.5+eps;

        %2) kosiny a siny uhlu 
        %od normaly sviticiho bodu
        cosTh = abs(bod.y(bod.strIDX+1:bod.stSIDX)'*ones(1, bod.podIDX)-ones(2*mstn.Nx*mstn.Nz, 1)*bod.y(1:bod.podIDX))./lSB;

        %od normaly osvetlovane plosky
        cosDelta = bod.z(bod.strIDX+1:bod.stSIDX)'*ones(1, bod.podIDX)-ones(2*mstn.Nx*mstn.Nz, 1)*bod.z(1:bod.podIDX) - mstn.sRov;
        cosDelta = abs(cosDelta)./lSB;

        %3) svitivost bodu v jednotlivych uhlech (Eo pod srovnavaci rovinou je nula)
        bod.I = ((bod.Eo(bod.strIDX+1:bod.stSIDX) .* mstn.COste .* bod.A(bod.strIDX+1:bod.stSIDX)./ pi)'*ones(1, bod.podIDX)).*cosTh;

        %4) Vypocet osveteni
        bod.Ev = bod.Ev + sum(bod.I .* cosDelta ./ lSB.^2, 1);

        %STENY ZAPAD a VYCHOD
        %1) vzdalenost sviticiho a osvetlovaneho bodu
        %pouziva se jako jmenovatel, promenna eps zamezi deleni
        %nulou
        lSB= ((bod.x(bod.stSIDX+1:bod.stVIDX)'*ones(1, bod.podIDX)-ones(2*mstn.Ny*mstn.Nz, 1)*bod.x(1:bod.podIDX)).^2 + (bod.y(bod.stSIDX+1:bod.stVIDX)'*ones(1, bod.podIDX)-ones(2*mstn.Ny*mstn.Nz, 1)*bod.y(1:bod.podIDX)).^2 + (bod.z(bod.stSIDX+1:bod.stVIDX)'*ones(1, bod.podIDX)-ones(2*mstn.Ny*mstn.Nz, 1)*bod.z(1:bod.podIDX) - mstn.sRov).^2).^0.5+eps;

        %2) kosiny a siny uhlu 
        %od normaly sviticiho bodu
        cosTh = abs(bod.x(bod.stSIDX+1:bod.stVIDX)'*ones(1, bod.podIDX)-ones(2*mstn.Ny*mstn.Nz, 1)*bod.x(1:bod.podIDX))./lSB;

        %od normaly osvetlovane plosky
        cosDelta = bod.z(bod.stSIDX+1:bod.stVIDX)'*ones(1, bod.podIDX)-ones(2*mstn.Ny*mstn.Nz, 1)*bod.z(1:bod.podIDX) - mstn.sRov;
        cosDelta = abs(cosDelta)./lSB;

        %3) svitivost bodu v jednotlivych uhlech
        bod.I = ((bod.Eo(bod.stSIDX+1:bod.stVIDX) .* mstn.COste .* bod.A(bod.stSIDX+1:bod.stVIDX)./ pi)'*ones(1, bod.podIDX)).*cosTh;

        %4) Vypocet osveteni
        bod.Ev = bod.Ev + sum(bod.I .* cosDelta ./ lSB.^2, 1);
        
        %Hodnota osvetleni na podlaze je nahrazena hodnotou osvetleni na
        %srovnavaci rovine
        bod.E(clen, 1:bod.podIDX)= bod.E(clen, 1:bod.podIDX) + bod.Ev;
        
        %------------------------------------------------------------------
        %Urceni toku
        %------------------------------------------------------------------
        cosTh = cos(svt.theta);
        sinTh = (1 - cosTh.^2).^0.5;
        cosTh = cosTh .* (cosTh > 0);
        svt.I = pop.dna(clen, 7) .* (polyval([pop.dna(clen, 1:2) 0], cosTh).^pop.dna(clen, 3) + polyval([pop.dna(clen, 4:5) 0], sinTh).^pop.dna(clen, 6));
        svt.OmegaTh= 4*pi*pi*sinTh/360;
        svt.Fi(clen)= sum(svt.I.*svt.OmegaTh);
    end
    
    %------------------------------------------------------------------
    %Urceni fitness funkce clenu populace
    %------------------------------------------------------------------
    %Prumerna hodnota osvetlenosti na podlaze
    pop.Eavg = sum(bod.E(:,1:bod.podIDX), 2)./bod.podIDX;

    %Rovnomernost
    pop.Uo = min(bod.E(:,1:bod.podIDX),[],2)./pop.Eavg;
    pop.var = sum((bod.E(:,1:bod.podIDX) - pop.Eavg*ones(1,bod.podIDX)).^2, 2)./bod.podIDX;
    pop.var = (pop.var.^0.5)./pop.Eavg;
    
    %Vysledna fitness
    pop.FIT = (0.01 + ((10*(target.Uo-pop.Uo)).^2).*(pop.Uo < target.Uo) + (0.1*(pop.Eavg-target.Eavg)).^2).*svt.Fi;
%     pop.FIT = (1 + ((10*(target.Uo-pop.Uo)).^2) + (0.1*(pop.Eavg-target.Eavg)).^2).*svt.Fi;
%     pop.FIT = (pop.var.^2 + (0.1*(pop.Eavg-target.Eavg)).^2).*svt.Fi;
     
    %Pravdepodobnosti vyberu clena populace jako rodice
    pop.prVyb =1./pop.FIT./ sum(1./pop.FIT);
    
    %======================================================================
    %MEZIVYSEDKY - zobrazeni
    %======================================================================
    %nejlepsi vysledek generace
    [PRAV, IDX]= max(pop.prVyb);
    %Vyneseni fitness funkce
    figure(2)
    subplot(2,2,1)
    pop.fitness(generace:end) = log(pop.FIT(IDX));
    plot(pop.fitness);
    title(sprintf('E_{avg} = %0.0f lx, U_{o}= %0.2f, Flux = %0.0f lm', pop.Eavg(IDX), pop.Uo(IDX), svt.Fi(IDX)));
    xlabel('historie (n)')
    ylabel('Fitness');
    grid on;
    
    %Zobrazeni nejlepsiho vysledku teto generace
    subplot(2,2,2)
    %Vyneseni polarniho grafu
    cosTh = cos([svt.theta,(svt.theta+pi)]);
    sinTh = (1 - cosTh.^2).^0.5;
    cosTh = cosTh .* (cosTh > 0);
    svt.I = pop.dna(IDX, 7) .* (polyval([pop.dna(IDX, 1:2) 0], cosTh).^pop.dna(IDX, 3) + polyval([pop.dna(IDX, 4:5) 0], sinTh).^pop.dna(IDX, 6));
    set(polar([svt.theta,(svt.theta+pi)],svt.I),'color','r','linewidth',2)
    view([90, 90]);
    title(sprintf('Nejlepsi jedinec, generace = %i, P_{vyberu}= %3.2f %%', generace, pop.prVyb(IDX)*100));
    grid on;
    
    subplot(2,2,3)
    %figure(3)
    bod.ME = vec2mat(bod.E(IDX,1:bod.podIDX),mstn.Nx);
    surf(mstn.bx,mstn.by,bod.ME);
    xlabel('x (m)');
    ylabel('y (m)');
    zlabel('E (lx)');
    
    subplot(2,2,4)
    %figure(4)
    %pcolor(mstn.bx,mstn.by,bod.ME);
    plot(svt.x, svt.y);%kvuli spravnym souradnicim
    hold on;
    image(mstn.bx,mstn.by,bod.ME,'CDataMapping','scaled');
    plot(svt.x, svt.y, 'o', 'MarkerSize', 10, 'LineWidth', 2, 'MarkerFaceColor', 'y', 'MarkerEdgeColor', 'k');
    xlabel('x (m)');
    ylabel('y (m)');
    axis([0 mstn.x 0 mstn.y]);
    hold off;
    
    drawnow; %Vykreslit grafy behem cyklu
    %======================================================================
   
    %Pokud se nejedna o posledni generaci, tak najit potomky
    if generace < pop.gen
        pop.dnaP = zeros(pop.N,pop.DNAlength);
        %------------------------------------------------------------------
        %ELITISMUS - vyber nejlepsiho clena populace na prvni misto
        %------------------------------------------------------------------
        pop.dnaP(1,:) = pop.dna(IDX,:); %tento clen nebude mutovat
        pop.dnaP(2,:) = pop.dna(IDX,:); %tento clen muze mutovat
        %------------------------------------------------------------------
        %KRIZENI - vyber rodicu a vytvareni potomku
        %------------------------------------------------------------------
        %opakovat hledani dokud nebude vytvorena nova populace velikosti N
        pop.i= zeros(1,3);
        pop.p= zeros(1,2);
        for clen = 3:2:pop.N
            %Turnajovy vyber rodicu
            %Index prvniho rodice
            pravdepodobnost = ceil(pop.N*rand(1,pop.N_turnament)+eps);
            [pop.p(1), pop.i(1)]= max(pop.prVyb(pravdepodobnost));
            pop.i(1)= pravdepodobnost(pop.i(1));

            %Index druheho rodice
            pravdepodobnost = ceil(pop.N*rand(1,pop.N_turnament)+eps);
            [pop.p(2), pop.i(2)]= max(pop.prVyb(pravdepodobnost));
            pop.i(2)= pravdepodobnost(pop.i(2));

            %Krizeni - podle indexu a dle pravdepodobnosti krizeni
            pop.i(3)= ceil(pop.DNAlength*rand(1,1)/pop.kriz + eps);
            if pop.i(3) >= (pop.DNAlength) %zde nekrizit
                pop.dnaP(clen, :) = pop.dna(pop.i(1), :);
                pop.dnaP(clen+1, :) = pop.dna(pop.i(2), :);
            else %zde krizit
                pop.dnaP(clen, :) = [pop.dna(pop.i(1), (1:pop.i(3))), pop.dna(pop.i(2), (pop.i(3)+1):end)];
                pop.dnaP(clen+1, :) = [pop.dna(pop.i(2), (1:pop.i(3))), pop.dna(pop.i(1), (pop.i(3)+1):end)];
            end
        end

        %------------------------------------------------------------------
        %MUTACE potomku
        %------------------------------------------------------------------
        %POZOR: prvni clen nesmi mutovat
        pravdepodobnost= rand(pop.N-1,pop.DNAlength);
        pop.mutace = zeros(pop.N-1,7);
        pop.mutace(:,1:1:6) = pop.stepPar .* randn(pop.N-1,6);
        pop.mutace(:,7) = pop.stepI0 .* randn(pop.N-1, 1);
        %zvyseni hodnoty
        pop.mutace = pop.mutace .* (pravdepodobnost <= pop.mut);
        pop.dnaP(2:end, :) = pop.dnaP(2:end, :) + pop.mutace;
        %omezeni zdola
        pop.mutace = (ones(pop.N-1,1)*pop.dnaMin) .* (pop.dnaP(2:end,:) < (ones(pop.N-1,1)*pop.dnaMin));
        pop.dnaP(2:end,:) = pop.dnaP(2:end,:) .* (pop.dnaP(2:end,:) >= (ones(pop.N-1,1)*pop.dnaMin));
        pop.dnaP(2:end,:) = pop.dnaP(2:end,:) + pop.mutace;
        %omezeni shora
        pop.mutace = (ones(pop.N-1,1)*pop.dnaMax) .* (pop.dnaP(2:end,:) > (ones(pop.N-1,1)*pop.dnaMax));
        pop.dnaP(2:end,:) = pop.dnaP(2:end,:) .* (pop.dnaP(2:end,:) <= (ones(pop.N-1,1)*pop.dnaMax));
        pop.dnaP(2:end,:) = pop.dnaP(2:end,:) + pop.mutace;
        
        %------------------------------------------------------------------
        %NOVA GENERACE
        %------------------------------------------------------------------
        pop.dna = pop.dnaP;
    end
end

clear clen;
clear cosTh;
clear generace;
clear i;
clear I0;
clear lsq;
clear mez;
clear odraz;
clear pravdepodobnost;
clear rov;
clear sinTh;
clear x;
clear y;
clear z;
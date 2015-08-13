1;%pro octave, aby bylo zrejme, ze tento soubor neni funkce
clear;
clc;
close;
%Reseni rozmisteni svetel pomoci genetickeho algoritmu. Na zacatku se zvoli
%pocet svitidel a jejich vyzarovaci charakteristika.
%DNA: x, y, x, y, x, y,... zavisi na poctu svitidel, posledni je svitivost
%v nulovem uhlu I0
%Krizeni: jednobodove (udat pravdepodobnost)
                pop.kriz = 0.9;
%Mutace (pomerna hodnota):
                pop.mut = 0.15;
%Pocet generací:
                pop.gen = 200;
%Velikost populace:
                pop.N = 150;
%Pocet jedincu v turnaji:
                pop.N_turnament = 4;
%krok pozice:
                pop.stepXY = 1;
%krok svitivosti:
                pop.stepI0 = 100;
%Rozmery mistnosti v m:
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
%Prumerna hladina osvetlenosti:
                target.Eavg = 500;
%Rovnomernost:
                target.Uo = 0.6;

%--------------------------------------------------------------------------
%PARAMETRY ODRAZU
%Uvazovany pocet odrazu:
                mstn.Nodr = 3;
%Vyska srovnavaci roviny:
                mstn.sRov = 0.8;
                
%--------------------------------------------------------------------------
%PARAMETRY SVITIDEL
%Krivka svitivosti
                svt.I = [4000*cos(0:pi/200:(pi/2-pi/200)) zeros(1,100)];
%Vyska svitidel:
                svt.z = 3.5;
%Pocet svitidel:
                svt.N = 6;

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
%N... pocet bodu na stene
%E... osvetleni
%E0... pocatecni osvetlenost generujici odraz ve vypoctu odrazu
%Ep... prirustek osvetleni ve vypoctu odrazu
%co... cinitel odrazu
%nv... normalovy vektor
for idx= 1:1:mstn.Ny
    podlaha.x((((idx-1)*mstn.Nx)+1):(idx*mstn.Nx)) = mstn.bx;
    podlaha.y((((idx-1)*mstn.Nx)+1):(idx*mstn.Nx)) = ones(1, mstn.Nx).*mstn.by(idx);
    podlaha.z((((idx-1)*mstn.Nx)+1):(idx*mstn.Nx)) = zeros(1, mstn.Nx);
end
podlaha.A = ones(1, mstn.Nx*mstn.Ny).* (mstn.x*mstn.y)/ mstn.Nx/ mstn.Ny;
podlaha.N = mstn.Nx*mstn.Ny;
podlaha.E = 0;
podlaha.E0 = 0;
podlaha.Ep = 0;
podlaha.co = 0.2;
podlaha.nv = [0 0 1];

for idx= 1:1:mstn.Ny
    strop.x((((idx-1)*mstn.Nx)+1):(idx*mstn.Nx)) = mstn.bx;
    strop.y((((idx-1)*mstn.Nx)+1):(idx*mstn.Nx)) = ones(1, mstn.Nx).*mstn.by(idx);
    strop.z((((idx-1)*mstn.Nx)+1):(idx*mstn.Nx)) = ones(1, mstn.Nx).*mstn.z;
end
strop.A = ones(1, mstn.Nx*mstn.Ny).*(mstn.x*mstn.y)/ mstn.Nx/ mstn.Ny;
strop.N = mstn.Nx*mstn.Ny;
strop.E = 0;
strop.E0 = 0;
strop.Ep = 0;
strop.co = 0.7;
strop.nv = [0 0 -1];

for idx= 1:1:mstn.Nz
    stenaJ.x((((idx-1)*mstn.Nx)+1):(idx*mstn.Nx)) = mstn.bx;
    stenaJ.y((((idx-1)*mstn.Nx)+1):(idx*mstn.Nx)) = zeros(1, mstn.Nx);
    stenaJ.z((((idx-1)*mstn.Nx)+1):(idx*mstn.Nx)) = ones(1, mstn.Nx).*mstn.bz(idx);
end
stenaJ.A = ones(1, mstn.Nx*mstn.Nz).*(mstn.x*mstn.z)/ mstn.Nx/ mstn.Nz;
stenaJ.N = mstn.Nx*mstn.Nz;
stenaJ.E = 0;
stenaJ.E0 = 0;
stenaJ.Ep = 0;
stenaJ.co = 0.5;
stenaJ.nv = [0 1 0];

for idx= 1:1:mstn.Nz
    stenaS.x((((idx-1)*mstn.Nx)+1):(idx*mstn.Nx)) = mstn.bx;
    stenaS.y((((idx-1)*mstn.Nx)+1):(idx*mstn.Nx)) = ones(1, mstn.Nx).*mstn.y;
    stenaS.z((((idx-1)*mstn.Nx)+1):(idx*mstn.Nx)) = ones(1, mstn.Nx).*mstn.bz(idx);
end
stenaS.A = ones(1, mstn.Nx*mstn.Nz).*(mstn.x*mstn.z)/ mstn.Nx/ mstn.Nz;
stenaS.N = mstn.Nx*mstn.Nz;
stenaS.E = 0;
stenaS.E0 = 0;
stenaS.Ep = 0;
stenaS.co = 0.5;
stenaS.nv = [0 -1 0];

for idx= 1:1:mstn.Nz
    stenaZ.x((((idx-1)*mstn.Ny)+1):(idx*mstn.Ny)) = zeros(1, mstn.Ny);
    stenaZ.y((((idx-1)*mstn.Ny)+1):(idx*mstn.Ny)) = mstn.by;
    stenaZ.z((((idx-1)*mstn.Ny)+1):(idx*mstn.Ny)) = ones(1, mstn.Ny).*mstn.bz(idx);
end
stenaZ.A = ones(1, mstn.Ny*mstn.Nz).*(mstn.y*mstn.z)/ mstn.Ny/ mstn.Nz;
stenaZ.N = mstn.Ny*mstn.Nz;
stenaZ.E = 0;
stenaZ.E0 = 0;
stenaZ.Ep = 0;
stenaZ.co = 0.5;
stenaZ.nv = [1 0 0];

for idx= 1:1:mstn.Nz
    stenaV.x((((idx-1)*mstn.Ny)+1):(idx*mstn.Ny)) = ones(1, mstn.Ny).*mstn.x;
    stenaV.y((((idx-1)*mstn.Ny)+1):(idx*mstn.Ny)) = mstn.by;
    stenaV.z((((idx-1)*mstn.Ny)+1):(idx*mstn.Ny)) = ones(1, mstn.Ny).*mstn.bz(idx);
end
stenaV.A = ones(1, mstn.Ny*mstn.Nz).*(mstn.y*mstn.z)/ mstn.Ny/ mstn.Nz;
stenaV.N = mstn.Ny*mstn.Nz;
stenaV.E = 0;
stenaV.E0 = 0;
stenaV.Ep = 0;
stenaV.co = 0.5;
stenaV.nv = [-1 0 0];

%--------------------------------------------------------------------------
%GENEROVANI DNA POCATECNICH POPULACI
%DNA: liche pozice x, sude pozice y
%Pocatecni populace je nahodna:
pop.dnaDelka = 2*svt.N;
pop.dna = zeros(pop.N, pop.dnaDelka);
pop.dna(:,1:2:(pop.dnaDelka-1)) = mstn.x.*rand(pop.N,svt.N);
pop.dna(:,2:2:pop.dnaDelka) = mstn.y.*rand(pop.N,svt.N);

%--------------------------------------------------------------------------
%SMYCKA GENETICKEHO ALGORITMU
%--------------------------------------------------------------------------
%opakovat tolikrat, kolik je pozadovano generaci
for generace = 1:1:pop.gen
    %vynulovani sledovanych promennych
    pop.E = zeros(pop.N, podlaha.N);
    
    %----------------------------------------------------------------------
    %Vypocet osvetleni vsech bodu pro kazdeho clena populace
    for clen = 1:1:pop.N
        %------------------------------------------------------------------
        %Vsechna svitidla tohoto clena populace vuci bodum mistnosti
        %------------------------------------------------------------------
        x1 = pop.dna(clen, 1:2:((2*svt.N)-1));
        y1 = pop.dna(clen, 2:2:(2*svt.N));
        z1 = svt.z*ones(1, svt.N);
        nv1 = [0 0 -1];
        
        %PODLAHA
        x2 = podlaha.x;
        y2 = podlaha.y;
        z2 = podlaha.z;
        nv2 = podlaha.nv;
        podlaha.E = osvSvitTh(x1,y1,z1,x2,y2,z2,nv1,nv2,svt.I);
        
        %STROP
        x2 = strop.x;
        y2 = strop.y;
        z2 = strop.z;
        nv2 = strop.nv;
        strop.E = osvSvitTh(x1,y1,z1,x2,y2,z2,nv1,nv2,svt.I);
        
        %STENA J
        x2 = stenaJ.x;
        y2 = stenaJ.y;
        z2 = stenaJ.z;
        nv2 = stenaJ.nv;
        stenaJ.E = osvSvitTh(x1,y1,z1,x2,y2,z2,nv1,nv2,svt.I);
        
        %STENA S
        x2 = stenaS.x;
        y2 = stenaS.y;
        z2 = stenaS.z;
        nv2 = stenaS.nv;
        stenaS.E = osvSvitTh(x1,y1,z1,x2,y2,z2,nv1,nv2,svt.I);
        
        %STENA Z
        x2 = stenaZ.x;
        y2 = stenaZ.y;
        z2 = stenaZ.z;
        nv2 = stenaZ.nv;
        stenaZ.E = osvSvitTh(x1,y1,z1,x2,y2,z2,nv1,nv2,svt.I);
        
        %STENA V
        x2 = stenaV.x;
        y2 = stenaV.y;
        z2 = stenaV.z;
        nv2 = stenaV.nv;
        stenaV.E = osvSvitTh(x1,y1,z1,x2,y2,z2,nv1,nv2,svt.I);
        
        %------------------------------------------------------------------
        %Vypocet odrazu mezi stenami
        %------------------------------------------------------------------
        podlaha.E0 = podlaha.E;
        strop.E0 = strop.E;
        stenaJ.E0 = stenaJ.E;
        stenaS.E0 = stenaS.E;
        stenaZ.E0 = stenaZ.E;
        stenaV.E0 = stenaV.E;
        
        for odraz = 1:1:mstn.Nodr
            
            podlaha.Ep = 0;
            strop.Ep = 0;
            stenaJ.Ep = 0;
            stenaS.Ep = 0;
            stenaZ.Ep = 0;
            stenaV.Ep = 0;

            %PODLAHA + neco
            x1 = podlaha.x;
            y1 = podlaha.y;
            z1 = podlaha.z;
            nv1 = podlaha.nv;
            fi01 = podlaha.E0.* podlaha.co.* podlaha.A;

            x2 = strop.x;
            y2 = strop.y;
            z2 = strop.z;
            nv2 = strop.nv;
            fi02 = strop.E0.* strop.co.* strop.A;
            [Ep1, Ep2] = osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);

            podlaha.Ep = Ep1;
            strop.Ep = Ep2;

            x2 = stenaJ.x;
            y2 = stenaJ.y;
            z2 = stenaJ.z;
            nv2 = stenaJ.nv;
            fi02 = stenaJ.E0.* stenaJ.co.* stenaJ.A;
            [Ep1, Ep2] = osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);

            podlaha.Ep = podlaha.Ep + Ep1;
            stenaJ.Ep = Ep2;

            x2 = stenaS.x;
            y2 = stenaS.y;
            z2 = stenaS.z;
            nv2 = stenaS.nv;
            fi02 = stenaS.E0.* stenaS.co.* stenaS.A;
            [Ep1, Ep2] = osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);

            podlaha.Ep = podlaha.Ep + Ep1;
            stenaS.Ep = Ep2;

            x2 = stenaZ.x;
            y2 = stenaZ.y;
            z2 = stenaZ.z;
            nv2 = stenaZ.nv;
            fi02 = stenaZ.E0.* stenaZ.co.* stenaZ.A;
            [Ep1, Ep2] = osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);

            podlaha.Ep = podlaha.Ep + Ep1;
            stenaZ.Ep = Ep2;

            x2 = stenaV.x;
            y2 = stenaV.y;
            z2 = stenaV.z;
            nv2 = stenaV.nv;
            fi02 = stenaV.E0.* stenaV.co.* stenaV.A;
            [Ep1, Ep2] = osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);

            podlaha.Ep = podlaha.Ep + Ep1;
            stenaV.Ep = Ep2;

            %STROP + neco
            x1 = strop.x;
            y1 = strop.y;
            z1 = strop.z;
            nv1 = strop.nv;
            fi01 = strop.E0.* strop.co.* strop.A;

            x2 = stenaJ.x;
            y2 = stenaJ.y;
            z2 = stenaJ.z;
            nv2 = stenaJ.nv;
            fi02 = stenaJ.E0.* stenaJ.co.* stenaJ.A;
            [Ep1, Ep2] = osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);

            strop.Ep = strop.Ep + Ep1;
            stenaJ.Ep = stenaJ.Ep + Ep2;

            x2 = stenaS.x;
            y2 = stenaS.y;
            z2 = stenaS.z;
            nv2 = stenaS.nv;
            fi02 = stenaS.E0.* stenaS.co.* stenaS.A;
            [Ep1, Ep2] = osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);

            strop.Ep = strop.Ep + Ep1;
            stenaS.Ep = stenaS.Ep + Ep2;

            x2 = stenaZ.x;
            y2 = stenaZ.y;
            z2 = stenaZ.z;
            nv2 = stenaZ.nv;
            fi02 = stenaZ.E0.* stenaZ.co.* stenaZ.A;
            [Ep1, Ep2] = osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);

            strop.Ep = strop.Ep + Ep1;
            stenaZ.Ep = stenaZ.Ep + Ep2;

            x2 = stenaV.x;
            y2 = stenaV.y;
            z2 = stenaV.z;
            nv2 = stenaV.nv;
            fi02 = stenaV.E0.* stenaV.co.* stenaV.A;
            [Ep1, Ep2] = osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);

            strop.Ep = strop.Ep + Ep1;
            stenaV.Ep = stenaV.Ep + Ep2;

            %STENA J + neco
            x1 = stenaJ.x;
            y1 = stenaJ.y;
            z1 = stenaJ.z;
            nv1 = stenaJ.nv;
            fi01 = stenaJ.E0.* stenaJ.co.* stenaJ.A;

            x2 = stenaS.x;
            y2 = stenaS.y;
            z2 = stenaS.z;
            nv2 = stenaS.nv;
            fi02 = stenaS.E0.* stenaS.co.* stenaS.A;
            [Ep1, Ep2] = osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);

            stenaJ.Ep = stenaJ.Ep + Ep1;
            stenaS.Ep = stenaS.Ep + Ep2;

            x2 = stenaZ.x;
            y2 = stenaZ.y;
            z2 = stenaZ.z;
            nv2 = stenaZ.nv;
            fi02 = stenaZ.E0.* stenaZ.co.* stenaZ.A;
            [Ep1, Ep2] = osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);

            stenaJ.Ep = stenaJ.Ep + Ep1;
            stenaZ.Ep = stenaZ.Ep + Ep2;

            x2 = stenaV.x;
            y2 = stenaV.y;
            z2 = stenaV.z;
            nv2 = stenaV.nv;
            fi02 = stenaV.E0.* stenaV.co.* stenaV.A;
            [Ep1, Ep2] = osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);

            stenaJ.Ep = stenaJ.Ep + Ep1;
            stenaV.Ep = stenaV.Ep + Ep2;

            %STENA S + neco
            x1 = stenaS.x;
            y1 = stenaS.y;
            z1 = stenaS.z;
            nv1 = stenaS.nv;
            fi01 = stenaS.E0.* stenaS.co.* stenaS.A;

            x2 = stenaZ.x;
            y2 = stenaZ.y;
            z2 = stenaZ.z;
            nv2 = stenaZ.nv;
            fi02 = stenaZ.E0.* stenaZ.co.* stenaZ.A;
            [Ep1, Ep2] = osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);

            stenaS.Ep = stenaS.Ep + Ep1;
            stenaZ.Ep = stenaZ.Ep + Ep2;

            x2 = stenaV.x;
            y2 = stenaV.y;
            z2 = stenaV.z;
            nv2 = stenaV.nv;
            fi02 = stenaV.E0.* stenaV.co.* stenaV.A;
            [Ep1, Ep2] = osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);

            stenaS.Ep = stenaS.Ep + Ep1;
            stenaV.Ep = stenaV.Ep + Ep2;

            %STENA Z + STENA V
            x1 = stenaZ.x;
            y1 = stenaZ.y;
            z1 = stenaZ.z;
            nv1 = stenaZ.nv;
            fi01 = stenaZ.E0.* stenaZ.co.* stenaZ.A;

            x2 = stenaV.x;
            y2 = stenaV.y;
            z2 = stenaV.z;
            nv2 = stenaV.nv;
            fi02 = stenaV.E0.* stenaV.co.* stenaV.A;
            [Ep1, Ep2] = osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);

            stenaZ.Ep = stenaZ.Ep + Ep1;
            stenaV.Ep = stenaV.Ep + Ep2;
            
            %--------------------------------------------------------------
            %Pripocteni prirustku osvetleni daneho odrazy
            %--------------------------------------------------------------
            podlaha.E0 = podlaha.Ep;
            strop.E0 = strop.Ep;
            stenaJ.E0 = stenaJ.Ep;
            stenaS.E0 = stenaS.Ep;
            stenaZ.E0 = stenaZ.Ep;
            stenaV.E0 = stenaV.Ep;
            
            podlaha.E = podlaha.E + podlaha.Ep;
            strop.E = strop.E + strop.Ep;
            stenaJ.E = stenaJ.E + stenaJ.Ep;
            stenaS.E = stenaS.E + stenaS.Ep;
            stenaZ.E = stenaZ.E + stenaZ.Ep;
            stenaV.E = stenaV.E + stenaV.Ep;
        end
        %------------------------------------------------------------------
        %Ulozeni sledovanych parametru tohoto clena populace
        %------------------------------------------------------------------
        pop.E(clen, :) = podlaha.E;
    end
    %----------------------------------------------------------------------
    %Urceni fitness
    %----------------------------------------------------------------------
    %prumerna osvetlenost, kazdy radek jeden clen
    pop.Eavg = sum(pop.E, 2)./ podlaha.N;
    %rovnomernost, kazdy radek jeden clen
    pop.Uo = min(pop.E,[],2)./pop.Eavg;
    
    %fitness
    pop.fitness = 2 - exp(-pop.Eavg./ target.Eavg);
    pop.fitness = pop.fitness - exp(-pop.Uo./ target.Uo);
    pop.fitness = pop.fitness./ 2;
    %pravdepodobnost vyberu
    pop.pravdep = pop.fitness./ sum(pop.fitness, 1);
    
    %----------------------------------------------------------------------
    %Generovani nove populace
    %----------------------------------------------------------------------
    pop.dnaPotomku = zeros(pop.N,pop.dnaDelka);
    %----------------------------------------------------------------------
    %ELITISMUS - vyber nejlepsiho clena populace na prvni misto
    %----------------------------------------------------------------------
    [elita.p, elita.idx]= max(pop.pravdep);
    %tento clen nebude mutovat
    pop.dnaPotomku(1,:) = pop.dna(elita.idx,:);
    %tento clen muze mutovat
    pop.dnaPotomku(2,:) = pop.dna(elita.idx,:);
    %----------------------------------------------------------------------
    %Krizeni
    %----------------------------------------------------------------------
    for clen = 3:2:pop.N
        %Vyber potomku na zaklade souteze mezi nekolika nahodnymi
        idx = ceil(pop.N*rand(1,pop.N_turnament)+eps);
        [rodicA.p, rodicA.idx]= max(pop.pravdep(idx));
        rodicA.idx = idx(rodicA.idx);

        idx = ceil(pop.N*rand(1,pop.N_turnament)+eps);
        [rodicB.p, rodicB.idx]= max(pop.pravdep(idx));
        rodicB.idx = idx(rodicB.idx);

        %Krizeni - podle indexu a dle pravdepodobnosti krizeni
        idx= ceil(pop.dnaDelka*rand(1,1)/pop.kriz + eps);
        if idx >= pop.dnaDelka %zde nekrizit
            pop.dnaPotomku(clen, :) = pop.dna(rodicA.idx, :);
            pop.dnaPotomku(clen+1, :) = pop.dna(rodicB.idx, :);
        else %zde krizit
            pop.dnaPotomku(clen, :) = [pop.dna(rodicA.idx, (1:idx)), pop.dna(rodicB.idx, (idx+1):end)];
            pop.dnaPotomku(clen+1, :) = [pop.dna(rodicB.idx, (1:idx)), pop.dna(rodicA.idx, (idx+1):end)];
        end
    end
    %----------------------------------------------------------------------
    %Mutace
    %----------------------------------------------------------------------
    %POZOR: prvni clen nesmi mutovat
    %Uvazovano normalni rozdeleni prirustku mutace
    mut= rand(pop.N-1,pop.dnaDelka);
    pop.mutace = pop.stepXY .* randn(pop.N-1,pop.dnaDelka);

    %zvyseni hodnoty
    pop.mutace = pop.mutace .* (mut <= pop.mut);
    pop.dnaPotomku(2:end, :) = pop.dnaPotomku(2:end, :)+ pop.mutace;

    %omezeni zdola je pro obe souradnice stejne
    pop.dnaPotomku(2:end, :) = pop.dnaPotomku(2:end, :).* (pop.dnaPotomku(2:end, :) > 0);
    %omezeni shora pro souradnici x
    pop.mutace = mstn.x * (pop.dnaPotomku(2:end, 1:2:(pop.dnaDelka-1)) > mstn.x);
    pop.dnaPotomku(2:end, 1:2:(pop.dnaDelka-1)) = pop.dnaPotomku(2:end, 1:2:(pop.dnaDelka-1)) .* (pop.dnaPotomku(2:end, 1:2:(pop.dnaDelka-1)) <= mstn.x);
    pop.dnaPotomku(2:end, 1:2:(pop.dnaDelka-1)) = pop.dnaPotomku(2:end, 1:2:(pop.dnaDelka-1)) + pop.mutace;
    %omezeni shora pro souradnici y
    pop.mutace = mstn.y * (pop.dnaPotomku(2:end, 2:2:pop.dnaDelka) > mstn.y);
    pop.dnaPotomku(2:end, 2:2:pop.dnaDelka) = pop.dnaPotomku(2:end, 2:2:pop.dnaDelka) .* (pop.dnaPotomku(2:end, 2:2:(2*svt.N)) <= mstn.y);
    pop.dnaPotomku(2:end, 2:2:pop.dnaDelka) = pop.dnaPotomku(2:end, 2:2:pop.dnaDelka) + pop.mutace;

    %----------------------------------------------------------------------
    %NOVA GENERACE
    %----------------------------------------------------------------------
    pop.dna = pop.dnaPotomku;
    
    fprintf('Generace: %d\n',generace);
    fprintf('Nejlepsi jedinec: Eavg= %4.2f lx, Uo= %2.2f\n',pop.Eavg(elita.idx),pop.Uo(elita.idx));
    fprintf('Fitness= %2.4f\n',pop.fitness(elita.idx));
end
%--------------------------------------------------------------------------
%Zobrazeni vysledku
%--------------------------------------------------------------------------
figure(1)
bod.ME = vec2mat(pop.E(elita.idx,:),mstn.Nx);
surf(mstn.bx,mstn.by,bod.ME);
xlabel('x (m)');
ylabel('y (m)');
zlabel('E (lx)');

figure(2)
plot(pop.dna(elita.idx,1:2:(pop.dnaDelka-1)), pop.dna(elita.idx,2:2:(pop.dnaDelka)), 'o', 'MarkerSize', 10, 'LineWidth', 2, 'MarkerFaceColor', 'y', 'MarkerEdgeColor', 'k');
xlabel('x (m)');
ylabel('y (m)');
axis([0 mstn.x 0 mstn.y]);
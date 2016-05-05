1;%pro octave, aby bylo zrejme, ze tento soubor neni funkce
clear;
clc;
close;
%Tento script ma upravenou fittness funkci.
%Vstupem je krivka svitivosti v soubooru csv. Gain udava nasobek vsech
%hodnot v krivce svitivosti.
filenameinput = 'MSTR_SLB_4x18W_5G4';
ID = '_Fit2';
gain = 5.4;
%Reseni rozmisteni svetel pomoci genetickeho algoritmu. Algorytmus vklada
%svitidla do rovnomerneho rastru.
%DNA: Uava logickou hodnotu platnosti souradnice v rastru. Pro 0 neni
%svitidlo na dane pozici, pro 1 je na dane poyici svitidlo. Kvuli zachovani
%symetrie rozmisteni, je DNA zrcadlove rozkopirovano pro druhou polovinu
%souradnic.
%Typ symetrie: 0 = stredova, 1 = osova
pop.sym = 0;
%Krizeni: jednobodove (udat pravdepodobnost)
                pop.kriz = 0.9;
%Mutace (pomerna hodnota):
                pop.mut = 0.01;
%Pravdepodobnost nejmene 1 permutace z 3 moznych (pomerna hodnota):
                pop.permut = 0.05;
                pop.permut = 1 - (1 - pop.permut)^(1/3);
                pop.permut = sqrt(pop.permut);%viz vypocet, je tam and!!
%Pocet generací:
                pop.gen = 25;
%Velikost populace:
                pop.N = 100;
%Pocet jedincu v turnaji:
                pop.N_turnament = 4;
%Rozmery mistnosti v m:
                mstn.x = 10;
                mstn.y = 5;
%Vyska mistnosti (m):
                mstn.z = 4;
%Vyska srovnavaci roviny (m):
                mstn.zsr = 0.75;
%Pocet bodu na stenach v ose x:
                mstn.Nx = ceil(4*mstn.x);
%Pocet bodu na stenach v ose y:
                mstn.Ny = ceil(4*mstn.y);
%Pocet bodu na stenach v ose z:
                mstn.Nz = ceil(4*mstn.z);
%Pocatecni fitness
                vysl.fitness = zeros(1, pop.gen);

%--------------------------------------------------------------------------
%PARAMETRY ODRAZU
%Uvazovany pocet odrazu:
                mstn.Nodr = 4;
                
%--------------------------------------------------------------------------
%PARAMETRY SVITIDEL
%Krivka svitivosti
                svt.I = gain*csvread(['Svitidla/', filenameinput, '.csv'],1,1);
%Vyska svitidel:
                svt.z = 4;
%Pocet svitidel:
                svt.Nx = 16;
                svt.Ny = 8;
%Smerove vektory roviny os svitidla:
                svt.vax = [0 1 0];%normala k C0 = osa svitidla
                svt.vrd = [1 0 0];%normala k C90 = pricna osa svitidla
                
%--------------------------------------------------------------------------
%Fenotyp - cilove paramety
%Prumerna hladina osvetlenosti:
                target.Eavg = 500;
%Rovnomernost:
                target.Uo = 0.6;
%Udrzovaci cinitel:
                target.MF = 0.75;
%%
%--------------------------------------------------------------------------
%GENEROVANI RASTRU SVITIDEL
%Deleni jednotlivych os:
%Polovina vydalenosti od sten
%svt.bx = ((1:svt.Nx).*mstn.x - mstn.x/2)./svt.Nx;
%svt.by = ((1:svt.Ny).*mstn.y - mstn.y/2)./svt.Ny;

%stejna vzdalenost od sten jako mezi svitidly
%svt.bx = ((1:svt.Nx).*mstn.x)./(svt.Nx+1);
%svt.by = ((1:svt.Ny).*mstn.y)./(svt.Ny+1);

%definovana vzdalenost od sten
mstn.Dx = 0.5;
mstn.Dy = 0.4;
svt.bx = mstn.Dx + ((0:(svt.Nx-1)).*(mstn.x - 2*mstn.Dx))./(svt.Nx-1);
svt.by = mstn.Dy + ((0:(svt.Ny-1)).*(mstn.y - 2*mstn.Dy))./(svt.Ny-1);

for idx= 1:1:svt.Ny
    svt.x((((idx-1)*svt.Nx)+1):(idx*svt.Nx)) = svt.bx;
    svt.y((((idx-1)*svt.Nx)+1):(idx*svt.Nx)) = ones(1, svt.Nx).*svt.by(idx);
end
svt.z = svt.z .* ones(1, svt.Nx*svt.Ny);

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

for idx= 1:1:mstn.Ny
    srovina.x((((idx-1)*mstn.Nx)+1):(idx*mstn.Nx)) = mstn.bx;
    srovina.y((((idx-1)*mstn.Nx)+1):(idx*mstn.Nx)) = ones(1, mstn.Nx).*mstn.by(idx);
    srovina.z((((idx-1)*mstn.Nx)+1):(idx*mstn.Nx)) = ones(1, mstn.Nx).*mstn.zsr;
end
srovina.A = ones(1, mstn.Nx*mstn.Ny).* (mstn.x*mstn.y)/ mstn.Nx/ mstn.Ny;
srovina.N = mstn.Nx*mstn.Ny;
srovina.E = 0;
srovina.E0 = 0;
srovina.Ep = 0;
srovina.co = 0;
srovina.nv = [0 0 1];

%--------------------------------------------------------------------------
%GENEROVANI DNA POCATECNICH POPULACI
%DNA: udava platnost souradnice - je to logicka hodnota
%Pocatecni populace je nahodna v intervalu <-0.5, 0.5>:
if pop.sym == 1
    pop.dnaDelka = svt.Nx.*svt.Ny/4;
else
    pop.dnaDelka = svt.Nx.*svt.Ny/2;
end
pop.dna = -0.5 + rand(pop.N,pop.dnaDelka);
%Tohle je prevod na binarni nahodny vektor
pop.dna = (pop.dna > 0);
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
        x1 = svt.x;
        y1 = svt.y;
        z1 = svt.z;
        vax = svt.vax;
        vrd = svt.vrd;
        if pop.sym == 1
           N = (svt.Nx/2);
           dnam = zrcadlo(pop.dna(clen,:), N);
           dna = [dnam, dnam(end:-1:1)];
        else
           dna = [pop.dna(clen, :), pop.dna(clen, end:-1:1)]; 
        end
        
        %PODLAHA
        x2 = podlaha.x;
        y2 = podlaha.y;
        z2 = podlaha.z;
        nv = podlaha.nv;
        podlaha.E = osvSvitCGama2(x1, y1, z1, x2, y2, z2, vax, vrd, nv, svt.I, dna);
        
        %STROP
        x2 = strop.x;
        y2 = strop.y;
        z2 = strop.z;
        nv = strop.nv;
        strop.E = osvSvitCGama2(x1, y1, z1, x2, y2, z2, vax, vrd, nv, svt.I, dna);
        
        %STENA J
        x2 = stenaJ.x;
        y2 = stenaJ.y;
        z2 = stenaJ.z;
        nv = stenaJ.nv;
        stenaJ.E = osvSvitCGama2(x1, y1, z1, x2, y2, z2, vax, vrd, nv, svt.I, dna);
        
        %STENA S
        x2 = stenaS.x;
        y2 = stenaS.y;
        z2 = stenaS.z;
        nv = stenaS.nv;
        stenaS.E = osvSvitCGama2(x1, y1, z1, x2, y2, z2, vax, vrd, nv, svt.I, dna);
        
        %STENA Z
        x2 = stenaZ.x;
        y2 = stenaZ.y;
        z2 = stenaZ.z;
        nv = stenaZ.nv;
        stenaZ.E = osvSvitCGama2(x1, y1, z1, x2, y2, z2, vax, vrd, nv, svt.I, dna);
        
        %STENA V
        x2 = stenaV.x;
        y2 = stenaV.y;
        z2 = stenaV.z;
        nv = stenaV.nv;
        stenaV.E = osvSvitCGama2(x1, y1, z1, x2, y2, z2, vax, vrd, nv, svt.I, dna);
        
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
        %Vypocet osvetleni srovnavaci roviny
        %------------------------------------------------------------------
        %Srovnavaci rovina + svitidla
        x1 = svt.x;
        y1 = svt.y;
        z1 = svt.z;
        vax = svt.vax;
        vrd = svt.vrd;
        if pop.sym == 1
           N = (svt.Nx/2);
           dnam = zrcadlo(pop.dna(clen,:), N);
           dna = [dnam, dnam(end:-1:1)];
        else
           dna = [pop.dna(clen, :), pop.dna(clen, end:-1:1)]; 
        end
        
        x2 = srovina.x;
        y2 = srovina.y;
        z2 = srovina.z;
        nv = srovina.nv;
        srovina.E = osvSvitCGama2(x1, y1, z1, x2, y2, z2, vax, vrd, nv, svt.I, dna);
        
        %Srovnavaci rovina + steny
        x1 = srovina.x;
        y1 = srovina.y;
        z1 = srovina.z;
        nv1 = srovina.nv;
        fi01 = zeros(1, mstn.Nx*mstn.Ny);

        x2 = strop.x;
        y2 = strop.y;
        z2 = strop.z;
        nv2 = strop.nv;
        fi02 = strop.E.* strop.co.* strop.A;
        [Ep1, ~] = osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);
        
        srovina.E = srovina.E + Ep1;
        
        x2 = stenaJ.x;
        y2 = stenaJ.y;
        z2 = stenaJ.z;
        nv2 = stenaJ.nv;
        fi02 = stenaJ.E.* stenaJ.co.* stenaJ.A.* (stenaJ.z > mstn.zsr);
        [Ep1, ~] = osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);

        srovina.E = srovina.E + Ep1;

        x2 = stenaS.x;
        y2 = stenaS.y;
        z2 = stenaS.z;
        nv2 = stenaS.nv;
        fi02 = stenaS.E.* stenaS.co.* stenaS.A.* (stenaS.z > mstn.zsr);
        [Ep1, ~] = osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);

        srovina.E = srovina.E + Ep1;

        x2 = stenaZ.x;
        y2 = stenaZ.y;
        z2 = stenaZ.z;
        nv2 = stenaZ.nv;
        fi02 = stenaZ.E.* stenaZ.co.* stenaZ.A.* (stenaZ.z > mstn.zsr);
        [Ep1, ~] = osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);

        srovina.E = srovina.E + Ep1;

        x2 = stenaV.x;
        y2 = stenaV.y;
        z2 = stenaV.z;
        nv2 = stenaV.nv;
        fi02 = stenaV.E.* stenaV.co.* stenaV.A.* (stenaV.z > mstn.zsr);
        [Ep1, ~] = osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);

        srovina.E = srovina.E + Ep1;
        
        %------------------------------------------------------------------
        %Ulozeni sledovanych parametru tohoto clena populace
        %------------------------------------------------------------------
        pop.E(clen, :) = srovina.E;
    end
    %----------------------------------------------------------------------
    %Urceni fitness
    %----------------------------------------------------------------------
    %prumerna osvetlenost, kazdy radek jeden clen
    pop.Eavg = sum(pop.E, 2)./ srovina.N;
    %rovnomernost, kazdy radek jeden clen
    pop.Uo = min(pop.E,[],2)./pop.Eavg;
    %oprava stredni hodnoty o udrzovaci cinitel
    pop.Eavg= target.MF .* pop.Eavg;
    %fitness
    pop.fitness = zeros(pop.N, 1);
    DROP = (pop.Eavg < target.Eavg) | (pop.Uo < target.Uo);
    pop.fitness = DROP .* pop.dnaDelka;
    pop.fitness = pop.fitness + not(DROP) .* sum(pop.dna, 2);
    pop.fitness = pop.fitness + target.Uo.*target.Eavg./(pop.Uo.*pop.Eavg + 0.00001);
    %pop.fitness = pop.fitness + target.Eavg./(pop.Eavg + 0.00001);
    %pop.fitness = pop.fitness + target.Uo./(pop.Uo + 0.00001);
    
    %----------------------------------------------------------------------
    %Generovani nove populace
    %----------------------------------------------------------------------
    pop.dnaPotomku = zeros(pop.N, pop.dnaDelka);
    %----------------------------------------------------------------------
    %ELITISMUS - vyber nejlepsiho clena populace na prvni misto
    %----------------------------------------------------------------------
    [~, elita.idx]= min(pop.fitness);
    
    %ulozeni nejlepsi hodnoty fitness funkce
    vysl.fitness(generace)= pop.fitness(elita.idx);
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
        [rodicA.p, rodicA.idx]= min(pop.fitness(idx));
        rodicA.idx = idx(rodicA.idx);

        idx = ceil(pop.N*rand(1,pop.N_turnament)+eps);
        [rodicB.p, rodicB.idx]= min(pop.fitness(idx));
        rodicB.idx = idx(rodicB.idx);

        %Krizeni - podle indexu a dle pravdepodobnosti krizeni
        idx= ceil(pop.dnaDelka*rand(1,1)/pop.kriz + eps);
        if idx >= pop.dnaDelka %zde nekrizit
            pop.dnaPotomku(clen) = pop.dna(rodicA.idx);
            pop.dnaPotomku(clen+1) = pop.dna(rodicB.idx);
        else %zde krizit
            pop.dnaPotomku(clen, :) = [pop.dna(rodicA.idx, (1:idx)), pop.dna(rodicB.idx, (idx+1):end)];
            pop.dnaPotomku(clen+1, :) = [pop.dna(rodicB.idx, (1:idx)), pop.dna(rodicA.idx, (idx+1):end)];
        end
    end
    %----------------------------------------------------------------------
    %Mutace
    %----------------------------------------------------------------------
    %POZOR: prvni clen nesmi mutovat
    %Vylosovani bitu pro mutaci
    mut= rand(pop.N-1,pop.dnaDelka);
    mut= (mut <= pop.mut);

    %zmena hodnoty
    pop.dnaPotomku(2:end, :) = xor(pop.dnaPotomku(2:end, :), mut);
    %----------------------------------------------------------------------
    %Permutace
    %----------------------------------------------------------------------
    for idx = 1:1:3 %mozne az 3 permutace
        per= ceil(pop.dnaDelka*rand(pop.N,2)/pop.permut + eps);
        for clen = 2:1:pop.N
            %zde permutace jen za splneni podminky
            if ((per(clen, 1) <= pop.dnaDelka) && (per(clen, 2) <= pop.dnaDelka)) 
                mut = pop.dnaPotomku(clen,(per(clen, 1)));
                pop.dnaPotomku(clen,(per(clen, 1))) = pop.dnaPotomku(clen,(per(clen, 2)));
                pop.dnaPotomku(clen,(per(clen, 2))) = mut;
            end
        end
    end
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
vysl.E = pop.E(elita.idx,:);
vysl.E_MAX = max(vysl.E);
vysl.E_MIN = min(vysl.E);
vysl.E_AVG = sum(pop.E, 2)./ srovina.N;
figure(1)
vysl.ME = vec2mat(vysl.E,mstn.Nx);
surf(mstn.bx,mstn.by,vysl.ME);
xlabel('x (m)');
ylabel('y (m)');
zlabel('E (lx)');

figure(2)

vysl.dna = pop.dna(1, :);
vysl.sx = svt.x;
vysl.sy = svt.y;
vysl.sz = svt.z;
vysl.zsr = mstn.zsr;

if pop.sym == 1
   N = (svt.Nx/2);
   dna = zrcadlo(vysl.dna, N);
   vysl.dnaIdx = find([dna, dna(end:-1:1)]);
else
   vysl.dnaIdx = find([vysl.dna, vysl.dna(end:-1:1)]);
end

vysl.dnax = vysl.sx(vysl.dnaIdx);
vysl.dnay = vysl.sy(vysl.dnaIdx);
plot(vysl.dnax, vysl.dnay, 'o', 'MarkerSize', 10, 'LineWidth', 2, 'MarkerFaceColor', 'y', 'MarkerEdgeColor', 'k');
xlabel('x (m)');
ylabel('y (m)');
grid on;
axis([0 mstn.x 0 mstn.y]);

figure(3)
plot(1:pop.gen, vysl.fitness);
xlabel('generation (-)');
ylabel('best fitness (-)')
grid on;

%Ulozeni vysledku
str = sprintf('_V%d%d%d_S%d.mat', svt.vax(1), svt.vax(2), svt.vax(3), pop.sym);
save(['Vysledky/' filenameinput ID str], 'vysl', 'pop', 'target', 'svt', 'mstn', 'srovina', 'stenaJ', 'stenaS', 'stenaV', 'stenaZ', 'strop')

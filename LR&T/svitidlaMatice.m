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
                pop.gen = 1;
%Velikost populace:
                pop.N = 2;
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
%Maximalni svitivost I0:
                svt.I0max = 10000;
%Minimalni svitivost I0:
                svt.I0min = 1000;
%Vyska svitidel:
                svt.z = 3.5;
%Pocet svitidel:
                svt.N = 4;
%Koeficienty charakteristicke funkce svitivosti (nejvyssi mocnina je vlevo)
                svt.fc =[-0.205, 1.717, 2.248, -0.241, 1.89, 2.071];
                svt.I0max = svt.I0max/((svt.fc(1)+ svt.fc(2)).^svt.fc(3));
                svt.I0min = svt.I0min/((svt.fc(1)+ svt.fc(2)).^svt.fc(3));
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
%Ep... prirustek osvetleni ve vypoctu pri odrazech
%co... cinitel odrazu
%nv... normalovy vektor
for i= 1:1:mstn.Ny
    podlaha.x((((i-1)*mstn.Nx)+1):(i*mstn.Nx)) = mstn.bx;
    podlaha.y((((i-1)*mstn.Nx)+1):(i*mstn.Nx)) = ones(1, mstn.Nx).*mstn.by(i);
    podlaha.z((((i-1)*mstn.Nx)+1):(i*mstn.Nx)) = zeros(1, mstn.Nx);
end
podlaha.A = ones(1, mstn.Nx*mstn.Ny).* (mstn.x*mstn.y)/ mstn.Nx/ mstn.Ny;
podlaha.N = mstn.Nx*mstn.Ny;
podlaha.E = 0;
podlaha.Ep = 0;
podlaha.co = 0.2;
podlaha.nv = [0 0 1];

for i= 1:1:mstn.Ny
    strop.x((((i-1)*mstn.Nx)+1):(i*mstn.Nx)) = mstn.bx;
    strop.y((((i-1)*mstn.Nx)+1):(i*mstn.Nx)) = ones(1, mstn.Nx).*mstn.by(i);
    strop.z((((i-1)*mstn.Nx)+1):(i*mstn.Nx)) = ones(1, mstn.Nx).*mstn.z;
end
strop.A = ones(1, mstn.Nx*mstn.Ny).*(mstn.x*mstn.y)/ mstn.Nx/ mstn.Ny;
strop.N = mstn.Nx*mstn.Ny;
strop.E = 0;
strop.Ep = 0;
strop.co = 0.7;
strop.nv = [0 0 -1];

for i= 1:1:mstn.Nz
    stenaJ.x((((i-1)*mstn.Nx)+1):(i*mstn.Nx)) = mstn.bx;
    stenaJ.y((((i-1)*mstn.Nx)+1):(i*mstn.Nx)) = zeros(1, mstn.Nx);
    stenaJ.z((((i-1)*mstn.Nx)+1):(i*mstn.Nx)) = ones(1, mstn.Nx).*mstn.bz(i);
end
stenaJ.A = ones(1, mstn.Nx*mstn.Nz).*(mstn.x*mstn.z)/ mstn.Nx/ mstn.Nz;
stenaJ.N = mstn.Nx*mstn.Nz;
stenaJ.E = 0;
stenaJ.Ep = 0;
stenaJ.co = 0.5;
stenaJ.nv = [0 1 0];

for i= 1:1:mstn.Nz
    stenaS.x((((i-1)*mstn.Nx)+1):(i*mstn.Nx)) = mstn.bx;
    stenaS.y((((i-1)*mstn.Nx)+1):(i*mstn.Nx)) = ones(1, mstn.Nx).*mstn.y;
    stenaS.z((((i-1)*mstn.Nx)+1):(i*mstn.Nx)) = ones(1, mstn.Nx).*mstn.bz(i);
end
stenaS.A = ones(1, mstn.Nx*mstn.Nz).*(mstn.x*mstn.z)/ mstn.Nx/ mstn.Nz;
stenaS.N = mstn.Nx*mstn.Nz;
stenaS.E = 0;
stenaS.Ep = 0;
stenaS.co = 0.5;
stenaS.nv = [0 -1 0];

for i= 1:1:mstn.Nz
    stenaZ.x((((i-1)*mstn.Ny)+1):(i*mstn.Ny)) = zeros(1, mstn.Ny);
    stenaZ.y((((i-1)*mstn.Ny)+1):(i*mstn.Ny)) = mstn.by;
    stenaZ.z((((i-1)*mstn.Ny)+1):(i*mstn.Ny)) = ones(1, mstn.Ny).*mstn.bz(i);
end
stenaZ.A = ones(1, mstn.Ny*mstn.Nz).*(mstn.y*mstn.z)/ mstn.Ny/ mstn.Nz;
stenaZ.N = mstn.Ny*mstn.Nz;
stenaZ.E = 0;
stenaZ.Ep = 0;
stenaZ.co = 0.5;
stenaZ.nv = [1 0 0];

for i= 1:1:mstn.Nz
    stenaV.x((((i-1)*mstn.Ny)+1):(i*mstn.Ny)) = ones(1, mstn.Ny).*mstn.x;
    stenaV.y((((i-1)*mstn.Ny)+1):(i*mstn.Ny)) = mstn.by;
    stenaV.z((((i-1)*mstn.Ny)+1):(i*mstn.Ny)) = ones(1, mstn.Ny).*mstn.bz(i);
end
stenaV.A = ones(1, mstn.Ny*mstn.Nz).*(mstn.y*mstn.z)/ mstn.Ny/ mstn.Nz;
stenaV.N = mstn.Ny*mstn.Nz;
stenaV.E = 0;
stenaV.Ep = 0;
stenaV.co = 0.5;
stenaV.nv = [-1 0 0];

%--------------------------------------------------------------------------
%GENEROVANI DNA POCATECNICH POPULACI
%DNA: liche pozice x, sude pozice y
%Pocatecni populace je nahodna:
pop.dna = zeros(pop.N,2*svt.N+1);
pop.dna(:,1:2:((2*svt.N)-1)) = mstn.x.*rand(pop.N,svt.N);
pop.dna(:,2:2:(2*svt.N)) = mstn.y.*rand(pop.N,svt.N);
pop.dna(:,2*svt.N+1)= svt.I0min + (svt.I0max-svt.I0min)*rand(pop.N, 1);

%--------------------------------------------------------------------------
%SMYCKA GENETICKEHO ALGORITMU
%--------------------------------------------------------------------------
%opakovat tolikrat, kolik je pozadovano generaci
for generace = 1:1:pop.gen
    %----------------------------------------------------------------------
    %Vypocet osvetleni vsech bodu pro kazdeho clena populace
    for clen = 1:1:pop.N
        %------------------------------------------------------------------
        %Vsechna svitidla tohoto clena populace vuci bodum mistnosti
        %------------------------------------------------------------------
        x1= pop.dna(clen, 1:2:((2*svt.N)-1));
        y1= pop.dna(clen, 2:2:(2*svt.N));
        z1= svt.z*ones(1, svt.N);
        nv1 = [0 0 -1];
        Isv = 500;
        
        %PODLAHA
        x2= podlaha.x;
        y2= podlaha.y;
        z2= podlaha.z;
        nv2= podlaha.nv;
        podlaha.E = osvSvitTh(x1,y1,z1,x2,y2,z2,nv1,nv2,Isv);
        
        %STROP
        x2= strop.x;
        y2= strop.y;
        z2= strop.z;
        nv2= strop.nv;
        strop.E = osvSvitTh(x1,y1,z1,x2,y2,z2,nv1,nv2,Isv);
        
        %STENA J
        x2= stenaJ.x;
        y2= stenaJ.y;
        z2= stenaJ.z;
        nv2= stenaJ.nv;
        stenaJ.E = osvSvitTh(x1,y1,z1,x2,y2,z2,nv1,nv2,Isv);
        
        %STENA S
        x2= stenaS.x;
        y2= stenaS.y;
        z2= stenaS.z;
        nv2= stenaS.nv;
        stenaS.E = osvSvitTh(x1,y1,z1,x2,y2,z2,nv1,nv2,Isv);
        
        %STENA Z
        x2= stenaZ.x;
        y2= stenaZ.y;
        z2= stenaZ.z;
        nv2= stenaZ.nv;
        stenaZ.E = osvSvitTh(x1,y1,z1,x2,y2,z2,nv1,nv2,Isv);
        
        %STENA V
        x2= stenaV.x;
        y2= stenaV.y;
        z2= stenaV.z;
        nv2= stenaV.nv;
        stenaV.E = osvSvitTh(x1,y1,z1,x2,y2,z2,nv1,nv2,Isv);
        
        %------------------------------------------------------------------
        %Vypocet odrazu mezi stenami
        %------------------------------------------------------------------
        podlaha.Ep= 0;
        strop.Ep= 0;
        stenaJ.Ep= 0;
        stenaS.Ep= 0;
        stenaZ.Ep= 0;
        stenaV.Ep= 0;
        
        %PODLAHA + neco
        x1= podlaha.x;
        y1= podlaha.y;
        z1= podlaha.z;
        nv1= podlaha.nv;
        fi01= podlaha.E.* podlaha.co.* podlaha.A./ pi;
        
        x2= strop.x;
        y2= strop.y;
        z2= strop.z;
        nv2= strop.nv;
        fi02= strop.E.* strop.co.* strop.A./ pi;
        [Ep1, Ep2]= osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);
        
        podlaha.Ep= Ep1;
        strop.Ep= Ep2;
        
        x2= stenaJ.x;
        y2= stenaJ.y;
        z2= stenaJ.z;
        nv2= stenaJ.nv;
        fi02= stenaJ.E.* stenaJ.co.* stenaJ.A./ pi;
        [Ep1, Ep2]= osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);
        
        podlaha.Ep= podlaha.Ep + Ep1;
        stenaJ.Ep= Ep2;
        
        x2= stenaS.x;
        y2= stenaS.y;
        z2= stenaS.z;
        nv2= stenaS.nv;
        fi02= stenaS.E.* stenaS.co.* stenaS.A./ pi;
        [Ep1, Ep2]= osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);
        
        podlaha.Ep= podlaha.Ep + Ep1;
        stenaS.Ep= Ep2;
        
        x2= stenaZ.x;
        y2= stenaZ.y;
        z2= stenaZ.z;
        nv2= stenaZ.nv;
        fi02= stenaZ.E.* stenaZ.co.* stenaZ.A./ pi;
        [Ep1, Ep2]= osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);
        
        podlaha.Ep= podlaha.Ep + Ep1;
        stenaZ.Ep= Ep2;
        
        x2= stenaV.x;
        y2= stenaV.y;
        z2= stenaV.z;
        nv2= stenaV.nv;
        fi02= stenaV.E.* stenaV.co.* stenaV.A./ pi;
        [Ep1, Ep2]= osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);
        
        podlaha.Ep= podlaha.Ep + Ep1;
        stenaV.Ep= Ep2;
        
        %STROP + neco
        x1= strop.x;
        y1= strop.y;
        z1= strop.z;
        nv1= strop.nv;
        fi01= strop.E.* strop.co.* strop.A./ pi;
        
        x2= stenaJ.x;
        y2= stenaJ.y;
        z2= stenaJ.z;
        nv2= stenaJ.nv;
        fi02= stenaJ.E.* stenaJ.co.* stenaJ.A./ pi;
        [Ep1, Ep2]= osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);
        
        strop.Ep= strop.Ep + Ep1;
        stenaJ.Ep= stenaJ.Ep + Ep2;
        
        x2= stenaS.x;
        y2= stenaS.y;
        z2= stenaS.z;
        nv2= stenaS.nv;
        fi02= stenaS.E.* stenaS.co.* stenaS.A./ pi;
        [Ep1, Ep2]= osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);
        
        strop.Ep= strop.Ep + Ep1;
        stenaS.Ep= stenaS.Ep + Ep2;
        
        x2= stenaZ.x;
        y2= stenaZ.y;
        z2= stenaZ.z;
        nv2= stenaZ.nv;
        fi02= stenaZ.E.* stenaZ.co.* stenaZ.A./ pi;
        [Ep1, Ep2]= osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);
        
        strop.Ep= strop.Ep + Ep1;
        stenaZ.Ep= stenaZ.Ep + Ep2;
        
        x2= stenaV.x;
        y2= stenaV.y;
        z2= stenaV.z;
        nv2= stenaV.nv;
        fi02= stenaV.E.* stenaV.co.* stenaV.A./ pi;
        [Ep1, Ep2]= osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);
        
        strop.Ep= strop.Ep + Ep1;
        stenaV.Ep= stenaV.Ep + Ep2;
        
        %STENA J + neco
        x1= stenaJ.x;
        y1= stenaJ.y;
        z1= stenaJ.z;
        nv1= stenaJ.nv;
        fi01= stenaJ.E.* stenaJ.co.* stenaJ.A./ pi;
        
        x2= stenaS.x;
        y2= stenaS.y;
        z2= stenaS.z;
        nv2= stenaS.nv;
        fi02= stenaS.E.* stenaS.co.* stenaS.A./ pi;
        [Ep1, Ep2]= osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);
        
        stenaJ.Ep= stenaJ.Ep + Ep1;
        stenaS.Ep= stenaS.Ep + Ep2;
        
        x2= stenaZ.x;
        y2= stenaZ.y;
        z2= stenaZ.z;
        nv2= stenaZ.nv;
        fi02= stenaZ.E.* stenaZ.co.* stenaZ.A./ pi;
        [Ep1, Ep2]= osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);
        
        stenaJ.Ep= stenaJ.Ep + Ep1;
        stenaZ.Ep= stenaZ.Ep + Ep2;
        
        x2= stenaV.x;
        y2= stenaV.y;
        z2= stenaV.z;
        nv2= stenaV.nv;
        fi02= stenaV.E.* stenaV.co.* stenaV.A./ pi;
        [Ep1, Ep2]= osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);
        
        stenaJ.Ep= stenaJ.Ep + Ep1;
        stenaV.Ep= stenaV.Ep + Ep2;
        
        %STENA S + neco
        x1= stenaS.x;
        y1= stenaS.y;
        z1= stenaS.z;
        nv1= stenaS.nv;
        fi01= stenaS.E.* stenaS.co.* stenaS.A./ pi;
        
        x2= stenaZ.x;
        y2= stenaZ.y;
        z2= stenaZ.z;
        nv2= stenaZ.nv;
        fi02= stenaZ.E.* stenaZ.co.* stenaZ.A./ pi;
        [Ep1, Ep2]= osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);
        
        stenaS.Ep= stenaS.Ep + Ep1;
        stenaZ.Ep= stenaZ.Ep + Ep2;
        
        x2= stenaV.x;
        y2= stenaV.y;
        z2= stenaV.z;
        nv2= stenaV.nv;
        fi02= stenaV.E.* stenaV.co.* stenaV.A./ pi;
        [Ep1, Ep2]= osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);
        
        stenaS.Ep= stenaS.Ep + Ep1;
        stenaV.Ep= stenaV.Ep + Ep2;
        
        %STENA Z + STENA V
        x1= stenaZ.x;
        y1= stenaZ.y;
        z1= stenaZ.z;
        nv1= stenaZ.nv;
        fi01= stenaZ.E.* stenaZ.co.* stenaZ.A./ pi;
        
        x2= stenaV.x;
        y2= stenaV.y;
        z2= stenaV.z;
        nv2= stenaV.nv;
        fi02= stenaV.E.* stenaV.co.* stenaV.A./ pi;
        [Ep1, Ep2]= osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);
        
        stenaZ.Ep= stenaZ.Ep + Ep1;
        stenaV.Ep= stenaV.Ep + Ep2;
    end
end

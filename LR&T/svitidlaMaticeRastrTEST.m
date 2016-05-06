1;%pro octave, aby bylo zrejme, ze tento soubor neni funkce
clear;
clc;
close;
%Vypocet osvetleni s uvazovanim mnohonasobnych odrazu. Vyuziva se zde
%funkci, ktere jsou nasledne pouzity v genetickem algoritmu.
filenameinput = 'MSTR_SLB_4x18W_5G4';
ID = '_TestC';
gain = 5.4;
%Rozmery mistnosti v m:
                mstn.x = 10;
                mstn.y = 5;
%Vyska mistnosti (m):
                mstn.z = 4;
%Vyska srovnavaci roviny (m):
                mstn.zsr = 0.8;
%Pocet bodu na stenach v ose x:
                mstn.Nx = ceil(4*mstn.x);
%Pocet bodu na stenach v ose y:
                mstn.Ny = ceil(4*mstn.y);
%Pocet bodu na stenach v ose z:
                mstn.Nz = ceil(4*mstn.z);

%--------------------------------------------------------------------------
%PARAMETRY ODRAZU
%Uvazovany pocet odrazu:
                mstn.Nodr = 8;
                
%--------------------------------------------------------------------------
%PARAMETRY SVITIDEL
%Krivka svitivosti
                svt.I = gain*csvread(['Svitidla/', filenameinput, '.csv'],1,1);
%Vyska svitidel:
                svt.z = 4;
%Pocet svitidel:
                svt.Nx = 1;
                svt.Ny = 1;
%Smerove vektory roviny os svitidla:
                svt.vax = [0 1 0];%normala k C0 = osa svitidla
                svt.vrd = [1 0 0];%normala k C90 = pricna osa svitidla
%%
%--------------------------------------------------------------------------
%GENEROVANI RASTRU SVITIDEL
%definovana vzdalenost od sten
mstn.Dx = 1.5;
mstn.Dy = 1;
if svt.Nx <= 1
    svt.bx = mstn.x / 2;
else
    svt.bx = mstn.Dx + ((0:(svt.Nx-1)).*(mstn.x - 2*mstn.Dx))./(svt.Nx-1);
end
if svt.Ny <= 1
    svt.by = mstn.y / 2;
else
    svt.by = mstn.Dy + ((0:(svt.Ny-1)).*(mstn.y - 2*mstn.Dy))./(svt.Ny-1);
end

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
podlaha.co = 0.3;
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
%vynulovani sledovanych promennych
pop.E = zeros(1, podlaha.N);

%------------------------------------------------------------------
%Vsechna svitidla vuci bodum mistnosti
%------------------------------------------------------------------
x1 = svt.x;
y1 = svt.y;
z1 = svt.z;
vax = svt.vax;
vrd = svt.vrd;
dna = ones(1, svt.Nx*svt.Ny);

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

podlaha.fiOdr = zeros(mstn.Nodr,podlaha.N);
strop.fiOdr = zeros(mstn.Nodr,strop.N);
stenaJ.fiOdr = zeros(mstn.Nodr,stenaJ.N);
stenaS.fiOdr = zeros(mstn.Nodr,stenaS.N);
stenaZ.fiOdr = zeros(mstn.Nodr,stenaZ.N);
stenaV.fiOdr = zeros(mstn.Nodr,stenaV.N);

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
    podlaha.fiOdr(odraz,:) = podlaha.E0.* podlaha.A;

    x2 = strop.x;
    y2 = strop.y;
    z2 = strop.z;
    nv2 = strop.nv;
    fi02 = strop.E0.* strop.co.* strop.A;
    strop.fiOdr(odraz,:) = strop.E0.* strop.A;
    [Ep1, Ep2] = osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);

    podlaha.Ep = Ep1;
    strop.Ep = Ep2;

    x2 = stenaJ.x;
    y2 = stenaJ.y;
    z2 = stenaJ.z;
    nv2 = stenaJ.nv;
    fi02 = stenaJ.E0.* stenaJ.co.* stenaJ.A;
    stenaJ.fiOdr(odraz,:) = stenaJ.E0.* stenaJ.A;
    [Ep1, Ep2] = osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);

    podlaha.Ep = podlaha.Ep + Ep1;
    stenaJ.Ep = Ep2;

    x2 = stenaS.x;
    y2 = stenaS.y;
    z2 = stenaS.z;
    nv2 = stenaS.nv;
    fi02 = stenaS.E0.* stenaS.co.* stenaS.A;
    stenaS.fiOdr(odraz,:) = stenaS.E0.* stenaS.A;
    [Ep1, Ep2] = osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);

    podlaha.Ep = podlaha.Ep + Ep1;
    stenaS.Ep = Ep2;

    x2 = stenaZ.x;
    y2 = stenaZ.y;
    z2 = stenaZ.z;
    nv2 = stenaZ.nv;
    fi02 = stenaZ.E0.* stenaZ.co.* stenaZ.A;
    stenaZ.fiOdr(odraz,:) = stenaZ.E0.* stenaZ.A;
    [Ep1, Ep2] = osvPlchPlch(x1,y1,z1,x2,y2,z2,nv1,nv2,fi01,fi02);

    podlaha.Ep = podlaha.Ep + Ep1;
    stenaZ.Ep = Ep2;

    x2 = stenaV.x;
    y2 = stenaV.y;
    z2 = stenaV.z;
    nv2 = stenaV.nv;
    fi02 = stenaV.E0.* stenaV.co.* stenaV.A;
    stenaV.fiOdr(odraz,:) = stenaV.E0.* stenaV.A;
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
dna = ones(1,svt.Nx*svt.Ny);

x2 = srovina.x;
y2 = srovina.y;
z2 = srovina.z;
nv = srovina.nv;
srovina.E = osvSvitCGama2(x1, y1, z1, x2, y2, z2, vax, vrd, nv, svt.I, dna);

%Srovnavaci rovina + steny
if(mstn.Nodr > 0)
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
end

%----------------------------------------------------------------------
%Urceni sledovanych promennych
%----------------------------------------------------------------------
%prumerna osvetlenost, kazdy radek jeden clen
Eavg = sum(srovina.E, 2)./ podlaha.N;
%rovnomernost, kazdy radek jeden clen
Uo = min(srovina.E,[],2)./Eavg;
    
%--------------------------------------------------------------------------
%Zobrazeni vysledku
%--------------------------------------------------------------------------
figure(1)
vysl.ME = vec2mat(srovina.E,mstn.Nx);
%surf(mstn.bx,mstn.by,vysl.ME);
contour(mstn.bx,mstn.by,vysl.ME,'ShowText','on');
xlabel('x (m)');
ylabel('y (m)');
zlabel('E (lx)');
grid on;

figure(2)
plot(svt.x, svt.y, 'o', 'MarkerSize', 10, 'LineWidth', 2, 'MarkerFaceColor', 'y', 'MarkerEdgeColor', 'k');
xlabel('x (m)');
ylabel('y (m)');
axis([0 mstn.x 0 mstn.y]);

figure(3)
podlaha.FI = sum(podlaha.fiOdr, 2)/mstn.x/mstn.y;
stenaJ.FI = sum(stenaJ.fiOdr, 2)/mstn.x/mstn.z;
stenaS.FI = sum(stenaS.fiOdr, 2)/mstn.x/mstn.z;
stenaV.FI = sum(stenaV.fiOdr, 2)/mstn.y/mstn.z;
stenaZ.FI = sum(stenaZ.fiOdr, 2)/mstn.y/mstn.z;
strop.FI = sum(strop.fiOdr, 2)/mstn.x/mstn.y;
subplot(2,1,1)
b = bar((1:(mstn.Nodr)), [podlaha.FI, strop.FI, stenaS.FI, stenaV.FI]);
g = gca;
g.YScale = 'log';
grid on;
ylabel('$$\Delta\overline{E}$$ (lx)','interpreter','latex');
xlabel('impact','interpreter','latex');
legend('floor', 'ceiling', 'wall N&S', 'wall E&W')
subplot(2,1,2)
b = bar((1:(mstn.Nodr)), [cumsum(podlaha.FI), cumsum(strop.FI), cumsum(stenaS.FI), cumsum(stenaV.FI)]);
g = gca;
%g.YScale = 'log';
grid on;
ylabel('$$\overline{E}$$ (lx)','interpreter','latex');
xlabel('impact','interpreter','latex');
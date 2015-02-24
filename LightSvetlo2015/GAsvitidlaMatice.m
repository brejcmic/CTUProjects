clear;
clc;
close;
%Reseni rozmisteni svetel pomoci genetickeho algoritmu. Na zacatku se zvoli
%pocet svitidel a jejich vyzarovaci charakteristika.
%DNA: x, y, x, y, x, y,... zavisi na poctu svitidel
%Krizeni: jednobodove (udat pravdepodobnost)
                pop.kriz = 0.9;
%Mutace (pomerna hodnota):
                pop.mut = 0.02;
%Pocet generací:
                pop.gen = 10000;
%Velikost populace:
                pop.N = 100;
%Meze parametru (dany rozmery mistnosti v m):
                mez.x0 = 0;
                mez.x1 = 10;
                mez.y0 = 0;
                mez.y1 = 5;
%Vyska mistnosti (m):
                mez.z0 = 0;
                mez.z1 = 2;
%Umisteni svitidel v ose z (POZOR: neosetreno umisteni svitidel nad strop):
                mez.zS = 2;
%Pocet bodu na stenach v ose x:
                rov.Nx = 20;
%Pocet bodu na stenach v ose y:
                rov.Ny = 10;
%Pocet bodu na stenach v ose z:
                rov.Nz = 4;
%Pocatecni fitness
                fitness = zeros(1, 100);

%--------------------------------------------------------------------------
%PARAMETRY STEN
%Cinitel odrazu stropu:
                rov.COstr = 0.7;
%Cinitel odrazu sten:
                rov.COste = 0.5;
%Cinitel odrazu podlahy:
                rov.COpod = 0.2;
%Uvazovany pocet odrazu:
                rov.Nodr = 3;
                
%--------------------------------------------------------------------------
%PARAMETRY SVITIDEL
%Pocet svitidel:
                svt.N = 8;
%Svitivost s nulovym uhlem
                svt.I0 = 100;
%Koeficienty charakteristicke funkce svitivosti (nejvyssi mocnina je vlevo)
                svt.fc =[0, -0.8, 1, 0];
%Vyneseni polarniho grafu
svt.theta = -pi/2:pi/500:pi/2;
svt.I= svt.I0*(polyval(svt.fc, cos(svt.theta)));
figure(1)
svt.theta = -pi/2:pi/500:pi/2;
svt.I= svt.I0*(polyval(svt.fc, cos(svt.theta)));
set(polar(svt.theta,svt.I),'color','r','linewidth',2)
view([90, 90]);
%%
%--------------------------------------------------------------------------
%GENEROVANI BODU JEDNOTLIVYCH STEN
%Deleni jednotlivych os:
rov.bx = ((1:rov.Nx).*(mez.x1-mez.x0) - (mez.x1-mez.x0)/2)./rov.Nx;
rov.by = ((1:rov.Ny).*(mez.y1-mez.y0) - (mez.y1-mez.y0)/2)./rov.Ny;
rov.bz = ((1:rov.Nz).*(mez.z1-mez.z0) - (mez.z1-mez.z0)/2)./rov.Nz;

%Generovani souradnic
%x, y, z... souradnice
%A... plocha bodu
for i= 1:1:rov.Ny
    podlaha.x((((i-1)*rov.Nx)+1):(i*rov.Nx)) = rov.bx;
    podlaha.y((((i-1)*rov.Nx)+1):(i*rov.Nx)) = ones(1, rov.Nx).*rov.by(i);
    podlaha.z((((i-1)*rov.Nx)+1):(i*rov.Nx)) = ones(1, rov.Nx).*mez.z0;
end
podlaha.A = ones(1, rov.Nx*rov.Ny).*(mez.x1-mez.x0)*(mez.y1-mez.y0)/ rov.Nx/ rov.Ny;

for i= 1:1:rov.Ny
    strop.x((((i-1)*rov.Nx)+1):(i*rov.Nx)) = rov.bx;
    strop.y((((i-1)*rov.Nx)+1):(i*rov.Nx)) = ones(1, rov.Nx).*rov.by(i);
    strop.z((((i-1)*rov.Nx)+1):(i*rov.Nx)) = ones(1, rov.Nx).*mez.z1;
end
strop.A = ones(1, rov.Nx*rov.Ny).*(mez.x1-mez.x0)*(mez.y1-mez.y0)/ rov.Nx/ rov.Ny;

for i= 1:1:rov.Nz
    stenaJ.x((((i-1)*rov.Nx)+1):(i*rov.Nx)) = rov.bx;
    stenaJ.y((((i-1)*rov.Nx)+1):(i*rov.Nx)) = ones(1, rov.Nx).*mez.y0;
    stenaJ.z((((i-1)*rov.Nx)+1):(i*rov.Nx)) = ones(1, rov.Nx).*rov.bz(i);
end
stenaJ.A = ones(1, rov.Nx*rov.Nz).*(mez.x1-mez.x0)*(mez.z1-mez.z0)/ rov.Nx/ rov.Nz;

for i= 1:1:rov.Nz
    stenaS.x((((i-1)*rov.Nx)+1):(i*rov.Nx)) = rov.bx;
    stenaS.y((((i-1)*rov.Nx)+1):(i*rov.Nx)) = ones(1, rov.Nx).*mez.y1;
    stenaS.z((((i-1)*rov.Nx)+1):(i*rov.Nx)) = ones(1, rov.Nx).*rov.bz(i);
end
stenaS.A = ones(1, rov.Nx*rov.Nz).*(mez.x1-mez.x0)*(mez.z1-mez.z0)/ rov.Nx/ rov.Nz;

for i= 1:1:rov.Nz
    stenaZ.x((((i-1)*rov.Ny)+1):(i*rov.Ny)) = ones(1, rov.Ny).*mez.x0;
    stenaZ.y((((i-1)*rov.Ny)+1):(i*rov.Ny)) = rov.by;
    stenaZ.z((((i-1)*rov.Ny)+1):(i*rov.Ny)) = ones(1, rov.Ny).*rov.bz(i);
end
stenaZ.A = ones(1, rov.Ny*rov.Nz).*(mez.y1-mez.y0)*(mez.z1-mez.z0)/ rov.Ny/ rov.Nz;

for i= 1:1:rov.Nz
    stenaV.x((((i-1)*rov.Ny)+1):(i*rov.Ny)) = ones(1, rov.Ny).*mez.x1;
    stenaV.y((((i-1)*rov.Ny)+1):(i*rov.Ny)) = rov.by;
    stenaV.z((((i-1)*rov.Ny)+1):(i*rov.Ny)) = ones(1, rov.Ny).*rov.bz(i);
end
stenaV.A = ones(1, rov.Ny*rov.Nz).*(mez.y1-mez.y0)*(mez.z1-mez.z0)/ rov.Ny/ rov.Nz;

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
%GENEROVANI DNA POCEATECNICH POPULACI
%DNA: liche pozice x, sude pozice y
%Pocatecni populace je nahodna:
pop.dna = zeros(pop.N,2*svt.N);
pop.dna(:,1:2:((2*svt.N)-1)) = mez.x0 + (mez.x1-mez.x0).*rand(pop.N,svt.N);
pop.dna(:,2:2:(2*svt.N)) = mez.y0 + (mez.y1-mez.y0).*rand(pop.N,svt.N);
%pop.dna=[0.5 0.5 2 2 0.5 2 2 0.5]
%--------------------------------------------------------------------------
%SMYCKA GENETICKEHO ALGORITMU
%--------------------------------------------------------------------------
%inicializace promenych
pop.Eavg = zeros(1,pop.N);
pop.Essq = zeros(1,pop.N);
pop.prVyb = zeros(1,pop.N);
%opakovat tolikrat, kolik je pozadovano generaci
for generace = 1:1:pop.gen
    %pocatecni osvetlenost je nulova
    bod.E = zeros(pop.N,bod.stVIDX);
    %----------------------------------------------------------------------
    %Vypocet osvetleni vsech bodu pro kazdeho clena populace
    for clen = 1:1:pop.N
        %------------------------------------------------------------------
        %Vsechna svitidla tohoto clena populace vuci vsem bodum
        %------------------------------------------------------------------
  
            x= pop.dna(clen, 1:2:((2*svt.N)-1))'*ones(1, bod.stVIDX);
            y= pop.dna(clen, 2:2:(2*svt.N))'*ones(1, bod.stVIDX);
            z= mez.zS'*ones(svt.N, bod.stVIDX);
            %kvadrat vzdalenosti bodu od svitidla
            lsq= ((x-ones(svt.N, 1)*bod.x).^2 + (y-ones(svt.N, 1)*bod.y).^2 + (z-ones(svt.N, 1)*bod.z).^2)+eps;
            %cosiny a siny uhlu od normaly svitidla
            %jen tady lze pocitat cosinus bez absolutni hodnoty
            cosTh = (z-ones(svt.N, 1)*bod.z)./(lsq.^0.5);
            sinTh = (1 - cosTh.^2).^0.5;
            
            %Vypocet osvetleni na podlaze a strope od svitidel
            %Nasobeni cosinem je nahrazeno rozsirenim charakteristicke
            %funkce
            bod.E(clen,1:bod.strIDX)= sum(svt.I0 .* polyval([svt.fc 0], cosTh(:, 1:bod.strIDX))./ lsq(:, 1:bod.strIDX));
            
            %Vypocet osvetleni na stenach od svitidel
            %Tady se nasobi sinem uhlu theta
            bod.E(clen,(bod.strIDX+1):end)= sum(svt.I0 .* polyval(svt.fc, cosTh(:, (bod.strIDX+1):end)) .* sinTh(:, (bod.strIDX+1):end) ./ lsq(:, (bod.strIDX+1):end));
     
        %------------------------------------------------------------------
        %Vsechny svitici body tohoto clena populace vuci vsem bodum
        %Ev... vysledna osvetlenost vsech sten v danem odrazu
        %Eo... osvetlenost prispivajici k novemu odrazu
        %------------------------------------------------------------------
        %pocatecni osvetlenost generujici odrazy
        bod.Eo = bod.E(clen,:);
        %opakovani podle poctu odrazu
        for odraz = 1:1:rov.Nodr
            %pocatecni vysledna osvetlenost je nulova
            bod.Ev = zeros(1,bod.stVIDX);
            %svitici body na podlaze
          
                %kvadrat vzdalenosti sviticiho a osvetlovaneho bodu
                %pouziva se jako jmenovatel, promenna eps zamezi deleni
                %nulou
                lsq= ((bod.x(1:bod.podIDX)'*ones(1, bod.stVIDX)-ones(rov.Nx*rov.Ny, 1)*bod.x).^2 + (bod.y(1:bod.podIDX)'*ones(1, bod.stVIDX)-ones(rov.Nx*rov.Ny, 1)*bod.y).^2 + (bod.z(1:bod.podIDX)'*ones(1, bod.stVIDX)-ones(rov.Nx*rov.Ny, 1)*bod.z).^2)+eps;
                %kosiny a siny uhlu od normaly sviticiho bodu
                cosTh = abs(bod.z(1:bod.podIDX)'*ones(1, bod.stVIDX)-ones(rov.Nx*rov.Ny, 1)*bod.z)./(lsq.^0.5);
                sinTh = (1 - cosTh.^2).^0.5;
                %Svitivost bodu v nulovem uhlu
                I0 = (bod.Eo(1:bod.podIDX) .* rov.COpod .* bod.A(1:bod.podIDX)./ pi)'*ones(1, bod.stVIDX);
                %Vypocet osveteni na strope
                %Predpokladaji se difuzni steny, stena je rovnobezna, odtud
                %nasobeni kosinem
                bod.Ev(bod.podIDX+1:bod.strIDX)= sum(I0(:, bod.podIDX+1:bod.strIDX) .* (cosTh(:, bod.podIDX+1:bod.strIDX).^2) ./ lsq(:, bod.podIDX+1:bod.strIDX));
                %Vypocet osveteni na stenach
                %Predpokladaji se difuzni steny, stena je kolma, odtud
                %nasobeni sinem
                bod.Ev((bod.strIDX+1):end)= sum(I0(:, (bod.strIDX+1):end) .* cosTh(:, (bod.strIDX+1):end).* sinTh(:, (bod.strIDX+1):end) ./ lsq(:, (bod.strIDX+1):end));
            
            %svitici body na strope
            
                %kvadrat vzdalenosti sviticiho a osvetlovaneho bodu
                %pouziva se jako jmenovatel, promenna eps zamezi deleni
                %nulou
                lsq= ((bod.x(bod.podIDX+1:bod.strIDX)'*ones(1, bod.stVIDX)-ones(rov.Nx*rov.Ny, 1)*bod.x).^2 + (bod.y(bod.podIDX+1:bod.strIDX)'*ones(1, bod.stVIDX)-ones(rov.Nx*rov.Ny, 1)*bod.y).^2 + (bod.z(bod.podIDX+1:bod.strIDX)'*ones(1, bod.stVIDX)-ones(rov.Nx*rov.Ny, 1)*bod.z).^2)+eps;
                %kosiny a siny uhlu od normaly sviticiho bodu
                cosTh = abs(bod.z(bod.podIDX+1:bod.strIDX)'*ones(1, bod.stVIDX)-ones(rov.Nx*rov.Ny, 1)*bod.z)./(lsq.^0.5);
                sinTh = (1 - cosTh.^2).^0.5;
                %Svitivost bodu v nulovem uhlu
                I0 = (bod.Eo(bod.podIDX+1:bod.strIDX) .* rov.COstr .* bod.A(bod.podIDX+1:bod.strIDX)./ pi)'*ones(1, bod.stVIDX);
                %Vypocet osveteni na podlaze
                %Predpokladaji se difuzni steny, stena je rovnobezna, odtud
                %nasobeni kosinem
                bod.Ev(1:bod.podIDX)= bod.Ev(1:bod.podIDX) + sum(I0(:, 1:bod.podIDX) .* (cosTh(:, 1:bod.podIDX).^2) ./ lsq(:, 1:bod.podIDX));
                %Vypocet osveteni na stenach
                %Predpokladaji se difuzni steny, stena je kolma, odtud
                %nasobeni sinem
                bod.Ev((bod.strIDX+1):end)= bod.Ev((bod.strIDX+1):end) + sum(I0(:, (bod.strIDX+1):end) .* cosTh(:, (bod.strIDX+1):end).* sinTh(:, (bod.strIDX+1):end) ./ lsq(:, (bod.strIDX+1):end));
            
            %svitici body na stenach JIH a SEVER
     
                %kvadrat vzdalenosti sviticiho a osvetlovaneho bodu
                %pouziva se jako jmenovatel, promenna eps zamezi deleni
                %nulou
                lsq= ((bod.x(bod.strIDX+1:bod.stSIDX)'*ones(1, bod.stVIDX)-ones(2*rov.Nx*rov.Nz, 1)*bod.x).^2 + (bod.y(bod.strIDX+1:bod.stSIDX)'*ones(1, bod.stVIDX)-ones(2*rov.Nx*rov.Nz, 1)*bod.y).^2 + (bod.z(bod.strIDX+1:bod.stSIDX)'*ones(1, bod.stVIDX)-ones(2*rov.Nx*rov.Nz, 1)*bod.z).^2)+eps;
                %kosiny a siny uhlu od normaly sviticiho bodu
                cosTh = abs(bod.y(bod.strIDX+1:bod.stSIDX)'*ones(1, bod.stVIDX)-ones(2*rov.Nx*rov.Nz, 1)*bod.y)./(lsq.^0.5);
                sinTh = (1 - cosTh.^2).^0.5;
                %Svitivost bodu v nulovem uhlu
                I0 = (bod.Eo(bod.strIDX+1:bod.stSIDX) .* rov.COste .* bod.A(bod.strIDX+1:bod.stSIDX)./ pi)'*ones(1, bod.stVIDX);
                %Vypocet osveteni na podlaze a strope
                %Predpokladaji se difuzni steny, stena je kolma, odtud
                %nasobeni sinem
                bod.Ev(1:bod.strIDX)= bod.Ev(1:bod.strIDX) + sum(I0(:, 1:bod.strIDX) .* cosTh(:, 1:bod.strIDX) .* sinTh(:, 1:bod.strIDX) ./ lsq(:, 1:bod.strIDX));
                %Vypocet osveteni na stenach JIH a SEVER
                %Predpokladaji se difuzni steny, stena je rovnobezna, odtud
                %nasobeni kosinem
                bod.Ev((bod.strIDX+1):bod.stSIDX)= bod.Ev((bod.strIDX+1):bod.stSIDX) + sum(I0(:, (bod.strIDX+1):bod.stSIDX) .* (cosTh(:, (bod.strIDX+1):bod.stSIDX).^2) ./ lsq(:, (bod.strIDX+1):bod.stSIDX));
                %Vypocet osveteni na stenach ZAPAD a VYCHOD
                %Predpokladaji se difuzni steny, stena je kolma, odtud
                %nasobeni sinem
                bod.Ev((bod.stSIDX+1):end)= bod.Ev((bod.stSIDX+1):end) + sum(I0(:, (bod.stSIDX+1):end) .* cosTh(:, (bod.stSIDX+1):end) .* sinTh(:, (bod.stSIDX+1):end) ./ lsq(:, (bod.stSIDX+1):end));
            
            %svitici body na stenach ZAPAD a VYCHOD

                %kvadrat vzdalenosti sviticiho a osvetlovaneho bodu
                %pouziva se jako jmenovatel, promenna eps zamezi deleni
                %nulou
                lsq= ((bod.x(bod.stSIDX+1:1:bod.stVIDX)'*ones(1, bod.stVIDX)-ones(2*rov.Ny*rov.Nz, 1)*bod.x).^2 + (bod.y(bod.stSIDX+1:1:bod.stVIDX)'*ones(1, bod.stVIDX)-ones(2*rov.Ny*rov.Nz, 1)*bod.y).^2 + (bod.z(bod.stSIDX+1:1:bod.stVIDX)'*ones(1, bod.stVIDX)-ones(2*rov.Ny*rov.Nz, 1)*bod.z).^2)+eps;
                %kosiny a siny uhlu od normaly sviticiho bodu
                cosTh = abs(bod.x(bod.stSIDX+1:1:bod.stVIDX)'*ones(1, bod.stVIDX)-ones(2*rov.Ny*rov.Nz, 1)*bod.x)./(lsq.^0.5);
                sinTh = (1 - cosTh.^2).^0.5;
                %Svitivost bodu v nulovem uhlu
                I0 = (bod.Eo(bod.stSIDX+1:1:bod.stVIDX) .* rov.COste .* bod.A(bod.stSIDX+1:1:bod.stVIDX)./ pi)'*ones(1, bod.stVIDX);
                %Vypocet osveteni na podlaze, strope a stenach JIH a SEVER
                %Predpokladaji se difuzni steny, stena je kolma, odtud
                %nasobeni sinem
                bod.Ev(1:bod.stSIDX)= bod.Ev(1:bod.stSIDX) + sum(I0(:, 1:bod.stSIDX) .* cosTh(:, 1:bod.stSIDX) .* sinTh(:, 1:bod.stSIDX) ./ lsq(:, 1:bod.stSIDX));
                %Vypocet osveteni na stenach ZAPAD a VYCHOD
                %Predpokladaji se difuzni steny, stena je kolma, odtud
                %nasobeni sinem
                bod.Ev((bod.stSIDX+1):end)= bod.Ev((bod.stSIDX+1):end) + sum(I0(:, (bod.stSIDX+1):end) .* (cosTh(:, (bod.stSIDX+1):end).^2) ./ lsq(:, (bod.stSIDX+1):end));
 
            %Pricteni prirustku k celkove osvetlenosti
            bod.E(clen,:) = bod.E(clen,:) + bod.Ev;
            %Aktualizace osvetlenosti generujici odrazy
            bod.Eo = bod.Ev;
        end
    end
    %------------------------------------------------------------------
    %Urceni fitness funkce clenu populace
    %------------------------------------------------------------------
    %Prumerna hodnota osvetlenosti na podlaze
    pop.Eavg = sum(bod.E(:,1:bod.podIDX), 2) * ones(1, rov.Nx*rov.Ny)./rov.Nx ./rov.Ny;
    %Prumerny soucet ctvercu odchylek od prumerne osvetlenosti
    pop.Essq = sum((bod.E(:,1:bod.podIDX) - pop.Eavg).^2, 2)/bod.podIDX;
    
    %Pravdepodobnosti vyberu clena populace jako rodice
    pop.prVyb =1./ sum(1./pop.Essq) ./ pop.Essq;
    
    %======================================================================
    %MEZIVYSEDKY - zobrazeni
    %======================================================================
    %nejlepsi vysledek generace
    [PRAV, IDX]= max(pop.prVyb);
    %Vyneseni fitness funkce
    figure(2)
    subplot(2,2,1)
    fitness = [fitness(2:100), pop.Essq(IDX)];
    plot(fitness);
    title('Fitness nejlepsich jedincu');
    xlabel('historie (n)');
    ylabel('sum((E-E_{avg})^2)');
    grid on;

    
    %Zobrazeni nejlepsiho vysledku teto generace
    subplot(2,2,2)
    %figure(2);
    plot(pop.dna(IDX,1:2:((2*svt.N)-1)), pop.dna(IDX,2:2:(2*svt.N)), 'o', 'MarkerSize', 10, 'LineWidth', 2, 'MarkerFaceColor', 'b');
    title(sprintf('Nejlepsi jedinec, generace = %i, P_{vyberu}= %3.2f %%', generace, pop.prVyb(IDX)*100));
    grid on;
    axis([mez.x0 mez.x1 mez.y0 mez.y1]);
    xlabel('x (m)');
    ylabel('y (m)');
    
    subplot(2,2,3)
    %figure(3)
    %bod.ME = vec2mat(bod.E(IDX,1:bod.podIDX),rov.Nx);
    bod.ME = zeros(rov.Ny,rov.Nx);
    for i= 1:1:bod.podIDX/rov.Nx
        bod.ME(i, :)= bod.E(IDX,(1+(i-1)*rov.Nx):(i*rov.Nx));
    end
    surf(rov.bx,rov.by,bod.ME);
    xlim([mez.x0 mez.x1]);
    ylim([mez.y0 mez.y1]);
    colorbar;
    xlabel('x (m)');
    ylabel('y (m)');
    zlabel('E (lx)');
    
    subplot(2,2,4)
    %figure(4)
    pcolor(rov.bx,rov.by,bod.ME);
    xlabel('x (m)');
    ylabel('y (m)');
    %======================================================================
    
    %Pokud se nejedna o posledni generaci, tak najit potomky
    if generace < pop.gen
        %------------------------------------------------------------------
        %KRIZENI - vyber rodicu a vytvareni potomku
        %------------------------------------------------------------------
        pop.dnaP = zeros(pop.N,2*svt.N);
        %opakovat hledani dokud nebude vytvorena nova populace velikosti N
        for clen = 1:1:pop.N
            %nahodne: vyber rodice1, vyber rodice2, index krizeni
            pravdepodobnost = rand(1,3);
            %Index prvniho rodice
            for i= 1:1:pop.N
                if pravdepodobnost(1) > 0
                    pop.i(1) = i;
                end
                pravdepodobnost(1)= pravdepodobnost(1)- pop.prVyb(i);
            end

            %Index druheho rodice
            for i= 1:1:pop.N
                if i~= pop.i(1)
                    if pravdepodobnost(2) > 0
                        pop.i(2) = i;
                    end
                    pravdepodobnost(2)= pravdepodobnost(2)- pop.prVyb(i);
                end
            end

            %Krizeni - podle indexu a dle pravdepodobnosti krizeni
            pop.i(3)= ceil(2*svt.N*pravdepodobnost(3)/pop.kriz);
            if pop.i(3) >= 2*svt.N %zde nekrizit
                pop.dnaP(clen, :) = pop.dna(pop.i(1), :);
                pop.dnaP(clen+1, :) = pop.dna(pop.i(2), :);
            else %zde krizit
                pop.dnaP(clen, :) = [pop.dna(pop.i(1), (1:pop.i(3))), pop.dna(pop.i(2), (pop.i(3)+1):2*svt.N)];
                pop.dnaP(clen+1, :) = [pop.dna(pop.i(2), (1:pop.i(3))), pop.dna(pop.i(1), (pop.i(3)+1):2*svt.N)];
            end
        end

        %------------------------------------------------------------------
        %MUTACE potomku
        %------------------------------------------------------------------
        pravdepodobnost= rand(pop.N,2*svt.N);
        for i= 1:2:(2*svt.N-1)
            for clen= 1:1:pop.N
                if pravdepodobnost(clen, i) <= pop.mut
                    pop.dnaP(clen, i)= mez.x0 + (mez.x1-mez.x0)*rand();
                end

                if pravdepodobnost(clen, i+1) <= pop.mut
                    pop.dnaP(clen, i+1)= mez.y0 + (mez.y1-mez.y0)*rand();
                end
            end
        end
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
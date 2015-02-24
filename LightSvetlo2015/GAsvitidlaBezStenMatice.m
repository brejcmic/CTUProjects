clear;
clc;
close;
%Reseni rozmisteni svetel pomoci genetickeho algoritmu. Na zacatku se zvoli
%pocet svitidel a jejich vyzarovaci charakteristika.
%DNA: x, y, x, y, x, y,... zavisi na poctu svitidel
%Krizeni: jednobodove (udat pravdepodobnost)
                pop.kriz = 0.9;
%Mutace (pomerna hodnota):
                pop.mut = 0.025;
%Pocet generací:
                pop.gen = 10000;
%Velikost populace:
                pop.N = 500;
%Meze parametru (dany rozmery mistnosti v m):
                mez.x0 = 0;
                mez.x1 = 10;
                mez.y0 = 0;
                mez.y1 = 5;
%Vyska mistnosti (m):
                mez.h = 2;
%Pocatecni fitness:
                fitness = zeros(1,100);
%--------------------------------------------------------------------------
%PARAMETRY SVITIDEL
%Pocet svitidel:
                svt.N = 8;
%Svitivost s nulovym uhlem
                svt.I0 = 100;
%Koeficienty charakteristicke funkce svitivosti (nejvyssi mocnina je vlevo)
                svt.fc =[-0.5, 0, 1, 0];

figure(1)
svt.theta = -pi/2:pi/500:pi/2;
svt.I= svt.I0*(polyval(svt.fc, cos(svt.theta)));
set(polar(svt.theta,svt.I),'color','r','linewidth',2)
view([90, 90]);
%--------------------------------------------------------------------------
%Generovani bodu na srovnavaci rovine
%Pocet bodu v ose x:
                rov.Nx = 40;
%Pocet bodu v ose y:
                rov.Ny = 20;
%Generovani souradnic:
rov.bx = ((1:rov.Nx).*(mez.x1-mez.x0) - (mez.x1-mez.x0)/2)./rov.Nx;
rov.by = ((1:rov.Ny).*(mez.y1-mez.y0) - (mez.y1-mez.y0)/2)./rov.Ny;

for i= 1:1:rov.Ny
    E.xb(1:1:svt.N, (((i-1)*rov.Nx)+1):((i*rov.Nx))) = ones(svt.N, 1)*rov.bx;
    E.yb(1:1:svt.N, (((i-1)*rov.Nx)+1):((i*rov.Nx))) = rov.by(i) .* ones(svt.N, rov.Nx);
end

%--------------------------------------------------------------------------
%Pocatecni populace je nahodna:
pop.dna = zeros(pop.N,2*svt.N);
pop.dna(:,1:2:((2*svt.N)-1)) = mez.x0 + (mez.x1-mez.x0).*rand(pop.N,svt.N);
pop.dna(:,2:2:(2*svt.N)) = mez.y0 + (mez.y1-mez.y0).*rand(pop.N,svt.N);
%pop.dna=ones(pop.N,1)*[0.5 0.5 2 2 0.5 2 2 0.5];
%--------------------------------------------------------------------------
%SMYCKA GENETICKEHO ALGORITMU
%--------------------------------------------------------------------------
displayRes = 1;     %promenna pro zobrazovani mezivysledku
for generace = 1:1:pop.gen
    %----------------------------------------------------------------------
    %Osvetlenost jednotlivych bodu srovnavaci roviny

    for i= 1:1:pop.N
        %Vsechna svitidla z jedne populace vuci vsem bodum
        E.xs = pop.dna(i,1:2:((2*svt.N)-1))' * ones(1, rov.Nx*rov.Ny);
        E.ys = pop.dna(i,2:2:(2*svt.N))' * ones(1, rov.Nx*rov.Ny);

        E.lQ = ((E.xs-E.xb).^2 + (E.ys-E.yb).^2 + mez.h^2)+eps;
        E.cos = mez.h ./ (E.lQ .^0.5);

        %Nasobeni kosinem je nahrazeno rozsirenim charakteristicke funkce
        pop.E(i, :) = sum(svt.I0 .* polyval([svt.fc 0], E.cos)./ E.lQ);
    end
    %----------------------------------------------------------------------
    %Fitnes populace
    %Prumerna hodnota osvetlenosti v dane populaci
    pop.Eavg = sum(pop.E, 2)./rov.Nx ./rov.Ny;

    %Soucet ctvercu odchylek v dane populaci
    pop.SSQ = sum((pop.E - pop.Eavg * ones(1, rov.Nx*rov.Ny)).^2, 2);

    %Pravdepodobnosti vyberu rodice
    pop.prVyb =1./ sum(1./pop.SSQ) ./ pop.SSQ;
    
    %======================================================================
    %MEZIVYSEDKY - zobrazeni
    %======================================================================
    %nejlepsi vysledek generace
    [PRAV, IDX]= max(pop.prVyb);
    %Vyneseni fitness funkce
    figure(2)
    subplot(2,2,1)
    fitness = [fitness(2:100), pop.SSQ(IDX)];
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
    bod.ME = vec2mat(pop.E(IDX,:),rov.Nx);
    surf(rov.bx,rov.by,bod.ME);
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
        for clen = 1:2:pop.N
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
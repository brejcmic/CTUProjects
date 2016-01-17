%E = osvSvitCGama(xs, ys, zs, xb, yb, zb, vax, vrd, nb, Is_cg)
%Funkce pro vypocet osvetlenosti soustavy bodu pomoci soustavy svitidel
%Jedna se o druhou verzi vypoctu, kde se predpoklada, ze v DNA je obsazena 
%logicka hodnota platnosti souradnice svitidla:
%0 - svitidlo na dane pozici neexistuje
%1 - svitidlo je na dane pozici

%xs... vektor x souradnic svitidla
%ys... vektor y souradnic svitidla
%zs... vektor z souradnic svitidla
%xb... vektor x souradnic bodu
%yb... vektor y souradnic bodu
%zb... vektor z souradnic bodu
%vax... smerovy vektor plochy svitidla - C0, C180
%vrd... smerovy vektor plochy svitidla - C90, C270
%vax a vrd jsou dle definice na sebe kolme, jejich vektorovy soucin udava
%osu svitidla pro gama = 0 (zde normalovy vektor plochy svitidla)
%nb... normalovy vektor osvetlovanych plosek
%Oba vektory jsou ve formatu [x, y, z]
%Is_cg... krivka svitivosti pro souradnice c-gama
%dna... logicka hodnota platnosti souradnice svitidla
function E = osvSvitCGama2(xs, ys, zs, xb, yb, zb, vax, vrd, nb, Is_cg, dna)

    Ns = length(xs);
    Nb = length(xb);
    NI = size(Is_cg);
    
    xs = xs'*ones(1, Nb);
    ys = ys'*ones(1, Nb);
    zs = zs'*ones(1, Nb);

    xb = ones(Ns, 1)*xb;
    yb = ones(Ns, 1)*yb;
    zb = ones(Ns, 1)*zb;
    
    %prevedeni vsech vektoru na jednotkove
    vax = vax./((vax*vax').^0.5);
    vrd = vrd./((vrd*vrd').^0.5);
    nb = nb./((nb*nb').^0.5);
    
    %1) normalovy vektor svitidla
    ns = [0,0,0];
    ns(1) = vax(2)*vrd(3)-vax(3)*vrd(2);
    ns(2) = vax(3)*vrd(1)-vax(1)*vrd(3);
    ns(3) = vax(1)*vrd(2)-vax(2)*vrd(1);
    %POZOR: nadale se predpoklada, ze vysledkem vektorovehosoucinu je opet
    %jednotkovy vektor!!!
    
    %2) vzdalenost bodu od svitidla, +eps zamezuje deleni nulou
    %pruvodic
    rx = xb - xs;
    ry = yb - ys;
    rz = zb - zs;
    lsb = (rx.^2 + ry.^2 + rz.^2).^0.5+eps;
    
    %3) Vypocet vektoru prumetu pruvodice do plochy svitidla
    %urceni nasobku jednotkoveho normaloveho vektoru (je to podobne vypoctu
    %vzdalenosti dvou rovin)
    t = ns(1)*xs + ns(2)*ys + ns(3)*zs;
    t = t - ns(1)*xb + ns(2)*yb + ns(3)*zb;
    %Prusecik primky prochazejici bodem b (a ktera je kolma k rovine) s 
    %rovinou svitidla
    xp = xb + t.*ns(1);
    yp = yb + t.*ns(2);
    zp = zb + t.*ns(3);
    %Prumet pruvodice - vektor smerem k bodu
    px = xp - xs;
    py = yp - ys;
    pz = zp - zs;
    lp = (px.^2 + py.^2 + pz.^2).^0.5+eps;
    
    %4) cosiny
    %pomoci skalarniho soucinu s pruvodicem ziskavam uhel
    %od normaly svitidla ns
    cosGm = ns(1)*rx;
    cosGm = cosGm + ns(2)*ry;
    cosGm = cosGm + ns(3)*rz;
    cosGm = cosGm./lsb;
    %rozsah 0° az 180°
    Gm = acos(cosGm);
    %mezi smerovym vektorem reprezentujicim C0 a prumetem pruvodice;
    cosC = vrd(1)*px;
    cosC = cosC + vrd(2)*py;
    cosC = cosC + vrd(3)*pz;
    cosC = cosC./lp;
    C = acos(cosC);
    %omezeni rozsahu na 0° az 90°
    C = C - (C > pi/2)*pi;
    C = abs(C);
    %uhel mezi pruvodicem a normalou plosky nb, pomoci zmeny znamenka
    %obracim smysl pruvodice. Ve vysledku totiz chci cosinus kladny, coz
    %pri dane orientaci vektoru nevyjde. Pri rovnobeznych rovinach svitidla
    %a plosky musi byt vysledek cosinu stejny jako pro cosGm.
    cosDl = nb(1)*rx;
    cosDl = cosDl + nb(2)*ry;
    cosDl = cosDl + nb(3)*rz;
    cosDl = -cosDl./lsb;
    
    %5) urceni svitivosti v jednotlivych uhlech C-Gm
    %predpokladaji se vsechny hodnoty v intervalu <0°,90°> pro C a v
    %intervalu <0°, 180°> pro Gm. Tabulka musi obsahovat i krajni body.
    %Pokud dle dna neni svitidlo na dane pozici, je svitivost nastavena na nulu.
    idxi = 1+ round((NI(1)-1) .* Gm/pi);
    idxj = 1+ round((NI(2)-1) .* 2*C/pi);
    Is = zeros(Ns, Nb);
    for i = 1:1:Ns
        if dna(i) = 0
            Is(i,:) = zeros(1, Nb);
        else
            for j = 1:1:Nb
                Is(i,j) = Is_cg(idxi(i,j), idxj(i,j));
            end
        end
    end
    %6) vypocet osvetleni, vysledky jsou v radku stejne jako souradnice
    E = sum(Is .* cosDl ./ lsb.^2, 1);
end

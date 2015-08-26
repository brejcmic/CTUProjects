%E = osvSvitCGama(xs, ys, zs, xb, yb, zb, vax, vrd, nb, Is_cg)
%Funkce pro vypocet osvetlenosti soustavy bodu pomoci soustavy svitidel
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
function E = osvSvitCGama(xs, ys, zs, xb, yb, zb, vax, vrd, nb, Is_cg)

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
    ns(1) = vax(1)*vrd(2)-vax(2)*vrd(1);
    %POZOR: nadale se predpoklada, ze vysledkem vektorovehosoucinu je opet
    %jednotkovy vektor!!!
    
    %2) vzdalenost bodu od svitidla, +eps zamezuje deleni nulou
    %pruvodic
    rx = xs - xb;
    ry = ys - yb;
    rz = zs - zb;
    lsb = (rx.^2 + ry.^2 + rz.^2).^0.5+eps;
    
    %3) Vypocet vektoru prumetu pruvodice do plochy svitidla
    %urceni nasobku jednotkoveho normaloveho vektoru (je to podobne vzpoctu
    %vydalenosti dvou rovin)
    t = ns(1)*xb + ns(2)*yb + ns(3)*zb;
    t = t - ns(1)*xs + ns(2)*ys + ns(3)*zs;
    %Prusecik primky prochazejici bodem b (a ktera je kolma k rovine) s 
    %rovinou svitidla
    xp = xb + t.*ns(1);
    yp = yb + t.*ns(2);
    zp = zb + t.*ns(3);
    %Prumet pruvodice - vektor
    px = xp - xb;
    py = yp - yb;
    pz = zp - zb;
    lp = (px.^2 + py.^2 + pz.^2).^0.5+eps;
    
    %4) cosiny
    %pomoci skalarniho soucinu
    %od normaly svitidla ns
    cosGm = ns(1)*rx;
    cosGm = cosGm + ns(2)*ry;
    cosGm = cosGm + ns(3)*rz;
    cosGm = -cosGm./lsb;
    Gm = acos(cosGm);
    %mezi smerovym vektorem reprezentujicim C0 a prumetem pruvodice;
    cosC = vax(1)*px;
    cosC = cosC + vax(2)*py;
    cosC = cosC + vax(3)*pz;
    cosC = cosC/lp;
    C = acos(cosC);
    %od normaly plosky nb
    cosDl = nb(1)*rx;
    cosDl = cosDl + nb(2)*ry;
    cosDl = cosDl + nb(3)*rz;
    cosDl = cosDl./lsb;
    
    %5) urceni svitivosti v jednotlivych uhlech C-Gm
    %TODO: dodelat pro danou krivku svitivosti
    idxi = 1+ floor((NI(1) .* C/pi) - eps);
    idxj = 1+ floor((NI(2) .* Gm/pi) - eps);
    Is = zeros(Ns, Nb);
    for i = 1:1:Ns
        for j = 1:1:Nb
            Is(i,j) = Is_cg(idxi(i,j), idxj(i,j));
        end
    end
    %6) vypocet osvetleni, vysledky jsou v radku stejne jako souradnice
    E = sum(Is .* cosDl ./ lsb.^2, 1);
end
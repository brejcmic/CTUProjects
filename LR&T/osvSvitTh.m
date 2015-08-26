%E = osvSvitTh(xs, ys, zs, xb, yb, zb, ns, nb, Is_theta)
%Funkce pro vypocet osvetlenosti soustavy bodu pomoci soustavy svitidel
%xs... vektor x souradnic svitidla
%ys... vektor y souradnic svitidla
%zs... vektor z souradnic svitidla
%xb... vektor x souradnic bodu
%yb... vektor y souradnic bodu
%zb... vektor z souradnic bodu
%ns... normalovy vektor svitidla - vektor osy svitidla
%nb... normalovy vektor osvetlovanych plosek
%Oba vektory jsou ve formatu [x, y, z]
%Is_theta... krivka svitivosti v intervalu uhlu (0 - 180)°
function E = osvSvitTh(xs, ys, zs, xb, yb, zb, ns, nb, Is_theta)

    Ns = length(xs);
    Nb = length(xb);
    NI = length(Is_theta);
    
    xs= xs'*ones(1, Nb);
    ys= ys'*ones(1, Nb);
    zs= zs'*ones(1, Nb);

    xb= ones(Ns, 1)*xb;
    yb= ones(Ns, 1)*yb;
    zb= ones(Ns, 1)*zb;
    
    %prevedeni vsech vektoru na jednotkove
    ns = ns./((ns*ns').^0.5);
    nb = nb./((nb*nb').^0.5);

    %1) vzdalenost bodu od sviticiho bodu, +eps zamezuje deleni nulou
    %pruvodic
    rx = xs - xb;
    ry = ys - yb;
    rz = zs - zb;
    lsb = (rx.^2 + ry.^2 + rz.^2).^0.5+eps;
    
    %2) cosiny
    %pomoci skalarniho soucinu
    %od normaly svitidla ns
    cosTh = ns(1)*rx;
    cosTh = cosTh + ns(2)*ry;
    cosTh = cosTh + ns(3)*rz;
    cosTh = -cosTh./lsb;
    Th = acos(cosTh);
    %od normaly plosky nb
    cosDl = nb(1)*rx;
    cosDl = cosDl + nb(2)*ry;
    cosDl = cosDl + nb(3)*rz;
    cosDl = cosDl./lsb;
    
    %3) urceni svitivosti v jednotlivych uhlech
    index = 1+ floor((NI .* Th/pi) - eps);
    Is = zeros(Ns, Nb);
    for i = 1:1:Ns
        for j = 1:1:Nb
            Is(i,j) = Is_theta(index(i,j));
        end
    end
    %4) vypocet osvetleni, vysledky jsou v radku stejne jako souradnice
    E = sum(Is .* cosDl ./ lsb.^2, 1);
end
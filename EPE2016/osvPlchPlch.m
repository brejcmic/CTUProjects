%[E1, E2] = osvPlchPlch(x1, y1, z1, x2, y2, z2, n1, n2, fi01, fi02)
%Funkce pro vypocet prirustku vzajemne osvetlenosti dvou sad bodu, obe sady 
%bodu maji pocatecni vyzarovane toky fi01 a fi02. Predpokladaji se difuzni 
%plochy.
%x1... vektor x souradnic prvni sady bodu
%y1... vektor y souradnic prvni sady bodu
%z1... vektor z souradnic prvni sady bodu
%x2... vektor x souradnic druhe sady bodu
%y2... vektor y souradnic druhe sady bodu
%z2... vektor z souradnic druhe sady bodu
%n1... normalovy vektor prvni sady bodu
%n2... normalovy vektor druhe sady bodu
%Oba vektory jsou ve formatu [x, y, z]
%fi01... tok vychazejici z plosek prvni sady bodu - vektor, pro kazdy bod
%jeden tok
%fi02... tok vychazejici z plosek druhe sady bodu - vektor, pro kazdy bod
%jeden tok
function [E1, E2] = osvPlchPlch(x1, y1, z1, x2, y2, z2, n1, n2, fi01, fi02)

    N1 = length(x1);
    N2 = length(x2);
    
    x1= x1'*ones(1, N2);
    y1= y1'*ones(1, N2);
    z1= z1'*ones(1, N2);
    fi01 = fi01'*ones(1, N2);

    x2= ones(N1, 1)*x2;
    y2= ones(N1, 1)*y2;
    z2= ones(N1, 1)*z2;
    fi02= ones(N1, 1)*fi02;
    
    %prevedeni vsech vektoru na jednotkove
    n1 = n1./((n1*n1').^0.5);
    n2 = n2./((n2*n2').^0.5);

    %1) vzdalenost bodu od sviticiho bodu, +eps zamezuje deleni nulou
    %pruvodic
    rx = x2 - x1;
    ry = y2 - y1;
    rz = z2 - z1;
    lsb = (rx.^2 + ry.^2 + rz.^2).^0.5+eps;
    
    %2) cosiny
    %od normaly plosek
    %pomoci skalarniho soucinu
    cosTh1 = n1(1)*rx;
    cosTh1 = cosTh1 + n1(2)*ry;
    cosTh1 = cosTh1 + n1(3)*rz;
    cosTh1 = cosTh1./lsb;
    %zmenou znamenka obracim smysl pruvodice, aby cosinus vysel kladny
    cosTh2 = n2(1)*rx;
    cosTh2 = cosTh2 + n2(2)*ry;
    cosTh2 = cosTh2 + n2(3)*rz;
    cosTh2 = -cosTh2./lsb;
    
    %3) urceni svitivosti v jednotlivych uhlech
    I1 = fi01.*cosTh1./pi;
    I2 = fi02.*cosTh2./pi;
    
    %4) vypocet osvetleni, vysledky jsou v radku stejne jako souradnice
    E1 = sum(I2 .* cosTh1 ./ lsb.^2, 2)';
    E2 = sum(I1 .* cosTh2 ./ lsb.^2, 1);
end
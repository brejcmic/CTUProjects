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
%n1... jednotkovy normalovy vektor prvni sady bodu
%n2... jednotkovy normalovy vektor druhe sady bodu
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

    %1) vzdalenost bodu od sviticiho bodu, +eps zamezuje deleni nulou
    lSB = (((x1 -x2).^2 + (y1-y2).^2 + (z1-z2).^2)).^0.5+eps;
    %pruvodic
    rx = (x1-x2);
    ry = (y1-y2);
    rz = (z1-z2);
    
    %2) cosiny
    %od normaly plosek
    %pomoci skalarniho soucinu
    cosTh1 = n1(1)*rx;
    cosTh1 = cosTh1 + n1(2)*ry;
    cosTh1 = cosTh1 + n1(3)*rz;
    cosTh1 = -cosTh1./lSB;
    
    cosTh2 = n2(1)*rx;
    cosTh2 = cosTh2 + n2(2)*ry;
    cosTh2 = cosTh2 + n2(3)*rz;
    cosTh2 = cosTh2./lSB;
    
    %3) urceni svitivosti v jednotlivych uhlech
    I1 = fi01.*cosTh1./pi;
    I2 = fi02.*cosTh2./pi;
    
    %4) vypocet osvetleni, vysledky jsou v radku stejne jako souradnice
    E1 = sum(I2 .* cosTh1 ./ lSB.^2, 2)';
    E2 = sum(I1 .* cosTh2 ./ lSB.^2, 1);
end
%xn = zrcadlo(x , Nx)
%Funkce pro zrcadleni vektoru souradnic x po usecich Nx. Funkce ma slouzit
%pro vypocet GA pri symetrickem rozmistovani svitidel.
%x... vstupni vektor souradnic, kterz ma byt zrcadlen.
%Nx... usek (pocet souradnic), u nichz ma byt obraceno poradi. Pocet
%souradnic v x musi bzt celociselne delitelne Nx.
%xn... navratova hodnota noveho vektoru.
function xn = zrcadlo(x , Nx)
    xn = zeros(1, 2*length(x));
    N = length(x)/Nx;
    for idx = 1:1:N
        xn((2*(idx-1)*Nx+1):((2*idx-1)*Nx)) = x(((idx-1)*Nx+1):(idx*Nx));
        xn(((2*idx-1)*Nx+1):(2*idx*Nx)) = x((idx*Nx):-1:((idx-1)*Nx+1));
    end
end
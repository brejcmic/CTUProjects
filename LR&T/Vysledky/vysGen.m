clc;
close;
%--------------------------------------------------------------------------
%Zobrazeni vysledku
%--------------------------------------------------------------------------
figure(1)
surf(mstn.bx,mstn.by,vysl.ME);
%contour(mstn.bx,mstn.by,vysl.ME,'ShowText','on');
view([0,0,1])
colorbar;
z = ((vysl.dnax*0)+1)*1000;
xlabel('x (m)');
ylabel('y (m)');
zlabel('E (lx)');
hold on;
%figure(2)
plot3(vysl.dnax, vysl.dnay,z, 'o', 'MarkerSize', 10, 'LineWidth', 2, 'MarkerFaceColor', 'y', 'MarkerEdgeColor', 'k');
xlabel('x (m)');
ylabel('y (m)');
grid on;
axis([0 mstn.x 0 mstn.y]);
hold off;

figure(3)
plot(1:pop.gen, vysl.fitness);
xlabel('generation (-)');
ylabel('best fitness (-)')
grid on;

Em= vysl.E_AVG*target.MF;
Uo= vysl.E_MIN/vysl.E_AVG;
C= sum(vysl.dna);
R= Em*target.Uo/target.Eavg/Uo;
disp(Em)
disp(Uo)
disp(C)
disp(R)
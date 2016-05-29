clc;
close;
%--------------------------------------------------------------------------
%Zobrazeni vysledku
%--------------------------------------------------------------------------
figure(1)
%surf(mstn.bx,mstn.by,vysl.ME);
contour(mstn.bx,mstn.by,vysl.ME,'ShowText','on');
xlabel('x (m)');
ylabel('y (m)');
zlabel('E (lx)');

figure(2)
plot(vysl.dnax, vysl.dnay, 'o', 'MarkerSize', 10, 'LineWidth', 2, 'MarkerFaceColor', 'y', 'MarkerEdgeColor', 'k');
xlabel('x (m)');
ylabel('y (m)');
grid on;
axis([0 mstn.x 0 mstn.y]);

figure(3)
plot(1:pop.gen, vysl.fitness);
xlabel('generation (-)');
ylabel('best fitness (-)')
grid on;
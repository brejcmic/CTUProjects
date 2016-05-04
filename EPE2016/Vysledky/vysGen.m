%--------------------------------------------------------------------------
%Zobrazeni vysledku
%--------------------------------------------------------------------------
figure(1)
vysl.ME = vec2mat(vysl.E,mstn.Nx);
surf(mstn.bx,mstn.by,vysl.ME);
%contour(mstn.bx,mstn.by,vysl.ME,'ShowText','on');
xlabel('x (m)');
ylabel('y (m)');
zlabel('E (lx)');

figure(2)
vysl.dna = pop.dna(1, :);
vysl.sx = svt.x;
vysl.sy = svt.y;
vysl.sz = svt.z;
vysl.zsr = mstn.zsr;

if pop.sym == 1
   N = (svt.Nx/2);
   dna = zrcadlo(vysl.dna, N);
   vysl.dnaIdx = find([dna, dna(end:-1:1)]);
else
   vysl.dnaIdx = find([vysl.dna, vysl.dna(end:-1:1)]);
end

vysl.dnax = vysl.sx(vysl.dnaIdx);
vysl.dnay = vysl.sy(vysl.dnaIdx);
plot(vysl.dnax, vysl.dnay, 'o', 'MarkerSize', 10, 'LineWidth', 2, 'MarkerFaceColor', 'y', 'MarkerEdgeColor', 'k');
xlabel('x (m)');
ylabel('y (m)');
grid on;
axis([0 mstn.x 0 mstn.y]);
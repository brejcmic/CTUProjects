x = 0:0.01:2;
xt = 1;

g1 = exp((x-xt)./x) .*(x < xt);
g1 = g1 + exp((xt-x)./x) .*(x >= xt);

g2 = (x/2/xt) .*(x < xt);
g2 = g2 + (1 - exp(xt-x)/2) .*(x >= xt);

subplot(2,1,1);
plot(x, g1);
ylabel('g_1(E_{avg})');
xlabel('E_{avg}/E_{avgT} ');
grid on;

subplot(2,1,2);
plot(x, g2);
ylabel('g_2(U_{0})');
xlabel('U_{0}/U_{0T} ');
grid on;
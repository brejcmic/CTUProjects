%generovani obrazku pro EMC

emi = rand(1,1001)-0.5;
for i= 1:1000
    emi(i+1)= emi(i+1) + emi(i);
end
emi = emi + 10;
ems = rand(1,1001)-0.5;
for i= 1:1000
    ems(i+1)= ems(i+1) + ems(i);
end
ems = ems + 80;

limEMS = ones(1,1001);
limEMI = 20 * limEMS;
limEMC = 45 * limEMS;
limEMS = 60 * limEMS;
f= 1e5:9900:1e7;
semilogx(f,emi,f,ems,'LineWidth',2)
hold on;
semilogx(f,limEMI,'k',f,limEMC,'r',f,limEMS,'k');
hold off;
ylabel('rušení (dB\muV)')
xlabel('frekvence(Hz)')
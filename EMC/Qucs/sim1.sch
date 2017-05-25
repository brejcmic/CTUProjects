<Qucs Schematic 0.0.18>
<Properties>
  <View=0,-120,1392,812,1,0,60>
  <Grid=10,10,1>
  <DataSet=sim1.dat>
  <DataDisplay=sim1.dpl>
  <OpenDisplay=1>
  <Script=sim1.m>
  <RunScript=0>
  <showFrame=0>
  <FrameText0=Název>
  <FrameText1=Nakresleno:>
  <FrameText2=Datum:>
  <FrameText3=Verze:>
</Properties>
<Symbol>
</Symbol>
<Components>
  <R R2 1 680 310 15 -26 1 3 "50 Ohm" 1 "26.85" 0 "0.0" 0 "0.0" 0 "26.85" 0 "european" 0>
  <IProbe I2 1 540 540 -26 16 0 0>
  <IProbe I3 1 540 610 -26 16 0 0>
  <IProbe I1 1 540 260 -26 16 0 0>
  <R R3 1 1250 280 -26 15 0 0 "50 Ohm" 1 "26.85" 0 "0.0" 0 "0.0" 0 "26.85" 0 "european" 0>
  <R R4 1 1250 360 -26 15 0 0 "50 Ohm" 1 "26.85" 0 "0.0" 0 "0.0" 0 "26.85" 0 "european" 0>
  <R R5 1 1250 440 -26 15 0 0 "50 Ohm" 1 "26.85" 0 "0.0" 0 "0.0" 0 "26.85" 0 "european" 0>
  <GND * 1 1340 360 0 0 0 0>
  <Vac V6 1 940 330 18 -26 0 1 "10 V" 1 "50 Hz" 1 "0" 1 "0" 1>
  <C C1 1 750 450 17 -26 0 1 "110000 nF" 1 "" 0 "neutral" 0>
  <Vac V5 1 1040 470 18 -26 0 1 "-10 V" 1 "50 Hz" 1 "240" 1 "0" 1>
  <Vac V4 1 940 470 18 -26 0 1 "-10 V" 1 "50 Hz" 1 "120" 1 "0" 1>
  <L L1 1 620 420 10 -26 0 1 "92 mH" 1 "0" 0>
  <GND * 1 290 380 0 0 0 0>
  <Vac V3 1 420 450 18 -26 0 1 "-10 V" 1 "50 Hz" 1 "120" 1 "0" 1>
  <Vac V1 1 320 310 18 -26 0 1 "10 V" 1 "50 Hz" 1 "240" 1 "0" 1>
  <Vac V2 1 320 450 18 -26 0 1 "-10 V" 1 "50 Hz" 1 "0" 1 "0" 1>
  <R R6 1 620 500 15 -26 1 3 "4 Ohm" 1 "26.85" 0 "0.0" 0 "0.0" 0 "26.85" 0 "european" 0>
  <.TR TR1 1 950 630 0 77 0 0 "lin" 1 "0" 1 "1400 ms" 1 "14001" 1 "Trapezoidal" 0 "2" 0 "1 ns" 0 "1e-16" 0 "150" 0 "0.001" 0 "1 pA" 0 "1 uV" 0 "26.85" 0 "1e-3" 0 "1e-6" 0 "1" 0 "CroutLU" 0 "no" 0 "yes" 0 "0" 0>
</Components>
<Wires>
  <320 340 320 380 "" 0 0 0 "">
  <320 380 320 420 "" 0 0 0 "">
  <320 260 320 280 "" 0 0 0 "">
  <320 260 510 260 "" 0 0 0 "">
  <570 260 680 260 "" 0 0 0 "">
  <680 260 680 280 "" 0 0 0 "">
  <320 480 320 610 "" 0 0 0 "">
  <320 610 510 610 "" 0 0 0 "">
  <570 610 750 610 "" 0 0 0 "">
  <420 480 420 540 "" 0 0 0 "">
  <420 540 510 540 "" 0 0 0 "">
  <680 340 680 380 "" 0 0 0 "">
  <420 380 420 420 "" 0 0 0 "">
  <320 380 420 380 "" 0 0 0 "">
  <940 360 940 400 "" 0 0 0 "">
  <1040 400 1040 440 "" 0 0 0 "">
  <940 400 940 440 "" 0 0 0 "">
  <940 400 1040 400 "" 0 0 0 "">
  <940 280 940 300 "" 0 0 0 "">
  <940 280 1220 280 "UR" 1110 250 142 "">
  <1130 360 1220 360 "US" 1180 330 17 "">
  <1130 360 1130 570 "" 0 0 0 "">
  <1040 570 1130 570 "" 0 0 0 "">
  <1040 500 1040 570 "" 0 0 0 "">
  <1200 440 1220 440 "" 0 0 0 "">
  <1200 440 1200 600 "" 0 0 0 "">
  <940 600 1200 600 "UT" 1190 570 222 "">
  <940 500 940 600 "" 0 0 0 "">
  <1280 440 1320 440 "" 0 0 0 "">
  <1320 280 1320 360 "" 0 0 0 "">
  <1280 280 1320 280 "" 0 0 0 "">
  <1320 360 1320 440 "" 0 0 0 "">
  <1280 360 1320 360 "" 0 0 0 "">
  <1320 360 1340 360 "" 0 0 0 "">
  <680 380 750 380 "" 0 0 0 "">
  <750 380 750 420 "" 0 0 0 "">
  <620 380 680 380 "" 0 0 0 "">
  <620 380 620 390 "" 0 0 0 "">
  <570 540 620 540 "" 0 0 0 "">
  <620 450 620 470 "" 0 0 0 "">
  <620 530 620 540 "" 0 0 0 "">
  <750 480 750 610 "" 0 0 0 "">
  <290 380 320 380 "" 0 0 0 "">
  <680 260 680 260 "U1" 710 230 0 "">
  <750 610 750 610 "U2" 780 580 0 "">
  <620 540 620 540 "U3" 650 510 0 "">
</Wires>
<Diagrams>
</Diagrams>
<Paintings>
</Paintings>
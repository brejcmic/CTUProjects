<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE eagle SYSTEM "eagle.dtd">
<eagle version="7.2.0">
<drawing>
<settings>
<setting alwaysvectorfont="no"/>
<setting verticaltext="up"/>
</settings>
<grid distance="0.1" unitdist="inch" unit="inch" style="lines" multiple="1" display="no" altdistance="0.01" altunitdist="inch" altunit="inch"/>
<layers>
<layer number="1" name="Top" color="4" fill="1" visible="no" active="no"/>
<layer number="2" name="Route2" color="1" fill="3" visible="no" active="no"/>
<layer number="3" name="Route3" color="4" fill="3" visible="no" active="no"/>
<layer number="4" name="Route4" color="1" fill="4" visible="no" active="no"/>
<layer number="5" name="Route5" color="4" fill="4" visible="no" active="no"/>
<layer number="6" name="Route6" color="1" fill="8" visible="no" active="no"/>
<layer number="7" name="Route7" color="4" fill="8" visible="no" active="no"/>
<layer number="8" name="Route8" color="1" fill="2" visible="no" active="no"/>
<layer number="9" name="Route9" color="4" fill="2" visible="no" active="no"/>
<layer number="10" name="Route10" color="1" fill="7" visible="no" active="no"/>
<layer number="11" name="Route11" color="4" fill="7" visible="no" active="no"/>
<layer number="12" name="Route12" color="1" fill="5" visible="no" active="no"/>
<layer number="13" name="Route13" color="4" fill="5" visible="no" active="no"/>
<layer number="14" name="Route14" color="1" fill="6" visible="no" active="no"/>
<layer number="15" name="Route15" color="4" fill="6" visible="no" active="no"/>
<layer number="16" name="Bottom" color="1" fill="1" visible="no" active="no"/>
<layer number="17" name="Pads" color="2" fill="1" visible="no" active="no"/>
<layer number="18" name="Vias" color="2" fill="1" visible="no" active="no"/>
<layer number="19" name="Unrouted" color="6" fill="1" visible="no" active="no"/>
<layer number="20" name="Dimension" color="15" fill="1" visible="no" active="no"/>
<layer number="21" name="tPlace" color="7" fill="1" visible="no" active="no"/>
<layer number="22" name="bPlace" color="7" fill="1" visible="no" active="no"/>
<layer number="23" name="tOrigins" color="15" fill="1" visible="no" active="no"/>
<layer number="24" name="bOrigins" color="15" fill="1" visible="no" active="no"/>
<layer number="25" name="tNames" color="7" fill="1" visible="no" active="no"/>
<layer number="26" name="bNames" color="7" fill="1" visible="no" active="no"/>
<layer number="27" name="tValues" color="7" fill="1" visible="no" active="no"/>
<layer number="28" name="bValues" color="7" fill="1" visible="no" active="no"/>
<layer number="29" name="tStop" color="7" fill="3" visible="no" active="no"/>
<layer number="30" name="bStop" color="7" fill="6" visible="no" active="no"/>
<layer number="31" name="tCream" color="7" fill="4" visible="no" active="no"/>
<layer number="32" name="bCream" color="7" fill="5" visible="no" active="no"/>
<layer number="33" name="tFinish" color="6" fill="3" visible="no" active="no"/>
<layer number="34" name="bFinish" color="6" fill="6" visible="no" active="no"/>
<layer number="35" name="tGlue" color="7" fill="4" visible="no" active="no"/>
<layer number="36" name="bGlue" color="7" fill="5" visible="no" active="no"/>
<layer number="37" name="tTest" color="7" fill="1" visible="no" active="no"/>
<layer number="38" name="bTest" color="7" fill="1" visible="no" active="no"/>
<layer number="39" name="tKeepout" color="4" fill="11" visible="no" active="no"/>
<layer number="40" name="bKeepout" color="1" fill="11" visible="no" active="no"/>
<layer number="41" name="tRestrict" color="4" fill="10" visible="no" active="no"/>
<layer number="42" name="bRestrict" color="1" fill="10" visible="no" active="no"/>
<layer number="43" name="vRestrict" color="2" fill="10" visible="no" active="no"/>
<layer number="44" name="Drills" color="7" fill="1" visible="no" active="no"/>
<layer number="45" name="Holes" color="7" fill="1" visible="no" active="no"/>
<layer number="46" name="Milling" color="3" fill="1" visible="no" active="no"/>
<layer number="47" name="Measures" color="7" fill="1" visible="no" active="no"/>
<layer number="48" name="Document" color="7" fill="1" visible="no" active="no"/>
<layer number="49" name="Reference" color="7" fill="1" visible="no" active="no"/>
<layer number="51" name="tDocu" color="7" fill="1" visible="no" active="no"/>
<layer number="52" name="bDocu" color="7" fill="1" visible="no" active="no"/>
<layer number="90" name="Modules" color="5" fill="1" visible="yes" active="yes"/>
<layer number="91" name="Nets" color="2" fill="1" visible="yes" active="yes"/>
<layer number="92" name="Busses" color="1" fill="1" visible="yes" active="yes"/>
<layer number="93" name="Pins" color="2" fill="1" visible="no" active="yes"/>
<layer number="94" name="Symbols" color="4" fill="1" visible="yes" active="yes"/>
<layer number="95" name="Names" color="7" fill="1" visible="yes" active="yes"/>
<layer number="96" name="Values" color="7" fill="1" visible="yes" active="yes"/>
<layer number="97" name="Info" color="7" fill="1" visible="yes" active="yes"/>
<layer number="98" name="Guide" color="6" fill="1" visible="yes" active="yes"/>
</layers>
<schematic xreflabel="%F%N/%S.%C%R" xrefpart="/%S.%C%R">
<libraries>
<library name="con-phoenix-smkdsp">
<description>Phoenix Connectors, Type SMKDSP</description>
<packages>
<package name="SMKDSP_1,5/4">
<description>&lt;b&gt;Printklemme, Nennstrom: 17,5 A, Bemessungsspannung: 250 V, Raster: 5,0 mm&lt;/b&gt;&lt;p&gt;
Source: http://eshop.phoenixcontact.de .. 1733415.pdf</description>
<wire x1="14.9" y1="-1.9017" x2="-4.9" y2="-1.9017" width="0.2032" layer="21"/>
<wire x1="14.9" y1="-2.354" x2="-4.9" y2="-2.354" width="0.2032" layer="21"/>
<wire x1="14.9" y1="2.192" x2="-4.9" y2="2.192" width="0.2032" layer="21"/>
<wire x1="14.9" y1="2.6785" x2="-4.9" y2="2.6785" width="0.2032" layer="21"/>
<wire x1="2.5" y1="6.0519" x2="2.0839" y2="6.0161" width="0.2032" layer="21" curve="9.818513"/>
<wire x1="2.0839" y1="6.016" x2="1.687" y2="5.9104" width="0.2032" layer="21" curve="10.070203"/>
<wire x1="1.687" y1="5.9104" x2="1.324" y2="5.7387" width="0.2032" layer="21" curve="10.633291"/>
<wire x1="1.324" y1="5.7387" x2="1.0139" y2="5.51" width="0.2032" layer="21" curve="11.361134"/>
<wire x1="1.0139" y1="5.51" x2="0.7679" y2="5.2327" width="0.2032" layer="21" curve="12.408633"/>
<wire x1="0.7679" y1="5.2327" x2="0.6204" y2="4.9736" width="0.2032" layer="21" curve="11.10896"/>
<wire x1="0.6205" y1="4.9736" x2="0.5305" y2="4.6984" width="0.2032" layer="21" curve="11.703364"/>
<wire x1="0.5305" y1="4.6984" x2="0.5" y2="4.4136" width="0.2032" layer="21" curve="12.150409"/>
<wire x1="4.5" y1="4.4136" x2="4.4695" y2="4.6984" width="0.2032" layer="21" curve="12.140502"/>
<wire x1="4.4695" y1="4.6984" x2="4.3795" y2="4.9736" width="0.2032" layer="21" curve="11.823167"/>
<wire x1="4.3795" y1="4.9736" x2="4.2321" y2="5.2327" width="0.2032" layer="21" curve="11.320489"/>
<wire x1="4.2321" y1="5.2327" x2="3.9861" y2="5.51" width="0.2032" layer="21" curve="12.612712"/>
<wire x1="3.9861" y1="5.51" x2="3.676" y2="5.7387" width="0.2032" layer="21" curve="11.606712"/>
<wire x1="3.676" y1="5.7387" x2="3.313" y2="5.9104" width="0.2032" layer="21" curve="10.808503"/>
<wire x1="3.313" y1="5.9104" x2="2.9161" y2="6.016" width="0.2032" layer="21" curve="10.16131"/>
<wire x1="2.9161" y1="6.016" x2="2.5" y2="6.0519" width="0.2032" layer="21" curve="9.8976"/>
<wire x1="-0.5" y1="4.4136" x2="-0.5438" y2="4.7544" width="0.2032" layer="21" curve="14.529549"/>
<wire x1="-0.5438" y1="4.7544" x2="-0.6727" y2="5.0795" width="0.2032" layer="21" curve="14.030571"/>
<wire x1="-0.6727" y1="5.0795" x2="-0.9137" y2="5.4112" width="0.2032" layer="21" curve="16.398865"/>
<wire x1="-0.9136" y1="5.4113" x2="-1.282" y2="5.713" width="0.2032" layer="21" curve="14.813546"/>
<wire x1="-1.282" y1="5.713" x2="-1.7351" y2="5.9273" width="0.2032" layer="21" curve="13.519323"/>
<wire x1="-1.7351" y1="5.9273" x2="-2.2384" y2="6.0378" width="0.2032" layer="21" curve="12.581205"/>
<wire x1="-2.2384" y1="6.0378" x2="-2.7616" y2="6.0378" width="0.2032" layer="21" curve="12.28945"/>
<wire x1="-2.7616" y1="6.0378" x2="-3.2649" y2="5.9273" width="0.2032" layer="21" curve="12.443318"/>
<wire x1="-3.2649" y1="5.9273" x2="-3.718" y2="5.713" width="0.2032" layer="21" curve="13.248047"/>
<wire x1="-3.718" y1="5.713" x2="-4.0864" y2="5.4113" width="0.2032" layer="21" curve="14.439619"/>
<wire x1="-4.0864" y1="5.4113" x2="-4.3274" y2="5.0795" width="0.2032" layer="21" curve="12.857171"/>
<wire x1="-4.3273" y1="5.0795" x2="-4.4562" y2="4.7544" width="0.2032" layer="21" curve="13.812127"/>
<wire x1="-4.4562" y1="4.7544" x2="-4.5" y2="4.4136" width="0.2032" layer="21" curve="14.512364"/>
<wire x1="-4.5" y1="4.4136" x2="-4.4695" y2="4.1287" width="0.2032" layer="21" curve="12.149235"/>
<wire x1="-4.4695" y1="4.1287" x2="-4.3795" y2="3.8536" width="0.2032" layer="21" curve="11.818019"/>
<wire x1="-4.3795" y1="3.8536" x2="-4.232" y2="3.5945" width="0.2032" layer="21" curve="11.320919"/>
<wire x1="-4.2321" y1="3.5944" x2="-3.9861" y2="3.3171" width="0.2032" layer="21" curve="12.610717"/>
<wire x1="-3.9861" y1="3.3171" x2="-3.676" y2="3.0884" width="0.2032" layer="21" curve="11.607468"/>
<wire x1="-3.676" y1="3.0884" x2="-3.313" y2="2.9167" width="0.2032" layer="21" curve="10.807383"/>
<wire x1="-3.313" y1="2.9167" x2="-2.9161" y2="2.8111" width="0.2032" layer="21" curve="10.16131"/>
<wire x1="-2.9161" y1="2.8111" x2="-2.5" y2="2.7752" width="0.2032" layer="21" curve="9.89801"/>
<wire x1="0.5" y1="4.4136" x2="0.5438" y2="4.0727" width="0.2032" layer="21" curve="14.538071"/>
<wire x1="0.5438" y1="4.0727" x2="0.6727" y2="3.7476" width="0.2032" layer="21" curve="14.027417"/>
<wire x1="0.6727" y1="3.7476" x2="0.9136" y2="3.4159" width="0.2032" layer="21" curve="16.392544"/>
<wire x1="0.9136" y1="3.4159" x2="1.282" y2="3.1141" width="0.2032" layer="21" curve="14.814063"/>
<wire x1="1.282" y1="3.1141" x2="1.7351" y2="2.8998" width="0.2032" layer="21" curve="13.518622"/>
<wire x1="1.7351" y1="2.8998" x2="2.2384" y2="2.7893" width="0.2032" layer="21" curve="12.581752"/>
<wire x1="2.2384" y1="2.7893" x2="2.7616" y2="2.7893" width="0.2032" layer="21" curve="12.288948"/>
<wire x1="2.7616" y1="2.7893" x2="3.2649" y2="2.8998" width="0.2032" layer="21" curve="12.443853"/>
<wire x1="3.2649" y1="2.8998" x2="3.718" y2="3.1141" width="0.2032" layer="21" curve="13.24872"/>
<wire x1="3.718" y1="3.1141" x2="4.0864" y2="3.4159" width="0.2032" layer="21" curve="14.441093"/>
<wire x1="4.0864" y1="3.4159" x2="4.3273" y2="3.7476" width="0.2032" layer="21" curve="12.852895"/>
<wire x1="4.3273" y1="3.7476" x2="4.4562" y2="4.0727" width="0.2032" layer="21" curve="13.810089"/>
<wire x1="4.4562" y1="4.0727" x2="4.5" y2="4.4136" width="0.2032" layer="21" curve="14.520871"/>
<wire x1="-2.5" y1="2.7753" x2="-2.0839" y2="2.8111" width="0.2032" layer="21" curve="9.823356"/>
<wire x1="-2.0839" y1="2.8111" x2="-1.687" y2="2.9167" width="0.2032" layer="21" curve="10.070203"/>
<wire x1="-1.687" y1="2.9167" x2="-1.324" y2="3.0884" width="0.2032" layer="21" curve="10.632749"/>
<wire x1="-1.324" y1="3.0884" x2="-1.0139" y2="3.3171" width="0.2032" layer="21" curve="11.361858"/>
<wire x1="-1.0139" y1="3.3171" x2="-0.7679" y2="3.5944" width="0.2032" layer="21" curve="12.401879"/>
<wire x1="-0.7679" y1="3.5944" x2="-0.6204" y2="3.8536" width="0.2032" layer="21" curve="11.113221"/>
<wire x1="-0.6205" y1="3.8536" x2="-0.5305" y2="4.1287" width="0.2032" layer="21" curve="11.698276"/>
<wire x1="-0.5305" y1="4.1287" x2="-0.5001" y2="4.4136" width="0.2032" layer="21" curve="12.152389"/>
<wire x1="-4.9" y1="-6.9" x2="14.9" y2="-6.9" width="0.2032" layer="21"/>
<wire x1="14.9" y1="-6.9" x2="14.9" y2="-2.354" width="0.2032" layer="21"/>
<wire x1="14.9" y1="-2.354" x2="14.9" y2="-1.9017" width="0.2032" layer="21"/>
<wire x1="14.9" y1="-1.9017" x2="14.9" y2="2.192" width="0.2032" layer="21"/>
<wire x1="14.9" y1="2.192" x2="14.9" y2="2.6785" width="0.2032" layer="21"/>
<wire x1="14.9" y1="2.6785" x2="14.9" y2="6.3" width="0.2032" layer="21"/>
<wire x1="14.9" y1="6.3" x2="-4.9" y2="6.3" width="0.2032" layer="21"/>
<wire x1="-4.9" y1="6.3" x2="-4.9" y2="2.6785" width="0.2032" layer="21"/>
<wire x1="-4.9" y1="2.6785" x2="-4.9" y2="2.192" width="0.2032" layer="21"/>
<wire x1="-4.9" y1="2.192" x2="-4.9" y2="-1.9017" width="0.2032" layer="21"/>
<wire x1="-4.9" y1="-1.9017" x2="-4.9" y2="-2.354" width="0.2032" layer="21"/>
<wire x1="-4.9" y1="-2.354" x2="-4.9" y2="-6.9" width="0.2032" layer="21"/>
<wire x1="-4" y1="-5.4" x2="-1" y2="-5.4" width="0.2032" layer="21"/>
<wire x1="-1" y1="-5.4" x2="-1" y2="-3.75" width="0.2032" layer="21"/>
<wire x1="-1" y1="-3.75" x2="-4" y2="-3.75" width="0.2032" layer="21"/>
<wire x1="-4" y1="-3.75" x2="-4" y2="-5.4" width="0.2032" layer="21"/>
<wire x1="-4.2" y1="-6.2" x2="-0.8" y2="-6.2" width="0.2032" layer="21"/>
<wire x1="-0.8" y1="-6.2" x2="-0.8" y2="-3" width="0.2032" layer="21"/>
<wire x1="-0.8" y1="-3" x2="-4.2" y2="-3" width="0.2032" layer="21"/>
<wire x1="-4.2" y1="-3" x2="-4.2" y2="-6.2" width="0.2032" layer="21"/>
<wire x1="15" y1="-6.3" x2="15.2" y2="-6.3" width="0.2032" layer="21"/>
<wire x1="15.2" y1="-6.3" x2="15.4" y2="-6.45" width="0.2032" layer="21"/>
<wire x1="15.4" y1="-6.45" x2="15.65" y2="-6.45" width="0.2032" layer="21"/>
<wire x1="15.65" y1="-6.45" x2="15.65" y2="-1.9" width="0.2032" layer="21"/>
<wire x1="15.65" y1="-1.9" x2="15.45" y2="-1.9" width="0.2032" layer="21"/>
<wire x1="15.45" y1="-1.9" x2="15.2" y2="-2.05" width="0.2032" layer="21"/>
<wire x1="15.2" y1="-2.05" x2="15" y2="-2.05" width="0.2032" layer="21"/>
<wire x1="15" y1="1.15" x2="15.2" y2="1.15" width="0.2032" layer="21"/>
<wire x1="15.2" y1="1.15" x2="15.4" y2="0.95" width="0.2032" layer="21"/>
<wire x1="15.4" y1="0.95" x2="15.65" y2="0.95" width="0.2032" layer="21"/>
<wire x1="15.65" y1="0.95" x2="15.65" y2="3.75" width="0.2032" layer="21"/>
<wire x1="15.65" y1="3.75" x2="15.4" y2="3.75" width="0.2032" layer="21"/>
<wire x1="15.4" y1="3.75" x2="15.2" y2="3.6" width="0.2032" layer="21"/>
<wire x1="15.2" y1="3.6" x2="15" y2="3.6" width="0.2032" layer="21"/>
<wire x1="1" y1="-5.15" x2="1" y2="-5.4" width="0.2032" layer="21"/>
<wire x1="1" y1="-5.4" x2="4" y2="-5.4" width="0.2032" layer="21"/>
<wire x1="4" y1="-5.4" x2="4" y2="-3.75" width="0.2032" layer="21"/>
<wire x1="4" y1="-3.75" x2="1" y2="-3.75" width="0.2032" layer="21"/>
<wire x1="1" y1="-3.75" x2="1" y2="-5.15" width="0.2032" layer="21"/>
<wire x1="0.8" y1="-6.2" x2="4.2" y2="-6.2" width="0.2032" layer="21"/>
<wire x1="4.2" y1="-6.2" x2="4.2" y2="-3" width="0.2032" layer="21"/>
<wire x1="4.2" y1="-3" x2="0.8" y2="-3" width="0.2032" layer="21"/>
<wire x1="0.8" y1="-3" x2="0.8" y2="-6.2" width="0.2032" layer="21"/>
<wire x1="7.5" y1="6.0519" x2="7.0839" y2="6.0161" width="0.2032" layer="21" curve="9.818513"/>
<wire x1="7.0839" y1="6.016" x2="6.687" y2="5.9104" width="0.2032" layer="21" curve="10.070203"/>
<wire x1="6.687" y1="5.9104" x2="6.324" y2="5.7387" width="0.2032" layer="21" curve="10.633291"/>
<wire x1="6.324" y1="5.7387" x2="6.0139" y2="5.51" width="0.2032" layer="21" curve="11.361134"/>
<wire x1="6.0139" y1="5.51" x2="5.7679" y2="5.2327" width="0.2032" layer="21" curve="12.408633"/>
<wire x1="5.7679" y1="5.2327" x2="5.6204" y2="4.9736" width="0.2032" layer="21" curve="11.10896"/>
<wire x1="5.6205" y1="4.9736" x2="5.5305" y2="4.6984" width="0.2032" layer="21" curve="11.703364"/>
<wire x1="5.5305" y1="4.6984" x2="5.5" y2="4.4136" width="0.2032" layer="21" curve="12.150409"/>
<wire x1="9.5" y1="4.4136" x2="9.4695" y2="4.6984" width="0.2032" layer="21" curve="12.140502"/>
<wire x1="9.4695" y1="4.6984" x2="9.3795" y2="4.9736" width="0.2032" layer="21" curve="11.823167"/>
<wire x1="9.3795" y1="4.9736" x2="9.2321" y2="5.2327" width="0.2032" layer="21" curve="11.320489"/>
<wire x1="9.2321" y1="5.2327" x2="8.9861" y2="5.51" width="0.2032" layer="21" curve="12.612712"/>
<wire x1="8.9861" y1="5.51" x2="8.676" y2="5.7387" width="0.2032" layer="21" curve="11.606712"/>
<wire x1="8.676" y1="5.7387" x2="8.313" y2="5.9104" width="0.2032" layer="21" curve="10.808503"/>
<wire x1="8.313" y1="5.9104" x2="7.9161" y2="6.016" width="0.2032" layer="21" curve="10.16131"/>
<wire x1="7.9161" y1="6.016" x2="7.5" y2="6.0519" width="0.2032" layer="21" curve="9.8976"/>
<wire x1="5.5" y1="4.4136" x2="5.5438" y2="4.0727" width="0.2032" layer="21" curve="14.538071"/>
<wire x1="5.5438" y1="4.0727" x2="5.6727" y2="3.7476" width="0.2032" layer="21" curve="14.027417"/>
<wire x1="5.6727" y1="3.7476" x2="5.9136" y2="3.4159" width="0.2032" layer="21" curve="16.392544"/>
<wire x1="5.9136" y1="3.4159" x2="6.282" y2="3.1141" width="0.2032" layer="21" curve="14.814063"/>
<wire x1="6.282" y1="3.1141" x2="6.7351" y2="2.8998" width="0.2032" layer="21" curve="13.518622"/>
<wire x1="6.7351" y1="2.8998" x2="7.2384" y2="2.7893" width="0.2032" layer="21" curve="12.581752"/>
<wire x1="7.2384" y1="2.7893" x2="7.7616" y2="2.7893" width="0.2032" layer="21" curve="12.288948"/>
<wire x1="7.7616" y1="2.7893" x2="8.2649" y2="2.8998" width="0.2032" layer="21" curve="12.443853"/>
<wire x1="8.2649" y1="2.8998" x2="8.718" y2="3.1141" width="0.2032" layer="21" curve="13.24872"/>
<wire x1="8.718" y1="3.1141" x2="9.0864" y2="3.4159" width="0.2032" layer="21" curve="14.441093"/>
<wire x1="9.0864" y1="3.4159" x2="9.3273" y2="3.7476" width="0.2032" layer="21" curve="12.852895"/>
<wire x1="9.3273" y1="3.7476" x2="9.4562" y2="4.0727" width="0.2032" layer="21" curve="13.810089"/>
<wire x1="9.4562" y1="4.0727" x2="9.5" y2="4.4136" width="0.2032" layer="21" curve="14.520871"/>
<wire x1="6" y1="-5.15" x2="6" y2="-5.4" width="0.2032" layer="21"/>
<wire x1="6" y1="-5.4" x2="9" y2="-5.4" width="0.2032" layer="21"/>
<wire x1="9" y1="-5.4" x2="9" y2="-3.75" width="0.2032" layer="21"/>
<wire x1="9" y1="-3.75" x2="6" y2="-3.75" width="0.2032" layer="21"/>
<wire x1="6" y1="-3.75" x2="6" y2="-5.15" width="0.2032" layer="21"/>
<wire x1="5.8" y1="-6.2" x2="9.2" y2="-6.2" width="0.2032" layer="21"/>
<wire x1="9.2" y1="-6.2" x2="9.2" y2="-3" width="0.2032" layer="21"/>
<wire x1="9.2" y1="-3" x2="5.8" y2="-3" width="0.2032" layer="21"/>
<wire x1="5.8" y1="-3" x2="5.8" y2="-6.2" width="0.2032" layer="21"/>
<wire x1="12.5" y1="6.0519" x2="12.0839" y2="6.0161" width="0.2032" layer="21" curve="9.818513"/>
<wire x1="12.0839" y1="6.016" x2="11.687" y2="5.9104" width="0.2032" layer="21" curve="10.070203"/>
<wire x1="11.687" y1="5.9104" x2="11.324" y2="5.7387" width="0.2032" layer="21" curve="10.633291"/>
<wire x1="11.324" y1="5.7387" x2="11.0139" y2="5.51" width="0.2032" layer="21" curve="11.361134"/>
<wire x1="11.0139" y1="5.51" x2="10.7679" y2="5.2327" width="0.2032" layer="21" curve="12.408633"/>
<wire x1="10.7679" y1="5.2327" x2="10.6204" y2="4.9736" width="0.2032" layer="21" curve="11.10896"/>
<wire x1="10.6205" y1="4.9736" x2="10.5305" y2="4.6984" width="0.2032" layer="21" curve="11.703364"/>
<wire x1="10.5305" y1="4.6984" x2="10.5" y2="4.4136" width="0.2032" layer="21" curve="12.150409"/>
<wire x1="14.5" y1="4.4136" x2="14.4695" y2="4.6984" width="0.2032" layer="21" curve="12.140502"/>
<wire x1="14.4695" y1="4.6984" x2="14.3795" y2="4.9736" width="0.2032" layer="21" curve="11.823167"/>
<wire x1="14.3795" y1="4.9736" x2="14.2321" y2="5.2327" width="0.2032" layer="21" curve="11.320489"/>
<wire x1="14.2321" y1="5.2327" x2="13.9861" y2="5.51" width="0.2032" layer="21" curve="12.612712"/>
<wire x1="13.9861" y1="5.51" x2="13.676" y2="5.7387" width="0.2032" layer="21" curve="11.606712"/>
<wire x1="13.676" y1="5.7387" x2="13.313" y2="5.9104" width="0.2032" layer="21" curve="10.808503"/>
<wire x1="13.313" y1="5.9104" x2="12.9161" y2="6.016" width="0.2032" layer="21" curve="10.16131"/>
<wire x1="12.9161" y1="6.016" x2="12.5" y2="6.0519" width="0.2032" layer="21" curve="9.8976"/>
<wire x1="10.5" y1="4.4136" x2="10.5438" y2="4.0727" width="0.2032" layer="21" curve="14.538071"/>
<wire x1="10.5438" y1="4.0727" x2="10.6727" y2="3.7476" width="0.2032" layer="21" curve="14.027417"/>
<wire x1="10.6727" y1="3.7476" x2="10.9136" y2="3.4159" width="0.2032" layer="21" curve="16.392544"/>
<wire x1="10.9136" y1="3.4159" x2="11.282" y2="3.1141" width="0.2032" layer="21" curve="14.814063"/>
<wire x1="11.282" y1="3.1141" x2="11.7351" y2="2.8998" width="0.2032" layer="21" curve="13.518622"/>
<wire x1="11.7351" y1="2.8998" x2="12.2384" y2="2.7893" width="0.2032" layer="21" curve="12.581752"/>
<wire x1="12.2384" y1="2.7893" x2="12.7616" y2="2.7893" width="0.2032" layer="21" curve="12.288948"/>
<wire x1="12.7616" y1="2.7893" x2="13.2649" y2="2.8998" width="0.2032" layer="21" curve="12.443853"/>
<wire x1="13.2649" y1="2.8998" x2="13.718" y2="3.1141" width="0.2032" layer="21" curve="13.24872"/>
<wire x1="13.718" y1="3.1141" x2="14.0864" y2="3.4159" width="0.2032" layer="21" curve="14.441093"/>
<wire x1="14.0864" y1="3.4159" x2="14.3273" y2="3.7476" width="0.2032" layer="21" curve="12.852895"/>
<wire x1="14.3273" y1="3.7476" x2="14.4562" y2="4.0727" width="0.2032" layer="21" curve="13.810089"/>
<wire x1="14.4562" y1="4.0727" x2="14.5" y2="4.4136" width="0.2032" layer="21" curve="14.520871"/>
<wire x1="11" y1="-5.15" x2="11" y2="-5.4" width="0.2032" layer="21"/>
<wire x1="11" y1="-5.4" x2="14" y2="-5.4" width="0.2032" layer="21"/>
<wire x1="14" y1="-5.4" x2="14" y2="-3.75" width="0.2032" layer="21"/>
<wire x1="14" y1="-3.75" x2="11" y2="-3.75" width="0.2032" layer="21"/>
<wire x1="11" y1="-3.75" x2="11" y2="-5.15" width="0.2032" layer="21"/>
<wire x1="10.8" y1="-6.2" x2="14.2" y2="-6.2" width="0.2032" layer="21"/>
<wire x1="14.2" y1="-6.2" x2="14.2" y2="-3" width="0.2032" layer="21"/>
<wire x1="14.2" y1="-3" x2="10.8" y2="-3" width="0.2032" layer="21"/>
<wire x1="10.8" y1="-3" x2="10.8" y2="-6.2" width="0.2032" layer="21"/>
<pad name="1" x="-2.5" y="0" drill="1.6" diameter="1.8" shape="long" rot="R90"/>
<pad name="2" x="2.5" y="0" drill="1.6" diameter="1.8" shape="long" rot="R90"/>
<pad name="3" x="7.5" y="0" drill="1.6" diameter="1.8" shape="long" rot="R90"/>
<pad name="4" x="12.5" y="0" drill="1.6" diameter="1.8" shape="long" rot="R90"/>
<text x="-5.08" y="6.985" size="1.27" layer="25">&gt;NAME</text>
<text x="1.905" y="6.985" size="1.27" layer="27">&gt;VALUE</text>
</package>
<package name="SMKDSP_1,5/3">
<description>&lt;b&gt;Printklemme, Nennstrom: 17,5 A, Bemessungsspannung: 250 V, Raster: 5,0 mm&lt;/b&gt;&lt;p&gt;
Source: http://eshop.phoenixcontact.de .. 1733415.pdf</description>
<wire x1="9.9" y1="-1.9017" x2="-4.9" y2="-1.9017" width="0.2032" layer="21"/>
<wire x1="9.9" y1="-2.354" x2="-4.9" y2="-2.354" width="0.2032" layer="21"/>
<wire x1="9.9" y1="2.192" x2="-4.9" y2="2.192" width="0.2032" layer="21"/>
<wire x1="9.9" y1="2.6785" x2="-4.9" y2="2.6785" width="0.2032" layer="21"/>
<wire x1="2.5" y1="6.0519" x2="2.0839" y2="6.0161" width="0.2032" layer="21" curve="9.818513"/>
<wire x1="2.0839" y1="6.016" x2="1.687" y2="5.9104" width="0.2032" layer="21" curve="10.070203"/>
<wire x1="1.687" y1="5.9104" x2="1.324" y2="5.7387" width="0.2032" layer="21" curve="10.633291"/>
<wire x1="1.324" y1="5.7387" x2="1.0139" y2="5.51" width="0.2032" layer="21" curve="11.361134"/>
<wire x1="1.0139" y1="5.51" x2="0.7679" y2="5.2327" width="0.2032" layer="21" curve="12.408633"/>
<wire x1="0.7679" y1="5.2327" x2="0.6204" y2="4.9736" width="0.2032" layer="21" curve="11.10896"/>
<wire x1="0.6205" y1="4.9736" x2="0.5305" y2="4.6984" width="0.2032" layer="21" curve="11.703364"/>
<wire x1="0.5305" y1="4.6984" x2="0.5" y2="4.4136" width="0.2032" layer="21" curve="12.150409"/>
<wire x1="4.5" y1="4.4136" x2="4.4695" y2="4.6984" width="0.2032" layer="21" curve="12.140502"/>
<wire x1="4.4695" y1="4.6984" x2="4.3795" y2="4.9736" width="0.2032" layer="21" curve="11.823167"/>
<wire x1="4.3795" y1="4.9736" x2="4.2321" y2="5.2327" width="0.2032" layer="21" curve="11.320489"/>
<wire x1="4.2321" y1="5.2327" x2="3.9861" y2="5.51" width="0.2032" layer="21" curve="12.612712"/>
<wire x1="3.9861" y1="5.51" x2="3.676" y2="5.7387" width="0.2032" layer="21" curve="11.606712"/>
<wire x1="3.676" y1="5.7387" x2="3.313" y2="5.9104" width="0.2032" layer="21" curve="10.808503"/>
<wire x1="3.313" y1="5.9104" x2="2.9161" y2="6.016" width="0.2032" layer="21" curve="10.16131"/>
<wire x1="2.9161" y1="6.016" x2="2.5" y2="6.0519" width="0.2032" layer="21" curve="9.8976"/>
<wire x1="-0.5" y1="4.4136" x2="-0.5438" y2="4.7544" width="0.2032" layer="21" curve="14.529549"/>
<wire x1="-0.5438" y1="4.7544" x2="-0.6727" y2="5.0795" width="0.2032" layer="21" curve="14.030571"/>
<wire x1="-0.6727" y1="5.0795" x2="-0.9137" y2="5.4112" width="0.2032" layer="21" curve="16.398865"/>
<wire x1="-0.9136" y1="5.4113" x2="-1.282" y2="5.713" width="0.2032" layer="21" curve="14.813546"/>
<wire x1="-1.282" y1="5.713" x2="-1.7351" y2="5.9273" width="0.2032" layer="21" curve="13.519323"/>
<wire x1="-1.7351" y1="5.9273" x2="-2.2384" y2="6.0378" width="0.2032" layer="21" curve="12.581205"/>
<wire x1="-2.2384" y1="6.0378" x2="-2.7616" y2="6.0378" width="0.2032" layer="21" curve="12.28945"/>
<wire x1="-2.7616" y1="6.0378" x2="-3.2649" y2="5.9273" width="0.2032" layer="21" curve="12.443318"/>
<wire x1="-3.2649" y1="5.9273" x2="-3.718" y2="5.713" width="0.2032" layer="21" curve="13.248047"/>
<wire x1="-3.718" y1="5.713" x2="-4.0864" y2="5.4113" width="0.2032" layer="21" curve="14.439619"/>
<wire x1="-4.0864" y1="5.4113" x2="-4.3274" y2="5.0795" width="0.2032" layer="21" curve="12.857171"/>
<wire x1="-4.3273" y1="5.0795" x2="-4.4562" y2="4.7544" width="0.2032" layer="21" curve="13.812127"/>
<wire x1="-4.4562" y1="4.7544" x2="-4.5" y2="4.4136" width="0.2032" layer="21" curve="14.512364"/>
<wire x1="-4.5" y1="4.4136" x2="-4.4695" y2="4.1287" width="0.2032" layer="21" curve="12.149235"/>
<wire x1="-4.4695" y1="4.1287" x2="-4.3795" y2="3.8536" width="0.2032" layer="21" curve="11.818019"/>
<wire x1="-4.3795" y1="3.8536" x2="-4.232" y2="3.5945" width="0.2032" layer="21" curve="11.320919"/>
<wire x1="-4.2321" y1="3.5944" x2="-3.9861" y2="3.3171" width="0.2032" layer="21" curve="12.610717"/>
<wire x1="-3.9861" y1="3.3171" x2="-3.676" y2="3.0884" width="0.2032" layer="21" curve="11.607468"/>
<wire x1="-3.676" y1="3.0884" x2="-3.313" y2="2.9167" width="0.2032" layer="21" curve="10.807383"/>
<wire x1="-3.313" y1="2.9167" x2="-2.9161" y2="2.8111" width="0.2032" layer="21" curve="10.16131"/>
<wire x1="-2.9161" y1="2.8111" x2="-2.5" y2="2.7752" width="0.2032" layer="21" curve="9.89801"/>
<wire x1="0.5" y1="4.4136" x2="0.5438" y2="4.0727" width="0.2032" layer="21" curve="14.538071"/>
<wire x1="0.5438" y1="4.0727" x2="0.6727" y2="3.7476" width="0.2032" layer="21" curve="14.027417"/>
<wire x1="0.6727" y1="3.7476" x2="0.9136" y2="3.4159" width="0.2032" layer="21" curve="16.392544"/>
<wire x1="0.9136" y1="3.4159" x2="1.282" y2="3.1141" width="0.2032" layer="21" curve="14.814063"/>
<wire x1="1.282" y1="3.1141" x2="1.7351" y2="2.8998" width="0.2032" layer="21" curve="13.518622"/>
<wire x1="1.7351" y1="2.8998" x2="2.2384" y2="2.7893" width="0.2032" layer="21" curve="12.581752"/>
<wire x1="2.2384" y1="2.7893" x2="2.7616" y2="2.7893" width="0.2032" layer="21" curve="12.288948"/>
<wire x1="2.7616" y1="2.7893" x2="3.2649" y2="2.8998" width="0.2032" layer="21" curve="12.443853"/>
<wire x1="3.2649" y1="2.8998" x2="3.718" y2="3.1141" width="0.2032" layer="21" curve="13.24872"/>
<wire x1="3.718" y1="3.1141" x2="4.0864" y2="3.4159" width="0.2032" layer="21" curve="14.441093"/>
<wire x1="4.0864" y1="3.4159" x2="4.3273" y2="3.7476" width="0.2032" layer="21" curve="12.852895"/>
<wire x1="4.3273" y1="3.7476" x2="4.4562" y2="4.0727" width="0.2032" layer="21" curve="13.810089"/>
<wire x1="4.4562" y1="4.0727" x2="4.5" y2="4.4136" width="0.2032" layer="21" curve="14.520871"/>
<wire x1="-2.5" y1="2.7753" x2="-2.0839" y2="2.8111" width="0.2032" layer="21" curve="9.823356"/>
<wire x1="-2.0839" y1="2.8111" x2="-1.687" y2="2.9167" width="0.2032" layer="21" curve="10.070203"/>
<wire x1="-1.687" y1="2.9167" x2="-1.324" y2="3.0884" width="0.2032" layer="21" curve="10.632749"/>
<wire x1="-1.324" y1="3.0884" x2="-1.0139" y2="3.3171" width="0.2032" layer="21" curve="11.361858"/>
<wire x1="-1.0139" y1="3.3171" x2="-0.7679" y2="3.5944" width="0.2032" layer="21" curve="12.401879"/>
<wire x1="-0.7679" y1="3.5944" x2="-0.6204" y2="3.8536" width="0.2032" layer="21" curve="11.113221"/>
<wire x1="-0.6205" y1="3.8536" x2="-0.5305" y2="4.1287" width="0.2032" layer="21" curve="11.698276"/>
<wire x1="-0.5305" y1="4.1287" x2="-0.5001" y2="4.4136" width="0.2032" layer="21" curve="12.152389"/>
<wire x1="-4.9" y1="-6.9" x2="9.9" y2="-6.9" width="0.2032" layer="21"/>
<wire x1="9.9" y1="-6.9" x2="9.9" y2="-2.354" width="0.2032" layer="21"/>
<wire x1="9.9" y1="-2.354" x2="9.9" y2="-1.9017" width="0.2032" layer="21"/>
<wire x1="9.9" y1="-1.9017" x2="9.9" y2="2.192" width="0.2032" layer="21"/>
<wire x1="9.9" y1="2.192" x2="9.9" y2="2.6785" width="0.2032" layer="21"/>
<wire x1="9.9" y1="2.6785" x2="9.9" y2="6.3" width="0.2032" layer="21"/>
<wire x1="9.9" y1="6.3" x2="-4.9" y2="6.3" width="0.2032" layer="21"/>
<wire x1="-4.9" y1="6.3" x2="-4.9" y2="2.6785" width="0.2032" layer="21"/>
<wire x1="-4.9" y1="2.6785" x2="-4.9" y2="2.192" width="0.2032" layer="21"/>
<wire x1="-4.9" y1="2.192" x2="-4.9" y2="-1.9017" width="0.2032" layer="21"/>
<wire x1="-4.9" y1="-1.9017" x2="-4.9" y2="-2.354" width="0.2032" layer="21"/>
<wire x1="-4.9" y1="-2.354" x2="-4.9" y2="-6.9" width="0.2032" layer="21"/>
<wire x1="-4" y1="-5.4" x2="-1" y2="-5.4" width="0.2032" layer="21"/>
<wire x1="-1" y1="-5.4" x2="-1" y2="-3.75" width="0.2032" layer="21"/>
<wire x1="-1" y1="-3.75" x2="-4" y2="-3.75" width="0.2032" layer="21"/>
<wire x1="-4" y1="-3.75" x2="-4" y2="-5.4" width="0.2032" layer="21"/>
<wire x1="-4.2" y1="-6.2" x2="-0.8" y2="-6.2" width="0.2032" layer="21"/>
<wire x1="-0.8" y1="-6.2" x2="-0.8" y2="-3" width="0.2032" layer="21"/>
<wire x1="-0.8" y1="-3" x2="-4.2" y2="-3" width="0.2032" layer="21"/>
<wire x1="-4.2" y1="-3" x2="-4.2" y2="-6.2" width="0.2032" layer="21"/>
<wire x1="10" y1="-6.3" x2="10.2" y2="-6.3" width="0.2032" layer="21"/>
<wire x1="10.2" y1="-6.3" x2="10.4" y2="-6.45" width="0.2032" layer="21"/>
<wire x1="10.4" y1="-6.45" x2="10.65" y2="-6.45" width="0.2032" layer="21"/>
<wire x1="10.65" y1="-6.45" x2="10.65" y2="-1.9" width="0.2032" layer="21"/>
<wire x1="10.65" y1="-1.9" x2="10.45" y2="-1.9" width="0.2032" layer="21"/>
<wire x1="10.45" y1="-1.9" x2="10.2" y2="-2.05" width="0.2032" layer="21"/>
<wire x1="10.2" y1="-2.05" x2="10" y2="-2.05" width="0.2032" layer="21"/>
<wire x1="10" y1="1.15" x2="10.2" y2="1.15" width="0.2032" layer="21"/>
<wire x1="10.2" y1="1.15" x2="10.4" y2="0.95" width="0.2032" layer="21"/>
<wire x1="10.4" y1="0.95" x2="10.65" y2="0.95" width="0.2032" layer="21"/>
<wire x1="10.65" y1="0.95" x2="10.65" y2="3.75" width="0.2032" layer="21"/>
<wire x1="10.65" y1="3.75" x2="10.4" y2="3.75" width="0.2032" layer="21"/>
<wire x1="10.4" y1="3.75" x2="10.2" y2="3.6" width="0.2032" layer="21"/>
<wire x1="10.2" y1="3.6" x2="10" y2="3.6" width="0.2032" layer="21"/>
<wire x1="1" y1="-5.15" x2="1" y2="-5.4" width="0.2032" layer="21"/>
<wire x1="1" y1="-5.4" x2="4" y2="-5.4" width="0.2032" layer="21"/>
<wire x1="4" y1="-5.4" x2="4" y2="-3.75" width="0.2032" layer="21"/>
<wire x1="4" y1="-3.75" x2="1" y2="-3.75" width="0.2032" layer="21"/>
<wire x1="1" y1="-3.75" x2="1" y2="-5.15" width="0.2032" layer="21"/>
<wire x1="0.8" y1="-6.2" x2="4.2" y2="-6.2" width="0.2032" layer="21"/>
<wire x1="4.2" y1="-6.2" x2="4.2" y2="-3" width="0.2032" layer="21"/>
<wire x1="4.2" y1="-3" x2="0.8" y2="-3" width="0.2032" layer="21"/>
<wire x1="0.8" y1="-3" x2="0.8" y2="-6.2" width="0.2032" layer="21"/>
<wire x1="7.5" y1="6.0519" x2="7.0839" y2="6.0161" width="0.2032" layer="21" curve="9.818513"/>
<wire x1="7.0839" y1="6.016" x2="6.687" y2="5.9104" width="0.2032" layer="21" curve="10.070203"/>
<wire x1="6.687" y1="5.9104" x2="6.324" y2="5.7387" width="0.2032" layer="21" curve="10.633291"/>
<wire x1="6.324" y1="5.7387" x2="6.0139" y2="5.51" width="0.2032" layer="21" curve="11.361134"/>
<wire x1="6.0139" y1="5.51" x2="5.7679" y2="5.2327" width="0.2032" layer="21" curve="12.408633"/>
<wire x1="5.7679" y1="5.2327" x2="5.6204" y2="4.9736" width="0.2032" layer="21" curve="11.10896"/>
<wire x1="5.6205" y1="4.9736" x2="5.5305" y2="4.6984" width="0.2032" layer="21" curve="11.703364"/>
<wire x1="5.5305" y1="4.6984" x2="5.5" y2="4.4136" width="0.2032" layer="21" curve="12.150409"/>
<wire x1="9.5" y1="4.4136" x2="9.4695" y2="4.6984" width="0.2032" layer="21" curve="12.140502"/>
<wire x1="9.4695" y1="4.6984" x2="9.3795" y2="4.9736" width="0.2032" layer="21" curve="11.823167"/>
<wire x1="9.3795" y1="4.9736" x2="9.2321" y2="5.2327" width="0.2032" layer="21" curve="11.320489"/>
<wire x1="9.2321" y1="5.2327" x2="8.9861" y2="5.51" width="0.2032" layer="21" curve="12.612712"/>
<wire x1="8.9861" y1="5.51" x2="8.676" y2="5.7387" width="0.2032" layer="21" curve="11.606712"/>
<wire x1="8.676" y1="5.7387" x2="8.313" y2="5.9104" width="0.2032" layer="21" curve="10.808503"/>
<wire x1="8.313" y1="5.9104" x2="7.9161" y2="6.016" width="0.2032" layer="21" curve="10.16131"/>
<wire x1="7.9161" y1="6.016" x2="7.5" y2="6.0519" width="0.2032" layer="21" curve="9.8976"/>
<wire x1="5.5" y1="4.4136" x2="5.5438" y2="4.0727" width="0.2032" layer="21" curve="14.538071"/>
<wire x1="5.5438" y1="4.0727" x2="5.6727" y2="3.7476" width="0.2032" layer="21" curve="14.027417"/>
<wire x1="5.6727" y1="3.7476" x2="5.9136" y2="3.4159" width="0.2032" layer="21" curve="16.392544"/>
<wire x1="5.9136" y1="3.4159" x2="6.282" y2="3.1141" width="0.2032" layer="21" curve="14.814063"/>
<wire x1="6.282" y1="3.1141" x2="6.7351" y2="2.8998" width="0.2032" layer="21" curve="13.518622"/>
<wire x1="6.7351" y1="2.8998" x2="7.2384" y2="2.7893" width="0.2032" layer="21" curve="12.581752"/>
<wire x1="7.2384" y1="2.7893" x2="7.7616" y2="2.7893" width="0.2032" layer="21" curve="12.288948"/>
<wire x1="7.7616" y1="2.7893" x2="8.2649" y2="2.8998" width="0.2032" layer="21" curve="12.443853"/>
<wire x1="8.2649" y1="2.8998" x2="8.718" y2="3.1141" width="0.2032" layer="21" curve="13.24872"/>
<wire x1="8.718" y1="3.1141" x2="9.0864" y2="3.4159" width="0.2032" layer="21" curve="14.441093"/>
<wire x1="9.0864" y1="3.4159" x2="9.3273" y2="3.7476" width="0.2032" layer="21" curve="12.852895"/>
<wire x1="9.3273" y1="3.7476" x2="9.4562" y2="4.0727" width="0.2032" layer="21" curve="13.810089"/>
<wire x1="9.4562" y1="4.0727" x2="9.5" y2="4.4136" width="0.2032" layer="21" curve="14.520871"/>
<wire x1="6" y1="-5.15" x2="6" y2="-5.4" width="0.2032" layer="21"/>
<wire x1="6" y1="-5.4" x2="9" y2="-5.4" width="0.2032" layer="21"/>
<wire x1="9" y1="-5.4" x2="9" y2="-3.75" width="0.2032" layer="21"/>
<wire x1="9" y1="-3.75" x2="6" y2="-3.75" width="0.2032" layer="21"/>
<wire x1="6" y1="-3.75" x2="6" y2="-5.15" width="0.2032" layer="21"/>
<wire x1="5.8" y1="-6.2" x2="9.2" y2="-6.2" width="0.2032" layer="21"/>
<wire x1="9.2" y1="-6.2" x2="9.2" y2="-3" width="0.2032" layer="21"/>
<wire x1="9.2" y1="-3" x2="5.8" y2="-3" width="0.2032" layer="21"/>
<wire x1="5.8" y1="-3" x2="5.8" y2="-6.2" width="0.2032" layer="21"/>
<pad name="1" x="-2.5" y="0" drill="1.6" diameter="1.8" shape="long" rot="R90"/>
<pad name="2" x="2.5" y="0" drill="1.6" diameter="1.8" shape="long" rot="R90"/>
<pad name="3" x="7.5" y="0" drill="1.6" diameter="1.8" shape="long" rot="R90"/>
<text x="-5.08" y="6.985" size="1.27" layer="25">&gt;NAME</text>
<text x="1.905" y="6.985" size="1.27" layer="27">&gt;VALUE</text>
</package>
</packages>
<symbols>
<symbol name="KLV">
<circle x="1.27" y="0" radius="1.27" width="0.254" layer="94"/>
<text x="-1.27" y="0.889" size="1.778" layer="95" rot="R180">&gt;NAME</text>
<text x="-3.81" y="2.667" size="1.778" layer="96">&gt;VALUE</text>
<pin name="KL" x="5.08" y="0" visible="off" length="short" direction="pas" rot="R180"/>
</symbol>
<symbol name="KL">
<circle x="1.27" y="0" radius="1.27" width="0.254" layer="94"/>
<text x="-1.27" y="0.889" size="1.778" layer="95" rot="R180">&gt;NAME</text>
<pin name="KL" x="5.08" y="0" visible="off" length="short" direction="pas" rot="R180"/>
</symbol>
</symbols>
<devicesets>
<deviceset name="SMKDSP_1,5/4" prefix="X">
<description>&lt;b&gt;Printklemme, Nennstrom: 17,5 A, Bemessungsspannung: 250 V, Raster: 5,0 mm&lt;/b&gt;&lt;p&gt;
Source: http://eshop.phoenixcontact.de .. 1733415.pdf</description>
<gates>
<gate name="-1" symbol="KLV" x="0" y="0" addlevel="always"/>
<gate name="-2" symbol="KL" x="0" y="-5.08" addlevel="always"/>
<gate name="-3" symbol="KL" x="0" y="-10.16" addlevel="always"/>
<gate name="-4" symbol="KL" x="0" y="-15.24" addlevel="always"/>
</gates>
<devices>
<device name="" package="SMKDSP_1,5/4">
<connects>
<connect gate="-1" pin="KL" pad="1"/>
<connect gate="-2" pin="KL" pad="2"/>
<connect gate="-3" pin="KL" pad="3"/>
<connect gate="-4" pin="KL" pad="4"/>
</connects>
<technologies>
<technology name="">
<attribute name="MF" value="FARNELL" constant="no"/>
<attribute name="MPN" value="1733596" constant="no"/>
<attribute name="OC_FARNELL" value="3041268" constant="no"/>
<attribute name="OC_NEWARK" value="71C4131" constant="no"/>
</technology>
</technologies>
</device>
</devices>
</deviceset>
<deviceset name="SMKDSP_1,5/3" prefix="X">
<description>&lt;b&gt;Printklemme, Nennstrom: 17,5 A, Bemessungsspannung: 250 V, Raster: 5,0 mm&lt;/b&gt;&lt;p&gt;
Source: http://eshop.phoenixcontact.de .. 1733415.pdf</description>
<gates>
<gate name="-1" symbol="KLV" x="0" y="0" addlevel="always"/>
<gate name="-2" symbol="KL" x="0" y="-5.08" addlevel="always"/>
<gate name="-3" symbol="KL" x="0" y="-10.16" addlevel="always"/>
</gates>
<devices>
<device name="" package="SMKDSP_1,5/3">
<connects>
<connect gate="-1" pin="KL" pad="1"/>
<connect gate="-2" pin="KL" pad="2"/>
<connect gate="-3" pin="KL" pad="3"/>
</connects>
<technologies>
<technology name="">
<attribute name="MF" value="FARNELL" constant="no"/>
<attribute name="MPN" value="1733583" constant="no"/>
<attribute name="OC_FARNELL" value="3041256" constant="no"/>
<attribute name="OC_NEWARK" value="71C4130" constant="no"/>
</technology>
</technologies>
</device>
</devices>
</deviceset>
</devicesets>
</library>
</libraries>
<attributes>
</attributes>
<variantdefs>
</variantdefs>
<classes>
<class number="0" name="default" width="0" drill="0">
</class>
</classes>
<parts>
<part name="X1" library="con-phoenix-smkdsp" deviceset="SMKDSP_1,5/4" device=""/>
<part name="X2" library="con-phoenix-smkdsp" deviceset="SMKDSP_1,5/4" device=""/>
<part name="X3" library="con-phoenix-smkdsp" deviceset="SMKDSP_1,5/3" device=""/>
</parts>
<sheets>
<sheet>
<plain>
</plain>
<instances>
<instance part="X1" gate="-1" x="43.18" y="43.18" rot="R270"/>
<instance part="X1" gate="-2" x="38.1" y="43.18" rot="R270"/>
<instance part="X1" gate="-3" x="33.02" y="43.18" rot="R270"/>
<instance part="X1" gate="-4" x="27.94" y="43.18" rot="R270"/>
<instance part="X2" gate="-1" x="83.82" y="43.18" rot="R270"/>
<instance part="X2" gate="-2" x="78.74" y="43.18" rot="R270"/>
<instance part="X2" gate="-3" x="73.66" y="43.18" rot="R270"/>
<instance part="X2" gate="-4" x="68.58" y="43.18" rot="R270"/>
<instance part="X3" gate="-1" x="43.18" y="15.24" rot="R90"/>
<instance part="X3" gate="-2" x="38.1" y="15.24" rot="R90"/>
<instance part="X3" gate="-3" x="33.02" y="15.24" rot="R90"/>
</instances>
<busses>
</busses>
<nets>
<net name="BASE" class="0">
<segment>
<pinref part="X3" gate="-1" pin="KL"/>
<pinref part="X1" gate="-1" pin="KL"/>
<wire x1="43.18" y1="20.32" x2="43.18" y2="33.02" width="0.1524" layer="91"/>
<pinref part="X1" gate="-4" pin="KL"/>
<wire x1="43.18" y1="33.02" x2="43.18" y2="38.1" width="0.1524" layer="91"/>
<wire x1="43.18" y1="33.02" x2="27.94" y2="33.02" width="0.1524" layer="91"/>
<wire x1="27.94" y1="33.02" x2="27.94" y2="38.1" width="0.1524" layer="91"/>
<junction x="43.18" y="33.02"/>
<pinref part="X2" gate="-2" pin="KL"/>
<wire x1="43.18" y1="33.02" x2="78.74" y2="33.02" width="0.1524" layer="91"/>
<wire x1="78.74" y1="33.02" x2="78.74" y2="38.1" width="0.1524" layer="91"/>
</segment>
</net>
<net name="COLECTOR" class="0">
<segment>
<pinref part="X3" gate="-2" pin="KL"/>
<pinref part="X1" gate="-2" pin="KL"/>
<wire x1="38.1" y1="20.32" x2="38.1" y2="30.48" width="0.1524" layer="91"/>
<pinref part="X2" gate="-3" pin="KL"/>
<wire x1="38.1" y1="30.48" x2="38.1" y2="38.1" width="0.1524" layer="91"/>
<wire x1="38.1" y1="30.48" x2="73.66" y2="30.48" width="0.1524" layer="91"/>
<wire x1="73.66" y1="30.48" x2="73.66" y2="38.1" width="0.1524" layer="91"/>
<junction x="38.1" y="30.48"/>
</segment>
</net>
<net name="EMITOR" class="0">
<segment>
<pinref part="X3" gate="-3" pin="KL"/>
<pinref part="X1" gate="-3" pin="KL"/>
<wire x1="33.02" y1="20.32" x2="33.02" y2="27.94" width="0.1524" layer="91"/>
<pinref part="X2" gate="-1" pin="KL"/>
<wire x1="33.02" y1="27.94" x2="33.02" y2="38.1" width="0.1524" layer="91"/>
<wire x1="33.02" y1="27.94" x2="83.82" y2="27.94" width="0.1524" layer="91"/>
<wire x1="83.82" y1="27.94" x2="83.82" y2="38.1" width="0.1524" layer="91"/>
<junction x="33.02" y="27.94"/>
</segment>
</net>
</nets>
</sheet>
</sheets>
</schematic>
</drawing>
</eagle>

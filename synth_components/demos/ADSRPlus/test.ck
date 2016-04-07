SawOsc saw => AdsrPlus adsr => dac;
saw.freq(300);
saw.gain(.2);
adsr.init();
AdsrPlusGui adsrGui;
MAUI_View view;
adsrGui.init(adsr, view, 0,0);
view.display();

while(true) {
  adsr.keyOn();
	<<<adsr.envelope.decayTime()>>>;
  500::ms => now;
  adsr.keyOff();
	<<<adsr.envelope.decayTime()>>>;
  500::ms => now;
}

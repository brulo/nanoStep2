SawOsc saw => AdsrPlus adsr => Gain gain => dac;
saw.freq(300);
gain.gain(.5);
adsr.init();
AdsrPlusGui adsrGui;
MAUI_View view;
adsrGui.init(adsr, view, 0,0);
view.display();

while(true) {
  adsr.keyOn();
  500::ms => now;
  adsr.keyOff();
  500::ms => now;
}

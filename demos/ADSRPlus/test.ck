SawOsc saw => ADSRPlus adsr => Gain gain => dac;
saw.freq(300);
gain.gain(.5);
adsr.init();

MAUI_View view;
adsr.initGUI(view, "ADSR Plus", 0, 0);
view.display();

while(true) {
  adsr.keyOn();
  500::ms => now;
  adsr.keyOff();
  500::ms => now;
}

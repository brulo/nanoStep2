SawOsc saw => MultiFilter mfilt => Gain gain => dac;
MultiFilterGui mFiltGui;
MAUI_View view;

gain.gain(0.5);
saw.freq(440);
mfilt.init();
mFiltGui.init(mfilt, view, 0, 0);
view.display();

while(samp => now);

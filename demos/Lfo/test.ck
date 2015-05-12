Lfo lfo => blackhole;
LfoGui lfoGui;
MAUI_View view;
lfo.init();
lfo.initGUI(view, "LFO", 0, 0);

SawOsc saw => MultiFilter mFilt => dac;
mFilt.init();
mFilt.initGUI(view, "MultiFilter", 0, 250);
mFilt.addFreqMod(lfo);

view.display();

20::second => now;

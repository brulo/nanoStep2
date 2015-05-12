Lfo lfo => blackhole;
/* Lfo lfo => dac; */
LfoGui lfoGui;
SawOsc saw => MultiFilter mFilt => dac;
MultiFilterGui mFiltGui;
MAUI_View view;
lfo.init();
lfoGui.init(lfo, view, "LFO", 0, 0);

mFilt.init();
mFiltGui.init(mFilt, view, 0, 250);
mFilt.addFreqMod(lfo);

view.display();

while(samp => now);

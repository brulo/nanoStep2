Lfo lfo => dac;
LfoGui lfoGui;
lfo.init();

MAUI_View view;
lfoGui.init(lfo, view, 0, 0);
view.display();

while(samp => now);

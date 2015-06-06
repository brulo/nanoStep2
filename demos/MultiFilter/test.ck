SawOsc saw => MultiFilter mfilt => dac;
saw.freq(300);
saw.gain(0.1);
mfilt.init();

// freq lfo
SinOsc sin => blackhole;
sin.freq(2);
sin @=> mfilt.freqLfo.source;

// freq env
Step step => ADSR env => blackhole;
step.next(1);
env.set(20::ms, 0::ms, 1, 500::ms);
env @=> mfilt.freqEnv.source;

MAUI_View view;
MultiFilterGui mFiltGui;
mFiltGui.init(mfilt, view, 0, 0);

view.display();

while(true) {
	env.keyOn();
	0.1::second => now;
	env.keyOff();
	1::second => now;
}

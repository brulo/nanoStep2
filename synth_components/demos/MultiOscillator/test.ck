MultiOscillator mOsc => dac;
mOsc.init();
mOsc.gain(0.5);
mOsc.note(40);

// freq lfo
SinOsc lfo => blackhole;
lfo.freq(2);
lfo @=> mOsc.freqLfo.source;

// freq env
Step step => ADSR env => blackhole;
step.next(1);
env.set(20::ms, 0::ms, 1, 500::ms);
env @=> mOsc.freqEnv.source;

MultiOscillatorGui mOscGui;
MAUI_View view;
mOscGui.init(mOsc, view, 0, 0);
view.display();


while(true) {
	env.keyOn();
	0.1::second => now;
	env.keyOff();
	1::second => now;
}

MultiOscillator mOsc => Gain g => dac;
MultiOscillatorGui mOscGui;
MAUI_View view;
g.gain(0.4);

<<<"MultiOscillator test", "">>>;
<<<"initializing MultiOscillator", "">>>;
mOsc.init();

<<<"initializing GUI", "">>>;
mOscGui.init(mOsc, view, 0, 0);
view.display();

<<<"initial waveform: saw", "">>>;
mOsc.note(mOsc.note() + 32);
1::second => now;
/*
<<<"waveform: sqr", "">>>;
mOsc.waveform("sqr");
1::second => now;

<<<"waveform: sin", "">>>;
mOsc.waveform("sin");
1::second => now;

<<<"waveform: tri", "">>>;
mOsc.waveform("tri");
1::second => now;

<<<"ascending chromatic scale">>>;
for(0 => int i; i <= 12; i++) {
  mOsc.note(48 + i);
  200::ms => now;
}
*/
<<<"hand test the GUI now", "">>>;

20::second => now;

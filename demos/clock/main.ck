SinOsc metro => ADSR metroEnv => dac;
metro.gain(.5);
metro.freq(Std.mtof(60));
metroEnv.set(1::ms, 10::ms, 0, 0::ms);

Clock clock;
clock.init();

while(clock.step => now) {
	metroEnv.keyOff();
	metroEnv.keyOn();
}

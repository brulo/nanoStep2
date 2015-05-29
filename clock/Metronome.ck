public class Metronome {
	SinOsc metroOsc => ADSR metroAmpEnv => Gain gain => dac;
	Clock clock;
	1 => int isClicking;

	fun void init(Clock theClock) {
		theClock @=> clock;
		gain.gain(0.7);
		metroAmpEnv.set(0.01::ms, 10::ms, 0, 0::ms);
		spork ~ _main();
	}

	fun void _main() {
		while(clock.step => now) {
			if(isClicking) {
				if(clock.currentStep % 4 == 0) {
					metroOsc.freq(Std.mtof(100));
				}
				else {
					metroOsc.freq(Std.mtof(90));
				}
				_click();
			}
		}
	}

	fun void _click() {
		metroAmpEnv.keyOff();
		metroAmpEnv.keyOn();
	}
}

public class EfAmp extends Chubgraph {
	UGen source;

	fun void init() {
		inlet => outlet;
		spork ~ _loop();
	}

	fun void _loop() {
		while(samp => now) {
			gain(Utility.clamp(source.last(), 0.0, 1.0));
		}
	}
}

public class InternalClock extends Clock {
	float _bpm;
	dur _stepDur, _swingDur; 
	4 => int _stepsPerBeat;  // 16ths
	20 => float MIN_BPM;
	999 => float MAX_BPM;

	fun void init() {
		bpm(130.0);
		swingAmount(0.0);
		stop();
		spork ~ _main();
	}

	fun void _main() {
		time lastPulse;  // unswung steps
		while(true) {
			if(isPlaying) { 
				if(now - lastPulse >= _stepDur) {
					if(currentStep % 2 == 0) {
						spork ~ _broadcastStep(1);  // swung
					}
					else {
						spork ~ _broadcastStep(0);  // unswung
					}
					now => lastPulse;
				}
			}
			samp => now;
		}
	}

	fun float bpm() { return _bpm; } 
	fun float bpm(float newBpm) {
		Utility.clamp(newBpm, MIN_BPM, MAX_BPM) => _bpm;
		_updateStepDur();
		return _bpm;
	}

	fun float addToBpm(float amount) {
		amount + _bpm => float newBpm;
		Utility.clamp(newBpm, MIN_BPM, MAX_BPM) => newBpm;
		return bpm(newBpm); 
	}

	fun int stepsPerBeat() { return _stepsPerBeat; }
	fun int stepsPerBeat(int theStepsPerBeat) {
		if(theStepsPerBeat > 0) {
			theStepsPerBeat => _stepsPerBeat;
			_updateStepDur();
		}
		return _stepsPerBeat;
	}

	fun void _updateStepDur() {
		60::second / _bpm => dur secondsPerBeat;
		secondsPerBeat / _stepsPerBeat => _stepDur;
	}
}

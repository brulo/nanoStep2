// A pitch sequencer that triggers midi on channel 1
// by Bruce Lott, 2013-2014
public class PitchSequencer extends Sequencer {
	float _triggers[][]; // [pattern][step]
	int accents[][];
	int ties[][];
	float pitches[][];  
	int _transpose, _octave, _lastNote;
	0.5 => float _stepLength;  // 0.0-1.0 of stepDur
	100::ms => dur _stepDur;
	int _numberOfPatterns, _patternPlaying, _patternEditing;


	fun void __init( Clock clock ) {
		_init( clock );

		8 => _numberOfPatterns;
		0 => _patternEditing => _patternPlaying;
		4 => _octave;

		new float[_numberOfPatterns][_numberOfSteps] @=> _triggers;
		new int[_numberOfPatterns][_numberOfSteps] @=> accents;
		new int[_numberOfPatterns][_numberOfSteps] @=> ties;
		new float[_numberOfPatterns][_numberOfSteps] @=> pitches;

		spork ~ stepLengthLoop();
	}

	// * Pattern Select Functionality *

	fun int numberOfPatterns() { return _numberOfPatterns; }

	fun int patternPlaying() { return _patternPlaying; }
	fun int patternPlaying(int pp) {
		Utility.clampi(pp, 0, _numberOfPatterns) => _patternPlaying;
		return _patternPlaying;
	}

	fun int patternEditing() { return _patternEditing; }
	fun int patternEditing(int pe) {
		if(pe>=0 & pe<_numberOfPatterns) 
			pe => _patternEditing;
		return _patternEditing;
	}

	// * Per Step Properties *

	fun float trigger(int step) { return _triggers[_patternEditing][step]; }
	fun float trigger(int step, float val) {
		Utility.clamp(val, 0.0, 1.0) => _triggers[_patternEditing][step];
		return _triggers[_patternEditing][step];
	}

	fun float pitch(int s) { return pitches[_patternEditing][s]; }
	fun float pitch(int s, float p) { 
		p => pitches[_patternEditing][s]; 
		return pitches[_patternEditing][s]; 
	}

	fun int accent(int s) { return accents[_patternEditing][s]; }
	fun int accent(int s, int t) { 
		t => accents[_patternEditing][s];
		return accents[_patternEditing][s];
	}

	fun int tie(int s) { return ties[_patternEditing][s]; }
	fun int tie(int s, int t) { 
		t => ties[_patternEditing][s];
		return ties[_patternEditing][s];
	}

	// * Sequencer Properties *

	fun float stepLength() { return _stepLength; }
	fun float stepLength(float sl) {
		Utility.clamp(sl, 0.0, 1.0) => _stepLength;
		return _stepLength;
	}

	fun int transpose() { return _transpose; }
	fun int transpose(int t) {
		t => _transpose;
		return _transpose;
	}

	fun int octave() { return _octave; }
	fun int octave(int o) {
		o => _octave;
		return _octave;
	}

	// * Utility Shreds *

	fun void stepLengthLoop() {
		while(samp => now) {
			_stepLength * (clock.lastStepDur - 20::ms) + 20::ms => _stepDur;
		}
	}

}

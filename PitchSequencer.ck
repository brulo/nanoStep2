// A pitch sequencer that triggers midi on channel 1
// by Bruce Lott, 2013-2014
public class PitchSequencer extends Sequencer {
	int accents[][];
	int ties[][];
	float pitches[][];  
	int _transpose, _octave, _lastNote;
	0.5 => float _stepLength;  // 0.0-1.0 of stepDur
	100::ms => dur _stepDur;
	MidiOut midiOut;

	fun void init(Clock clock, MidiOut theMidiOut) {
		_init(clock);
		theMidiOut @=> midiOut;
		4 => _octave;
		new int[_numberOfPatterns][_numberOfSteps] @=> accents;
		new int[_numberOfPatterns][_numberOfSteps] @=> ties;
		new float[_numberOfPatterns][_numberOfSteps] @=> pitches;
		spork ~ stepLengthLoop();
	}

	fun float pitch(int s) { return pitches[_patternEditing][s]; }
	fun float pitch(int s, float p) { 
		p => pitches[_patternEditing][s]; 
		return pitches[_patternEditing][s]; 
	}

	fun float stepLength() { return _stepLength; }
	fun float stepLength(float sl) {
		Utility.clamp(sl, 0.0, 1.0) => _stepLength;
		return _stepLength;
	}

	fun void stepLengthLoop() {
		while(samp => now) {
			_stepLength * (clock.lastStepDur - 20::ms) + 20::ms => _stepDur;
		}
	}

	fun int octave() { return _octave; }
	fun int octave(int o) {
		o => _octave;
		return _octave;
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
	fun int transpose() { return _transpose; }
	fun int transpose(int t) {
		t => _transpose;
		return _transpose;
	}

	fun void doStep() {
		int _velocity;
		if(_triggers[_patternPlaying][_currentStep]>0) {
			80 => _velocity;
			if(accents[_patternPlaying][_currentStep]) 40 +=> _velocity;
			(pitches[_patternPlaying][_currentStep] + _transpose + (_octave * 12)) $ int => int currentNote;
			if(ties[_patternPlaying][_currentStep]) {
				if(currentNote != _lastNote) {
					/* <<<"currrent note on", "">>>; */
					Utility.midiOut(0x90, currentNote, _velocity, midiOut);
					2::ms => now;
					/* <<<"last note off", "">>>; */
					Utility.midiOut(0x80, _lastNote, 10, midiOut);
				}
			}
			else { // gate
				/* <<<"current note on", "">>>; */
				Utility.midiOut(0x90, currentNote, _velocity, midiOut);
				spork ~ noteOffAfterStepDur(currentNote, _velocity);
				if(currentNote != _lastNote) {
					2::ms => now;
					/* <<<"last note off", "">>>; */
					Utility.midiOut(0x80, _lastNote, _velocity, midiOut);
				}
			}
			currentNote => _lastNote;
		}
		else {
			if(!ties[_patternPlaying][_currentStep] & _lastNote !=0) { 
				/* <<< "0 => _lastNote", "">>>; */
				Utility.midiOut(0x80, _lastNote, _velocity, midiOut);
				0 => _lastNote;
			}
		}
	}


	fun void noteOffAfterStepDur(int p, int v) {
		_stepDur => now;
		/* <<<"note off", "">>>; */
		Utility.midiOut(0x80, p, v, midiOut); 
	}
}

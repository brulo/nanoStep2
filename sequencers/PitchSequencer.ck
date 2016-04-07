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
	MidiOut midiOut;
	0 => int midiChannel;
	int _numberOfPatterns, _patternPlaying, _patternEditing;

	fun void init(Clock clock, MidiOut theMidiOut) {
		init(clock, theMidiOut, 0);
	}

	fun void init(Clock clock, MidiOut theMidiOut, int theMidiChannel) {
		_init(clock);
		theMidiOut @=> midiOut;
		theMidiChannel => midiChannel;

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

	// * Midi Generation *

	fun void doStep() {
		//<<<"====== doStep() begins ======", "">>>;

		// get this step's velocity
		80 => int _velocity;
		if(accents[_patternPlaying][_currentStep]) {
			127 => _velocity;
		}

		// get this step's pitch
		(pitches[_patternPlaying][_currentStep] $ int) => int currentNote;
		(currentNote + _transpose + (_octave * 12)) $ int => currentNote;

		// step is triggered
		if(_triggers[_patternPlaying][_currentStep] > 0) {

			// step is tied
			if(ties[_patternPlaying][_currentStep]) {
				if(currentNote != _lastNote) {
					//<<<"	* tie *", "">>>;
					//<<<"new note on", "">>>;
					Utility.midiOut(0x90 + midiChannel, currentNote, _velocity, midiOut);
					10::ms => now;
					//<<<"last note off", "">>>;
					Utility.midiOut(0x80+ midiChannel, _lastNote, 10, midiOut);
				}
				else {
					//<<<"	* hold * ", "">>>;
				}
			}
			// step is gated 
			else {
				//<<<"new note on", "">>>;
				Utility.midiOut(0x90 + midiChannel, currentNote, _velocity, midiOut);
				spork ~ noteOffAfterStepDur(currentNote, _velocity);

				if(currentNote != _lastNote) {
					2::ms => now;
					//<<<"last note off", "">>>;
					Utility.midiOut(0x80 + midiChannel, _lastNote, _velocity, midiOut);
				}
			}
			currentNote => _lastNote;
		}
		// nothing happens this step
		else {
			if(!ties[_patternPlaying][_currentStep] & _lastNote !=0) { 
				//<<< "0 => _lastNote", "">>>;
				Utility.midiOut(0x80 + midiChannel, _lastNote, _velocity, midiOut);
				0 => _lastNote;
			}
		}
	}

	// * Utility Shreds *

	fun void stepLengthLoop() {
		while(samp => now) {
			_stepLength * (clock.lastStepDur - 20::ms) + 20::ms => _stepDur;
		}
	}

	fun void noteOffAfterStepDur(int p, int v) {
		_stepDur => now;
		//<<<"note off", "">>>;
		Utility.midiOut(0x80 + midiChannel, p, v, midiOut); 
	}
}

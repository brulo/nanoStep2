public class PitchSequencerMidi extends PitchSequencer {
	MidiOut midiOut;
	0 => int midiChannel;

	fun void ___init( Clock clock, MidiOut theMidiOut, int theMidiChannel ) {
		__init( clock );
		theMidiOut @=> midiOut;
		theMidiChannel => midiChannel;
	}

	// overwriting Sequencer.ck's doStep()
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

	fun void noteOffAfterStepDur(int p, int v) {
		_stepDur => now;
		//<<<"note off", "">>>;
		Utility.midiOut(0x80 + midiChannel, p, v, midiOut); 
	}

}

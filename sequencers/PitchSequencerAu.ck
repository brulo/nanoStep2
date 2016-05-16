public class PitchSequencerAu extends PitchSequencer {
	AudioUnit audioUnit;

	fun void ___init( Clock clock, AudioUnit theAudioUnit ) {
		__init( clock );
		theAudioUnit @=> audioUnit;
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
		( currentNote + _transpose + _octave*12 + octaves[_patternEditing][_currentStep]*12 ) $ int => currentNote;

		// step is triggered
		if(_triggers[_patternPlaying][_currentStep] > 0) {

			// step is tied
			if(ties[_patternPlaying][_currentStep]) {
				if(currentNote != _lastNote) {
					//<<<"	* tie *", "">>>;
					//<<<"new note on", "">>>;
					audioUnit.send( 0x90, currentNote, _velocity );
					10::ms => now;
					//<<<"last note off", "">>>;
					audioUnit.send( 0x80, _lastNote, 10 );
				}
				else {
					//<<<"	* hold * ", "">>>;
				}
			}
			// step is gated 
			else {
				//<<<"new note on", "">>>;
				//<<<currentNote>>>;
				audioUnit.send( 0x90, currentNote, _velocity );
				spork ~ noteOffAfterStepDur(currentNote, _velocity);

				if(currentNote != _lastNote) {
					2::ms => now;
					//<<<"last note off", "">>>;
					audioUnit.send( 0x80 , _lastNote, _velocity );
				}
			}
			currentNote => _lastNote;
		}
		// nothing happens this step
		else {
			if(!ties[_patternPlaying][_currentStep] & _lastNote !=0) { 
				//<<< "0 => _lastNote", "">>>;
				audioUnit.send( 0x80, _lastNote, _velocity );
				0 => _lastNote;
			}
		}
	}

	fun void noteOffAfterStepDur(int p, int v) {
		_stepDur => now;
		//<<<"note off", "">>>;
		audioUnit.send( 0x80, p, v ); 
	}

}

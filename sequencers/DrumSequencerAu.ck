public class DrumSequencerAu extends DrumSequencer {

	AudioUnit audioUnit;

	fun void init( Clock clock, AudioUnit theAudioUnit ) {
		_init( clock );
		theAudioUnit @=> audioUnit;
		new int[_numberOfDrums][_numberOfPatterns][_numberOfSteps] @=> triggers;
	}

	fun void doStep() {
		for( 0 => int drumIndex; drumIndex < _numberOfDrums; drumIndex++ ) {
			if( triggers[drumIndex][_patternPlaying][_currentStep] > 0 ) {
				<<< "trigger for drum:", drumIndex >>>;
				triggers[drumIndex][_patternPlaying][_currentStep] * 100 => int velocity;

				audioUnit.send( 0x90, drumIndex + 36, velocity);
				spork ~ gateShred( drumIndex + 36, velocity );
			}
		}
	}

	fun void gateShred( int noteValue, int velocity ) {
		100::ms => now;
		audioUnit.send( 0x80, noteValue, velocity );
	}
	
}

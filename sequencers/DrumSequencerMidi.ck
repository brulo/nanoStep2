public class DrumSequencerMidi extends DrumSequencer {

	MidiOut midiOut;
	int midiChannel;

	fun void init( Clock clock, MidiOut theMidiOut, int theMidiChannel ) {
		_init( clock );
		theMidiOut @=> midiOut;	
		theMidiChannel => midiChannel;

		new int[_numberOfDrums][_numberOfPatterns][_numberOfSteps] @=> triggers;
	}

	fun void doStep() {
		for( 0 => int drumIndex; drumIndex < _numberOfDrums; drumIndex++ ) {
			if( triggers[drumIndex][_patternPlaying][_currentStep] > 0 ) {
				<<< "trigger for drum:", drumIndex >>>;
				triggers[drumIndex][_patternPlaying][_currentStep] * 100 => int velocity;

				Utility.midiOut( 0x90 + midiChannel, drumIndex + 36, velocity, midiOut );
				spork ~ gateShred( drumIndex + 36, velocity );
			}
		}
	}

	fun void gateShred( int noteValue, int velocity ) {
		100::ms => now;

		Utility.midiOut( 0x80 + midiChannel, 
			noteValue, velocity, midiOut );
	}
	
}
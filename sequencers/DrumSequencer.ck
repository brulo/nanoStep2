// 8 voice drum sequencer. 
public class DrumSequencer extends Sequencer {

	int triggers[][][]; //[drum][sequence][step]	
	8 => int _numberOfPatterns;
	8 => int _numberOfDrums;
	0 => int _selectedDrum;
	0 => int _patternEditing;
	0 => int _patternPlaying;
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
				triggers[drumIndex][_patternPlaying][_currentStep] * 12 => int velocity;

				Utility.midiOut( 0x90 + midiChannel, drumIndex + 36, velocity, midiOut );
				spork ~ gateShred( drumIndex + 36, velocity );
			}
		}
	}



	// * Set and Get Properties * 

	fun int trigger( int step ) {
		return triggers[_selectedDrum][_patternEditing][step];
	}
	fun int trigger( int step, int offOrOn ) {
		Utility.clampi( offOrOn, 0, 1 ) => offOrOn;
		offOrOn => triggers[_selectedDrum][_patternEditing][step];
		
		return triggers[_selectedDrum][_patternEditing][step];
	}

	fun int selectedDrum() { return _selectedDrum; }
	fun int selectedDrum( int drumToSelect ) {
		drumToSelect => _selectedDrum;
	}

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

	// * Get Only Properties *

	fun int numberOfPatterns() { return _numberOfPatterns; }
	fun int numberOfDrums() { return _numberOfDrums; }

	// * Utility Shreds

	fun void gateShred( int noteValue, int velocity ) {
		100::ms => now;

		Utility.midiOut( 0x80 + midiChannel, 
			noteValue, velocity, midiOut );
	}

}

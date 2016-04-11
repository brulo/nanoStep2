// 8 voice drum sequencer. 
public class DrumSequencer extends Sequencer {

	int triggers[][][]; //[drum][sequence][step]	
	8 => int _numberOfPatterns;
	8 => int _numberOfDrums;
	0 => int _selectedDrum;
	0 => int _patternEditing;
	0 => int _patternPlaying;

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

}

// Sequencer.ck
// Sequencer base class to extend from
// Uses local OSC 
// by Bruce Lott, 2013

public class Sequencer {
	int _patternLength, _numberOfSteps, _currentStep;
	int _numberOfPatterns, _patternPlaying, _patternEditing;
	float _triggers[][]; // [pattern][step]
	Clock clock;
	Shred clockShred;

	fun void _init(Clock theClock) {
		theClock @=> clock;
		0  => _currentStep => _patternPlaying => _patternEditing;
		8  => _patternLength => _numberOfPatterns;
		64 => _numberOfSteps;
		new float[_numberOfPatterns][_numberOfSteps] @=> _triggers;
		clearAllTriggers();
		spork ~ clockLoop() @=> clockShred;
	}  

	fun void clockLoop() { 
		while(clock.step => now) {
			clock.currentStep % _patternLength => _currentStep;
			doStep();
		}
	}

	fun void doStep() { } // what happens when arriving at a new step
	// override this in child class     

	fun float trigger(int step) { return _triggers[_patternEditing][step]; }
	fun float trigger(int step, float val) {
		Utility.clamp(val, 0.0, 1.0) => _triggers[_patternEditing][step];
		return _triggers[_patternEditing][step];
	}

	fun void clearTriggers() {  // clear pattern being edited's triggers
		for (int i; i<_triggers[0].cap(); i++) {
			0.0 => _triggers[_patternEditing][i];
		}
	}

	fun void clearAllTriggers() { 
		for (int i; i<_triggers.cap(); i++) {
			for (int j; j<_triggers[0].cap(); j++) {
				0 => _triggers[i][j];
			}
		}
	}

	fun int numberOfSteps() { return _numberOfSteps; }

	fun int numberOfPatterns() { return _numberOfPatterns; }

	fun int currentStep() { return _currentStep; }

	// pattern select functionality
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

	fun int patternLength() { return _patternLength; }
	fun int patternLength(int pl) {
		Utility.clampi(pl, 0, _numberOfSteps) => _patternLength;
		return _patternLength;
	}
}

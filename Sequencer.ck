// Sequencer base class to extend from
// by Bruce Lott, 2013-2015

public class Sequencer {
	int _numberOfSteps, _currentStep, _patternLength;
	int _numberOfPatterns, _patternPlaying, _patternEditing;
	float _triggers[][]; // [pattern][step]
	Clock clock;
	Shred clockShred;
	int _firstStep, _lastStep; // controls pattern length 

	fun void _init(Clock theClock) {
		theClock @=> clock;
		0  => _currentStep => _patternPlaying => _patternEditing => _firstStep;
		8  => _numberOfPatterns;
		64 => _numberOfSteps;
		new float[_numberOfPatterns][_numberOfSteps] @=> _triggers;
		lastStep(7);
		clearAllTriggers();
		spork ~ clockLoop() @=> clockShred;
	}  

	fun void clockLoop() { 
		while(clock.step => now) {
			((clock.currentStep % _numberOfSteps) + _firstStep) % _patternLength => _currentStep;
			doStep();
		}
	}

	fun void doStep() {  
		// what happens when arriving at a new step.
		// override this in child class     
	}

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

	fun int _calcPatternLength() {
		_lastStep - _firstStep + 1 => _patternLength;
		return _patternLength;
	}

	fun int firstStep() { return _firstStep; }
	fun int firstStep(int step) {
		Utility.clampi(step, 0, _lastStep) => _firstStep;
		_calcPatternLength();
		return _firstStep;
	}

	fun int lastStep() { return _lastStep; } 
	fun int lastStep(int step) {
		Utility.clampi(step, _firstStep, 
			_numberOfSteps - 1) => _lastStep;
		_calcPatternLength();
		return _lastStep;
	}

}

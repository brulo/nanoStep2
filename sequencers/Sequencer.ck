// Sequencer base class to extend from
// by Bruce Lott, 2013-2015

public class Sequencer {
	Clock clock;
	Shred clockShred;
	int _numberOfSteps, _currentStep, _previousStep, _patternLength;
	int _firstStep, _lastStep; // controls pattern length 

	fun void _init(Clock theClock) {
		theClock @=> clock;

		0  => _currentStep => _previousStep;
		64 => _numberOfSteps;
		0 => _firstStep;
		7 => _lastStep;
		_calcPatternLength();

		spork ~ clockLoop() @=> clockShred;
	}  

	fun void clockLoop() { 
		while(clock.step => now) {
			_currentStep => _previousStep;
			((clock.currentStep % _numberOfSteps) + _firstStep) % _patternLength => _currentStep;
			doStep();
		}
	}

	fun void doStep() {  
		// what happens when arriving at a new step.
		// override this in child class     
	}

	// * Get Only Properties *

	fun int numberOfSteps() { return _numberOfSteps; }

	fun int currentStep() { return _currentStep; }

	fun int patternLength() { return _patternLength; } 

	// * Get and Set Properties *

	// set the first step of the pattern
	fun int firstStep() { return _firstStep; }
	fun int firstStep(int step) {
		Utility.clampi(step, 0, _lastStep) => _firstStep;
		_calcPatternLength();
		return _firstStep;
	}

	// set the last step of the pattern
	fun int lastStep() { return _lastStep; } 
	fun int lastStep(int step) {
		Utility.clampi(step, _firstStep, 
			_numberOfSteps - 1) => _lastStep;
		_calcPatternLength();
		return _lastStep;
	}

	// * Utility Functions *

	// calc pattern length from first and last step
	fun int _calcPatternLength() {
		_lastStep - _firstStep + 1 => _patternLength;
		return _patternLength;
	}

}

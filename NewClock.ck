public class Clock {
    int _stepsPerBeat, _isPlaying, _currentStep;
		int _numSteps;
    float _bpm, _swingAmount;
    dur _stepDur, _swingDur, _spb; 
    time _lastStep;
		Event step; 
		20 => float MIN_BPM;
		999 => float MAX_BPM;

    fun void init() {
        4 => _stepsPerBeat;
        128 => _numSteps;
        bpm(120.0);
        stepsPerBeat(4);  // 16th notes
				spork ~ _mainLoop();
        play(1);
    }

    fun void _mainLoop() {
        while(true) {
            if(_isPlaying) _advance();
        }
    }

    fun void _advance() {
        if(_currentStep % 2 == 0) { 
            if(now - _lastStep >= _stepDur + _swingDur) {
							_broadcastStep();
						}
        }
        else {
            if(now - _lastStep >= _stepDur - _swingDur) {
							_broadcastStep();
						}
        }
        samp => now;
    }

    fun void _broadcastStep() { 
        now => _lastStep;
				(_currentStep + 1) % _numSteps => _currentStep;
				step.broadcast();
    }

    fun int isPlaying() { return _isPlaying; } 
    fun int play() { return _isPlaying; } 
    fun int play(int newState) {
        if(newState) {  // start playing/re-cue
            now => _lastStep; 
            0 => _currentStep;
            1 => _isPlaying;
        }
        else 0 => _isPlaying;  // stop
        return _isPlaying;
		}

    fun float bpm() { return _bpm; } 
    fun float bpm(float newBpm) {
				Utility.clamp(newBpm, MIN_BPM, MAX_BPM) => _bpm;
        60.0::second / _bpm => _spb;
        stepsPerBeat(_stepsPerBeat);  // update PPB
        return _bpm;
    }

    fun float addToBpm(float amount) {
			amount + _bpm => float newBpm;
			Utility.clamp(newBpm, MIN_BPM, MAX_BPM) => newBpm;
			return bpm(newBpm); 
		}

    fun float swingAmount() { return _swingAmount; }
    fun float swingAmount(float amount) {
			Utility.clamp(amount, 0.0, 1.0) => _swingAmount;
      _stepDur * _swingAmount => _swingDur;
			return _swingAmount;
    }    

    fun int stepsPerBeat() { return _stepsPerBeat; }
    fun int stepsPerBeat(int ppb) {
        if(ppb > 0) {
            ppb => _stepsPerBeat;
            _spb / _stepsPerBeat => _stepDur;
            swingAmount(_swingAmount);
        }
        return _stepsPerBeat;
    }

		fun int currentStep() { return _currentStep; }
}

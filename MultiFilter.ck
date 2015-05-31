public class MultiFilter extends Chubgraph {
  FilterBasic _filters[4];
  LPF lp @=> _filters[0];
  BPF bp @=> _filters[1];
  HPF hp @=> _filters[2];
  ResonZ rez @=> _filters[3];
  int _currentFilter;
  float _freq, _Q;
	UGen _lfoFreqModSource, _envFreqModSource;
	0.0 => float _lfoFreqModAmount;
	0.0 => float _envFreqModAmount;
	1.0 => float MIN_Q;
  2.0 => float MAX_Q;
  10.0 => float MIN_FREQ; 
  12070.0 => float MAX_FREQ;
  5000.0 => float MAX_MOD_FREQ; 

  fun void init() {
    filter(0);
    freq(MAX_FREQ);
    Q(1.0);
    spork ~ _paramLoop();
  }

	fun UGen lfoFreqModSource(UGen source) {
		source => blackhole;
		source @=> _lfoFreqModSource;
		return _lfoFreqModSource;;
	}

	fun UGen envFreqModSource(UGen source) {
		source => blackhole;
		source @=> _envFreqModSource;
		return _envFreqModSource;;
	}

	fun float lfoFreqModAmount(float val) {
		Utility.clamp(val, 0.0, 1.0) => _lfoFreqModAmount;
		return _lfoFreqModAmount;
	}

	fun float envFreqModAmount(float val) {
		Utility.clamp(val, 0.0, 1.0) => _envFreqModAmount;
		return _envFreqModAmount;
	}

  fun int filter() { return _currentFilter; }
  fun int filter(int filt) {
    inlet =< _filters[_currentFilter];
    _filters[_currentFilter] =< outlet;
    Utility.clampi(filt, 0, _filters.cap()) => _currentFilter;	
    inlet => _filters[_currentFilter];
    _filters[_currentFilter] => outlet; 
    return _currentFilter;
  }

  fun float freq() { return _freq; }
  fun float freq(float val) {
    Utility.clamp(val, MIN_FREQ, MAX_FREQ) => _freq;  
    return _freq;
  }

  fun float Q() { return _Q; }
  fun float Q(float val) {
    Utility.clamp(val, MIN_Q, MAX_Q) => _Q; 
    return _Q;
  }

  fun void _paramLoop() { 
    while(samp => now) { 
			float lfoFreqRatio, envFreqRatio;  // 0 - 1 amount of MAX_MOD_FREQ to use
			// remap -1 - 1 to 0 - 1, then scale by our amount parameter
			((_lfoFreqModSource.last() + 1) * 0.5) * _lfoFreqModAmount => lfoFreqRatio;
			// already 0 - 1, just scale
			_envFreqModSource.last() * _envFreqModAmount => envFreqRatio;

			// calc current freq value of mods
			lfoFreqRatio * MAX_MOD_FREQ => float lfoFreqMod;
			envFreqRatio * MAX_MOD_FREQ => float envFreqMod;

      _filters[_currentFilter].freq(_freq + lfoFreqMod + envFreqMod);
      _filters[_currentFilter].Q(_Q);
    }
  } 
}

public class MultiFilter extends Chubgraph {
  FilterBasic _filters[4];
  LPF lp @=> _filters[0];
  BPF bp @=> _filters[1];
  HPF hp @=> _filters[2];
  ResonZ rez @=> _filters[3];
	ModSource freqLfo, freqEnv, freqPitch;
  int _currentFilter;
  float _freq, _Q;
	1.0 => float MIN_Q;
  2.0 => float MAX_Q;
  10.0 => float MIN_FREQ; 
  12070.0 => float MAX_FREQ;

  fun void init() {
		0.0 => freqEnv.sourceMin;
		0.0 => freqPitch.sourceMin;
		20000.0 => freqPitch.sourceMax;
		freqPitch.sourceMax * 2 => freqPitch.maxValue;
		1 => freqPitch.isPitchTracking;
		0 => freqPitch.isExponential;
		10000 => freqEnv.maxValue => freqLfo.maxValue;
    filter(0);
    freq(MAX_FREQ);
    Q(1.0);
    spork ~ _paramLoop();
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
      _filters[_currentFilter].freq(_freq + freqLfo.value() + freqEnv.value() + freqPitch.value());
      _filters[_currentFilter].Q(_Q);
    }
  } 
}

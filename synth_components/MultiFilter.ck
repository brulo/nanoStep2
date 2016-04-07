public class MultiFilter extends Chubgraph {
  FilterBasic _filters[4];
  LPF lp @=> _filters[0];
  BPF bp @=> _filters[1];
  HPF hp @=> _filters[2];
  ResonZ rez @=> _filters[3];
	ModSource freqLfo, freqEnv, freqPitch;
  int _currentFilter;
  float _freq, _Q;
	1.0 => float minQ;
  2.0 => float maxQ;
  10.0 => float minFreq; 
  12070.0 => float maxFreq;

  fun void init() {
		0.0 => freqEnv.sourceMin;
		0 => freqEnv.isCentered;
		0.0 => freqPitch.sourceMin;
		20000.0 => freqPitch.sourceMax;
		0 => freqPitch.isCentered;
		freqPitch.sourceMax * 2 => freqPitch.maxValue;
		1 => freqPitch.isPitchTracking;
		10000 => freqEnv.maxValue => freqLfo.maxValue;
    filter(0);
    freq(maxFreq);
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
    Utility.clamp(val, 0.0, 1.0) => _freq; 
    return _freq;
  }

  fun float Q() { return _Q; }
  fun float Q(float val) {
    Utility.clamp(val, 0.0, 1.0) => _Q; 
    return _Q;
  }

  fun void _paramLoop() { 
    while(samp => now) { 
			Utility.remap(_freq, 0.0, 1.0, minFreq, maxFreq) => float theFreq;
			Utility.clamp(theFreq + freqLfo.value() + freqEnv.value() + freqPitch.value(),
					5.0, 24000.0) => float freqSum;
      _filters[_currentFilter].freq(freqSum);
			_filters[_currentFilter].Q(Utility.remap(_Q, 0.0, 1.0, minQ, maxQ));
    }
  } 
}

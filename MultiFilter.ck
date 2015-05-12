public class MultiFilter extends Chubgraph {
  FilterBasic _filters[4];
  LPF lp @=> _filters[0];
  BPF bp @=> _filters[1];
  HPF hp @=> _filters[2];
  ResonZ rez @=> _filters[3];
  int _currentFilter;
  float _freq, _Q;
  UGen _freqMods[0];
	30.0 => float _minFreq; 
	1598 => float _maxFreq;

  /* PUBLIC */

  fun void init() {
    filter(0);
    freq(1.0);
    Q(0.0);
    spork ~ _paramLoop();
  }

  fun void addFreqMod(UGen mod) {
    _freqMods << mod;    
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

  /* PRIVATE */
  
  fun void _paramLoop() { 
    while(samp => now) { 
      _filters[_currentFilter].Q(_Q * 11 + 1);
      0 => float freqModSum;
      for(0 => int i; i < _freqMods.cap(); i++) {
        _freqMods[i].last() +=> freqModSum;  
			}
      _filters[_currentFilter].freq(Utility.clamp(_freq + freqModSum, 0, 1) * _maxFreq + _minFreq);
    }
  } 
}

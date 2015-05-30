public class MultiFilter extends Chubgraph {
  FilterBasic _filters[4];
  LPF lp @=> _filters[0];
  BPF bp @=> _filters[1];
  HPF hp @=> _filters[2];
  ResonZ rez @=> _filters[3];
  int _currentFilter;
  float _freq, _Q;
  UGen _freqMods[2];
  5.0 => float MAX_Q;
  30.0 => float MIN_FREQ; 
  15070.0 => float MAX_FREQ;
  5000.0 => float MOD_MAX_FREQ; 

  fun void init() {
    filter(0);
    freq(1.0);
    Q(0.0);
    spork ~ _paramLoop();
  }

  fun void setFreqMod(UGen mod, int idx) {
    Utility.clampi(idx, 0, _freqMod.cap()) => int clampedIdx;
    mod @=> _freqMod[clampedIdx];
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
      0 => float freqModSum;
      for(0 => int i; i < _freqMods.cap(); i++) {
	// convert -1.0 - 1.0 to 0.0 - 1.0, then add to sum
	(_freqMods[i].last() + 1) * 0.5 +=> freqModSum;
      }
      // scale sum to 0.0 - 1.0
      freqModSum * (1.0 / _freqMods.cap()) => freqModAmount;
      freqModAmount * MOD_MAX_FREQ => float modFreq;

      (_freq * MAX_FREQ) + MIN_FREQ => float baseFreq;

      _filters[_currentFilter].freq(baseFreq + modFreq);
      _filters[_currentFilter].Q(_Q * 4 + 1);
    }
  } 
}

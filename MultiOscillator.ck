public class MultiOscillator extends Chubgraph {
  Osc _waveforms[4];
  SawOsc _saw @=> _waveforms["saw"];
  SqrOsc _sqr @=> _waveforms["sqr"];
  TriOsc _tri @=> _waveforms["tri"];
  SinOsc _sin @=> _waveforms["sin"];
  ["saw", "sqr", "tri", "sin"] @=> string _waveformNames[];
  string _currentWaveform;

  // MIDI note, tuning modifiers, and the resultant freq.
  float _note, _coarseTune, _fineTune, _freq;

  /* PUBLIC */  
  fun void init() {
    waveform("saw");
    note(36);
    gain(0.25);
  }

  fun float note() { return _note; }
  fun float note(float val) { 
    Utility.clamp(val, 0, 127) => _note;
    _updateFreq();
    return _note;
  }

  fun float coarseTune() { return _coarseTune; }
  fun float coarseTune(float val) { 
    // 2 major 5ths 
    Utility.clamp(val, 0, 1) * 14 - 7 => _coarseTune;
    _updateFreq();
    return _coarseTune;
  } 

  fun float fineTune() { return _fineTune; }
  fun float fineTune(float val) {
    Utility.clamp(val, 0, 1) * 2 - 1 => _fineTune;
    _updateFreq();
    return _fineTune;
  }

  fun string waveform() { return _currentWaveform; }
  fun string waveform(string wf) {
    if(_isWaveformName(wf)) {
      if(_isWaveformName(_currentWaveform))
        _waveforms[_currentWaveform] =< outlet;	
      wf => _currentWaveform;
      _waveforms[_currentWaveform] => outlet; 
      _updateFreq();
      return _currentWaveform;
    }
    else return "Not a valid waveform";
  }


  /* PRIVATE */
  fun void _updateFreq() {
    _note + _coarseTune + _fineTune => _freq;
    _waveforms[_currentWaveform].freq(Std.mtof(_freq));
  }

  fun int _isWaveformName(string wf) {
    for(0 => int i; i < _waveformNames.cap(); i++){
      if(wf == _waveformNames[i])
        return 1;
    }
    return 0;
  }

}

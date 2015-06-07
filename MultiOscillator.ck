public class MultiOscillator extends Chubgraph {
  Osc _waveforms[4];
  SawOsc _saw @=> _waveforms[0];
  SqrOsc _sqr @=> _waveforms[1];
  TriOsc _tri @=> _waveforms[2];
  SinOsc _sin @=> _waveforms[3];
  int _currentWaveform;
  // MIDI note, tuning modifiers, and the resultant freq.
  float _note, _coarseTune, _fineTune;
	ModSource freqLfo, freqEnv;

  fun void init() {
		0.0 => freqEnv.sourceMin;
		0 => freqEnv.isCentered;
		100 => freqEnv.maxValue => freqLfo.maxValue;
    waveform(0);
    note(36);
    gain(0.25);
    spork ~ _paramLoop();
  }

  fun float note() { return _note; }
  fun float note(float input) { 
    Utility.clamp(input, 0.0, 127.0) => _note;
    return _note;
  }

  fun float coarseTune() { return _coarseTune; }
  fun float coarseTune(float input) { 
    // 2 major 5ths 
    Utility.clamp(input, 0.0, 1.0) * 14 - 7 => _coarseTune;
    return _coarseTune;
  } 

  fun float fineTune() { return _fineTune; }
  fun float fineTune(float input) {
    Utility.clamp(input, 0.0, 1.0) * 2 - 1 => _fineTune;
    return _fineTune;
  }

	fun int waveform() { return _currentWaveform; }
  fun int waveform(int wf) {
    _waveforms[_currentWaveform] =< outlet;	
		Utility.clampi(wf, 0, _waveforms.cap()) => _currentWaveform;
    _waveforms[_currentWaveform] => outlet; 
		return _currentWaveform;
	}

  fun void _paramLoop() { 
		float _freq;
    while(samp => now) { 
      Utility.clamp(_note + _coarseTune + _fineTune, 0.0, 127.0) => _freq;
			freqLfo.value() + freqEnv.value() +=> _freq;
			Utility.clamp(_freq, 0.0, 18000.0) => _freq;
      _waveforms[_currentWaveform].freq(Std.mtof(_freq));
    }
  } 
}

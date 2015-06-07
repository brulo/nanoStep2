public class Lfo extends Chubgraph {
  Osc _waveforms[4];
  SawOsc _saw @=> _waveforms[0];
  SqrOsc _sqr @=> _waveforms[1];
  TriOsc _tri @=> _waveforms[2];
  SinOsc _sin @=> _waveforms[3];
  int _currentWaveform;
  float _freq;
	30.0 => float MAX_FREQ;
	0.001 => float MIN_FREQ;

  fun void init() {
    waveform(0);
  } 

  fun int waveform() { return _currentWaveform; }
  fun int waveform(int wf) {
    _waveforms[_currentWaveform] =< outlet;	
		Utility.clampi(wf, 0, _waveforms.cap()) => _currentWaveform;
    _waveforms[_currentWaveform] => outlet; 
		return _currentWaveform;
	}
  
  fun float freq() { return _freq; }
  fun float freq(float val) {
    Utility.clamp(val, 0.0, 1.0) => _freq;
    _waveforms[_currentWaveform].freq(_freq * MAX_FREQ + MIN_FREQ);
    return _freq;
  }
}

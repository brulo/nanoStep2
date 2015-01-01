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

  // GUI
  MAUI_Slider coarseTuneSlider, fineTuneSlider;
  [coarseTuneSlider, fineTuneSlider] @=> MAUI_Slider sliders[];

  
  /* PUBLIC */  
  fun void init() {
    waveform("saw");
    note(36);
    gain(0.25);
  }

  fun void initGUI(MAUI_View view, int xOffset, int yOffset) {
    for(0 => int i; i < sliders.cap(); i++) {
      sliders[i].range(0.0, 1.0);
      sliders[i].value(0.5);
      view.addElement(sliders[i]);
    } 
    coarseTuneSlider.name("Coarse Tune");
    fineTuneSlider.name("Fine Tune");
    coarseTuneSlider.position(xOffset, yOffset);
    fineTuneSlider.position(xOffset, yOffset + 100);

    spork ~ _guiLoop();
  }

  fun float note() { return _note; }
  fun float note(float input) { 
    Utility.clamp(input, 0, 127) => _note;
    _updateFreq();
    return _note;
  }

  fun float coarseTune() { return _coarseTune; }
  fun float coarseTune(float input) { 
    // 2 major 5ths 
    Utility.clamp(input, 0, 1) * 14 - 7 => _coarseTune;
    _updateFreq();
    return _coarseTune;
  } 

  fun float fineTune() { return _fineTune; }
  fun float fineTune(float input) {
    Utility.clamp(input, 0, 1) * 2 - 1 => _fineTune;
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

  // poll slider values to set parameters
  fun void _guiLoop() {
    while(1::samp => now) { 
      fineTune(fineTuneSlider.value());
      coarseTune(coarseTuneSlider.value());
    }
  }
}

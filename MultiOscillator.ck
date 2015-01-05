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
  MAUI_Button sawButton, sqrButton, triButton, sinButton;
  [sawButton, sqrButton, triButton, sinButton] @=> MAUI_Button buttons[];
  TitleBar titleBar;

  /* PUBLIC */  
  fun void init() {
    waveform("saw");
    note(36);
    gain(0.25);
  }

  fun void initGUI(MAUI_View view, string titleName, int x, int y) {
    for(0 => int i; i < sliders.cap(); i++) {
      sliders[i].range(0.0, 1.0);
      sliders[i].value(0.5);
      view.addElement(sliders[i]);
    } 
    titleBar.init(x, y, 
                  titleName, 90,
                  5, 9);                  
    titleBar.addElementsToView(view);
    x => int xOffset;
    60 => int titleBarOffset;
    y + titleBarOffset => int yOffset;
    for(0 => int i; i < buttons.cap(); i++) {
      buttons[i].toggleType();
      buttons[i].state(0);
      buttons[i].position(xOffset + i*50, yOffset);
      view.addElement(buttons[i]);
    }
    sawButton.state(1);
    coarseTuneSlider.name("Coarse Tune");
    fineTuneSlider.name("Fine Tune");
    coarseTuneSlider.position(xOffset, yOffset + 75);
    fineTuneSlider.position(xOffset, yOffset + 125);

    _sporkGUIShreds();
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

  fun void _waveformButtonLoop(MAUI_Button button, string waveName) {
    button.name(waveName);
    while(button => now)
      if(button.state() == 1) {
        _toggleButtonsOff();
        button.state(1);
        waveform(waveName);
      }
  }

  fun void _toggleButtonsOff() {
    for(0 => int i; i < buttons.cap(); i++)
      buttons[i].state(0);   
  }

  fun void _fineTuneSliderLoop() {
    while(fineTuneSlider => now)
      fineTune(fineTuneSlider.value()); 
  }

  fun void _coarseTuneSliderLoop() {
    while(coarseTuneSlider => now)
      coarseTune(coarseTuneSlider.value());
  }

  fun void _sporkGUIShreds() {
    spork ~ _coarseTuneSliderLoop();
    spork ~ _fineTuneSliderLoop();
    spork ~ _waveformButtonLoop(sawButton, "saw");
    spork ~ _waveformButtonLoop(sqrButton, "sqr");
    spork ~ _waveformButtonLoop(sinButton, "sin");
    spork ~ _waveformButtonLoop(triButton, "tri");
  }
}

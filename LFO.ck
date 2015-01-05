public class LFO extends Chubgraph {
  Osc _waveforms[4];
  SawOsc _saw @=> _waveforms["saw"];
  SqrOsc _sqr @=> _waveforms["sqr"];
  TriOsc _tri @=> _waveforms["tri"];
  SinOsc _sin @=> _waveforms["sin"];
  ["saw", "sqr", "tri", "sin"] @=> string _waveformNames[];
  string _currentWaveform;
  float _freq;
  
  // GUI
  MAUI_Slider freqSlider, gainSlider;
  [freqSlider, gainSlider] @=> MAUI_Slider sliders[];
  MAUI_Button sawButton, sqrButton, triButton, sinButton;
  [sawButton, sqrButton, triButton, sinButton] @=> MAUI_Button buttons[];
  TitleBar titleBar;

  /* PUBLIC */
  fun void init() {
    waveform("sin");
    gain(0.5); 
  } 

  fun void initGUI(MAUI_View view, string titleName, int x, int y) {
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
    sinButton.state(1);
    freqSlider.name("Freq");
    gainSlider.name("Gain");
    freqSlider.position(xOffset, yOffset + 75);
    gainSlider.position(xOffset, yOffset + 125);

    _sporkGUIShreds();
  }

  fun void initGUI(MAUI_View view, int xOffset, int yOffset) {
    initGUI(view, xOffset, yOffset, "LFO", 103);
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
  
  fun float freq() { return _freq; }
  fun float freq(float val) {
    Utility.clamp(val, 0, 1) => _freq;
    _updateFreq();
    return _freq;
  }

  /* PRIVATE */
  fun int _isWaveformName(string wf) {
    for(0 => int i; i < _waveformNames.cap(); i++){
      if(wf == _waveformNames[i])
        return 1;
    }
    return 0;
  }

  fun void _updateFreq() {
    _waveforms[_currentWaveform].freq(_freq*100 + 0.01);
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
  
  fun void _gainSliderLoop() {
    while(gainSlider => now) {
      gain(gainSlider.value());
    }
  }

  fun void _freqSliderLoop() {
    while(freqSlider => now)
      freq(freqSlider.value());
  }

  fun void _sporkGUIShreds() {
    spork ~ _freqSliderLoop();
    spork ~ _gainSliderLoop();
    spork ~ _waveformButtonLoop(sawButton, "saw");
    spork ~ _waveformButtonLoop(sqrButton, "sqr");
    spork ~ _waveformButtonLoop(sinButton, "sin");
    spork ~ _waveformButtonLoop(triButton, "tri");
  }
}

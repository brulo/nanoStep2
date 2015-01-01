public class MultiFilter extends Chubgraph {
  FilterBasic _filters[4];
  LPF lp @=> _filters["lp"];
  BPF bp @=> _filters["bp"];
  HPF hp @=> _filters["hp"];
  ResonZ rez @=> _filters["rez"];
  ["lp", "bp", "hp", "rez"] @=> string _filterNames[];
  string _currentFilter;
  float _freq, _Q;

  // GUI
  MAUI_Slider freqSlider, QSlider;
  [freqSlider, QSlider] @=> MAUI_Slider sliders[];


  /* PUBLIC */
  fun void init() {
    filter("lp");
    freq(1.0);
    Q(0);
  }

  fun void initGUI(MAUI_View view, int xOffset, int yOffset) {
    for(0 => int i; i < sliders.cap(); i++) {
      sliders[i].range(0.0, 1.0);
      view.addElement(sliders[i]);
    } 
    freqSlider.name("Cutoff Frequency");
    freqSlider.value(1.0);
    QSlider.name("Q");
    QSlider.value(0.0);
    freqSlider.position(xOffset, yOffset);
    QSlider.position(xOffset, yOffset + 100);

    spork ~ _guiLoop();
  }

  fun string filter() { return _currentFilter; }
  fun string filter(string name) {
    if(_isFilterName(name)) {
      if(_isFilterName(_currentFilter)) {
        inlet =<_filters[_currentFilter];
        _filters[_currentFilter] =< outlet;
      }
      name => _currentFilter;
      inlet => _filters[_currentFilter];
      _filters[_currentFilter] => outlet; 
      _updateQ();
      _updateFreq();
      return _currentFilter;
    }
    else return "Not a valid waveform";
  }

  fun float freq() { return _freq; }
  fun float freq(float val) {
    Utility.clamp(val, 0, 1)*15980 + 30 => _freq;  
    _updateFreq();
    return _freq;
  }

  fun float Q() { return _Q; }
  fun float Q(float val) {
    Utility.clamp(val, 0, 1)*11 + 1 => _Q; 
    _updateQ();
    return _Q;
  }

  /* PRIVATE */
  fun void _updateFreq() {
    _filters[_currentFilter].freq(_freq);
  }

  fun void _updateQ() {
    _filters[_currentFilter].Q(_Q);
  }
  
  fun int _isFilterName(string name) {
    for(0 => int i; i < _filterNames.cap(); i++) {
      if(name == _filterNames[i])
        return 1;
    }
    return 0;
  }

  // poll slider values to set parameters
  fun void _guiLoop() {
    while(1::samp => now) { 
      freq(freqSlider.value());
      Q(QSlider.value());
    }
  }
}

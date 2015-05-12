public class LFO extends Chubgraph {
	Lfo lfo;
  MAUI_Slider freqSlider, gainSlider;
  [freqSlider, gainSlider] @=> MAUI_Slider sliders[];
  MAUI_Button sawButton, sqrButton, triButton, sinButton;
  [sawButton, sqrButton, triButton, sinButton] @=> MAUI_Button buttons[];
  TitleBar titleBar;

  /* PUBLIC */
  fun void init(MAUI_View view, string titleName, int x, int y) {
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
      buttons[i].size(90, 68);
      view.addElement(buttons[i]);
    }
    sinButton.state(1);
    freqSlider.name("Freq");
    gainSlider.name("Gain");
    freqSlider.position(xOffset, yOffset + 45);
    gainSlider.position(xOffset, yOffset + 95);
    view.addElement(freqSlider);
    view.addElement(gainSlider);

    spork ~ _freqSliderLoop();
    spork ~ _gainSliderLoop();
    spork ~ _waveformButtonLoop(sawButton, "saw");
    spork ~ _waveformButtonLoop(sqrButton, "sqr");
    spork ~ _waveformButtonLoop(sinButton, "sin");
    spork ~ _waveformButtonLoop(triButton, "tri");
  }

  fun void _waveformButtonLoop(MAUI_Button button, string waveName) {
    button.name(waveName);
    while(button => now)
      if(button.state() == 1) {
        _toggleButtonsOff();
        button.state(1);
        lfo.waveform(waveName);
      }
  }

  fun void _toggleButtonsOff() {
    for(0 => int i; i < buttons.cap(); i++)
      buttons[i].state(0);   
  }
  
  fun void _gainSliderLoop() {
    while(gainSlider => now) {
      lfo.gain(gainSlider.value());
    }
  }

  fun void _freqSliderLoop() {
    while(freqSlider => now)
      lfo.freq(freqSlider.value());
  }
}

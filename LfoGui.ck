public class LfoGui {
	Lfo lfo;
  MAUI_Slider freqSlider;
  MAUI_Button sawButton, sqrButton, triButton, sinButton;
  [sawButton, sqrButton, triButton, sinButton] @=> MAUI_Button buttons[];
	MAUI_Text titleText;

  /* PUBLIC */
  fun void init(Lfo theLfo, MAUI_View view, string titleName, int x, int y) {
		theLfo @=> lfo;

		// title
		titleText.name("LFO");
		titleText.position(x + 95, y);
		view.addElement(titleText);

    60 => int titleOffset;
    y + titleOffset => int yOffset;
    x => int xOffset;

		// buttons
    for(0 => int i; i < buttons.cap(); i++) {
      buttons[i].toggleType();
      buttons[i].state(0);
      buttons[i].position(xOffset + i*50, yOffset);
      buttons[i].size(90, 68);
      view.addElement(buttons[i]);
    }
    sawButton.state(1);

		// slider
    freqSlider.name("Freq");
    freqSlider.position(xOffset, yOffset + 45);
    view.addElement(freqSlider);

    spork ~ _sliderLoop();
    spork ~ _waveformButtonLoop(sawButton, "saw", 0);
    spork ~ _waveformButtonLoop(sqrButton, "sqr", 1);
    spork ~ _waveformButtonLoop(sinButton, "sin", 2);
    spork ~ _waveformButtonLoop(triButton, "tri", 3);
  }

  fun void _waveformButtonLoop(MAUI_Button button, string waveName, int waveIdx) {
    button.name(waveName);
    while(button => now) {
      if(button.state() == 1 && waveIdx != lfo.waveform()) {
			for(0 => int i; i < buttons.cap(); i++) {
				buttons[i].state(0);   
			}
        lfo.waveform(waveIdx);
      }
      button.state(1);
		}
  }

  fun void _sliderLoop() {
    while(samp => now)
      lfo.freq(freqSlider.value());
  }
}

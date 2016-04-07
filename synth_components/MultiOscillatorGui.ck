public class MultiOscillatorGui extends Chubgraph {
	MultiOscillator multiOsc;
  // GUI
  MAUI_Slider coarseTuneSlider, fineTuneSlider, lfoAmountSlider, envAmountSlider;
  [coarseTuneSlider, fineTuneSlider, 
		lfoAmountSlider, envAmountSlider] @=> MAUI_Slider sliders[];
  MAUI_Button sawButton, sqrButton, triButton, sinButton;
  [sawButton, sqrButton, triButton, sinButton] @=> MAUI_Button buttons[];
	MAUI_Text titleText;

  fun void init(MultiOscillator mOsc, MAUI_View view, int x, int y) {
		mOsc @=> multiOsc;
    for(0 => int i; i < sliders.cap(); i++) {
      sliders[i].range(0.0, 1.0);
      sliders[i].value(0.5);
      view.addElement(sliders[i]);
    } 
		lfoAmountSlider.value(0.0);
		envAmountSlider.value(0.0);
		// title
		titleText.name("MULTI OSC");
		titleText.position(x+90, y);
		view.addElement(titleText);
    x => int xOffset;
    45 => int titleBarOffset;
    y + titleBarOffset => int yOffset;
    for(0 => int i; i < buttons.cap(); i++) {
      buttons[i].toggleType();
      buttons[i].state(0);
      buttons[i].position(xOffset + i*50, yOffset);
      buttons[i].size(90, 68);
      view.addElement(buttons[i]);
    }
    sawButton.state(1);
    coarseTuneSlider.name("Coarse Tune");
    fineTuneSlider.name("Fine Tune");
		lfoAmountSlider.name("Lfo Amount");
		envAmountSlider.name("Env Amount");
    coarseTuneSlider.position(xOffset, yOffset + 45);
    fineTuneSlider.position(xOffset, yOffset + 95);
    lfoAmountSlider.position(xOffset, yOffset + 145);
    envAmountSlider.position(xOffset, yOffset + 195);

    spork ~ _sliderLoop();
    spork ~ _waveformButtonLoop(sawButton, "saw", 0);
    spork ~ _waveformButtonLoop(sqrButton, "sqr", 1);
    spork ~ _waveformButtonLoop(sinButton, "tri", 2);
    spork ~ _waveformButtonLoop(triButton, "sin", 3);
  }

  fun void _waveformButtonLoop(MAUI_Button button, string waveName, int waveIdx) {
    button.name(waveName);
    while(button => now) {
      if(button.state() == 1 && waveIdx != multiOsc.waveform()) {
				for(0 => int i; i < buttons.cap(); i++) {
					buttons[i].state(0);   
				}
        multiOsc.waveform(waveIdx);
      }
      button.state(1);
		}
  }

  fun void _sliderLoop() {
    while(samp => now) {
      multiOsc.fineTune(fineTuneSlider.value()); 
      multiOsc.coarseTune(coarseTuneSlider.value());
      multiOsc.freqLfo.amount(lfoAmountSlider.value());
      multiOsc.freqEnv.amount(envAmountSlider.value());
		}
  }
}

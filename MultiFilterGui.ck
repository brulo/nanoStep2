public class MultiFilterGui {
	MultiFilter multiFilter;
  MAUI_Slider freqSlider, QSlider;
  [freqSlider, QSlider] @=> MAUI_Slider sliders[];
	MAUI_Button lpButton, bpButton, hpButton, rzButton;
	[lpButton, bpButton, hpButton, rzButton] @=> MAUI_Button buttons[];
	MAUI_Text titleText;

  /* PUBLIC */

  fun void init(MultiFilter mFilt, MAUI_View view, int x, int y) {
		mFilt @=> multiFilter;

		// title 
		titleText.name("FILTER");
		titleText.position(x+95, y);
		view.addElement(titleText);

    45 => int titleBarOffset;
    y + titleBarOffset => int yOffset;
    x => int xOffset;

		// buttons
    for(0 => int i; i < buttons.cap(); i++) {
      buttons[i].toggleType();
      buttons[i].state(0);
      buttons[i].position(xOffset + i*50, yOffset);
      buttons[i].size(90, 68);
      view.addElement(buttons[i]);
    }
		lpButton.state(1);

		// sliders
    for(0 => int i; i < sliders.cap(); i++) {
      sliders[i].range(0.0, 1.0);
      view.addElement(sliders[i]);
    } 
    freqSlider.name("Cutoff Freq");
    freqSlider.value(1.0);
    QSlider.name("Q");
    QSlider.value(0.0);
    freqSlider.position(xOffset, yOffset + 50 );
    QSlider.position(xOffset, yOffset + 100);

   spork ~ _typeButtonLoop(lpButton, "LP", 0);
   spork ~ _typeButtonLoop(bpButton, "BP", 1);
   spork ~ _typeButtonLoop(hpButton, "HP", 2);
   spork ~ _typeButtonLoop(rzButton, "Rez", 3);
   spork ~ _guiLoop();
  }

  /* PRIVATE */
  fun void _typeButtonLoop(MAUI_Button button, string filtName, int filtIdx) {
    button.name(filtName);
    while(button => now) {
      if(button.state() == 1) {
				for(0 => int i; i < buttons.cap(); i++) {
					buttons[i].state(0);   
				}
        button.state(1);
        multiFilter.filter(filtIdx);
      }
		}
  }

  fun void _guiLoop() {
    while(samp => now) { 
      multiFilter.freq(freqSlider.value());
      multiFilter.Q(QSlider.value());
    }
  }
}

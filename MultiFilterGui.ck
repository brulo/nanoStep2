public class MultiFilterGui {
	MultiFilter multiFilter;
  MAUI_Slider freqSlider, QSlider;
  [freqSlider, QSlider] @=> MAUI_Slider sliders[];
	MAUI_Text titleText;

  /* PUBLIC */

  fun void init(MultiFilter mFilt, MAUI_View view, int x, int y) {
		mFilt @=> multiFilter;
		titleText.name("FILTER");
		titleText.position(x+95, y);
		view.addElement(titleText);

    x => int xOffset;
    45 => int titleBarOffset;
    y + titleBarOffset => int yOffset;
    for(0 => int i; i < sliders.cap(); i++) {
      sliders[i].range(0.0, 1.0);
      view.addElement(sliders[i]);
    } 
    freqSlider.name("Cutoff Freq");
    freqSlider.value(1.0);
    QSlider.name("Q");
    QSlider.value(0.0);
    freqSlider.position(xOffset, yOffset);
    QSlider.position(xOffset, yOffset + 50);

    spork ~ _guiLoop();
  }

  /* PRIVATE */

  fun void _guiLoop() {
    while(samp => now) { 
      multiFilter.freq(freqSlider.value());
      multiFilter.Q(QSlider.value());
    }
  }
}

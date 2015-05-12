public class MultiFilterGui {
	MultiFilter multiFilter;
  MAUI_Slider freqSlider, QSlider;
  [freqSlider, QSlider] @=> MAUI_Slider sliders[];
  TitleBar titleBar;


  /* PUBLIC */
  fun void init(MultiFilter mFilt, MAUI_View view, string titleName, int x, int y) {
		mFilt @=> multiFilter;
    titleBar.init(x, y, 
                  titleName, 90,
                  5, 9);                  
    titleBar.addElementsToView(view);
    x => int xOffset;
    60 => int titleBarOffset;
    y + titleBarOffset => int yOffset;
    for(0 => int i; i < sliders.cap(); i++) {
      sliders[i].range(0.0, 1.0);
      view.addElement(sliders[i]);
    } 
    freqSlider.name("Cutoff Frequency");
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

public class MultiFilterGui {
	MultiFilter multiFilter;
	MAUI_Slider freqSlider, QSlider, lfoModSlider; 
	MAUI_Slider envModSlider, pitchModSlider;
	[freqSlider, QSlider, lfoModSlider, 
		envModSlider, pitchModSlider] @=> MAUI_Slider sliders[];

	MAUI_Button lpButton, bpButton, hpButton, rzButton;
	[lpButton, bpButton, hpButton, rzButton] @=> MAUI_Button buttons[];
	MAUI_Text titleText;

	fun void init(MultiFilter mFilt, MAUI_View view, int x, int y) {
		mFilt @=> multiFilter;

		// title 
		titleText.name("FILTER");
		titleText.position(x + 95, y);
		view.addElement(titleText);
		 
		45 => int titleOffset;
		y + titleOffset => int yOffset;
		x => int xOffset;

		// buttons
		for(0 => int i; i < buttons.cap(); i++) {
			buttons[i].toggleType();
			buttons[i].state(0);
			buttons[i].position(xOffset + (i * 50), yOffset);
			buttons[i].size(90, 68);
			view.addElement(buttons[i]);
		}
		lpButton.state(1);

		// sliders
		for(0 => int i; i < sliders.cap(); i++) {
			sliders[i].range(0.0, 1.0);
			sliders[i].value(0.0);
			sliders[i].position(xOffset, yOffset + 50 + (i * 50));
			view.addElement(sliders[i]);
		}
		freqSlider.name("Cutoff Freq");
		QSlider.name("Q");
		lfoModSlider.name("Lfo Freq Mod");
		envModSlider.name("Env Freq Mod");
		pitchModSlider.name("Pitch Tracking Freq Mod");

		spork ~ _typeButtonLoop(lpButton, "LP", 0);
		spork ~ _typeButtonLoop(bpButton, "BP", 1);
		spork ~ _typeButtonLoop(hpButton, "HP", 2);
		spork ~ _typeButtonLoop(rzButton, "Rez", 3);
		spork ~ _sliderLoop();
	}

	fun void _typeButtonLoop(MAUI_Button button, string filtName, int filtIdx) {
		button.name(filtName);
		while(button => now) {
			if(button.state() == 1 && multiFilter.filter() != filtIdx) {
				for(0 => int i; i < buttons.cap(); i++) {
					buttons[i].state(0);   
				}
				multiFilter.filter(filtIdx);
			}
			button.state(1);
		}
	}

	fun void _sliderLoop() {
		while(samp => now) { 
			multiFilter.freq(freqSlider.value());
			multiFilter.Q(QSlider.value());
			multiFilter.freqLfo.amount((lfoModSlider.value()));
			multiFilter.freqEnv.amount((envModSlider.value()));
			multiFilter.freqPitch.amount((pitchModSlider.value()));
		}
	}
}

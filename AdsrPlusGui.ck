public class AdsrPlusGui {
	AdsrPlus adsrPlus;
	MAUI_Slider attackSlider, decaySlider, sustainSlider, releaseSlider;
	[attackSlider, decaySlider, sustainSlider, releaseSlider] @=> MAUI_Slider sliders[];
	MAUI_LED keyLED;
	MAUI_Text titleText;

	fun void init(AdsrPlus aPlus, MAUI_View view, int x, int y) {
		aPlus @=> adsrPlus;
		/* titleBar.init(x, y, */ 
		/*               titleName, 90, */
		/*               5, 9); */                  
		/* titleBar.addElementsToView(view); */
		titleText.name("ADSR");
		titleText.position(100+x, y);
		view.addElement(titleText);
		x => int xOffset;
		45 => int titleBarOffset;
		y + titleBarOffset => int yOffset;
		for(0 => int i; i < sliders.cap(); i++) {
			sliders[i].range(0.0, 1.0);
			sliders[i].value(0.5);
			sliders[i].position(xOffset, yOffset + i*50);
			view.addElement(sliders[i]);
		} 
		keyLED.position(xOffset, yOffset+200);
		keyLED.color(1);
		view.addElement(keyLED);
		attackSlider.name("Attack");
		decaySlider.name("Decay");
		sustainSlider.name("Sustain");
		releaseSlider.name("Release");
		/* attackSlider.position(xOffset, yOffset); */
		/* decaySlider.position(xOffset, yOffset + 50); */
		/* sustainSlider.position(xOffset, yOffset + 100); */
		/* releaseSlider.position(xOffset, yOffset + 150); */

		spork ~ _attackSliderLoop();
		spork ~ _decaySliderLoop();
		spork ~ _sustainSliderLoop();
		spork ~ _releaseSliderLoop();
		spork ~ _keyLedLoop();
	}

	fun void _keyLedLoop() {
		while(10::ms => now) {
			if(adsrPlus.keyPosition) {
				keyLED.light();
			}
			else {
				keyLED.unlight();
			}
		}
	}

	fun void _attackSliderLoop() {
		while(attackSlider => now)
			adsrPlus.attackTime(attackSlider.value());
	}

	fun void _decaySliderLoop() {
		while(decaySlider => now)
			adsrPlus.decayTime(decaySlider.value());
	}

	fun void _sustainSliderLoop() {
		while(sustainSlider => now)
			adsrPlus.sustainLevel(sustainSlider.value());
	}

	fun void _releaseSliderLoop() {
		while(releaseSlider => now)
			adsrPlus.releaseTime(releaseSlider.value());
	}
}

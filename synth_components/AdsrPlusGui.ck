public class AdsrPlusGui {
	AdsrPlus adsrPlus;
	MAUI_Slider attackSlider, decaySlider, sustainSlider, releaseSlider;
	[attackSlider, decaySlider, sustainSlider, releaseSlider] @=> MAUI_Slider sliders[];
	MAUI_LED keyLED;
	MAUI_Text titleText;

	fun void init(AdsrPlus aPlus, MAUI_View view, int x, int y) {
		aPlus @=> adsrPlus;
		// title
		titleText.name("ADSR");
		titleText.position(100+x, y);
		view.addElement(titleText);
		
		45 => int titleBarOffset;
		x => int xOffset;
		y + titleBarOffset => int yOffset;

		// sliders
		for(0 => int i; i < sliders.cap(); i++) {
			sliders[i].range(0.0, 1.0);
			sliders[i].value(0.5);
			sliders[i].position(xOffset, yOffset + i*50);
			view.addElement(sliders[i]);
		} 
		attackSlider.name("Attack");
		decaySlider.name("Decay");
		sustainSlider.name("Sustain");
		releaseSlider.name("Release");
		
		// led
		keyLED.position(xOffset, yOffset+200);
		keyLED.color(1);
		view.addElement(keyLED);

		spork ~ _sliderLoop();
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

	fun void _sliderLoop() {
		while(samp => now) {
			adsrPlus.attackTime(attackSlider.value());
			adsrPlus.decayTime(decaySlider.value());
			adsrPlus.sustainLevel(sustainSlider.value());
			adsrPlus.releaseTime(releaseSlider.value());
		}
	}
}

public class MidiClockGui {
	MAUI_Slider swingSlider;
	MAUI_LED stepLed;
	MidiClock clock;

	fun void init(MidiClock theClock, MAUI_View view) {
		theClock @=> clock;

		stepLed.color(1);
		stepLed.position(0, 0);
		view.addElement(stepLed);

		swingSlider.name("Swing");
		swingSlider.range(0.0, 0.5);
		swingSlider.position(0, 50);
		swingSlider.value(0.0);
		view.addElement(swingSlider);
		
		spork ~ _swingSliderLoop();
		spork ~ _stepLedLoop();
	}

	fun void _stepLedLoop() {
		while(clock.step => now) {
			if(clock.currentStep % 2 == 0) {
				stepLed.light();
			}
			else {
				stepLed.unlight();
			}
		}
	}

	fun void _swingSliderLoop() {
		while(samp => now) {
			clock.swingAmount(swingSlider.value());
		}
	}
}

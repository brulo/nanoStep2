public class InternalClockGui {
	MAUI_Button onButton;
	MAUI_Slider bpmSlider, swingSlider;
	MAUI_LED stepLed;
	InternalClock clock;

	fun void init(InternalClock theClock, MAUI_View view) {
		theClock @=> clock;

		onButton.name("On");
		onButton.toggleType();
		onButton.state(0);
		onButton.size(75, 75);
		view.addElement(onButton);

		stepLed.color(1);
		stepLed.position(180, 7);
		view.addElement(stepLed);

		bpmSlider.name("BPM");
		bpmSlider.range(20.0, 200.0);
		bpmSlider.position(0, 50);
		view.addElement(bpmSlider);

		swingSlider.name("Swing");
		swingSlider.range(0.0, 0.5);
		swingSlider.position(0, 100);
		swingSlider.value(0.0);
		view.addElement(swingSlider);

		
		spork ~ _sliderLoop();
		spork ~ _onButtonLoop();
		spork ~ _stepLedLoop();
	}

	fun void _onButtonLoop() {
		while(onButton => now) {
			if(onButton.state() == 1) {
				clock.start();
			}
			else {
				clock.stop();
				stepLed.unlight();
			}
		}
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

	fun void _sliderLoop() {
		while(samp => now) {
			clock.bpm(bpmSlider.value());
			clock.swingAmount(swingSlider.value());
		}
	}
}

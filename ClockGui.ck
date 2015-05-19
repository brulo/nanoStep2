public class ClockGui {
	MAUI_Button playButton;
	MAUI_Slider bpmSlider, swingSlider;
	Clock clock;

	fun void init(Clock theClock, MAUI_View view) {
		theClock @=> clock;

		playButton.name("Play");
		playButton.toggleType();
		playButton.state(1);
		playButton.size(75, 75);

		bpmSlider.name("BPM");
		bpmSlider.range(80.0, 200.0);
		bpmSlider.position(0, 50);

		swingSlider.name("Swing");
		swingSlider.range(0.0, 0.5);
		swingSlider.position(0, 100);
		swingSlider.value(0.0);

		view.addElement(playButton);
		view.addElement(bpmSlider);
		view.addElement(swingSlider);

		spork ~ _sliderLoop();
		spork ~ _playButtonLoop();
	}

	fun void _sliderLoop() {
		while(samp => now) {
			clock.bpm(bpmSlider.value());
			clock.swingAmount(swingSlider.value());
		}
	}

	fun void _playButtonLoop() {
		while(playButton => now) {
			clock.play(playButton.state());
		}
	}
}

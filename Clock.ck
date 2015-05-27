public class Clock {
	0 => int isPlaying;
	-1 => int currentStep;
	0 => float _swingAmount;  // 0.0-1.0 amount of a step
	Event step;
	time lastStepTime;

	fun void init() { }  // define in inheriting class

	fun void start() {
		1 => isPlaying;
		-1 => currentStep;
		now => lastStepTime;
	}

	fun void stop() {
		0 => isPlaying;
	}

	fun void _broadcastStep(int isSwung) {
		currentStep++;
		if(isSwung) {
			(now - lastStepTime) * _swingAmount => now;
		}
		step.broadcast();
		now => lastStepTime;
	}

	fun float swingAmount() { return _swingAmount; }
	fun float swingAmount(float amount) {
		Utility.clamp(amount, 0.0, 0.5) => _swingAmount;
		return _swingAmount;
	}
}

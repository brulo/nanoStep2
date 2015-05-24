public class MidiClock {
	MidiIn min;
	0 => int isPlaying;
	-1 => int pulseCount;
	int ppq;  // pulses per quarter note 
	int pps; // pulses per steps
	-1 => int currentStep;
	0.0 => float _swingAmount;  // amount of a 16th
	Event step, start, cont, stop;
	time lastStepTime;

	fun void init(string minName) {
		min.open(minName);
		chout <= "Clock listening to midi port: " <= min.name() <= IO.nl();
		24 => ppq;
		ppq / 4 => pps;
		spork ~ _main();
	}

	fun void _main() { 
		MidiMsg msg;
		while(min => now) {
			while(min.recv(msg)) {
				if(msg.data1 == 0xF8) {  // clock pulse
					pulseCount++;
					if(pulseCount % pps == 0) {
						currentStep++;
						if(pulseCount % (pps * 2)  == 0) {
							step.broadcast();
							now => lastStepTime;
						}
						else {
							spork ~ _swingStep();
						}
					}
				}
				else if(msg.data1 == 0xFA) {  // start
					1 => isPlaying;
					start.broadcast();
				}
				else if(msg.data1 == 0xFB) {  // continue
					1 => isPlaying;
					cont.broadcast();
				}
				else if(msg.data1 == 0xFC) {  // stop
					0 => isPlaying;
					-1 => pulseCount;
					-1 => currentStep;
					stop.broadcast();
				}
			}
		}
	}

	fun void _swingStep() {
		(now - lastStepTime) * _swingAmount => now;
		step.broadcast();
		now => lastStepTime;
	}

	fun float swingAmount() { return _swingAmount; }
	fun float swingAmount(float amount) {
		Utility.clamp(amount, 0.0, 0.5) => _swingAmount;
		return _swingAmount;
	}
}

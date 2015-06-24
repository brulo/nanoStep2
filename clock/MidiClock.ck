// converts MIDI clock in into a ChucK ClocK
public class MidiClock extends Clock {
	MidiIn min;
	-1 => int pulseCount;
	int ppq;  // pulses per quarter note 
	int pps; // pulses per steps

	fun void init(string minName) {
		swingAmount(0.2);
		if(min.open(minName)) 
			<<<"Clock listening to", min.name()>>>;
		else 
			<<<"Clock couldn't open", minName>>>;
		24 => ppq;
		ppq / 4 => pps; // 16ths
		spork ~ _main();
	}

	fun void _main() { 
		MidiMsg msg;
		while(min => now) {
			while(min.recv(msg)) {
				if(msg.data1 == 0xF8) {  // clock pulse
					pulseCount++;
					if(pulseCount % pps == 0) {
						if(pulseCount % (pps * 2)  == 0) {
							spork ~ _broadcastStep(0);  // not swung
						}
						else {
							spork ~ _broadcastStep(1);  // swung
						}
					}
				}
				else if(msg.data1 == 0xFA) {  // start
					-1 => pulseCount;
					start();
				}
				else if(msg.data1 == 0xFC) {  // stop
					stop();
				}
			}
		}
	}
}

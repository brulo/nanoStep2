LividBase base;
InternalClock clock;
PitchSequencer sequencer;
MidiOut midiOut;
Metronome metro;
if(midiOut.open("IAC Driver Bus 1")) 
<<<midiOut.name(), "successfully opened for sequencer output">>>;

base.init();
clock.init();
clock.start();
clock.bpm(125);
sequencer.init(clock, midiOut);
/* metro.init(clock); */

MidiMsg msg;
while(base.midiIn => now) {
	while(base.midiIn.recv(msg)) {
		if(msg.data3 > 0) {
			if(base.isFader(msg) > -1) {
				if(base.isFader(msg) < 8) {
					sequencer.pitch(base.isFader(msg), 
							Utility.remap(msg.data3, 0, 127, 0, 7));
				}
				else
					sequencer.stepLength(Utility.remap(msg.data3, 0, 127, 0, 1));
			}
			else if(base.isPad(msg) > -1) {
				base.getPadCoordinate(msg) @=> int pad[];
				pad[0] => int x;
				pad[1] => int y;
				if(y == 3) {  // top row
					if(sequencer.trigger(x) > 0.0) {
						sequencer.trigger(x, 0.0);
						base.setPadLed(x, y, "off");
					}
					else {
						sequencer.trigger(x, 1.0);
						base.setPadLed(x, y, "red");
					}
				}
				else if(y == 2) { 
					if(sequencer.tie(x)) {
						sequencer.tie(x, 0);
						base.setPadLed(x, y, "off");
					}
					else {
						sequencer.tie(x, 1);
						base.setPadLed(x, y, "green");
					}
				}
				else if(y == 1) { 
					if(sequencer.accent(x)) {
						sequencer.accent(x, 0);
						base.setPadLed(x, y, "off");
					}
					else {
						sequencer.accent(x, 1);
						base.setPadLed(x, y, "blue");
					}
				}
			}
		}
	}
}

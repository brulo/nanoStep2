LividBase base;
InternalClock clock;
PitchSequencer sequencer;

base.init();
clock.init();
clock.start();
sequencer.init(clock);

MidiMsg msg;
while(base.midiIn => now) {
	while(base.midiIn.recv(msg)) {
		if(msg.data3 > 0) {
			if(base.isPad(msg)) {
				base.getPadCoordinate(msg) @=> int pad[];
				pad[0] => int x;
				pad[1] => int y;
				if(y == 3) {  // top row
					if(sequencer.trigger(x) > 0.0)
						sequencer.trigger(pad[0], 0.0);
					else 
						sequencer.trigger(pad[0], 1.0);
				}
			}
		}
	}
}

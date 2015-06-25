LividBase base;
base.init();
0.2::second => dur timeStep;

MidiMsg msg;
while(base.midiIn => now) {
	while(base.midiIn.recv(msg)) {
		<<<msg>>>;
		if(base.isFader(msg))
			<<<"fader:", base.isFader(msg), "-", msg.data3>>>;

		if(base.isPad(msg))
			<<<"pad:", base.isPad(msg), "-", msg.data3>>>;

		if(base.isButton(msg))
			<<<"button:", base.isButton(msg), "-", msg.data3>>>;

		if(base.isTouchButton(msg))
			<<<"touch button:", base.isTouchButton(msg), "-", msg.data3>>>;
	}
}

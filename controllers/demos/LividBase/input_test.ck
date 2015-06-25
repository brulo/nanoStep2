LividBase base;
base.init();
0.2::second => dur timeStep;

MidiMsg msg;
while(base.midiIn => now) {
	while(base.midiIn.recv(msg)) {
		if(base.isFader(msg) > -1)
			<<<"fader:", base.isFader(msg), "-", msg.data3>>>;

		if(base.isPad(msg) > -1)
			<<<"pad:", base.isPad(msg), "-", msg.data3>>>;

		if(base.isButton(msg) > -1)
			<<<"button:", base.isButton(msg), "-", msg.data3>>>;

		if(base.isTouchButton(msg) > -1)
			<<<"touch button:", base.isTouchButton(msg), "-", msg.data3>>>;
	}
}

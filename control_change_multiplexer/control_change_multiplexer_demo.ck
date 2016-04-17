ControlChangeMultiplexer controlChangeMultiplexer;
MidiIn midiIn;
MidiOut midiOut;
0 => int midiOutChannel;
NanoKontrol2 nanoKontrol2;
int controlChanges[nanoKontrol2.knobs.cap()];

for( 0 => int i; i < nanoKontrol2.knobs.cap(); i++ ) {
	nanoKontrol2.knobs[i] => controlChanges[i];
}

midiIn.open( "drumKONTROL1 SLIDER/KNOB" );
midiOut.open( "IAC Driver IAC Bus 1" );

controlChangeMultiplexer.init( controlChanges, midiIn, midiOut, midiOutChannel );

while(true) {
	for( int i; i < 2; i++)
	{
		<<<"now on channel", i>>>;
		controlChangeMultiplexer.changePage(i);
		2::second => now;
	}
}
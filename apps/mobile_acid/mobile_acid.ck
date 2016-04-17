InternalClockGui internalClockGui;
LividPitch lividPitch;
AudioUnit phoscyon => dac;
AudioUnit drumazon => dac;
DrumSequencerAu drumSequencer;
NanoDrum nanoDrum;
MidiIn nanoMidiIn, nanoMidiIn2, iacMidiIn, launchControlMidiIn;
MidiOut nanoMidiOut, iacMidiOut;
ControlChangeToAuRouter ccAuRouter;
ControlChangeToAuRouter ccAuRouter2;
ControlChangeMultiplexer ccMultiplexer;
NanoKontrol2 nanoKontrol2;
MidiIn xxxmin;

internalClockGui.init();
initMidi();
initAudioUnits();
initNanoDrum();
initNanoDrumMultiplexer();
spork ~ mapDrumSelectButtonsToCCMultiplexer();
lividPitch.init( internalClockGui.clock, phoscyon );

while(samp => now);

// * Init Functions * 

fun void initMidi() {
	if ( nanoMidiIn.open( "drumKONTROL1 SLIDER/KNOB" ) )
		<<< "1" >>>;
	if ( nanoMidiIn2.open( "drumKONTROL1 SLIDER/KNOB" ) )
		<<<"2">>>;
	if(nanoMidiOut.open( "drumKONTROL1 CTRL" ))
		<<<"3">>>;
	if(iacMidiIn.open( "IAC Driver IAC Bus 1" ))
		<<<"4">>>;
	if(iacMidiOut.open( "IAC Driver IAC Bus 1" ) ) 
		<<<5>>>;
	if( launchControlMidiIn.open( "Launch Control" ) )
		<<<6>>>;
}

fun void initAudioUnits() {
	// probe audio units
	AudioUnit.list() @=> string aus[];
	for(int i; i < aus.cap(); i++) {
	    chout <= aus[i] <= IO.newline();
	}

	drumazon.open( "Drumazon" );
	drumazon.display();

	phoscyon.open( "Phoscyon" );
	phoscyon.display();
}

fun void initNanoDrum() {
	drumSequencer.init( internalClockGui.clock, drumazon );
	nanoDrum.init( drumSequencer, nanoMidiIn2, nanoMidiOut );
}

fun void initNanoDrumMultiplexer() {
	int controlChanges[nanoKontrol2.knobs.cap()];
	for( 0 => int i; i < nanoKontrol2.knobs.cap(); i++ ) {
		nanoKontrol2.knobs[i] => controlChanges[i];
	}
	0 => int multiplerChannelOut;
	ccMultiplexer.init( controlChanges, nanoMidiIn, iacMidiOut, multiplerChannelOut );
	ccAuRouter.init( drumazon, iacMidiIn );
	ccAuRouter2.init( phoscyon, launchControlMidiIn );
}

fun void mapDrumSelectButtonsToCCMultiplexer() {
	MidiIn min;
	MidiMsg msg;

	min.open("drumKONTROL1 SLIDER/KNOB");
	while( min => now ) {
		while( min.recv(msg) ) {
			if( nanoKontrol2.isFader(msg.data2) ) {
				64 +=> msg.data2;
				iacMidiOut.send( msg );
			}
			else if( msg.data3 == 127 ) {
				if( nanoKontrol2.isChannelButton(msg.data2) ) {
					if( nanoKontrol2.channelButtonRow(msg.data2) == 0 ) {
						nanoKontrol2.channelButtonColumn( msg.data2 ) => int column;
						<<<"changing drum multiplexer to drum num", column >>>;
						ccMultiplexer.changePage( column );
					}
				}
			}
		}
	}
}
// custom stuff
InternalClockGui internalClockGui;
LividPitch lividPitch;
NanoDrum nanoDrum;
DrumSequencerAu drumSequencer;
// ugens
Dyno limiter => dac;
limiter.limit();

JCRev reverb => limiter;
reverb.mix( 1 );

FeedbackDelay delay => limiter;

AudioUnit phoscyon => limiter;
phoscyon => Gain phoscyonReverbBus => reverb;
phoscyonReverbBus.gain( 0 );
phoscyon => Gain phoscyonDelayBus => delay;
phoscyonDelayBus.gain( 0 );

AudioUnit drumazon => limiter;
drumazon => Gain drumazonReverbBus => reverb;
drumazonReverbBus.gain( 0 );
drumazon => Gain drumazonDelayBus => delay;
drumazonDelayBus.gain( 0 );

// midi 
MidiIn nanoMidiIn, nanoMidiIn2, iacMidiIn, launchControlMidiIn;
MidiOut nanoMidiOut, iacMidiOut;
ControlChangeToAuRouter ccAuRouter;
ControlChangeToAuRouter ccAuRouter2;
ControlChangeMultiplexer ccMultiplexer;
NanoKontrol2 nanoKontrol2;
internalClockGui.init();
initMidi();
initAudioUnits();
initNanoDrum();
initNanoDrumMultiplexer();
spork ~ drumKontrol1Loop();
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
		<<<"5">>>;
	if( launchControlMidiIn.open( "Launch Control" ) )
		<<<"6">>>;
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
	spork ~ launchControlLoop();
}

fun void drumKontrol1Loop() {
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

fun void launchControlLoop() {
	MidiIn min;
	MidiMsg msg;

	if( min.open("Launch Control") )
		<<<"opened launch control for loop">>>;

	while( min => now ) {
		while( min.recv(msg) ) {
			<<< msg.data1, msg.data2, msg.data3 >>>;
			//25
			if( msg.data2 == 26 ) {
				phoscyonDelayBus.gain( Utility.remap(msg.data3, 0, 126, 0, 1) );
			}
			else if( msg.data2 == 27 ) {
				phoscyonReverbBus.gain( Utility.remap(msg.data3, 0, 126, 0, 1) );
			}
		}
	}
}

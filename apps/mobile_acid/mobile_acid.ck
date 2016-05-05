// custom stuff
InternalClockGui internalClockGui;
LividPitch lividPitch;
NanoKontrol2 nanoKontrol2;
NanoDrum nanoDrum;
DrumSequencerAu drumSequencer;
LaunchControl launchControl;

// ugens
Dyno limiter => dac;
limiter.limit();

NRev reverb => limiter;
reverb.mix( 1 );

FeedbackDelay delay => limiter;

AudioUnit phoscyon => limiter;
phoscyon => Gain phoscyonReverbBus => reverb;
phoscyonReverbBus.gain( 0 );
phoscyon => Gain phoscyonDelayBus => delay;
phoscyonDelayBus.gain( 0 );

AudioUnit phoscyon2 => limiter;
phoscyon2 => Gain phoscyon2ReverbBus => reverb;
phoscyon2ReverbBus.gain( 0 );
phoscyon2 => Gain phoscyon2DelayBus => delay;
phoscyon2DelayBus.gain( 0 );

AudioUnit drumazon => limiter;
drumazon => Gain drumazonReverbBus => reverb;
drumazonReverbBus.gain( 0 );
drumazon => Gain drumazonDelayBus => delay;
drumazonDelayBus.gain( 0 );

AudioUnit lush => limiter;
lush => Gain lushReverbBus => reverb;
lushReverbBus.gain( 0 );
lush => Gain lushDelayBus => delay;
lushDelayBus.gain( 0 );

// midi 
"drumKONTROL1 SLIDER/KNOB" => string nanoMidiInName;
"IAC Driver IAC Bus 1" => string iacMidiInName;
"IAC Driver IAC Bus 2" => string iacMidiIn2Name;
"Launch Control" => string launchControlMidiInName;
MidiOut nanoMidiOut, iacMidiOut, iacMidiOut2, launchControlMidiOut;

ControlChangeToAuRouter ccAuRouter, ccAuRouter2, ccAuRouter3, ccAuRouter4;
ControlChangeMultiplexer ccMultiplexer, ccMultiplexer2;

// initialize
internalClockGui.init();
internalClockGui.bpmSlider.value(135);
internalClockGui.clock.start();
internalClockGui.onButton.state(1);
initMidi();
initAudioUnits();
initNanoDrum();
initNanoDrumMultiplexer();
spork ~ drumKontrol1Loop();

while(samp => now);


// * Init Functions * 

fun void initMidi() {
	if(nanoMidiOut.open( "drumKONTROL1 CTRL" )) {
		//<<< "MobileAcid: opened midiout device", nanoMidiOut.name, "successfully" >>>;
	}
	if( launchControlMidiOut.open( "Launch Control" ) ) {
		//<<< "MobileAcid: opened midiout device", launchControlMidiOut.name, "successfully" >>>;
	}
	if(iacMidiOut.open( "IAC Driver IAC Bus 1" ) ) {
		//<<< "MobileAcid: opened midiout device", iacMidiOut.name, "successfully" >>>;
	}
	if(iacMidiOut2.open( "IAC Driver IAC Bus 2" ) ) {
		//<<< "MobileAcid: opened midiout device", iacMidiOut2.name, "successfully" >>>;
	}

	launchControl.clearAllLeds( launchControlMidiOut );
	Utility.midiOut( 0x90, launchControl.buttons[0], 1, launchControlMidiOut );
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

	phoscyon2.open( "Phoscyon" );
	phoscyon2.display();
	
	lush.open( "LuSH-101" );
	lush.display();

	lividPitch.init();
	lividPitch.sequencers[0].___init( internalClockGui.clock, phoscyon );
	lividPitch.sequencers[1].___init( internalClockGui.clock, phoscyon2 );
	lividPitch.sequencers[2].___init( internalClockGui.clock, lush );
}

fun void initNanoDrum() {
	drumSequencer.init( internalClockGui.clock, drumazon );
	nanoDrum.init( drumSequencer, nanoMidiInName, nanoMidiOut );
}

fun void initNanoDrumMultiplexer() {
	int controlChanges[5];
	for( 0 => int i; i < 5; i++ ) {
		nanoKontrol2.knobs[i] => controlChanges[i];
	}
	0 => int multiplerChannelOut;
	ccMultiplexer.init( controlChanges, nanoMidiInName, iacMidiOut, multiplerChannelOut );
	ccAuRouter.init( drumazon, iacMidiInName );

	int controlChanges2[launchControl.knobs.cap()];
	for( int i; i < launchControl.knobs.cap(); i++ ) {
		launchControl.knobs[i] => controlChanges2[i];
	}
	ccMultiplexer2.init( controlChanges2, launchControlMidiInName, iacMidiOut2, multiplerChannelOut );
	ccAuRouter2.init( phoscyon, iacMidiIn2Name );
	ccAuRouter3.init( phoscyon2, iacMidiIn2Name );
	ccAuRouter3.init( lush, iacMidiIn2Name );

	spork ~ launchControlPageSelectLoop();
	spork ~ launchControlIacLoop();
	spork ~ nanoKontrolLoop();
}

fun void drumKontrol1Loop() {
	MidiIn min;
	MidiMsg msg;

	min.open( nanoMidiInName );
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
						//<<<"changing drum multiplexer to drum num", column >>>;
						ccMultiplexer.changePage( column );
					}
				}
			}
		}
	}
}

fun void nanoKontrolLoop() {
	MidiIn min;
	MidiMsg msg;

	min.open( "drumKONTROL1 SLIDER/KNOB" );

	while( min => now ) {
		while( min.recv(msg) ) {
			if( msg.data1 == 0xB0 ) {
				if( nanoKontrol2.knobIndex(msg.data2) == 5 ) {
					drumazonDelayBus.gain( Utility.remap(msg.data3, 0, 127, 0, 1) );
				}
				else if( nanoKontrol2.knobIndex(msg.data2) == 6) {
					drumazonReverbBus.gain( Utility.remap(msg.data3, 0, 127, 0, 1) );
				}
			}
		}
	}
}

fun void launchControlIacLoop() {
	MidiIn min;
	MidiMsg msg;

	min.open( iacMidiIn2Name );

	while( min => now ) {
		while( min.recv(msg) ) {
			if( msg.data1 == 0xB0 ) {
				if( msg.data2 == 5 ) {
					phoscyonDelayBus.gain( Utility.remap(msg.data3, 0, 127, 0, 1) );
				}
				else if( msg.data2 == 6 ) {
					phoscyonReverbBus.gain( Utility.remap(msg.data3, 0, 127, 0, 1) );
				}
			}
		}
	}
}

fun void launchControlPageSelectLoop() {
	MidiIn min;
	MidiMsg msg;

	min.open( launchControlMidiInName );

	while( min => now ) {
		while( min.recv(msg) ) {
			if( msg.data1 >= 0x90 && msg.data1 < 0x9F ) {
				if( launchControl.isButton(msg) ) {
					launchControl.buttonIndex(msg) => int buttonIndex;
					// velocity of 1 is red
					Utility.midiOut(msg.data1, launchControl.buttons[ccMultiplexer2.currentPage], 0, launchControlMidiOut);
					ccMultiplexer2.changePage( buttonIndex );
					Utility.midiOut(msg.data1, launchControl.buttons[buttonIndex], 1, launchControlMidiOut);
				}
			}
		}
	}

}

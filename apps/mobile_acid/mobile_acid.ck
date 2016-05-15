// mobile acid techno jambox software
// March 2016

InternalClockGui internalClockGui;
LividPitch lividPitch;
NanoKontrol2 nanoKontrol2;
NanoDrum nanoDrum;
DrumSequencerAu drumSequencer;
LaunchControl launchControl;
ControlChangeToAuRouter ccAuRouter, ccAuRouter2, ccAuRouter3, ccAuRouter4;
ControlChangeMultiplexer ccMultiplexer, ccMultiplexer2;

// midi 
"drumKONTROL1 SLIDER/KNOB" => string nanoMidiInName;
"IAC Driver IAC Bus 1" => string iacMidiInName;
"IAC Driver IAC Bus 2" => string iacMidiIn2Name;
"Launch Control" => string launchControlMidiInName;
MidiOut nanoMidiOut, iacMidiOut, iacMidiOut2, launchControlMidiOut;

// ugens
Dyno limiter => dac;
limiter.limit();

NRev reverb => limiter;
reverb.mix( 1 );

//FeedbackDelay delay => limiter;

AudioUnit phoscyon => limiter;
phoscyon => Gain phoscyonReverbBus => reverb;
phoscyonReverbBus.gain( 0 );
//phoscyon => Gain phoscyonDelayBus => delay;
//phoscyonDelayBus.gain( 0 );

AudioUnit phoscyon2 => limiter;
phoscyon2 => Gain phoscyon2ReverbBus => reverb;
phoscyon2ReverbBus.gain( 0 );
//phoscyon2 => Gain phoscyon2DelayBus => delay;
//phoscyon2DelayBus.gain( 0 );

AudioUnit drumazon => Gain drumazonBus => limiter;
drumazonBus => Gain drumazonReverbBus => reverb;
drumazonReverbBus.gain( 0 );
//drumazon => Gain drumazonDelayBus => delay;
//drumazonDelayBus.gain( 0 );

AudioUnit lush => limiter;
lush => Gain lushReverbBus => reverb;
lushReverbBus.gain( 0 );
//lush => Gain lushDelayBus => delay;
//lushDelayBus.gain( 0 );

main();
while( 1::week => now );

fun void main() {
	probeAudioUnits();
	initClock();
	initMidi();
	initLividPitch();
	initNanoDrum();
	initNanoDrumMultiplexer();

	spork ~ launchControlPageSelectLoop();
	spork ~ launchControlIacLoop();

}

fun void probeAudioUnits() {
	AudioUnit.list() @=> string aus[];
	for(int i; i < aus.cap(); i++) {
	    chout <= aus[i] <= IO.newline();
	}
}

fun void initClock() {
	internalClockGui.init();
	internalClockGui.bpmSlider.value(135);
	internalClockGui.clock.start();
	internalClockGui.onButton.state(1);
}

fun void initMidi() {
	nanoMidiOut.open( "drumKONTROL1 CTRL" );
	launchControlMidiOut.open( "Launch Control" );
	iacMidiOut.open( "IAC Driver IAC Bus 1" );
	iacMidiOut2.open( "IAC Driver IAC Bus 2" );

	Utility.midiOut( 0x90, launchControl.buttons[0], 1, launchControlMidiOut );
}

fun void initLividPitch() {
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

	lividPitch.sequencers[1].octave( 5 );

	launchControl.clearAllLeds( launchControlMidiOut );
}


fun void initNanoDrum() {
	drumSequencer.init( internalClockGui.clock, drumazon );
	nanoDrum.init( drumSequencer, nanoMidiInName, nanoMidiOut );

	drumazon.open( "Drumazon" );
	drumazon.display();

	int controlChanges[5];
	for( 0 => int i; i < 5; i++ ) {
		nanoKontrol2.knobs[i] => controlChanges[i];
	}
	0 => int multiplerChannelOut;
														// midi chan out
	ccMultiplexer.init( controlChanges, nanoMidiInName, iacMidiOut, 0 );
	ccAuRouter.init( drumazon, iacMidiInName );

	spork ~ nanoKontrolLoop();
}

fun void initNanoDrumMultiplexer() {

	int controlChanges2[launchControl.knobs.cap()];
	for( int i; i < launchControl.knobs.cap(); i++ ) {
		launchControl.knobs[i] => controlChanges2[i];
	}
																   // midi chan out
	ccMultiplexer2.init( controlChanges2, launchControlMidiInName, iacMidiOut2, 0 );
	ccAuRouter2.init( phoscyon, iacMidiIn2Name );
	ccAuRouter3.init( phoscyon2, iacMidiIn2Name );
	ccAuRouter4.init( lush, iacMidiIn2Name );

}

fun void nanoKontrolLoop() {
	MidiIn min;
	MidiMsg msg;
	min.open( nanoMidiInName );

	while( min => now ) {
		while( min.recv(msg) ) {
			if( nanoKontrol2.isFader(msg.data2) ) {
				64 +=> msg.data2;
				iacMidiOut.send( msg );
			}
			else if( nanoKontrol2.isKnob(msg.data2) ) {
				/*	
				if( nanoKontrol2.knobIndex(msg.data2) == 5 ) {
					drumazonDelayBus.gain( Utility.remap(msg.data3, 0, 127, 0, 1) );
				}
				*/
				if( nanoKontrol2.knobIndex(msg.data2) == 6) {
					drumazonReverbBus.gain( Utility.remap(msg.data3, 0, 127, 0, 0.5) );
				}
				else if( nanoKontrol2.knobIndex(msg.data2) == 7) {
					drumazonBus.gain( Utility.remap(msg.data3, 0, 127, 0, 1) );
				}
			}
			else if( nanoKontrol2.isChannelButton(msg.data2) ) {
				if( msg.data3 == 127 ) {
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

fun void launchControlIacLoop() {
	MidiIn min;
	MidiMsg msg;
	min.open( iacMidiIn2Name );

	while( min => now ) {
		while( min.recv(msg) ) {
			if( launchControl.isKnob(msg) ) {
				if( msg.data2 == 5 ) {
					//phoscyonDelayBus.gain( Utility.remap(msg.data3, 0, 127, 0, 1) );
					lividPitch.sequencers[0].stepLength( Utility.remap(msg.data3, 0, 127, 0.1, 1) );
				}
				else if( msg.data2 == 6 ) {
					phoscyonReverbBus.gain( Utility.remap(msg.data3, 0, 127, 0, 0.5) );
				}
				else if( msg.data2 == 13 ) {
					lividPitch.sequencers[1].stepLength( Utility.remap(msg.data3, 0, 127, 0.1, 1) );
				}
				else if( msg.data2 == 14 ) {
					phoscyon2ReverbBus.gain( Utility.remap(msg.data3, 0, 127, 0, 0.5) );
				}
				else if( msg.data2 == 21 ) {
					lividPitch.sequencers[2].stepLength( Utility.remap(msg.data3, 0, 127, 0.1, 1) );
				}
				else if( msg.data2 == 22 ) {
					lushReverbBus.gain( Utility.remap(msg.data3, 0, 127, 0, 0.5) );
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

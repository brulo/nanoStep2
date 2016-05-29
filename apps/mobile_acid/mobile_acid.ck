// mobile acid techno jambox software
// March 2016

InternalClock clock;
//MidiClock clock;
LividPitch lividPitch;
NanoKontrol2 nanoKontrol2;
NanoDrum nanoDrum;
DrumSequencerAu drumSequencer;
LaunchControl launchControl;
ControlChangeToAuRouter ccAuRouter, ccAuRouter2, ccAuRouter3, ccAuRouter4;
ControlChangeMultiplexer ccMultiplexer, ccMultiplexer2;
AudioUnitDisplayer audioUnitDisplayer;

// midi 
"drumKONTROL1 SLIDER/KNOB" => string nanoMidiInName;
"IAC Driver IAC Bus 1" => string iacMidiInName;
"IAC Driver IAC Bus 2" => string iacMidiIn2Name;
"Launch Control" => string launchControlMidiInName;
MidiOut nanoMidiOut, iacMidiOut, iacMidiOut2, launchControlMidiOut;
0.75 => float MAX_REVERB_GAIN;
0.5 => float MAX_DELAY_GAIN;

// ugens

HPF reverb => dac.chan( 1 );
reverb.freq( 400 );

HPF delayHpf => FeedbackDelay delay => dac.chan( 0 );
delayHpf.freq( 300 );

// phoscyon 1
AudioUnit phoscyon => dac.chan( 0 );
phoscyon => Gain phoscyonReverbBus => reverb; 
phoscyonReverbBus.gain( 0 );
phoscyon => Gain phoscyonDelayBus => delayHpf;
phoscyonDelayBus.gain( 0 );

// phoscyon 2
AudioUnit phoscyon2 => dac.chan( 0 );
phoscyon => Gain phoscyon2ReverbBus => reverb; 
phoscyon2ReverbBus.gain( 0 );
phoscyon2 => Gain phoscyon2DelayBus => delayHpf;
phoscyon2DelayBus.gain( 0 );

// drumazon
AudioUnit drumazon => Gain drumazonBus => dac.chan( 0 );
drumazon => Gain drumazonReverbBus => reverb; 
drumazonReverbBus.gain( 0 );
drumazon => Gain drumazonDelayBus => delayHpf;
drumazonDelayBus.gain( 0 );

AudioUnit lush => dac.chan( 0 );
lush => Gain lushReverbBus => reverb;
lushReverbBus.gain( 0 );
lush => Gain lushDelayBus => delay;
lushDelayBus.gain( 0 );

main();
while( 1::week => now );

fun void main() {
	probeAudioUnits();
	initClock();
	initMidi();
	initLividPitch();
	initNanoDrum();
	initAudioUnitDisplay();

	spork ~ launchControlPageSelectLoop();
	spork ~ launchControlIacLoop();
}

fun void initAudioUnitDisplay() {
	AudioUnit audioUnits[4];
	phoscyon  @=> audioUnits[0];
	phoscyon2 @=> audioUnits[1];
	lush      @=> audioUnits[2];
	drumazon  @=> audioUnits[3];

	string audioUnitNames[4];
	"phoscyon"  => audioUnitNames[0];
	"phoscyon2" => audioUnitNames[1];
	"lush"      => audioUnitNames[2];
	"drumazon"  => audioUnitNames[3];

	audioUnitDisplayer.init( audioUnits, audioUnitNames );
}

fun void probeAudioUnits() {
	AudioUnit.list() @=> string aus[];
	for(int i; i < aus.cap(); i++) {
	    chout <= aus[i] <= IO.newline();
	}
}

fun void initClock() {
	clock.init();                   // internal clock
	//clock.init( iacMidiInName );  // midi clock 
	clock.start();
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

	phoscyon2.open( "Phoscyon" );
	
	lush.open( "LuSH-101" );

	lividPitch.init();
	lividPitch.sequencers[0].___init( clock, phoscyon );
	lividPitch.sequencers[1].___init( clock, phoscyon2 );
	lividPitch.sequencers[2].___init( clock, lush );

	lividPitch.sequencers[1].octave( 5 );

	launchControl.clearAllLeds( launchControlMidiOut );
}


fun void initNanoDrum() {
	drumSequencer.init( clock, drumazon );
	nanoKontrol2.init( nanoMidiOut );
	nanoDrum.init( drumSequencer, nanoMidiInName, nanoKontrol2 );

	drumazon.open( "Drumazon" );

	int controlChanges[5];
	for( int i; i < 5; i++ ) {
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
	ccAuRouter4.init( lush, iacMidiIn2Name );

	spork ~ nanoKontrolLoop();
}

fun void nanoKontrolLoop() {
	MidiIn min;
	MidiMsg msg;
	min.open( nanoMidiInName );

	while( min => now ) {
		while( min.recv(msg) ) {
			if( nanoKontrol2.isFader(msg) ) {
				64 +=> msg.data2;
				iacMidiOut.send( msg );
			}
			else if( nanoKontrol2.isKnob(msg) ) {
				if( nanoKontrol2.knobIndex(msg) == 5 ) {
					drumazonDelayBus.gain( Utility.remap(msg.data3, 0, 127, 0, MAX_DELAY_GAIN) );
				}
				if( nanoKontrol2.knobIndex(msg) == 6) {
					drumazonReverbBus.gain( Utility.remap(msg.data3, 0, 127, 0, 0.4) );
				}
				else if( nanoKontrol2.knobIndex(msg) == 7) {
					drumazonBus.gain( Utility.remap(msg.data3, 0, 127, 0, 1) );
				}
			}
			else if( nanoKontrol2.isChannelButton(msg) ) {
				if( msg.data3 == 127 ) {
					// nanoDrum cc mulitplexer page change
					if( nanoKontrol2.channelButtonRow(msg) == 0 ) {
						nanoKontrol2.channelButtonColumn( msg ) => int column;
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
			if( msg.data2 == 5 ) {
				phoscyonDelayBus.gain( Utility.remap(msg.data3, 0, 127, 0, MAX_DELAY_GAIN) );
				//lividPitch.sequencers[0].stepLength( Utility.remap(msg.data3, 0, 127, 0.1, 1) );
			}
			else if( msg.data2 == 6 ) {
				phoscyonReverbBus.gain( Utility.remap(msg.data3, 0, 127, 0, MAX_REVERB_GAIN) );
			}
			else if( msg.data2 == 13 ) {
				lividPitch.sequencers[1].stepLength( Utility.remap(msg.data3, 0, 127, 0.1, 1) );
			}
			else if( msg.data2 == 14 ) {
				phoscyon2ReverbBus.gain( Utility.remap(msg.data3, 0, 127, 0, MAX_REVERB_GAIN) );
			}
			else if( msg.data2 == 21 ) {
				lividPitch.sequencers[2].stepLength( Utility.remap(msg.data3, 0, 127, 0.1, 1) );
			}
			else if( msg.data2 == 22 ) {
				lushReverbBus.gain( Utility.remap(msg.data3, 0, 127, 0, MAX_REVERB_GAIN) );
			}
			else if( msg.data2 == 16*7 ) {
				delay.delayTime( Utility.remap(msg.data3, 0, 127, 0, 1) );
			}
			else if( msg.data2 == 16*7 + 1 ) {
				delay.feedback( Utility.remap(msg.data3, 0, 127, 0, 1) );
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

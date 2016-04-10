NanoKontrol2 nanoKontrol2;
MidiIn midiIn;
MidiOut midiOut, nanoMidiOut;
InternalClock internalClock;
DrumSequencer drumSequencer;

midiIn.open( "drumKONTROL1 SLIDER/KNOB" );
midiOut.open( "IAC Driver IAC Bus 1" );
nanoMidiOut.open( "drumKONTROL1 CTRL" );
internalClock.init();
internalClock.start();
internalClock.bpm( 120 );
drumSequencer.lastStep( 15 ); // not working?
drumSequencer.init( internalClock, midiOut, 0 );

// initialize nanoKontrol
nanoKontrol2.turnAllLedsOff( nanoMidiOut );
Utility.midiOut( 0xB0, nanoKontrol2.channelButtons[0][0], 127, nanoMidiOut );
Utility.midiOut( 0xB0, nanoKontrol2.rewindButton, 127, nanoMidiOut );
Utility.midiOut( 0xB0, nanoKontrol2.cycleButton, 127, nanoMidiOut );

while( midiIn => now ) {
	MidiMsg midiMsg;
	while( midiIn.recv(midiMsg) ) {
		//<<<"cc:", midiMsg.data2>>>;
		if( midiMsg.data3 > 0 ) {
			if( nanoKontrol2.isChannelButton(midiMsg.data2) ) {
				nanoKontrol2.channelButtonRow( midiMsg.data2 ) => int row;
				nanoKontrol2.channelButtonColumn( midiMsg.data2 ) => int column;
				if( row == 0) {
					<<<"selcted drum", column>>>;
					updateLed( nanoKontrol2.channelButtons[drumSequencer.selectedDrum()][0], 0 );
					drumSequencer.selectedDrum( column );
					updateLed( midiMsg.data2, 1 );
					updateTriggerButtonLeds();
				}
				else if( row == 1 ) {
					<<<"step", column>>>;
					drumSequencer.trigger( column, !drumSequencer.trigger(column) );
					updateLed( midiMsg.data2, drumSequencer.trigger(column) );
				}
				else if( row == 2 ) {
					<<<"step", column + 8>>>;
					drumSequencer.trigger( column + 8, !drumSequencer.trigger(column + 8) );
					updateLed( midiMsg.data2, drumSequencer.trigger(column + 8) );
				}
			}
			else if( nanoKontrol2.isKnob(midiMsg.data2) ) {
				64*drumSequencer.patternEditing() + 8*drumSequencer.selectedDrum() => int knobCc;
				Utility.midiOut( 0xB0, knobCc, midiMsg.data2, midiOut );
			}
			else if( nanoKontrol2.isTransportButton(midiMsg.data2) ) {
				<<<"transport button", "">>>;
				// pattern 1
				if( midiMsg.data2 == nanoKontrol2.rewindButton ) {
					<<< "rewind button", "" >>>;
					patternSelectorButtonAction( 0, midiMsg.data2 );
				}  // pattern 2
				else if( midiMsg.data2 == nanoKontrol2.fastForwardButton ) {
					patternSelectorButtonAction( 1, midiMsg.data2 );
					<<< "fastforward button", "" >>>;
				}
				else if( midiMsg.data2 == nanoKontrol2.cycleButton ) {
					drumSequencer.patternPlaying( drumSequencer.patternEditing() );
					Utility.midiOut( 0xB0, nanoKontrol2.cycleButton, 127, nanoMidiOut );
				}
			}
		}
	}
}

fun void patternSelectorButtonAction( int patternNumber, int buttonCc ) {
	updateLed( nanoKontrol2.cycleButton, 0 );
	updateLed( drumSequencer.patternEditing() + nanoKontrol2.rewindButton, 0 );
	drumSequencer.patternEditing( patternNumber );
	updateTriggerButtonLeds();
	updateLed( buttonCc, 1 );

	if( drumSequencer.patternPlaying() == patternNumber )
	{
		updateLed( nanoKontrol2.cycleButton, 1 );
	}
}

fun void updateLed( int cc, int offOrOn  ) {
	Utility.midiOut( 0xB0, cc, offOrOn * 127, nanoMidiOut );
}

fun void updateTriggerButtonLeds() {
	for( 0 => int x; x < 8; x++ ) {
		for( 0 => int y; y < 2; y++ ) {
			nanoKontrol2.channelButtons[x][y+1] => int cc;
			drumSequencer.trigger( x + 8*y ) * 127 => int offOrOn;
			Utility.midiOut( 0xB0, cc, offOrOn, nanoMidiOut );
		}
	}
}

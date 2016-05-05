public class NanoDrum {
	NanoKontrol2 nanoKontrol2;
	DrumSequencer drumSequencer;
	MidiIn nanoMidiIn;
	MidiOut nanoMidiOut, instrumentMidiOut;
	int instrumentMidiOutChannel;
	
	fun void init( DrumSequencer theDrumSequencer, string midiInName, MidiOut theNanoMidiOut ) {
		<<<"initializing nanodrum", "">>>;
		theDrumSequencer @=> drumSequencer;
		if( nanoMidiIn.open(midiInName) ) {
			<<<"NanoDrum: opened midi in device", midiInName, "successfully">>>;
		}
		theNanoMidiOut @=> nanoMidiOut;

		drumSequencer.firstStep( 0 );
		drumSequencer.lastStep( 15 );

		nanoKontrol2.turnAllLedsOff( nanoMidiOut );
		Utility.midiOut( 0xB0, nanoKontrol2.channelButtons[0][0], 127, nanoMidiOut );
		Utility.midiOut( 0xB0, nanoKontrol2.rewindButton, 127, nanoMidiOut );
		Utility.midiOut( 0xB0, nanoKontrol2.cycleButton, 127, nanoMidiOut );

		spork ~ main();
		<<<"nanodrum initialized", "">>>;
	}

	fun void main() {
		while( nanoMidiIn => now ) {
			MidiMsg midiMsg;
			while( nanoMidiIn.recv(midiMsg) ) {
				//<<<"cc:", midiMsg.data2>>>;
				if( midiMsg.data3 > 0 ) {
					if( nanoKontrol2.isChannelButton(midiMsg.data2) ) {
						nanoKontrol2.channelButtonRow( midiMsg.data2 ) => int row;
						nanoKontrol2.channelButtonColumn( midiMsg.data2 ) => int column;
						if( row == 0) {
							//<<<"selcted drum", column>>>;
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
					/*
					else if( nanoKontrol2.isKnob(midiMsg.data2) ) {
						8 * drumSequencer.selectedDrum() + nanoKontrol2.knobIndex( midiMsg.data2 ) => int knobCc;
						Utility.midiOut( 0xB0, knobCc, midiMsg.data3, instrumentMidiOut );
					}
					*/
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
	}

	fun void patternSelectorButtonAction( int patternNumber, int buttonCc ) {
		updateLed( nanoKontrol2.cycleButton, 0 );
		updateLed( drumSequencer.patternEditing() + nanoKontrol2.rewindButton, 0 );
		drumSequencer.patternEditing( patternNumber );
		updateTriggerButtonLeds();
		updateLed( buttonCc, 1 );

		if( drumSequencer.patternPlaying() == patternNumber ) {
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

}

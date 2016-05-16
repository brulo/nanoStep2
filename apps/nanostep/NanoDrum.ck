public class NanoDrum {
	NanoKontrol2 nanoKontrol2;
	DrumSequencer drumSequencer;
	MidiIn nanoMidiIn;
	MidiOut nanoMidiOut, instrumentMidiOut;
	int instrumentMidiOutChannel;
	
	fun void init( DrumSequencer theDrumSequencer, string midiInName, NanoKontrol2 theNanoKontrol2 ) {
		<<<"initializing nanodrum", "">>>;

		theDrumSequencer @=> drumSequencer;
		theNanoKontrol2 @=> nanoKontrol2;

		if( nanoMidiIn.open(midiInName) ) {
			<<<"NanoDrum: opened midi in device", midiInName, "successfully">>>;
		}

		drumSequencer.firstStep( 0 );
		drumSequencer.lastStep( 15 );

		nanoKontrol2.setChannelLed( 0, 0, 1 );
		nanoKontrol2.setRewindLed( 1 );
		nanoKontrol2.setCycleLed( 1 );

		spork ~ triggerOnChaseLed();
		spork ~ main();
		<<<"nanodrum initialized", "">>>;
	}

	fun void main() {
		MidiMsg msg;
		while( nanoMidiIn => now ) {
			while( nanoMidiIn.recv(msg) ) {
				if( msg.data3 > 0 ) {
					if( nanoKontrol2.isChannelButton(msg) ) {
						nanoKontrol2.channelButtonRow( msg ) => int row;
						nanoKontrol2.channelButtonColumn( msg ) => int column;
						if( row == 0) {
							nanoKontrol2.setChannelLed( 0, drumSequencer.selectedDrum(), 0 );
							drumSequencer.selectedDrum( column );
							nanoKontrol2.setChannelLed( 0, drumSequencer.selectedDrum(), 1 );
							updateTriggerButtonLeds();
						}
						else if( row == 1 ) {
							drumSequencer.trigger( column, !drumSequencer.trigger(column) );
							nanoKontrol2.setChannelLed( row, column, drumSequencer.trigger(column) );
						}
						else if( row == 2 ) {
							drumSequencer.trigger( column + 8, !drumSequencer.trigger(column + 8) );
							nanoKontrol2.setChannelLed( row, column, drumSequencer.trigger(column + 8) );
						}
					}
					else if( nanoKontrol2.isTransportButton(msg) ) {
						  // pattern 1
						if( nanoKontrol2.isRewindButton(msg) ) {
							patternSelectorButtonAction( 0 );
						} // pattern 2
						else if( nanoKontrol2.isFastForwardButton(msg) ) {
							patternSelectorButtonAction( 1 );
						} // make pattern editing the pattern playing
						else if( nanoKontrol2.isCycleButton(msg) ) {
							drumSequencer.patternPlaying( drumSequencer.patternEditing() );
							nanoKontrol2.setCycleLed( 1 );
						}
						else if( nanoKontrol2.isStopButton(msg) ) {
							drumSequencer.deletePattern();
							updateTriggerButtonLeds();
						}
					}
				}
			}
		}
	}

	fun void patternSelectorButtonAction( int patternNumber ) {
		if( drumSequencer.patternEditing() == 0 ) {
			nanoKontrol2.setRewindLed( 0 );
		}
		else {
			nanoKontrol2.setFastForwardLed( 0 );
		}

		drumSequencer.patternEditing( patternNumber );

		updateTriggerButtonLeds();

		if( patternNumber == 0 ) {
			nanoKontrol2.setRewindLed( 1 );
		}
		else {
			nanoKontrol2.setFastForwardLed( 1 );
		}

		nanoKontrol2.setCycleLed( 0 );
		if( drumSequencer.patternPlaying() == patternNumber ) {
			nanoKontrol2.setCycleLed( 1 );
		}
	}

	fun void updateTriggerButtonLeds() {
		for( 1 => int row; row < 3; row++ ) {
			for( int col; col < 8; col++ ) {
				drumSequencer.trigger( col + 8*(row - 1) ) => int isOn;
				nanoKontrol2.setChannelLed( row, col, isOn );
			}
		}
	}

	fun void triggerOnChaseLed() {
		while( drumSequencer.clock.step => now ) {
			if( drumSequencer.trigger() ) {
				nanoKontrol2.setRecordLed( 1 );
			}
			else {
				nanoKontrol2.setRecordLed( 0 );
			}
		}
	}

}

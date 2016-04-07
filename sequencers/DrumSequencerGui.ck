public class DrumSequencerGui {
	16 => int numSteps;
	25 => int textOffsetX;
	15 => int buttonPaddingX;
	70 => int buttonSize;
	100 => int sliderSizeX;
	300 => int sliderSizeY;
	125 => int sliderOffsetY;
	0 => int patternSelectButtonsPadding;

	InternalClockGui clockGui;
	DrumSequencer sequencer;
	MidiOut midiOut;

	MAUI_Button triggerButtons[numSteps];
	MAUI_Button drumSelectorButtons[sequencer.numberOfDrums()];
	MAUI_View view, clockView;
	MAUI_Text triggerText, drumSelectorText, patternSelectorText;
	MAUI_Button patternSelectorButtons[4];

	fun void init( Clock theClock, MidiOut theMidiOut ) {
		theMidiOut @=> midiOut;

		sequencer.init( theClock, midiOut, 3 );
		initButtons();

		view.display();
	}

	fun void initText() {

	}

	fun void initButtons() {
		// drum select buttons
		for( 0 => int i; i < drumSelectorButtons.cap(); i++ ) {
			drumSelectorButtons[i].position(textOffsetX + buttonPaddingX + patternSelectButtonsPadding + i*50, 0);
			drumSelectorButtons[i].toggleType();
			drumSelectorButtons[i].size( buttonSize, buttonSize );
			spork ~ drumSelectorLoop( drumSelectorButtons[i], i );
			view.addElement( drumSelectorButtons[i] );
		}

		// trigger buttons
		for( 0 => int i; i < numSteps; i++ ) {
			100 => int secondRowOffset;	
			if( i > 7 ) {
				150 => secondRowOffset;
			}

			triggerButtons[i].position( (i % 8)*50 + buttonPaddingX + textOffsetX, secondRowOffset );
			triggerButtons[i].toggleType();
			triggerButtons[i].size( buttonSize, buttonSize );
			spork ~ triggerButtonLoop( i );
			view.addElement( triggerButtons[i] );
		}

	    // pattern select buttons
		for( 0 => int i; i < patternSelectorButtons.cap(); i++ ) {
			patternSelectorButtons[i].position(textOffsetX + buttonPaddingX + patternSelectButtonsPadding + i*50, 100);
			patternSelectorButtons[i].toggleType();
			patternSelectorButtons[i].size( buttonSize, buttonSize );
			spork ~ patternSelectorLoop( patternSelectorButtons[i], i );
			view.addElement( patternSelectorButtons[i] );
		}	

	
	}

	fun void updateUi() {
		updateTriggerButtons();
	}

	fun void updateTriggerButtons() {
		for( 0 => int i; i < numSteps; i++ ) {
			triggerButtons[i].state( sequencer.trigger(i) $ int );
		}
	}

	// UI Loops
	fun void triggerButtonLoop( int step ) {
		while( triggerButtons[step] => now ) {
			sequencer.trigger( step, triggerButtons[step].state() );
		}
	}

	fun void patternSelectorLoop( MAUI_Button button, int patternNumber ) {
		while( button => now ) {
			if( button.state() == 1 ) { 
				if( patternNumber != sequencer.patternEditing() ) {
					sequencer.patternEditing( patternNumber );
				}
				else {
					sequencer.patternPlaying( patternNumber );
					/*
					for( 0 => int i; i < patternPlayingLeds.cap(); i++ ) {
						patternPlayingLeds[i].unlight;
					}
					patternPlayingLeds[patternNumber].light;
					*/
				}

				for( 0 => int i; i < patternSelectorButtons.cap(); i++ ) {
					patternSelectorButtons[i].state( 0 );   
				}

				button.state( 1 );
				updateUi();
			}
		}
	}

	fun void drumSelectorLoop( MAUI_Button button, int drumNumber ) {
		while( button => now ) {
			if( button.state() == 1 ) { 
				sequencer.selectedDrum( drumNumber );
				for( 0 => int i; i < drumSelectorButtons.cap(); i++ ) {
					drumSelectorButtons[i].state( 0 );   
				}

				button.state( 1 );
				updateUi();
			}
		}
	}	

}

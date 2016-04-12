public class LividPitch {
	LividBase base;
	PitchSequencerMidi sequencers[2];
	MidiOut midiOut;
	Metronome metro;

	"red" => string triggerLedColor;
	"green" => string tieLedColor;
	"blue" => string accentLedColor;
	"red" => string pageSelectLedColor;
	"magenta" => string sequencerSelectLedColor;
	"blue" => string patternEditingLedColor;
	"red" => string patternPlayingLedColor;

	3 => int triggerLedRow;
	2 => int tieLedRow;
	1 => int accentLedRow;
	0 => int sequencerIndex;
	0 => int pageIndex;
	8 => int maxPages;

	-1 => int touchButtonHeld;
	0 => int patternLengthChanged;

	fun void init( Clock clock, string midiOutputName ) {
		<<< "\n==== Initializing LividStep! ====", "\n" >>>;


		// init midi
		<<< "Initializing Sequencer Midi Output...", "" >>>;
		if( midiOut.open(midiOutputName) ) {
			<<< "	", "Success: opened", midiOut.name() >>>;
		}
		else {
			<<< "	Failure: Unable to open", midiOutputName >>>;
		}


		// init sequencers
		for(int i; i < sequencers.cap(); i++) {
			sequencers[i].___init(clock, midiOut, i);
			//sequencers[i].patternLength(32);
			i => sequencers[i].midiChannel;
		}

		// init base 
		base.init();
		base.setButtonLed(0, "left", "blue");
		base.setButtonLed(0, "right", "red");
		base.setButtonLed(4, "left", "magenta");
		base.setButtonLed(4, "right", "magenta");
		base.setTouchButtonLed(pageIndex, "center", 
				pageSelectLedColor);
		// metronome for debugging
		//metro.init(clock);

		main();
		<<< "\n==== LividStep initialized! ====", "\n" >>>;
	}

	fun void main() {
		MidiMsg msg;
		while( base.midiIn => now ) {
			while( base.midiIn.recv(msg) ) {
				if( base.isFader(msg) > -1 ) {
					faderAction( msg );
				}
				else if( msg.data3 > 0 ) {
					if( base.isButton(msg) > -1 ) {
						buttonAction( msg );
					}
					else if( base.isPad(msg) > -1 ) {
						padAction( msg );
					}
				}
			}
		}
	}

	fun void faderAction( MidiMsg msg )
	{
		base.isFader(msg) => int faderIdx;
		if(faderIdx < 8) {
			sequencers[sequencerIndex].pitch(faderIdx + (pageIndex * 8), 
					Utility.remap(msg.data3, 0, 127, 0, 7));
		}
		else {
			sequencers[sequencerIndex].stepLength(Utility.remap(msg.data3, 0, 127, 0, 1));
		}
		base.setFaderLed(msg);
	}

	fun void buttonAction( MidiMsg msg ) {
		base.isButton(msg) => int buttonIndex;
		// pattern playing/editing
		if(buttonIndex < 4) {  // change pattern being edited
			if(sequencers[sequencerIndex].patternEditing() != buttonIndex) {
				base.setButtonLed(sequencers[sequencerIndex].patternEditing(), "left", "off");
				base.setButtonLed(buttonIndex, "left", patternEditingLedColor);
				sequencers[sequencerIndex].patternEditing(buttonIndex);
				updateStepLeds();
			}
			else { 	// change pattern being played
				base.setButtonLed(sequencers[sequencerIndex].patternPlaying(), "right", "off");
				base.setButtonLed(buttonIndex, "right", patternPlayingLedColor);
				sequencers[sequencerIndex].patternPlaying(buttonIndex);
			}
		}
		else if(buttonIndex < 6) {
			changeSequencer(buttonIndex - 4);
		}
	}

	fun void padAction( MidiMsg msg ) {
		base.getPadCoordinate(msg) @=> int pad[];
		pad[0] => int x;
		pad[1] => int y;
		x + (pageIndex * 8) => int stepIndex;

		// trigger
		if(y == triggerLedRow) { 
			if(sequencers[sequencerIndex].trigger(stepIndex) > 0.0) {
				sequencers[sequencerIndex].trigger(stepIndex, 0.0);
				base.setPadLed(x, y, "off");
			}
			else {
				sequencers[sequencerIndex].trigger(stepIndex, 1.0);
				base.setPadLed(x, y, triggerLedColor);
			}
		}
		// tie
		else if(y == tieLedRow) { 
			if(sequencers[sequencerIndex].tie(stepIndex)) {
				sequencers[sequencerIndex].tie(stepIndex, 0);
				base.setPadLed(x, y, "off");
			}
			else {
				sequencers[sequencerIndex].tie(stepIndex, 1);
				base.setPadLed(x, y, tieLedColor);
			}
		}
		// accent
		else if(y == accentLedRow) { 
			if(sequencers[sequencerIndex].accent(stepIndex)) {
				sequencers[sequencerIndex].accent(stepIndex, 0);
				base.setPadLed(x, y, "off");
			}
			else {
				sequencers[sequencerIndex].accent(stepIndex, 1);
				base.setPadLed(x, y, accentLedColor);
			}
		}
	}

	fun void changeStepPage(int newPageIndex) {
		Utility.clampi(newPageIndex, 0, maxPages) => newPageIndex;
		if(newPageIndex != pageIndex) {
			base.setTouchButtonLed(pageIndex, "center", "off");
			newPageIndex => pageIndex; 
			base.setTouchButtonLed(pageIndex, "center", pageSelectLedColor);
			updateStepLeds();
		}
	}

	fun void changeSequencer(int newSequencerIndex) {
		if(newSequencerIndex != sequencerIndex) {
			base.setButtonLed(sequencerIndex + 4, "left", "off");
			base.setButtonLed(sequencerIndex + 4, "right", "off");
			base.setButtonLed(sequencers[sequencerIndex].patternEditing(),"left", "off");
			base.setButtonLed(sequencers[sequencerIndex].patternPlaying(), "right", "off");
			newSequencerIndex => sequencerIndex;
			base.setButtonLed(sequencerIndex + 4, "left", sequencerSelectLedColor);
			base.setButtonLed(sequencerIndex + 4, "right", sequencerSelectLedColor);

			base.setButtonLed(sequencers[sequencerIndex].patternEditing(),"left", patternEditingLedColor);
			base.setButtonLed(sequencers[sequencerIndex].patternPlaying(), "right", patternPlayingLedColor);

			updateStepLeds();
		}
	}

	fun void updateStepLeds() {
		for(0 => int x; x < 8; x++) {
			x + (pageIndex * 8) => int stepIndex;
			base.setFaderLed(x, sequencers[sequencerIndex].pitch(stepIndex) $ int);

			if(sequencers[sequencerIndex].trigger(stepIndex) > 0.0)
				base.setPadLed(x, triggerLedRow, triggerLedColor);
			else
				base.setPadLed(x, triggerLedRow, "off");

			if(sequencers[sequencerIndex].tie(stepIndex))
				base.setPadLed(x, tieLedRow, tieLedColor);
			else
				base.setPadLed(x, tieLedRow, "off");

			if(sequencers[sequencerIndex].accent(stepIndex))
				base.setPadLed(x, accentLedRow, accentLedColor);
			else
				base.setPadLed(x, accentLedRow, "off");
		}
	}

}

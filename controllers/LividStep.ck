LividBase base;
InternalClock clock;
PitchSequencer sequencer;
MidiOut midiOut;
Metronome metro;

if(midiOut.open("UltraLite mk3 Hybrid MIDI Port")) 
	<<<midiOut.name(), "successfully opened for sequencer output">>>;

base.init();
clock.init();
clock.start();
clock.swingAmount(0.2);
clock.bpm(125);
sequencer.init(clock, midiOut);
/* metro.init(clock); */

"red" => string triggerLedColor;
"green" => string tieLedColor;
"blue" => string accentLedColor;
3 => int triggerLedRow;
2 => int tieLedRow;
1 => int accentLedRow;

base.setButtonLed(0, "left", "blue");
base.setButtonLed(0, "right", "red");
MidiMsg msg;
while(base.midiIn => now) {
	while(base.midiIn.recv(msg)) {
		if(msg.data3 > 0) {
			if(base.isFader(msg) > -1) {
				if(base.isFader(msg) < 8) {
					sequencer.pitch(base.isFader(msg), 
							Utility.remap(msg.data3, 0, 127, 0, 7));
				}
				else
					sequencer.stepLength(Utility.remap(msg.data3, 0, 127, 0, 1));
				base.setFaderLed(msg);
			}
			else if(base.isButton(msg) > -1) {
				base.isButton(msg) => int buttonIndex;
				// pattern playing/editing
				if(buttonIndex < 4) {  // change pattern being edited
					if(sequencer.patternEditing() != buttonIndex) {
						base.setButtonLed(sequencer.patternEditing(), "left", "off");
						base.setButtonLed(buttonIndex, "left", "blue");
						sequencer.patternEditing(buttonIndex);

						for(0 => int x; x < 8; x++) {
							base.setFaderLed(x, sequencer.pitch(x) $ int);

							if(sequencer.trigger(x) > 0.0)
								base.setPadLed(x, triggerLedRow, triggerLedColor);
							else
								base.setPadLed(x, triggerLedRow, "off");

							if(sequencer.tie(x))
								base.setPadLed(x, tieLedRow, tieLedColor);
							else
								base.setPadLed(x, tieLedRow, "off");
							
							if(sequencer.accent(x))
								base.setPadLed(x, accentLedRow, accentLedColor);
							else
								base.setPadLed(x, accentLedRow, "off");
						}
					}
					else { 	// change pattern being played
						base.setButtonLed(sequencer.patternPlaying(), "right", "off");
						base.setButtonLed(buttonIndex, "right", "red");
						sequencer.patternPlaying(buttonIndex);
					}
				}
				// sequencer paramater being edited
			}
			else if(base.isPad(msg) > -1) {
				base.getPadCoordinate(msg) @=> int pad[];
				pad[0] => int x;
				pad[1] => int y;

				// trigger
				if(y == triggerLedRow) { 
					if(sequencer.trigger(x) > 0.0) {
						sequencer.trigger(x, 0.0);
						base.setPadLed(x, y, "off");
					}
					else {
						sequencer.trigger(x, 1.0);
						base.setPadLed(x, y, triggerLedColor);
					}
				}
				// tie
				else if(y == tieLedRow) { 
					if(sequencer.tie(x)) {
						sequencer.tie(x, 0);
						base.setPadLed(x, y, "off");
					}
					else {
						sequencer.tie(x, 1);
						base.setPadLed(x, y, tieLedColor);
					}
				}
				// accent
				else if(y == accentLedRow) { 
					if(sequencer.accent(x)) {
						sequencer.accent(x, 0);
						base.setPadLed(x, y, "off");
					}
					else {
						sequencer.accent(x, 1);
						base.setPadLed(x, y, accentLedColor);
					}
				}
			}
		}
	}
}

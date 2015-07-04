LividBase base;
InternalClock clock;
PitchSequencer sequencer;
MidiOut midiOut;
Metronome metro;

"red" => string triggerLedColor;
"green" => string tieLedColor;
"blue" => string accentLedColor;
"red" => string pageSelectLedColor;

3 => int triggerLedRow;
2 => int tieLedRow;
1 => int accentLedRow;
0 => int pageIndex;
2 => int maxPages;

/* if(midiOut.open("UltraLite mk3 Hybrid MIDI Port")) */ 
if(midiOut.open("IAC Driver Bus 1"))
	<<<midiOut.name(), "successfully opened for sequencer output">>>;

base.init();
clock.init();
clock.start();
clock.swingAmount(0.2);
clock.bpm(125);
sequencer.init(clock, midiOut);
sequencer.patternLength(32);
/* metro.init(clock); */

base.setButtonLed(0, "left", "blue");
base.setButtonLed(0, "right", "red");
base.setTouchButtonLed(pageIndex, "center", 
		pageSelectLedColor);

MidiMsg msg;
while(base.midiIn => now) {
	while(base.midiIn.recv(msg)) {
		if(msg.data3 > 0) {
			if(base.isTouchButton(msg) > -1) {
				base.isTouchButton(msg) => int buttonIdx;
				if(buttonIdx < 2) {
					changeStepPage(buttonIdx);
				}
			}
			if(base.isFader(msg) > -1) {
				base.isFader(msg) => int faderIdx;
				if(faderIdx < 8) {
					sequencer.pitch(faderIdx + (pageIndex * 8), 
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
						updateStepLeds();
					}
					else { 	// change pattern being played
						base.setButtonLed(sequencer.patternPlaying(), "right", "off");
						base.setButtonLed(buttonIndex, "right", "red");
						sequencer.patternPlaying(buttonIndex);
					}
				}
			}
			else if(base.isPad(msg) > -1) {
				base.getPadCoordinate(msg) @=> int pad[];
				pad[0] => int x;
				pad[1] => int y;
				x + (pageIndex * 8) => int stepIndex;

				// trigger
				if(y == triggerLedRow) { 
					if(sequencer.trigger(stepIndex) > 0.0) {
						sequencer.trigger(stepIndex, 0.0);
						base.setPadLed(x, y, "off");
					}
					else {
						sequencer.trigger(stepIndex, 1.0);
						base.setPadLed(x, y, triggerLedColor);
					}
				}
				// tie
				else if(y == tieLedRow) { 
					if(sequencer.tie(stepIndex)) {
						sequencer.tie(stepIndex, 0);
						base.setPadLed(x, y, "off");
					}
					else {
						sequencer.tie(stepIndex, 1);
						base.setPadLed(x, y, tieLedColor);
					}
				}
				// accent
				else if(y == accentLedRow) { 
					if(sequencer.accent(stepIndex)) {
						sequencer.accent(stepIndex, 0);
						base.setPadLed(x, y, "off");
					}
					else {
						sequencer.accent(stepIndex, 1);
						base.setPadLed(x, y, accentLedColor);
					}
				}
			}
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

fun void updateStepLeds() {
	for(0 => int x; x < 8; x++) {
		x + (pageIndex * 8) => int stepIndex;
		base.setFaderLed(x, sequencer.pitch(stepIndex) $ int);

		if(sequencer.trigger(stepIndex) > 0.0)
			base.setPadLed(x, triggerLedRow, triggerLedColor);
		else
			base.setPadLed(x, triggerLedRow, "off");

		if(sequencer.tie(stepIndex))
			base.setPadLed(x, tieLedRow, tieLedColor);
		else
			base.setPadLed(x, tieLedRow, "off");

		if(sequencer.accent(stepIndex))
			base.setPadLed(x, accentLedRow, accentLedColor);
		else
			base.setPadLed(x, accentLedRow, "off");
	}
}

// uses the default Base mappings, just with all local LED stuff turned off
public class LividBase {
	MidiIn midiIn;
	MidiOut midiOut;
	"Base Controls" => string midiDeviceName;

	// yellow, cyan, magenta, and red seem to be the brightest
	int ledColor[0];
	0 => ledColor["off"];
	2 => ledColor["white"];
	5 => ledColor["cyan"];
	10 => ledColor["magenta"];
	20 => ledColor["red"];
	40 => ledColor["blue"];
	100 => ledColor["yellow"];
	127 => ledColor["green"];

	[[68, 10], [69, 11], [70, 12], [71, 13], 
	 [72, 14], [73, 15], [74, 16], [75, 17]] @=> int touchButtonLeds[][];

	[1, 2, 3, 4, 5, 6, 7, 8, 9] @=> int faderLeds[];
	[0, 10, 40, 50, 70, 90, 110, 127] @=> int faderLedPositions[];

	[[60, 61, 62, 63, 64, 65, 66, 67],
	 [52, 53, 54, 55, 56, 57, 58, 59],
	 [44, 45, 46, 47, 48, 49, 50, 51],
	 [36, 37, 38, 39, 40, 41, 42, 43]] @=> int padLeds[][];

	[[18, 26], [19, 27], [20, 28], [21, 29], 
	 [22, 30], [23, 31], [24, 32], [25, 33]] @=> int buttonLeds[][];

	fun void init() {
		<<<"Initializing Livid Base...", "">>>;
		if(midiIn.open(midiDeviceName))
			<<<midiIn.name(), "input opened sucessfully!">>>;
		else
			<<<midiDeviceName, "input did not open sucessfully...">>>;

		if(midiOut.open(midiDeviceName))
			<<<midiOut.name(), "output opened sucessfully!">>>;
		else
			<<<midiDeviceName, "output did not open sucessfully...">>>; 
	}

	fun void setPadLed(int row, int col, string color) {
		Utility.midiOut(0x90, padLeds[row][col], ledColor[color] , midiOut);
	}

	fun void setFaderLed(int faderIndex, int faderPosition) { 
		Utility.midiOut(0xB0, faderLeds[faderIndex], 
				faderLedPositions[faderPosition], midiOut);
	}

	fun void setTouchButtonLed(int buttonIndex, string topOrCenter, string color) {
		0 => int topOrCenterIdx;
		if(topOrCenter == "center")
			1 => topOrCenterIdx;
		Utility.midiOut(0x90, touchButtonLeds[buttonIndex][topOrCenterIdx], 
				ledColor[color], midiOut);
	}

	fun void setButtonLed(int buttonIdx, string leftOrRight, string color) {
		0 => int leftOrRightIdx;
		if(leftOrRight == "right")
			1 => leftOrRightIdx;
		Utility.midiOut(0x90, buttonLeds[buttonIdx][leftOrRightIdx], 
				ledColor[color], midiOut);
	}
}

public class ModeQuantizer {
	1 => int isEnabled;
	7 => int currentMode;

	["ionian", 
	 "dorian",
	 "phrygian",
	 "lydian",
	 "mixolydian",
	 "aeolian",
	 "locrian",
	 "pentatonic",
	 "wholetone"] @=> string modeNames[];

	[[0, 2, 4, 5, 7, 9, 11],
	 [0, 2, 3, 5, 7, 9, 10],
	 [0, 1, 3, 5, 7, 8, 10],
	 [0, 2, 4, 6, 7, 9, 11],
	 [0, 2, 4, 5, 7, 9, 10],
	 [0, 2, 3, 5, 7, 8, 10],
	 [0, 1, 3, 5, 6, 8, 10],
	 [0, 2, 4, 7, 9],
	 [0, 2, 4, 6, 8, 10]] @=> int modeIntervals[][];

	fun int quantize(int note) {
		if(isEnabled) {
			(note / (modeIntervals[currentMode].cap())) $ int => int octave;
			(note % 12) % modeIntervals[currentMode].cap() => int modeIndex;
			return (octave * 12) + modeIntervals[currentMode][modeIndex];
		}
		else 
			return note;
	}
}

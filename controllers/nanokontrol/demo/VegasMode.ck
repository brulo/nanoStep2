MidiOut mout;
NanoKontrol2 nanoKontrol2;
15::ms => dur timeStep;

main();

fun void init() {
	mout.open( "drumKONTROL1 CTRL" );
}

fun void main() {
	init();

	spork ~ channelButtons();
	spork ~ transportButtons();

	while( samp => now );
}

fun void channelButtons() {
	while( true ) {
		for( 0 => int x; x < 8; x++ ) {
			for( 0 => int y; y < 3; y++ ) {
				Utility.midiOut( 0xB1, nanoKontrol2.channelButtons[x][y], 127, mout );
				timeStep => now;
			}
		}
		for( 0 => int x; x < 8; x++ ) {
			for( 0 => int y; y < 3; y++ ) {
				Utility.midiOut( 0xB1, nanoKontrol2.channelButtons[x][y], 0, mout );
				timeStep => now;
			}
		}
	}
}

fun void transportButtons() {
	while( true ) {
		for( 0 => int i; i < nanoKontrol2.transportButtons.cap(); i++ ) {
			Utility.midiOut( 0xB1, nanoKontrol2.transportButtons[i], 127, mout );
			timeStep * 2 => now;
		}
		for( 0 => int i; i < nanoKontrol2.transportButtons.cap(); i++ ) {
			Utility.midiOut( 0xB1, nanoKontrol2.transportButtons[i], 0, mout );
			timeStep * 2 => now;
		}
	}
}

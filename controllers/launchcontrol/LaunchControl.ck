// use factory setting 1 
public class LaunchControl {
	int knobs[16];
	int buttons[8];
	114 => int upButton;
	115 => int downButton;
	116 => int leftButton;
	117 => int rightButton;

	for( int i; i < 8; i++ ) {
		21 + i => knobs[i];
		41 + i => knobs[8+i];

		if( i < 4 ) {
			9 + i => buttons[i];
		}
		else {
			21 + i => buttons[i];
		}
	}

	fun int knobIndex( MidiMsg msg ) {
		if( msg.data1 == 0xB0 ) {
			for( int i; i < knobs.cap(); i++ ) {
				if( knobs[i] == msg.data2 ) {
					return i;
				}
			}
		}
		return -1;
	}

	fun int isKnob( MidiMsg msg ) {
		if( msg.data1 == 0xB0 ) {
			for( int i; i < knobs.cap(); i++ ) {
				if( knobs[i] == msg.data2 ) {
					return 1;
				}
			}
		}
		return 0;
	}

	fun int isButton( MidiMsg msg ) {
		for( int i; i < buttons.cap(); i++ ) {
			if( msg.data2 == buttons[i] ) {
				return 1;
			}
		}
		return 0;
	}

	fun int buttonIndex( MidiMsg msg ) {
		for( int i; i < buttons.cap(); i++ ) {
			if( msg.data2 == buttons[i] ) {
				return i;
			}
		}
		return -1;
	}

	fun int isDirectionButton( MidiMsg msg ) {
		if( msg.data2 >= upButton && msg.data2 <= rightButton ) {
			return 1;
		}
		return 0;
	}

	fun void clearAllLeds(MidiOut mout) {
		for(int i; i < buttons.cap(); i++) {
			Utility.midiOut( 0x90, buttons[i], 0, mout );
		}
	}

}

/*
// test 
MidiIn min;
MidiMsg msg;
LaunchControl launchControl;
if( min.open("Launch Control") ) {
	<<<"opened min successfully">>>;
}

while( min => now ) {
    while( min.recv(msg) ) {
        <<< msg.data1, msg.data2, msg.data3 >>>;
        <<< "isKnob:", launchControl.isKnob(msg) >>>;
        <<< "isButton:", launchControl.isButton(msg) >>>;
        <<< "isDirectionButton:", launchControl.isDirectionButton(msg) >>>;
    }
}
*/
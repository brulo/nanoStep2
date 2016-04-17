// listens to a midi device for control changes in, 
// maps those control changes to selected MidiOut.
// also includes a page system, so you can have multiple 
// pages of of control changes out from the same control changes in.
// a multiplexer, if you will.
public class ControlChangeMultiplexer {
	MidiIn midiIn;
	MidiOut midiOut;
	int channelOut;
	int controlChanges[];
	0 => int currentPage;
	32 => int MAX_NUMBER_OF_PAGES;

	fun void init( int theControlChanges[], MidiIn theMidiIn, MidiOut theMidiOut, int theChannelOut ) {
		theControlChanges @=> controlChanges;
		theMidiIn @=> midiIn;
		theMidiOut @=> midiOut;
		theChannelOut => channelOut;

		spork ~ main();
	}

	fun void main() {
		MidiMsg midiMessage;
		while( midiIn => now ) {
			while( midiIn.recv(midiMessage) ) {
				for( 0 => int i; i < controlChanges.cap(); i++ ) {
					if( midiMessage.data2 == controlChanges[i] ) {
						i + (currentPage * controlChanges.cap()) => int cc;
						Utility.midiOut( 0xB0 + channelOut, cc, midiMessage.data3, midiOut );
						<<<"CCMultiplexer:", 0xB0 + channelOut, cc, midiMessage.data3>>>;
						break;
					}
				}
			}
		}
	}

	fun void changePage( int page ) {
		Utility.clampi( page, 0, MAX_NUMBER_OF_PAGES ) => page;
		page => currentPage;
	}
	
}

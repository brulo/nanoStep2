// forwards all CC's from a midi in to an AudioUnit
public class ControlChangeToAuRouter {
	AudioUnit audioUnit;
	MidiIn midiIn;

	fun void init( AudioUnit theAudioUnit, string midiInName ) {
		theAudioUnit @=> audioUnit;
		midiIn.open( midiInName );
		
		spork ~ main();
	}

	fun void main() {
		MidiMsg msg;
		while( midiIn => now ) {
			while( midiIn.recv(msg) ) {
				// if its a control change
				if( msg.data1 >= 0xB0 && msg.data1 < 0xBF) {
					//<<<"CCToAu", msg.data1, msg.data2, msg.data3 >>>;
					audioUnit.send( msg.data1, msg.data2, msg.data3 );
				}
			}
		}
	}
	
}

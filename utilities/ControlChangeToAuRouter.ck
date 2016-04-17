// forwards all CC's from a midi in to an AudioUnit
public class ControlChangeToAuRouter {
	AudioUnit audioUnit;
	MidiIn midiIn;

	fun void init( AudioUnit theAudioUnit, MidiIn theMidiIn ) {
		theAudioUnit @=> audioUnit;
		theMidiIn @=> midiIn;

		spork ~ main();
	}

	fun void main() {
		MidiMsg midiMessage;
		while( midiIn => now ) {
			while( midiIn.recv(midiMessage) ) {
				// if its a control change
				if( midiMessage.data1 >= 0xB0 && midiMessage.data1 < 0xBF) {
					<<<"routing msg">>>;
					sendMidiToAu( midiMessage );
				}
			}
		}
	}

	fun void sendMidiToAu( MidiMsg msg ) {
		<<< msg.data1, msg.data2, msg.data3 >>>;
		audioUnit.send( msg.data1, msg.data2, msg.data3 );
	}
	
}
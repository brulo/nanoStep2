// channel arguments should be 0 indexed

public class StatusByte {

	fun int noteOff(int channel) {
		return 0x80 + channel;
	}

	fun int noteOn(int channel) {
		return 0x90 + channel;
	}

	fun int cc(int channel) {
		return 0xB0 + channel;
	}

	fun int programChange(int channel) {
		return 0xC0 + channel;
	}  

	fun static void midiOut(int status, int note, int velocity, MidiOut mout) {
	    MidiMsg msg; 
	    status => msg.data1;
	    note => msg.data2;
	    velocity => msg.data3;
	    mout.send(msg); 
	  }

}

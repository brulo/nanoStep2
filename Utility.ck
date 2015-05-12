public class Utility {
  // Clamp a float between a min and max.
  fun static float clamp(float val, float min, float max) {
    return Math.max(Math.min(val, max), min);
  }
	
  fun static int clampi(int val, int min, int max) {
		if(val > max) {
			return max;
		}
		else if(val < min) {
			return min;
		}
		return val;
  }

  fun static void midiOut(int status, int note, int velocity, MidiOut mout) {
    MidiMsg msg; 
    status => msg.data1;
    note => msg.data2;
    velocity => msg.data3;
    mout.send(msg); 
  }
}

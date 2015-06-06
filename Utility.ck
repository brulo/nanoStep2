public class Utility {
  // clamp a float between a range
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

	// map a value in one range to another range.
	fun static float remap(float val, 
			float low1, float high1,    // val's range
			float low2, float high2) {  // desired range
		return low2 + (val - low1) * (high2 -low2) / (high1 - low1);
	}
}

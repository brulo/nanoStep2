public class ModSource {
	UGen source;
	Osc pitchSource;
	// the min/max expected values from source
	-1.0 => float sourceMin;
	1.0 => float sourceMax;
	1.0 => float maxValue;
	0.0 => float _amount;
	1 => int isExponential;
	0 => int isPitchTracking;
	
	fun float amount() { return _amount; }
	fun float amount(float val) {
		Utility.clamp(val, 0.0, 1.0) => _amount;
		return _amount;
	}

	fun float sourceLast() {
		if(isPitchTracking) { 
			return pitchSource.freq();
		}
		else { 
			return source.last();
		}
	}

	fun float value() {
		Utility.remap(sourceLast(), 	
				sourceMin, sourceMax, 
				0.0, 1.0)  * _amount => float normedAmount;
		if(isExponential) { 
			normedAmount *=> normedAmount;
		}
		return normedAmount * maxValue;
	}
}

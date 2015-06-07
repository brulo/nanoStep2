public class ModSource {
	UGen source;
	Osc pitchSource;
	// the min/max expected values from source
	-1.0 => float sourceMin;
	1.0 => float sourceMax;
	1.0 => float maxValue;  // should be positive
	0.0 => float _amount;
	/* 1 => int isExponential; */
	0 => int isPitchTracking;
	1 => int isCentered;
	0 => int isInverted;
	
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
		float val;
		if(isCentered) {
			Utility.remap(sourceLast(), 	
					sourceMin, sourceMax, 
					-1.0, 1.0) => float bipolarized;
			bipolarized * maxValue * 0.5 => val;
		}
		else {
			Utility.remap(sourceLast(), 	
					sourceMin, sourceMax, 
					0.0, 1.0) => float unipolarized;
			unipolarized * maxValue => val; 
		}
		return val * _amount;
	}
}

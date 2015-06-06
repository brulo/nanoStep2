public class ModSource {
	UGen source;
	// the min/max expected values from source
	-1.0 => float sourceMin;
	1.0 => float sourceMax;
	1.0 => float maxValue;
	0.0 => float _amount;
	1 => int isExponential;
	
	fun float amount() { return _amount; }
	fun float amount(float val) {
		Utility.clamp(val, 0.0, 1.0) => _amount;
		return _amount;
	}


	fun float value() {
		Utility.remap(source.last(), 
				sourceMin, sourceMax, 
				0.0, 1.0)  * _amount => float normedAmount;
		if(isExponential) { 
			normedAmount *=> normedAmount;
		}
		return normedAmount * maxValue;
	}
}

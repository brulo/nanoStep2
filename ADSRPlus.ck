// ADSR wrapped to normalize param control to 0.0 - 1.0
public class AdsrPlus extends Chubgraph {
  inlet => ADSR envelope => outlet;
  float _attackTime, _decayTime, _sustainLevel, _releaseTime;
	0 => int keyPosition;
	0.01::ms => dur minTime;
	2::second => dur maxTime;

  fun void init() {
    attackTime(0.0);
    decayTime(0.0);
    sustainLevel(1.0);
    releaseTime(0.0);
  }
  
  fun void keyOn() { 
    envelope.keyOn(1); 
		1 => keyPosition;
  }

  fun void keyOff() { 
    envelope.keyOff(1); 
		0 => keyPosition;
  }

  fun float attackTime() { return _attackTime; }
  fun float attackTime(float val) {
    Utility.clamp(val, 0.0, 1.0) => _attackTime;
    envelope.attackTime(_attackTime * maxTime + minTime);
    return _attackTime;
  }

  fun float decayTime() { return _decayTime; }
  fun float decayTime(float val) {
    Utility.clamp(val, 0.0, 1.0) => _decayTime;
    envelope.decayTime(_decayTime * maxTime + minTime);
    return _decayTime;
  }
  
  fun float sustainLevel() { return _sustainLevel; }
  fun float sustainLevel(float val) {
    Utility.clamp(val, 0.0, 1.0) => _sustainLevel;
    envelope.sustainLevel(_sustainLevel);
    return _sustainLevel;
  }

  fun float releaseTime() { return _releaseTime; }
  fun float releaseTime(float val) {
    Utility.clamp(val, 0.0, 1.0) => _releaseTime;
    envelope.releaseTime(_releaseTime * maxTime + minTime);
    return _releaseTime;
  }
}

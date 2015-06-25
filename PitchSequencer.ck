// A pitch sequencer that triggers midi on channel 1
// by Bruce Lott, 2013-2014
public class PitchSequencer extends Sequencer {
  int accents[][];
  int ties[][];
  float pitches[][];  
  int _transpose, _octave, lastPitch;
  30 => int gateT; 
	MidiOut midiOut;

  fun void init(Clock clock, MidiOut theMidiOut) {
    _init(clock);
		theMidiOut @=> midiOut;
    4 => _octave;
    new int[_numberOfPatterns][_numberOfSteps] @=> accents;
    new int[_numberOfPatterns][_numberOfSteps] @=> ties;
    new float[_numberOfPatterns][_numberOfSteps] @=> pitches;
  }

  fun float pitch(int s) { return pitches[_patternEditing][s]; }
  fun float pitch(int s, float p) { 
		p => pitches[_patternEditing][s]; 
		return pitches[_patternEditing][s]; 
	}

  fun int gateTime() { return gateT; }
  fun int gateTime(int gt) {
    gt => gateT;
    return gateT;
  }

  fun int octave() { return _octave; }
  fun int octave(int o) {
    o => _octave;
    return _octave;
  }

  fun int accent(int s) { return accents[_patternEditing][s]; }
  fun int accent(int s, int t) { 
		t => accents[_patternEditing][s];
		return accents[_patternEditing][s];
	}

  fun int tie(int s) { return ties[_patternEditing][s]; }
  fun int tie(int s, int t) { 
		t => ties[_patternEditing][s];
		return ties[_patternEditing][s];
	}
  fun int transpose() { return _transpose; }
  fun int transpose(int t) {
    t => _transpose;
    return _transpose;
  }

  fun void doStep() {
		int _velocity;
    if(_triggers[_patternPlaying][_currentStep]>0) {
      80 => _velocity;
      if(accents[_patternPlaying][_currentStep]) 40 +=> _velocity;
      (pitches[_patternPlaying][_currentStep]+_transpose+(_octave*12))$int => int pit;
      if(ties[_patternPlaying][_currentStep]) {
        <<<"cur note on", "">>>;
        Utility.midiOut(0x90, pit, _velocity, midiOut);
        1::ms => now;
        <<<"last note off", "">>>;
        Utility.midiOut(0x80, lastPitch, 10, midiOut);
      }
      else { // gate
        <<<"cur note on", "">>>;
        Utility.midiOut(0x90, pit, _velocity, midiOut);
        spork ~ gateOff(pit, _velocity) @=> Shred g; // timed cur note off
        if(pit != lastPitch) {
          1::ms => now;
          <<<"turn last pitch off", "">>>;
          Utility.midiOut(0x80, lastPitch, _velocity, midiOut);
        }
      }
      pit => lastPitch;
    }
    else {
      if(!ties[_patternPlaying][_currentStep] & lastPitch !=0) { 
        <<< "0 => lastPitch", "">>>;
        Utility.midiOut(0x80, lastPitch, _velocity, midiOut);
        0 => lastPitch;
      }
    }
  }
	

  fun void gateOff(int p, int v) {
    gateT::ms => now;
    <<<"gate off", "">>>;
    Utility.midiOut(0x80, p, v, midiOut); 
  }
}

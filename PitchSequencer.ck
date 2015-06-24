// PitchSequencer_Midi.ck
// A pitch sequencer that _triggersgers midi on channel 1
// by Bruce Lott, 2013-2014
public class PitchSequencer extends Sequencer {
  int accents[][];
  int ties[][];
  float pitches[][];  
  int _transpose, _octave, lastPitch;
  60 => int gateT; 

  fun void init(Clock clock) {
    _init(clock);
    4 => _octave;
    new int[_numberOfPatterns][_numberOfSteps] @=> accents;
    new int[_numberOfPatterns][_numberOfSteps] @=> ties;
    new float[_numberOfPatterns][_numberOfSteps] @=> pitches;
  }

  fun void setPitch(float p) { p => pitches[_patternEditing][_currentStep]; }
  fun void setPitch(int s, float p) { p => pitches[_patternEditing][s]; }
  fun void setPitch(int pat, int s, float p) { p => pitches[pat][s]; }

  fun float getPitch() { return pitches[_patternEditing][_currentStep]; }
  fun float getPitch(int s) { return pitches[_patternEditing][s]; } 
  fun float getPitch(int p, int s) { return pitches[p][s]; }

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

  fun void setAccent(int t) { t => accents[_patternEditing][_currentStep]; }
  fun void setAccent(int s, int t) { t => accents[_patternEditing][s]; }
  fun void setAccent(int p, int s, int t) { t => accents[p][s]; }

  fun void toggleAccent(int s) {
    !accents[_patternEditing][s] => accents[_patternEditing][s];
  }    
  fun void toggleAccent(int p, int s) {
    !accents[p][s] => accents[p][s];
  }

  fun int getAccent() { return accents[_patternEditing][_currentStep]; }
  fun int getAccent(int s) { return accents[_patternEditing][s]; }
  fun int getAccent(int p, int s) { return accents[p][s]; }

  fun void setTie(int t) { t => ties[_patternEditing][_currentStep]; }
  fun void setTie(int s, int t) { t => ties[_patternEditing][s]; }
  fun void setTie(int p, int s, int t) { t => ties[p][s]; }

  fun void toggleTie(int s) {
    if(ties[_patternEditing][s]) 0 => ties[_patternEditing][s];
    else 1 => ties[_patternEditing][s];
  }    
  fun void toggleTie(int p, int s) {
    if(ties[p][s]) 0 => ties[p][s];
    else 1 => ties[p][s];
  }

  fun int getTie() { return ties[_patternEditing][_currentStep]; }
  fun int getTie(int s) { return ties[_patternEditing][s]; }
  fun int getTie(int p, int s) { return ties[p][s]; }

  fun int transpose() { return _transpose; }
  fun int transpose(int t) {
    t => _transpose;
    return _transpose;
  }

  fun void doStep() {
    if(_triggers[_patternPlaying][_currentStep]>0) {
      80 => int _velocity;
      if(accents[_patternPlaying][_currentStep]) 40 +=> _velocity;
      (pitches[_patternPlaying][_currentStep]+_transpose+(_octave*12))$int => int pit;
      if(ties[_patternPlaying][_currentStep]) {
        <<<"cur note on", "">>>;
        /* midiOut(0x90, pit, _velocity); // cur note on */
        1::ms => now;
        <<<"last note off", "">>>;
        /* midiOut(0x80, lastPitch, 10); // last note off */
      }
      else { // gate
        <<<"cur note on", "">>>;
        /* midiOut(0x90, pit, _velocity); // cur note on */
        spork ~ gateOff(pit, _velocity) @=> Shred g; // timed cur note off
        if(pit != lastPitch) {
          1::ms => now;
          <<<"turn last pitch off", "">>>;
          /* midiOut(0x80, lastPitch, _velocity); */ 
        }
      }
      pit => lastPitch;
    }
    else {
      if(!ties[_patternPlaying][_currentStep] & lastPitch !=0) { 
        <<< "0 => lastPitch", "">>>;
        /* midiOut(0x80, lastPitch, _velocity); */
        0 => lastPitch;
      }
    }
  }

  fun void gateOff(int p, int v) {
    gateT::ms => now;
    <<<"gate off", "">>>;
    /* midiOut(0x80, p, v); */ 
  }

}

public class ADSRPlus extends Chubgraph {
  inlet => ADSR envelope => outlet;
  float _attackTime, _decayTime, _sustainLevel, _releaseTime;

  // GUI
  MAUI_Slider attackSlider, decaySlider, sustainSlider, releaseSlider;
  [attackSlider, decaySlider, sustainSlider, releaseSlider] @=> MAUI_Slider sliders[];

  fun void init() {
    attackTime(0.0);
    decayTime(0.0);
    sustainLevel(1.0);
    releaseTime(0.0);
  }
  
  fun void initGUI(MAUI_View view, int xOffset, int yOffset) {
    for(0 => int i; i < sliders.cap(); i++) {
      sliders[i].range(0.0, 1.0);
      sliders[i].value(0.5);
      sliders[i].position(xOffset, yOffset + i*50);
      view.addElement(sliders[i]);
    } 
    sustainSlider.value(sustainLevel());
    attackSlider.name("Attack");
    decaySlider.name("Decay");
    sustainSlider.name("Sustain");
    releaseSlider.name("Release");
    /* attackSlider.position(xOffset, yOffset); */
    /* decaySlider.position(xOffset, yOffset + 50); */
    /* sustainSlider.position(xOffset, yOffset + 100); */
    /* releaseSlider.position(xOffset, yOffset + 150); */

    _sporkGUIShreds();
  }

  /* PUBLIC */
  fun void keyOn() { envelope.keyOn(1); }
  fun void keyOff() { envelope.keyOff(1); }

  fun float attackTime() { return _attackTime; }
  fun float attackTime(float val) {
    Utility.clamp(val, 0, 1) => _attackTime;
    envelope.attackTime((_attackTime*500+1)::ms);
    return _attackTime;
  }

  
  fun float decayTime() { return _decayTime; }
  fun float decayTime(float val) {
    Utility.clamp(val, 0, 1) => _decayTime;
    envelope.decayTime((_decayTime*500+1)::ms);
    return _decayTime;
  }
  
  fun float sustainLevel() { return _sustainLevel; }
  fun float sustainLevel(float val) {
    Utility.clamp(val, 0, 1) => _sustainLevel;
    envelope.sustainLevel(_sustainLevel);
    return _sustainLevel;
  }

  fun float releaseTime() { return _releaseTime; }
  fun float releaseTime(float val) {
    Utility.clamp(val, 0, 1) => _releaseTime;
    envelope.releaseTime((_releaseTime*500+1)::ms);
    return _releaseTime;
  }
    
  /* PRIVATE */
  fun void _attackSliderLoop() {
    while(attackSlider => now)
      attackTime(attackSlider.value());
  }

  fun void _decaySliderLoop() {
    while(decaySlider => now)
      decayTime(decaySlider.value());
  }

  fun void _sustainSliderLoop() {
    while(sustainSlider => now)
      sustainLevel(sustainSlider.value());
  }

  fun void _releaseSliderLoop() {
    while(releaseSlider => now)
      releaseTime(releaseSlider.value());
  }

  fun void _sporkGUIShreds() {
    spork ~ _attackSliderLoop();
    spork ~ _decaySliderLoop();
    spork ~ _sustainSliderLoop();
    spork ~ _releaseSliderLoop();
  }
}

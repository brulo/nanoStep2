MAUI_View keyboardView;
MAUI_GridKeyboard keyboard;
keyboard.init(keyboardView);
keyboardView.display();

MAUI_View synthView;

MultiOscillator mOsc => MultiFilter mFilt => ADSRPlus ampEnv => dac;
LFO pitchLFO => blackhole;
Step step => ADSRPlus filterCutoffEnv => blackhole;

// oscillator row
mOsc.init();
mOsc.initGUI(synthView, "Oscillator", 0, 0);
pitchLFO.init();
pitchLFO.initGUI(synthView, "Osc LFO", 0, 215);
mOsc.addFreqMod(pitchLFO);
// filter row
mFilt.init();
mFilt.initGUI(synthView, "Filter", 250, 0);
filterCutoffEnv.init();
filterCutoffEnv.initGUI(synthView, "Filter Env", 250, 175);
mFilt.addFreqMod(filterCutoffEnv);
// amplitude row
ampEnv.init();
ampEnv.initGUI(synthView, "Amp Env", 500, 0);

keyboardView.display();
synthView.size(775, 550);
synthView.display();

OscIn oscIn;
oscIn.port(1234);
oscIn.listenAll();
OscMsg oscMsg;
36 => int lowestNote;

// OSC processing/main loop
while(oscIn => now) {
  while(oscIn.recv(oscMsg)) {
    if(oscMsg.address == "/note") {
      mOsc.note(oscMsg.getFloat(0) + lowestNote);
    }
    else if(oscMsg.address == "/gate") {
      if(oscMsg.getInt(0)) {
        ampEnv.keyOn();
        filterCutoffEnv.keyOn();
      }
      else {
        ampEnv.keyOff();
        filterCutoffEnv.keyOff();
      }
    }
  }
}

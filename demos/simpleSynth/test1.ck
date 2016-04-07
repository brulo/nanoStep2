MAUI_View keyboardView;
MAUI_GridKeyboard keyboard;
keyboard.init(keyboardView);
keyboardView.display();

MAUI_View synthView;

MultiOscillator mOsc => MultiFilter mFilt => AdsrPlus ampEnv => Gain gain => dac;
gain.gain(.7);
Lfo pitchLfo => blackhole;
Step step => AdsrPlus filterCutoffEnv => blackhole;

// oscillator row
mOsc.init();
MultiOscillatorGui mOscGui;
mOscGui.init(mOsc, synthView, 0, 0);
pitchLfo.init();
LfoGui lfoGui;
lfoGui.init(pitchLfo, synthView, 0, 300);
pitchLfo @=> mOsc.freqLfo.source;
/* mOsc.addFreqMod(pitchLfo); */
// filter row
mFilt.init();
MultiFilterGui mFiltGui;
mFiltGui.init(mFilt, synthView, 250, 0);
filterCutoffEnv.init();
AdsrPlusGui filterCutoffEnvGui;
filterCutoffEnvGui.init(filterCutoffEnv, synthView, 250, 350);
filterCutoffEnv @=> mFilt.freqEnv.source;
/* mFilt.addFreqMod(filterCutoffEnv); */
// amplitude row
ampEnv.init();
AdsrPlusGui ampEnvGui;
ampEnvGui.init(ampEnv, synthView, 500, 0);

keyboardView.display();
synthView.size(775, 700);
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

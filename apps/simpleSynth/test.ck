MAUI_View keyboardView;
MAUI_GridKeyboard keyboard;
keyboard.init(keyboardView);
keyboardView.display();

MAUI_View synthView;

MultiOscillator mOsc => MultiFilter mFilt => EfAmp amp =>  dac;
Step step=> AdsrPlus env => blackhole;
step.next(1.0);
env @=> amp.source;
amp.init();
Lfo lfo => blackhole;

// row 1 
// oscillator 
mOsc.init();
MultiOscillatorGui mOscGui;
mOscGui.init(mOsc, synthView, 0, 0);
env @=> mOsc.freqEnv.source;
lfo @=> mOsc.freqLfo.source;

// filter
mFilt.init();
MultiFilterGui mFiltGui;
mFiltGui.init(mFilt, synthView, 0, 300);
env @=> mFilt.freqEnv.source;
0 => mFilt.freqEnv.isCentered;
0 => mFilt.freqLfo.isCentered;
lfo @=> mFilt.freqLfo.source;

// row 2
// env
env.init();
AdsrPlusGui envGui;
envGui.init(env, synthView, 250, 0);

// lfo
lfo.init();
LfoGui lfoGui;
lfoGui.init(lfo, synthView, 250, 350);


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
        env.keyOn();
      }
      else {
        env.keyOff();
      }
    }
  }
}

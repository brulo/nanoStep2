public class PitchOscToMidi {
  MidiOut midiOut;
  OscIn oscIn;
  OscMsg oscMsg;

  fun void init(int oscPort, string midiPortName) {
    oscIn.port(oscPort);
    oscIn.addAddress("/gate");
    oscIn.addAddress("/note");

    if(!midiOut.open(midiPortName))
      <<<"midi port:", midiPortName, "not opened">>>;
    else
      <<<"midi port:", midiPortName, "opened">>>;
    while(oscIn => now) {
      while(oscIn.recv(oscMsg)) {
              
      }
    }
  }
}

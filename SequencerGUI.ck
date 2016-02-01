8 => int numSteps;
MAUI_Slider pitchSliders[numSteps];
MAUI_Button triggerButtons[numSteps];
InternalClock clock;
PitchSequencer pitchSeq;
int x, y;
MAUI_View view;
MidiOut midiOut;
"IAC Driver IAC Bus 1" => string midiOutPort;

if(midiOut.open(midiOutPort))
  <<<midiOut.name(), "input opened sucessfully!">>>;
else
  <<<midiOutPort, "input did not open sucessfully...">>>;

clock.init();
midiOut.open(midiOutPort);
pitchSeq.init(clock, midiOut);

for(0 => int i; i < numSteps; i++) {
  pitchSliders[i].position(x, y + i*50);
  triggerButtons[i].position(x+200, y + i*50 + 18);
  triggerButtons[i].toggleType();
  triggerButtons[i].size(70, 70);
  spork ~ pitchSliderLoop(i); 
  spork ~ triggerButtonLoop(i);
  view.addElement(pitchSliders[i]);
  view.addElement(triggerButtons[i]);
} 

view.display();
clock.start();
20::second => now;

fun void triggerButtonLoop(int step) {
  while(triggerButtons[step] => now)
    pitchSeq.trigger(step, triggerButtons[step].state()); 
}

fun void pitchSliderLoop(int step) {
  while(pitchSliders[step] => now)
    pitchSeq.pitch(step, pitchSliders[step].value()*numSteps);
}

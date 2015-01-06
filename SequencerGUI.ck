8 => int numSteps;
MAUI_Slider pitchSliders[numSteps];
MAUI_Button triggerButtons[numSteps];
Clock clock;
PitchSequencer pitchSeq;
MAUI_View view;

int x, y;
clock.init();
pitchSeq.init();
pitchSeq.patternLength(numSteps);

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
20::second => now;

fun void triggerButtonLoop(int step) {
  while(triggerButtons[step] => now)
    pitchSeq.trigger(step, triggerButtons[step].state()); 
}

fun void pitchSliderLoop(int step) {
  while(pitchSliders[step] => now)
    pitchSeq.setPitch(step, pitchSliders[step].value()*numSteps);
}

8 => int numSteps;
25 => int textOffsetX;
15 => int buttonPaddingX;
70 => int buttonSize;
100 => int sliderSizeX;
300 => int sliderSizeY;
125 => int sliderOffsetY;
0 => int x; 0 => int y;  // offset for all elements on the main panel
MAUI_Slider pitchSliders[numSteps];
MAUI_Button triggerButtons[numSteps];
MAUI_Button accentButtons[numSteps];
MAUI_Button tieButtons[numSteps];
MAUI_View view, clockView;
MAUI_Text triggerText, slideText, accentText;
InternalClock clock;
InternalClockGui clockGui;
PitchSequencer pitchSeq;
MidiOut midiOut;


main("IAC Driver IAC Bus 1");

fun void main( string midiOutPort ) {
  clock.init();
  clockGui.init( clock, clockView );
  pitchSeq.init( clock, midiOut );

  initMidi( midiOutPort );

  initButtons();
  initSliders();
  initText();

  view.display();
  clockView.size( 250, 200 );
  clockView.display();
  clock.start();

  while( samp => now );
}

fun void initButtons() {
  for( 0 => int i; i < numSteps; i++ ) {
    triggerButtons[i].position( x + i*50 + buttonPaddingX + textOffsetX, y );
    triggerButtons[i].toggleType();
    triggerButtons[i].size( buttonSize, buttonSize );
    spork ~ triggerButtonLoop( i );
    view.addElement( triggerButtons[i] );

    tieButtons[i].position( x + i*50 + buttonPaddingX + textOffsetX, y + 50 );
    tieButtons[i].toggleType();
    tieButtons[i].size( buttonSize, buttonSize );
    spork ~ tieButtonLoop( i );
    view.addElement( tieButtons[i] );

    accentButtons[i].position( x + i*50 + buttonPaddingX + textOffsetX, y + 100 );
    accentButtons[i].toggleType();
    accentButtons[i].size( buttonSize, buttonSize );
    spork ~ accentButtonLoop( i );
    view.addElement( accentButtons[i] );
  } 
}

fun void initSliders() {
  for( 0 => int i; i < 8; i++ ) {
    pitchSliders[i].position( x + i*50 + textOffsetX, y + sliderOffsetY );
    pitchSliders[i].orientation( 2 );
    pitchSliders[i].size( sliderSizeX, sliderSizeY );
    spork ~ pitchSliderLoop( i ); 
    view.addElement( pitchSliders[i] );
  }
}

fun void initText() {
    triggerText.name( "Trigger" );
    triggerText.position( x, 0 );
    view.addElement( triggerText );

    slideText.name( "Slide" );
    slideText.position( x, 50 );
    view.addElement( slideText );

    accentText.name( "Accent" );
    accentText.position( x, 100 );
    view.addElement( accentText );
}

fun void initMidi(string midiOutPort) {
  if( midiOut.open(midiOutPort) ) {
    <<< midiOut.name(), "input opened sucessfully!" >>>;
  }
  else {
    <<< midiOutPort, "input did not open sucessfully..." >>>;
  }
}

// UI loops
fun void triggerButtonLoop( int step ) {
  while( triggerButtons[step] => now ) {
    pitchSeq.trigger( step, triggerButtons[step].state() );
  }
}

fun void tieButtonLoop( int step ) {
  while( triggerButtons[step] => now ) {
    pitchSeq.tie( step, tieButtons[step].state() );
  }
}

fun void accentButtonLoop( int step ) {
  while( accentButtons[step] => now ) {
    pitchSeq.accent( step, accentButtons[step].state() );
  }
}

fun void pitchSliderLoop( int step ) {
  while( pitchSliders[step] => now ) {
    pitchSeq.pitch( step, pitchSliders[step].value() * numSteps );
  }
}

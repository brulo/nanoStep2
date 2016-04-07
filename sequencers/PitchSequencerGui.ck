public class PitchSequencerGui {
  12.0 => float pitchSliderRange;
  15 => int buttonPaddingX;
  70 => int buttonSize;

  100 => int sliderSizeX;
  300 => int sliderSizeY;
  125 => int sliderOffsetY;

  8 => int numSteps;
  25 => int textOffsetX;
  50 => int stepLengthSliderOffset;
  225 => int patternSelectButtonsPadding;

  MAUI_Slider pitchSliders[numSteps];
  MAUI_Slider stepLengthSlider;
  MAUI_Button triggerButtons[numSteps];
  MAUI_Button accentButtons[numSteps];
  MAUI_Button tieButtons[numSteps];
  MAUI_Button patternSelectorButtons[4];
  MAUI_LED patternPlayingLeds[4];
  MAUI_View view;
  MAUI_Text triggerText, slideText, accentText;
  PitchSequencer pitchSeq;

  fun void init( Clock clock, MidiOut midiOut) {
    pitchSeq.init( clock, midiOut );

    initButtons();
    initSliders();
    initText();

    view.display();
  }

  fun void initButtons() {
    // per step buttons 
    for( 0 => int i; i < numSteps; i++ ) {
      triggerButtons[i].position( i*50 + buttonPaddingX + textOffsetX, stepLengthSliderOffset );
      triggerButtons[i].toggleType();
      triggerButtons[i].size( buttonSize, buttonSize );
      spork ~ triggerButtonLoop( i );
      view.addElement( triggerButtons[i] );

      tieButtons[i].position( i*50 + buttonPaddingX + textOffsetX, 50 + stepLengthSliderOffset );
      tieButtons[i].toggleType();
      tieButtons[i].size( buttonSize, buttonSize );
      spork ~ tieButtonLoop( i );
      view.addElement( tieButtons[i] );

      accentButtons[i].position( i*50 + buttonPaddingX + textOffsetX, 100 + stepLengthSliderOffset );
      accentButtons[i].toggleType();
      accentButtons[i].size( buttonSize, buttonSize );
      spork ~ accentButtonLoop( i );
      view.addElement( accentButtons[i] );
    }

    // pattern select buttons
    for( 0 => int i; i < patternSelectorButtons.cap(); i++ ) {
      patternSelectorButtons[i].position( patternSelectButtonsPadding + i*50, 0);
      patternSelectorButtons[i].toggleType();
      patternSelectorButtons[i].size( buttonSize, buttonSize );
      spork ~ patternSelectorLoop( patternSelectorButtons[i], i );
      view.addElement( patternSelectorButtons[i] );
    }
  }

  fun void initLeds() {
    for( 0 => int i; i < patternPlayingLeds.cap(); i++ ) {
      patternPlayingLeds[i].color( 1 );
      patternPlayingLeds[i].position( patternSelectButtonsPadding + i*25, 0 );
      view.addElement( patternPlayingLeds[i] ); 
    }
  }

  fun void initSliders() {
    for( 0 => int i; i < 8; i++ ) {
      pitchSliders[i].position( i*50 + textOffsetX, sliderOffsetY + stepLengthSliderOffset );
      pitchSliders[i].orientation( 2 );
      pitchSliders[i].size( sliderSizeX, sliderSizeY );
      pitchSliders[i].range(0.0, pitchSliderRange);
      spork ~ pitchSliderLoop( i ); 
      view.addElement( pitchSliders[i] );
    }

    stepLengthSlider.position( 0, 0 );
    stepLengthSlider.name( "Step Length" );
    spork ~ stepLengthLoop();
    view.addElement( stepLengthSlider );
  }

  fun void initText() {
      triggerText.name( "Trigger" );
      triggerText.position( 7, stepLengthSliderOffset );
      view.addElement( triggerText );

      slideText.name( "Slide" );
      slideText.position( 7, 50 + stepLengthSliderOffset );
      view.addElement( slideText );

      accentText.name( "Accent" );
      accentText.position( 7, 100 + stepLengthSliderOffset );
      view.addElement( accentText );
  }

  // UI Updates (called when patternEditing/patternPlaying changed)
  fun void updateUi() {
    updateSliderValues();
    updateButtonValues();
  }

  fun void updateSliderValues() {
    for( 0 => int i; i < numSteps; i++ ) {
      pitchSliders[i].value( pitchSeq.pitch(i) );
    }
  }

  fun void updateButtonValues() {
    for( 0 => int i; i < numSteps; i++ ) {
      triggerButtons[i].state( pitchSeq.trigger(i) $ int );
      accentButtons[i].state( pitchSeq.accent(i) $ int);
      tieButtons[i].state( pitchSeq.tie(i) $ int );
    }
  }

  // * UI Loops *
  fun void patternSelectorLoop( MAUI_Button button, int patternNumber ) {
    while( button => now ) {
      if( button.state() == 1 ) { 
        if( patternNumber != pitchSeq.patternEditing() ) {
          pitchSeq.patternEditing( patternNumber );
        }
        else {
          pitchSeq.patternPlaying( patternNumber );
          for( 0 => int i; i < patternPlayingLeds.cap(); i++ ) {
            patternPlayingLeds[i].unlight;
          }
          patternPlayingLeds[patternNumber].light;
        }

        for( 0 => int i; i < patternSelectorButtons.cap(); i++ ) {
          patternSelectorButtons[i].state( 0 );   
        }

        button.state( 1 );
        updateUi();
      }
    }
  }

  fun void triggerButtonLoop( int step ) {
    while( triggerButtons[step] => now ) {
      pitchSeq.trigger( step, triggerButtons[step].state() );
    }
  }

  fun void tieButtonLoop( int step ) {
    while( tieButtons[step] => now ) {
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
      pitchSeq.pitch( step, pitchSliders[step].value() );
    }
  }

  fun void stepLengthLoop() {
    while( stepLengthSlider => now ) {
      pitchSeq.stepLength( stepLengthSlider.value() );
    }
  }

}

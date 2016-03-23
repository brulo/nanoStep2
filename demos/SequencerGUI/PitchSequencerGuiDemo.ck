InternalClock clock;
InternalClockGui clockGui;
MAUI_View clockView;

PitchSequencerGui pitchSequencerGui;
MidiOut midiOut;

midiOut.open("IAC Driver IAC Bus 1");

clock.init();

clock.init();
clockGui.init( clock, clockView );

clockView.size( 250, 200 );
clockView.display();
clock.start();

pitchSequencerGui.init( clock, midiOut );

while( samp => now );
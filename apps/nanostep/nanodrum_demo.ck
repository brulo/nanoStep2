InternalClock internalClock;
NanoDrum nanoDrum;
DrumSequencerMidi drumSequencer;
MidiIn nanoMidiIn;
MidiOut instrumentMidiOut, nanoMidiOut;
0 => int instrumentMidiOutChannel;

drumSequencer.init( internalClock, instrumentMidiOut, instrumentMidiOutChannel );

nanoMidiIn.open( "drumKONTROL1 SLIDER/KNOB" );
nanoMidiOut.open( "drumKONTROL1 CTRL" );
instrumentMidiOut.open( "IAC Driver IAC Bus 1" );
internalClock.init();
internalClock.start();
internalClock.bpm( 120 );

nanoDrum.init( drumSequencer, nanoMidiIn, nanoMidiOut );

while( samp => now );
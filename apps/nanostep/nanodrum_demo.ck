InternalClock internalClock;
NanoDrum nanoDrum;
MidiIn nanoMidiIn;
MidiOut instrumentMidiOut, nanoMidiOut;

nanoMidiIn.open( "drumKONTROL1 SLIDER/KNOB" );
nanoMidiOut.open( "drumKONTROL1 CTRL" );
instrumentMidiOut.open( "IAC Driver IAC Bus 1" );
internalClock.init();
internalClock.start();
internalClock.bpm( 120 );
0 => int instrumentMidiOutChannel;

nanoDrum.init( nanoMidiIn, nanoMidiOut, instrumentMidiOut, instrumentMidiOutChannel, internalClock );

while( samp => now );
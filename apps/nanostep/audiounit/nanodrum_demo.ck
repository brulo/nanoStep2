InternalClock internalClock;
NanoDrum nanoDrum;
DrumSequencerAu drumSequencer;
MidiIn nanoMidiIn;
MidiOut nanoMidiOut;
AudioUnit audioUnit => dac;

AudioUnit.list() @=> string aus[];
for(int i; i < aus.cap(); i++) {
    chout <= aus[i] <= IO.newline();
}

audioUnit.open( "Drumazon" );
//:w
audioUnit.display();

drumSequencer.init( internalClock, audioUnit );

nanoMidiIn.open( "drumKONTROL1 SLIDER/KNOB" );
nanoMidiOut.open( "drumKONTROL1 CTRL" );
internalClock.init();
internalClock.start();
internalClock.bpm( 120 );

nanoDrum.init( drumSequencer, nanoMidiIn, nanoMidiOut );

while( samp => now );
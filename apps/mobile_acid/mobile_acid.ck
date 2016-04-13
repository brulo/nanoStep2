InternalClockGui internalClockGui;
LividPitch lividPitch;
AudioUnit phoscyon => dac;
AudioUnit drumazon => dac;
DrumSequencerAu drumSequencer;
NanoDrum nanoDrum;
MidiIn nanoMidiIn;
MidiOut nanoMidiOut;

// init clock
internalClockGui.init();

// probe audio units
AudioUnit.list() @=> string aus[];
for(int i; i < aus.cap(); i++) {
    chout <= aus[i] <= IO.newline();
}
// init nanodrum
nanoMidiIn.open( "drumKONTROL1 SLIDER/KNOB" );
nanoMidiOut.open( "drumKONTROL1 CTRL" );
drumazon.open( "Drumazon" );
drumazon.display();
drumSequencer.init( internalClockGui.clock, drumazon );
nanoDrum.init( drumSequencer, nanoMidiIn, nanoMidiOut );

// init lividpitch
phoscyon.open( "Phoscyon" );
phoscyon.display();
lividPitch.init( internalClockGui.clock, phoscyon );

while( samp => now );

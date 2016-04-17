InternalClockGui internalClockGui;
LividPitch lividPitch;
AudioUnit phoscyon => dac;
AudioUnit drumazon => dac;
DrumSequencerAu drumSequencer;
NanoDrum nanoDrum;
MidiIn nanoMidiIn;
MidiOut nanoMidiOut;
MidiIn iacMidiIn;
MidiOut iacMidiOut;
ControlChangeToAuRouter ccAuRouter;
ControlChangeMultiplexer ccMultiplexer;
NanoKontrol2 nanoKontrol2;

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

// init iac accessories
iacMidiIn.open( "IAC Driver IAC Bus 1" );
iacMidiOut.open( "IAC Driver IAC Bus 1" );
int controlChanges[nanoKontrol2.knobs.cap()];
for( 0 => int i; i < nanoKontrol2.knobs.cap(); i++ ) {
	nanoKontrol2.knobs[i] => controlChanges[i];
}
0 => int multiplerChannelOut;
ccMultiplexer.init( controlChanges, nanoMidiIn, iacMidiOut, multiplerChannelOut );
ccAuRouter.init( drumazon, iacMidiIn );

// init lividpitch
phoscyon.open( "Phoscyon" );
phoscyon.display();
lividPitch.init( internalClockGui.clock, phoscyon );

while(samp => now);
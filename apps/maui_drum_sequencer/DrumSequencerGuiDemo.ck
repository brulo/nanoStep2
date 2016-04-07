DrumSequencerGui drumSequencerGui;
InternalClockGui internalClockGui;
MidiOut midiOut;

midiOut.open("IAC Driver IAC Bus 1");
internalClockGui.init();
drumSequencerGui.init( internalClockGui.clock, midiOut );

while( samp => now );
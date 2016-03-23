InternalClockGui clockGui;
PitchSequencerGui pitchSequencerGui;
MidiOut midiOut;

midiOut.open("IAC Driver IAC Bus 1");
clockGui.init();
pitchSequencerGui.init( clockGui.clock, midiOut );

while( samp => now );
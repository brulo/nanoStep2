LividPitch lividPitch;
InternalClock internalClock;

internalClock.init();
internalClock.start();
internalClock.swingAmount(0.2);
internalClock.bpm(125);

"IAC Driver IAC Bus 1" => string midiOutputName;
lividPitch.init( internalClock, midiOutputName );

while( samp => now );

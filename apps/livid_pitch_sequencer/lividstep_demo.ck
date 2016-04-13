LividPitch lividPitch;
InternalClock internalClock;
AudioUnit audioUnit => dac;

AudioUnit.list() @=> string aus[];
for(int i; i < aus.cap(); i++) {
    chout <= aus[i] <= IO.newline();
}

audioUnit.open( "Phoscyon" );
//:w
audioUnit.display();

internalClock.init();
internalClock.start();
internalClock.swingAmount(0);
internalClock.bpm(125);

lividPitch.init( internalClock, audioUnit );

while( samp => now );

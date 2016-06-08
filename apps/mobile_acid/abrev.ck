// probe
AudioUnit.list() @=> string aus[];
for(int i; i < aus.cap(); i++) {
    chout <= aus[i] <= IO.newline();
}

AudioUnit audioUnit => Overdrive rev => dac;
rev.drive(15);
audioUnit.open( "Drumazon" );
audioUnit.display();

1::week => now;
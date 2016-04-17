AudioUnit phoscyon => dac;

// probe audio units
AudioUnit.list() @=> string aus[];
for(int i; i < aus.cap(); i++) {
    chout <= aus[i] <= IO.newline();
}

phoscyon.open( "Phoscyon" );
phoscyon.display();

MidiMsg midiMsg;
0xB0 => midiMsg.data1;
64 => midiMsg.data2;
100 => midiMsg.data3;
phoscyon.send(midiMsg);

while(samp => now);
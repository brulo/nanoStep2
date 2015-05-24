MidiClock clock;
Metronome metro;

clock.init("IAC Driver Bus 1");
/* clock.init("UltraLite mk3 Hybrid"); */
metro.init(clock);

while(samp => now);

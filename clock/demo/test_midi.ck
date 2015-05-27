MidiClock clock;
MidiClockGui clockGui;
Metronome metro;
MAUI_View view;

clock.init("IAC Driver Bus 1");
/* clock.init("UltraLite mk3 Hybrid"); */
metro.init(clock);
clockGui.init(clock, view);
view.size(250, 150);
view.name("Midi Clock");
view.display();


while(samp => now);

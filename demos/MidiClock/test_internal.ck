InternalClock clock;
InternalClockGui clockGui;
Metronome metro;
MAUI_View view;

clock.init();
metro.init(clock);
clockGui.init(clock, view);
view.size(250, 200);
view.name("Internal Clock");
view.display();

while(samp => now);

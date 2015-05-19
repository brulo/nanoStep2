SinOsc metro => ADSR metroEnv => dac;
metro.gain(.5);
metro.freq(Std.mtof(60));
metroEnv.set(1::ms, 20::ms, 0, 0::ms);

Clock clock;
clock.init();

MAUI_View view;
view.size(250, 200);

ClockGui clockGui;
clockGui.init(clock, view);

view.display();

while(clock.step => now) {
	if(clock.currentStep() % 4 == 0) {
		metro.freq(Std.mtof(80));
	}
	else {
		metro.freq(Std.mtof(60));
	}
	metroEnv.keyOff();
	metroEnv.keyOn();
}

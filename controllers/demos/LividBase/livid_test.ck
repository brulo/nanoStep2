LividBase base;
base.init();
0.2::second => dur timeStep;


spork ~ faderLeds();
spork ~ touchButtonLeds();
spork ~ padLedColors();
spork ~ buttonLeds();

while(samp => now);

fun void faderLeds() {
	while(true) {
		for(int i; i < 8; i++) {
			for(int j; j < 9; j++) {
				base.setFaderLed(j, i);
			}
			timeStep => now;
		}
	}
}

fun void touchButtonLeds() {
	while(true) {
		for(int i; i < 8; i++) {
			base.setTouchButtonLed(i, "center", "green");
			timeStep => now;
		}
		for(int i; i < 8; i++) {
			base.setTouchButtonLed(i, "top", "red");
			timeStep => now;
		}
		for(int i; i < 8; i++) {
			base.setTouchButtonLed(i, "center", "off");
			base.setTouchButtonLed(i, "top", "off");
		}
	}
}

fun void padLedColors() {
	while(true) {
		for(int j; j < 8; j++) { 
			base.setPadLed(0, j, "yellow");
			timeStep/2 => now;
		}
		for(int j; j < 8; j++) { 
			base.setPadLed(1, j, "cyan");
			timeStep/2 => now;
		}
		for(int j; j < 8; j++) { 
			base.setPadLed(2, j, "magenta");
			timeStep/2 => now;
		}
		for(int j; j < 8; j++) { 
			base.setPadLed(3, j, "red");
			timeStep/2 => now;
		}
		for(int i; i < 4; i++) { 
			for(int j; j < 8; j++) { 
				base.setPadLed(i, j, "off");
			}
		}
	}
}

fun void buttonLeds() {	
	while(true) {
		for(int i; i < 8; i++) {
			base.setButtonLed(i, "left", "red");
			timeStep => now;
		}
		for(int i; i < 8; i++) {
			base.setButtonLed(i, "right", "green");
			timeStep => now;
		}
		for(int i; i < 8; i++) {
			base.setButtonLed(i, "left", "off");
			base.setButtonLed(i, "right", "off");
		}
	}
}

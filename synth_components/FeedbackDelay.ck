public class FeedbackDelay extends Chubgraph {
	500 => float MAX_DELAY_TIME;
	inlet => Delay _delay => outlet;
	_delay => Gain feedbackBus => _delay;
	feedbackBus.gain(0.85);
	_delay.max( MAX_DELAY_TIME::ms );
	_delay.delay(100::ms);

	fun void feedback( float val ) {
		Std.clampf( val, 0.0, 1.0) => val;
		Std.scalef( val, 0, 1, 0, 0.9 ) => val;
		feedbackBus.gain( val );
	}

	// 0 to 1 float for easy binding to a midi knob
	fun void delayTime( float val ) {
		Std.clampf( val, 0.0, 1.0 ) => val;
		val *=> val;
		Std.scalef( val, 0.0, 1.0, 10.0, MAX_DELAY_TIME )::ms => _delay.delay;
	}

}

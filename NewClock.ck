public class Clock{
    int _pulsesPerBeat, playing, networking;
    float BPM, nSteps, _swingAmount;
		int cStep;
    dur _stepLength, SPB, swing; 
    time lastStep;
    Shred loopS;
		Event pulse;


    fun void init() { init(120.0); }
    fun void init(float nTempo) {
        1 => _pulsesPerBeat;
        128 => nSteps;
        tempo(nTempo);
        pulsesPerBeat(4); // 16th notes
        play(1);
        spork ~ loop() @=> loopS;
    }

    fun void loop() { // main loop, if not playing, wait
        while(true) {
            if(playing) wait();
            else samp => now;
        }
    }

    fun void wait() { // checks if a step has passed
        if(cStep % 2 == 0) { 
            if(now - lastStep >= _stepLength + swing) {
							advance();
						}
        }
        else {
            if(now - lastStep >= _stepLength - swing) {
							advance();
						}
        }

        samp => now;
    }

		// increment current step and broadcast pulse 
    fun void advance() { 
        now => lastStep;
        if(cStep + 1 < nSteps) 1 +=> cStep;
        else 0 => cStep;
				pulse.broadcast();
    }

    fun int play() { return playing; } 
    fun int play(int p) {
        if(p){
            now => lastStep; // start playing/re-cue
            0 => cStep;
            1 => playing;
        }
        else 0 => playing; // stop
        return playing;
    }    

    fun float tempo() { return BPM; } 
    fun float tempo(float newBPM) {
        newBPM => BPM;
        60.0::second / BPM => SPB;
        pulsesPerBeat(_pulsesPerBeat);
        return BPM;
    }

    fun float addToCurrentTempo(int inc) { return tempo(BPM + inc); }
    fun float addToCurrentTempo(float inc) { return tempo(BPM + inc); }

    fun float swingAmount() { return _swingAmount; }
    fun float swingAmount(float s) {
			Utility.clamp(s, 0.0, 1.0);
      _stepLength * _swingAmount => swing;
    }    

    fun int pulsesPerBeat() { return _pulsesPerBeat; }
    fun int pulsesPerBeat(int d) {
        if(d > 0) {
            d => _pulsesPerBeat;
            SPB / _pulsesPerBeat => _stepLength;
            swingAmount(_swingAmount);
        }
        return _pulsesPerBeat;
    }

    fun dur stepLength() { return stepLen; }

    fun void kill() { loopS.exit(); } 
}

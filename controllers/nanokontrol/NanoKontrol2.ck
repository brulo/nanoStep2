public class NanoKontrol2 {
    int faders[8];
    int knobs[8];
    int channelButtons[8][3];

    for( 0 => int i; i < 8; i++ ) {
        i => faders[i];
        i => knob[i];
        8 + i => channelButtons[i][0];
        16 + i => channelButtons[i][1];
        24 + i => channelButtons[i][2];
    }

    int transportButtons[11];
    for(0 => int i; i < trans.cap(); i++) {
        40 + i => trans[i];
    }
    transportButtons[0] => int rewindButton;
    transportButtons[1] => int fastForwardButton;
    transportButtons[2] => int stopButton;
    transportButtons[3] => int playButton;
    transportButtons[4] => int recordButton;
    transportButtons[5] => int cycleButton;
    transportButtons[6] => int setButton;
    transportButtons[7] => int markerLeftButton;
    transportButtons[8] => int markerRightButton;
    transportButtons[9] => int trackLeftButton;
    transportButtons[10] => int trackRightButton;

    fun int isFader( int cc ) {
        for( int i; i < faders.size(); i++ ) {
            if( cc == faders[i] ) {
                return 1;
            }
        }
        return 0;
    }

    fun int faderIndex( int cc ) {
        if( isFader(cc) ) {
            return cc;
        }
        return -1;
    }

    fun int isKnob( int cc ) {
        for( int i; i < knobs.size(); i++ ) {
            if( cc == knobs[i] ) {
                return 1;
            }
        }
        return 0;
    }

    fun int knobIndex( int cc ) {
        if( isKnob(cc) ){
            return cc - knobs[0];
        } 
        return -1;
    }

    fun int isButton( int cc ) {
        for( int i; i < button.size(); i++ ) {
            for( int j; j < button[0].size(); j++ ) {
                if( cc == button[i][j]) {
                    return cc;
                }
            }
        }
        return -1;
    }

    fun int[] buttonPos( int cc ) {
        int result[2];
        buttonColumn( cc ) => result[0];
        buttonRow( cc ) => result[1];

        return result;
    }
    
    fun int buttonColumn( int cc ) {
        if( isButton(cc) ) {
            for( int i; i < button.size(); i++ ) {
                for( int j; j<button[0].size(); j++ ) {
                    if( cc == button[i][j] ) {
                        return i;
                    }
                }
            }
        }
        return -1;
    }

    fun int buttonRow( int cc ) {
        if( isButton(cc) ) {
            for( int i; i < button.size(); i++ ) {
                for( int j; j < button[0].size(); j++ ) {
                    if( cc == button[i][j] ) {
                        return j;
                    }
                }
            }
        }
        return -1;
    }

    fun int isTransportButton( int cc ) {
        for( int i; i < trans.size(); i++ ) {
            if( cc == trans[i] ) {
                return 1;
            }
        }
        return 0;
    }   

    fun int isControl( int cc ) {
        if( isFader(cc) | isKnob(cc) | isButton(cc) | isFader(cc) ) {
            return 1;
        }
        return 0;
    }
}      
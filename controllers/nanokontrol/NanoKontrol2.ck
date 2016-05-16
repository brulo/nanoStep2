public class NanoKontrol2 {
    MidiOut midiOut;
    int faders[8];
    int knobs[8];
    int channelButtons[8][3];

    for( 0 => int i; i < 8; i++ ) {
        i      => knobs[i];
        i + 32 => faders[i];
        8 + i  => channelButtons[i][0];
        16 + i => channelButtons[i][1];
        24 + i => channelButtons[i][2];
    }

    int transportButtons[11];
    for(0 => int i; i < transportButtons.cap(); i++) {
        40 + i => transportButtons[i];
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

    
    fun void init( MidiOut theMidiOut ) {
        theMidiOut @=> midiOut;
        turnAllLedsOff();
    }

    fun int isFader( MidiMsg msg ) {
        for( int i; i < faders.size(); i++ ) {
            if( msg.data2 == faders[i] ) {
                return 1;
            }
        }
        return 0;
    }

    fun int faderIndex( MidiMsg msg ) {
        if( isFader(msg) ) {
            return msg.data2;
        }
        return -1;
    }

    fun int isKnob( MidiMsg msg ) {
        for( int i; i < knobs.size(); i++ ) {
            if( msg.data2 == knobs[i] ) {
                return 1;
            }
        }
        return 0;
    }

    fun int knobIndex( MidiMsg msg ) {
        if( isKnob(msg) ){
            return msg.data2 - knobs[0];
        } 
        return -1;
    }

    fun int isChannelButton( MidiMsg msg ) {
        for( int i; i < channelButtons.size(); i++ ) {
            for( int j; j < channelButtons[0].size(); j++ ) {
                if( msg.data2 == channelButtons[i][j]) {
                    return msg.data2;
                }
            }
        }
        return 0;
    }

    fun int[] buttonPos( MidiMsg msg ) {
        int result[2];
        channelButtonColumn( msg ) => result[0];
        channelButtonRow( msg ) => result[1];

        return result;
    }
    
    fun int channelButtonColumn( MidiMsg msg ) {
        if( isChannelButton(msg) ) {
            for( int i; i < channelButtons.size(); i++ ) {
                for( int j; j < channelButtons[0].size(); j++ ) {
                    if( msg.data2 == channelButtons[i][j] ) {
                        return i;
                    }
                }
            }
        }
        return -1;
    }

    fun int channelButtonRow( MidiMsg msg ) {
        if( isChannelButton(msg) ) {
            for( int i; i < channelButtons.size(); i++ ) {
                for( int j; j < channelButtons[0].size(); j++ ) {
                    if( msg.data2 == channelButtons[i][j] ) {
                        return j;
                    }
                }
            }
        }
        return -1;
    }

    fun int isTransportButton( MidiMsg msg ) {
        for( int i; i < transportButtons.size(); i++ ) {
            if( msg.data2 == transportButtons[i] ) {
                return 1;
            }
        }
        return 0;
    }   

    fun int isControl( MidiMsg msg ) {
        msg.data2 => int cc;
        if( isFader(msg) || isKnob(msg) || isChannelButton(msg) || isFader(msg) ) {
            return 1;
        }
        return 0;
    }

    fun void setChannelLed( int row, int col, int isOn ) {
        if( isOn != 0 ) {
            1 => isOn;
        }
        channelButtons[col][row] => int cc;
        Utility.midiOut( 0xB0, cc, isOn * 127, midiOut );
    }

    fun void setRewindLed( int isOn ) {
        if( isOn != 0 ) {
            1 => isOn;
        }
        Utility.midiOut( 0xB0, rewindButton, isOn * 127, midiOut );
    }

    fun void setFastForwardLed( int isOn ) {
        if( isOn != 0 ) {
            1 => isOn;
        }
        Utility.midiOut( 0xB0, fastForwardButton, isOn * 127, midiOut );
    }

    fun void setStopLed( int isOn ) {
        if( isOn != 0 ) {
            1 => isOn;
        }
        Utility.midiOut( 0xB0, stopButton, isOn * 127, midiOut );
    }

    fun void setPlayLed( int isOn ) {
        if( isOn != 0 ) {
            1 => isOn;
        }
        Utility.midiOut( 0xB0, playButton, isOn * 127, midiOut );
    }

    fun void setRecordLed( int isOn ) {
        if( isOn != 0 ) {
            1 => isOn;
        }
        Utility.midiOut( 0xB0, recordButton, isOn * 127, midiOut );
    }

    fun void setCycleLed( int isOn ) {
        if( isOn != 0 ) {
            1 => isOn;
        }
        Utility.midiOut( 0xB0, cycleButton, isOn * 127, midiOut );
    }

    fun void turnAllLedsOff() {
        for( int row; row < 3; row++ ) {
            for( int col; col < 8; col++ ) {
                setChannelLed( row, col, 0 );
            }
        }

        for( 0 => int i; i < transportButtons.cap(); i++ ) {
            Utility.midiOut( 0xB0, transportButtons[i], 0, midiOut );
        }
    }

    fun int isTrackRightButton( MidiMsg msg ) {
        return msg.data2 == trackRightButton;
    }

    fun int isTrackLeftButton( MidiMsg msg ) {
        return msg.data2 == trackLeftButton;
    }

    fun int isMarkerRightButton( MidiMsg msg ) {
        return msg.data2 == markerRightButton;
    }

    fun int isMarkerLeftButton( MidiMsg msg ) {
        return msg.data2 == markerLeftButton;
    }

    fun int isSetButton( MidiMsg msg ) {
        return msg.data2 == setButton;
    }

    fun int isCycleButton( MidiMsg msg ) {
        return msg.data2 == cycleButton;
    }

    fun int isRecordButton( MidiMsg msg ) {
        return msg.data2 == recordButton;
    }

    fun int isPlayButton( MidiMsg msg ) {
        return msg.data2 == playButton;
    }

    fun int isStopButton( MidiMsg msg ) {
        return msg.data2 == stopButton;
    }

    fun int isFastForwardButton( MidiMsg msg ) {
        return msg.data2 == fastForwardButton;
    }

    fun int isRewindButton( MidiMsg msg ) {
        return msg.data2 == rewindButton;
    }

}      

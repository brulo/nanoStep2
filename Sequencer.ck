// Sequencer.ck
// Sequencer base class to extend from
// Uses local OSC 
// by Bruce Lott, 2013

public class Sequencer{
    int patternLen, numSteps, currentStep;
    int numPatterns, patternPlaying, patternEditing;
    float trigger[][]; // [pattern][step]
    
    fun void _init(){
        0  => currentStep => patternPlaying => patternEditing;
        8  => patternLen => numPatterns;
        16 => numSteps;
        new float[numPatterns][numSteps] @=> trigger;
        new float[numPatterns][numSteps] @=> triggerBuffer;
        clearAllTriggers();
    }  
    
    fun void doStep(){ } // what happens when arriving at a new step
                         // override this in child class     
                           
    fun float trigger(int step){ return trigger[patternEditing][step]; }
    fun float trigger(int step, float val){
        val => trigger[patternEditing][step];
        return trigger[patternEditing][step];
    }
   
    fun void clearTriggers(){  // clear pattern being edited's triggers
        for(int i; i<trigger[0].cap(); i++){
            0 => trigger[patternEditing][i];
        }
    }
    
    fun void clearAllTriggers(){  // clear all patterns' triggers
        for(int i; i<trigger.cap(); i++){
            for(int j; j<trigger[0].cap(); j++){
                0 => trigger[i][j];
            }
        }
    }

    fun int numberOfSteps(){ return numSteps; }
    
    fun int numberOfPatterns(){ return numPatterns; }
    
    fun int currentStep(){ return currentStep; }
    
    fun void kill(){ clockShred.exit(); }
    
    // pattern select functionality
    fun int patternPlaying(){ return patternPlaying; } // pattern being played/broadcast
    fun int patternPlaying(int pp){
				Utility.clamp(pp, 0, numPatterns) => patternPlaying;
        return patternPlaying;
    }
    
    fun int patternEditing(){ return patternEditing; } // pattern being edited
    fun int patternEditing(int pe){
        if(pe>=0 & pe<numPatterns) pe => patternEditing;
        return patternEditing;
    }
    
    fun int patternLength(){ return patternLength; }  // pattern 
    fun int patternLength(int pl){
				Utility.clamp(pl, 0, numSteps) => patternLength;
        return patternLength;
    }
}

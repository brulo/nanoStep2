public class Sampler {
	<<<"alkdfsj">>>;	
	//SndBuf samples[];		
		
	/*
	fun void init( string sampleNames[] )
	{
		<<<"a">>>;
		
		new SndBuf[ sampleNames.cap() ] @=> samples;
		for( int i; i < sampleNames.cap(); i++ )
		{
			samples[i].read( sampleNames[i] );
			samples[i].pos( samples[i].length() );
		}
	}
	*/
	fun void triggerNote( int midiNote )
	{
		<<< "trigger">>>;
		Utility.clampi( midiNote, 60 - 4*12, 60 + 4*12 ) => midiNote;
		Std.mtof( midiNote ) => float midiFreq;
		
		1/16 => float rateLow;
		16 => float rateHigh;
		Std.mtof( 60 - 4*12 ) => float freqLow;
		Std.mtof( 60 + 4*12 ) => float freqHigh;

		Utility.remap(midiFreq, freqLow, freqHigh, rateLow, rateHigh ) => float mapped;

		mapped * mapped => mapped;
		//samples[0].pos( 0 );
	}

}

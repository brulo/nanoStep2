<<<1>>>;
Sampler sampler;
<<<2>>>;
string sampleNames[1];
"808.wav" => sampleNames[0];
//sampler.init( sampleNames );

for( 60-12*4 => int i; i < 60+12*4; i++ )
{
	sampler.triggerNote( i );
	50::ms => now;
}
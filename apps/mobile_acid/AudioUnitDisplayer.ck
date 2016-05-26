public class AudioUnitDisplayer
{
	AudioUnit audioUnits[];
	MAUI_Button buttons[];
	MAUI_View view;
	125 => int BUTTON_WIDTH;
	75 => int BUTTON_HEIGHT;

	fun void init( AudioUnit theAudioUnits[], string audioUnitNames[] )
	{
		theAudioUnits @=> audioUnits;
		new MAUI_Button[ theAudioUnits.cap() ] @=> buttons;

		for( int i; i < audioUnits.cap(); i++ )
		{
			buttons[i].position( BUTTON_WIDTH*i, 0 );
			buttons[i].size( BUTTON_WIDTH, BUTTON_HEIGHT );
        	buttons[i].pushType();
        	buttons[i].name( audioUnitNames[i] );

        	view.size( BUTTON_WIDTH*i + BUTTON_WIDTH, BUTTON_HEIGHT );
        	view.name( "AudioUnit Displayer" );
        	view.addElement( buttons[i] );

			spork ~ buttonLoop( buttons[i], i );
		}

        view.display();
	}

	fun void buttonLoop( MAUI_Button button, int index )
	{
		while( button => now )
		{
			if( button.state() )
			{
				audioUnits[index].display();
			}
		}
	}

}

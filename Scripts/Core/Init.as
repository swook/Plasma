/*
 *    _____         _______ _______ _______ _______
 *   |_____] |      |_____| |______ |  |  | |_____|
 *   |       |_____ |     | ______| |  |  | |     |
 *
 *   Core/Init.as - Core Initialisation Methods
 */


if ( !UCI_NAME )
	var UCI_NAME:String = "Plasma_" + new Date().getTime();		// Set some UCI name


// For: Mode.as
// Mode Init
{
	switch ( Sys.State ) {
		case 0:																	// No state
		case 1:																	// Music/Video Playing
		case 2:																	// Music/Video Paused
		case 3:																	// Music/Video Stopped
		case 6:																	// Reserved state
			Mode.Music = true;
			break;
		case 4:																	// Radio
		case 5:																	// Radio Recording
			Mode.Radio = true;
			break;
		case 7:																	// Recording
		case 8:																	// Recording Paused
		case 9:																	// Recording Stopped
		case 10:																// Recording Playing
		case 11:																// Recording 'Play_Pause'
			Mode.Record = true;
			break;
		case 12:																// Mobile TV
		case 13:																// Mobile TV Recording
			Mode.MobileTV = true;
			break;
		default:
			Mode.Music = true;
			break;
	}
}

// For: Data.as
Do_Periodic( 5000, Data.Sync );

// For: System.as
Do_onDisplayUpdate( function ():Void {
	Sys.State = ext_fscommand2( "GetEtcState" );
});

// For: Volume.as
Do_onDisplayUpdate( Volume.CheckDevice );



// For: Time.as
Do_onUnload( function ():Void {
	delete onEnterFrame;
});


// For: Key.as
{
	switch ( Sys.Device ) {
		case "J3":
		case "C2":
		case "X7":
			_global.RegisterKeyListener( onKey.Handler );									// J3, C2
			break;
		case "S9":
		case "i9":
			_global.gfn_Key_CreateKeyListner( onKey.Handler );							// S9, i9
			break;
	}
}

tDevice = "Your Device: "+ Sys.Device;

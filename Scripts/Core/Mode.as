/*
 *    _____         _______ _______ _______ _______
 *   |_____] |      |_____| |______ |  |  | |_____|
 *   |       |_____ |     | ______| |  |  | |     |
 *
 *   Core/Mode.as - Low-Level Mode Handling
 */


/*
 * All mode setting must be done via:
 * 		Mode.Current = "Music";
 * 		Mode.Current = "Video";
 * for example.
 *
 * This is so that Plasma can keep track of modes and
 * enable/disable functionality when needed.
 */
var Mode:Object = {};

/*
 * Mode.Current can be used to set modes
 * Use in the following manner:
 * 		Mode.Current = "Music";
 * Note: Modes are case-sensitive. (ie. "Music" works but "music" does not)
 */
Mode.addProperty( "Current",
				  function ():String {
					  return Mode.CurrentData;
				  },
				  function ( mode:String ):Void {
					  mode = Mode.CheckModeName( mode );						// Check if valid mode specified
					  if ( mode == "" || mode == Mode.Previous )
						  return;												// Invalid mode name or already set

					  var result:Number = ext_fscommand2( "EtcModChangeMode", mode );
					  var init:Boolean = ( Mode.CurrentData == null );			// Check if first time setting mode
					  if ( init || result == 1 ) {								// If first time or successful and different mode
						  if ( !init ) Mode.Previous = Mode.CurrentData;
						  Mode.CurrentData = mode;
						  if ( !init ) Mode.PostProcessing();
					  }
				  });

Mode.CheckModeName = function ( name ):String {
	switch ( name ) {
		case "Music":
		case "Video":
		case "Radio":
		case "Record":
		case "MobileTV":
		case "Flash":
		case "Text":
		case "Picture":
		case "Dictionary":
			return name;
		default:
			return "";
	}
}

// This function changes some cached information based on mode change
Mode.PostProcessing = function ():Void {
	var prev:String = Mode.Previous;
	var now:String = Mode.CurrentData;

	switch ( now ) {
		case "Music":
			break;
		case "Video":
			switch ( prev ) {
				case "Music":
					Music.PlayState = false;
			}
			break;
		case "Radio":
			switch ( prev ) {
				case "Music":
					Music.PlayState = false;
			}
			break;
		case "Record":
			switch ( prev ) {
				case "Music":
					Music.PlayState = false;
			}
			break;
		case "MobileTV":
			switch ( prev ) {
				case "Music":
					Music.PlayState = false;
			}
			break;
		case "Flash":
			break;
	}
}



/*
 * The following properties are shortcuts for Mode.Current
 *
 * To check whether a certain mode is enabled, check in the following way:
 * 		if ( Mode.Music )
 *
 * To set a certain mode, do the following:
 * 		Mode.Music = true;
 *
 * Note: Disabling modes is not possible as a replacement mode needs to be set.
 */

Mode.addProperty( "Music",
				  function ():Boolean {
					  return ( Mode.Current == "Music" );
				  },
				  function ( trig:Boolean ):Void {
					  if ( trig )
						  Mode.Current = "Music";
				  });

Mode.addProperty( "Video",
				  function ():Boolean {
					  return ( Mode.Current == "Video" );
				  },
				  function ( trig:Boolean ):Void {
					  if ( trig )
						  Mode.Current = "Video";
				  });

Mode.addProperty( "Radio",
				  function ():Boolean {
					  return ( Mode.Current == "Radio" );
				  },
				  function ( trig:Boolean ):Void {
					  if ( trig )
						  Mode.Current = "Radio";
				  });

Mode.addProperty( "Record",
				  function ():Boolean {
					  return ( Mode.Current == "Record" );
				  },
				  function ( trig:Boolean ):Void {
					  if ( trig )
						  Mode.Current = "Record";
				  });

Mode.addProperty( "MobileTV",
				  function ():Boolean {
					  return ( Mode.Current == "MobileTV" );
				  },
				  function ( trig:Boolean ):Void {
					  if ( trig )
						  Mode.Current = "MobileTV";
				  });

Mode.addProperty( "Flash",
				  function ():Boolean {
					  return ( Mode.Current == "Flash" );
				  },
				  function ( trig:Boolean ):Void {
					  if ( trig )
						  Mode.Current = "Flash";
				  });

Mode.addProperty( "Text",
				  function ():Boolean {
					  return ( Mode.Current == "Text" );
				  },
				  function ( trig:Boolean ):Void {
					  if ( trig )
						  Mode.Current = "Text";
				  });

Mode.addProperty( "Picture",
				  function ():Boolean {
					  return ( Mode.Current == "Picture" );
				  },
				  function ( trig:Boolean ):Void {
					  if ( trig )
						  Mode.Current = "Picture";
				  });

Mode.addProperty( "Dictionary",
				  function ():Boolean {
					  return ( Mode.Current == "Dictionary" );
				  },
				  function ( trig:Boolean ):Void {
					  if ( trig )
						  Mode.Current = "Dictionary";
				  });


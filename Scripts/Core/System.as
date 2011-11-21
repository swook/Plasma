/*
 *    _____         _______ _______ _______ _______
 *   |_____] |      |_____| |______ |  |  | |_____|
 *   |       |_____ |     | ______| |  |  | |     |
 *
 * File: Core/System.as
 * System Settings Control
 */

// System.capabilities.os: OEM
// System.capabilities.manufacturer: neomtel
// System.capabilities.version: 7

var Sys:Object = {};
Sys.state = ext_fscommand2( "GetEtcState" );

/*
 * Property: Sys.device
 * Returns current device's name
 *
 * Get:
 *     Device Name as String (S9/i9/etc)
 *
 * Set:
 *     None
 *
 * See also:
 *     <Sys.checkDevice>
 */
Sys.addProperty( "device",
				 function ():String {
					 var check = Plasma.Data.Get( "Device" );					// Has device been detected?
					 if ( !check )
						 check = Sys.checkDevice();							// If not detect device
					 return Sys.deviceNameFromID( check );
				 },
				 function ():Void {} );											// Do nothing on set


/*
 * Method: Sys.checkDevice
 * Checks and saves what the current device is.
 *
 * Checking is done via bitwise AND comparisons.
 * There are 5 bits used for each device in the following order: S9, i9, J3, X7, C2.
 *
 * Parameters:
 *     Void
 *
 * Returns:
 *     Returns result of bitwise AND comparison
 *
 * See also:
 *     <Sys.device>
 */
Sys.checkDevice = function ():Number {
	// Initialise for all devices
	// 11111
	var check:Number = 31;

	// 01111 - All except S9
	check = ( false)?//ext_fscommand2( "GetEtcSpeakerOn" ) == -1 ) ?
			( check & ~15 ) : ( check & 15 );

	// 00100 - Just the J3
	check = ( true)?//ext_fscommand2( "GetEtcVolumeBoost" ) == -1 ) ?
			( check & ~4 ) : ( check & 4 );

	// 00010 - Just the X7
	check = ( true)?//ext_fscommand2( "GetEtcHorUIRotation" ) == -1 ) ?
			( check & ~2 ) : ( check & 2 );

	// 00001 - Just the C2
	check = ( true)?//ext_fscommand2( "GetSysDisplayRotation" ) == -1 ) ?
			( check & ~1 ) : ( check & 1 );

	Plasma.Data.Set( "Device", check );
	return check;
}

Sys.deviceNameFromID = function ( i:Number ):String {
	switch ( i ) {
		case 16: return "S9";
		case 8: return "i9";
		case 4: return "J3";
		case 2: return "X7";
		case 1: return "C2";
	}
}

/*
 * Property: Sys.S9
 * Returns a boolean describing the current device
 *
 * Returns:
 *     true if device is S9, false if device is not S9
 *
 * See also:
 *     <Sys.device>, <Sys.checkDevice>, <Sys.i9>, <Sys.J3>, <Sys.X7>, <Sys.C2>
 */
Sys.addProperty( "S9",
				 function ():Boolean { return Plasma.Data.Get( "Device" ) == 16; },
				 function ():Void {} );

/*
 * Property: Sys.i9
 * Returns a boolean describing the current device
 *
 * Returns:
 *     true if device is i9, false if device is not i9
 *
 * See also:
 *     <Sys.device>, <Sys.checkDevice>, <Sys.S9>, <Sys.J3>, <Sys.X7>, <Sys.C2>
 */
Sys.addProperty( "i9",
				 function ():Boolean { return Plasma.Data.Get( "Device" ) == 8; },
				 function ():Void {} );

/*
 * Property: Sys.J3
 * Returns a boolean describing the current device
 *
 * Returns:
 *     true if device is J3, false if device is not J3
 *
 * See also:
 *     <Sys.device>, <Sys.checkDevice>, <Sys.S9>, <Sys.i9>, <Sys.X7>, <Sys.C2>
 */
Sys.addProperty( "J3",
				 function ():Boolean { return Plasma.Data.Get( "Device" ) == 4; },
				 function ():Void {} );

/*
 * Property: Sys.X7
 * Returns a boolean describing the current device
 *
 * Returns:
 *     true if device is X7, false if device is not X7
 *
 * See also:
 *     <Sys.device>, <Sys.checkDevice>, <Sys.S9>, <Sys.i9>, <Sys.J3>, <Sys.C2>
 */
Sys.addProperty( "X7",
				 function ():Boolean { return Plasma.Data.Get( "Device" ) == 2; },
				 function ():Void {} );

/*
 * Property: Sys.C2
 * Returns a boolean describing the current device
 *
 * Returns:
 *     true if device is C2, false if device is not C2
 *
 * See also:
 *     <Sys.device>, <Sys.checkDevice>, <Sys.S9>, <Sys.i9>, <Sys.J3>, <Sys.X7>
 */
Sys.addProperty( "C2",
				 function ():Boolean { return Plasma.Data.Get( "Device" ) == 1; },
				 function ():Void {} );


Sys.Firmware = {};
Sys.Firmware.index = {
	S9: [ "Korea", "International", "DMB", "Norway_DMB" ],
	i9: [ "General" ],
	J3: [ "Korea", "International", "DMB", "Vokhan" ],
	X7: [ "Korea", "International" ],
	C2: [ "General" ]
};
Sys.Firmware.addProperty( "version",
						  function ():String {
							  if ( !Sys.Firmware.version_ ) {
								  var result:String;
								  ext_fscommand2( "GetSysVersion", "result" );
								  result = "3.34b";
								  if ( result == -1 ) return;

								  var len:Number = result.length;
								  var type:Number = int( result.charAt( 0 ) );
								  Sys.Firmware.version_ = result;
								  Sys.Firmware.type_ = ( type == 0 ) ? 1 : type;
							}
							return Sys.Firmware.version_;
						  },
						  function ():Void {} );

Sys.Firmware.addProperty( "type",
						  function ():String {
							  if ( !Sys.Firmware.version ) return;
							  return Sys.Firmware.index[ Sys.device

							][ Sys.Firmware.type_ - 1 ];
						  },
						  function ():Void {} );

Sys.Firmware.addProperty( "typeNum",
						  function ():Number {
							  if ( !Sys.Firmware.version ) return;
							  return Sys.Firmware.type_;
						  },
						  function ():Void {} );

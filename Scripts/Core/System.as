/*
 *    _____         _______ _______ _______ _______
 *   |_____] |      |_____| |______ |  |  | |_____|
 *   |       |_____ |     | ______| |  |  | |     |
 *
 *   Core/System.as - System Settings Control
 */

// System.capabilities.os: OEM
// System.capabilities.manufacturer: neomtel
// System.capabilities.version: 7

var Sys:Object = {};
Sys.State = ext_fscommand2( "GetEtcState" );
Sys.addProperty( "Device",
				 function ():String {
					 var device = Plasma.Data.Get( "Device" );					// Has device been detected?
					 if ( !device )
						 device = Sys.CheckDevice();							// If not detect device
					 return device;
				 },
				 function ():Void {} );											// Do nothing on set

// Manually re-check device
Sys.CheckDevice = function ():String {
	var device:String;
	if ( ext_fscommand2( "GetEtcSpeakerOn" ) == -1 )
		device = "S9";
	else if ( ext_fscommand2( "GetEtcVolumeBoost" ) != -1 )
		device = "J3";
	else if ( ext_fscommand2( "GetEtcHorUIRotation" ) != -1 )
		device = "X7";
	else if ( ext_fscommand2( "GetSysDisplayRotation" ) != -1 )
		device = "C2";
	else
		device = "i9";
	Plasma.Data.Set( "Device", device );
	return device;
}

Sys.addProperty( "S9",
				 function ():Boolean { return Sys.Device == "S9"; },
				 function ():Void {} );
Sys.addProperty( "i9",
				 function ():Boolean { return Sys.Device == "i9"; },
				 function ():Void {} );
Sys.addProperty( "J3",
				 function ():Boolean { return Sys.Device == "J3"; },
				 function ():Void {} );
Sys.addProperty( "X7",
				 function ():Boolean { return Sys.Device == "X7"; },
				 function ():Void {} );
Sys.addProperty( "C2",
				 function ():Boolean { return Sys.Device == "C2"; },
				 function ():Void {} );


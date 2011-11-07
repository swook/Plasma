
/*
 *    _____         _______ _______ _______ _______
 *   |_____] |      |_____| |______ |  |  | |_____|
 *   |       |_____ |     | ______| |  |  | |     |
 *
 *   Core/Music.as - Core Volume Control Functionality
 */

var Volume:Object = {};
Volume.addProperty( "Value",
					function ():Number {
						return Volume.Value_;
					},
					function ( num:Number ):Void {
						if ( !isNaN( Volume.Value_ ) ) Volume.Update();
						var diff:Number = num - Volume.Value_;
						var cmd:String;
						if ( diff > 0 ) cmd = "KeyComPlus";						// S9, J3, X7, i9, C2
						else if ( diff < 0 ) {
							cmd = "KeyComMinus";								// S9, J3, X7, i9, C2
							diff = -diff;
						}

						var result:Number;
						for ( ; diff > 0; diff-- ) {
							result = ext_fscommand2( cmd );
							if ( result == -1 ) break;
						}

						if ( result == -1 )
							Volume.Update();
						else {
							Volume.Value_ = result;
							Volume.DisplayUpdate();
						}
					});

Volume.Mute = function ():Void {
	if ( Volume.Value == 0 && Volume.MuteValue ) {
		Volume.Value = Volume.MuteValue;
		Volume.MuteValue = 0;
	}
	else if ( Volume.Value > 0 ) {
		Volume.MuteValue = Volume.Value;
		Volume.Value = 0;
	}
}

Volume.Update = function ():Boolean {
	var result:Number = ext_fscommand2( "GetEtcVolume" );						// S9, J3
	if ( result != -1 ) {
		Volume.Value_ = result;
		Volume.DisplayUpdate();
		return true;
	}
	return false;
}

Volume.DisplayUpdate = function ():Void {
	Main.tVolume = Volume.Value;
	if ( Volume.Value == 0 ) {
		Main.Volume._visible = false;
		GMain.Muted._visible = true;
	}
	else {
		Main.Volume._visible = true;
		GMain.Muted._visible = false;
	}
	GMain.gVolumeSize._xscale = 1.6 * Volume.Value;
	GMain.gVolumeSize._yscale = 50 + 0.5 * Volume.Value;
}


// 0: Headphones
// 1: Speaker
// 2: Bluetooth

Volume.CheckDevice = function ():Void {
	var init:Boolean = ( Volume.Device == null );
	var result:Number = ext_fscommand2( "GetEtcAudioOutDevice" );				// J3, X7

	if ( result == -1 && !init ) return;

	if ( !init ) Volume.PrevDevice = Volume.Device;
	Volume.Device = ( result == -1 ) ? 0 : result;

	if ( Volume.Device != Volume.PrevDevice ) {
		Volume.Headphone = false;
		Volume.Speaker = false;
		Volume.Bluetooth = false;

		switch ( Volume.Device ) {
			case 0:
				Volume.Headphone = true;
				break;
			case 1:
				Volume.Speaker = true;
				break;
			case 2:
				Volume.Bluetooth = true;
				break;
		}
	}
	Volume.Update();
}
Volume.CheckDevice();

/*
 *    _____         _______ _______ _______ _______
 *   |_____] |      |_____| |______ |  |  | |_____|
 *   |       |_____ |     | ______| |  |  | |     |
 *
 *   Core/Key.as - Key Input Handling
 */


var onKey:Object = {};
onKey.HoldState = ( ext_fscommand2("GetSysHoldKey") == 1 ) ? true : false;

onKey.Handler = function ( KeyCode:Number ):Void {
	switch ( KeyCode ) {
		// Play (Short)
		case _global.KEY_PLAY_SHORT:											// Key 32 (Space)
			if ( onKey.PlayShort )
				onKey.PlayShort();
			else
				Music.PlayPause();												// Play/Pause by default
			break;

		// FF (Short)
		case _global.KEY_FF_SHORT:												// Key 37 (Left)
			if ( onKey.FFShort )
				onKey.FFShort();
			else
				Music.Next();													// Prev by default
			break;

		// Rew (Short)
		case _global.KEY_REW_SHORT:												// Key 39 (Right)
			if ( onKey.RewShort )
				onKey.RewShort();
			else
				Music.Prev();													// Next by default
			break;

		// Volume Up (Short)
		case _global.KEY_PLUS_SHORT:											// Key 38 (Up)
			if ( onKey.PlusShort )
				onKey.PlusShort();
			else
				Volume.Value++;													// Inc Vol by default
			break;

		// Volume Down (Short)
		case _global.KEY_MINUS_SHORT:											// Key 40 (Down)
			if ( onKey.MinusShort )
				onKey.MinusShort();
			else
				Volume.Value--;													// Dec Vol by default
			break;

		// Play (Long)
		case _global.KEY_PLAY_LONG:												// Key 32 (Space)
			if ( onKey.PlayLong )
				onKey.PlayLong();
			else
				_global.LoadSWF( _global.MODE_MAIN );							// Return to main by default
			break;

		// FF (Long)
		case _global.KEY_FF_LONG:												// Key 37 (Left)
			if ( onKey.FFLong )
				onKey.FFLong();
			else
				Music.FF();														// Rew by default
			break;

		// Volume Up (Long)
		case _global.KEY_PLUS_LONG:												// Key 38 (Up)
			if ( onKey.PlusLong )
				onKey.PlusLong();
			else
				Volume.Value++;													// Inc Vol by default
			break;

		// Rew (Long)
		case _global.KEY_REW_LONG:												// Key 39 (Right)
			if ( onKey.RewLong )
				onKey.RewLong();
			else
				Music.Rew();													// FF by default
			break;

		// Volume Down (Long)
		case _global.KEY_MINUS_LONG:											// Key 40 (Down)
			if ( onKey.MinusLong )
				onKey.MinusLong();
			else
				Volume.Value--;													// Dec Vol by default
			break;

		// Rotation to 0, 90, 180, 270 degrees
		case _global.KEY_DISPLAY_ROTATE:										// 122 Key (F11)
			break;

		// Display Update (Speaker, Track, Screen, Bluetooth etc change)
		case _global.KEY_DISPLAY_UPDATE:										// 123 Key (F12)
			onDisplayUpdate();
			break;

		// Hold Key
		case _global.KEY_HOLD:													// 145 Key (Scroll Lock)
			onKey.HoldState = !onKey.HoldState;
			if ( onKey.HoldState ) {
				if ( onKey.Hold )
					onKey.Hold();
			}
			else if ( onKey.Unhold ) {
				onKey.Unhold();
			}
			break;
	}
}


Queue.onDisplayUpdate = [];
function onDisplayUpdate ( func:Function ):Void {
	if ( func ) {
		Queue.onDisplayUpdate.push( func );
	}
	else {
		var len:Number = Queue.onDisplayUpdate.length;
		for ( var i:Number = 0; i < len; i++ )
			Queue.onDisplayUpdate[ i ]();
	}
}

/*
 *    _____         _______ _______ _______ _______
 *   |_____] |      |_____| |______ |  |  | |_____|
 *   |       |_____ |     | ______| |  |  | |     |
 *
 *   Core/Utility.as - Core Utility Functions
 */

var Misc:Object = {};

Misc.Math = {};
Misc.Math.highest = function ( arr:Array ) {
	var len:Number = arr.length;
	if ( len == 0 ) return;
	var num:Number = arr[ 0 ];
	if ( len == 1 ) return num;
	for ( var idx:Number = 1; idx < len; idx++ ) {
		if ( arr[ idx ] > num ) num = arr[ idx ];
	}
	return num;
}

Misc.Math.absInt = function ( x:Number ):Number {
	return ( x ^ ( x >> 31 ) ) - ( x >> 31 );
}

Misc.Math.equalSign = function ( x1:Number, x2:Number ):Number {
	return x1 ^ x2 >= 0;
}

Misc.Math.mod = function ( x:Number, m:Number ):Number {
	x = x >> 0;
	m = m >> 0;
	if ( ( m & ( m - 1 ) ) == 0 )
		return x & ( m - 1 );
	else
		return x % m;
}


/* CACHE ext_fscommand2 CALL RESULTS */
var fscache:Array = new Array();
function fscmd_cache ( cmd:String, dur:Number ) {
	dur = dur ? dur : 150;
	if ( fscache[ cmd ] && ( Time.Ticks - fscache[ cmd ].LastChecked ) < 150 ) {
		return fscache[ cmd ].Data;
	}
	if ( !fscache[ cmd ] ) {
		var cache:Object = new Object()
		fscache[ cmd ] = cache;
	}
	var newdata = ext_fscommand2( cmd );
	if ( cmd == "GetAudPlayTime" ) {
		if ( !fscache[ cmd ].Data || fscache[ cmd ].Data != newdata ) {
			fscache[ cmd ].Data = newdata;
			fscache[ cmd ].LastChecked = Time.Ticks;
		}
	}
	else {
		fscache[ cmd ].Data = newdata;
		fscache[ cmd ].LastChecked = Time.Ticks;
	}
	return fscache[ cmd ].Data;
}

/*
 * Unloading Handling
 * - Queue funcs in array
 */

Queue.onUnload = [];
onUnload = function ( func:Function ):Void {
	if ( func ) {
		Queue.onUnload.push( func );
	}
	else {
		var len:Number = Queue.onUnload.length;
		for ( var i:Number = 0; i < len; i++ )
			Queue.onUnload[ i ]();
		Data.Unload();
	}
}

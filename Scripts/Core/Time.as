/*
 *    _____         _______ _______ _______ _______
 *   |_____] |      |_____| |______ |  |  | |_____|
 *   |       |_____ |     | ______| |  |  | |     |
 *
 *   Core/Time.as - Time and Periodic Script Management
 */

/* TIME MANAGEMENT */
var Time:Object = {};
Time.Ticks = getTimer();

Time.Conv = {};
Time.Conv.Text_mmss = function ( secs ):String {
	secs = secs >> 0;
	return ( ( ( secs >> 2 ) / 15 ) >> 0 )										// minutes = secs / 60
		   + ":"
		   + Time.Conv.Num_2Dig( Misc.Math.mod( secs, 60 ) );
}
Time.Conv.Text_hhmmss = function ( secs ):String {
	var hr:Number = ( ( ( secs >> 4 ) / 225 ) >> 0 );
	secs = secs >> 0;
	return Time.Conv.Num_2Dig( hr ) + ":"										// hour = secs / 3600
		   + Time.Conv.Num_2Dig( ( ( ( secs - ( hr << 4 ) * 225 ) >> 2 ) / 15 ) >> 0 )
		   + ":"
		   + Time.Conv.Num_2Dig( secs % 60 );
}
Time.Conv.Num_2Dig = function ( num ):String { return ( num < 10 ) ? "0" + num : num; }


// The following runs every 1 / FRAMERATE seconds. For the default loader, fps is 24fps.
// This gives you an onEnterFrame trigger interval of 42ms (This runs every 42ms)
// This also means that you cannot set intervals shorter than 42ms. You should not need to.
onEnterFrame = function ():Void
{
	Time.Ticks = getTimer();

	var pobj:Object;
	for ( var idx in Time.PeriodicQueue ) {
		pobj = Time.PeriodicQueue[ idx ];
		if ( pobj.Prev && ( Time.Ticks - pobj.Prev ) < pobj.Interval )
				continue;
		pobj.Prev = Time.Ticks
		pobj.Function();
	}
}

// Interval in milliseconds
Time.PeriodicQueue = new Array();
Do_Periodic = function ( dur:Number, func:Function ):Void {
	var obj:Object = new Object();
	dur = ( dur ) ? dur : 1000;													// If duration not set, set to 1000ms = 1s
	obj.Interval = dur;
	obj.Function = func;
	Time.PeriodicQueue.push( obj );
}

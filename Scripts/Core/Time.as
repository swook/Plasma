/*
 *    _____         _______ _______ _______ _______
 *   |_____] |      |_____| |______ |  |  | |_____|
 *   |       |_____ |     | ______| |  |  | |     |
 *
 *   Core/Time.as - Time and Periodic Script Management
 */

import mx.transitions.OnEnterFrameBeacon;
OnEnterFrameBeacon.init();

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


// The following runs every 1 / FRAMERATE seconds. For Plasma, fps is 25fps.
// This gives you an onEnterFrame trigger interval of 40ms (This runs every 40ms)
// This also means that you cannot set intervals shorter than 40ms and should not need to.
Time.onEnterFrame = function ():Void
{
	Time.Ticks = getTimer();

	var pobj:Object, len:Number = Queue.Periodic.length;
	for ( var i:Number = 0; i < len; i++ ) {
		pobj = Queue.Periodic[ i ];
		if ( pobj.last_t && ( Time.Ticks - pobj.last_t ) < pobj.interval )
				continue;
		pobj.last_t = Time.Ticks
		pobj.func();
	}
}
MovieClip.addListener( Time );

// Interval in milliseconds
Queue.Periodic = [];
function Periodic ( dur:Number, func:Function ):Void {
	if ( func == undefined ) return;
	Queue.Periodic.push( {
		interval: ( dur ) ? dur : 1000,												// If duration not set, set to 1000ms = 1s
		func: func
	} );
}

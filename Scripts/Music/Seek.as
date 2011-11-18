/*
 *    _____         _______ _______ _______ _______
 *   |_____] |      |_____| |______ |  |  | |_____|
 *   |       |_____ |     | ______| |  |  | |     |
 *
 *   Music/Seek.as - Methods for calculating and setting seek pos
 */

Music.pos = {};

Music.pos.addProperty( "ms",
					   function ():Number {
						   if ( Music.pos.cache == undefined )
							   Music.pos.reset();
						   return Music.pos.current + Music.pos.offset.current;
					   },
					   function ( pos:Number ):Void {
						   Music.pos.set( pos );
					   } );


Music.pos.addProperty( "s",
					    function ():Number {
							return Music.pos.current;
						},
					    function ( pos:Number ):Void {
						    Music.pos.set( pos );
						} );

Music.pos.addProperty( "current",
					   function ():Number {
							   var ds:Number = ( ( ( Time.Ticks - Music.pos.cache_ticks ) / 1000 ) >> 0 ) * 1000;
							   return Music.pos.cache + ds;
					   },
					   function ():Void {} );

Music.pos.reset = function ():Void {
	Music.pos.cache = ext_fscommand2( "GetAudPlayTime" );
	Music.pos.cache_ticks = Time.Ticks;
	Music.pos.offset.reset();
}

Music.pos.set = function ( pos:Number ):Void {
	pos = pos >> 0;
	var diff:Number = pos - Music.pos.current;
	if ( diff == 1 || diff == -1 ) {											// If Music.pos++ or Music.pos--
		if ( diff == 1 ) Music.FF();
		else Music.Rew();
		return;
	}

	if ( pos < 0 ) {
		Music.Prev();
		Music.Update();
		Music.pos.set( Music.Length - pos );
		return;
	}
	else if ( pos > Music.Length ) {
		Music.Next();
		Music.Update();
		Music.pos.set( pos - Music.Length );
		return;
	}

	if ( ext_fscommand2( "KeyAudDirectSeek", pos ) == 1 ) { // All Players
		Music.pos.cache = pos;
		Music.pos.cache_ticks = Time.Ticks;
		Music.pos.offset.reset();
	}
}

Music.pos.offset = {};
Music.pos.offset.reset = function ():Void {
	Music.pos.offset.value = getTimer() % 1000;
}

Music.pos.offset.addProperty( "current",
							  function ():Number {
								  if ( Music.pos.offset.ticks != Time.Ticks ) {
									  var ticks:Number = Time.Ticks % 1000;
									  var now:Number = Music.pos.offset.msFromDiff( ticks - Music.pos.offset.value );
									  Music.pos.offset.cache = now;
									  Music.pos.offset.ticks = Time.Ticks
								  }
								  return Music.pos.offset.cache;
							  },
							  function ():Void {} );

Music.pos.offset.msFromDiff = function ( ms:Number ):Number {
	var neg:Boolean = false;
	ms = ms >> 0;																// equiv. int
	if ( ms < 0 ) neg = true;
	ms = ( ms ^ ( ms >> 31 ) ) - ( ms >> 31 );									// equiv. Math.asb
	if ( ms < 1000 ) return ( neg ) ? 1000 - ms : ms;
	ms = ms - ( ( ( ( ms >> 3 ) / 125 ) >> 0 ) << 3 ) * 125;
	if ( neg ) return 1000 - ms;
	return ( neg ) ? 1000 - ms : ms;
}

Music.pos.reset();
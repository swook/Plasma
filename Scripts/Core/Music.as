/*
 *    _____         _______ _______ _______ _______
 *   |_____] |      |_____| |______ |  |  | |_____|
 *   |       |_____ |     | ______| |  |  | |     |
 *
 *   Core/Music.as - Core Music Functionality
 */

var Music:Object = {};

Music.addProperty( "playState",
				   function ():Boolean {
					   return ( Sys.state == 1 ) ? true : false;
				   },
				   function ( state:Boolean ):Void {
					   if ( Mode.Music ) Sys.state = ( state ) ? 1 : 2;
				   } );

Music.playPause = function ():Boolean {
	if ( Music.playState )
		return Music.pause();
	else
		return Music.play();
}

Music.play = function ():Boolean {
	if ( !Music.playState ) {			// All Players | J3, X7, C2
		var music:Boolean = Mode.Music;
		Music.pos.set( Music.pos.s );

		var cmd:String = ( music ) ? "KeyAudPlay" : "KeyComShortPlay";
		if ( ext_fscommand2( cmd ) == 1 ) {
			Music.pos.offset.reset();
			Music.playState = true;
			return true;
		}
	}
	return false;
}

Music.pause = function ():Boolean {
	if ( Music.playState ) {             // All Players | J3, X7, C2
		var cmd:String = ( Mode.Music ) ? "KeyAudPause" : "KeyComShortPlay";
		if ( ext_fscommand2( cmd ) == 1 ) {
			Music.playState = false;
			return true;
		}
	}
	return false;
}

Music.prev = function ():Boolean {  // All Players     | J3, X7, C2
	var cmd:String = ( Mode.Music ) ? "KeyAudShortREW" : "KeyComShortREW";
	if ( ext_fscommand2( cmd ) == 1 ) {
		if ( Mode.Music ) {
			if ( !Music.playState )
				Music.Update();
			Music.pos_ = 0;
			Music.posOffset = ( getTimer() % 1000 );
		}
		return true;
	}
	return false;
}

Music.Next = function ():Boolean {  // All Players    | J3, X7, C2
	var cmd:String = ( Mode.Music ) ? "KeyAudShortFF" : "KeyComShortFF";
	if ( ext_fscommand2( cmd ) == 1 ) {
		if ( Mode.Music ) {
			if ( !Music.playState )
				Music.Update();
			Music.pos_ = 0;
			Music.posOffset = ( getTimer() % 1000 );
		}
		return true;
	}
	return false;
}

Music.Rew = function ():Boolean {  // All Players     | J3, X7, C2
	var cmd:String = ( Mode.Music ) ? "KeyAudLongREW" : "KeyComLongREW";
	if ( ext_fscommand2( cmd ) == 1 )
		return true;
	return false;
}

Music.FF = function ():Boolean {  // All Players     | J3, X7, C2
	var cmd:String = ( Mode.Music ) ? "KeyAudLongFF" : "KeyComLongFF";
	if ( ext_fscommand2( cmd ) == 1 )
		return true;
	return false;
}

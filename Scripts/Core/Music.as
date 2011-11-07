/*
 *    _____         _______ _______ _______ _______
 *   |_____] |      |_____| |______ |  |  | |_____|
 *   |       |_____ |     | ______| |  |  | |     |
 *
 *   Core/Music.as - Core Music Functionality
 */

var Music:Object = {};

Music.addProperty( "PlayState",
				   function ():Boolean {
					   return ( Sys.State == 1 ) ? true : false;
				   },
				   function ( state:Boolean ):Void {
					   if ( Mode.Music ) Sys.State = ( state ) ? 1 : 2;
				   } );

Music.PlayPause = function ():Boolean {
	if ( Music.PlayState )
		return Music.Pause();
	else
		return Music.Play();
}

Music.Play = function ():Boolean {
	if ( !Music.PlayState ) {			// All Players | J3, X7, C2
		var music:Boolean = Mode.Music;
		var setoffset:Boolean, updateoffset:Boolean;
		if ( music ) {
			if ( Music.PosOffset == undefined ) setoffset = true;
			else updateoffset = true;
		}
		if ( setoffset ) Music.Pos = Music.Pos;

		var cmd:String = ( music ) ? "KeyAudPlay" : "KeyComShortPlay";
		if ( ext_fscommand2( cmd ) == 1 ) {
			Music.PlayState = true;
			if ( setoffset ) Music.PosOffset = ( getTimer() % 1000 );
			if ( updateoffset ) Music.PosOffset
			return true;
		}
	}
	return false;
}

Music.Pause = function ():Boolean {
	if ( Music.PlayState ) {             // All Players | J3, X7, C2
		var cmd:String = ( Mode.Music ) ? "KeyAudPause" : "KeyComShortPlay";
		if ( ext_fscommand2( cmd ) == 1 ) {
			Music.PlayState = false;
			return true;
		}
	}
	return false;
}

Music.Prev = function ():Boolean {  // All Players     | J3, X7, C2
	var cmd:String = ( Mode.Music ) ? "KeyAudShortREW" : "KeyComShortREW";
	if ( ext_fscommand2( cmd ) == 1 ) {
		if ( Mode.Music ) {
			if ( !Music.PlayState )
				Music.Update();
			Music.Pos_ = 0;
			Music.PosOffset = ( getTimer() % 1000 );
		}
		return true;
	}
	return false;
}

Music.Next = function ():Boolean {  // All Players    | J3, X7, C2
	var cmd:String = ( Mode.Music ) ? "KeyAudShortFF" : "KeyComShortFF";
	if ( ext_fscommand2( cmd ) == 1 ) {
		if ( Mode.Music ) {
			if ( !Music.PlayState )
				Music.Update();
			Music.Pos_ = 0;
			Music.PosOffset = ( getTimer() % 1000 );
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

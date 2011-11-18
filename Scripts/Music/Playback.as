/*
 *    _____         _______ _______ _______ _______
 *   |_____] |      |_____| |______ |  |  | |_____|
 *   |       |_____ |     | ______| |  |  | |     |
 *
 *   Music/Playback.as - Music Control Management
 */

// NOTE: Playback control functions such as Play,Pause,Rew,FF are in Core/Music.as


Music.Stop = function ():Boolean {
	if ( Music.playState && Mode.Music ) {
		if ( ext_fscommand2( "KeyAudStop" ) == 1 ) {						// All Players
			Music.playState = false;
			return true;
		}
	}
	return false;
}

Music.UpdateState = function ():Void {
	if ( !Album.playPausePressed )
		mAlbum.playPause.gotoAndStop( Music.playState ? 2 : 1 );
}

Music.pSpeed = function ():Number { return fscmd_cache( "GetAudPSpeed", 1000 ); }
Music.SetPSpeed = function ( num:Number ):Void {
	if ( num == Music.pSpeed() ) return;
	var result:Number = ext_fscommand2( "SetAudPSpeed", num );
	if ( result != -1 ) fscache[ "GetAudPSpeed" ].Data = result;
}

Music.addProperty ( "Length",
					function ():Number {
						if ( !Music.Length_ ) {
							Music.Length_ = ext_fscommand2( "GetAudTotalTime" );
							Main.Seeker.Cur.tTotTime = ConvSecToTime( Music.Length_ );
						}
						return Music.Length_;
					},
					function ( len:Number ):Void {
						Music.Length_ = len;
						Main.Seeker.Cur.tTotTime = ConvSecToTime( Music.Length );
					} );

var curIdx:Number = ext_fscommand2("GetEtcCurPLIndex");
Music.UpdateInfo	= function ():Void {
	ext_fscommand2("GetAudTitle", curIdx, "Music.Title");
	ext_fscommand2("GetAudAlbum", curIdx, "Music.Album");
	ext_fscommand2("GetAudArtist", curIdx, "Music.Artist");
	Main.tTitle = Music.Title;
	Main.tAlbum = Music.Album;
	Main.tArtist = Music.Artist;
	Music.posReset();
	Music.msSeek.reset();
	Music.Length = ext_fscommand2( "GetAudTotalTime" );
	Music.prevpos = null;
}
Music.UpdateFileName = function():Void {
	curIdx = ext_fscommand2("GetEtcCurPLIndex");
	ext_fscommand2("GetEtcFileName", curIdx, "Music.Filename");
}


Music.Update = function ():Void {
	Music.UpdateFileName();
	if ( Music.prevFilename != Music.Filename ) {
		Music.UpdateInfo();
		Music.prevFilename = Music.Filename;

		// Load new album art
		if ( Music.prevAlbum != Music.Album ) {
			Album.Next();
			Music.prevAlbum = Music.Album;
		}
	}
	Music.UpdateState();
}
Music.Update();
onDisplayUpdate( Music.Update );


Queue.onTrackChange = [];
onTrackChange = function ( func:Function ):Void {
	if ( func ) {
		Queue.onTrackChange.push( func );
	}
	else {
		var len:Number = Queue.onTrackChange.length;
		for ( var i:Number = 0; i < len; i++ )
			onTrackChangeQueue[ i ]();
	}
}

function UpdateSeeker ():Void {
	Main.Seeker.Cur.tCurTime = Time.Conv.Text_mmss( Music.intPos );
	if ( Music.Length == 0 )
		Main.Seeker.Cur._x = 0;
	else
		Main.Seeker.Cur._x = Music.pos / Music.Length * 272;
}
Periodic( 1, UpdateSeeker );
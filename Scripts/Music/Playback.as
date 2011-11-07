/*
 *    _____         _______ _______ _______ _______
 *   |_____] |      |_____| |______ |  |  | |_____|
 *   |       |_____ |     | ______| |  |  | |     |
 *
 *   Music/Playback.as - Music Control Management
 */

// NOTE: Playback control functions such as Play,Pause,Rew,FF are in Core/Music.as


Music.Stop = function ():Boolean {
	if ( Music.PlayState && Mode.Music ) {
		if ( ext_fscommand2( "KeyAudStop" ) == 1 ) {						// All Players
			Music.PlayState = false;
			Music.Pos_ = 0;
			return true;
		}
	}
	return false;
}

Music.addProperty ( "Pos",
					function ():Number {
						if ( Music.Pos_ == undefined ) {
							Music.Pos_ = ext_fscommand2( "GetAudPlayTime" );
						}
						var offset:Number = ( getTimer() % 1000 ) - Music.PosOffset;
						if ( offset < 0 ) offset += 1000;
						return Music.Pos_ + offset / 1000;
					},
					function ( pos:Number ):Void {
						var diff:Number = pos - Music.Pos_;
						if ( diff == 1 || diff == -1 ) {						// If Music.Pos++ or Music.Pos--
							if ( diff == 1 ) Music.FF();
							else Music.Rew();
							return;
						}

						pos = int( pos );
						if ( pos < 0 ) {
							Music.Prev();
							Music.Update();
							Music.Pos += pos;
							return;
						}
						else if ( pos > Music.Length ) {
							var newpos:Number = pos - Music.Length;
							Music.Next();
							Music.Update();
							Music.Pos = newpos;
							return;
						}

						if ( ext_fscommand2( "KeyAudDirectSeek", pos ) == 1 ) { // All Players
							Music.Pos_ = pos;
						}
					} );

Music.addProperty ( "IntPos",
					function ():Number {
						return Music.Pos;
					},
					function ( num:Number ):Void {
						Music.Pos = num;
					} );


Music.UpdateState = function ():Void {
	if ( !Album.PlayPausePressed )
		mAlbum.PlayPause.gotoAndStop( Music.PlayState ? 2 : 1 );
}

Music.PSpeed = function ():Number { return fscmd_cache( "GetAudPSpeed", 1000 ); }
Music.SetPSpeed = function ( num:Number ):Void {
	if ( num == Music.PSpeed() ) return;
	var result:Number = ext_fscommand2( "SetAudPSpeed", num );
	if ( result != -1 ) fscache[ "GetAudPSpeed" ].Data = result;
}

Music.Inc	= function ():Void { Music.FF(); }
Music.Dec	= function ():Void { Music.Rew(); }
// Music.Pos	= function ():Number {
// 	var pos:Number = fscmd_cache( "GetAudPlayTime", 100 );
// 	if ( Music.PlayState && fscache[ "GetAudPlayTime" ].LastChecked ) {
// 		var dt:Number = Time.Ticks - fscache[ "GetAudPlayTime" ].LastChecked;
// 		if ( dt < 1000 ) {
// 			pos += ( Time.Ticks - fscache[ "GetAudPlayTime" ].LastChecked ) * RatiofromPSpeed( Music.PSpeed() ) / 1000;
// 		}
// 	}
// 	return pos;
// }
Music.addProperty ( "Length",
					function ():Number {
						if ( !Music.LengthValue ) {
							Music.LengthValue = ext_fscommand2( "GetAudTotalTime" );
							Main.Seeker.Cur.tTotTime = ConvSecToTime( Music.LengthValue );
						}
						return Music.LengthValue;
					},
					function ( len:Number ):Void {
						Music.LengthValue = len;
						Main.Seeker.Cur.tTotTime = ConvSecToTime( Music.Length );
					} );


Music.IncPos = function ( num ):Void {
	num = num ? int( num ) : 1;
	num += Music.IntPos;
	if (num > Music.Length) Music.FF();
	else Music.Pos = num;
}
Music.DecPos = function ( num ):Void {
	num = num ? int( num ) : 1;
	num = Music.IntPos - num;
	if (num <= 0) {
		Music.Prev();
		Music.Pos = Music.Length + num - 1;
	}
	else Music.Pos = num;
}
var curIdx:Number = ext_fscommand2("GetEtcCurPLIndex");
Music.UpdateInfo	= function ():Void {
	ext_fscommand2("GetAudTitle", curIdx, "Music.Title");
	ext_fscommand2("GetAudAlbum", curIdx, "Music.Album");
	ext_fscommand2("GetAudArtist", curIdx, "Music.Artist");
	Main.tTitle = Music.Title;
	Main.tAlbum = Music.Album;
	Main.tArtist = Music.Artist;
	Music.Length = ext_fscommand2( "GetAudTotalTime" );
	Music.PrevPos = null;
}
Music.UpdateFileName = function():Void {
	curIdx = ext_fscommand2("GetEtcCurPLIndex");
	ext_fscommand2("GetEtcFileName", curIdx, "Music.Filename");
}


Music.Update = function ():Void {
	Music.UpdateFileName();
	if ( Music.PrevFilename != Music.Filename ) {
		Music.UpdateInfo();
		Music.PrevFilename = Music.Filename;

		// Load new album art
		if ( Music.PrevAlbum != Music.Album ) {
			Album.Next();
			Music.PrevAlbum = Music.Album;
		}
	}
	Music.UpdateState();
}
Music.Update();
Do_onDisplayUpdate( Music.Update );


var onTrackChangeQueue:Array = new Array();
Music.onTrackChange = function ():Void {
	for ( var i = 0; i < onTrackChangeQueue.length; i++ )
		onTrackChangeQueue[ i ]();
}

function Do_onTrackChange ( func:Function ):Void {
	onTrackChangeQueue.push( func );
}


function UpdateSeeker ():Void {
	var pos:Number = fscmd_cache( "GetAudPlayTime", 100 );
	if ( !isNaN( Music.PrevPos ) || pos != Music.PrevPos )
	{
		Main.Seeker.Cur.tCurTime = ConvSecToTime( pos );
		if ( Music.Length == 0 )
			Main.Seeker.Cur._x = 0;
		else
			Main.Seeker.Cur._x = Music.Pos / Music.Length * 272;
		Music.PrevPos = pos;
	}
}
Do_Periodic( 1, UpdateSeeker );
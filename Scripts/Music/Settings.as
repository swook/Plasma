/*
 *    _____         _______ _______ _______ _______
 *   |_____] |      |_____| |______ |  |  | |_____|
 *   |       |_____ |     | ______| |  |  | |     |
 *
 *   Music/Settings.as - Music Settings Management
 */

Music.SkipLengthData = [ 0, 2, 3, 4, 5, 10, 20, 30 ];
Music.addProperty( "SkipLength",
					   function ():Number {
						   if ( Music.SkipLength_ == undefined )			// All Players
							   Music.SkipLength_ = ext_fscommand2( "GetAudSkipLength" );
						   return Music.SkipLength_;
					   },
					   function ( num:Number ):Void {
						   if ( num < 0 || num > 7 ) return;
						   num = ext_fscommand2( "SetAudSkipLength" );
						   if ( num == -1 ) return
						   Music.SkipLength_ = num;
					   } );

Music.ScanSpeedData = [ 3, 5, 10, 20, 30 ];
Music.addProperty( "ScanSpeed",
					   function ():Number {
						   if ( Music.ScanSpeed_ == undefined )
							   Music.ScanSpeed_ = ext_fscommand2( "GetAudScanSpeed" );
						   return Music.ScanSpeed_;
					   },
					   function ( num:Number ):Void {
						   if ( num < 0 || num > 4 ) return;
						   num = ext_fscommand2( "SetAudScanSpeed" );
						   if ( num == -1 ) return
						   Music.ScanSpeed_ = num;
					   } );



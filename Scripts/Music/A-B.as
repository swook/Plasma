/*
 *    _____         _______ _______ _______ _______
 *   |_____] |      |_____| |______ |  |  | |_____|
 *   |       |_____ |     | ______| |  |  | |     |
 *
 *   Music/AB.as - AB Mode Management
 */

Music.ABMode = new Object();
Music.ABMode.addProperty ( "Current",
					   function ():Number {
						   if ( Music.ABMode.CurrentIdx == undefined ) {  // All Players
							   Music.ABMode.CurrentIdx = ext_fscommand2( "GetAudABMode" );
						   }
						   return Music.ABMode.CurrentIdx;
					   },
					   function ( num:Number ):Void {
						   // All Players
						   Music.ABMode.CurrentIdx = ext_fscommand2( "KeyAudABMode" );
						   switch ( Music.ABMode.CurrentIdx ) {
							   case 0:
								   delete Music.ABMode.A;
								   delete Music.ABMode.B;
								   break;
							   case 1:
								   Music.ABMode.A = Music.IntPos;
								   break;
							   case 2:
								   Music.ABMode.B = Music.IntPos;
								   break;
						   }
						   Music.onAB( Music.ABMode.CurrentIdx );
					   } );

Music.ABMode.Clear = function ():Void {
	ext_fscommand2( "KeyAudABModeClear" );		// All Players
}
Do_onUnload( Music.ABMode.Clear );
Do_onTrackChange( function ():Void {
	if ( Music.ABMode.CurrentIdx == 1 )
		Music.ABMode.Clear();
} );

Music.ABMode.addProperty ( "A",
						function ():Number {
							if ( Music.ABMode.CurrentIdx )
								return Music.ABMode.A;
							return null;
						},
						function ():Void {} );

Music.ABMode.addProperty ( "B",
						function ():Number {
							if ( Music.ABMode.CurrentIdx == 2 )
								return Music.ABMode.B;
							return null;
						},
						function ():Void {} );

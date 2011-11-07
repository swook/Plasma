/*
 *    _____         _______ _______ _______ _______
 *   |_____] |      |_____| |______ |  |  | |_____|
 *   |       |_____ |     | ______| |  |  | |     |
 *
 *   Core/JetEffect.as - JetEffect EQ Management
 */

var JetEffect:Object = {};
JetEffect.EQNames = [ "User 1", "User 2", "User 3", "User 4", "Normal", "BBE", "BBE ViVA", "BBE ViVA 2",
					  "BBE Mach3Bass", "BBE MP", "BBE Headphone", "BBE Headphone 2", "BBE Headphone 3",
					  "Rock", "Jazz", "Classic", "Ballad", "Pop", "Club", "Funk", "Hip Hop", "Techno",
					  "Blues", "Metal", "Dance", "Rap", "Wide", "X-Bass", "Hall", "Vocal", "Maestro",
					  "Feel the Wind", "Mild Shore", "Crystal Clear", "Reverb Room", "Reverb Club",
					  "Reverb Stage", "Reverb Hall", "Reverb Stadium" ];

JetEffect.addProperty( "Current",
					   function ():Number {
						   if ( JetEffect.Current_ == undefined ) {			// All Players
							   JetEffect.Current_ = ext_fscommand2( "GetJetEffectIndex" );
						   }
						   return JetEffect.Current_;
					   },
					   function ( num:Number ):Void {

					   } );

JetEffect.addProperty( "CurrentName",
					   function ():String {
						   return JetEffect.EQNames[ JetEffect.Current ];
					   },
					   function ( setting:String ):Void {
						   setting = setting.toLowerCase();
						   for ( var i:Number = 0; i < 39; i++ ) {
							   if ( setting == JetEffect.EQNames[ i ].toLowerCase() ) {
								   JetEffect.Current = i;
								   return;
							   }
						   }
					   } );

// Deal with user EQs
// Namely "User 1", "User 2", "User 3", "User 4"
JetEffect.User = {};
JetEffect.User.addProperty( "Current",
							function ():Number {
								if ( JetEffect.User.Current_ == undefined ) {			// All Players
									ext_fscommand2( "SetJetUserIndex", 1 );
									JetEffect.User.Current_ = ext_fscommand2( "GetJetUserIndex" );
								}
								return JetEffect.User.Current_;
							},
							function ( num:Number ):Void {

							} );

JetEffect.User.addProperty( "CurrentName",
							function ():String {
								return JetEffect.EQNames[ JetEffect.User.Current ];
							},
							function ( setting:String ):Void {
								setting = setting.toLowerCase();
								for ( var i:Number = 0; i < 4; i++ ) {
									if ( setting == JetEffect.EQNames[ i ].toLowerCase() ) {
										JetEffect.User.Current = i;
										return;
									}
								}
							} );

JetEffect.User.Update = function ():Void {
	var list:String = ext_fscommand2( "GetJetUserData", "list" );
	var settings:Array = list.split( "|" );
	JetEffect.User.BBE_ = int( settings[ 0 ] );
	JetEffect.User.M3B_ = int( settings[ 0 ] );
	JetEffect.User._3DS_ = int( settings[ 0 ] );
	JetEffect.User.MPE_ = ( settings[ 0 ] == "1" ) ? true : false;
}

JetEffect.User.addProperty( "BBE",
							function ():Number {
								if ( !JetEffect.User.BBE_ ) {
									JetEffect.User.BBE_ = ext_fscommand2( "GetJetUserBBE" );
								}
								return JetEffect.User.BBE_;
							},
							function ( num:Number ):Void {
							} );

JetEffect.User.addProperty( "M3B",
							function ():Number {
								if ( !JetEffect.User.M3B_ ) {
									JetEffect.User.M3B_ = ext_fscommand2( "GetJetUserM3B" );
								}
								return JetEffect.User.M3B_;
							},
							function ( num:Number ):Void {
							} );

JetEffect.User.addProperty( "_3DS",
							function ():Number {
								if ( !JetEffect.User._3DS_ ) {
									JetEffect.User._3DS_ = ext_fscommand2( "GetJetUser3DS" );
								}
								return JetEffect.User._3DS_;
							},
							function ( num:Number ):Void {
							} );

JetEffect.User.addProperty( "MPE",
							function ():Boolean {
								if ( !JetEffect.User.MPE_ ) {
									JetEffect.User.MPE_ = ext_fscommand2( "GetJetUserMPE" );
								}
								return JetEffect.User.MPE_;
							},
							function ( setting:Boolean ):Void {
							} );






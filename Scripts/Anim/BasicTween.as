/*
 *    _____         _______ _______ _______ _______
 *   |_____] |      |_____| |______ |  |  | |_____|
 *   |       |_____ |     | ______| |  |  | |     |
 *
 *   Anim/BasicTween.as - Basic Tween Management
 */

Anim.addProperty( "Speed",
				  function ():Number {
					  var setting:Number = Data.Get( "AnimSpeed" );
					  if ( isNaN( setting ) ) {
						  Data.Set( "AnimSpeed", 1 );
						  setting = 1;
					  }
					  return setting;
				  },
				  function ():Void {} );

Anim.TweenTo = function ( mc:MovieClip, property:String, target:Number,
						  speed:Number, ease:Function ):Void {
	speed = ( isNaN( speed ) ) ? 1.0 : speed;
	var dur:Number = speed * Anim.Speed;
	Anim.Tween( mc, property, ease, mc[ property ], target, dur );
}

Anim.FadeTo = function ( mc:MovieClip, targetalpha:Number, speed:Number ) {
	if ( isNaN( targetalpha ) || targetalpha < 0 || targetalpha > 100 )
		targetalpha = 0;
	speed = ( isNaN( speed ) ) ? 1.0 : speed;
	Anim.TweenTo( mc, "_alpha", targetalpha );
}

Anim.FadeIn = function ( mc:MovieClip, speed:Number ) {
	speed = ( isNaN( speed ) ) ? 1.0 : speed;
	mc._alpha = 0;
	Anim.TweenTo( mc, "_alpha", 100, speed );
}

Anim.FadeOut = function ( mc:MovieClip, speed:Number ) {
	speed = ( isNaN( speed ) ) ? 1.0 : speed;
	mc._alpha = 100;
	Anim.TweenTo( mc, "_alpha", 0, speed );
}


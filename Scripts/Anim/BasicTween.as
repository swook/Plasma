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

Anim.fadeTo = function ( targetalpha:Number, speed:Number ):Void {
	if ( isNaN( targetalpha ) || targetalpha < 0 || targetalpha > 100 )
		targetalpha = 0;
	speed = ( isNaN( speed ) ) ? 1.0 : speed;
	this.tweenTo( "_alpha", targetalpha, speed );
}
MovieClip.prototype.fadeTo = Anim.fadeTo;

Anim.fadeIn = function ( speed:Number ):Void {
	speed = ( isNaN( speed ) ) ? 1.0 : speed;
	this._alpha = 0;
	this.tweenTo( "_alpha", 100, speed );
}
MovieClip.prototype.fadeIn = Anim.fadeIn;

Anim.fadeOut = function ( speed:Number ):Void {
	speed = ( isNaN( speed ) ) ? 1.0 : speed;
	this._alpha = 100;
	this.tweenTo( "_alpha", 0, speed );
}
MovieClip.prototype.fadeOut = Anim.fadeOut;

// propo: Number with 1.0 being 100% increase
// axis: Array of two numbers, xcoord and ycoord of axis point
Anim.scale = function ( propo:Number, speed:Number, axis:Array ):Void {
	if ( !axis || axis.length != 2 ) axis = [ Void, Void ];
	var axischk:Array = [ !isNaN( axis[ 0 ] ), !isNaN( axis[ 1 ] ) ];
	axis[ 0 ] = ( axischk[ 0 ] ) ? axis[ 0 ] : this._x + ( this._width >> 1 );
	axis[ 1 ] = ( axischk[ 1 ] ) ? axis[ 1 ] : this._y + ( this._height >> 1 );

	var target:Array = [ 0, 0, 0, 0 ];
	propo += 1;
	target[ 0 ] = ( this._x - axis[ 0 ] ) * propo + axis[ 0 ];
	target[ 1 ] = ( this._y - axis[ 1 ] ) * propo + axis[ 1 ];
	target[ 2 ] = this._xscale * propo;
	target[ 3 ] = this._yscale * propo;
	this.tweenTo( "_x", target[ 0 ], speed );
	this.tweenTo( "_y", target[ 1 ], speed );
	this.tweenTo( "_xscale", target[ 2 ], speed );
	this.tweenTo( "_yscale", target[ 3 ], speed );
}
MovieClip.prototype.scale = Anim.scale;

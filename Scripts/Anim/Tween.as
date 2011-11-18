/*
 *    _____         _______ _______ _______ _______
 *   |_____] |      |_____| |______ |  |  | |_____|
 *   |       |_____ |     | ______| |  |  | |     |
 *
 *   Anim/Tween.as - Tweening Functionality
 */

AnimQueue.Tween = {};

Anim.tweenTo = function ( prop:String, endval:Number, speed:Number, easing:Function ):Void {
	var startval:Number = this[ prop ];
	if ( startval == endval ) return;
	speed = ( isNaN( speed ) ) ? 1.0 : speed;

	var idx:String = this._name +"."+ prop;
	if ( AnimQueue.Tween[ idx ] != undefined )
		delete AnimQueue.Tween[ idx ];

	this._visible = true;
	AnimQueue.Tween[ idx ] = {
		idx: idx,
		start_t: Time.Ticks,
		mc: this,
		prop: prop,
		begin: startval,
		change: endval - startval,
		end: endval,
		easing: ( easing ) ? easing : None.easeInOut,
		duration: speed * Anim.Speed * 1000
	};
}
MovieClip.prototype.tweenTo = Anim.tweenTo;


Anim.tween = function ( prop:String, startval:Number, endval:Number, speed:Number, ease:Function ):Void {
	this[ prop ] = startval;
	this.tweenTo( this, prop, endval, speed, ease );
}
MovieClip.prototype.tween = Anim.tween;

Anim.processTween = function ( tween:Object ):Void {
	if ( !tween.mc || !tween.mc._visible ) Anim.StopTween( tween.mc );

	var t:Number = Time.Ticks - tween.start_t;
	if ( t >= tween.duration ) {
		tween.mc[ tween.prop ] = tween.end;
		if ( tween.mc._alpha == 0 )
			tween.mc._visible = false;
		if ( tween.mc[ "onAnimEnd" ] != undefined )
			tween.mc[ "onAnimEnd" ]();
		delete AnimQueue.Tween[ tween.idx ];
		return;
	}
	tween.mc[ tween.prop ] = tween.easing( t, tween.begin, tween.change, tween.duration );
}

Anim.stopTween = function ( mc:MovieClip ):Void {
	var match:String;
	for ( var idx:String in AnimQueue.Tween ) {
		match = idx.substr( 0, idx.lastIndexOf( "." ) );
		if ( match == mc._name )
			delete AnimQueue.Tween[ idx ];
	}
}

Periodic( 1, function ():Void {
	var tween:Object;
	for ( var idx:String in AnimQueue.Tween ) {
		tween = AnimQueue.Tween[ idx ];
		Anim.processTween( tween );
	}
} );

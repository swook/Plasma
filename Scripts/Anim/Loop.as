/*
 *    _____         _______ _______ _______ _______
 *   |_____] |      |_____| |______ |  |  | |_____|
 *   |       |_____ |     | ______| |  |  | |     |
 *
 *   Anim/Loop.as - Looping Functionality
 */

AnimQueue.loop = {};

Anim.loop = function ( prop:String, startval:Number, endval:Number, speed:Number, easing:Function ):Void {
	if ( startval == endval ) return;
	speed = ( isNaN( speed ) ) ? 1.0 : speed;

	var idx:String = this._name +"."+ prop;
	if ( AnimQueue.loop[ idx ] != undefined )
		delete AnimQueue.loop[ idx ];

	this[ prop ] = startval;
	this._visible = true;

	AnimQueue.loop[ idx ] = {
		idx: idx,
		t: 0,
		last_t: Time.Ticks,
		mc: this,
		prop: prop,
		begin: startval,
		change: endval - startval,
		end: endval,
		easing: ( easing ) ? easing : None.easeInOut,
		duration: speed * Anim.Speed * 1000,
		direction: 1
	};
}
MovieClip.prototype.loop = Anim.loop;

Anim.processLoop = function ( loop:Object ):Void {
	if ( !loop.mc || !loop.mc._visible ) return;

	loop.t += Time.Ticks - loop.last_t;
	loop.last_t = Time.Ticks;
	if ( loop.t >= loop.duration ) {
		loop.direction = -loop.direction;
		loop.t = 0;
	}
	loop.mc[ loop.prop ] = loop.easing( loop.t, ( loop.direction > 0 ) ? loop.begin : loop.end,
										loop.direction * loop.change, loop.duration );
}

Anim.stopLoop = function ( mc:MovieClip ):Void {
	var match:String;
	for ( var idx:String in AnimQueue.loop ) {
		match = idx.substr( 0, idx.lastIndexOf( "." ) );
		if ( match == mc._name )
			delete AnimQueue.loop[ idx ];
	}
}

Periodic( 1, function ():Void {
	var loop:Object;
	for ( var idx:String in AnimQueue.loop ) {
		loop = AnimQueue.loop[ idx ];
		Anim.processLoop( loop );
	}
} );

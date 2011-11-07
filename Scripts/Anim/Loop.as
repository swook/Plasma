/*
 *    _____         _______ _______ _______ _______
 *   |_____] |      |_____| |______ |  |  | |_____|
 *   |       |_____ |     | ______| |  |  | |     |
 *
 *   Anim/Loop.as - Looping Functionality
 */

Anim.BeingLooped = {};

Anim.Loop = function ( mc:MovieClip, prop:String, easing:Function,
						startval:Number, endval:Number, duration:Number ):Void {
	var idx:String = mc._name +"."+ prop;
	if ( Anim.BeingLooped[ idx ] != undefined )
		delete Anim.BeingLooped[ idx ];

	mc[ prop ] = startval;
	mc._visible = true;
	var change:Number = endval - startval;
	Anim.BeingLooped[ idx ] = {
		idx: idx,
		t: 0,
		last_t: Time.Ticks,
		mc: mc,
		prop: prop,
		begin: startval,
		change: change,
		end: endval,
		easing: ( easing ) ? easing : None.easeInOut,
		duration: duration * 1000,
		direction: 1
	};
}

Anim.ProcessLoop = function ( loop:Object ):Void {
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

Anim.StopLoop = function ( mc:MovieClip ):Void {
	var match:String;
	for ( var idx:String in Anim.BeingLooped ) {
		match = idx.substr( 0, idx.lastIndexOf( "." ) );
		if ( match == mc._name )
			delete Anim.BeingLooped[ idx ];
	}
}

Do_Periodic( 1, function ():Void {
	var loop:Object;
	for ( var idx:String in Anim.BeingLooped ) {
		loop = Anim.BeingLooped[ idx ];
		Anim.ProcessLoop( loop );
	}
} );

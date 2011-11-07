/*
 *    _____         _______ _______ _______ _______
 *   |_____] |      |_____| |______ |  |  | |_____|
 *   |       |_____ |     | ______| |  |  | |     |
 *
 *   Anim/TextField.as - TextField Animations
 */

Anim.TextScrollList = {};

Anim.TextScroll = function ( tf:TextField ):Void {
	var idx:String = tf._name;
	var max:Number = tf.maxhscroll;
	Anim.StopTextScroll( tf );

	Anim.TextScrollList[ idx ] = {
		idx: tf._name,
		t: 0,
		last_t: Time.Ticks,
		tf: tf,
		duration: max * 100,
		direction: 1
	};
}

Anim.ProcessTextScroll = function ( loop:Object ):Void {
	if ( !loop.tf ) delete Anim.TextScrollList[ loop.idx ];
	if ( !loop.tf._visible ) return;
	var max:Number = loop.tf.maxhscroll;
	if ( max == 0 ) return;
	loop.end = max;

	loop.t += Time.Ticks - loop.last_t;
	loop.last_t = Time.Ticks;
	if ( loop.t >= loop.duration ) {
		loop.direction = -loop.direction;
		loop.t = 0;
	}
	loop.tf.hscroll = None.easeInOut( loop.t, ( loop.direction > 0 ) ? 0 : max,
									  loop.direction * max, loop.duration );
}

Anim.StopTextScroll = function ( tf:TextField ):Void {
	delete Anim.TextScrollList[ tf._name ];
}

Do_Periodic( 1, function ():Void {
	var loop:Object;
	for ( var idx:String in Anim.TextScrollList ) {
		loop = Anim.TextScrollList[ idx ];
		Anim.ProcessTextScroll( loop );
	}
} );

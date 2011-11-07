/*
 *    _____         _______ _______ _______ _______
 *   |_____] |      |_____| |______ |  |  | |_____|
 *   |       |_____ |     | ______| |  |  | |     |
 *
 *   Anim/Tween.as - Tweening Functionality
 */

Anim.BeingTweened = {};

Anim.Tween = function ( mc:MovieClip, prop:String, easing:Function,
						startval:Number, endval:Number, duration:Number ):Void {
	var idx:String = mc._name +"."+ prop;
	if ( Anim.BeingTweened[ idx ] != undefined )
		delete Anim.BeingTweened[ idx ];

	mc[ prop ] = startval;
	mc._visible = true;
	var change:Number = endval - startval;
	Anim.BeingTweened[ idx ] = {
		idx: idx,
		start_t: Time.Ticks,
		mc: mc,
		prop: prop,
		begin: startval,
		change: change,
		end: endval,
		easing: ( easing ) ? easing : None.easeInOut,
		duration: duration * 1000
	};
}

Anim.ProcessTween = function ( tween:Object ):Void {
	if ( !tween.mc || !tween.mc._visible ) Anim.StopTween( tween.mc );

	var t:Number = Time.Ticks - tween.start_t;
	if ( t >= tween.duration ) {
		tween.mc[ tween.prop ] = tween.end;
		delete Anim.BeingTweened[ tween.idx ];
		return;
	}
	tween.mc[ tween.prop ] = tween.easing( t, tween.begin, tween.change, tween.duration );
}

Anim.StopTween = function ( mc:MovieClip ):Void {
	var match:String;
	for ( var idx:String in Anim.BeingTweened ) {
		match = idx.substr( 0, idx.lastIndexOf( "." ) );
		if ( match == mc._name )
			delete Anim.BeingTweened[ idx ];
	}
}

Do_Periodic( 1, function ():Void {
	var tween:Object;
	for ( var idx:String in Anim.BeingTweened ) {
		tween = Anim.BeingTweened[ idx ];
		Anim.ProcessTween( tween );
	}
} );

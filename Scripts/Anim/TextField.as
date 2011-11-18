/*
 *    _____         _______ _______ _______ _______
 *   |_____] |      |_____| |______ |  |  | |_____|
 *   |       |_____ |     | ______| |  |  | |     |
 *
 *   Anim/TextField.as - TextField Animations
 */

AnimQueue.textScroll = {};

Anim.textScroll = function ():Void {
	this.stopScroll();

	AnimQueue.textScroll[ this._name ] = {
		init: true,
		tf: this,
		format: this.getTextFormat(),
		direction: 1
	};
}
TextField.prototype.startHScroll = Anim.textScroll;

Anim.processTextScroll = function ( tscroll:Object ):Void {
	if ( !tscroll.tf ) delete AnimQueue.textScroll[ tscroll.idx ];
	if ( !tscroll.tf._visible ) return;

	var max:Number = tscroll.tf.maxhscroll;
	if ( tscroll.max != max ) {
		tscroll.max = max;
		tscroll.inc = ( max / tscroll.format.size ) >> 4;
		tscroll.inc++;
		tscroll.pausedur = ( 128 / max ) >> 0;
		tscroll.pausedur++;
	}
	if ( max < 4 ) return;

	if ( tscroll.pause != undefined ) {
		if ( tscroll.pause < tscroll.pausedur ) tscroll.pause++;
		else delete tscroll.pause;
	}
	if ( tscroll.pause == undefined ) {
		if ( !tscroll.init && ( tscroll.tf.hscroll == max || tscroll.tf.hscroll == 0 ) ) {
			tscroll.direction = -tscroll.direction;
			tscroll.pause = 0;
		}
		tscroll.tf.hscroll += tscroll.inc * tscroll.direction;
		tscroll.init = false;
	}
}

Anim.stopTextScroll = function ():Void {
	var tscroll:Object = AnimQueue.textScroll[ this._name ];
	if ( tscroll != undefined ) {
		tscroll.tf.setTextFormat( tscroll.format );
		tscroll.tf.hscroll = 0;
		delete AnimQueue.textScroll[ this._name ];
	}
}
TextField.prototype.stopHScroll = Anim.stopTextScroll;

Anim.resetTextScroll = function ():Void {
	if ( AnimQueue.pauseTextScroll )
		return;

	var tscroll:Object = AnimQueue.textScroll[ this._name ];
	if ( tscroll != undefined ) {
		tscroll.direction = 1;
		tscroll.tf.hscroll = 0;
	}
}
TextField.prototype.resetHScroll = Anim.resetTextScroll;

Periodic( 1, function ():Void {
	var tscroll:Object;
	for ( var idx:String in AnimQueue.textScroll ) {
		tscroll = AnimQueue.textScroll[ idx ];
		Anim.processTextScroll( tscroll );
	}
} );

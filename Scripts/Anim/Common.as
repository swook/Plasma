/*
 *    _____         _______ _______ _______ _______
 *   |_____] |      |_____| |______ |  |  | |_____|
 *   |       |_____ |     | ______| |  |  | |     |
 *
 *   Anim/Common.as - Common Methods and Other Methods
 */


import mx.transitions.easing.*;

var Anim:Object = {};
var AnimQueue:Object = {};

Anim.stop = function ():Void {
	Anim.stopTween( this );
	Anim.stopLoop( this );
}
MovieClip.prototype.stopAnim = Anim.stop;



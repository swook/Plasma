/*
 *    _____         _______ _______ _______ _______
 *   |_____] |      |_____| |______ |  |  | |_____|
 *   |       |_____ |     | ______| |  |  | |     |
 *
 *   Anim/Common.as - Common Methods and Other Methods
 */


import mx.transitions.easing.*;

var Anim:Object = {};

Anim.Stop = function ( mc:MovieClip ):Void {
	Anim.StopTween( mc );
	Anim.StopLoop( mc );
}




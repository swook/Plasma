/*
 *    _____         _______ _______ _______ _______
 *   |_____] |      |_____| |______ |  |  | |_____|
 *   |       |_____ |     | ______| |  |  | |     |
 *
 *   Launcher/Plasmoid.as - Dealings with Plasmoid
 */


Plasma.Expose = function ():Void {
	_global.Music = Music;
	_global.JetEffect = JetEffect;
	_global.Data = Data;
	_global.onKey = onKey;
	_global.Sys = Sys;
}

Plasma.Hide = function ():Void {
	delete _global.Music;
	delete _global.JetEffect;
	delete _global.Data;
	delete _global.onKey;
	delete _global.Sys;
}


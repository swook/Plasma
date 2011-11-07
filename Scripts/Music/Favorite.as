/*
 *    _____         _______ _______ _______ _______
 *   |_____] |      |_____| |______ |  |  | |_____|
 *   |       |_____ |     | ______| |  |  | |     |
 *
 *   Music/Favorite.as - Favorite Management
 */

var Favorite:Object = new Object();

Favorite.Add = function ():Boolean {
	//ext_fscommand2( "KeyAudFavorite" );				// All Players
	return true;
}
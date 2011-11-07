/*
 *    _____         _______ _______ _______ _______
 *   |_____] |      |_____| |______ |  |  | |_____|
 *   |       |_____ |     | ______| |  |  | |     |
 *
 *   Music/Bookmark.as - Bookmarks Management
 */


var Bookmark:Object = new Object();

Bookmark.Add = function ():Boolean {
	//ext_fscommand2( "KeyAudBookmark" );					// All Players
	return true;
}
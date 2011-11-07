/*
 *    _____         _______ _______ _______ _______
 *   |_____] |      |_____| |______ |  |  | |_____|
 *   |       |_____ |     | ______| |  |  | |     |
 *
 *   Music.as - Music Mode Functionality
 */

Mode.Music = true;
#include "./Music/Playback.as"
#include "./Music/Settings.as"
#include "./Music/A-B.as"
#include "./Music/Bookmark.as"
#include "./Music/Favorite.as"
ext_fscommand2("SetAudAlbumArtMCSize", "250");

Do_onUnload( function ():Void {
	delete imgLoader;
	UnloadGestures();
});

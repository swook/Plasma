function launcherInit()
{
    _global.g_CurrLauncherMode = _global.MODE_MAIN;
    if (ext_fscommand2("GetSysRegion") == -1)
    {
        Load_SWF(MODE_ETC, "init_country.swf");
        return;
    } // end if
    ext_fscommand2("GetTimAlarmState");
    ext_fscommand2("EtcModGetResumeMode", "resumeMode");
    if (resumeMode == "Music")
    {
        _global.Load_SWF(MODE_MUSIC);
    }
    else if (resumeMode == "Video")
    {
        _global.Load_SWF(MODE_VIDEO);
    }
    else if (resumeMode == "Radio")
    {
        _global.Load_SWF(MODE_RADIO);
    }
    else if (resumeMode == "Record")
    {
        _global.Load_SWF(MODE_RECORD);
    }
    else if (resumeMode == "Flash")
    {
        _global.Load_SWF(MODE_FLASHBROWSER);
    }
    else if (resumeMode == "Text")
    {
        _global.Load_SWF(MODE_TEXTBROWSER);
    }
    else if (resumeMode == "Picture")
    {
        _global.Load_SWF(MODE_PICTURE);
    }
    else
    {
        _global.Load_SWF(MODE_MAIN);
    } // end else if
} // End of the function
_global.LCD_WIDTH = 240;
_global.LCD_HEIGHT = 320;
_global.SCROLL_VERTICAL = 1;
_global.SCROLL_HORIZONTAL = 2;
_global.SCROLL_FREE = 3;
_global.STATE_UNDEFINED = 0;
_global.STATE_MUSIC_PLAY = 1;
_global.STATE_MUSIC_PAUSE = 2;
_global.STATE_MUSIC_STOP = 3;
_global.STATE_RADIO = 4;
_global.STATE_RADIO_RECORD = 5;
_global.STATE_RECORD = 7;
_global.STATE_RECORD_PAUSE = 8;
_global.STATE_RECORD_STOP = 9;
_global.STATE_RECORD_PLAY = 10;
_global.STATE_RECORD_PLAYPAUSE = 11;
_global.MODE_MUSIC = 0;
_global.MODE_VIDEO = 1;
_global.MODE_PICTURE = 2;
_global.MODE_TEXT = 3;
_global.MODE_RADIO = 4;
_global.MODE_RECORD = 5;
_global.MODE_FLASH = 6;
_global.MODE_SETTING = 7;
_global.MODE_ETC = 10;
_global.MODE_MAIN = 11;
_global.MODE_BROWSER = 12;
_global.MODE_FLASHBROWSER = 13;
_global.MODE_TEXTBROWSER = 14;
_global.g_FirmwareVersion = 0;
_global.g_PrevLauncherMode = -1;
_global.g_CurrLauncherMode = -1;
_global.g_PrevMenuMode = -1;
_global.g_fPopup = 0;
_global.g_curHour = 0;
_global.g_curMin = 0;
_global.g_curSec = 0;
_global.g_curYear = 0;
_global.g_curMonth = 0;
_global.g_curDay = 0;
_global.g_SeekRatio = 0;
_global.g_PlayMode = 2;
_global.g_PlayBoundary = 1;
_global.g_PlayRepeat = 1;
_global.g_PlayShuffle = 1;
_global.g_PlayABRepeat = 1;
_global.g_VideoPlayMode = 1;
_global.g_VideoScreenMode = 1;
_global.g_TextScrollCount = 0;
_global.g_TextScrollInterval = 0;
_global.g_PrevBrowser = "unknown";
_global.g_Browser_CurrScale = 16;
_global.g_Browser_InitScale = 12;
_global.g_Rec_CurMode = STATE_RECORD_STOP;
_global.g_TextCurrScale;
_global.g_TextinitScale;
var NUMOFSCROLLFIELD = 6;
var gScrollFlagArr = new Array(null, null, null, null, null, null);
var gScrollDirection = new Array(0, 0, 0, 0, 0, 0, 0, 0);
var gScrollAlign = new Array(null, null, null, null, null, null);
var EQString = new Array("User 1", "User 2", "User 3", "User 4", "Normal", "BBE", "BBE ViVA", "BBE ViVA 2", "BBE Mach3Bass", "BBE MP", "BBE Headphone", "BBE Headphone 2", "BBE Headphone 3", "Rock", "Jazz", "Classic", "Ballad", "Pop", "Club", "Funk", "Hiphop", "Techno", "Blues", "Metal", "Dance", "Rap", "Wide", "X-Bass", "Hall", "Vocal", "Maestro", "Feel the Wind", "Mild Shore", "Crystal Clear", "Reverb Room", "Reverb Club", "Reverb Stage", "Reverb Hall", "Reverb Stadium");
var PopupMCName;
_global.Rect = function ()
{
    var _loc4;
    var _loc3;
    var _loc1;
    var _loc2;
};
var restoreAlign = new TextFormat();
_global.gfn_SetPopupMCName = function (MC, TimerOnOff)
{
    if (PopupMCName != null)
    {
        var TempMC = PopupMCName;
        if (_global.g_TextScrollInterval == 0)
        {
            TempMC.onEnterFrame = function ()
            {
                TempMC._xscale = TempMC._xscale / 2;
                TempMC._yscale = TempMC._yscale / 2;
                if (TempMC._xscale <= 5)
                {
                    delete TempMC.onEnterFrame;
                    TempMC._xscale = 100;
                    TempMC._yscale = 100;
                    TempMC._visible = false;
                } // end if
            };
        }
        else
        {
            TempMC._visible = false;
        } // end if
    } // end else if
    if (MC != null)
    {
        if (TimerOnOff == 1)
        {
            _global.g_fPopup = 1;
        }
        else
        {
            _global.g_fPopup = 0;
        } // end else if
        if (_global.g_TextScrollInterval == 0)
        {
            MC._xscale = MC._yscale = 0;
            MC._visible = true;
            MC.onEnterFrame = function ()
            {
                MC._xscale = MC._xscale + (100 - MC._xscale) / 2;
                MC._yscale = MC._yscale + (100 - MC._yscale) / 2;
                if (MC._xscale > 99)
                {
                    MC._xscale = 100;
                    MC._yscale = 100;
                    delete MC.onEnterFrame;
                } // end if
            };
        }
        else
        {
            MC._visible = true;
        } // end else if
    }
    else
    {
        _global.g_fPopup = 0;
    } // end else if
    PopupMCName = MC;
};
_global.gfn_GetPopupMCName = function ()
{
    return (PopupMCName._name);
};
_global.gfn_Common_SetMask = function (MaskWidth, MaskHeight, BgMC, MaskMC)
{
    MaskMC._width = MaskWidth;
    MaskMC._height = MaskHeight;
    BgMC.setMask(MaskMC);
};
_global.gfn_Common_DrawSeekBar = function (BGMC, TargetMC, MaskMC, Position, ScrollMode)
{
    if (Position < 0)
    {
        Position = 0;
    } // end if
    if (Position > 100)
    {
        Position = 100;
    } // end if
    if (ScrollMode == SCROLL_HORIZONTAL)
    {
        if (MaskMC == null)
        {
            var _loc5 = BGMC._width - TargetMC._width;
        }
        else
        {
            _loc5 = BGMC._width - (TargetMC._width - 24);
        } // end else if
        TargetMC._x = Position * _loc5 / 100;
        gfn_Common_SetMask(Math.floor(TargetMC._x), BGMC._height, BGMC, MaskMC);
    }
    else if (ScrollMode == SCROLL_VERTICAL)
    {
        if (MaskMC == null)
        {
            _loc5 = BGMC._height - TargetMC._height;
        }
        else
        {
            _loc5 = BGMC._height - (TargetMC._height - 24);
        } // end else if
        TargetMC._y = Position * _loc5 / 100;
        gfn_Common_SetMask(Math.floor(TargetMC._y), BGMC._width, BGMC, MaskMC);
    } // end else if
};
_global.gfn_Common_GetRatio = function (Total, Current)
{
    if (Total == 0 || Current == 0)
    {
        return (0);
    }
    else
    {
        return (Math.floor(Current * 100 / Total));
    } // end else if
};
_global.gfn_Common_GetSeekBarRatio = function (TotalWidth, TargetWidth, curPos)
{
    var _loc1 = TotalWidth - TargetWidth;
    g_SeekRatio = Math.floor(curPos * 100 / _loc1);
    if (g_SeekRatio < 0)
    {
        g_SeekRatio = 0;
    } // end if
    if (g_SeekRatio > 100)
    {
        g_SeekRatio = 100;
    } // end if
    return (g_SeekRatio);
};
_global.gfn_Common_GetSeekRatio = function ()
{
    return (g_SeekRatio);
};
_global.gfn_Common_Get2ChiperNum = function (curVal)
{
    if (curVal < 10)
    {
        return ("0" + String(curVal));
    }
    else
    {
        return (String(curVal));
    } // end else if
};
_global.gfn_Common_GetTime2Text = function (time)
{
    var _loc3;
    var _loc2;
    var _loc1;
    var _loc6;
    var _loc5;
    _loc1 = 0;
    _loc2 = 0;
    _loc3 = 0;
    _loc3 = Math.floor(time / 3600);
    _loc2 = Math.floor(time % 3600 / 60);
    _loc1 = Math.floor(time % 3600 % 60);
    _loc3 = gfn_Common_Get2ChiperNum(_loc3);
    _loc2 = gfn_Common_Get2ChiperNum(_loc2);
    _loc1 = gfn_Common_Get2ChiperNum(_loc1);
    _loc5 = _loc3 + ":" + _loc2 + ":" + _loc1;
    return (_loc5);
};
_global.gfn_Common_SetStringScroll = function (TextFieldName, TextAlign)
{
    var _loc1;
    var _loc4 = TextFieldName.getTextFormat();
    if (TextFieldName.maxhscroll >= 3)
    {
        var _loc2 = NUMOFSCROLLFIELD;
        for (var _loc1 = 0; _loc1 < NUMOFSCROLLFIELD; ++_loc1)
        {
            if (gScrollFlagArr[_loc1] == TextFieldName)
            {
                _loc2 = _loc1;
                break;
                continue;
            } // end if
            if (gScrollFlagArr[_loc1] == null)
            {
                if (_loc2 == NUMOFSCROLLFIELD)
                {
                    _loc2 = _loc1;
                } // end if
            } // end if
        } // end of for
        if (_loc2 != NUMOFSCROLLFIELD)
        {
            gScrollFlagArr[_loc2] = TextFieldName;
            gScrollDirection[_loc2] = 0;
            gScrollAlign[_loc2] = _loc4.align;
            _loc4.align = "left";
            TextFieldName.setTextFormat(_loc4);
        } // end if
    }
    else
    {
        for (var _loc1 = 0; _loc1 < NUMOFSCROLLFIELD; ++_loc1)
        {
            if (gScrollFlagArr[_loc1] == TextFieldName)
            {
                gScrollFlagArr[_loc1] = null;
                gScrollDirection[_loc1] = 0;
                gScrollAlign[_loc1] = 0;
                break;
            } // end if
        } // end of for
        if (TextAlign == 1)
        {
            _loc4.align = "center";
            TextFieldName.setTextFormat(_loc4);
        } // end if
    } // end else if
    false;
};
_global.gfn_Common_StringScroll = function ()
{
    var _loc1;
    var _loc2;
    for (var _loc1 = 0; _loc1 < NUMOFSCROLLFIELD; ++_loc1)
    {
        if (gScrollFlagArr[_loc1] != null)
        {
            if (gScrollDirection[_loc1] == 0)
            {
                ++gScrollFlagArr[_loc1].hscroll;
                if (gScrollFlagArr[_loc1].hscroll >= gScrollFlagArr[_loc1].maxhscroll)
                {
                    gScrollDirection[_loc1] = 1;
                } // end if
                continue;
            } // end if
            --gScrollFlagArr[_loc1].hscroll;
            if (gScrollFlagArr[_loc1].hscroll <= 0)
            {
                gScrollDirection[_loc1] = 0;
            } // end if
        } // end if
    } // end of for
};
_global.gfn_Common_ResetStringScroll = function ()
{
    var _loc1;
    for (var _loc1 = 0; _loc1 < NUMOFSCROLLFIELD; ++_loc1)
    {
        if (gScrollFlagArr[_loc1] != null)
        {
            restoreAlign.align = gScrollAlign[_loc1];
            gScrollFlagArr[_loc1].setTextFormat(restoreAlign);
            restoreAlign.align = null;
        } // end if
        gScrollFlagArr[_loc1].hscroll = 0;
        gScrollFlagArr[_loc1] = null;
        gScrollDirection[_loc1] = null;
        gScrollAlign[_loc1] = null;
    } // end of for
};
_global.KEY_MODE_CHANGE_SHORT = 0;
_global.KEY_MODE_CHANGE_LONG = 1;
_global.KEY_PLUS_SHORT = 2;
_global.KEY_PLUS_LONG = 3;
_global.KEY_MINUS_SHORT = 4;
_global.KEY_MINUS_LONG = 5;
_global.KEY_BACK_SHORT = 10;
_global.KEY_BACK_LONG = 11;
_global.KEY_FF_SHORT = 12;
_global.KEY_FF_LONG = 13;
_global.KEY_PLAY_SHORT = 14;
_global.KEY_PLAY_LONG = 15;
_global.KEY_REW_SHORT = 16;
_global.KEY_REW_LONG = 17;
_global.KEY_RELEASE_LONG = 18;
_global.KEY_DISPLAY_UPDATE = 19;
_global.KEY_HOLD = 20;
_global.KEY_CENTER_SHORT = 21;
_global.KEY_CENTER_LONG = 22;
_global.SHORTKEY_DELAY = 400;
_global.LONGKEY_REPEAT = 40;
_global.REPEAT_KEY_MENU = 0;
_global.REPEAT_KEY_PLUS = 1;
_global.REPEAT_KEY_MINUS = 2;
_global.REPEAT_KEY_BACK = 5;
_global.REPEAT_KEY_FF = 6;
_global.REPEAT_KEY_PLAY = 7;
_global.REPEAT_KEY_REW = 8;
_global.REPEAT_KEY_CENTER = 9;
_global.Key_Type = 0;
_global.Key_StartTick = 0;
_global.Key_DragLength = 0;
_global.Key_ThrowAcc = 0;
_global.Key_BeepOn = true;
var keyObj = new Object();
var enableRepeatKey = new Array(false, true, true, undefined, undefined, false, true, false, true, false);
_global.gfn_SetRepeatKey = function (keyValue, enableRepeat)
{
    enableRepeatKey[keyValue] = enableRepeat;
};
_global.gfn_Key_CreateKeyListner = function (fn_Handle)
{
    var Key_CodeValue;
    keyObj.onKeyDown = function ()
    {
        if (_global.isLoading == true)
        {
            return;
        } // end if
        Key_CodeValue = Key.getCode();
        if (Key_CodeValue >= 32 && Key_CodeValue <= 40 || Key_CodeValue == 101)
        {
            var _loc2 = getTimer();
            switch (Key_Type)
            {
                case 0:
                {
                    Key_Type = 1;
                    Key_StartTick = _loc2;
                    break;
                }
                case 1:
                {
                    if (_loc2 - Key_StartTick > SHORTKEY_DELAY)
                    {
                        Key_Type = enableRepeatKey[Key_CodeValue - 32] ? (2) : (3);
                        if (ext_fscommand2("GetSysHoldKey") && Key_CodeValue == 39)
                        {
                            break;
                        } // end if
                        Key_StartTick = _loc2;
                        ext_fscommand2("SetEtcTriggerBeep");
                        if (Key_CodeValue == 101)
                        {
                            fn_Handle(KEY_CENTER_LONG);
                        }
                        else
                        {
                            fn_Handle((Key_CodeValue - 32 << 1) + 1);
                        } // end if
                    } // end else if
                    break;
                }
                case 2:
                {
                    if (_loc2 - Key_StartTick > LONGKEY_REPEAT)
                    {
                        Key_Type = 2;
                        Key_StartTick = _loc2;
                        ext_fscommand2("SetEtcTriggerBeep");
                        if (Key_CodeValue == 101)
                        {
                            fn_Handle(KEY_CENTER_LONG);
                        }
                        else
                        {
                            fn_Handle((Key_CodeValue - 32 << 1) + 1);
                        } // end if
                    } // end else if
                    break;
                }
                case 3:
                {
                    break;
                }
            } // End of switch
        }
        else if (Key_CodeValue == 104 || Key_CodeValue == 98)
        {
            _global.Key_DragLength = ext_fscommand2("GetSysTPLength");
            Key_Type = 2;
            if (_global.Key_DragLength != 0)
            {
                if (_global.Key_BeepOn == true)
                {
                    ext_fscommand2("SetEtcTriggerBeep");
                } // end if
                if (Key_CodeValue == 104)
                {
                    fn_Handle(KEY_FF_LONG);
                }
                else if (Key_CodeValue == 98)
                {
                    fn_Handle(KEY_REW_LONG);
                } // end if
            } // end else if
            _global.Key_DragLength = 0;
        } // end else if
    };
    keyObj.onKeyUp = function ()
    {
        Key_CodeValue = Key.getCode();
        if (Key_CodeValue == 120)
        {
            unloadMovieNum(1);
        }
        else if (Key_CodeValue == 123)
        {
            fn_Handle(KEY_DISPLAY_UPDATE);
        }
        else if (Key_CodeValue == 145)
        {
            fn_Handle(KEY_HOLD);
        }
        else if (_global.isLoading == false)
        {
            if (Key_CodeValue >= 32 && Key_CodeValue <= 40 || Key_CodeValue == 101)
            {
                if (Key_Type == 1)
                {
                    ext_fscommand2("SetEtcTriggerBeep");
                    if (Key_CodeValue == 101)
                    {
                        fn_Handle(KEY_CENTER_SHORT);
                    }
                    else
                    {
                        fn_Handle(Key_CodeValue - 32 << 1);
                    } // end else if
                }
                else if (Key_Type == 2)
                {
                    fn_Handle(KEY_RELEASE_LONG);
                } // end else if
                Key_Type = 0;
                Key_StartTick = 0;
            }
            else if (Key_CodeValue == 104 || Key_CodeValue == 98)
            {
                fn_Handle(KEY_RELEASE_LONG);
                Key_Type = 0;
                Key_StartTick = 0;
            } // end else if
        } // end else if
    };
    Key.addListener(keyObj);
};
_global.gfn_Key_RemoveKeyListener = function ()
{
    Key.removeListener(keyObj);
};
var currAudioOut = -1;
var prevAudioOut = -1;
var prevVolume = -1;
var currVolume = -1;
var prevBatt = -1;
var currBatt = -1;
var prevMin = -1;
var prevHold = -1;
var currHold = -1;
var display24Hour;
_global.gfn_DispPlayStatus = function ()
{
    _level1.MCCon.MCInfobar.mc_jeteffect._visible = false;
    _level1.MCCon.MCInfobar.txt_eqValue._visible = false;
    if (ext_fscommand2("GetEtcState") == _global.STATE_MUSIC_PLAY)
    {
        _level1.MCCon.MCInfobar.mc_playing._visible = true;
        _level1.MCCon.MCInfobar.mc_playing.gotoAndStop(1);
    }
    else
    {
        _level1.MCCon.MCInfobar.mc_playing._visible = false;
    } // end else if
};
_global.gfn_systemInfo = function (Update)
{
    gfn_DispTime(Update);
    gfn_DispAudioOut(Update);
    gfn_DispVolume(Update);
    gfn_DispBatt(Update);
    gfn_DispHold(Update);
};
_global.gfn_DispAudioOut = function (Update)
{
    currAudioOut = ext_fscommand2("GetEtcSpeakerOn");
    if (Update == 1 || prevAudioOut != currAudioOut)
    {
        prevAudioOut = currAudioOut;
        if (currAudioOut == 0)
        {
            _level1.MCCon.MCInfobar.mc_speak.gotoAndStop(2);
        }
        else
        {
            _level1.MCCon.MCInfobar.mc_speak.gotoAndStop(1);
        } // end if
    } // end else if
};
_global.gfn_DispVolume = function (Update)
{
    currVolume = ext_fscommand2("GetEtcVolume");
    if (Update == 1 || prevVolume != currVolume)
    {
        prevVolume = currVolume;
        _level1.MCCon.MCInfobar.txt_vol.text = currVolume;
    } // end if
};
_global.gfn_DispTime = function (Update)
{
    var _loc2 = new Date();
    _global.g_curHour = _loc2.getHours();
    _global.g_curMin = _loc2.getMinutes();
    _global.g_curSec = _loc2.getSeconds();
    _global.g_curYear = _loc2.getFullYear();
    _global.g_curMonth = _loc2.getMonth() + 1;
    _global.g_curDay = _loc2.getDate();
    if (Update == 1 || _global.g_curMin != prevMin)
    {
        prevMin = _global.g_curMin;
        if (Update == 1)
        {
            display24Hour = ext_fscommand2("GetTim24HDisplay");
        } // end if
        if (display24Hour)
        {
            _level1.MCCon.MCInfobar.txt_time.text = gfn_Common_Get2ChiperNum(_global.g_curHour) + ":" + gfn_Common_Get2ChiperNum(_global.g_curMin);
        }
        else
        {
            var _loc3;
            if (_global.g_curHour < 12)
            {
                _loc3 = _global.g_curHour;
                _level1.MCCon.MCInfobar.txt_ampm.text = "AM";
            }
            else
            {
                if (_global.g_curHour != 12)
                {
                    _loc3 = _global.g_curHour - 12;
                }
                else
                {
                    _loc3 = _global.g_curHour;
                } // end else if
                _level1.MCCon.MCInfobar.txt_ampm.text = "PM";
            } // end else if
            _level1.MCCon.MCInfobar.txt_time.text = gfn_Common_Get2ChiperNum(_loc3) + ":" + gfn_Common_Get2ChiperNum(_global.g_curMin);
        } // end else if
        if (Update == 1)
        {
            if (display24Hour)
            {
                _level1.MCCon.MCInfobar.txt_ampm._visible = false;
            }
            else
            {
                _level1.MCCon.MCInfobar.txt_ampm._visible = true;
            } // end if
        } // end if
    } // end else if
    false;
};
_global.gfn_DispBatt = function (Update)
{
    currBatt = ext_fscommand2("GetSysBattery");
    if (Update == 1 || currBatt != prevBatt)
    {
        prevBatt = currBatt;
        _level1.MCCon.MCInfobar.mc_batt.gotoAndStop(1 + currBatt);
    } // end if
};
_global.gfn_DispHold = function (Update)
{
    currHold = ext_fscommand2("GetSysHoldKey");
    if (Update == 1 || currHold != prevHold)
    {
        prevHold = currHold;
        if (currHold == 1)
        {
            _level1.MCCon.MCInfobar.mc_lock._visible = true;
            if (ext_fscommand2("GetSysCtrlHoldState") == 0)
            {
                _level1.MCCon.MCInfobar.mc_lock.gotoAndStop(1);
            }
            else
            {
                _level1.MCCon.MCInfobar.mc_lock.gotoAndStop(2);
            } // end else if
        }
        else
        {
            _level1.MCCon.MCInfobar.mc_lock._visible = false;
        } // end if
    } // end else if
};
_global.isLoading = false;
var popupKeyObj;
var systemInfoTick = 0;
var resumeMode;
var currentMainmenu;
var WPLoader = new MovieClipLoader();
var WPListener = new Object();
var BGLoader = new MovieClipLoader();
var BGListener = new Object();
_global.Load_SWF_ANI = function (ItemNum, FileName)
{
    _global.g_PrevLauncherMode = _global.g_CurrLauncherMode;
    if (_global.g_CurrLauncherMode != _global.MODE_BROWSER && _global.g_CurrLauncherMode != _global.MODE_SETTING && _global.g_CurrLauncherMode != _global.MODE_MAIN)
    {
        _global.g_PrevMenuMode = _global.g_CurrLauncherMode;
    } // end if
    _global.g_CurrLauncherMode = ItemNum;
    _global.gfn_Key_RemoveKeyListener();
    _global.gfn_Common_ResetStringScroll();
    _global.gfn_Common_ResetTimer();
    currentMainmenu = ext_fscommand2("EtcUsrGetMainmenu");
    Load_WallPaper();
    unloadMovieNum(1);
    switch (ItemNum)
    {
        case MODE_MAIN:
        case MODE_MUSIC:
        {
            switch (currentMainmenu)
            {
                case 1:
                {
                    loadMovieNum("System\\Flash UI\\mainmenu2.swf", 1);
                    break;
                }
                case 0:
                default:
                {
                    loadMovieNum("System\\Flash UI\\mainmenu1.swf", 1);
                    break;
                }
            } // End of switch
            break;
        }
        case MODE_VIDEO:
        {
            loadMovieNum("System\\Flash UI\\music.swf", 1);
            break;
        }
        case MODE_RADIO:
        {
            loadMovieNum("System\\Flash UI\\videos.swf", 1);
            break;
        }
        case MODE_RECORD:
        {
            loadMovieNum("System\\Flash UI\\radio.swf", 1);
            break;
        }
        case MODE_PICTURE:
        {
            loadMovieNum("System\\Flash UI\\recorder.swf", 1);
            break;
        }
        case MODE_TEXT:
        {
            loadMovieNum("System\\Flash UI\\pictures.swf", 1);
            break;
        }
        case MODE_TEXTBROWSER:
        {
            loadMovieNum("System\\Flash UI\\documents.swf", 1);
            break;
        }
        case MODE_FLASHBROWSER:
        case MODE_BROWSER:
        case MODE_SETTING:
        {
            loadMovieNum("System\\Flash UI\\browser.swf", 1);
            break;
        }
        case MODE_ETC:
        {
            loadMovieNum("System\\Flash UI\\settings.swf", 1);
            break;
        }
        default:
        {
            var _loc2 = "System\\Flash UI\\";
            _loc2 = _loc2 + FileName;
            loadMovieNum(_loc2, 1);
            break;
        }
    } // End of switch
};
BGListener.onLoadInit = function (mc)
{
    var targetPosition;
    var multiplier;
    var diff;
    var delay = 3;
    if (BGListener.ItemNum == _global.MODE_MAIN && _global.g_CurrLauncherMode == _global.MODE_BROWSER)
    {
        _level0._level1._x = 240;
        _level0._x = -240;
    } // end if
    _global.Load_SWF_ANI(BGListener.ItemNum, BGListener.FileName);
    BGLoader.removeListener(this);
    if (BGListener.ItemNum == _global.MODE_MAIN || BGListener.ItemNum == _global.MODE_BROWSER)
    {
        _level0.MCDup._x = 240;
        targetPosition = 0;
        _level0._level1._x = 0;
    }
    else
    {
        _level0.MCDup._x = 0;
        targetPosition = -240;
        _level0._level1._x = 240;
    } // end else if
    if (BGListener.ItemNum == _global.MODE_MUSIC)
    {
        multiplier = 8.500000E-001;
    }
    else
    {
        multiplier = 6.000000E-001;
    } // end else if
    mcSC.onEnterFrame = function ()
    {
        if (delay-- < 0)
        {
            diff = targetPosition - _level0._x;
            if (Math.abs(diff) < 5)
            {
                _level0._x = targetPosition;
                delete this.onEnterFrame;
                _level0.MCDup.removeMovieClip();
                ext_fscommand2("EtcDisClearBuffer");
                _global.isLoading = false;
            }
            else
            {
                _level0._x = _level0._x + diff * multiplier;
            } // end if
        } // end else if
    };
};
BGListener.onLoadError = function (mc, errorCode)
{
    BGLoader.removeListener(this);
};
_global.Load_SWF = function (ItemNum, FileName)
{
    if (ItemNum == _global.MODE_VIDEO || _global.g_CurrLauncherMode == _global.MODE_VIDEO || _global.g_PrevLauncherMode == -1)
    {
        _level0._level1._x = 0;
        _level0._x = 0;
        _global.Load_SWF_ANI(ItemNum, FileName);
    }
    else
    {
        _global.isLoading = true;
        ext_fscommand2("EtcDisCapture");
        _level0.createEmptyMovieClip("MCDup", _level0.getNextHighestDepth());
        BGListener.ItemNum = ItemNum;
        BGListener.FileName = FileName;
        BGLoader.loadClip("0.NPM", _level0.MCDup);
        BGLoader.addListener(BGListener);
    } // end else if
};
this.onEnterFrame = function ()
{
    var _loc4 = getTimer();
    if (_loc4 - systemInfoTick > 1000)
    {
        systemInfoTick = _loc4;
        gfn_DispTime(0);
        gfn_DispBatt(0);
    } // end if
    if (_global.isLoading == false)
    {
        ++g_TextScrollCount;
        if (g_TextScrollCount >= g_TextScrollInterval)
        {
            g_TextScrollCount = 0;
        } // end if
        for (var _loc2 = 0; _loc2 < NUMOFSCROLLFIELD; ++_loc2)
        {
            if (gScrollFlagArr[_loc2] != null)
            {
                if (g_TextScrollCount == 0)
                {
                    var _loc3 = gScrollFlagArr[_loc2];
                    if (gScrollDirection[_loc2] == 0)
                    {
                        ++_loc3.hscroll;
                        if (_loc3.hscroll >= _loc3.maxhscroll)
                        {
                            gScrollDirection[_loc2] = 1;
                        } // end if
                        continue;
                    } // end if
                    --_loc3.hscroll;
                    if (_loc3.hscroll <= 0)
                    {
                        gScrollDirection[_loc2] = 0;
                    } // end if
                } // end if
            } // end if
        } // end of for
    } // end if
};
WPListener.onLoadInit = function (mc)
{
    WPLoader.removeListener(this);
};
WPListener.onLoadError = function (mc, errorCode)
{
    WPLoader.removeListener(this);
};
_global.Unload_WallPaper = function ()
{
    if (_root.MCBG != undefined)
    {
        _root.MCBG.removeMovieClip();
    } // end if
};
var prevWallpaper = 0;
var bgUpdate = 1;
_global.Load_WallPaper = function (force)
{
    var _loc3 = ext_fscommand2("GetDisWallpaper");
    Unload_WallPaper();
    if (g_CurrLauncherMode == _global.MODE_VIDEO)
    {
        _root.attachMovie("MCDefaultBG", "MCBG", 0);
    }
    else if ((prevWallpaper != _loc3 || force == true || _global.g_PrevLauncherMode == _global.MODE_VIDEO || g_CurrLauncherMode == _global.MODE_MAIN) && currentMainmenu == 1)
    {
        prevWallpaper = _loc3;
        _root.attachMovie("MCBG", "MCBG", 0);
        WPLoader.loadClip("WALLPAPER.BNG", "MCBG");
        WPLoader.addListener(WPListener);
    } // end else if
};
launcherInit();


function launcherInit()
{
    var _loc2;
    if (popupKeyObj == undefined)
    {
        var i;
        popupKeyObj = new Object();
        popupKeyObj.onMouseUp = popupKeyObj.onMouseMove = popupKeyObj.onKeyUp = popupKeyObj.onKeyDown = function ()
        {
            _global.g_popupTimer = getTimer();
            for (i = 0; i < 5; i++)
            {
                if (cTimer.StartTick[i] != null)
                {
                    cTimer.StartTick[i] = _global.g_popupTimer;
                } // end if
            } // end of for
        };
        Key.addListener(popupKeyObj);
        Mouse.addListener(popupKeyObj);
    } // end if
    ext_fscommand2("GetSysVersion", "VersionString");
    _global.g_FirmwareVersion = Number(VersionString.substring(0, 1));
    if (_global.g_FirmwareVersion == 0)
    {
        _global.g_FirmwareVersion = S9_NODMB_DIC;
    } // end if
    redraw_WP = true;
    curWP_State = ext_fscommand2("GetDisWallpaper");
    prevMainMenuIndex = curMainMenuIndex = ext_fscommand2("EtcUsrGetMainmenu");
    if (_global.g_FirmwareVersion == S9_NODMB || _global.g_FirmwareVersion == S9_NORWAY_DMB)
    {
        if (ext_fscommand2("GetSysRegion") == -1)
        {
            Load_SWF(MODE_ETC, "init_country.swf");
            return;
        } // end if
    } // end if
    _loc2 = ext_fscommand2("GetTimAlarmState");
    ext_fscommand2("EtcModGetResumeMode", "resumeMode");
    if (resumeMode == "Music")
    {
        Load_SWF(MODE_MUSIC);
    }
    else if (resumeMode == "Video")
    {
        Load_SWF(MODE_VIDEO);
    }
    else if (resumeMode == "Radio")
    {
        Load_SWF(MODE_RADIO);
    }
    else if (resumeMode == "Record")
    {
        Load_SWF(MODE_RECORD);
    }
    else if (resumeMode == "MobileTV")
    {
        Load_SWF(MODE_DMB);
    }
    else if (resumeMode == "Flash")
    {
        Load_SWF(MODE_FLASHBROWSER);
    }
    else if (resumeMode == "Text")
    {
        Load_SWF(MODE_TEXTBROWSER);
    }
    else if (resumeMode == "Picture")
    {
        Load_SWF(MODE_PICTURE);
    }
    else if (resumeMode == "Dictionary")
    {
        Load_SWF(MODE_DICTIONARY);
    }
    else
    {
        Load_SWF(MODE_MAIN);
    } // end else if
} // End of the function
_global.LCD_WIDTH = 272;
_global.LCD_HEIGHT = 480;
_global.SCROLL_VERTICAL = 1;
_global.SCROLL_HORIZONTAL = 2;
_global.SCROLL_FREE = 3;
_global.NUMOFMAINICONS = 15;
_global.S9_NODMB_DIC = 1;
_global.S9_NODMB = 2;
_global.S9_DMB = 3;
_global.S9_NORWAY_DMB = 4;
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
_global.STATE_MTV = 12;
_global.STATE_MTV_RECORD = 13;
_global.MODE_MUSIC = 0;
_global.MODE_VIDEO = 1;
_global.MODE_RADIO = 2;
_global.MODE_RECORD = 3;
_global.MODE_DMB = 4;
_global.MODE_FLASH = 5;
_global.MODE_TEXT = 6;
_global.MODE_PICTURE = 7;
_global.MODE_DICTIONARY = 8;
_global.MODE_UTIL = 9;
_global.MODE_ETC = 10;
_global.MODE_MAIN = 11;
_global.MODE_MAIN2 = 12;
_global.MODE_MAIN3 = 13;
_global.MODE_SETTING = 14;
_global.MODE_BROWSER = 15;
_global.MODE_FLASHBROWSER = 16;
_global.MODE_TEXTBROWSER = 17;
_global.MODE_WIDGET = 18;
_global.g_FirmwareVersion = 0;
_global.g_PrevLauncherMode = -1;
_global.g_CurrLauncherMode = -1;
_global.g_popupTimer = 0;
_global.g_fPopup = 0;
_global.g_CurrRotation = 0;
_global.g_curHour = 0;
_global.g_curMin = 0;
_global.g_curSec = 0;
_global.g_SeekRatio = 0;
_global.g_mainScale = 0;
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
cTimer = new Object();
cTimer.startTick = new Array(null, null, null, null, null);
cTimer.tick = new Array(null, null, null, null, null);
cTimer.func = new Array(null, null, null, null, null);
var DoFlip = 0;
var PopupMCName;
_global.Rect = function ()
{
    var _loc4;
    var _loc3;
    var _loc1;
    var _loc2;
};
var restoreAlign = new TextFormat();
var tempScale_x;
var tempScale_y;
_global.Scale_OneDegree = function (mc, targetScale)
{
    if (targetScale > mc._xscale)
    {
        tempScale_x = targetScale - mc._xscale >> 1;
        if (tempScale_x <= 1)
        {
            mc._xscale = mc._yscale = targetScale;
            return (1);
        } // end if
        mc._xscale = mc._xscale + tempScale_x;
        mc._yscale = mc._yscale + tempScale_x;
    }
    else
    {
        tempScale_x = targetScale - mc._xscale >> 1;
        if (tempScale_x >= -1)
        {
            mc._xscale = mc._yscale = targetScale;
            return (1);
        } // end if
        mc._xscale = mc._xscale + tempScale_x;
        mc._yscale = mc._yscale + tempScale_x;
    } // end else if
    return (0);
};
_global.gfn_flipFooter = function (SideA, SideB, flipMode, fastMode)
{
    var fFlip = 1;
    var parentMC = SideA._parent;
    var chMenu = 0;
    if (DoFlip == 0)
    {
        if (flipMode == SCROLL_HORIZONTAL)
        {
            var bgHeight = parentMC._height;
            if (fastMode)
            {
                var bgHalfHeight = parentMC._height * 8.000000E-001;
            }
            else
            {
                var bgHalfHeight = parentMC._height >> 1;
            } // end else if
            var _loc2 = 0;
            DoFlip = 1;
            parentMC.onEnterFrame = function ()
            {
                if (parentMC._height < 1)
                {
                    fFlip = 2;
                } // end if
                if (fFlip == 1)
                {
                    if (parentMC._height > bgHalfHeight)
                    {
                        parentMC._height = parentMC._height - bgHalfHeight;
                    }
                    else
                    {
                        parentMC._height = 0;
                    } // end if
                } // end else if
                if (fFlip == 2)
                {
                    if (parentMC._height > bgHeight)
                    {
                        parentMC._height = bgHalfHeight;
                    }
                    else if (bgHeight < bgHalfHeight + parentMC._height)
                    {
                        parentMC._height = bgHeight;
                        DoFlip = 0;
                        delete parentMC.onEnterFrame;
                    }
                    else
                    {
                        parentMC._height = parentMC._height + bgHalfHeight;
                    } // end else if
                    if (parentMC._height > bgHalfHeight - 2 && chMenu == 0)
                    {
                        if (SideA._visible != SideB._visible)
                        {
                            gfn_ToggleVisibleState(SideA);
                            gfn_ToggleVisibleState(SideB);
                        }
                        else
                        {
                            SideA._visible = true;
                            SideB._visible = false;
                        } // end else if
                        chMenu = 1;
                    } // end if
                } // end if
            };
        }
        else if (flipMode == SCROLL_VERTICAL)
        {
            var bgHeight = parentMC._width;
            if (fastMode)
            {
                var bgHalfHeight = parentMC._width * 8.000000E-001;
            }
            else
            {
                var bgHalfHeight = parentMC._width >> 1;
            } // end else if
            _loc2 = 0;
            DoFlip = 1;
            parentMC.onEnterFrame = function ()
            {
                if (parentMC._width < 1)
                {
                    fFlip = 2;
                } // end if
                if (fFlip == 1)
                {
                    if (parentMC._width > bgHalfHeight)
                    {
                        parentMC._width = parentMC._width - bgHalfHeight;
                    }
                    else
                    {
                        parentMC._width = 0;
                    } // end if
                } // end else if
                if (fFlip == 2)
                {
                    if (bgHeight < bgHalfHeight + parentMC._width)
                    {
                        parentMC._width = bgHeight;
                        DoFlip = 0;
                        delete parentMC.onEnterFrame;
                    }
                    else
                    {
                        parentMC._width = parentMC._width + bgHalfHeight;
                    } // end else if
                    if (parentMC._width > bgHalfHeight - 2 && chMenu == 0)
                    {
                        if (SideA._visible != SideB._visible)
                        {
                            gfn_ToggleVisibleState(SideA);
                            gfn_ToggleVisibleState(SideB);
                        }
                        else
                        {
                            SideA._visible = true;
                            SideB._visible = false;
                        } // end else if
                        chMenu = 1;
                    } // end if
                } // end if
            };
        } // end if
    } // end else if
};
_global.gfn_ToggleVisibleState = function (TargetMC)
{
    if (TargetMC._visible == true)
    {
        TargetMC._visible = false;
    }
    else
    {
        TargetMC._visible = true;
    } // end else if
};
_global.gfn_Common_SetTimer = function (tick, ExFunc)
{
    var _loc1;
    for (var _loc1 = 0; _loc1 < 5; ++_loc1)
    {
        if (cTimer.func[_loc1] == ExFunc)
        {
            cTimer.StartTick[_loc1] = getTimer();
            cTimer.tick[_loc1] = tick;
            cTimer.func[_loc1] = ExFunc;
            _loc1 = -1;
            break;
        } // end if
    } // end of for
    if (_loc1 != -1)
    {
        for (var _loc1 = 0; _loc1 < 5; ++_loc1)
        {
            if (cTimer.tick[_loc1] == null)
            {
                cTimer.StartTick[_loc1] = getTimer();
                cTimer.tick[_loc1] = tick;
                cTimer.func[_loc1] = ExFunc;
                break;
            } // end if
        } // end of for
    } // end if
};
_global.gfn_Common_ResetTimer = function ()
{
    var _loc1;
    for (var _loc1 = 0; _loc1 < 5; ++_loc1)
    {
        cTimer.StartTick[_loc1] = null;
        cTimer.tick[_loc1] = null;
        cTimer.func[_loc1] = null;
    } // end of for
};
_global.gfn_Common_CheckTimerTick = function (ExFunc)
{
    var _loc1;
    for (var _loc1 = 0; _loc1 < 5; ++_loc1)
    {
        if (cTimer.func[_loc1] == ExFunc)
        {
            return (cTimer.tick[_loc1]);
        } // end if
    } // end of for
    return (null);
};
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
        if (MC._parent.getNextHighestDepth() != undefined)
        {
            MC.swapDepths(MC._parent.getNextHighestDepth());
        } // end if
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
        gfn_Common_SetMask(int(TargetMC._x), BGMC._height, BGMC, MaskMC);
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
        gfn_Common_SetMask(int(TargetMC._y), BGMC._width, BGMC, MaskMC);
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
        return (int(Current * 100 / Total));
    } // end else if
};
_global.gfn_Common_GetSeekBarRatio = function (TotalWidth, TargetWidth, curPos)
{
    var _loc1 = TotalWidth - TargetWidth;
    g_SeekRatio = int(curPos * 100 / _loc1);
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
    _loc3 = int(time / 3600);
    _loc2 = int(time % 3600 / 60);
    _loc1 = int(time % 3600 % 60);
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
    if (TextFieldName.maxhscroll >= 5)
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
            return (_loc2);
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
        return (-1);
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
_global.gfn_Common_ResetStringScroll = function (NumofReset)
{
    var _loc1;
    if (NumofReset == undefined)
    {
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
    }
    else
    {
        if (gScrollFlagArr[NumofReset] != null)
        {
            restoreAlign.align = gScrollAlign[NumofReset];
            gScrollFlagArr[NumofReset].setTextFormat(restoreAlign);
            restoreAlign.align = null;
        } // end if
        gScrollFlagArr[NumofReset].hscroll = 0;
        gScrollFlagArr[NumofReset] = null;
        gScrollDirection[NumofReset] = null;
        gScrollAlign[NumofReset] = null;
    } // end else if
};
_global.KEY_PLAY_SHORT = 0;
_global.KEY_PLAY_LONG = 1;
_global.KEY_REW_SHORT = 2;
_global.KEY_REW_LONG = 3;
_global.KEY_PLUS_SHORT = 4;
_global.KEY_PLUS_LONG = 5;
_global.KEY_FF_SHORT = 6;
_global.KEY_FF_LONG = 7;
_global.KEY_MINUS_SHORT = 8;
_global.KEY_MINUS_LONG = 9;
_global.TOUCH_REW = 10;
_global.TOUCH_REW_SHORT = 10;
_global.TOUCH_REW_LONG = 11;
_global.TOUCH_FF = 12;
_global.TOUCH_FF_SHORT = 12;
_global.TOUCH_FF_LONG = 13;
_global.TOUCH_PLUS = 14;
_global.TOUCH_PLUS_SHORT = 14;
_global.TOUCH_PLUS_LONG = 15;
_global.TOUCH_MINUS = 16;
_global.TOUCH_MINUS_SHORT = 16;
_global.TOUCH_MINUS_LONG = 17;
_global.KEY_RELEASE_LONG = 18;
_global.KEY_DISPLAY_UPDATE = 19;
_global.KEY_HOLD = 20;
_global.KEY_DISPLAY_ROTATE = 21;
_global.VKEY_PLUS = 100;
_global.VKEY_MINUS = 101;
_global.VKEY_FF = 102;
_global.VKEY_REW = 103;
_global.SHORTKEY_DELAY = 800;
_global.LONGKEY_REPEAT = 150;
_global.fLongkey = 0;
_global.startTick = 0;
var gapX;
var gapY;
var PressX;
var PressY;
var VKMC;
_global.InputHandler = function ()
{
    var _loc1;
    var _loc2;
    var _loc3;
};
g_TouchHandler = new InputHandler();
_global.Key_Type = 0;
_global.Key_StartTick = 0;
var keyObj = new Object();
_global.gfn_Key_CreateKeyListner = function (fn_Handle)
{
    var Key_CodeValue;
    keyObj.onKeyDown = function ()
    {
        Key_CodeValue = Key.getCode();
        if (Key_CodeValue >= 37 && Key_CodeValue <= 40 || Key_CodeValue == 32)
        {
            var _loc1 = getTimer();
            if (Key_CodeValue == 32)
            {
                Key_CodeValue = Key_CodeValue + 4;
            } // end if
            if (Key_Type == 0)
            {
                Key_StartTick = _loc1;
                Key_Type = 1;
            }
            else if (Key_Type == 1)
            {
                if (_loc1 - Key_StartTick > SHORTKEY_DELAY)
                {
                    Key_Type = 2;
                    Key_StartTick = _loc1;
                    fn_Handle((Key_CodeValue - 36 << 1) + 1);
                } // end if
            }
            else if (Key_CodeValue != 32)
            {
                if (_loc1 - Key_StartTick > LONGKEY_REPEAT)
                {
                    Key_Type = 2;
                    Key_StartTick = _loc1;
                    fn_Handle((Key_CodeValue - 36 << 1) + 1);
                } // end if
            } // end else if
        } // end else if
    };
    keyObj.onKeyUp = function ()
    {
        Key_CodeValue = Key.getCode();
        if (Key_CodeValue >= 37 && Key_CodeValue <= 40 || Key_CodeValue == 32)
        {
            if (Key_CodeValue == 32)
            {
                Key_CodeValue = Key_CodeValue + 4;
            } // end if
            if (Key_Type == 1)
            {
                fn_Handle(Key_CodeValue - 36 << 1);
            }
            else if (Key_Type == 2)
            {
                fn_Handle(KEY_RELEASE_LONG);
            } // end else if
            Key_Type = 0;
            Key_StartTick = 0;
        }
        else if (Key_CodeValue == 120)
        {
            unloadMovieNum(1);
        }
        else if (Key_CodeValue == 122)
        {
            fn_Handle(KEY_DISPLAY_ROTATE);
        }
        else if (Key_CodeValue == 123)
        {
            fn_Handle(KEY_DISPLAY_UPDATE);
        }
        else if (Key_CodeValue == 145)
        {
            fn_Handle(KEY_HOLD);
        } // end else if
    };
    Key.addListener(keyObj);
};
_global.gfn_Key_RemoveKeyListener = function ()
{
    var _loc1;
    _loc1 = Key.removeListener(keyObj);
};
_global.gfn_Key_SetVirtualKeyMC = function (TargetMC)
{
    VKMC = TargetMC;
};
_global.gfn_Key_GetVirtualKeyMC = function ()
{
    return (VKMC._name);
};
var mouseObj = new Object();
_global.gfn_Key_CreateTouchListener = function (fn_Handle)
{
    g_TouchHandler.fn_Handler = fn_Handle;
    g_TouchHandler.InputKey = -1;
    mouseObj.onMouseDown = function ()
    {
        startTick = getTimer();
        if (gfn_Key_GetVirtualKeyMC() != null && VKMC.hitTest(_root._xmouse, _root._ymouse, 0) == 1)
        {
            PressX = _root._xmouse;
            PressY = _root._ymouse;
        }
        else
        {
            PressX = null;
            PressY = null;
        } // end else if
    };
    mouseObj.onMouseMove = function ()
    {
        _level1.MCMouse._x = _root._xmouse;
        _level1.MCMouse._y = _root._ymouse;
        if (g_TouchHandler.fmouseDown)
        {
            if (fLongkey == 0)
            {
                if (getTimer() - startTick > SHORTKEY_DELAY)
                {
                    fLongkey = 1;
                    startTick = getTimer();
                } // end if
            }
            else if (fLongkey == 1)
            {
                if (getTimer() - startTick > LONGKEY_REPEAT)
                {
                    g_TouchHandler.fn_Handler(g_TouchHandler.InputKey + fLongkey);
                    startTick = getTimer();
                } // end if
            } // end if
        } // end else if
    };
    mouseObj.onMouseUp = function ()
    {
        if (fLongkey)
        {
            fn_Handle(KEY_RELEASE_LONG);
        } // end if
        startTick = 0;
        if (g_TouchHandler.fmouseDown == 0 && PressX != null)
        {
            gapX = _root._xmouse - PressX;
            gapY = _root._ymouse - PressY;
            if (Math.abs(gapX) > 40 || Math.abs(gapY) > 40)
            {
                if (Math.abs(gapX) < Math.abs(gapY))
                {
                    if (gapY <= 0)
                    {
                        g_TouchHandler.fn_Handler(VKEY_PLUS);
                    }
                    else
                    {
                        g_TouchHandler.fn_Handler(VKEY_MINUS);
                    } // end else if
                }
                else if (gapX <= 0)
                {
                    g_TouchHandler.fn_Handler(VKEY_REW);
                }
                else
                {
                    g_TouchHandler.fn_Handler(VKEY_FF);
                } // end if
            } // end else if
        } // end else if
        g_TouchHandler.fmouseDown = 0;
        g_TouchHandler.InputKey = -1;
    };
    Mouse.addListener(mouseObj);
};
_global.gfn_Key_RemoveTouchListener = function ()
{
    var _loc1;
    _loc1 = Mouse.removeListener(mouseObj);
};
_global.gfn_Key_GetLongkeyState = function ()
{
    return (fLongkey);
};
_global.gfn_KeyRepeatOn = function (keyType)
{
    g_TouchHandler.InputKey = keyType;
    g_TouchHandler.fmouseDown = 1;
};
_global.gfn_KeyRepeatOff = function ()
{
    fLongkey = 0;
    g_TouchHandler.fmouseDown = 0;
};
_global.MouseDrag = function (bt, mc, scrollMode, DragRegion)
{
    var DragWidth = DragRegion.widthgfn_SeekBarDrag >> 1;
    var DragHeight = DragRegion.height >> 1;
    var MCHalfWidth = mc._width >> 1;
    var MCHalfHeight = mc._height >> 1;
    bt.onPress = function ()
    {
        var ownX = mc._x;
        var ownY = mc._y;
        var tx = bt._xmouse;
        var ty = bt._ymouse;
        var _loc1 = 0;
        bt.onMouseMove = function ()
        {
            moveX = bt._xmouse - tx;
            moveY = bt._ymouse - ty;
            updateAfterEvent();
            if (scrollMode >= 2)
            {
                MCHalfHeight = mc._height >> 1;
                mc._x = ownX + moveX;
                if (DragWidth > MCHalfWidth)
                {
                    if (DragWidth * -1 + DragRegion.x > mc._x - MCHalfWidth)
                    {
                        mc._x = DragWidth * -1 + DragRegion.x + MCHalfWidth;
                    } // end if
                    if (DragWidth + DragRegion.x < mc._x + MCHalfWidth)
                    {
                        mc._x = DragWidth + DragRegion.x - MCHalfWidth;
                    } // end if
                }
                else
                {
                    if ((mc._width - DragWidth) * -1 > mc._x - MCHalfWidth)
                    {
                        mc._x = (mc._width - DragWidth - MCHalfWidth) * -1;
                    } // end if
                    if (mc._width - DragWidth < mc._x + MCHalfWidth)
                    {
                        mc._x = mc._width - DragWidth - MCHalfWidth;
                    } // end if
                } // end if
            } // end else if
            if (scrollMode == 1 || scrollMode == 3)
            {
                MCHalfHeight = mc._height >> 1;
                mc._y = ownY + moveY;
                if (DragHeight > MCHalfHeight)
                {
                    if (DragHeight * -1 + DragRegion.y > mc._y - MCHalfHeight)
                    {
                        mc._y = DragHeight * -1 + MCHalfHeight + DragRegion.y;
                    } // end if
                    if (DragHeight + DragRegion.y < mc._y + MCHalfHeight)
                    {
                        mc._y = DragHeight - MCHalfHeight + DragRegion.y;
                    } // end if
                }
                else
                {
                    if ((mc._height - DragHeight) * -1 > mc._y - MCHalfHeight)
                    {
                        mc._y = (MCHalfHeight - DragHeight) * -1;
                    } // end if
                    if (MCHalfHeight - DragHeight < mc._y)
                    {
                        mc._y = MCHalfHeight - DragHeight;
                    } // end if
                } // end if
            } // end else if
        };
    };
    bt.onRelease = bt.onReleaseOutside = function ()
    {
        delete bt.onMouseMove;
    };
};
_global.gfn_SeekBarDrag = function (BGMC, TargetMC, MaskMC, ScrollMode)
{
    var _loc3 = BGMC._width >> 1;
    var _loc1 = BGMC._height >> 1;
    var _loc4 = TargetMC._width >> 1;
    var _loc5 = TargetMC._height >> 1;
    var maskWidth = 0;
    TargetMC.onPress = function ()
    {
        var ownX = TargetMC._x;
        var _loc1 = TargetMC._y;
        var tx = BGMC._xmouse;
        var ty = BGMC._ymouse;
        TargetMC.onMouseMove = function ()
        {
            moveX = BGMC._xmouse - tx;
            moveY = BGMC._ymouse - ty;
            updateAfterEvent();
            if (ScrollMode == SCROLL_HORIZONTAL)
            {
                maskWidth = gfn_Common_GetSeekBarRatio(BGMC._width, TargetMC._width, ownX + moveX);
                gfn_Common_DrawSeekBar(BGMC, TargetMC, MaskMC, maskWidth, SCROLL_HORIZONTAL);
            }
            else if (ScrollMode == SCROLL_VERTICAL)
            {
                maskWidth = gfn_Common_GetSeekBarRatio(BGMC._width, TargetMC._width, ownX + moveX);
                gfn_Common_DrawSeekBar(BGMC, TargetMC, MaskMC, maskWidth, SCROLL_VERTICAL);
            } // end else if
        };
    };
    TargetMC.onRelease = TargetMC.onReleaseOutside = function ()
    {
        delete TargetMC.onMouseMove;
    };
};
_global.gfn_Mouse_GetCurrRatio = function (BGMC, TargetMC)
{
    var _loc1;
    var _loc2;
    _loc1 = BGMC._width - TargetMC._width;
    _loc2 = TargetMC._x + (_loc1 >> 1);
    return (Math.floor(_loc2 * 100 / _loc1));
};
var prevVolume = -1;
var currVolume = -1;
var prevBatt = -1;
var currBatt = -1;
var prevMin = -1;
var prevHold = -1;
var currHold = -1;
var prevBluetooth = -1;
var currBluetooth;
var display24Hour;
_global.gfn_systemInfo = function (Update)
{
    gfn_DispTime(Update);
    gfn_DispVolume(Update);
    gfn_DispBatt(Update);
    gfn_DispHold(Update);
    gfn_DispBluetooth(Update);
};
_global.gfn_DispVolume = function (Update)
{
    currVolume = ext_fscommand2("GetEtcVolume");
    if (Update == 1 || prevVolume != currVolume)
    {
        prevVolume = currVolume;
        _level1.MCCon.MCInfobar.TXVol.text = currVolume;
    } // end if
};
_global.gfn_DispTime = function (Update)
{
    var _loc2 = new Date();
    _global.g_curHour = _loc2.getHours();
    _global.g_curMin = _loc2.getMinutes();
    _global.g_curSec = _loc2.getSeconds();
    if (Update == 1 || _global.g_curMin != prevMin)
    {
        prevMin = _global.g_curMin;
        if (Update == 1)
        {
            display24Hour = ext_fscommand2("GetTim24HDisplay");
        } // end if
        if (display24Hour)
        {
            _level1.MCCon.MCInfobar.TXTime.text = gfn_Common_Get2ChiperNum(_global.g_curHour) + ":" + gfn_Common_Get2ChiperNum(_global.g_curMin);
        }
        else
        {
            var _loc3;
            if (_global.g_curHour < 12)
            {
                _loc3 = _global.g_curHour;
                _level1.MCCon.MCInfobar.TXAmPm.text = "AM";
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
                _level1.MCCon.MCInfobar.TXAmPm.text = "PM";
            } // end else if
            _level1.MCCon.MCInfobar.TXTime.text = gfn_Common_Get2ChiperNum(_loc3) + ":" + gfn_Common_Get2ChiperNum(_global.g_curMin);
        } // end else if
        if (Update == 1)
        {
            if (display24Hour)
            {
                _level1.MCCon.MCInfobar.TXAmPm._visible = false;
            }
            else
            {
                _level1.MCCon.MCInfobar.TXAmPm._visible = true;
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
        _level1.MCCon.MCInfobar.MCBatt.gotoAndStop(1 + currBatt);
    } // end if
};
_global.gfn_DispHold = function (Update)
{
    currHold = ext_fscommand2("GetSysHoldKey");
    if (Update == 1 || currHold != prevHold)
    {
        prevHold = currHold;
        _level1.MCCon.MCInfobar.MCHold.gotoAndStop(ext_fscommand2("GetSysCtrlHoldState") + 1);
        if (currHold == 1)
        {
            _level1.MCCon.MCInfobar.MCHold._visible = true;
        }
        else
        {
            _level1.MCCon.MCInfobar.MCHold._visible = false;
        } // end if
    } // end else if
};
_global.gfn_DispBluetooth = function (Update)
{
    currBluetooth = ext_fscommand2("GetBTHState");
    if (prevBluetooth != currBluetooth || Update == 1)
    {
        prevBluetooth = currBluetooth;
        if (prevBluetooth == 1)
        {
            _level1.MCCon.MCInfobar.MCBluetooth._visible = true;
        }
        else
        {
            _level1.MCCon.MCInfobar.MCBluetooth._visible = false;
        } // end if
    } // end else if
};
var popupKeyObj;
var VersionString;
var systemInfoTick = 0;
var resumeMode;
var prevMainNum;
var prevMainMenuIndex;
var curMainMenuIndex;
var redraw_WP = false;
var curWP_State = 0;
var prevWP_State = 0;
var WPLoader = new MovieClipLoader();
var WPListener = new Object();
WPListener.onLoadInit = function (mc)
{
    WPLoader.removeListener(WPListener);
};
WPListener.onLoadError = function (mc, errorCode)
{
    WPLoader.removeListener(WPListener);
    _root.attachMovie("MCDefaultBG", "MCBG", 0);
};
_global.Load_WallPaper = function (Void)
{
    if (g_CurrLauncherMode == MODE_MAIN)
    {
        prevWP_State = curWP_State;
        _root.MCBG.removeMovieClip();
        if (curWP_State)
        {
            _root.attachMovie("MCBG", "MCBG", 0);
            WPLoader.loadClip("WALLPAPER.BNG", "MCBG");
            WPLoader.addListener(WPListener);
        }
        else if (curMainMenuIndex == 0)
        {
            _root.attachMovie("MCMainDefaultBG", "MCBG", 0);
        }
        else
        {
            _root.attachMovie("MCMain3BG", "MCBG", 0);
        } // end else if
    }
    else if (g_CurrLauncherMode == MODE_VIDEO || g_CurrLauncherMode == MODE_PICTURE || g_CurrLauncherMode == MODE_DMB)
    {
        _root.MCBG.removeMovieClip();
    }
    else if (g_CurrLauncherMode == MODE_SETTING || g_CurrLauncherMode == MODE_BROWSER || g_CurrLauncherMode == MODE_TEXTBROWSER || g_CurrLauncherMode == MODE_FLASHBROWSER || g_CurrLauncherMode == MODE_ETC)
    {
        prevWP_State = curWP_State;
        _root.MCBG.removeMovieClip();
        _root.attachMovie("MCMainDefaultBG", "MCBG", 0);
    }
    else if (curWP_State)
    {
        _root.attachMovie("MCBG", "MCBG", 0);
        WPLoader.loadClip("WALLPAPER.BNG", "MCBG");
        WPLoader.addListener(WPListener);
    }
    else
    {
        prevWP_State = curWP_State;
        _root.MCBG.removeMovieClip();
        _root.attachMovie("MCMainDefaultBG", "MCBG", 0);
    } // end else if
};
_global.Reflush_Wallpaper = function ()
{
    redraw_WP = true;
};
_global.Load_SWF = function (ItemNum, FileName)
{
    var _loc4 = ext_fscommand2("EtcUsrGetMainmenu");
    _global.g_PrevLauncherMode = _global.g_CurrLauncherMode;
    _global.g_CurrLauncherMode = ItemNum;
    _global.gfn_Key_RemoveKeyListener();
    _global.gfn_Key_RemoveTouchListener();
    _global.gfn_Common_ResetStringScroll();
    _global.gfn_Common_ResetTimer();
    unloadMovieNum(1);
    if (curMainMenuIndex != _loc4)
    {
        prevMainMenuIndex = curMainMenuIndex;
        curMainMenuIndex = _loc4;
    } // end if
    curWP_State = ext_fscommand2("GetDisWallpaper");
    _global.Load_WallPaper();
    switch (ItemNum)
    {
        case MODE_MAIN:
        case MODE_MAIN2:
        case MODE_MAIN3:
        case MODE_WIDGET:
        case MODE_MUSIC:
        {
            switch (curMainMenuIndex)
            {
                case 1:
                {
                    loadMovieNum("System\\Flash UI\\mainmenu2.swf", 1);
                    break;
                }
                case 2:
                {
                    loadMovieNum("System\\Flash UI\\mainmenu3.swf", 1);
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
            loadMovieNum("System\\Flash UI\\movie.swf", 1);
            break;
        }
        case MODE_RECORD:
        {
            loadMovieNum("System\\Flash UI\\radio.swf", 1);
            break;
        }
        case MODE_PICTURE:
        {
            loadMovieNum("System\\Flash UI\\Record.swf", 1);
            break;
        }
        case MODE_TEXT:
        {
            loadMovieNum("System\\Flash UI\\picture.swf", 1);
            break;
        }
        case MODE_TEXTBROWSER:
        {
            loadMovieNum("System\\Flash UI\\text.swf", 1);
            break;
        }
        case MODE_FLASHBROWSER:
        case MODE_SETTING:
        {
            loadMovieNum("System\\Flash UI\\browser_total.swf", 1);
            break;
        }
        case MODE_BROWSER:
        {
            loadMovieNum("System\\Flash UI\\setting.swf", 1);
            break;
        }
        case MODE_DMB:
        {
            loadMovieNum("System\\Flash UI\\browser_total.swf", 1);
            break;
        }
        case MODE_DICTIONARY:
        {
            loadMovieNum("System\\Flash UI\\dmb.swf", 1);
            break;
        }
        case MODE_ETC:
        {
            loadMovieNum("System\\Flash UI\\PowerDicRun.swf", 1);
            break;
        }
        default:
        {
            var tempStr = "System\\Flash UI\\";
            tempStr = tempStr + FileName;
            var _loc3 = new LoadVars();
            _loc3._parent = this;
            _loc3.onLoad = function (success)
            {
                if (success == true)
                {
                    loadMovieNum(tempStr, 1);
                }
                else
                {
                    Load_SWF(g_PrevLauncherMode);
                } // end else if
            };
            _loc3.load(tempStr);
            break;
        }
    } // End of switch
};
this.onEnterFrame = function ()
{
    var _loc3 = getTimer();
    var _loc1;
    if (_loc3 - systemInfoTick > 500)
    {
        systemInfoTick = _loc3;
        gfn_DispTime(0);
        gfn_DispBatt(0);
    } // end if
    ++g_TextScrollCount;
    if (g_TextScrollCount >= g_TextScrollInterval)
    {
        g_TextScrollCount = 0;
    } // end if
    for (var _loc1 = 0; _loc1 < 5; ++_loc1)
    {
        if (cTimer.tick[_loc1] != null)
        {
            if (_loc3 - cTimer.StartTick[_loc1] >= cTimer.tick[_loc1])
            {
                cTimer.func[_loc1]();
                cTimer.StartTick[_loc1] = null;
                cTimer.tick[_loc1] = null;
                cTimer.func[_loc1] = null;
            } // end if
        } // end if
    } // end of for
    for (var _loc1 = 0; _loc1 < NUMOFSCROLLFIELD; ++_loc1)
    {
        if (gScrollFlagArr[_loc1] != null)
        {
            if (g_TextScrollCount == 0)
            {
                var _loc2 = gScrollFlagArr[_loc1];
                if (gScrollDirection[_loc1] == 0)
                {
                    ++_loc2.hscroll;
                    if (_loc2.hscroll >= _loc2.maxhscroll)
                    {
                        gScrollDirection[_loc1] = 1;
                    } // end if
                    continue;
                } // end if
                --_loc2.hscroll;
                if (_loc2.hscroll <= 0)
                {
                    gScrollDirection[_loc1] = 0;
                } // end if
            } // end if
        } // end if
    } // end of for
    if (g_fPopup == 1 && g_popupTimer)
    {
        if (_loc3 - g_popupTimer > 5000)
        {
            gfn_SetPopupMCName(null, 0);
        } // end if
    } // end if
};
launcherInit();

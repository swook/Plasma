function RegisterPopupMC(targetMC)
{
    var scale;
    if (popupMCName != targetMC)
    {
        if (popupMCName != null)
        {
            clearTimeout(__id);
            var tempMC = popupMCName;
            tempMC.onEnterFrame = function (Void)
            {
                scale = tempMC._xscale / 2;
                tempMC._xscale = scale;
                tempMC._yscale = scale;
                tempMC._alpha = scale;
                if (tempMC._xscale <= 10)
                {
                    delete tempMC.onEnterFrame;
                    tempMC._xscale = 100;
                    tempMC._yscale = 100;
                    tempMC._visible = false;
                    tempMC = null;
                } // end if
            };
        } // end if
        if (targetMC != null)
        {
            var scaleIndex = 0;
            var scaleArray;
            if (targetMC._height > 250 || targetMC._width > 250)
            {
                scaleArray = new Array(85, 95, 101, 99);
            }
            else
            {
                scaleArray = new Array(85, 95, 103, 98);
            } // end else if
            targetMC._visible = true;
            targetMC._xscale = targetMC._yscale = 60;
            targetMC._alpha = 100;
            targetMC.onEnterFrame = function (Void)
            {
                scale = scaleArray[scaleIndex];
                targetMC._xscale = scale;
                targetMC._yscale = scale;
                if (++scaleIndex > scaleArray.length)
                {
                    targetMC._xscale = 100;
                    targetMC._yscale = 100;
                    delete this.onEnterFrame;
                    delete scaleArray;
                } // end if
            };
            if (targetMC._parent != undefined)
            {
                targetMC.swapDepths(targetMC._parent.getNextHighestDepth());
            } // end if
        } // end if
        popupMCName = targetMC;
    } // end if
} // End of the function
function RegisterWallpaperListener(Void)
{
    wallpaperListener.onLoadInit = function (mc)
    {
        wallpaperLoader.removeListener(this);
    };
    wallpaperListener.onLoadError = function (mc, errorCode)
    {
        wallpaperLoader.removeListener(this);
        SetWallpaper(1);
    };
} // End of the function
function SetWallpaper(wallpaper)
{
    _root.MCBG.removeMovieClip();
    if (wallpaper == 1)
    {
        _root.attachMovie("MCDefaultBG", "MCBG", 0);
    }
    else if (wallpaper == 2)
    {
        _root.attachMovie("MCBG", "MCBG", 0);
        wallpaperLoader.loadClip("WALLPAPER.BNG", "MCBG");
        wallpaperLoader.addListener(wallpaperListener);
    } // end else if
    currentWallpaper = wallpaper;
} // End of the function
function LoadWallpaper(Void)
{
    if (currentLauncherMode == _global.MODE_VIDEO || currentLauncherMode == _global.MODE_DMB)
    {
        SetWallpaper(0);
    }
    else
    {
        switch (currentWallpaper)
        {
            case 0:
            {
                if (currentLauncherMode == _global.MODE_MAIN)
                {
                    SetWallpaper(userWallpaper + 1);
                }
                else if (currentLauncherMode == _global.MODE_BROWSER)
                {
                    if (currentBrowserBackground == 0)
                    {
                        SetWallpaper(1);
                    } // end if
                }
                else
                {
                    SetWallpaper(1);
                } // end else if
                break;
            }
            case 1:
            {
                if (currentLauncherMode == _global.MODE_MAIN && userWallpaper == 1)
                {
                    SetWallpaper(2);
                } // end if
                break;
            }
            case 2:
            {
                if (currentLauncherMode != _global.MODE_MAIN)
                {
                    SetWallpaper(1);
                } // end if
                break;
            }
        } // End of switch
    } // end else if
} // End of the function
function SaveConfiguration(Void)
{
    if (currentBrowserBackground == undefined)
    {
        currentBrowserBackground = 0;
    } // end if
    tempString = String(currentBrowserBackground);
    ext_fscommand2("SetEtcUIConfig", _global.MODE_LAUNCHER, tempString);
} // End of the function
function LoadConfiguration(Void)
{
    ext_fscommand2("GetEtcUIConfig", _global.MODE_LAUNCHER, "tempString");
    if (isNaN(tempString))
    {
        currentBrowserBackground = 0;
    }
    else
    {
        currentBrowserBackground = Number(tempString);
    } // end else if
} // End of the function
function LoadSwfFile(itemNumber, fileName)
{
    if (itemNumber == _global.MODE_ETC && fileName == undefined || itemNumber >= modeArray.length && itemNumber != initializeCountry)
    {
        return;
    } // end if
    _global.g_PrevLauncherMode = _global.g_CurrLauncherMode;
    _global.g_CurrLauncherMode = itemNumber;
    _global.gfn_Common_ResetTimer();
    prevLauncherMode = currentLauncherMode;
    currentLauncherMode = itemNumber;
    if (currentMode == -1)
    {
        currentMode = itemNumber;
    } // end if
    _global.RemovePopupMC();
    _global.RemoveKeyListener();
    _global.RemoveTouchListener();
    _global.CommonResetStringScroll();
    userWallpaper = ext_fscommand2("GetDisWallpaper");
    LoadWallpaper();
    unloadMovieNum(1);
    if (fileName == "Vokhan.swf" || fileName == "VokhanGuide.swf")
    {
        prevLauncherMode = -1;
        currentMode = _global.MODE_VOKHAN;
        ext_fscommand2("EtcModChangeMode", "Vokhan");
        if (fileName == "Vokhan.swf")
        {
            ext_fscommand2("VokhanInit");
        }
        else
        {
            ext_fscommand2("VokhanGuide");
        } // end else if
        ext_fscommand2("EtcModChangeMode", "Music");
        _global.LoadSWF(_global.MODE_MAIN);
        return;
    }
    else
    {
        var tempStr = "System\\Flash UI\\";
        if (itemNumber == _global.MODE_ETC)
        {
            tempStr = tempStr + fileName;
            var _loc5 = new LoadVars();
            _loc5._parent = this;
            _loc5.onLoad = function (success)
            {
                if (success == true)
                {
                    loadMovieNum(tempStr, 1);
                }
                else
                {
                    _global.LoadPrevSWF();
                } // end else if
            };
            _loc5.load(tempStr);
        }
        else if (itemNumber == initializeCountry)
        {
            loadMovieNum(String(tempStr + "init_country.swf"), 1);
        }
        else
        {
            if (itemNumber == _global.MODE_MAIN)
            {
                var _loc6 = ext_fscommand2("EtcUsrGetMainmenu");
                if (_loc6 < MAX_MAINMENU_NUMBER)
                {
                    tempStr = tempStr + ("mainmenu" + String(_loc6 + 1) + ".swf");
                }
                else
                {
                    tempStr = tempStr + "mainmenu1.swf";
                } // end else if
            }
            else
            {
                tempStr = tempStr + String(modeArray[itemNumber] + ".swf");
            } // end else if
            loadMovieNum(tempStr, 1);
        } // end else if
    } // end else if
} // End of the function
function RegisterSystemTickTimer(Void)
{
    var tempMC;
    var previousSecond = -1;
    var prevMinute = -1;
    var currentTickCount;
    var idx;
    MCEmpty.onEnterFrame = function (Void)
    {
        currentTickCount = getTimer();
        currentTime = new Date();
        _global.g_curSec = currentTime.getSeconds();
        if (_global.g_curSec != previousSecond)
        {
            _global.g_curMin = currentTime.getMinutes();
            if (prevMinute != _global.g_curMin)
            {
                _global.g_curHour = currentTime.getHours();
                _global.DisplayTime();
                prevMinute = _global.g_curMin;
            } // end if
            _global.DisplayBattery(0);
            previousSecond = _global.g_curSec;
        } // end if
        delete currentTime;
        for (idx = 0; idx < 3; idx++)
        {
            if (cTimer.tick[idx] != null)
            {
                if (currentTickCount - cTimer.StartTick[idx] >= cTimer.tick[idx])
                {
                    cTimer.func[idx]();
                    cTimer.StartTick[idx] = null;
                    cTimer.tick[idx] = null;
                    cTimer.func[idx] = null;
                } // end if
            } // end if
        } // end of for
        if (enableTextScrolling == true)
        {
            for (idx = 0; idx < NUMOFSCROLLFIELD; idx++)
            {
                if (scrollFlagArray[idx] != null)
                {
                    tempMC = scrollFlagArray[idx];
                    if (scrollDirection[idx] == 0)
                    {
                        ++tempMC.hscroll;
                        if (tempMC.hscroll >= tempMC.maxhscroll)
                        {
                            scrollDirection[idx] = 1;
                        } // end if
                        continue;
                    } // end if
                    --tempMC.hscroll;
                    if (tempMC.hscroll <= 0)
                    {
                        scrollDirection[idx] = 0;
                    } // end if
                } // end if
            } // end of for
        } // end if
    };
} // End of the function
function InitializeLauncher(Void)
{
    RegisterWallpaperListener();
    RegisterSystemTickTimer();
    LoadConfiguration();
    if (_global.GetFirmwareVersion() == _global.J3_OVERSEAS && ext_fscommand2("GetSysRegion") == -1)
    {
        LoadSwfFile(initializeCountry);
    }
    else
    {
        var _loc2 = ext_fscommand2("GetTimAlarmState");
        display24Hour = ext_fscommand2("GetTim24HDisplay");
        ext_fscommand2("EtcModGetResumeMode", "tempString");
        if (tempString == "Music")
        {
            _global.LoadSWF(_global.MODE_MUSIC);
        }
        else if (tempString == "Video")
        {
            _global.LoadSWF(_global.MODE_VIDEO);
        }
        else if (tempString == "Radio")
        {
            _global.LoadSWF(_global.MODE_RADIO);
        }
        else if (tempString == "Record")
        {
            _global.LoadSWF(_global.MODE_RECORD);
        }
        else if (tempString == "MobileTV")
        {
            _global.LoadSWF(_global.MODE_DMB);
        }
        else if (tempString == "Flash")
        {
            _global.LoadSWF(_global.MODE_FLASHBROWSER);
        }
        else if (tempString == "Text")
        {
            _global.LoadSWF(_global.MODE_TEXT);
        }
        else if (tempString == "Picture")
        {
            _global.LoadSWF(_global.MODE_PICTURE);
        }
        else if (tempString == "Dictionary")
        {
            _global.LoadSWF(_global.MODE_DICTIONARY);
        }
        else
        {
            _global.LoadSWF(_global.MODE_MAIN);
        } // end else if
    } // end else if
} // End of the function
_global.LCD_WIDTH = 272;
_global.LCD_HEIGHT = 480;
_global.SCROLL_VERTICAL = 1;
_global.SCROLL_HORIZONTAL = 2;
_global.SCROLL_FREE = 3;
_global.J3_DOMESTIC = 1;
_global.J3_OVERSEAS = 2;
_global.J3_DOMESTIC_DMB = 3;
_global.J3_DOMESTIC_VOKHAN = 4;
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
_global.MODE_LAUNCHER = 16;
_global.MODE_FLASHBROWSER = 17;
_global.MODE_TEXTBROWSER = 18;
_global.MODE_VOKHAN = 19;
_global.TEXT_ALIGN_UNDEFIEND = 0;
_global.TEXT_ALIGN_CENTER = 1;
_global.seekRatio = 0;
_global.g_curHour = 0;
_global.g_curMin = 0;
_global.g_curSec = 0;
var NUMOFSCROLLFIELD = 6;
var scrollDirection = new Array(0, 0, 0, 0, 0, 0);
var scrollFlagArray = new Array(null, null, null, null, null, null);
var scrollAlign = new Array(null, null, null, null, null, null);
var isFlipping = false;
var popupMCName = null;
var __id = -1;
var restoreAlign = new TextFormat();
_global.S9_NODMB_DIC = 1;
_global.S9_NODMB = 2;
_global.S9_DMB = 3;
_global.S9_NORWAY_DMB = 4;
_global.g_FirmwareVersion = 0;
_global.g_PrevLauncherMode = -1;
_global.g_CurrLauncherMode = -1;
_global.g_PrevBrowser = "unknown";
_global.g_Browser_CurrScale = 16;
_global.g_Browser_InitScale = 16;
_global.g_TextCurrScale;
_global.g_TextinitScale;
_global.g_Rec_CurMode = STATE_RECORD_STOP;
cTimer = new Object();
cTimer.startTick = new Array(null, null, null);
cTimer.tick = new Array(null, null, null);
cTimer.func = new Array(null, null, null);
_global.GetFlipStatus = function ()
{
    return (isFlipping);
};
_global.gfn_flipFooter = _global.FlipFooter = function (mcSideA, mcSideB, flipMode, fastMode)
{
    var step = 1;
    var chMenu = 0;
    var bgHalfHeight;
    var bgHeight;
    var _loc3 = mcSideA._parent;
    if (isFlipping == true)
    {
        return;
    } // end if
    switch (flipMode)
    {
        case _global.SCROLL_VERTICAL:
        {
            bgHeight = _loc3._width;
            if (fastMode)
            {
                bgHalfHeight = bgHeight * 8.000000E-001;
            }
            else
            {
                bgHalfHeight = bgHeight / 2;
            } // end else if
            isFlipping = true;
            _loc3.onEnterFrame = function (Void)
            {
                if (this._width < 1)
                {
                    step = 2;
                } // end if
                if (step == 1)
                {
                    if (this._width > bgHalfHeight)
                    {
                        this._width = this._width - bgHalfHeight;
                    }
                    else
                    {
                        this._width = 0;
                    } // end else if
                }
                else if (step == 2)
                {
                    if (bgHeight < bgHalfHeight + this._width)
                    {
                        this._width = bgHeight;
                        isFlipping = false;
                        delete this.onEnterFrame;
                    }
                    else
                    {
                        this._width = this._width + bgHalfHeight;
                    } // end else if
                    if (this._width > bgHalfHeight - 2 && chMenu == 0)
                    {
                        if (mcSideA._visible != mcSideB._visible)
                        {
                            mcSideA._visible = !mcSideA._visible;
                            mcSideB._visible = !mcSideB._visible;
                        }
                        else
                        {
                            mcSideA._visible = true;
                            mcSideB._visible = false;
                        } // end else if
                        chMenu = 1;
                    } // end if
                } // end else if
            };
            break;
        }
        default:
        {
            bgHeight = _loc3._height;
            if (fastMode)
            {
                bgHalfHeight = bgHeight * 8.000000E-001;
            }
            else
            {
                bgHalfHeight = bgHeight / 2;
            } // end else if
            isFlipping = true;
            _loc3.onEnterFrame = function (Void)
            {
                if (this._height < 1)
                {
                    step = 2;
                } // end if
                if (step == 1)
                {
                    if (this._height > bgHalfHeight)
                    {
                        this._height = this._height - bgHalfHeight;
                    }
                    else
                    {
                        this._height = 0;
                    } // end else if
                }
                else if (step == 2)
                {
                    if (this._height > bgHeight)
                    {
                        this._height = bgHalfHeight;
                    }
                    else if (bgHeight < bgHalfHeight + this._height)
                    {
                        this._height = bgHeight;
                        isFlipping = false;
                        delete this.onEnterFrame;
                    }
                    else
                    {
                        this._height = this._height + bgHalfHeight;
                    } // end else if
                    if (this._height > bgHalfHeight - 2 && chMenu == 0)
                    {
                        if (mcSideA._visible != mcSideB._visible)
                        {
                            mcSideA._visible = !mcSideA._visible;
                            mcSideB._visible = !mcSideB._visible;
                        }
                        else
                        {
                            mcSideA._visible = true;
                            mcSideB._visible = false;
                        } // end else if
                        chMenu = 1;
                    } // end if
                } // end else if
            };
            break;
        }
    } // End of switch
};
_global.gfn_SetPopupMCName = function (targetMC, timeOut)
{
    if (timeOut == undefined)
    {
        timeOut = 0;
    }
    else if (timeOut == 1)
    {
        timeOut = 5000;
    } // end else if
    _global.DisplayPopupMC(targetMC, timeOut);
};
_global.DisplayPopupMC = function (targetMC, timeOut)
{
    RegisterPopupMC(targetMC);
    if (timeOut == undefined)
    {
        timeOut = 0;
    } // end if
    if (timeOut > 0)
    {
        clearTimeout(__id);
        __id = setTimeout(_global.RemovePopupMC, timeOut);
    } // end if
};
_global.gfn_GetPopupMCName = _global.GetPopupMCName = function (Void)
{
    return (popupMCName._name);
};
_global.RemovePopupMC = function (Void)
{
    clearTimeout(__id);
    RegisterPopupMC(null);
};
_global.gfn_Common_DrawSeekBar = _global.CommonDrawSeekBar = function (bgMC, targetMC, maskMC, position, scrollMode)
{
    var _loc2;
    if (position < 0)
    {
        position = 0;
    }
    else if (position > 100)
    {
        position = 100;
    } // end else if
    switch (scrollMode)
    {
        case SCROLL_VERTICAL:
        {
            _loc2 = bgMC._height - targetMC._height;
            if (maskMC != null)
            {
                _loc2 = _loc2 + 24;
            } // end if
            targetMC._y = position * _loc2 / 100;
            maskMC._width = int(targetMC._y);
            maskMC._height = bgMC._width;
            bgMC.setMask(maskMC);
            break;
        }
        default:
        {
            _loc2 = bgMC._width - targetMC._width;
            if (maskMC != null)
            {
                _loc2 = _loc2 + 24;
            } // end if
            targetMC._x = position * _loc2 / 100;
            maskMC._width = int(targetMC._x);
            maskMC._height = bgMC._height;
            bgMC.setMask(maskMC);
            break;
        }
    } // End of switch
};
_global.gfn_Common_GetRatio = _global.CommonGetRatio = function (total, currentValue)
{
    if (currentValue == 0)
    {
        return (0);
    } // end if
    if (total == 0)
    {
        return (Infinity);
    } // end if
    return (int(currentValue * 100 / total));
};
_global.gfn_Common_GetSeekBarRatio = _global.CommonGetSeekBarRatio = function (totalWidth, targetWidth, currentPosition)
{
    _global.seekRatio = int(currentPosition * 100 / (totalWidth - targetWidth));
    if (_global.seekRatio < 0)
    {
        _global.seekRatio = 0;
    }
    else if (_global.seekRatio > 100)
    {
        _global.seekRatio = 100;
    } // end else if
    return (_global.seekRatio);
};
_global.gfn_Common_GetSeekRatio = _global.CommonGetSeekRatio = function (Void)
{
    return (_global.seekRatio);
};
_global.gfn_Common_Get2ChiperNum = _global.CommonGetTwoDigitNumber = Time.Conv.Num_2Dig;
_global.gfn_Common_GetTime2Text = _global.CommonGetTime2Text = Time.Conv.Text_hhmmss;
_global.gfn_Common_SetStringScroll = _global.CommonSetStringScroll = function (textFieldName, textAlign)
{
    var _loc5 = textFieldName.getTextFormat();
    if (textFieldName.maxhscroll >= 5)
    {
        var _loc3 = NUMOFSCROLLFIELD;
        for (var _loc2 = 0; _loc2 < NUMOFSCROLLFIELD; ++_loc2)
        {
            if (scrollFlagArray[_loc2] == textFieldName)
            {
                _loc3 = _loc2;
                break;
                continue;
            } // end if
            if (scrollFlagArray[_loc2] == null && _loc3 == NUMOFSCROLLFIELD)
            {
                _loc3 = _loc2;
            } // end if
        } // end of for
        if (_loc3 != NUMOFSCROLLFIELD)
        {
            scrollFlagArray[_loc3] = textFieldName;
            scrollDirection[_loc3] = 0;
            scrollAlign[_loc3] = _loc5.align;
            _loc5.align = "left";
            textFieldName.setTextFormat(_loc5);
            return (_loc3);
        } // end if
    }
    else
    {
        for (var _loc2 = 0; _loc2 < NUMOFSCROLLFIELD; ++_loc2)
        {
            if (scrollFlagArray[_loc2] == textFieldName)
            {
                scrollFlagArray[_loc2] = null;
                scrollDirection[_loc2] = 0;
                scrollAlign[_loc2] = 0;
                break;
            } // end if
        } // end of for
        if (textAlign == _global.TEXT_ALIGN_CENTER)
        {
            _loc5.align = "center";
            textFieldName.setTextFormat(_loc5);
        } // end if
        return (-1);
    } // end else if
    false;
    return (1);
};
_global.gfn_Common_StringScroll = _global.CommonStringScroll = function (Void)
{
    for (var _loc1 = 0; _loc1 < NUMOFSCROLLFIELD; ++_loc1)
    {
        if (scrollFlagArray[_loc1] != null)
        {
            if (scrollDirection[_loc1] == 0)
            {
                ++scrollFlagArray[_loc1].hscroll;
                if (scrollFlagArray[_loc1].hscroll >= scrollFlagArray[_loc1].maxhscroll)
                {
                    scrollDirection[_loc1] = 1;
                } // end if
                continue;
            } // end if
            --scrollFlagArray[_loc1].hscroll;
            if (scrollFlagArray[_loc1].hscroll <= 0)
            {
                scrollDirection[_loc1] = 0;
            } // end if
        } // end if
    } // end of for
};
_global.gfn_Common_ResetStringScroll = _global.CommonResetStringScroll = function (targetIdx)
{
    var _loc3;
    var _loc2;
    if (targetIdx == undefined)
    {
        _loc3 = 0;
        _loc2 = NUMOFSCROLLFIELD;
    }
    else
    {
        _loc3 = targetIdx;
        _loc2 = targetIdx + 1;
    } // end else if
    for (var _loc1 = _loc3; _loc1 < _loc2; ++_loc1)
    {
        if (scrollFlagArray[_loc1] != null)
        {
            restoreAlign.align = scrollAlign[_loc1];
            scrollFlagArray[_loc1].setTextFormat(restoreAlign);
            restoreAlign.align = null;
        } // end if
        scrollFlagArray[_loc1].hscroll = 0;
        scrollFlagArray[_loc1] = null;
        scrollDirection[_loc1] = null;
        scrollAlign[_loc1] = null;
    } // end of for
};
_global.CommonSetDigitMC = function (mc, number)
{
    mc.MCDigit1.gotoAndStop(int(number / 10) + 1);
    mc.MCDigit0.gotoAndStop(int(number % 10) + 1);
};
_global.gfn_Common_SetMask = function (maskWidth, maskHeight, bgMC, maskMC)
{
    maskMC._width = maskWidth;
    maskMC._height = maskHeight;
    bgMC.setMask(maskMC);
};
_global.gfn_ToggleVisibleState = function (targetMC)
{
    if (targetMC._visible == true)
    {
        targetMC._visible = false;
    }
    else
    {
        targetMC._visible = true;
    } // end else if
};
_global.gfn_Common_SetTimer = function (tick, exFunc)
{
    var _loc1;
    for (var _loc1 = 0; _loc1 < 3; ++_loc1)
    {
        if (cTimer.func[_loc1] == exFunc)
        {
            cTimer.StartTick[_loc1] = getTimer();
            cTimer.tick[_loc1] = tick;
            cTimer.func[_loc1] = exFunc;
            _loc1 = -1;
            break;
        } // end if
    } // end of for
    if (_loc1 != -1)
    {
        for (var _loc1 = 0; _loc1 < 3; ++_loc1)
        {
            if (cTimer.tick[_loc1] == null)
            {
                cTimer.StartTick[_loc1] = getTimer();
                cTimer.tick[_loc1] = tick;
                cTimer.func[_loc1] = exFunc;
                break;
            } // end if
        } // end of for
    } // end if
};
_global.gfn_Common_ResetTimer = function (Void)
{
    for (var _loc1 = 0; _loc1 < 3; ++_loc1)
    {
        cTimer.StartTick[_loc1] = null;
        cTimer.tick[_loc1] = null;
        cTimer.func[_loc1] = null;
    } // end of for
};
_global.gfn_Common_CheckTimerTick = function (exFunc)
{
    for (var _loc1 = 0; _loc1 < 3; ++_loc1)
    {
        if (cTimer.func[_loc1] == exFunc)
        {
            return (cTimer.tick[_loc1]);
        } // end if
    } // end of for
    return (null);
};
_global.Scale_OneDegree = function (mc, targetScale)
{
    var _loc2;
    var _loc4;
    if (targetScale > mc._xscale)
    {
        _loc2 = targetScale - mc._xscale >> 1;
        if (_loc2 <= 1)
        {
            mc._xscale = mc._yscale = targetScale;
            return (1);
        } // end if
        mc._xscale = mc._xscale + _loc2;
        mc._yscale = mc._yscale + _loc2;
    }
    else
    {
        _loc2 = targetScale - mc._xscale >> 1;
        if (_loc2 >= -1)
        {
            mc._xscale = mc._yscale = targetScale;
            return (1);
        } // end if
        mc._xscale = mc._xscale + _loc2;
        mc._yscale = mc._yscale + _loc2;
    } // end else if
    return (0);
};
_global.KEY_PLAY_SHORT = 0;
_global.KEY_PLAY_LONG = 1;
_global.KEY_FF_SHORT = 2;
_global.KEY_FF_LONG = 3;
_global.KEY_PLUS_SHORT = 4;
_global.KEY_PLUS_LONG = 5;
_global.KEY_REW_SHORT = 6;
_global.KEY_REW_LONG = 7;
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
_global.SETTING_FF = 200;
_global.SETTING_REW = 201;
var SHORTKEY_DELAY = 800;
var LONGKEY_REPEAT = 150;
var keyType = 0;
_global.fLongkey = 0;
var virtualKeyMC;
var keyObject = new Object();
var mouseObject = new Object();
var touchHandler = new Object();
with (touchHandler)
{
    functionHandler = null;
    inputKey = -1;
    fmouseDown = -1;
} // End of with
_global.gfn_Key_CreateKeyListner = _global.RegisterKeyListener = function (callBackFunction)
{
    var keyStartTick;
    var keyCode;
    keyObject.onKeyDown = function (Void)
    {
        keyCode = Key.getCode();
        if (keyCode == 32)
        {
            keyCode = keyCode + 4;
        } // end if
        if (keyCode >= 36 && keyCode <= 40)
        {
            var _loc1 = getTimer();
            if (keyType == 0)
            {
                keyStartTick = _loc1;
                keyType = 1;
                if (keyCode == 40 || keyCode == 38)
                {
                    callBackFunction((keyCode - 36) * 2 + 1);
                } // end if
            }
            else if (keyType == 1)
            {
                if (_loc1 - keyStartTick > SHORTKEY_DELAY)
                {
                    keyType = 2;
                    keyStartTick = _loc1;
                    callBackFunction((keyCode - 36) * 2 + 1);
                } // end if
            }
            else if (_loc1 - keyStartTick > LONGKEY_REPEAT)
            {
                keyType = 2;
                keyStartTick = _loc1;
                callBackFunction((keyCode - 36) * 2 + 1);
            } // end else if
        } // end else if
    };
    keyObject.onKeyUp = function (Void)
    {
        keyCode = Key.getCode();
        if (keyCode == 32)
        {
            keyCode = keyCode + 4;
        } // end if
        if (keyCode >= 36 && keyCode <= 40)
        {
            switch (keyType)
            {
                case 1:
                {
                    if (keyCode != 40 && keyCode != 38)
                    {
                        callBackFunction((keyCode - 36) * 2);
                    } // end if
                    break;
                }
                case 2:
                {
                    callBackFunction(_global.KEY_RELEASE_LONG);
                    break;
                }
                default:
                {
                    break;
                }
            } // End of switch
            keyType = 0;
            keyStartTick = 0;
        }
        else
        {
            switch (keyCode)
            {
                case 120:
                {
                    unloadMovieNum(1);
                    break;
                }
                case 121:
                {
                    if (!_global.CheckCurrentLauncherMode(_global.MODE_MAIN))
                    {
                        _global.LoadSWF(_global.MODE_MAIN);
                    } // end if
                    break;
                }
                case 122:
                {
                    callBackFunction(_global.KEY_DISPLAY_ROTATE);
                    break;
                }
                case 123:
                {
                    _global.UpdateSystemInfo(1);
                    callBackFunction(_global.KEY_DISPLAY_UPDATE);
                    break;
                }
                case 145:
                {
                    callBackFunction(_global.KEY_HOLD);
                    break;
                }
                default:
                {
                    break;
                }
            } // End of switch
        } // end else if
    };
    Key.addListener(keyObject);
};
_global.gfn_Key_RemoveKeyListener = _global.RemoveKeyListener = function (Void)
{
    var _loc1 = Key.removeListener(keyObject);
};
_global.gfn_Key_SetVirtualKeyMC = _global.SetVirtualKeyMC = function (targetMC)
{
    virtualKeyMC = targetMC;
};
_global.gfn_Key_GetVirtualKeyMC = _global.GetVirtualKeyMC = function (Void)
{
    return (virtualKeyMC._name);
};
_global.gfn_Key_CreateTouchListener = _global.CreateTouchListener = function (funcHandler)
{
    var startTick;
    var pressX;
    var pressY;
    touchHandler.functionHandler = funcHandler;
    touchHandler.inputKey = -1;
    mouseObject.onMouseDown = function (Void)
    {
        startTick = getTimer();
        if (GetVirtualKeyMC() != null && virtualKeyMC.hitTest(_root._xmouse, _root._ymouse, 0) == 1)
        {
            pressX = _root._xmouse;
            pressY = _root._ymouse;
        }
        else
        {
            pressX = null;
            pressY = null;
        } // end else if
    };
    mouseObject.onMouseMove = function (Void)
    {
        _level1.MCMouse._x = _root._xmouse;
        _level1.MCMouse._y = _root._ymouse;
        if (touchHandler.fmouseDown)
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
                    touchHandler.functionHandler(touchHandler.inputKey + fLongkey);
                    startTick = getTimer();
                } // end if
            } // end if
        } // end else if
    };
    mouseObject.onMouseUp = function (Void)
    {
        if (fLongkey)
        {
            touchHandler.functionHandler(_global.KEY_RELEASE_LONG);
        } // end if
        startTick = 0;
        if (touchHandler.fmouseDown == 0 && pressX != null)
        {
            var _loc4 = _root._xmouse - pressX;
            var _loc3 = _root._ymouse - pressY;
            if (Math.abs(_loc4) > 40 || Math.abs(_loc3) > 40)
            {
                if (Math.abs(_loc4) < Math.abs(_loc3))
                {
                    if (_loc3 <= 0)
                    {
                        touchHandler.functionHandler(_global.VKEY_PLUS);
                    }
                    else
                    {
                        touchHandler.functionHandler(_global.VKEY_MINUS);
                    } // end else if
                }
                else if (_loc4 <= 0)
                {
                    touchHandler.functionHandler(_global.VKEY_REW);
                }
                else
                {
                    touchHandler.functionHandler(_global.VKEY_FF);
                } // end if
            } // end else if
        } // end else if
        touchHandler.fmouseDown = 0;
        touchHandler.inputKey = -1;
    };
    Mouse.addListener(mouseObject);
};
_global.gfn_Key_RemoveTouchListener = _global.RemoveTouchListener = function (Void)
{
    Mouse.removeListener(mouseObject);
};
_global.gfn_Key_GetLongkeyState = _global.GetLongkeyState = function (Void)
{
    return (fLongkey);
};
_global.gfn_KeyRepeatOn = _global.KeyRepeatOn = function (keyType)
{
    touchHandler.inputKey = keyType;
    touchHandler.fmouseDown = 1;
};
_global.gfn_KeyRepeatOff = _global.KeyRepeatOff = function (Void)
{
    fLongkey = 0;
    touchHandler.fmouseDown = 0;
};
_global.RegisterDualTouchListener = function (touchListener, scale, UserInitFunction, UserApplyFunction, UserResetFunction)
{
    var currentDualDistance;
    var prevDualDistance;
    var diffDistance;
    var offset;
    var dualTouch = false;
    var preDualTouch = false;
    _global.RemoveDualTouchListener();
    touchListener.InitializeDualTouchInput = function (Void)
    {
        dualTouch = false;
        preDualTouch = false;
    };
    touchListener.ApplyDualTouch = function (Void)
    {
        diffDistance = currentDualDistance - offset;
        if (Math.abs(prevDualDistance - diffDistance) > 30 && currentDualDistance <= 0)
        {
            UserResetFunction();
            dualTouch = false;
            prevDualDistance = 0;
            offset = 0;
        }
        else
        {
            prevDualDistance = diffDistance;
            if (diffDistance < -100)
            {
                diffDistance = -100;
            }
            else if (diffDistance > 100)
            {
                diffDistance = 100;
            } // end else if
            UserApplyFunction(int(scale * diffDistance / 100));
        } // end else if
    };
    touchListener.CheckDualTouchInput = function (Void)
    {
        var _loc2 = false;
        currentDualDistance = ext_fscommand2("GetEtcDualDistance");
        currentDualDistance = currentDualDistance >> 2;
        if (dualTouch == true)
        {
            this.ApplyDualTouch();
            _loc2 = true;
        }
        else if (currentDualDistance > 0)
        {
            dualTouch = true;
            preDualTouch = true;
            offset = currentDualDistance;
            prevDualDistance = 0;
            UserInitFunction();
            this.ApplyDualTouch();
            _loc2 = true;
        } // end else if
        if (preDualTouch == true)
        {
            return (true);
        }
        else
        {
            return (_loc2);
        } // end else if
    };
    touchListener.GetDualTouchStatus = function (Void)
    {
        return (preDualTouch);
    };
};
_global.RemoveDualTouchListener = function (touchListener)
{
    delete touchListener.ApplyDualTouch;
    delete touchListener.CheckDualTouchInput;
};
var tempHour;
var mcInfobar;
var prevVolume = -1;
var prevBattery = -1;
var prevHoldStatus = -1;
var prevBluetooth = -1;
var prevAudioOut = -1;
var currentTime;
var currentVolume = 0;
var currentBattery = 0;
var currentHoldStatus = 0;
var currentBluetooth = 0;
var display24Hour = 0;
var currentAudioOut = 0;
var muteState = 0;
var baseVolumeOfBoost = -1;
var playShuffle = -1;
var playBoundary = -1;
_global.gfn_systemInfo = _global.UpdateSystemInfo = function (forceUpdate)
{
    display24Hour = ext_fscommand2("GetTim24HDisplay");
    _global.DisplayTime(forceUpdate);
    _global.DisplayBattery(forceUpdate);
    _global.DisplayHold(forceUpdate);
    _global.DisplayPlayStatus();
    _global.DisplayBluetooth(forceUpdate);
    _global.DisplayAudioOut(forceUpdate);
    _global.DisplayVolume(forceUpdate);
};
_global.DisplayPlayStatus = function (Void)
{
    if (ext_fscommand2("GetEtcState") == _global.STATE_MUSIC_PLAY)
    {
        var _loc2 = _level1.MCCon.MCInfobar.MCMusicStatus;
        playShuffle = Number(ext_fscommand2("GetAudShuffle"));
        playBoundary = Number(ext_fscommand2("GetAudBoundary"));
        _loc2.MCShuffle.gotoAndStop(playShuffle + 1);
        _loc2.MCBoundary.gotoAndStop(playBoundary + 1);
        _loc2.MCPlayStop.gotoAndStop(1);
        _loc2._visible = true;
    }
    else
    {
        _level1.MCCon.MCInfobar.MCMusicStatus._visible = false;
    } // end else if
};
_global.DisplayAudioOut = function (forceUpdate)
{
    muteState = ext_fscommand2("GetEtcAudioOutMute");
    currentAudioOut = ext_fscommand2("GetEtcAudioOutDevice") + muteState * 3;
    if (forceUpdate == 1 || prevAudioOut != currentAudioOut)
    {
        prevAudioOut = currentAudioOut;
        _level1.MCCon.MCInfobar.MCVolumeIcon.gotoAndStop(currentAudioOut + 1);
        _level1.MCCon.MCInfobar.MCBluetooth.gotoAndStop(ext_fscommand2("GetBTHState2") < 2 ? (1) : (2));
        _level1.MCCon.MCInfobar.TXVol._visible = muteState == 0 ? (true) : (false);
    } // end if
};
_global.gfn_DispVolume = _global.DisplayVolume = function (forceUpdate)
{
    currentVolume = ext_fscommand2("GetEtcVolume");
    if (forceUpdate == 1 || prevVolume != currentVolume)
    {
        prevVolume = currentVolume;
        baseVolumeOfBoost = ext_fscommand2("GetEtcVolumeBoost");
        if (baseVolumeOfBoost != -1 && currentVolume >= baseVolumeOfBoost)
        {
            _level1.MCCon.MCInfobar.TXVol.textColor = 14486026;
        }
        else
        {
            _level1.MCCon.MCInfobar.TXVol.textColor = 6866144;
        } // end else if
        _level1.MCCon.MCInfobar.TXVol.text = _global.CommonGetTwoDigitNumber(currentVolume);
    } // end if
};
_global.gfn_DispTime = _global.DisplayTime = function (forceUpdate)
{
    if (forceUpdate == 1)
    {
        currentTime = new Date();
        _global.g_curHour = currentTime.getHours();
        _global.g_curMin = currentTime.getMinutes();
        _global.g_curSec = currentTime.getSeconds();
        delete currentTime;
    } // end if
    mcInfobar = _level1.MCCon.MCInfobar;
    tempHour = _global.g_curHour;
    if (display24Hour == 0)
    {
        if (tempHour < 12)
        {
            mcInfobar.TXAmPm.text = "AM";
        }
        else
        {
            mcInfobar.TXAmPm.text = "PM";
            if (tempHour != 12)
            {
                tempHour = tempHour - 12;
            } // end if
        } // end else if
        mcInfobar.TXAmPm._visible = true;
    }
    else
    {
        mcInfobar.TXAmPm._visible = false;
    } // end else if
    mcInfobar.TXTime.text = _global.CommonGetTwoDigitNumber(tempHour) + ":" + _global.CommonGetTwoDigitNumber(_global.g_curMin);
};
_global.gfn_DispBatt = _global.DisplayBattery = function (forceUpdate)
{
    currentBattery = ext_fscommand2("GetSysBattery");
    if (forceUpdate == 1 || currentBattery != prevBattery)
    {
        prevBattery = currentBattery;
        _level1.MCCon.MCInfobar.MCBatt.gotoAndStop(currentBattery + 1);
        _level1.MCCon.MCInfobar.MCBattery.gotoAndStop(currentBattery + 1);
    } // end if
};
_global.gfn_DispHold = _global.DisplayHold = function (forceUpdate)
{
    currentHoldStatus = ext_fscommand2("GetSysHoldKey");
    if (forceUpdate == 1 || currentHoldStatus != prevHoldStatus)
    {
        prevHoldStatus = currentHoldStatus;
        _level1.MCCon.MCInfobar.MCHold.gotoAndStop(ext_fscommand2("GetSysCtrlHoldState") + 1);
        _level1.MCCon.MCInfobar.MCHold._visible = currentHoldStatus == 1 ? (true) : (false);
    } // end if
};
_global.gfn_DispBluetooth = _global.DisplayBluetooth = function (forceUpdate)
{
    currentBluetooth = ext_fscommand2("GetBTHState2");
    if (forceUpdate == 1 || prevBluetooth != currentBluetooth)
    {
        prevBluetooth = currentBluetooth;
        _level1.MCCon.MCInfobar.MCBluetooth._visible = currentBluetooth > 0 ? (true) : (false);
        if (currentBluetooth % 2 == 0)
        {
            var delay = 12;
            _level1.MCCon.MCInfobar.MCBluetooth.onEnterFrame = function (Void)
            {
                if (delay-- < 0)
                {
                    delay = 12;
                    _level1.MCCon.MCInfobar.MCBluetooth._visible = !_level1.MCCon.MCInfobar.MCBluetooth._visible;
                } // end if
            };
        }
        else
        {
            delete _level1.MCCon.MCInfobar.MCBluetooth.onEnterFrame;
        } // end if
    } // end else if
};
var tempString;
var versionString;
var pauseSystemTimer = false;
var firmwareVersion = -1;
var prevLauncherMode = -1;
var currentLauncherMode = -1;
var currentMode = -1;
var previousMode = -1;
var loading = false;
var modeArray = new Array("music", "movie", "radio", "record", "dmb", "browser_total", "text", "picture", "PowerDicRun", "null", "null", "mainmenu", "mainmenu", "mainmenu", "Setting", "browser_total", "null", "browser_total", "browser_total");
var initializeCountry = 99;
var enableTextScrolling = true;
var MAX_MAINMENU_NUMBER = 3;
var DEFAULT_HEADER_HEIGHT = 59;
var userWallpaper = 0;
var currentWallpaper = 0;
var wallpaperLoader = new MovieClipLoader();
var wallpaperListener = new Object();
var currentBrowserBackground = 0;
var alarmSettingFlag = false;
_global.ChangeWallpaper = function (imgNumber, isBrowser)
{
    SetWallpaper(0);
    if (imgNumber == 0)
    {
        SetWallpaper(1);
    } // end if
    if (isBrowser == true)
    {
        currentBrowserBackground = imgNumber;
        SaveConfiguration();
    } // end if
};
_global.SetBrowserWallpaper = function (imgNumber)
{
    currentBrowserBackground = imgNumber;
    SaveConfiguration();
};
_global.GetBrowserWallpaper = function (Void)
{
    return (currentBrowserBackground);
};
_global.Load_SWF = _global.LoadSWF = function (itemNumber, fileName)
{
    var _loc4 = 0;
    if (loading == true)
    {
        return;
    } // end if
    previousMode = currentMode;
    currentMode = itemNumber;
    if (currentLauncherMode == _global.MODE_VIDEO)
    {
        LoadSwfFile(itemNumber, fileName);
    }
    else if (itemNumber == _global.MODE_VIDEO)
    {
        ext_fscommand2("EtcModChangeMode", "Video");
        if (ext_fscommand2("GetEtcCurPLIndex") < 0)
        {
            if (currentLauncherMode == _global.MODE_BROWSER)
            {
                _global.LoadSWF(_global.MODE_MAIN);
            }
            else
            {
                currentMode = _global.MODE_MAIN;
                _global.LoadSWF(_global.MODE_BROWSER);
            } // end else if
        }
        else
        {
            LoadSwfFile(itemNumber, fileName);
        } // end else if
    }
    else
    {
        if (itemNumber == _global.MODE_MUSIC)
        {
            ext_fscommand2("EtcModChangeMode", "Music");
            if (ext_fscommand2("GetEtcCurPLIndex") < 0)
            {
                if (currentLauncherMode == _global.MODE_BROWSER)
                {
                    _global.LoadSWF(_global.MODE_MAIN);
                }
                else
                {
                    currentMode = _global.MODE_MAIN;
                    _global.LoadSWF(_global.MODE_BROWSER);
                } // end else if
                return;
            } // end if
        }
        else if (itemNumber == _global.MODE_TEXT)
        {
            ext_fscommand2("EtcModChangeMode", "Text");
            if (ext_fscommand2("EtcTxtOpen") != 1)
            {
                if (currentLauncherMode == _global.MODE_BROWSER)
                {
                    _global.LoadSWF(_global.MODE_MAIN);
                }
                else
                {
                    currentMode = _global.MODE_MAIN;
                    _global.LoadSWF(_global.MODE_BROWSER);
                } // end else if
                return;
            } // end if
        } // end else if
        LoadSwfFile(itemNumber, fileName);
    } // end else if
};
_global.LoadPrevSWF = function (Void)
{
    if (prevLauncherMode == -1)
    {
        prevLauncherMode = _global.MODE_MAIN;
    } // end if
    LoadSwfFile(prevLauncherMode);
};
_global.CheckCurrentLauncherMode = function (mode)
{
    if (currentMode == mode)
    {
        return (true);
    }
    else
    {
        return (false);
    } // end else if
};
_global.GetCurrentLauncherMode = function (Void)
{
    return (currentMode);
};
_global.CheckPrevLauncherMode = function (mode)
{
    if (previousMode == mode)
    {
        return (true);
    }
    else
    {
        return (false);
    } // end else if
};
_global.GetPrevLauncherMode = function (Void)
{
    return (previousMode);
};
_global.ResumeTextScrolling = function (Void)
{
    enableTextScrolling = true;
};
_global.PauseTextScrolling = function (Void)
{
    enableTextScrolling = false;
};
_global.SetAlarmSettingFlag = function (flag)
{
    alarmSettingFlag = flag;
};
_global.GetFirmwareVersion = function (Void)
{
    if (firmwareVersion == -1)
    {
        ext_fscommand2("GetSysVersion", "versionString");
        firmwareVersion = Number(versionString.substring(0, 1));
        if (firmwareVersion == 0)
        {
            firmwareVersion = _global.J3_DOMESTIC_DMB;
        } // end if
        _global.g_FirmwareVersion = firmwareVersion;
    } // end if
    return (firmwareVersion);
};
_global.GetAlarmSettingFlag = function (Void)
{
    return (alarmSettingFlag);
};
InitializeLauncher();


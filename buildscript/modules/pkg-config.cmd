@setlocal
@set pkgconfigloc=null

@rem pkg-config. Can be (1) present (0) missing/broken.
@rem Try building pkgconf
@set pkgconfigstate=1
@call %devroot%\%projectname%\buildscript\modules\pkgconf.cmd
@IF EXIST %devroot%\pkgconf\pkgconf\pkg-config.exe set pkgconfigloc=%devroot%\pkgconf\pkgconf
@IF EXIST %devroot%\pkgconf\pkgconf\pkg-config.exe GOTO doneenvcheck

@rem pkg-config fallback code
@IF %msysstate%==0 GOTO nonmingwpkgconfig
@GOTO nonmingwpkgconfig
@call %devroot%\%projectname%\buildscript\modules\msysupdate.cmd
@%msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -S ${MINGW_PACKAGE_PREFIX}-pkg-config --needed --noconfirm --disable-download-timeout"
@echo.
@set pkgconfigloc=%msysloc%\mingw32\bin
@IF %abi%==x64 set pkgconfigloc=%msysloc%\mingw64\bin
@GOTO doneenvcheck

:nonmingwpkgconfig
@rem Look for pkg-config-lite and standalone pkg-config
@set pkgconfigloc=%devroot%\pkgconfig\bin
@IF EXIST %pkgconfigloc%\pkg-config.exe IF NOT EXIST %pkgconfigloc%\x86_64-w64-mingw32-pkg-config.exe IF NOT EXIST %pkgconfigloc%\i686-w64-mingw32-pkg-config.exe GOTO doneenvcheck
@IF EXIST %pkgconfigloc%\pkg-config.exe IF EXIST %pkgconfigloc%\x86_64-w64-mingw32-pkg-config.exe IF EXIST %pkgconfigloc%\libwinpthread-1.dll GOTO doneenvcheck
@IF EXIST %pkgconfigloc%\pkg-config.exe IF EXIST %pkgconfigloc%\i686-w64-mingw32-pkg-config.exe IF EXIST %pkgconfigloc%\libwinpthread-1.dll GOTO doneenvcheck

@set pkgconfigloc=%devroot%\pkg-config\bin
@IF EXIST %pkgconfigloc%\pkg-config.exe IF NOT EXIST %pkgconfigloc%\x86_64-w64-mingw32-pkg-config.exe IF NOT EXIST %pkgconfigloc%\i686-w64-mingw32-pkg-config.exe GOTO doneenvcheck
@IF EXIST %pkgconfigloc%\pkg-config.exe IF EXIST %pkgconfigloc%\x86_64-w64-mingw32-pkg-config.exe IF EXIST %pkgconfigloc%\libwinpthread-1.dll GOTO doneenvcheck
@IF EXIST %pkgconfigloc%\pkg-config.exe IF EXIST %pkgconfigloc%\i686-w64-mingw32-pkg-config.exe IF EXIST %pkgconfigloc%\libwinpthread-1.dll GOTO doneenvcheck

@set pkgconfigloc=%devroot%\pkgconfiglite\bin
@IF EXIST %pkgconfigloc%\pkg-config.exe IF NOT EXIST %pkgconfigloc%\x86_64-w64-mingw32-pkg-config.exe IF NOT EXIST %pkgconfigloc%\i686-w64-mingw32-pkg-config.exe GOTO doneenvcheck
@IF EXIST %pkgconfigloc%\pkg-config.exe IF EXIST %pkgconfigloc%\x86_64-w64-mingw32-pkg-config.exe IF EXIST %pkgconfigloc%\libwinpthread-1.dll GOTO doneenvcheck
@IF EXIST %pkgconfigloc%\pkg-config.exe IF EXIST %pkgconfigloc%\i686-w64-mingw32-pkg-config.exe IF EXIST %pkgconfigloc%\libwinpthread-1.dll GOTO doneenvcheck

@set pkgconfigloc=%devroot%\pkg-config-lite\bin
@IF EXIST %pkgconfigloc%\pkg-config.exe IF NOT EXIST %pkgconfigloc%\x86_64-w64-mingw32-pkg-config.exe IF NOT EXIST %pkgconfigloc%\i686-w64-mingw32-pkg-config.exe GOTO doneenvcheck
@IF EXIST %pkgconfigloc%\pkg-config.exe IF EXIST %pkgconfigloc%\x86_64-w64-mingw32-pkg-config.exe IF EXIST %pkgconfigloc%\libwinpthread-1.dll GOTO doneenvcheck
@IF EXIST %pkgconfigloc%\pkg-config.exe IF EXIST %pkgconfigloc%\i686-w64-mingw32-pkg-config.exe IF EXIST %pkgconfigloc%\libwinpthread-1.dll GOTO doneenvcheck

@set pkgconfigstate=0

:doneenvcheck
@endlocal&set pkgconfigstate=%pkgconfigstate%&set pkgconfigloc=%pkgconfigloc%
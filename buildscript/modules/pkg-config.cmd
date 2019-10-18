@rem pkg-config. Can be (1) present (0) missing/broken. Only valid for Meson build.
@IF %mesabldsys%==scons set pkgconfigstate=0
@IF %mesabldsys%==scons GOTO doneenvcheck

@rem Try building pkgconf
@set pkgconfigstate=1
@call %mesa%\mesa-dist-win\buildscript\modules\pkgconf.cmd
@IF EXIST %mesa%\pkgconf\build\pkg-config.exe set pkgconfigloc=%mesa%\pkgconf\build
@IF EXIST %mesa%\pkgconf\build\pkg-config.exe GOTO doneenvcheck

@rem pkg-config fallback code
@IF %msysstate%==0 GOTO nonmingwpkgconfig
@GOTO nonmingwpkgconfig
@call %mesa%\mesa-dist-win\buildscript\modules\msysupdate.cmd
@%msysloc%\usr\bin\bash --login -c "pacman -S mingw-w64-%mingwabi%-pkg-config --needed --noconfirm --disable-download-timeout"
@echo.
@set pkgconfigloc=%msysloc%\mingw%minabi%\bin
@GOTO doneenvcheck

:nonmingwpkgconfig
@rem Look for pkg-config-lite and standalone pkg-config
@set pkgconfigloc=%mesa%\pkgconfig\bin
@IF EXIST %pkgconfigloc%\pkg-config.exe IF NOT EXIST %pkgconfigloc%\x86_64-w64-mingw32-pkg-config.exe IF NOT EXIST %pkgconfigloc%\i686-w64-mingw32-pkg-config.exe GOTO doneenvcheck
@IF EXIST %pkgconfigloc%\pkg-config.exe IF EXIST %pkgconfigloc%\x86_64-w64-mingw32-pkg-config.exe IF EXIST %pkgconfigloc%\libwinpthread-1.dll GOTO doneenvcheck
@IF EXIST %pkgconfigloc%\pkg-config.exe IF EXIST %pkgconfigloc%\i686-w64-mingw32-pkg-config.exe IF EXIST %pkgconfigloc%\libwinpthread-1.dll GOTO doneenvcheck

@set pkgconfigloc=%mesa%\pkg-config\bin
@IF EXIST %pkgconfigloc%\pkg-config.exe IF NOT EXIST %pkgconfigloc%\x86_64-w64-mingw32-pkg-config.exe IF NOT EXIST %pkgconfigloc%\i686-w64-mingw32-pkg-config.exe GOTO doneenvcheck
@IF EXIST %pkgconfigloc%\pkg-config.exe IF EXIST %pkgconfigloc%\x86_64-w64-mingw32-pkg-config.exe IF EXIST %pkgconfigloc%\libwinpthread-1.dll GOTO doneenvcheck
@IF EXIST %pkgconfigloc%\pkg-config.exe IF EXIST %pkgconfigloc%\i686-w64-mingw32-pkg-config.exe IF EXIST %pkgconfigloc%\libwinpthread-1.dll GOTO doneenvcheck

@set pkgconfigloc=%mesa%\pkgconfiglite\bin
@IF EXIST %pkgconfigloc%\pkg-config.exe IF NOT EXIST %pkgconfigloc%\x86_64-w64-mingw32-pkg-config.exe IF NOT EXIST %pkgconfigloc%\i686-w64-mingw32-pkg-config.exe GOTO doneenvcheck
@IF EXIST %pkgconfigloc%\pkg-config.exe IF EXIST %pkgconfigloc%\x86_64-w64-mingw32-pkg-config.exe IF EXIST %pkgconfigloc%\libwinpthread-1.dll GOTO doneenvcheck
@IF EXIST %pkgconfigloc%\pkg-config.exe IF EXIST %pkgconfigloc%\i686-w64-mingw32-pkg-config.exe IF EXIST %pkgconfigloc%\libwinpthread-1.dll GOTO doneenvcheck

@set pkgconfigloc=%mesa%\pkg-config-lite\bin
@IF EXIST %pkgconfigloc%\pkg-config.exe IF NOT EXIST %pkgconfigloc%\x86_64-w64-mingw32-pkg-config.exe IF NOT EXIST %pkgconfigloc%\i686-w64-mingw32-pkg-config.exe GOTO doneenvcheck
@IF EXIST %pkgconfigloc%\pkg-config.exe IF EXIST %pkgconfigloc%\x86_64-w64-mingw32-pkg-config.exe IF EXIST %pkgconfigloc%\libwinpthread-1.dll GOTO doneenvcheck
@IF EXIST %pkgconfigloc%\pkg-config.exe IF EXIST %pkgconfigloc%\i686-w64-mingw32-pkg-config.exe IF EXIST %pkgconfigloc%\libwinpthread-1.dll GOTO doneenvcheck

@set pkgconfigstate=0

:doneenvcheck

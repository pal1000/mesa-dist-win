@rem Ninja build system. Can have all states.
@SET ERRORLEVEL=0
@SET ninjaloc=ninja.exe
@set ninjastate=2
@where /q ninja.exe
@IF ERRORLEVEL 1 set ninjaloc=%mesa%\ninja\ninja.exe
@IF %ninjaloc%==%mesa%\ninja\ninja.exe set ninjastate=1
@IF %ninjastate%==1 IF NOT EXIST %ninjaloc% set ninjastate=0

@rem CMake build generator. Can have all states.
@SET ERRORLEVEL=0
@SET cmakeloc=cmake.exe
@set cmakestate=2
@where /q cmake.exe
@IF ERRORLEVEL 1 set cmakeloc=%mesa%\cmake\bin\cmake.exe
@IF %cmakeloc%==%mesa%\cmake\bin\cmake.exe set cmakestate=1
@IF %cmakestate%==1 IF NOT EXIST %cmakeloc% set cmakestate=0

@rem Git version control. Can either be always present (2) or missing (0).
@SET ERRORLEVEL=0
@set gitstate=2
@where /q git.exe
@IF ERRORLEVEL 1 set gitstate=0

@rem winflexbison. Can have all states.
@SET ERRORLEVEL=0
@SET flexloc=win_flex.exe
@set flexstate=2
@where /q win_flex.exe
@IF ERRORLEVEL 1 set flexloc=%mesa%\flexbison\win_flex.exe
@IF %flexloc%==%mesa%\flexbison\win_flex.exe set flexstate=1
@IF %flexstate%==1 IF NOT EXIST %flexloc% set flexstate=0

@rem pkg-config. Can be (1) present (0) missing/broken. Only valid for Python 3.x
@IF %pythonver%==2 set pkgconfigstate=0
@IF %pythonver%==2 GOTO doneenvcheck
@set pkgconfigstate=1
@IF %msysstate%==0 GOTO nonmingwpkgconfig
@call %mesa%\mesa-dist-win\buildscript\modules\msysupdate.cmd
@%runmsys% pacman -S mingw-w64-%mingwabi%-pkg-config --needed --noconfirm --disable-download-timeout
@set PKG_CONFIG_PATH=%msysloc%\mingw%minabi%\bin
@GOTO doneenvcheck

:nonmingwpkgconfig
@rem Look for pkg-config-lite and standalone pkg-config
@set pkgconfloc=%mesa%\pkgconfig
@IF EXIST %pkgconfloc%\pkg-config.exe IF NOT EXIST %pkgconfloc%\x86_64-w64-mingw32-pkg-config.exe IF NOT EXIST %pkgconfloc%\i686-w64-mingw32-pkg-config.exe SET PKG_CONFIG_PATH=%pkgconfloc%
@IF EXIST %pkgconfloc%\pkg-config.exe IF EXIST %pkgconfloc%\x86_64-w64-mingw32-pkg-config.exe IF EXIST %pkgconfloc%\libwinpthread-1.dll SET PKG_CONFIG_PATH=%pkgconfloc%
@IF EXIST %pkgconfloc%\pkg-config.exe IF EXIST %pkgconfloc%\i686-w64-mingw32-pkg-config.exe IF EXIST %pkgconfloc%\libwinpthread-1.dll SET PKG_CONFIG_PATH=%pkgconfloc%
@IF EXIST "%PKG_CONFIG_PATH%" GOTO doneenvcheck

@set pkgconfloc=%mesa%\pkg-config
@IF EXIST %pkgconfloc%\pkg-config.exe IF NOT EXIST %pkgconfloc%\x86_64-w64-mingw32-pkg-config.exe IF NOT EXIST %pkgconfloc%\i686-w64-mingw32-pkg-config.exe SET PKG_CONFIG_PATH=%pkgconfloc%
@IF EXIST %pkgconfloc%\pkg-config.exe IF EXIST %pkgconfloc%\x86_64-w64-mingw32-pkg-config.exe IF EXIST %pkgconfloc%\libwinpthread-1.dll SET PKG_CONFIG_PATH=%pkgconfloc%
@IF EXIST %pkgconfloc%\pkg-config.exe IF EXIST %pkgconfloc%\i686-w64-mingw32-pkg-config.exe IF EXIST %pkgconfloc%\libwinpthread-1.dll SET PKG_CONFIG_PATH=%pkgconfloc%
@IF EXIST "%PKG_CONFIG_PATH%" GOTO doneenvcheck

@set pkgconfloc=%mesa%\pkgconfiglite
@IF EXIST %pkgconfloc%\pkg-config.exe IF NOT EXIST %pkgconfloc%\x86_64-w64-mingw32-pkg-config.exe IF NOT EXIST %pkgconfloc%\i686-w64-mingw32-pkg-config.exe SET PKG_CONFIG_PATH=%pkgconfloc%
@IF EXIST %pkgconfloc%\pkg-config.exe IF EXIST %pkgconfloc%\x86_64-w64-mingw32-pkg-config.exe IF EXIST %pkgconfloc%\libwinpthread-1.dll SET PKG_CONFIG_PATH=%pkgconfloc%
@IF EXIST %pkgconfloc%\pkg-config.exe IF EXIST %pkgconfloc%\i686-w64-mingw32-pkg-config.exe IF EXIST %pkgconfloc%\libwinpthread-1.dll SET PKG_CONFIG_PATH=%pkgconfloc%
@IF EXIST "%PKG_CONFIG_PATH%" GOTO doneenvcheck

@set pkgconfloc=%mesa%\pkg-config-lite
@IF EXIST %pkgconfloc%\pkg-config.exe IF NOT EXIST %pkgconfloc%\x86_64-w64-mingw32-pkg-config.exe IF NOT EXIST %pkgconfloc%\i686-w64-mingw32-pkg-config.exe SET PKG_CONFIG_PATH=%pkgconfloc%
@IF EXIST %pkgconfloc%\pkg-config.exe IF EXIST %pkgconfloc%\x86_64-w64-mingw32-pkg-config.exe IF EXIST %pkgconfloc%\libwinpthread-1.dll SET PKG_CONFIG_PATH=%pkgconfloc%
@IF EXIST %pkgconfloc%\pkg-config.exe IF EXIST %pkgconfloc%\i686-w64-mingw32-pkg-config.exe IF EXIST %pkgconfloc%\libwinpthread-1.dll SET PKG_CONFIG_PATH=%pkgconfloc%
@IF EXIST "%PKG_CONFIG_PATH%" GOTO doneenvcheck

@set pkgconfigstate=0

:doneenvcheck

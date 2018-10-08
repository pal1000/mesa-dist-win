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

@rem pkg-config. can be present in PATH (2), present as local dependency (1), missing or broken (0). Only required with Meson build.
@set pkgconfigstate=2

@rem Look in PATH for pkg-config
@SET ERRORLEVEL=0
@where /q pkg-config.exe
@IF ERRORLEVEL 1 GOTO nopathpkgconfig
@set mingwpkgconfig=110
@SET ERRORLEVEL=0
@where /q x86_64-w64-mingw32-pkg-config.exe
@IF ERRORLEVEL 1 set mingwpkgconfig=%mingwpkgconfig:~1%
@SET ERRORLEVEL=0
@where /q i686-w64-mingw32-pkg-config.exe
@IF ERRORLEVEL 1 set mingwpkgconfig=%mingwpkgconfig:~1%
@IF %mingwpkgconfig%==0 GOTO doneenvcheck
@SET ERRORLEVEL=0
@where /q libwinpthread-1.dll
@IF ERRORLEVEL 1 GOTO nopathpkgconfig
@GOTO doneenvcheck

:nopathpkgconfig
@set pkgconfigstate=1

@rem Look for mingw versions of pkg-config.
@set pkgconfloc=%mesa%\msys64\mingw64\bin
@IF EXIST %pkgconfloc%\pkg-config.exe SET PKG_CONFIG_PATH=%pkgconfloc%\pkg-config.exe
@IF EXIST "%PKG_CONFIG_PATH%" GOTO doneenvcheck

@set pkgconfloc=%mesa%\msys32\mingw64\bin
@IF EXIST %pkgconfloc%\pkg-config.exe SET PKG_CONFIG_PATH=%pkgconfloc%\pkg-config.exe
@IF EXIST "%PKG_CONFIG_PATH%" GOTO doneenvcheck

@set pkgconfloc=%mesa%\msys64\mingw32\bin
@IF EXIST %pkgconfloc%\pkg-config.exe SET PKG_CONFIG_PATH=%pkgconfloc%\pkg-config.exe
@IF EXIST "%PKG_CONFIG_PATH%" GOTO doneenvcheck

@set pkgconfloc=%mesa%\msys32\mingw32\bin
@IF EXIST %pkgconfloc%\pkg-config.exe SET PKG_CONFIG_PATH=%pkgconfloc%\pkg-config.exe
@IF EXIST "%PKG_CONFIG_PATH%" GOTO doneenvcheck

@rem Look for pkg-config-lite and standalone pkg-config
@set pkgconfloc=%mesa%\pkgconfig
@IF EXIST %pkgconfloc%\pkg-config.exe IF NOT EXIST %pkgconfloc%\x86_64-w64-mingw32-pkg-config.exe IF NOT EXIST %pkgconfloc%\i686-w64-mingw32-pkg-config.exe SET PKG_CONFIG_PATH=%pkgconfloc%\pkg-config.exe
@IF EXIST %pkgconfloc%\pkg-config.exe IF EXIST %pkgconfloc%\x86_64-w64-mingw32-pkg-config.exe IF EXIST %pkgconfloc%\libwinpthread-1.dll SET PKG_CONFIG_PATH=%pkgconfloc%\pkg-config.exe
@IF EXIST %pkgconfloc%\pkg-config.exe IF EXIST %pkgconfloc%\i686-w64-mingw32-pkg-config.exe IF EXIST %pkgconfloc%\libwinpthread-1.dll SET PKG_CONFIG_PATH=%pkgconfloc%\pkg-config.exe
@IF EXIST "%PKG_CONFIG_PATH%" GOTO doneenvcheck

@set pkgconfloc=%mesa%\pkg-config
@IF EXIST %pkgconfloc%\pkg-config.exe IF NOT EXIST %pkgconfloc%\x86_64-w64-mingw32-pkg-config.exe IF NOT EXIST %pkgconfloc%\i686-w64-mingw32-pkg-config.exe SET PKG_CONFIG_PATH=%pkgconfloc%\pkg-config.exe
@IF EXIST %pkgconfloc%\pkg-config.exe IF EXIST %pkgconfloc%\x86_64-w64-mingw32-pkg-config.exe IF EXIST %pkgconfloc%\libwinpthread-1.dll SET PKG_CONFIG_PATH=%pkgconfloc%\pkg-config.exe
@IF EXIST %pkgconfloc%\pkg-config.exe IF EXIST %pkgconfloc%\i686-w64-mingw32-pkg-config.exe IF EXIST %pkgconfloc%\libwinpthread-1.dll SET PKG_CONFIG_PATH=%pkgconfloc%\pkg-config.exe
@IF EXIST "%PKG_CONFIG_PATH%" GOTO doneenvcheck

@set pkgconfloc=%mesa%\pkgconfiglite
@IF EXIST %pkgconfloc%\pkg-config.exe IF NOT EXIST %pkgconfloc%\x86_64-w64-mingw32-pkg-config.exe IF NOT EXIST %pkgconfloc%\i686-w64-mingw32-pkg-config.exe SET PKG_CONFIG_PATH=%pkgconfloc%\pkg-config.exe
@IF EXIST %pkgconfloc%\pkg-config.exe IF EXIST %pkgconfloc%\x86_64-w64-mingw32-pkg-config.exe IF EXIST %pkgconfloc%\libwinpthread-1.dll SET PKG_CONFIG_PATH=%pkgconfloc%\pkg-config.exe
@IF EXIST %pkgconfloc%\pkg-config.exe IF EXIST %pkgconfloc%\i686-w64-mingw32-pkg-config.exe IF EXIST %pkgconfloc%\libwinpthread-1.dll SET PKG_CONFIG_PATH=%pkgconfloc%\pkg-config.exe
@IF EXIST "%PKG_CONFIG_PATH%" GOTO doneenvcheck

@set pkgconfloc=%mesa%\pkg-config-lite
@IF EXIST %pkgconfloc%\pkg-config.exe IF NOT EXIST %pkgconfloc%\x86_64-w64-mingw32-pkg-config.exe IF NOT EXIST %pkgconfloc%\i686-w64-mingw32-pkg-config.exe SET PKG_CONFIG_PATH=%pkgconfloc%\pkg-config.exe
@IF EXIST %pkgconfloc%\pkg-config.exe IF EXIST %pkgconfloc%\x86_64-w64-mingw32-pkg-config.exe IF EXIST %pkgconfloc%\libwinpthread-1.dll SET PKG_CONFIG_PATH=%pkgconfloc%\pkg-config.exe
@IF EXIST %pkgconfloc%\pkg-config.exe IF EXIST %pkgconfloc%\i686-w64-mingw32-pkg-config.exe IF EXIST %pkgconfloc%\libwinpthread-1.dll SET PKG_CONFIG_PATH=%pkgconfloc%\pkg-config.exe
@IF EXIST "%PKG_CONFIG_PATH%" GOTO doneenvcheck

@set pkgconfigstate=0

:doneenvcheck
@rem Done checking environment. Backup PATH to easily keep environment clean
@set oldpath=%PATH%
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

@rem pkg-config. Can have all states. Only required with Meson build.
@SET ERRORLEVEL=0
@SET pkgconfigloc=pkg-config.exe
@set pkgconfigstate=2
@where /q pkg-config.exe
@IF ERRORLEVEL 1 set pkgconfigloc=%mesa%\pkgconfig\pkg-config.exe
@IF %pkgconfigloc%==%mesa%\pkgconfig\pkg-config.exe set pkgconfigstate=1
@IF %pkgconfigstate%==1 IF NOT EXIST %pkgconfigloc% set pkgconfigstate=0
@IF %pkgconfigstate%==0 GOTO doneenvcheck
@IF %pkgconfigstate%==1 IF NOT EXIST %mesa%\pkgconfig\x86_64-w64-mingw32-pkg-config.exe IF NOT EXIST %mesa%\pkgconfig\i686-w64-mingw32-pkg-config.exe GOTO doneenvcheck
@IF %pkgconfigstate%==1 GOTO libpthreads
@set mingwpkgconfig=110
@SET ERRORLEVEL=0
@where /q x86_64-w64-mingw32-pkg-config.exe
@IF ERRORLEVEL 1 set mingwpkgconfig=%mingwpkgconfig:~1%
@SET ERRORLEVEL=0
@where /q i686-w64-mingw32-pkg-config.exe
@IF ERRORLEVEL 1 set mingwpkgconfig=%mingwpkgconfig:~1%
@IF %mingwpkgconfig%==0 GOTO doneenvcheck

:libpthreads
@rem libpthreads. Needed with mingw version of pkg-config
@SET ERRORLEVEL=0
@SET libpthreadsloc=libwinpthread-1.dll
@set libpthreadsstate=2
@where /q libwinpthread-1.dll
@IF ERRORLEVEL 1 set libpthreadsloc=%mesa%\pkgconfig\libwinpthread-1.dll
@IF %libpthreadsloc%==%mesa%\pkgconfig\libwinpthread-1.dll set libpthreadsstate=1
@IF %libpthreadsstate%==1 IF NOT EXIST %libpthreadsloc% set libpthreadsstate=0
@IF %libpthreadsstate%==0 set pkgconfigstate=0

:doneenvcheck
@rem Done checking environment. Backup PATH to easily keep environment clean
@set oldpath=%PATH%
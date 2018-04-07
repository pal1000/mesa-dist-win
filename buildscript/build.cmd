@TITLE Building Mesa3D

@rem Determine Mesa3D build environment root folder and convert the path to it into DOS 8.3 format to avoid quotes mess.
@cd "%~dp0"
@cd ..\..\
@for %%I in ("%cd%") do @set mesa=%%~sI

@rem Analyze environment. Get each dependency status: 0=missing, 1=standby/load manually in PATH, 2=cannot be unloaded.
@rem Not all dependencies can have all these states.

@rem Search for Visual Studio environment. Hard fail if missing.
@call %mesa%\mesa-dist-win\buildscript\modules\visualstudio.cmd

@rem Python. State tracking is pointless as it is loaded once and we are done.
@call %mesa%\mesa-dist-win\buildscript\modules\discoverpython.cmd

:pyupdate
@rem Look for python modules
@rem Mako. State is irrelevant as it can easily be added via Pypi and Pypi only if missing.
@set makoloc=%pythonloc:python.exe=%Lib\site-packages\mako

@rem Meson. Can only be always present (2) or missing (0). We need to keep it state for later.
@SET mesonloc=meson.exe
@set mesonstate=2
@SET ERRORLEVEL=0
@where /q meson.exe
@IF ERRORLEVEL 1 set mesonloc=%pythonloc:python.exe=%Scripts\meson.py
@IF %mesonloc%==%pythonloc:python.exe=%Scripts\meson.py IF NOT EXIST %mesonloc% set mesonstate=0

@rem Scons - Can be auto-acquired if missing, no state tracking needed.
@set sconsloc=%pythonloc:python.exe=%Scripts\scons.py

@rem Check for python updates
@set pyupd=n
@if %pythonver% GEQ 3 echo WARNING: Python 3.x support is experimental.
@if %pythonver% GEQ 3 echo.
@if %pythonver%==2 if NOT EXIST %makoloc% (
@%pythonloc% -m pip install -U setuptools
@%pythonloc% -m pip install -U pip
@%pythonloc% -m pip install -U scons
@%pythonloc% -m pip install -U MarkupSafe
@%pythonloc% -m pip install -U mako
@set pyupd=y
@echo.
)
@if %pythonver%==2 if NOT EXIST %pythonloc:python.exe=%Lib\site-packages\win32 (
@%pythonloc% -m pip install pywin32
@echo WARNIMG: Pywin32 is not installed in system-wide mode. COM and services support is not available.
)
@if %pythonver% GEQ 3 IF %mesonstate%==0 (
@%pythonloc% -m pip install -U setuptools
@%pythonloc% -m pip install -U pip
@%pythonloc% -m pip install -U meson
@set pyupd=y
@echo.
)
@if /I NOT "%pyupd%"=="y" set /p pyupd=Install/update python modules (y/n):
@if /I "%pyupd%"=="y" (
@for /F "delims= " %%i in ('%pythonloc% -m pip list -o --format=legacy') do @if NOT "%%i"=="pywin32" %pythonloc% -m pip install -U "%%i"
@echo.
)

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
@SET gitloc=git.exe
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

@rem Done checking environment. Backup PATH to easily keep environment clean
@set oldpath=%PATH%

:build_llvm
@rem Look for build generators.
@IF %cmakestate%==0 IF %mesonstate%==0 (
@echo There is no build system generator suitable for LLVM build.
@GOTO prep_mesa
)

@rem LLVM build getting started.
@if EXIST %mesa%\llvm set /p buildllvm=Begin LLVM build. Only needs to run once for each ABI and version. Proceed (y/n):
@if /I NOT "%buildllvm%"=="y" GOTO prep_mesa
@if EXIST %mesa%\llvm echo.
@cd %mesa%\llvm
@if EXIST %abi% RD /S /Q %abi%
@if EXIST buildsys-%abi% RD /S /Q buildsys-%abi%
@md buildsys-%abi%
@cd buildsys-%abi%
@set ninja=n
@set meson=n
@if NOT %mesonstate%==0 if %cmakestate%==0 set meson=y

@rem Ask for Ninja use if exists. Load it if opted for it.
@if NOT %ninjastate%==0 set /p ninja=Use Ninja build system instead of MsBuild (y/n); less storage device strain and maybe faster build:
@if NOT %ninjastate%==0 echo.
@if /I "%ninja%"=="y" if %ninjastate%==1 set PATH=%mesa%\ninja\;%PATH%

@rem Ask for Meson use if both CMake and Meson are present (commented out since Meson support is just stubbed for now).
@rem Load cmake into build environment if used.
@rem if NOT %mesonstate%==0 if NOT %cmakestate%==0 set /p meson=Use Meson build generator instead of CMake (y/n):
@rem if NOT %mesonstate%==0 if NOT %cmakestate%==0 echo.
@if /I NOT "%meson%"=="y" if %cmakestate%==1 set PATH=%mesa%\cmake\bin\;%PATH%

@rem Construct build configuration command based on choices made above.
@set buildconf=cmake -G
@if /I NOT "%meson%"=="y" if /I NOT "%ninja%"=="y" set buildconf=%buildconf% "Visual Studio %toolset%
@if /I NOT "%meson%"=="y" if NOT %abi%==x64 if /I NOT "%ninja%"=="y" set buildconf=%buildconf%"
@if /I NOT "%meson%"=="y" if %abi%==x64 if /I NOT "%ninja%"=="y" set buildconf=%buildconf% Win64"
@if /I NOT "%meson%"=="y" if /I NOT "%ninja%"=="y" IF /I %PROCESSOR_ARCHITECTURE%==AMD64 set buildconf=%buildconf% -Thost=x64
@if /I NOT "%meson%"=="y" if /I "%ninja%"=="y" set buildconf=%buildconf% "Ninja"
@if /I NOT "%meson%"=="y" set buildconf=%buildconf% -DLLVM_TARGETS_TO_BUILD=X86 -DCMAKE_BUILD_TYPE=Release -DLLVM_USE_CRT_RELEASE=MT -DLLVM_ENABLE_RTTI=1 -DLLVM_ENABLE_TERMINFO=OFF -DCMAKE_INSTALL_PREFIX=../%abi% ..
@if /I "%meson%"=="y" set buildconf=echo LLVM Build aborted. Unimplemented build configuration.

@rem Load Visual Studio environment. Only cmake can load it in the background and only when using MsBuild.
@if /I NOT "%meson%"=="y" if /I "%ninja%"=="y" call %vsenv%
@rem if /I "%meson%"=="y" call %vsenv%
@if /I "%ninja%"=="y" cd %mesa%\llvm\buildsys-%abi%
@if /I "%meson%"=="y" cd %mesa%\llvm\buildsys-%abi%

@rem Configure and execute the build with the configuration made above.
@echo.
@%buildconf%
@echo.
@pause
@echo.
@if /I NOT "%meson%"=="y" if /I NOT "%ninja%"=="y" cmake --build . --config Release --target install
@if /I NOT "%meson%"=="y" if /I "%ninja%"=="y" ninja install
@rem if /I "%meson%"=="y" nothing
@echo.

:prep_mesa
@set PATH=%oldpath%
@IF %flexstate%==0 (
@echo winflexbison is required to build Mesa3D.
GOTO distcreate
)
@if NOT EXIST mesa if %gitstate%==0 (
@echo Fatal: Both Mesa code and Git are missing. At least one is required. Execution halted.
@GOTO distcreate
)
@cd %mesa%
@set mesapatched=0
@set haltmesabuild=n
@if %gitstate%==0 echo Error: Git not found. Auto-patching disabled.
@if NOT EXIST mesa echo Warning: Mesa3D source code not found.
@if NOT EXIST mesa set /p haltmesabuild=Press Y to abort execution. Press any other key to download Mesa via Git:
@if /I "%haltmesabuild%"=="y" GOTO distcreate
@if NOT EXIST mesa set branch=master
@if NOT EXIST mesa set /p branch=Enter Mesa source code branch name - defaults to master:
@if NOT EXIST mesa echo.
@if NOT EXIST mesa git clone --recurse-submodules --depth=1 --branch=%branch% git://anongit.freedesktop.org/mesa/mesa mesa
@cd mesa
@set LLVM=%mesa%\llvm\%abi%
@set /p mesaver=<VERSION
@if "%mesaver:~-7%"=="0-devel" set /a intmesaver=%mesaver:~0,2%%mesaver:~3,1%00
@if "%mesaver:~5,4%"=="0-rc" set /a intmesaver=%mesaver:~0,2%%mesaver:~3,1%00+%mesaver:~9%
@rem if NOT "%mesaver:~5,2%"=="0-" set /a intmesaver=%mesaver:~0,2%%mesaver:~3,1%50+%mesaver:~5%
@if EXIST mesapatched.ini GOTO build_mesa
@if %gitstate%==0 GOTO build_mesa
@git apply -v ..\mesa-dist-win\patches\s3tc.patch
@set mesapatched=1
@echo %mesapatched% > mesapatched.ini
@echo.

:build_mesa
@set /p buildmesa=Begin mesa build. Proceed (y/n):
@if /i NOT "%buildmesa%"=="y" GOTO distcreate
@echo.
@cd %mesa%\mesa
@set sconscmd=%pythonloc% %sconsloc% build=release platform=windows machine=%longabi% libgl-gdi
@set llvmless=n
@if EXIST %LLVM% set /p llvmless=Build Mesa without LLVM (y/n). Only softpipe and osmesa will be available:
@if EXIST %LLVM% echo.
@if NOT EXIST %LLVM% set /p llvmless=Build Mesa without LLVM (y=yes/n=quit). Only softpipe and osmesa will be available:
@if NOT EXIST %LLVM% echo.
@if /I "%llvmless%"=="y" set sconscmd=%sconscmd% llvm=no
@if /I "%llvmless%"=="y" GOTO osmesa
@if /I NOT "%llvmless%"=="y" if NOT EXIST %LLVM% GOTO distcreate
@set swrdrv=n
@if %abi%==x64 set /p swrdrv=Do you want to build swr drivers? (y=yes):
@if %abi%==x64 echo.
@if /I "%swrdrv%"=="y" set sconscmd=%sconscmd% swr=1
@set /p graw=Do you want to build graw library (y/n):
@echo.
@if /I "%graw%"=="y" set sconscmd=%sconscmd% graw-gdi

:osmesa
@set /p osmesa=Do you want to build off-screen rendering drivers (y/n):
@echo.
@if /I "%osmesa%"=="y" set sconscmd=%sconscmd% osmesa

:build_mesa_exec
@IF %flexstate%==1 set PATH=%mesa%\flexbison\;%PATH%
@cd %mesa%\mesa
@set cleanbuild=n
@if EXIST build\windows-%longabi% set /p cleanbuild=Do you want to clean build (y/n):
@if EXIST build\windows-%longabi% echo.
@if /I "%cleanbuild%"=="y" RD /S /Q build\windows-%longabi%
@if NOT EXIST build md build
@if NOT EXIST build\windows-%longabi% md build\windows-%longabi%
@if NOT EXIST build\windows-%longabi%\git_sha1.h echo 0 > build\windows-%longabi%\git_sha1.h
@echo.
@%sconscmd%
@echo.

:distcreate
@if NOT EXIST %mesa%\mesa\build\windows-%longabi% GOTO exit
@set /p dist=Create or update Mesa3D distribution package (y/n):
@echo.
@if /I NOT "%dist%"=="y" GOTO exit
@cd %mesa%
@if NOT EXIST mesa-dist-win MD mesa-dist-win
@cd mesa-dist-win
@if NOT EXIST bin MD bin
@cd bin
@if EXIST %abi% RD /S /Q %abi%
@MD %abi%
@cd %abi%
@MD osmesa-gallium
@MD osmesa-swrast
@copy %mesa%\mesa\build\windows-%longabi%\gallium\targets\libgl-gdi\opengl32.dll opengl32.dll
@if %abi%==x64 copy %mesa%\mesa\build\windows-%longabi%\gallium\drivers\swr\swrAVX.dll swrAVX.dll
@if %abi%==x64 copy %mesa%\mesa\build\windows-%longabi%\gallium\drivers\swr\swrAVX2.dll swrAVX2.dll
@copy %mesa%\mesa\build\windows-%longabi%\mesa\drivers\osmesa\osmesa.dll osmesa-swrast\osmesa.dll
@copy %mesa%\mesa\build\windows-%longabi%\gallium\targets\osmesa\osmesa.dll osmesa-gallium\osmesa.dll
@copy %mesa%\mesa\build\windows-%longabi%\gallium\targets\graw-gdi\graw.dll graw.dll
@echo.

:exit
@pause
@exit
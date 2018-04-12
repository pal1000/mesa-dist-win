@TITLE Building Mesa3D

@rem Determine Mesa3D build environment root folder and convert the path to it into DOS 8.3 format to avoid quotes mess.
@cd "%~dp0"
@cd ..\..\
@for %%I in ("%cd%") do @set mesa=%%~sI

@rem Analyze environment. Get each dependency status: 0=missing, 1=standby/load manually in PATH, 2=cannot be unloaded.
@rem Not all dependencies can have all these states.

@rem Search for Visual Studio environment. Hard fail if missing.
@call %mesa%\mesa-dist-win\buildscript\modules\visualstudio.cmd

@rem Search for Python. State tracking is pointless as it is loaded once and we are done. Hard fail if missing.
@call %mesa%\mesa-dist-win\buildscript\modules\discoverpython.cmd

@rem Search for Python packages. Install missing packages automatically. Ask to do an update to all packages except pywin32
@rem which doesn't support pypi updates cleanly.
@call %mesa%\mesa-dist-win\buildscript\modules\pythonpackages.cmd

@rem Check for remaining dependencies: cmake, ninja, winflexbison and git.
@call %mesa%\mesa-dist-win\buildscript\modules\otherdependencies.cmd

@rem LLVM build.
@call %mesa%\mesa-dist-win\buildscript\modules\llvm.cmd

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
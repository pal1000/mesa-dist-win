@rem Reset PATH and current folder after LLVM build.
@set PATH=%oldpath%
@cd %mesa%

@rem Check environment
@if %pythonver%==2 IF %flexstate%==0 (
@echo winflexbison is required to build Mesa3D.
GOTO skipmesa
)
@if NOT EXIST mesa if %gitstate%==0 (
@echo Fatal: Both Mesa3D code and Git are missing. At least one is required. Execution halted.
@GOTO skipmesa
)

@rem Hide Meson support behind a parametter as it doesn't work yet.
@IF %enablemeson%==0 if %pythonver% GEQ 3 echo Mesa3D build: Unimplemented code path.
@IF %enablemeson%==0 if %pythonver% GEQ 3 GOTO skipmesa

@REM Aquire Mesa3D source code if missing and enable S3TC texture cache automatically if possible.
@set buildmesa=n
@if %gitstate%==0 echo Error: Git not found. Auto-patching disabled. If you try to build with GLES support and use quick configuration or try to build osmesa expect a build failure per https://bugs.freedesktop.org/show_bug.cgi?id=106843
@if %gitstate%==0 echo.
@if NOT EXIST mesa echo Warning: Mesa3D source code not found.
@if NOT EXIST mesa echo.
@if NOT EXIST mesa set /p buildmesa=Download mesa code and build (y/n):
@if NOT EXIST mesa if /i "%buildmesa%"=="y" echo.
@if NOT EXIST mesa if /i NOT "%buildmesa%"=="y" GOTO skipmesa
@if NOT EXIST mesa set branch=master
@if NOT EXIST mesa set /p branch=Enter Mesa source code branch name - defaults to master:
@if NOT EXIST mesa echo.
@if NOT EXIST mesa (
@git clone --recurse-submodules --depth=1 --branch=%branch% git://anongit.freedesktop.org/mesa/mesa mesa
@echo.
)
@if EXIST mesa if /i NOT "%buildmesa%"=="y" set /p buildmesa=Begin mesa build. Proceed (y/n):
@if EXIST mesa if /i "%buildmesa%"=="y" echo.
@if /i NOT "%buildmesa%"=="y" GOTO skipmesa
@cd mesa
@set LLVM=%mesa%\llvm\%abi%
@set /p mesaver=<VERSION
@if "%mesaver:~-7%"=="0-devel" set /a intmesaver=%mesaver:~0,2%%mesaver:~3,1%00
@if "%mesaver:~5,4%"=="0-rc" set /a intmesaver=%mesaver:~0,2%%mesaver:~3,1%00+%mesaver:~9%
@if NOT "%mesaver:~5,2%"=="0-" set /a intmesaver=%mesaver:~0,2%%mesaver:~3,1%50+%mesaver:~5%
@if EXIST mesapatched.ini GOTO configmesabuild
@if %gitstate%==0 GOTO configmesabuild
@git apply -v ..\mesa-dist-win\patches\s3tc.patch
@echo 1 > mesapatched.ini
@echo.

@rem Initially disable osmesa when building with GLES due to build failure
@rem https://bugs.freedesktop.org/show_bug.cgi?id=106843
@rem We'll do a 2-pass build in this case. Build everything requested except osmesa with GLES, backup libgl-gdi and
@rem finally build again libgl-gdi and osmesa without GLES. Caveat: osmesa will not have GLES support and it may no longer
@rem work with swr. In the end restore the original libgl-gdi with GLES support.
@git apply -v ..\mesa-dist-win\patches\osmesa.patch

:configmesabuild
@rem Configure Mesa build.

@if %pythonver%==2 set buildcmd=%pythonloc% %pythonloc:~0,-10%Scripts\scons.py build=release platform=windows machine=%longabi%
@if %pythonver%==2 set sconscmd=%buildcmd%
@if %pythonver% GEQ 3 set buildcmd=%mesonloc% . .\build\windows-%longabi% --backend=vs2017
@set /p expressmesabuild=Do you want to build Mesa with quick configuration - libgl-gdi, graw-gdi, graw-null, tests, osmesa and GLAPI and OpenGL ES if GLES enabled:
@echo.
@if %pythonver%==2 IF /I NOT "%expressmesabuild%"=="y" set buildcmd=%buildcmd% libgl-gdi
@set /p gles=Do you want to build GLAPI and GLES support (y/n):
@echo.
@if %pythonver%==2 if /I "%gles%"=="y" set buildcmd=%buildcmd% gles=1
@set osmesa=n
@IF /I NOT "%expressmesabuild%"=="y" set /p osmesa=Do you want to build off-screen rendering drivers (y/n):
@IF /I NOT "%expressmesabuild%"=="y" echo.
@IF /I "%expressmesabuild%"=="y" set osmesa=y
@if %pythonver%==2 if /I "%osmesa%"=="y" IF /I NOT "%expressmesabuild%"=="y" set buildcmd=%buildcmd% osmesa
@set llvmless=n
@if EXIST %LLVM% set /p llvmless=Build Mesa without LLVM (y/n). Only softpipe and osmesa will be available:
@if EXIST %LLVM% echo.
@if NOT EXIST %LLVM% set /p llvmless=Build Mesa without LLVM (y=yes/q=quit). Only softpipe and osmesa will be available:
@if NOT EXIST %LLVM% echo.
@if %pythonver%==2 if /I "%llvmless%"=="y" set buildcmd=%buildcmd% llvm=no
@if /I "%llvmless%"=="y" GOTO build_mesa
@if /I NOT "%llvmless%"=="y" if NOT EXIST %LLVM% echo User refused to build Mesa without LLVM.
@if /I NOT "%llvmless%"=="y" if NOT EXIST %LLVM% GOTO skipmesa
@set swrdrv=n
@if %abi%==x64 set /p swrdrv=Do you want to build swr drivers? (y=yes):
@if %abi%==x64 echo.
@if %pythonver%==2 if /I "%swrdrv%"=="y" set buildcmd=%buildcmd% swr=1
@set graw=n
@IF /I NOT "%expressmesabuild%"=="y" set /p graw=Do you want to build graw library (y/n):
@IF /I NOT "%expressmesabuild%"=="y" echo.
@IF /I "%expressmesabuild%"=="y" set graw=y
@if %pythonver%==2 if /I "%graw%"=="y" IF /I NOT "%expressmesabuild%"=="y" set buildcmd=%buildcmd% graw-gdi

:build_mesa
@if %pythonver%==2 IF %flexstate%==1 set PATH=%mesa%\flexbison\;%PATH%
@set cleanbuild=n
@if EXIST build\windows-%longabi% set /p cleanbuild=Do you want to clean build (y/n):
@if EXIST build\windows-%longabi% echo.
@if /I "%cleanbuild%"=="y" RD /S /Q build\windows-%longabi%
@if NOT EXIST build md build
@if NOT EXIST build\windows-%longabi% md build\windows-%longabi%
@if NOT EXIST build\windows-%longabi%\git_sha1.h echo 0 > build\windows-%longabi%\git_sha1.h
@echo.
@if %pythonver% GEQ 3 call %vsenv%
@if %pythonver% GEQ 3 echo.
@echo Build command: %buildcmd%
@echo.
@%buildcmd%
@echo.

@if %pythonver%==2 IF /I NOT "%gles%"=="y" IF /I NOT "%osmesa%"=="y" GOTO skipmesa
@if %pythonver% GEQ 3 cmd

@pause
@echo Beginning 2nd build pass
@echo.
@echo Backing softpipe+llvmpipe drivers having GLES support
@IF EXIST %mesa%\build\windows-%longabi%\bin\opengl32.dll del %mesa%\build\windows-%longabi%\bin\opengl32.dll
@copy %mesa%\build\windows-%longabi%\gallium\targets\libgl-gdi\opengl32.dll %mesa%\build\windows-%longabi%\bin
@echo.
@echo Second stage build command: %sconscmd% libgl-gdi osmesa
@echo.
@%sconscmd% libgl-gdi osmesa
@echo.
@pause
@echo.
@echo Replace softpipe+llvpipe without GLES support from pass 2 with ones from pass 1
@echo.
@del %mesa%\build\windows-%longabi%\gallium\targets\libgl-gdi\opengl32.dll
@copy %mesa%\build\windows-%longabi%\bin\opengl32.dll %mesa%\build\windows-%longabi%\gallium\targets\libgl-gdi
@echo.

:skipmesa
@echo.
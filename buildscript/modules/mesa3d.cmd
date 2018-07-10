@rem Reset PATH and current folder after LLVM build.
@set PATH=%oldpath%
@cd %mesa%

@rem Check environment
@IF %flexstate%==0 (
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
@if NOT EXIST mesa IF %pythonver%==2 set /p branch=Enter Mesa source code branch name - defaults to master:
@if NOT EXIST mesa IF %pythonver%==2 echo.
@if NOT EXIST mesa IF %pythonver%==2 set mesarepo=https://gitlab.freedesktop.org/mesa/mesa.git
@if NOT EXIST mesa IF %pythonver% GEQ 3 set mesarepo=git://people.freedesktop.org/~dbaker/mesa
@if NOT EXIST mesa IF %pythonver% GEQ 3 set branch=meson-windows
@if NOT EXIST mesa git clone --recurse-submodules --depth=1 --branch=%branch% %mesarepo% mesa
@if NOT EXIST mesa echo.

@REM Collect information about Mesa3D code. Apply patches
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

@rem Apply a patch that disables osmesa gallium and cuts off GLES from osmesa classic when building with Scons
@rem when GLES is enabled due to build failure - https://bugs.freedesktop.org/show_bug.cgi?id=106843
@rem We'll do a 2-pass build in this case. Build everything requested without GLES, then build everything again with GLES
@rem having osmesa gallium disabled via patch.
@IF %pythonver%==2 git apply -v ..\mesa-dist-win\patches\osmesa.patch
@IF %pythonver%==2 echo.

:configmesabuild
@rem Configure Mesa build.

@if %pythonver%==2 set buildcmd=%pythonloc% %pythonloc:~0,-10%Scripts\scons.py build=release platform=windows machine=%longabi% texture_float=1
@if %pythonver% GEQ 3 set buildcmd=%mesonloc% . .\build\windows-%longabi% --backend=vs2017 --buildtype=release

@set ninja=n
@if %pythonver% GEQ 3 if NOT %ninjastate%==0 set /p ninja=Use Ninja build system instead of MsBuild (y/n); less storage device strain and maybe faster build:
@if %pythonver% GEQ 3 if NOT %ninjastate%==0 echo.
@if /I "%ninja%"=="y" if %ninjastate%==1 set PATH=%mesa%\ninja\;%PATH%
@if /I "%ninja%"=="y" set buildcmd=%buildcmd:vs2017=ninja%

@set llvmless=n
@if %pythonver%==2 if EXIST %LLVM% set /p llvmless=Build Mesa without LLVM (y/n). llvmpipe and swr drivers and high performance JIT won't be available for other drivers and libraries:
@if %pythonver%==2 if EXIST %LLVM% echo.
@if %pythonver%==2 if NOT EXIST %LLVM% set /p llvmless=Build Mesa without LLVM (y=yes/q=quit). llvmpipe and swr drivers and high performance JIT won't be available for other drivers and libraries:
@if %pythonver%==2 if NOT EXIST %LLVM% echo.
@if %pythonver%==2 if /I "%llvmless%"=="y" set buildcmd=%buildcmd% llvm=no
@if %pythonver%==2 if /I NOT "%llvmless%"=="y" if NOT EXIST %LLVM% echo User refused to build Mesa without LLVM.
@if %pythonver%==2 if /I NOT "%llvmless%"=="y" if NOT EXIST %LLVM% GOTO skipmesa

@if %pythonver%==2 set /p openmp=Build Mesa3D with OpenMP. Faster build and smaller binaries (y/n):
@if %pythonver%==2 echo.
@if %pythonver%==2 if /I "%openmp%"=="y" set buildcmd=%buildcmd% openmp=1

@set swrdrv=n
@if %pythonver%==2 if /I NOT "%llvmless%"=="y" if %abi%==x64 if EXIST %LLVM% set /p swrdrv=Do you want to build swr drivers? (y=yes):
@if %pythonver%==2 if /I NOT "%llvmless%"=="y" if %abi%==x64 if EXIST %LLVM% echo.
@if %pythonver%==2 if /I "%swrdrv%"=="y" set buildcmd=%buildcmd% swr=1

@if %pythonver%==2 set /p gles=Do you want to build GLAPI shared library and GLES support (y/n):
@if %pythonver%==2 echo.
@if %pythonver%==2 if /I "%gles%"=="y" set gles=y
@if %pythonver%==2 if /I NOT "%gles%"=="y" set gles=0

@if %pythonver%==2 set /p expressmesabuild=Do you want to build Mesa with quick configuration - includes libgl-gdi, graw-gdi, graw-null, tests, osmesa and GLAPI + OpenGL ES if GLES enabled:
@if %pythonver%==2 echo.
@if %pythonver%==2 IF /I "%expressmesabuild%"=="y" set mesatargets=.
@if %pythonver%==2 IF /I NOT "%expressmesabuild%"=="y" set mesatargets=libgl-gdi

@set osmesa=n
@if %pythonver%==2 IF /I NOT "%expressmesabuild%"=="y" set /p osmesa=Do you want to build off-screen rendering drivers (y/n):
@if %pythonver%==2 IF /I NOT "%expressmesabuild%"=="y" echo.
@if %pythonver%==2 IF /I NOT "%expressmesabuild%"=="y" IF /I "%osmesa%"=="y" set mesatargets=%mesatargets% osmesa
@IF /I "%expressmesabuild%"=="y" set osmesa=y

@set graw=n
@if %pythonver%==2 IF /I NOT "%expressmesabuild%"=="y" set /p graw=Do you want to build graw library (y/n):
@if %pythonver%==2 IF /I NOT "%expressmesabuild%"=="y" echo.
@if %pythonver%==2 if /I "%graw%"=="y" IF /I NOT "%expressmesabuild%"=="y" set mesatargets=%mesatargets% graw-gdi
@IF /I "%expressmesabuild%"=="y" set graw=y

:build_mesa
@IF %flexstate%==1 set PATH=%mesa%\flexbison\;%PATH%
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
@if %pythonver% GEQ 3 echo Build command stored in buildcmd variable.
@if %pythonver% GEQ 3 echo.
@if %pythonver% GEQ 3 cmd
@if %pythonver%==2 IF /I "%osmesa%"=="y" IF /I "%gles%"=="y" (
echo Build command: %buildcmd% gles=0 %mesatargets%
@echo.
@%buildcmd% gles=0 %mesatargets%
@echo.
@pause
@echo Beginning 2nd build pass
@echo.
)
@if %pythonver%==2 (
@echo Build command: %buildcmd% gles=%gles% %mesatargets%
@echo.
@%buildcmd% gles=%gles% %mesatargets%
@echo.
)

:skipmesa
@echo.
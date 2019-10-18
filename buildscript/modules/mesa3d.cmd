@setlocal
@rem Check environment
@IF %flexstate%==0 echo Flex and bison are required to build Mesa3D.
@IF %flexstate%==0 GOTO skipmesa
@if NOT EXIST mesa if %gitstate%==0 echo Fatal: Both Mesa3D code and Git are missing. At least one is required. Execution halted.
@if NOT EXIST mesa if %gitstate%==0 echo.
@if NOT EXIST mesa if %gitstate%==0 GOTO skipmesa
@IF %mesabldsys%==meson IF %pkgconfigstate%==0 echo No suitable pkg-config implementtion found. pkgconf or pkg-config-lite is required to build Mesa3D with Meson and MSVC.
@IF %mesabldsys%==meson IF %pkgconfigstate%==0 echo.
@IF %mesabldsys%==meson IF %pkgconfigstate%==0 GOTO skipmesa

@REM Aquire Mesa3D source code if missing.
@set buildmesa=n
@cd %mesa%
@if %gitstate%==0 IF %toolchain%==msvc echo Error: Git not found. Auto-patching disabled. This could have many consequences going all the way up to build failure.
@if %gitstate%==0 IF %toolchain%==msvc echo.
@if NOT EXIST mesa echo Warning: Mesa3D source code not found.
@if NOT EXIST mesa echo.
@if NOT EXIST mesa set /p buildmesa=Download mesa code and build (y/n):
@if NOT EXIST mesa if /i "%buildmesa%"=="y" echo.
@if NOT EXIST mesa if /i NOT "%buildmesa%"=="y" GOTO skipmesa
@if NOT EXIST mesa set branch=master
@if NOT EXIST mesa set /p branch=Enter Mesa source code branch name - defaults to master:
@if NOT EXIST mesa echo.
@if NOT EXIST mesa git clone --recurse-submodules --depth=1 --branch=%branch% https://gitlab.freedesktop.org/mesa/mesa.git mesa
@if NOT EXIST mesa echo.

@if EXIST mesa if /i NOT "%buildmesa%"=="y" set /p buildmesa=Begin mesa build. Proceed (y/n):
@if EXIST mesa if /i "%buildmesa%"=="y" echo.
@if /i NOT "%buildmesa%"=="y" GOTO skipmesa
@cd mesa

@rem Locate LLVM
@IF %toolchain%==msvc set LLVM=%mesa%\llvm\%abi%-%llvmlink%
@IF %toolchain%==gcc set LLVM=/mingw%minabi%
@set havellvm=0
@IF EXIST %LLVM% set havellvm=1
@IF %toolchain%==gcc set havellvm=1

@rem Get Mesa3D version as an integer
@set /p mesaver=<VERSION
@if "%mesaver:~-7%"=="0-devel" set /a intmesaver=%mesaver:~0,2%%mesaver:~3,1%00
@if "%mesaver:~5,4%"=="0-rc" set /a intmesaver=%mesaver:~0,2%%mesaver:~3,1%00+%mesaver:~9%
@if NOT "%mesaver:~5,2%"=="0-" set /a intmesaver=%mesaver:~0,2%%mesaver:~3,1%50+%mesaver:~5%

@REM Collect information about Mesa3D code. Apply patches
@if %gitstate%==0 IF %toolchain%==msvc GOTO configmesabuild
@rem Enable S3TC texture cache
@call %mesa%\mesa-dist-win\buildscript\modules\applypatch.cmd s3tc
@rem Update Meson subprojects
@IF EXIST %mesa%\mesa\subprojects call %mesa%\mesa-dist-win\buildscript\modules\applypatch.cmd subprojects-update
@rem Fix MSYS2 Mingw-w64 GCC build
@IF %intmesaver% LEQ 19157 IF %toolchain%==gcc call %mesa%\mesa-dist-win\buildscript\modules\applypatch.cmd msys2-mingw_w64-fixes
@IF %intmesaver% GEQ 19200 IF %intmesaver% LSS 19251 IF %toolchain%==gcc call %mesa%\mesa-dist-win\buildscript\modules\applypatch.cmd msys2-mingw_w64-fixes
@rem Fix build with LLVM 9
@IF %intmesaver% LEQ 19157 call %mesa%\mesa-dist-win\buildscript\modules\applypatch.cmd mingw-posix-flag-fix
@IF %intmesaver% GEQ 19200 IF %intmesaver% LSS 19251 call %mesa%\mesa-dist-win\buildscript\modules\applypatch.cmd mingw-posix-flag-fix
@IF %intmesaver% LEQ 19157 call %mesa%\mesa-dist-win\buildscript\modules\applypatch.cmd llvm9
@IF %intmesaver% GEQ 19200 IF %intmesaver% LSS 19251 call %mesa%\mesa-dist-win\buildscript\modules\applypatch.cmd llvm9
@rem Scons Python 3 initial
@IF %intmesaver% LEQ 19157 call %mesa%\mesa-dist-win\buildscript\modules\applypatch.cmd mesapy3
@IF %intmesaver% GEQ 19200 IF %intmesaver% LSS 19251 call %mesa%\mesa-dist-win\buildscript\modules\applypatch.cmd mesapy3

:configmesabuild
@rem Configure Mesa build.

@if %mesabldsys%==scons if %toolchain%==msvc IF NOT "%sconspypi%"=="1" set sconsloc=%mesa%\scons\src\script\scons.py
@if %mesabldsys%==scons if %toolchain%==msvc IF "%sconspypi%"=="1" set sconsloc=%pythonloc:~0,-10%Scripts\scons.py
@if %mesabldsys%==scons if %toolchain%==msvc IF "%sconspypi%"=="1" IF NOT EXIST "%sconsloc%" set sconsloc=%pythonloc:~0,-10%Scripts\scons
@if %mesabldsys%==scons if %toolchain%==msvc set buildcmd=%pythonloc% %sconsloc%
@if %mesabldsys%==scons if %toolchain%==gcc set buildcmd=%msysloc%\usr\bin\bash --login -c "cd $mesa/mesa;scons
@if %mesabldsys%==scons set buildcmd=%buildcmd% -j%throttle% build=release platform=windows machine=%longabi%
@if %mesabldsys%==scons if %toolchain%==gcc set buildcmd=%buildcmd% toolchain=mingw
@if %mesabldsys%==scons if %toolchain%==msvc set buildcmd=%buildcmd% MSVC_USE_SCRIPT=%vsenv%

@if %mesabldsys%==meson set buildconf=%mesonloc% build/%abi% --backend=
@IF %mesabldsys%==meson set platformabi=Win32
@IF %mesabldsys%==meson IF %abi%==x64 set platformabi=%abi%
@if %mesabldsys%==meson set buildcmd=msbuild /p^:Configuration=release,Platform=%platformabi% mesa.sln /m^:%throttle%

@set ninja=n
@rem if %mesabldsys%==meson if NOT %ninjastate%==0 set /p ninja=Use Ninja build system instead of MsBuild (y/n); less storage device strain and maybe faster build:
@rem if %mesabldsys%==meson if NOT %ninjastate%==0 echo.
@if /I "%ninja%"=="y" if %ninjastate%==1 set PATH=%mesa%\ninja\;%PATH%
@if /I "%ninja%"=="y" set buildconf=%buildconf%ninja
@if /I "%ninja%"=="y" set buildcmd=ninja -j %throttle%
@if %mesabldsys%==meson if /I NOT "%ninja%"=="y" set buildconf=%buildconf%vs

@if %mesabldsys%==meson set buildconf=%buildconf% --default-library=static --buildtype=release
@if %mesabldsys%==meson if "%llvmlink%"=="MT" set buildconf=%buildconf% -Db_vscrt=mt

@set llvmless=n
@if %havellvm%==0 set llvmless=y
@rem Disable LLVM for Meson build
@if %mesabldsys%==meson set llvmless=y
@if %havellvm%==1 if %mesabldsys%==scons set /p llvmless=Build Mesa without LLVM (y/n). llvmpipe and swr drivers and high performance JIT won't be available for other drivers and libraries:
@if %havellvm%==1 if %mesabldsys%==scons echo.
@if %mesabldsys%==scons if /I "%llvmless%"=="y" set buildcmd=%buildcmd% llvm=no
@if %mesabldsys%==meson if /I NOT "%llvmless%"=="y" call %mesa%\mesa-dist-win\buildscript\modules\llvmwrapgen.cmd
@if %mesabldsys%==meson if /I NOT "%llvmless%"=="y" set buildconf=%buildconf% -Dllvm-wrap=llvm -Dllvm=true

@if %mesabldsys%==scons IF %toolchain%==msvc set /p openmp=Build Mesa3D with OpenMP. Faster build and smaller binaries (y/n):
@if %mesabldsys%==scons IF %toolchain%==msvc echo.
@if %mesabldsys%==scons if /I "%openmp%"=="y" set buildcmd=%buildcmd% openmp=1

@set swrdrv=n
@if /I NOT "%llvmless%"=="y" if %abi%==x64 IF %toolchain%==msvc set /p swrdrv=Do you want to build swr drivers? (y=yes):
@if /I NOT "%llvmless%"=="y" if %abi%==x64 IF %toolchain%==msvc echo.
@if %mesabldsys%==scons if /I "%swrdrv%"=="y" set buildcmd=%buildcmd% swr=1
@if %mesabldsys%==meson if /I "%swrdrv%"=="y" set buildconf=%buildconf% -Dgallium-drivers=swrast,swr -Dswr-arches=avx,avx2,skx,knl

@IF %mesabldsys%==meson set /p gles=Do you want to build GLAPI as a shared library and standalone GLES libraries (y/n):
@IF %mesabldsys%==meson echo.
@if %mesabldsys%==meson if /I "%gles%"=="y" set buildconf=%buildconf% -Dshared-glapi=true -Dgles1=true -Dgles2=true

@set expressmesabuild=n
@if %mesabldsys%==scons set /p expressmesabuild=Do you want to build Mesa with quick configuration - includes libgl-gdi, graw-gdi, graw-null, tests, osmesa and shared glapi and shared GLES libraries if glapi is a shared library:
@if %mesabldsys%==scons echo.
@if %mesabldsys%==scons IF /I NOT "%expressmesabuild%"=="y" set buildcmd=%buildcmd% libgl-gdi

@set osmesa=n
@IF /I NOT "%expressmesabuild%"=="y" set /p osmesa=Do you want to build off-screen rendering drivers (y/n):
@IF /I NOT "%expressmesabuild%"=="y" echo.
@if %mesabldsys%==scons IF /I NOT "%expressmesabuild%"=="y" IF /I "%osmesa%"=="y" set buildcmd=%buildcmd% osmesa
@if %mesabldsys%==meson IF /I "%osmesa%"=="y" set buildconf=%buildconf% -Dosmesa=gallium
@IF /I "%expressmesabuild%"=="y" set osmesa=y

@set graw=n
@IF /I NOT "%expressmesabuild%"=="y" set /p graw=Do you want to build graw library (y/n):
@IF /I NOT "%expressmesabuild%"=="y" echo.
@if %mesabldsys%==scons if /I "%graw%"=="y" IF /I NOT "%expressmesabuild%"=="y" set buildcmd=%buildcmd% graw-gdi
@IF /I "%expressmesabuild%"=="y" set graw=y
@if %mesabldsys%==meson if /I "%graw%"=="y" set buildconf=%buildconf% -Dbuild-tests=true

@if %mesabldsys%==scons if %toolchain%==gcc set buildcmd=%buildcmd%"

@set cleanbuild=n
@IF %mesabldsys%==scons if EXIST build\windows-%longabi% set /p cleanbuild=Do you want to clean build (y/n):
@IF %mesabldsys%==scons if EXIST build\windows-%longabi% echo.
@IF %mesabldsys%==meson if EXIST build\%abi% set /p cleanbuild=Do you want to clean build (y/n):
@IF %mesabldsys%==meson if EXIST build\%abi% echo.
@IF %mesabldsys%==scons if /I "%cleanbuild%"=="y" RD /S /Q build\windows-%longabi%
@IF %mesabldsys%==meson if /I "%cleanbuild%"=="y" RD /S /Q build\%abi%
@IF %mesabldsys%==meson if /I "%cleanbuild%"=="y" for /d %%a in ("%mesa%\mesa\subprojects\zlib-*") do @RD /S /Q "%%~a"
@IF %mesabldsys%==meson if /I "%cleanbuild%"=="y" for /d %%a in ("%mesa%\mesa\subprojects\expat-*") do @RD /S /Q "%%~a"

@IF %toolchain%==msvc IF %flexstate%==1 set PATH=%mesa%\flexbison\;%PATH%
@if %mesabldsys%==meson IF %toolchain%==msvc set PATH==%pkgconfigloc%\;%PATH%

:build_mesa
@rem Generate dummy heaader for MSVC build when git is missing.
@IF %toolchain%==msvc if NOT EXIST build md build
@IF %toolchain%==msvc IF %mesabldsys%==scons if NOT EXIST build\windows-%longabi% md build\windows-%longabi%
@IF %toolchain%==msvc IF %mesabldsys%==scons if NOT EXIST build\windows-%longabi%\git_sha1.h echo 0 > build\windows-%longabi%\git_sha1.h
@IF %mesabldsys%==meson if NOT EXIST build\%abi% md build\%abi%
@IF %mesabldsys%==meson if NOT EXIST build\%abi%\src md build\%abi%\src
@IF %mesabldsys%==meson if NOT EXIST build\%abi%\src\git_sha1.h echo 0 > build\%abi%\src\git_sha1.h

@rem Prepare build command line tools and set compiler and linker flags.
@IF %toolchain%==msvc echo.
@IF %toolchain%==msvc IF /I "%ninja%"=="y" call %vsenv% %abi%
@IF %toolchain%==msvc IF /I NOT "%ninja%"=="y" call %vsenv% %vsabi%
@IF %toolchain%==msvc echo.
@IF %toolchain%==gcc set MSYSTEM=MINGW%minabi%
@IF %toolchain%==gcc set CFLAGS=-march=core2 -pipe
@IF %toolchain%==gcc set CXXFLAGS=-march=core2 -pipe
@IF %toolchain%==gcc set LDFLAGS=-static -s

@rem Execute build.
@if %mesabldsys%==meson echo Build configuration command: %buildconf%
@if %mesabldsys%==meson echo.
@if %mesabldsys%==meson %buildconf%
@if %mesabldsys%==meson echo.
@if %mesabldsys%==meson cd build\%abi%
@echo Build command: %buildcmd%
@echo.
@if %mesabldsys%==meson pause
@if %mesabldsys%==meson echo.
@%buildcmd%
@echo.
@if %mesabldsys%==meson cd ..\..\

:skipmesa
@rem Reset environment.
@endlocal
@setlocal
@rem Check environment
@IF %flexstate%==0 echo Flex and bison are required to build Mesa3D.
@IF %flexstate%==0 echo.
@IF %flexstate%==0 GOTO skipmesa
@if NOT EXIST mesa if %gitstate%==0 echo Fatal: Both Mesa3D code and Git are missing. At least one is required. Execution halted.
@if NOT EXIST mesa if %gitstate%==0 echo.
@if NOT EXIST mesa if %gitstate%==0 GOTO skipmesa
@IF %mesabldsys%==meson IF %pkgconfigstate%==0 echo No suitable pkg-config implementation found. pkgconf or pkg-config-lite is required to build Mesa3D with Meson and MSVC.
@IF %mesabldsys%==meson IF %pkgconfigstate%==0 echo.
@IF %mesabldsys%==meson IF %pkgconfigstate%==0 GOTO skipmesa

@REM Aquire Mesa3D source code if missing.
@set buildmesa=n
@cd %devroot%
@if %gitstate%==0 IF %toolchain%==msvc echo Error: Git not found. Auto-patching disabled. This could have many consequences going all the way up to build failure.
@if %gitstate%==0 IF %toolchain%==msvc echo.
@if NOT EXIST mesa echo Warning: Mesa3D source code not found.
@if NOT EXIST mesa echo.
@if NOT EXIST mesa set /p buildmesa=Download mesa code and build (y/n):
@if NOT EXIST mesa echo.
@if NOT EXIST mesa if /i NOT "%buildmesa%"=="y" GOTO skipmesa
@if NOT EXIST mesa set branch=master
@if NOT EXIST mesa set /p branch=Enter Mesa source code branch name - defaults to master:
@if NOT EXIST mesa echo.
@if NOT EXIST mesa (
@git clone --recurse-submodules https://gitlab.freedesktop.org/mesa/mesa.git mesa
@echo.
@cd mesa
@IF NOT "%branch%"=="master" git checkout %branch%
@echo.
@cd ..
)

@if EXIST mesa if /i NOT "%buildmesa%"=="y" (
@set /p buildmesa=Begin mesa build. Proceed - y/n :
@echo.
)
@if /i NOT "%buildmesa%"=="y" GOTO skipmesa
@cd mesa

@rem Get Mesa3D version as an integer
@set /p mesaver=<VERSION
@if "%mesaver:~-7%"=="0-devel" set /a intmesaver=%mesaver:~0,2%%mesaver:~3,1%00
@if "%mesaver:~5,4%"=="0-rc" set /a intmesaver=%mesaver:~0,2%%mesaver:~3,1%00+%mesaver:~9%
@if NOT "%mesaver:~5,2%"=="0-" set /a intmesaver=%mesaver:~0,2%%mesaver:~3,1%50+%mesaver:~5%
@IF NOT EXIST %devroot%\mesa\subprojects\.gitignore if %mesabldsys%==meson echo Meson build support is only available in Mesa 19.3 and newer.
@IF NOT EXIST %devroot%\mesa\subprojects\.gitignore if %mesabldsys%==meson echo.
@IF NOT EXIST %devroot%\mesa\subprojects\.gitignore if %mesabldsys%==meson GOTO skipmesa

@REM Collect information about Mesa3D code. Apply patches
@if %gitstate%==0 IF %toolchain%==msvc GOTO configmesabuild
@rem Enable S3TC texture cache
@call %devroot%\mesa-dist-win\buildscript\modules\applypatch.cmd s3tc
@rem Update Meson subprojects
@IF EXIST %devroot%\mesa\subprojects\.gitignore copy /Y %devroot%\mesa-dist-win\patches\zlib.wrap %devroot%\mesa\subprojects\zlib.wrap
@rem Fix swrAVX512 build
@IF EXIST %devroot%\mesa\subprojects\.gitignore IF %intmesaver% LSS 20000 call %devroot%\mesa-dist-win\buildscript\modules\applypatch.cmd swravx512
@IF %intmesaver% GEQ 20000 call %devroot%\mesa-dist-win\buildscript\modules\applypatch.cmd swravx512-post-static-link
@rem Ensure filenames parity with Scons
@IF EXIST %devroot%\mesa\subprojects\.gitignore IF %intmesaver% LSS 19303 call %devroot%\mesa-dist-win\buildscript\modules\applypatch.cmd filename-parity
@rem Make possible to build both osmesa gallium and swrast at the same time with Meson
@IF EXIST %devroot%\mesa\subprojects\.gitignore call %devroot%\mesa-dist-win\buildscript\modules\applypatch.cmd meson-build-both-osmesa

:configmesabuild
@rem Configure Mesa build.

@if %mesabldsys%==scons if %toolchain%==msvc IF NOT "%sconspypi%"=="1" set buildcmd=%devroot%\scons\src\script\scons.py
@if %mesabldsys%==scons if %toolchain%==msvc IF "%sconspypi%"=="1" set buildcmd=%pythonloc:~0,-10%Scripts\scons.py
@if %mesabldsys%==scons if %toolchain%==msvc IF "%sconspypi%"=="1" IF NOT EXIST "%buildcmd%" set buildcmd=%pythonloc:~0,-10%Scripts\scons
@if %mesabldsys%==scons if %toolchain%==msvc set buildcmd=%pythonloc% %buildcmd%
@if %mesabldsys%==scons if %toolchain%==gcc set buildcmd=%msysloc%\usr\bin\bash --login -c "cd ${devroot}/mesa;/usr/bin/scons
@if %mesabldsys%==scons set buildcmd=%buildcmd% -j%throttle% build=release platform=windows machine=%longabi%
@if %mesabldsys%==scons if %toolchain%==gcc set buildcmd=%buildcmd% toolchain=mingw
@if %mesabldsys%==scons if %toolchain%==msvc set buildcmd=%buildcmd% MSVC_USE_SCRIPT=%vsenv%

@set buildconf=null
@if %mesabldsys%==meson set buildconf=%mesonloc% build/%abi% --default-library=static --buildtype=release
@if %mesabldsys%==meson IF %toolchain%==msvc set buildconf=%buildconf% -Db_vscrt=mt
@if %mesabldsys%==meson set buildcmd=msbuild /p^:Configuration=release,Platform=Win32 mesa.sln /m^:%throttle%
@if %mesabldsys%==meson IF %abi%==x64 set buildcmd=msbuild /p^:Configuration=release,Platform=x64 mesa.sln /m^:%throttle%

@IF %toolchain%==msvc set LLVM=%devroot%\llvm\%abi%
@IF %toolchain%==gcc set LLVM=/mingw32
@IF %toolchain%==gcc IF %abi%==x64 set LLVM=/mingw64
@set havellvm=0
@IF EXIST %LLVM% set havellvm=1
@IF %toolchain%==gcc set havellvm=1
@set llvmless=n
@if %havellvm%==0 set llvmless=y
@if %havellvm%==1 set /p llvmless=Build Mesa without LLVM (y/n). llvmpipe and swr drivers and high performance JIT won't be available for other drivers and libraries:
@if %havellvm%==1 echo.
@if %mesabldsys%==scons if /I "%llvmless%"=="y" set buildcmd=%buildcmd% llvm=no
@if %mesabldsys%==meson if /I NOT "%llvmless%"=="y" call %devroot%\mesa-dist-win\buildscript\modules\llvmwrapgen.cmd
@if %mesabldsys%==meson if /I NOT "%llvmless%"=="y" set buildconf=%buildconf% -Dllvm=true
@if %mesabldsys%==meson if /I "%llvmless%"=="y" set buildconf=%buildconf% -Dllvm=false

@set useninja=n
@if %mesabldsys%==meson IF %toolchain%==gcc set useninja=y
@if %mesabldsys%==meson if NOT %ninjastate%==0 IF %toolchain%==msvc set /p useninja=Use Ninja build system instead of MsBuild (y/n); less storage device strain and maybe faster build:
@if %mesabldsys%==meson if NOT %ninjastate%==0 IF %toolchain%==msvc echo.
@if /I "%useninja%"=="y" if %ninjastate%==1 IF %toolchain%==msvc set PATH=%devroot%\ninja\;%PATH%
@if /I "%useninja%"=="y" set buildconf=%buildconf% --backend=ninja
@if /I "%useninja%"=="y" IF %toolchain%==msvc set buildcmd=ninja -j %throttle%
@if /I "%useninja%"=="y" IF %toolchain%==gcc set buildcmd=%msysloc%\usr\bin\bash --login -c "cd ${devroot}/mesa/build/%abi%;%LLVM%/bin/ninja -j %throttle%"
@if %mesabldsys%==meson if /I NOT "%useninja%"=="y" set buildconf=%buildconf% --backend=vs

@if %mesabldsys%==scons IF %toolchain%==msvc set /p openmp=Build Mesa3D with OpenMP. Faster build and smaller binaries (y/n):
@if %mesabldsys%==scons IF %toolchain%==msvc echo.
@if %mesabldsys%==scons if /I "%openmp%"=="y" set buildcmd=%buildcmd% openmp=1

@if %mesabldsys%==meson set buildconf=%buildconf% -Dgallium-drivers=swrast

@set zink=n
@rem IF %mesabldsys%==meson IF %toolchain%==gcc set /p zink=Do you want to build Mesa3D OpenGL driver over Vulkan - zink (y/n):
@rem IF %mesabldsys%==meson IF %toolchain%==gcc echo.
@IF /I "%zink%"=="y" set buildconf=%buildconf%,zink

@set swrdrv=n
@if /I NOT "%llvmless%"=="y" if %abi%==x64 IF %toolchain%==msvc set /p swrdrv=Do you want to build swr drivers? (y=yes):
@if /I NOT "%llvmless%"=="y" if %abi%==x64 IF %toolchain%==msvc echo.
@if %mesabldsys%==scons if /I "%swrdrv%"=="y" set buildcmd=%buildcmd% swr=1
@if %mesabldsys%==meson if /I "%swrdrv%"=="y" set buildconf=%buildconf%,swr -Dswr-arches=avx,avx2,skx,knl

@IF %mesabldsys%==meson set /p gles=Do you want to build GLAPI as a shared library and standalone GLES libraries (y/n):
@IF %mesabldsys%==meson echo.
@if %mesabldsys%==meson if /I "%gles%"=="y" set buildconf=%buildconf% -Dshared-glapi=true -Dgles1=true -Dgles2=true

@set expressmesabuild=n
@if %mesabldsys%==scons set /p expressmesabuild=Do you want to build Mesa with quick configuration - includes libgl-gdi, graw-gdi, graw-null, tests, osmesa and shared glapi and shared GLES libraries if glapi is a shared library:
@if %mesabldsys%==scons echo.
@if %mesabldsys%==scons IF /I NOT "%expressmesabuild%"=="y" set buildcmd=%buildcmd% libgl-gdi

@set osmesa=n
@IF /I "%expressmesabuild%"=="y" set osmesa=y
@IF /I NOT "%expressmesabuild%"=="y" set /p osmesa=Do you want to build off-screen rendering drivers (y/n):
@IF /I NOT "%expressmesabuild%"=="y" echo.
@if %mesabldsys%==scons IF /I NOT "%expressmesabuild%"=="y" IF /I "%osmesa%"=="y" set buildcmd=%buildcmd% osmesa
@if %mesabldsys%==meson IF /I "%osmesa%"=="y" set buildconf=%buildconf% -Dosmesa=gallium,classic
@if %mesabldsys%==meson IF /I "%osmesa%"=="y" if %gitstate%==0 IF %toolchain%==msvc set buildconf=%buildconf:~0,-8%
@rem Disable osmesa classic when building with Meson and Mingw due to build failure
@if %mesabldsys%==meson IF /I "%osmesa%"=="y" IF %toolchain%==gcc set buildconf=%buildconf:~0,-8%

@set graw=n
@IF /I "%expressmesabuild%"=="y" set graw=y
@IF /I NOT "%expressmesabuild%"=="y" set /p graw=Do you want to build graw library (y/n):
@IF /I NOT "%expressmesabuild%"=="y" echo.
@if %mesabldsys%==scons if /I "%graw%"=="y" IF /I NOT "%expressmesabuild%"=="y" set buildcmd=%buildcmd% graw-gdi
@if %mesabldsys%==meson if /I "%graw%"=="y" set buildconf=%buildconf% -Dbuild-tests=true

@set opencl=n
@rem According to Mesa source code clover OpenCL state tracker requires LLVM built with RTTI so it won't work with Mingw and it depends on libclc.
@rem IF %intmesaver% GEQ 20000 if %mesabldsys%==meson if /I NOT "%llvmless%"=="y" IF %toolchain%==msvc set /p opencl=Build Mesa3D clover OpenCL state tracker (y/):
@rem IF %intmesaver% GEQ 20000 if %mesabldsys%==meson if /I NOT "%llvmless%"=="y" IF %toolchain%==msvc echo.
@IF /I "%opencl%"=="y" set buildconf=%buildconf% -Dgallium-opencl=standalone

@if %toolchain%==gcc IF %mesabldsys%==scons set buildcmd=%buildcmd%"
@if %toolchain%==gcc IF %mesabldsys%==meson set buildconf=%buildconf%"

@set cleanbuild=n
@IF %mesabldsys%==meson set cleanbuild=y
@IF %mesabldsys%==meson for /d %%a in ("%devroot%\mesa\subprojects\zlib-*") do @RD /S /Q "%%~a"
@IF %mesabldsys%==meson for /d %%a in ("%devroot%\mesa\subprojects\expat-*") do @RD /S /Q "%%~a"
@IF %mesabldsys%==scons if EXIST build\windows-%longabi% set /p cleanbuild=Do you want to clean build (y/n):
@IF %mesabldsys%==scons if EXIST build\windows-%longabi% echo.
@IF %mesabldsys%==meson if EXIST build\%abi% echo WARNING: Meson build always performs clean build. This is last chance to cancel build.
@IF %mesabldsys%==meson if EXIST build\%abi% pause
@IF %mesabldsys%==meson if EXIST build\%abi% echo.
@IF %mesabldsys%==scons if /I "%cleanbuild%"=="y" IF EXIST build\windows-%longabi% RD /S /Q build\windows-%longabi%
@IF %mesabldsys%==meson if /I "%cleanbuild%"=="y" IF EXIST build\%abi% RD /S /Q build\%abi%

@IF %toolchain%==msvc IF %flexstate%==1 set PATH=%devroot%\flexbison\;%PATH%
@if %mesabldsys%==meson IF %toolchain%==msvc set PATH=%pkgconfigloc%\;%PATH%

:build_mesa
@rem Generate dummy header for MSVC build when git is missing.
@IF %toolchain%==msvc if NOT EXIST build md build
@IF %toolchain%==msvc IF %mesabldsys%==scons if NOT EXIST build\windows-%longabi% md build\windows-%longabi%
@IF %toolchain%==msvc IF %mesabldsys%==scons if NOT EXIST build\windows-%longabi%\git_sha1.h echo 0 > build\windows-%longabi%\git_sha1.h
@IF %mesabldsys%==meson if NOT EXIST build\%abi% md build\%abi%
@IF %mesabldsys%==meson if NOT EXIST build\%abi%\src md build\%abi%\src
@IF %mesabldsys%==meson if NOT EXIST build\%abi%\src\git_sha1.h echo 0 > build\%abi%\src\git_sha1.h

@rem Prepare build command line tools and set compiler and linker flags.
@IF %toolchain%==msvc echo.
@IF %toolchain%==msvc call %vsenv% %vsabi%
@IF %toolchain%==msvc echo.
@IF %toolchain%==gcc set MSYSTEM=MINGW32
@IF %toolchain%==gcc IF %abi%==x64 set MSYSTEM=MINGW64
@IF %toolchain%==gcc set CFLAGS=-march=core2 -pipe
@IF %toolchain%==gcc set CXXFLAGS=-march=core2 -pipe
@IF %toolchain%==gcc set LDFLAGS=-static -s

@rem Execute build.
@if %mesabldsys%==meson echo Build configuration command: %buildconf%
@if %mesabldsys%==meson echo.
@if %mesabldsys%==meson %buildconf%
@if %mesabldsys%==meson echo.
@if %mesabldsys%==meson IF %toolchain%==msvc cd build\%abi%
@echo Build command: %buildcmd%
@echo.
@if %mesabldsys%==meson pause
@if %mesabldsys%==meson echo.
@%buildcmd%
@echo.
@if %mesabldsys%==meson IF %toolchain%==msvc cd ..\..\

:skipmesa
@rem Reset environment.
@endlocal
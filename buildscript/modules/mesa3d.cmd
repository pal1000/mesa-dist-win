@setlocal
@rem Check environment
@IF %flexstate%==0 echo Flex and bison are required to build Mesa3D.
@IF %flexstate%==0 echo.
@IF %flexstate%==0 GOTO skipmesa
@if NOT EXIST mesa if %gitstate%==0 echo Fatal: Both Mesa3D code and Git are missing. At least one is required. Execution halted.
@if NOT EXIST mesa if %gitstate%==0 echo.
@if NOT EXIST mesa if %gitstate%==0 GOTO skipmesa
@IF %pkgconfigstate%==0 echo No suitable pkg-config implementation found. pkgconf or pkg-config-lite is required to build Mesa3D with Meson and MSVC.
@IF %pkgconfigstate%==0 echo.
@IF %pkgconfigstate%==0 GOTO skipmesa

@REM Aquire Mesa3D source code if missing.
@cd %devroot%
@if %gitstate%==0 IF NOT EXIST %msysloc%\usr\bin\patch.exe IF %toolchain%==msvc echo Error: Git and MSYS2 GNU patch are both missing. Auto-patching disabled. This could have many consequences going all the way up to build failure.
@if %gitstate%==0 IF NOT EXIST %msysloc%\usr\bin\patch.exe IF %toolchain%==msvc echo.
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
@IF NOT EXIST %devroot%\mesa\subprojects\.gitignore echo Mesa3D source code you are using is too old. Update to 19.3 or newer.
@IF NOT EXIST %devroot%\mesa\subprojects\.gitignore echo.
@IF NOT EXIST %devroot%\mesa\subprojects\.gitignore GOTO skipmesa

@rem Wrap zlib static library as Meson subproject.
@call %devroot%\%projectname%\buildscript\modules\zlibwrapgen.cmd

@REM Collect information about Mesa3D code. Apply patches.
@if %gitstate%==0 IF NOT EXIST %msysloc%\usr\bin\patch.exe IF %toolchain%==msvc GOTO configmesabuild
@set disablemesapatch=0
@IF %disablemesapatch%==1 echo WARNING: Patching is forcefully disabled!
@IF %disablemesapatch%==1 echo.
@IF %disablemesapatch%==1 GOTO configmesabuild
@rem Enable S3TC texture cache
@call %devroot%\%projectname%\buildscript\modules\applypatch.cmd s3tc
@rem Fix swrAVX512 build
@IF %intmesaver% LSS 20000 call %devroot%\%projectname%\buildscript\modules\applypatch.cmd swravx512
@IF %intmesaver% GEQ 20000 call %devroot%\%projectname%\buildscript\modules\applypatch.cmd swravx512-post-static-link
@rem Ensure filenames parity with Scons
@IF %intmesaver% LSS 19303 call %devroot%\%projectname%\buildscript\modules\applypatch.cmd filename-parity
@rem Make possible to build both osmesa gallium and swrast at the same time with Meson
@call %devroot%\%projectname%\buildscript\modules\applypatch.cmd meson-build-both-osmesa
@rem Fix regression when building with native mingw toolchains affecting Mesa 20.1 branch
@IF %intmesaver% GEQ 20100 IF %intmesaver% LSS 20103 call %devroot%\%projectname%\buildscript\modules\applypatch.cmd winepath

:configmesabuild
@rem Configure Mesa build.
@set buildconf=%mesonloc% build/%abi% --default-library=static --buildtype=release --prefix=%devroot:\=/%/%projectname%/dist/%abi%
@IF %toolchain%==msvc set buildconf=%buildconf% -Db_vscrt=mt
@IF NOT %toolchain%==msvc set buildconf=%buildconf% --wrap-mode=forcefallback -Dc_args='-march=core2 -pipe' -Dcpp_args='-march=core2 -pipe' -Dc_link_args='-static -s' -Dcpp_link_args='-static -s'
@IF %toolchain%==clang set CC=clang
@IF %toolchain%==clang set CXX=clang++
@set buildcmd=msbuild /p^:Configuration=release,Platform=Win32 mesa.sln /m^:%throttle%
@IF %abi%==x64 set buildcmd=msbuild /p^:Configuration=release,Platform=x64 mesa.sln /m^:%throttle%

@set havellvm=0
@IF EXIST %devroot%\llvm\%abi% set havellvm=1
@IF NOT %toolchain%==msvc set havellvm=1
@set llvmless=n
@if %havellvm%==0 set llvmless=y
@if %havellvm%==1 set /p llvmless=Build Mesa without LLVM (y/n). llvmpipe and swr drivers and high performance JIT won't be available for other drivers and libraries:
@if %havellvm%==1 echo.
@if /I NOT "%llvmless%"=="y" call %devroot%\%projectname%\buildscript\modules\llvmwrapgen.cmd
@if /I NOT "%llvmless%"=="y" set buildconf=%buildconf% -Dllvm=true
@if /I "%llvmless%"=="y" set buildconf=%buildconf% -Dllvm=false

@set useninja=n
@IF NOT %toolchain%==msvc set useninja=y
@if NOT %ninjastate%==0 IF %toolchain%==msvc set /p useninja=Use Ninja build system instead of MsBuild (y/n); less storage device strain and maybe faster build:
@if NOT %ninjastate%==0 IF %toolchain%==msvc echo.
@if /I "%useninja%"=="y" if %ninjastate%==1 IF %toolchain%==msvc set PATH=%devroot%\ninja\;%PATH%
@if /I "%useninja%"=="y" set buildconf=%buildconf% --backend=ninja
@if /I "%useninja%"=="y" IF %toolchain%==msvc set buildcmd=ninja -C %devroot:\=/%/mesa/build/%abi% -j %throttle%
@IF NOT %toolchain%==msvc set buildcmd=%msysloc%\usr\bin\bash --login -c "
@IF NOT %toolchain%==msvc IF %gitstate% GTR 0 set buildcmd=%buildcmd%PATH=${PATH}:${gitloc};
@IF NOT %toolchain%==msvc set buildcmd=%buildcmd%${MINGW_PREFIX}/bin/ninja -C $(/usr/bin/cygpath -m ${devroot})/mesa/build/${abi} -j ${throttle}"
@if /I NOT "%useninja%"=="y" set buildconf=%buildconf% --backend=vs

@set buildconf=%buildconf% -Dgallium-drivers=swrast

@set zink=n
@rem IF NOT %toolchain%==msvc set /p zink=Do you want to build Mesa3D OpenGL driver over Vulkan - zink (y/n):
@rem IF NOT %toolchain%==msvc echo.
@IF /I "%zink%"=="y" set buildconf=%buildconf%,zink

@set swrdrv=n
@if /I NOT "%llvmless%"=="y" if %abi%==x64 IF %toolchain%==msvc set /p swrdrv=Do you want to build swr drivers? (y=yes):
@if /I NOT "%llvmless%"=="y" if %abi%==x64 IF %toolchain%==msvc echo.
@if /I "%swrdrv%"=="y" set buildconf=%buildconf%,swr -Dswr-arches=avx,avx2,skx,knl

@set /p gles=Do you want to build GLAPI as a shared library and standalone GLES libraries (y/n):
@echo.
@if /I "%gles%"=="y" set buildconf=%buildconf% -Dshared-glapi=true -Dgles1=true -Dgles2=true

@set osmesa=n
@set /p osmesa=Do you want to build off-screen rendering drivers (y/n):
@echo.
@IF /I "%osmesa%"=="y" set buildconf=%buildconf% -Dosmesa=gallium,classic
@IF /I "%osmesa%"=="y" if %gitstate%==0 IF %toolchain%==msvc set buildconf=%buildconf:~0,-8%
@rem Disable osmesa classic when building with Meson and Mingw toolchains due to build failure
@IF /I "%osmesa%"=="y" IF NOT %toolchain%==msvc set buildconf=%buildconf:~0,-8%

@set graw=n
@set /p graw=Do you want to build graw library (y/n):
@echo.
@if /I "%graw%"=="y" set buildconf=%buildconf% -Dbuild-tests=true

@set opencl=n
@rem According to Mesa source code clover OpenCL state tracker requires LLVM built with RTTI so it won't work with Mingw and it depends on libclc.
@rem IF %intmesaver% GEQ 20000 if /I NOT "%llvmless%"=="y" IF %toolchain%==msvc set /p opencl=Build Mesa3D clover OpenCL state tracker (y/):
@rem IF %intmesaver% GEQ 20000 if /I NOT "%llvmless%"=="y" IF %toolchain%==msvc echo.
@IF /I "%opencl%"=="y" set buildconf=%buildconf% -Dgallium-opencl=standalone

@if NOT %toolchain%==msvc set buildconf=%buildconf%"

@if EXIST build\%abi% echo WARNING: Meson build always performs clean build. This is last chance to cancel build.
@if EXIST build\%abi% pause
@if EXIST build\%abi% echo.
@IF EXIST build\%abi% RD /S /Q build\%abi%

@IF %toolchain%==msvc IF %flexstate%==1 set PATH=%devroot%\flexbison\;%PATH%
@IF %toolchain%==msvc set PATH=%pkgconfigloc%\;%PATH%

:build_mesa
@rem Generate dummy header for MSVC build when git is missing.
@IF %toolchain%==msvc if NOT EXIST build md build
@IF %toolchain%==msvc if NOT EXIST build\%abi% md build\%abi%
@IF %toolchain%==msvc if NOT EXIST build\%abi%\src md build\%abi%\src
@IF %toolchain%==msvc if NOT EXIST build\%abi%\src\git_sha1.h echo 0 > build\%abi%\src\git_sha1.h

@rem Load MSVC environment if used.
@IF %toolchain%==msvc echo.
@IF %toolchain%==msvc call %vsenv% %vsabi%
@IF %toolchain%==msvc echo.

@rem Execute build.
@echo Build configuration command: %buildconf%
@echo.
@%buildconf%
@echo.
@if /I NOT "%useninja%"=="y" cd build\%abi%
@echo Build command: %buildcmd%
@echo.
@pause
@echo.
@%buildcmd%
@echo.
@if /I NOT "%useninja%"=="y" cd ..\..\

:skipmesa
@rem Reset environment.
@endlocal
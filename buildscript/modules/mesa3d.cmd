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
@if NOT EXIST mesa echo Warning: Mesa3D source code not found.
@if NOT EXIST mesa echo.
@if NOT EXIST mesa set /p buildmesa=Download mesa code and build (y/n):
@if NOT EXIST mesa echo.
@if NOT EXIST mesa if /i NOT "%buildmesa%"=="y" GOTO skipmesa
@if NOT EXIST mesa set branch=main
@if NOT EXIST mesa set /p branch=Enter Mesa source code branch name - defaults to main:
@if NOT EXIST mesa echo.
@if NOT EXIST mesa (
@git clone --recurse-submodules https://gitlab.freedesktop.org/mesa/mesa.git mesa
@echo.
@cd mesa
@IF NOT "%branch%"=="main" git checkout %branch%
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

@rem Support Mesa3D enabled/disabled style booleans for build options as the true/false ones will be removed at some point
@IF %intmesaver% LSS 20200 set mesonbooltrue=true
@IF %intmesaver% LSS 20200 set mesonboolfalse=false
@IF %intmesaver% GEQ 20200 set mesonbooltrue=enabled
@IF %intmesaver% GEQ 20200 set mesonboolfalse=disabled

@rem Treat all files as UTF-8 encoded, port mesa3d/mesa@b437fb81
@set PYTHONUTF8=1

@REM Handle lack of out of tree patches support.
@IF %disableootpatch%==1 IF %intmesaver% GEQ 20100 IF %intmesaver% LSS 20103 IF NOT %toolchain%==msvc echo FATAL: Mesa 20.1-devel through 20.1.0-rc2 cannot be built with MinGW without out of tree patches.
@IF %disableootpatch%==1 IF %intmesaver% GEQ 20100 IF %intmesaver% LSS 20103 IF NOT %toolchain%==msvc echo.
@IF %disableootpatch%==1 IF %intmesaver% GEQ 20100 IF %intmesaver% LSS 20103 IF NOT %toolchain%==msvc GOTO skipmesa
@IF %disableootpatch%==1 if NOT %gitstate%==0 echo Reverting out of tree patches...
@IF %disableootpatch%==1 if NOT %gitstate%==0 git checkout .
@IF %disableootpatch%==1 if NOT %gitstate%==0 git clean -fd
@IF %disableootpatch%==1 if NOT %gitstate%==0 echo.
@IF %disableootpatch%==1 GOTO configmesabuild

@REM Collect information about Mesa3D code. Apply out of tree patches.
@set msyspatchdir=%devroot%\mesa
@rem Enable S3TC texture cache
@call %devroot%\%projectname%\buildscript\modules\applypatch.cmd s3tc
@rem Fix swrAVX512 build with MSVC
@IF %intmesaver% LSS 20000 call %devroot%\%projectname%\buildscript\modules\applypatch.cmd swravx512
@IF %intmesaver% GEQ 20000 call %devroot%\%projectname%\buildscript\modules\applypatch.cmd swravx512-post-static-link
@rem Make it possible to build both osmesa gallium and swrast at the same time with Meson. Applies to Mesa 20.3 and older.
@IF %intmesaver% LSS 21000 call %devroot%\%projectname%\buildscript\modules\applypatch.cmd dual-osmesa
@IF %intmesaver% LSS 20200 call %devroot%\%projectname%\buildscript\modules\applypatch.cmd dual-osmesa-part2a
@IF %intmesaver% GEQ 20200 IF %intmesaver% LSS 21000 call %devroot%\%projectname%\buildscript\modules\applypatch.cmd dual-osmesa-part2b
@rem Fix regression when building with native mingw toolchains affecting Mesa 20.1 branch
@IF %intmesaver% GEQ 20100 IF %intmesaver% LSS 20103 call %devroot%\%projectname%\buildscript\modules\applypatch.cmd winepath
@rem Fix swr build
@IF %intmesaver% LSS 20152 call %devroot%\%projectname%\buildscript\modules\applypatch.cmd swrbuildfix
@rem Get swr building with Mingw
@IF %intmesaver% LSS 20158 call %devroot%\%projectname%\buildscript\modules\applypatch.cmd swr-mingw
@IF %intmesaver% GEQ 20200 IF %intmesaver% LSS 20250 call %devroot%\%projectname%\buildscript\modules\applypatch.cmd swr-mingw
@rem Fix lavapipe crash when built with MinGW
@IF %intmesaver:~0,3% EQU 211 IF %intmesaver% LSS 21151 call %devroot%\%projectname%\buildscript\modules\applypatch.cmd lavapipe-mingw-crashfix
@rem Fix lavapipe build with MSVC 32-bit
@IF %intmesaver:~0,3% EQU 211 IF %intmesaver% LSS 21151 call %devroot%\%projectname%\buildscript\modules\applypatch.cmd lavapipe-32-bit-msvc-buildfix
@rem Fix radv MinGW build
@IF %intmesaver% GEQ 21200 IF %intmesaver% LSS 21251 call %devroot%\%projectname%\buildscript\modules\applypatch.cmd radv-mingw
@rem Fix d3d10sw MSVC build
@IF %intmesaver% GEQ 21200 call %devroot%\%projectname%\buildscript\modules\applypatch.cmd d3d10sw

:configmesabuild
@rem Configure Mesa build.
@set buildconf=%mesonloc%
@if EXIST build\%abi% set /p cleanmesabld=Perform clean build (y/n):
@if EXIST build\%abi% echo.
@IF /I "%cleanmesabld%"=="y" RD /S /Q build\%abi%
@IF /I NOT "%cleanmesabld%"=="y" if EXIST build\%abi% set buildconf=%mesonloc% configure
@set buildconf=%buildconf% build/%abi% --buildtype=release -Db_ndebug=true --prefix=%devroot:\=/%/%projectname%/dist/%abi%
@IF %intmesaver% GEQ 21200 set buildconf=%buildconf% -Dc_std=c17
@IF %toolchain%==msvc set buildconf=%buildconf% -Db_vscrt=mt -Dzlib:default_library=static
@IF %toolchain%==msvc IF %intmesaver% GEQ 21200 set buildconf=%buildconf% -Dcpp_std=vc++latest
@IF NOT %toolchain%==msvc set buildconf=%buildconf% -Dc_args='-march=core2 -pipe' -Dcpp_args='-march=core2 -pipe'
@IF NOT %toolchain%==msvc set LDFLAGS=-static -s
@IF NOT %toolchain%==msvc IF %intmesaver% GTR 20000 set buildconf=%buildconf% -Dzstd=%mesonbooltrue%
@set buildcmd=msbuild /p^:Configuration=release,Platform=Win32 mesa.sln /m^:%throttle%
@IF %abi%==x64 set buildcmd=msbuild /p^:Configuration=release,Platform=x64 mesa.sln /m^:%throttle%

@set havellvm=0
@IF %toolchain%==msvc IF EXIST %devroot%\llvm\%abi% IF %cmakestate% GTR 0 set havellvm=1
@IF NOT %toolchain%==msvc set havellvm=1
@set llvmless=n
@if %havellvm%==0 set llvmless=y
@if %havellvm%==1 set /p llvmless=Build Mesa without LLVM (y/n). llvmpipe and swr drivers and high performance JIT won't be available for other drivers and libraries:
@if %havellvm%==1 echo.
@call %devroot%\%projectname%\buildscript\modules\mesonsubprojects.cmd
@IF NOT %toolchain%==msvc set buildconf=%buildconf% --force-fallback-for=zlib,libzstd
@if /I NOT "%llvmless%"=="y" IF %llvmconfigbusted% EQU 1 set buildconf=%buildconf%,llvm
@if /I NOT "%llvmless%"=="y" set buildconf=%buildconf% -Dllvm=%mesonbooltrue% -Dshared-llvm=%mesonboolfalse%
@if /I NOT "%llvmless%"=="y" IF %toolchain%==msvc set buildconf=%buildconf% --cmake-prefix-path=%devroot:\=/%/llvm/%abi%
@if /I NOT "%llvmless%"=="y" IF %toolchain%==msvc IF %cmakestate% EQU 1 SET PATH=%devroot%\cmake\bin\;%PATH%
@if /I "%llvmless%"=="y" set buildconf=%buildconf% -Dllvm=%mesonboolfalse%

@set useninja=n
@IF NOT %toolchain%==msvc set useninja=y
@if NOT %ninjastate%==0 IF %toolchain%==msvc set /p useninja=Use Ninja build system instead of MsBuild (y/n); less storage device strain and maybe faster build:
@if NOT %ninjastate%==0 IF %toolchain%==msvc echo.
@if /I "%useninja%"=="y" if %ninjastate%==1 IF %toolchain%==msvc set PATH=%devroot%\ninja\;%PATH%
@if /I "%useninja%"=="y" set buildconf=%buildconf% --backend=ninja
@if /I "%useninja%"=="y" IF %toolchain%==msvc set buildcmd=ninja -C %devroot:\=/%/mesa/build/%abi% -j %throttle% -k 0
@IF NOT %toolchain%==msvc set buildcmd=%msysloc%\usr\bin\bash --login -c "
@IF NOT %toolchain%==msvc IF %gitstate% GTR 0 set buildcmd=%buildcmd%PATH=${PATH}:${gitloc};
@IF NOT %toolchain%==msvc set buildcmd=%buildcmd%${MINGW_PREFIX}/bin/ninja -C $(/usr/bin/cygpath -m ${devroot})/mesa/build/${abi} -j ${throttle} -k 0"
@if /I NOT "%useninja%"=="y" set buildconf=%buildconf% --backend=vs

@set galliumcount=0
@set msysregex=0
@if NOT %toolchain%==msvc IF %intmesaver% GEQ 21300 set msysregex=1

@set glswrast=n
@if /I NOT "%llvmless%"=="y" set /p glswrast=Do you want to build Mesa3D softpipe and llvmpipe drivers (y/n):
@if /I "%llvmless%"=="y" set /p glswrast=Do you want to build Mesa3D softpipe driver (y/n):
@echo.
@if /I "%glswrast%"=="y" set /a galliumcount+=1

@set zink=n
@set canzink=0
@IF NOT %toolchain%==msvc IF %intmesaver% GEQ 21000 set canzink=1
@IF %toolchain%==msvc IF %intmesaver% GEQ 21200 set canzink=1
@IF %toolchain%==msvc IF %canzink% EQU 1 IF NOT EXIST "%VK_SDK_PATH%" IF NOT EXIST "%VULKAN_SDK%" set canzink=0
@IF %canzink% EQU 1 set /p zink=Do you want to build Mesa3D OpenGL driver over Vulkan - zink (y/n):
@IF %canzink% EQU 1 echo.
@IF %toolchain%==msvc IF /I "%zink%"=="y" set LDFLAGS=/DELAYLOAD:vulkan-1.dll
@IF /I "%zink%"=="y" set /a galliumcount+=1

@set d3d12=n
@IF EXIST %devroot%\mesa\subprojects\DirectX-Headers.wrap IF %intmesaver% GEQ 21000 IF %toolchain%==msvc set /p d3d12=Do you want to build Mesa3D OpenGL driver over D3D12 - GLonD3D12 (y/n):
@IF EXIST %devroot%\mesa\subprojects\DirectX-Headers.wrap IF %intmesaver% GEQ 21000 IF %toolchain%==msvc echo.
@IF /I "%d3d12%"=="y" set /a galliumcount+=1

@set swrdrv=n
@set canswr=0
@if /I NOT "%llvmless%"=="y" if %abi%==x64 IF %toolchain%==msvc IF %intmesaver% LSS 20152 IF %disableootpatch%==0 set canswr=1
@if /I NOT "%llvmless%"=="y" if %abi%==x64 IF %toolchain%==msvc IF %intmesaver% GEQ 20152 set canswr=1
@if /I NOT "%llvmless%"=="y" if %abi%==x64 IF NOT %toolchain%==msvc IF %disableootpatch%==0 set canswr=1
@if /I NOT "%llvmless%"=="y" if %abi%==x64 IF NOT %toolchain%==msvc IF %disableootpatch%==1 IF %intmesaver% GEQ 20158 IF %intmesaver% LSS 20200 set canswr=1
@if /I NOT "%llvmless%"=="y" if %abi%==x64 IF NOT %toolchain%==msvc IF %disableootpatch%==1 IF %intmesaver% GEQ 20250 set canswr=1
@if %canswr% EQU 1 set /p swrdrv=Do you want to build swr drivers? (y=yes):
@if %canswr% EQU 1 echo.
@if /I "%swrdrv%"=="y" IF %disableootpatch%==0 set buildconf=%buildconf% -Dswr-arches=avx,avx2,skx,knl
@if /I "%swrdrv%"=="y" IF %disableootpatch%==1 IF NOT %toolchain%==msvc set buildconf=%buildconf% -Dswr-arches=avx,avx2,skx,knl
@if /I "%swrdrv%"=="y" set /a galliumcount+=1

@set buildconf=%buildconf% -Dgallium-drivers=
@IF /I "%glswrast%"=="y" set buildconf=%buildconf%swrast,
@IF /I "%zink%"=="y" set buildconf=%buildconf%zink,
@IF /I "%d3d12%"=="y" set buildconf=%buildconf%d3d12,
@if /I "%swrdrv%"=="y" set buildconf=%buildconf%swr,
@IF %galliumcount% GTR 0 set buildconf=%buildconf:~0,-1%

@set mesavkcount=0

@set lavapipe=n
@set canlavapipe=1
@if /I "%llvmless%"=="y" set canlavapipe=0
@IF %intmesaver% LSS 21100 set canlavapipe=0
@if /I NOT "%glswrast%"=="y" set canlavapipe=0
@IF %intmesaver:~0,3% EQU 211 IF %intmesaver% LSS 21151 IF %toolchain%==msvc if %abi%==x86 IF %disableootpatch%==1 set canlavapipe=0
@IF %canlavapipe% EQU 1 set /p lavapipe=Build Mesa3D Vulkan software renderer (y/n):
@IF %canlavapipe% EQU 1 echo.
@if NOT %toolchain%==msvc if /I "%lavapipe%"=="y" set msysregex=1
@if /I "%lavapipe%"=="y" set /a mesavkcount+=1

@set radv=n
@set canradv=1
@if /I "%llvmless%"=="y" set canradv=0
@IF %intmesaver% LSS 21200 set canradv=0
@IF %toolchain%==msvc IF NOT EXIST %devroot%\llvm\%abi%\lib\LLVMAMDGPU*.lib set canradv=0
@IF %abi%==x86 set canradv=0
@IF %toolchain%==msvc IF NOT EXIST %devroot%\mesa\subprojects\libelf-lfg-win32 IF %gitstate% EQU 0 set canradv=0
@IF NOT %toolchain%==msvc IF %disableootpatch%==1 IF %intmesaver% LSS 21251 set canradv=0
@IF %canradv% EQU 1 set /p radv=Build AMD Vulkan driver - radv (y/n):
@IF %canradv% EQU 1 echo.
@IF NOT %toolchain%==msvc if /I "%radv%"=="y" set msysregex=1
@if /I "%radv%"=="y" set /a mesavkcount+=1

@set buildconf=%buildconf% -Dvulkan-drivers=
@if /I "%lavapipe%"=="y" set buildconf=%buildconf%swrast,
@if /I "%radv%"=="y" set buildconf=%buildconf%amd,
@IF %mesavkcount% GTR 0 set buildconf=%buildconf:~0,-1%

@IF %msysregex%==1 set LDFLAGS=%LDFLAGS% -ltre -lintl -liconv

@set d3d10umd=n
@set cand3d10umd=0
@IF %intmesaver% GEQ 21200 if /I "%glswrast%"=="y" IF %disableootpatch% EQU 0 IF %toolchain%==msvc for /f tokens^=^* %%a in ('@call %devroot%\%projectname%\buildscript\modules\winsdk.cmd wdk') do @IF "%%a"=="OK" set cand3d10umd=1
@IF %cand3d10umd% EQU 1 set /p d3d10umd=Build Mesa3D D3D10 software renderer (y/n):
@IF %cand3d10umd% EQU 1 echo.
@if /I "%d3d10umd%"=="y" set buildconf=%buildconf% -Dgallium-d3d10umd=true
@if /I NOT "%d3d10umd%"=="y" IF %intmesaver% GEQ 21200 set buildconf=%buildconf% -Dgallium-d3d10umd=false

@set spirvtodxil=n
@IF EXIST %devroot%\mesa\subprojects\DirectX-Headers.wrap IF %intmesaver% GEQ 21000 IF %toolchain%==msvc set /p spirvtodxil=Do you want to build SPIR-V to DXIL tool (y/n):
@IF EXIST %devroot%\mesa\subprojects\DirectX-Headers.wrap IF %intmesaver% GEQ 21000 IF %toolchain%==msvc echo.
@IF /I "%spirvtodxil%"=="y" set buildconf=%buildconf% -Dspirv-to-dxil=true
@IF /I NOT "%spirvtodxil%"=="y" IF %intmesaver% GEQ 21000 set buildconf=%buildconf% -Dspirv-to-dxil=false

@set /p gles=Do you want to build GLAPI as a shared library and standalone GLES libraries (y/n):
@echo.
@if /I "%gles%"=="y" set buildconf=%buildconf% -Dshared-glapi=%mesonbooltrue% -Dgles1=%mesonbooltrue% -Dgles2=%mesonbooltrue%
@if /I NOT "%gles%"=="y" set buildconf=%buildconf% -Dshared-glapi=auto -Dgles1=auto -Dgles2=auto

@set osmesa=n
@if /I "%glswrast%"=="y" IF %intmesaver% LSS 21000 set /p osmesa=Do you want to build off-screen rendering drivers (y/n):
@if /I "%glswrast%"=="y" IF %intmesaver% GEQ 21000 set /p osmesa=Do you want to build off-screen rendering driver (y/n):
@if /I "%glswrast%"=="y" echo.
@rem osmesa classic is gone in Mesa 21.0 and newer
@IF /I "%osmesa%"=="y" IF %intmesaver% GEQ 21000 set buildconf=%buildconf% -Dosmesa=true
@IF /I "%osmesa%"=="y" IF %intmesaver% LSS 21000 set buildconf=%buildconf% -Dosmesa=gallium,classic
@rem Building both osmesa gallium and classic requires out of tree patches
@IF /I "%osmesa%"=="y" IF %intmesaver% LSS 21000 IF %toolchain%==msvc IF %disableootpatch%==1 set buildconf=%buildconf:~0,-8%
@rem Disable osmesa classic when building with Meson and Mingw toolchains due to build failure
@IF /I "%osmesa%"=="y" IF %intmesaver% LSS 21000 IF NOT %toolchain%==msvc set buildconf=%buildconf:~0,-8%
@rem Explicitly disable osmesa when asked, for incremental build consistency
@IF /I NOT "%osmesa%"=="y" IF %intmesaver% LSS 21000 set buildconf=%buildconf% -Dosmesa=
@IF /I NOT "%osmesa%"=="y" IF %intmesaver% GEQ 21000 set buildconf=%buildconf% -Dosmesa=false

@set graw=n
@set /p graw=Do you want to build graw library (y/n):
@echo.
@if /I "%graw%"=="y" set buildconf=%buildconf% -Dbuild-tests=true
@if /I NOT "%graw%"=="y" set buildconf=%buildconf% -Dbuild-tests=false

@rem According to Mesa source code CLonD3D12 requires SPIRV tools and LLVM built with clang, LLD, SPIRV translator and libclc and it doesn't support MinGW.
@set canopencl=1
@IF NOT EXIST %devroot%\mesa\subprojects\DirectX-Headers.wrap set canopencl=0
@IF %intmesaver% LSS 21000 set canopencl=0
@IF NOT %toolchain%==msvc set canopencl=0
@if /I "%llvmless%"=="y" set canopencl=0
@IF NOT EXIST %devroot%\llvm\%abi%\lib\pkgconfig set canopencl=0
@IF NOT EXIST %devroot%\llvm\clc\share\pkgconfig set canopencl=0
@IF NOT EXIST %devroot%\spirv-tools\%abi%\lib\pkgconfig set canopencl=0
@IF %canopencl% EQU 1 set /p opencl=Build Mesa3D Microsoft OpenCL on D3D12 driver (y/n):
@IF %canopencl% EQU 1 echo.
@IF /I "%opencl%"=="y" set buildconf=%buildconf% --pkg-config-path=%devroot:\=/%/llvm/%abi%/lib/pkgconfig;%devroot:\=/%/llvm/clc/share/pkgconfig;%devroot:\=/%/spirv-tools/%abi%/lib/pkgconfig -Dmicrosoft-clc=enabled -Dstatic-libclc=all
@IF /I NOT "%opencl%"=="y" IF %intmesaver% GEQ 21000 set buildconf=%buildconf% -Dmicrosoft-clc=disabled

@rem Pass additional linker flags
@if %toolchain%==msvc if defined LDFLAGS set buildconf=%buildconf% -Dc_link_args="%LDFLAGS%" -Dcpp_link_args="%LDFLAGS%"
@if NOT %toolchain%==msvc set buildconf=%buildconf% -Dc_link_args='%LDFLAGS%' -Dcpp_link_args='%LDFLAGS%'"

@rem Load MSVC specific build dependencies
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

@rem Execute build configuration.
@echo Build configuration command: %buildconf%
@echo.
@set LDFLAGS=
@%buildconf%
@echo.
@if /I NOT "%useninja%"=="y" cd build\%abi%
@echo Build command: %buildcmd%
@echo.
@pause
@echo.
@set retrymesabld=0

:execmesabld
@set "ERRORLEVEL="
@CMD /C EXIT 0
@%buildcmd%
@if NOT "%ERRORLEVEL%"=="0" if %retrymesabld% EQU 0 set retrymesabld=1
@echo.

:retrymesabld
@if /I "%useninja%"=="y" if "%retrymesabld%"=="1" (
@set /p retrymesabld=Number of Mesa3D build retries ^(0^=end, 1^=ask again, ^>1 automatically retry n-1 times^)^:
@echo.
@if "%retrymesabld%"=="1" GOTO retrymesabld
)
@if /I "%useninja%"=="y" if %retrymesabld% GTR 1 (
@set /a retrymesabld-=1
GOTO execmesabld
)
@if /I "%useninja%"=="y" echo.
@if /I NOT "%useninja%"=="y" cd ..\..\

:skipmesa
@rem Reset environment.
@endlocal
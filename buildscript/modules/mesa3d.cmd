@setlocal
@rem Check environment
@IF %flexstate%==0 echo Flex and bison are required to build Mesa3D.
@IF %flexstate%==0 echo.
@IF %flexstate%==0 GOTO skipmesa

@cd "%devroot%"
@if NOT EXIST "mesa\" if %gitstate%==0 echo Fatal: Both Mesa3D code and Git are missing. At least one is required. Execution halted.
@if NOT EXIST "mesa\" if %gitstate%==0 echo.
@if NOT EXIST "mesa\" if %gitstate%==0 GOTO skipmesa

@IF %pkgconfigstate%==0 echo No suitable pkg-config implementation found. pkgconf or pkg-config-lite is required to build Mesa3D with Meson and MSVC.
@IF %pkgconfigstate%==0 echo.
@IF %pkgconfigstate%==0 GOTO skipmesa

@rem Ask for starting Mesa3D build and aquire source code if missing
@if EXIST "mesa\" set /p buildmesa=Begin mesa build. Proceed - y/n :
@if NOT EXIST "mesa\" echo Warning: Mesa3D source code not found.
@if NOT EXIST "mesa\" echo.
@if NOT EXIST "mesa\" set /p buildmesa=Download mesa code and build (y/n):
@echo.
@if /i NOT "%buildmesa%"=="y" GOTO skipmesa
@if NOT EXIST "mesa\" set branch=main
@if NOT EXIST "mesa\" set /p branch=Enter Mesa source code branch name - defaults to main:
@if NOT EXIST "mesa\" echo.
@if NOT EXIST "mesa\" (
@git clone --recurse-submodules https://gitlab.freedesktop.org/mesa/mesa.git mesa
@echo.
@cd mesa
@IF NOT "%branch%"=="main" git checkout %branch%
@IF NOT "%branch%"=="main" echo.
@cd ..
)

@cd mesa

@rem Get Mesa3D version as an integer
@set /p mesaver=<VERSION
@if "%mesaver:~-7%"=="0-devel" set /a intmesaver=%mesaver:~0,2%%mesaver:~3,1%00
@if "%mesaver:~5,4%"=="0-rc" set /a intmesaver=%mesaver:~0,2%%mesaver:~3,1%00+%mesaver:~9%
@if NOT "%mesaver:~5,2%"=="0-" set /a intmesaver=%mesaver:~0,2%%mesaver:~3,1%50+%mesaver:~5%
@IF NOT EXIST "%devroot%\mesa\subprojects\.gitignore" echo Mesa3D source code you are using is too old. Update to 19.3 or newer.
@IF NOT EXIST "%devroot%\mesa\subprojects\.gitignore" echo.
@IF NOT EXIST "%devroot%\mesa\subprojects\.gitignore" GOTO skipmesa

@rem Support Mesa3D enabled/disabled style booleans for build options as the true/false ones will be removed at some point
@IF %intmesaver% LSS 20200 set mesonbooltrue=true
@IF %intmesaver% LSS 20200 set mesonboolfalse=false
@IF %intmesaver% GEQ 20200 set mesonbooltrue=enabled
@IF %intmesaver% GEQ 20200 set mesonboolfalse=disabled

@rem Treat all files as UTF-8 encoded, port mesa3d/mesa@b437fb81
@set PYTHONUTF8=1

@REM Handle lack of out of tree patches support.
@IF %disableootpatch%==1 if NOT %gitstate%==0 echo Reverting out of tree patches...
@IF %disableootpatch%==1 if NOT %gitstate%==0 git checkout .
@IF %disableootpatch%==1 if NOT %gitstate%==0 git clean -fd
@IF %disableootpatch%==1 if NOT %gitstate%==0 echo.
@IF %intmesaver% LSS 22100 IF %disableootpatch%==1 IF %toolchain%==clang echo Building Mesa3D prior to 22.1 with clang requires out of tree patches.
@IF %intmesaver% LSS 22100 IF %disableootpatch%==1 IF %toolchain%==clang echo.
@IF %intmesaver% LSS 22100 IF %disableootpatch%==1 IF %toolchain%==clang GOTO skipmesa
@IF %intmesaver% LSS 21254 IF %toolchain%==clang echo Only Mesa3D 21.2.4 and newer is known to work with MinGW-W64 clang toolchain.
@IF %intmesaver% LSS 21254 IF %toolchain%==clang echo.
@IF %intmesaver% LSS 21254 IF %toolchain%==clang GOTO skipmesa
@IF %intmesaver% GEQ 21300 IF %intmesaver% LSS 22200 IF %disableootpatch%==1 IF %abi%==x86 IF %toolchain%==gcc echo Building 32-bit Mesa3D 21.3 through 22.1 using MSYS2 MinGW-W64 GCC requires out of tree patches.
@IF %intmesaver% GEQ 21300 IF %intmesaver% LSS 22200 IF %disableootpatch%==1 IF %abi%==x86 IF %toolchain%==gcc echo.
@IF %intmesaver% GEQ 21300 IF %intmesaver% LSS 22200 IF %disableootpatch%==1 IF %abi%==x86 IF %toolchain%==gcc GOTO skipmesa
@IF %intmesaver% GEQ 22003 IF %intmesaver% LSS 22051 IF %disableootpatch%==1 IF %abi%==x86 IF %toolchain%==msvc echo Building 32-bit Mesa3D 22.0.0-rc3 through 22.0.0 stable using MSVC requires out of tree patches.
@IF %intmesaver% GEQ 22003 IF %intmesaver% LSS 22051 IF %disableootpatch%==1 IF %abi%==x86 IF %toolchain%==msvc echo.
@IF %intmesaver% GEQ 22003 IF %intmesaver% LSS 22051 IF %disableootpatch%==1 IF %abi%==x86 IF %toolchain%==msvc GOTO skipmesa
@IF %disableootpatch%==1 GOTO configmesabuild

@REM Collect information about Mesa3D code. Apply out of tree patches.
@set msyspatchdir=%devroot%\mesa

@rem Enable S3TC texture cache
@call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" s3tc

@rem Fix regression when building with native mingw toolchains affecting Mesa 20.1 branch
@IF %intmesaver% GEQ 20100 IF %intmesaver% LSS 20103 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" winepath

@rem Fix link flags passing for MinGW
@IF %intmesaver% GEQ 21300 IF %intmesaver% LSS 21352 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" mingw-CRT-link-fix

@rem Fix symbols exporting for MinGW GCC x86
@IF %intmesaver% GEQ 21300 IF %intmesaver% LSS 22200 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" def-fixes
@IF %intmesaver:~0,3% EQU 221 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" def-fix-dzn

@rem Fix MinGW clang build
@IF %intmesaver% GEQ 21254 IF %intmesaver% LSS 22100 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" clang
@IF %intmesaver% GEQ 21254 IF EXIST "%devroot%\mesa\src\gallium\drivers\swr\meson.build" call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" clang-swr

@rem Fix MinGW static link with regex
@IF %intmesaver% GEQ 21100 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" fix-regex-static-link

@rem Fix 32-bit MSVC build for Mesa 22.0.0-rc3 - 22.0.0
@IF %intmesaver% GEQ 22003 IF %intmesaver% LSS 22051 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" msvc-32_bit-libmesa_util

@rem Make it possible to build both osmesa gallium and swrast at the same time with Meson. Applies to Mesa 20.3 and older.
@IF %intmesaver% LSS 21000 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" dual-osmesa
@IF %intmesaver% LSS 20200 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" dual-osmesa-part2a
@IF %intmesaver% GEQ 20200 IF %intmesaver% LSS 21000 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" dual-osmesa-part2b

@rem Fix swrAVX512 build with MSVC
@IF %intmesaver% LSS 20000 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" swravx512
@IF %intmesaver% GEQ 20000 IF EXIST "%devroot%\mesa\src\gallium\drivers\swr\meson.build" call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" swravx512-post-static-link

@rem Fix swr build with MSVC
@IF %intmesaver% LSS 20152 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" swr-msvc
@IF %intmesaver% GEQ 21300 IF %intmesaver% LSS 21353 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" swr-msvc-2

@rem Get swr building with Mingw
@IF %intmesaver% LSS 20158 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" swr-mingw
@IF %intmesaver% GEQ 20200 IF %intmesaver% LSS 20250 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" swr-mingw

@rem Fix swr build with LLVM 13
@IF EXIST "%devroot%\mesa\src\gallium\drivers\swr\meson.build" call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" swr-llvm13

@rem Fix lavapipe crash when built with MinGW
@IF %intmesaver:~0,3% EQU 211 IF %intmesaver% LSS 21151 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" lavapipe-mingw-crashfix

@rem Fix lavapipe build with MSVC 32-bit
@IF %intmesaver:~0,3% EQU 211 IF %intmesaver% LSS 21151 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" lavapipe-32-bit-msvc-buildfix

@rem Fix radv MinGW build
@IF %intmesaver% GEQ 21200 IF %intmesaver% LSS 21251 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" radv-mingw

@rem Fix radv MSVC build with LLVM 13
@IF %intmesaver:~0,3% EQU 213 IF %intmesaver% LSS 21306 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" radv-msvc-llvm13
@IF %intmesaver:~0,3% EQU 212 IF %intmesaver% LSS 21256 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" radv-msvc-llvm13-2

@rem Fix vulkan util build with MSVC 32-bit
@IF %intmesaver% GEQ 21301 IF %intmesaver% LSS 21303 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" vulkan-core-msvc-32-bit

@rem Fix d3d10sw MSVC build
@IF %intmesaver% GEQ 21200 IF %intmesaver% LSS 22000 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" d3d10sw
@IF %intmesaver% GEQ 21300 IF %intmesaver% LSS 22000 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" d3d10sw-2

@rem Clover build on Windows
@IF %intmesaver% GEQ 21300 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" clover

:configmesabuild
@rem Configure Mesa build.
@set buildconf=%mesonloc% setup
@if EXIST "build\%toolchain%-%abi%\" set /p cleanmesabld=Perform clean build (y/n):
@if EXIST "build\%toolchain%-%abi%\" echo.
@if NOT EXIST "build\%toolchain%-%abi%\" set cleanmesabld=y
@if EXIST "build\%toolchain%-%abi%\" IF /I "%cleanmesabld%"=="y" RD /S /Q build\%toolchain%-%abi%
@IF /I NOT "%cleanmesabld%"=="y" set buildconf=%mesonloc% configure
@set buildconf=%buildconf% build/%toolchain%-%abi% --buildtype=release --libdir="lib/%abi%" --pkgconfig.relocatable -Db_ndebug=true
@IF %intmesaver% GEQ 21200 IF %intmesaver% LSS 22100 set buildconf=%buildconf% -Dc_std=c17
@IF %toolchain%==msvc set buildconf=%buildconf% --prefix="%devroot:\=/%/%projectname%" -Db_vscrt=mt -Dzlib:default_library=static
@IF %toolchain%==msvc IF %intmesaver% GEQ 21200 IF %intmesaver% LSS 22100 set buildconf=%buildconf% -Dcpp_std=vc++latest
@IF NOT %toolchain%==msvc IF %intmesaver% GTR 20000 set buildconf=%buildconf% -Dzstd=%mesonbooltrue%
@IF NOT %toolchain%==msvc set buildconf=%buildconf% --prefer-static --force-fallback-for=
@IF NOT %toolchain%==msvc set CFLAGS=-march^=core2 -pipe
@IF NOT %toolchain%==msvc set LDFLAGS=-static -s
@set buildcmd=msbuild /p^:Configuration=release,Platform=Win32 mesa.sln /m^:%throttle%
@IF %abi%==x64 set buildcmd=msbuild /p^:Configuration=release,Platform=x64 mesa.sln /m^:%throttle%

@set havellvm=1
@set llvmmethod=configtool
@IF %toolchain%==msvc IF NOT EXIST "%devroot%\llvm\build\%abi%\lib\" set havellvm=0
@IF %toolchain%==msvc IF NOT EXIST "%devroot%\llvm\build\%abi%\llvmconfig\llvm-config.exe" IF %cmakestate% EQU 0 set havellvm=0
@IF %toolchain%==msvc IF NOT EXIST "%devroot%\llvm\build\%abi%\llvmconfig\llvm-config.exe" IF %cmakestate% GTR 0 set llvmmethod=cmake
@set llvmless=n
@if %havellvm%==0 set llvmless=y
@if %havellvm%==1 set /p llvmless=Build Mesa without LLVM (y/n). llvmpipe, swr, RADV, lavapipe and all OpenCL drivers won't be available and high performance JIT won't be available for softpipe, osmesa and graw:
@if %havellvm%==1 echo.
@call "%devroot%\%projectname%\buildscript\modules\mesonsubprojects.cmd"
@IF "%vksdkselect%"=="1" IF %toolchain%==clang set buildconf=%buildconf%,vulkan
@if /I NOT "%llvmless%"=="y" IF %llvmconfigbusted% EQU 1 set buildconf=%buildconf%,llvm
@IF %intmesaver% GEQ 22000 set buildconf=%buildconf% -Dcpp_rtti=%RTTI%
@if /I NOT "%llvmless%"=="y" set buildconf=%buildconf% -Dllvm=%mesonbooltrue% -Dshared-llvm=%mesonboolfalse%
@if /I NOT "%llvmless%"=="y" IF %llvmmethod%==cmake set buildconf=%buildconf% --cmake-prefix-path="%devroot:\=/%/llvm/build/%abi%"
@if /I NOT "%llvmless%"=="y" IF %llvmmethod%==cmake IF %cmakestate% EQU 1 SET PATH=%devroot%\cmake\bin\;%PATH%
@if /I NOT "%llvmless%"=="y" IF NOT %llvmmethod%==cmake set buildconf=%buildconf% --cmake-prefix-path=
@if /I NOT "%llvmless%"=="y" IF NOT %llvmmethod%==cmake IF %toolchain%==msvc SET PATH=%devroot%\llvm\build\%abi%\llvmconfig\;%PATH%
@if /I "%llvmless%"=="y" set buildconf=%buildconf% -Dllvm=%mesonboolfalse%

@set useninja=n
@IF NOT %toolchain%==msvc set useninja=y
@if NOT %ninjastate%==0 IF %toolchain%==msvc set /p useninja=Use Ninja build system instead of MsBuild (y/n); less storage device strain and maybe faster build:
@if NOT %ninjastate%==0 IF %toolchain%==msvc echo.
@if /I "%useninja%"=="y" if %ninjastate%==1 IF %toolchain%==msvc set PATH=%devroot%\ninja\;%PATH%
@if /I "%useninja%"=="y" set buildconf=%buildconf% --backend=ninja
@if /I "%useninja%"=="y" IF %toolchain%==msvc set buildcmd=ninja -C "%devroot%\mesa\build\%toolchain%-%abi%" -j %throttle% -k 0
@IF NOT %toolchain%==msvc set buildcmd=%runmsys% cd "%devroot%\mesa\build\%toolchain%-%abi%";
@IF NOT %toolchain%==msvc IF %gitstate% GTR 0 set buildcmd=%buildcmd%PATH=${PATH}:${gitloc};
@IF NOT %toolchain%==msvc set buildcmd=%buildcmd%/%LMSYSTEM%/bin/ninja -j %throttle% -k 0
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
@IF %toolchain%==msvc IF %intmesaver% GEQ 21301 IF %intmesaver% LSS 21303 IF %abi%==x86 IF %disableootpatch%==1 set canzink=0
@IF %toolchain%==msvc IF NOT EXIST "%VK_SDK_PATH%" IF NOT EXIST "%VULKAN_SDK%" IF %intmesaver% LSS 22200 set canzink=0
@IF %canzink% EQU 1 set /p zink=Do you want to build Mesa3D OpenGL driver over Vulkan - zink (y/n):
@IF %canzink% EQU 1 echo.
@IF %toolchain%==msvc IF /I "%zink%"=="y" IF %intmesaver% LSS 22200 set LDFLAGS=-ldelayimp /DELAYLOAD^:vulkan-1.dll
@IF /I "%zink%"=="y" set /a galliumcount+=1

@rem Prerequisites for all Microsoft components in Mesa3D
@set canmcrdrvcom=1
@for /f delims^=^ eol^= %%a in ('dir /b /a:d "%devroot%\mesa\subprojects\DirectX-Header*" 2^>^&1') do @IF NOT EXIST "%devroot%\mesa\subprojects\%%~nxa\" IF %gitstate% EQU 0 set canmcrdrvcom=0
@IF %intmesaver% LSS 21000 set canmcrdrvcom=0
@IF NOT %toolchain%==msvc IF %intmesaver% LSS 22200 set canmcrdrvcom=0

@set d3d12=n
@IF %canmcrdrvcom% EQU 1 set /p d3d12=Do you want to build Mesa3D OpenGL driver over D3D12 - GLonD3D12 (y/n):
@IF %canmcrdrvcom% EQU 1 echo.
@IF /I "%d3d12%"=="y" set /a galliumcount+=1

@set swrdrv=n
@set canswr=0
@if /I NOT "%llvmless%"=="y" if %abi%==x64 IF %disableootpatch%==0 IF EXIST "%devroot%\mesa\src\gallium\drivers\swr\meson.build" set canswr=1
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
@IF %toolchain%==msvc IF %intmesaver% GEQ 21301 IF %intmesaver% LSS 21303 IF %abi%==x86 IF %disableootpatch%==1 set canlavapipe=0
@IF %canlavapipe% EQU 1 set /p lavapipe=Build Mesa3D Vulkan software renderer (y/n):
@IF %canlavapipe% EQU 1 echo.
@if NOT %toolchain%==msvc if /I "%lavapipe%"=="y" set msysregex=1
@if /I "%lavapipe%"=="y" set /a mesavkcount+=1

@rem HACK: OpenCL stack on Mesa 21.3+ requires RADV if LLVM AMDGPU target is available so allow building RADV with MSVC for 32-bit even when we know is going to fail
@set radv=n
@set canradv=1
@if /I "%llvmless%"=="y" set canradv=0
@IF %intmesaver% LSS 21200 set canradv=0
@IF %toolchain%==msvc IF NOT EXIST "%devroot%\llvm\build\%abi%\lib\LLVMAMDGPU*.lib" set canradv=0
@IF %toolchain%==msvc IF NOT EXIST "%devroot%\mesa\subprojects\libelf-lfg-win32\" IF %gitstate% EQU 0 set canradv=0
@IF %toolchain%==msvc IF %disableootpatch%==1 IF %intmesaver% LSS 21256 set canradv=0
@IF %toolchain%==msvc IF %disableootpatch%==1 IF %intmesaver% GEQ 21300 IF %intmesaver% LSS 21306 set canradv=0
@IF %toolchain%==msvc IF NOT EXIST "%VK_SDK_PATH%" IF NOT EXIST "%VULKAN_SDK%" IF %intmesaver% GEQ 22200 set canradv=0
@rem Disable RADV build, see https://github.com/pal1000/mesa-dist-win/issues/103
@IF NOT %toolchain%==msvc set canradv=0
@IF NOT %toolchain%==msvc IF %abi%==x86 IF %intmesaver% LSS 22000 set canradv=0
@IF NOT %toolchain%==msvc IF %disableootpatch%==1 IF %intmesaver% LSS 21251 set canradv=0
@IF %canradv% EQU 1 set /p radv=Build AMD Vulkan driver - radv (y/n):
@IF %canradv% EQU 1 echo.
@IF NOT %toolchain%==msvc if /I "%radv%"=="y" set msysregex=1
@if /I "%radv%"=="y" set /a mesavkcount+=1

@IF %canmcrdrvcom% EQU 1 IF %intmesaver% GEQ 22100 set /p dozenmsvk=Build Microsoft Dozen Vulkan driver (y/n):
@IF %canmcrdrvcom% EQU 1 IF %intmesaver% GEQ 22100 echo.
@if /I "%dozenmsvk%"=="y" set /a mesavkcount+=1

@set buildconf=%buildconf% -Dvulkan-drivers=
@if /I "%lavapipe%"=="y" set buildconf=%buildconf%swrast,
@if /I "%radv%"=="y" set buildconf=%buildconf%amd,
@if /I "%dozenmsvk%"=="y" set buildconf=%buildconf%microsoft-experimental,
@IF %mesavkcount% GTR 0 set buildconf=%buildconf:~0,-1%

@IF %msysregex%==1 IF %disableootpatch% EQU 1 set LDFLAGS=%LDFLAGS% -ltre -lintl -liconv

@set d3d10umd=n
@set cand3d10umd=1
@IF %intmesaver% LSS 21200 set cand3d10umd=0
@if /I NOT "%glswrast%"=="y" set cand3d10umd=0
@IF NOT %toolchain%==msvc set cand3d10umd=0
@IF %intmesaver% LSS 22000 IF %disableootpatch% EQU 1 set cand3d10umd=0
@IF %cand3d10umd% EQU 1 for /f delims^=^ eol^= %%a in ('@call "%devroot%\%projectname%\buildscript\modules\winsdk.cmd" wdk') do @IF NOT "%%a"=="OK" set cand3d10umd=0
@IF %cand3d10umd% EQU 1 set /p d3d10umd=Build Mesa3D D3D10 software renderer (y/n):
@IF %cand3d10umd% EQU 1 echo.
@if /I "%d3d10umd%"=="y" set buildconf=%buildconf% -Dgallium-d3d10umd=true
@if /I NOT "%d3d10umd%"=="y" IF %intmesaver% GEQ 21200 set buildconf=%buildconf% -Dgallium-d3d10umd=false

@set spirvtodxil=n
@if /I "%dozenmsvk%"=="y" set spirvtodxil=y
@IF %canmcrdrvcom% EQU 1 if /I NOT "%dozenmsvk%"=="y" set /p spirvtodxil=Do you want to build SPIR-V to DXIL tool (y/n):
@IF %canmcrdrvcom% EQU 1 if /I NOT "%dozenmsvk%"=="y" echo.
@IF /I "%spirvtodxil%"=="y" set buildconf=%buildconf% -Dspirv-to-dxil=true
@IF /I NOT "%spirvtodxil%"=="y" IF %intmesaver% GEQ 21000 set buildconf=%buildconf% -Dspirv-to-dxil=false

@set gles=n
@IF %intmesaver% LSS 21300 IF %galliumcount% GTR 0 set /p gles=Do you want to build GLAPI as a shared library and standalone GLES drivers (y/n):
@IF %intmesaver% GEQ 21300 IF %galliumcount% GTR 0 set /p gles=Do you want to build standalone GLES drivers (y/n):
@IF %galliumcount% GTR 0 echo.
@if /I "%gles%"=="y" set buildconf=%buildconf% -Dshared-glapi=%mesonbooltrue% -Dgles1=%mesonbooltrue% -Dgles2=%mesonbooltrue%
@if /I "%gles%"=="y" IF %intmesaver% GEQ 21300 set buildconf=%buildconf% -Degl=%mesonbooltrue%
@if /I NOT "%gles%"=="y" set buildconf=%buildconf% -Dgles1=auto -Dgles2=auto -Dshared-glapi=auto
@if /I NOT "%gles%"=="y" IF %intmesaver% GEQ 21300 IF %galliumcount% GTR 0 set buildconf=%buildconf:~0,-4%%mesonbooltrue%
@if /I NOT "%gles%"=="y" IF %intmesaver% GEQ 21300 set buildconf=%buildconf% -Degl=%mesonboolfalse%

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
@set cangraw=1
@IF %disableootpatch%==1 IF %intmesaver% GEQ 20100 IF %intmesaver% LSS 20103 IF NOT %toolchain%==msvc set cangraw=0
@IF %cangraw% EQU 1 set /p graw=Do you want to build graw library (y/n):
@IF %cangraw% EQU 1 echo.
@if /I "%graw%"=="y" set buildconf=%buildconf% -Dbuild-tests=true
@if /I NOT "%graw%"=="y" set buildconf=%buildconf% -Dbuild-tests=false

@rem Basic OpenCL requirements: Mesa 21.0+, LLVM and libclc
@rem HACK: OpenCL stack on Mesa 21.3+ requires RADV if LLVM AMDGPU target is available
@set canopencl=1
@IF %intmesaver% LSS 21000 set canopencl=0
@IF NOT %toolchain%==msvc set canopencl=0
@if /I "%llvmless%"=="y" set canopencl=0
@IF NOT EXIST "%devroot%\llvm\build\clc\share\pkgconfig\" set canopencl=0
@IF %intmesaver% GEQ 21300 IF EXIST "%devroot%\llvm\build\%abi%\lib\LLVMAMDGPU*.lib" if /I NOT "%radv%"=="y" set canopencl=0

@rem OpenCL SPIR-V requirements: basic support + Clang, LLD, LLVM SPIRV translator and SPIRV tools
@set canclspv=1
@IF %canopencl% EQU 0 set canclspv=0
@IF NOT EXIST "%devroot%\llvm\build\%abi%\lib\clang*.lib" set canclspv=0
@IF NOT EXIST "%devroot%\llvm\build\%abi%\lib\lld*.lib" set canclspv=0
@IF NOT EXIST "%devroot%\llvm\build\spv-%abi%\lib\pkgconfig\" set canclspv=0
@IF NOT EXIST "%devroot%\spirv-tools\build\%abi%\lib\pkgconfig\" set canclspv=0

@rem Clover requirements: basic support + Mesa 21.3, LLVM build with RTTI, gallium swrast, out of tree patches.
@rem Disabled as it doesn't work - https://github.com/pal1000/mesa-dist-win/issues/88
@set canclover=1
@IF %canopencl% EQU 0 set canclover=0
@IF %intmesaver% LSS 21300 set canclover=0
@IF %RTTI%==false set canclover=0
@if /I NOT "%glswrast%"=="y" set canclover=0
@IF %disableootpatch%==1 set canclover=0
@set canclover=0

@rem Add flags tracking PKG_CONFIG search PATH adjustment needs
@set PKG_CONFIG_LIBCLC=0
@set PKG_CONFIG_SPV=0

@rem Microsoft OpenCL compiler requires OpenCL SPIR-V and DirectX Headers
@IF %canclspv% EQU 1 IF %canmcrdrvcom% EQU 1 set /p mclc=Build Mesa3D Microsoft OpenCL compiler (y/n):
@IF %canclspv% EQU 1 IF %canmcrdrvcom% EQU 1 echo.
@IF /I "%mclc%"=="y" set PKG_CONFIG_LIBCLC=1
@IF /I "%mclc%"=="y" set PKG_CONFIG_SPV=1
@IF /I "%mclc%"=="y" set buildconf=%buildconf% -Dmicrosoft-clc=enabled
@IF /I NOT "%mclc%"=="y" IF %intmesaver% GEQ 21000 set buildconf=%buildconf% -Dmicrosoft-clc=disabled

@rem Build clover
@if %canclover% EQU 1 set /p buildclover=Build OpenCL clover driver (y/n):
@if %canclover% EQU 1 echo.
@IF /I NOT "%buildclover%"=="y" set buildconf=%buildconf% -Dgallium-opencl=disabled
@IF /I "%buildclover%"=="y" set PKG_CONFIG_LIBCLC=1
@IF /I "%buildclover%"=="y" set /p icdclover=Build clover in ICD format (y/n):
@IF /I "%buildclover%"=="y" echo.
@IF /I "%icdclover%"=="y" set buildconf=%buildconf% -Dgallium-opencl=icd
@IF /I "%buildclover%"=="y" IF /I NOT "%icdclover%"=="y" set buildconf=%buildconf% -Dgallium-opencl=standalone
@IF /I "%buildclover%"=="y" IF %canclspv% EQU 1 set /p cloverspv=Build clover with SPIR-V binary support (y/n):
@IF /I "%buildclover%"=="y" IF %canclspv% EQU 1 echo.
@IF /I "%cloverspv%"=="y" set PKG_CONFIG_SPV=1
@IF /I "%cloverspv%"=="y" set buildconf=%buildconf% -Dopencl-spirv=true
@IF /I "%buildclover%"=="y" IF /I NOT "%cloverspv%"=="y" set buildconf=%buildconf% -Dopencl-spirv=false
@IF /I "%buildclover%"=="y" set buildconf=%buildconf% -Dopencl-native=false
@IF /I "%buildclover%"=="y" IF %intmesaver% GEQ 22100 set buildconf=%buildconf% -Dcpp_std=c++20

@rem Apply PKG_CONFIG search PATH adjustments
@IF %PKG_CONFIG_LIBCLC% EQU 1 set buildconf=%buildconf% -Dstatic-libclc=all --pkg-config-path="%devroot:\=/%/llvm/build/clc/share/pkgconfig"
@IF %PKG_CONFIG_SPV% EQU 1 set buildconf=%buildconf:~0,-1%;%devroot:\=/%/llvm/build/spv-%abi%/lib/pkgconfig;%devroot:\=/%/spirv-tools/build/%abi%/lib/pkgconfig"
@set "PKG_CONFIG_LIBCLC="
@set "PKG_CONFIG_SPV="

@rem Pass additional compiler and linker flags
@if defined CFLAGS set buildconf=%buildconf% -Dc_args="%CFLAGS%" -Dcpp_args="%CFLAGS%"
@if defined LDFLAGS set buildconf=%buildconf% -Dc_link_args="%LDFLAGS%" -Dcpp_link_args="%LDFLAGS%"

@rem Load MSVC specific build dependencies
@IF %toolchain%==msvc IF %flexstate%==1 set PATH=%devroot%\flexbison\;%PATH%
@IF %toolchain%==msvc set PATH=%pkgconfigloc%\;%PATH%

:build_mesa
@rem Generate dummy header for MSVC build when git is missing.
@IF %toolchain%==msvc if NOT EXIST "build\" md build
@IF %toolchain%==msvc if NOT EXIST "build\%toolchain%-%abi%\" md build\%toolchain%-%abi%
@IF %toolchain%==msvc if NOT EXIST "build\%toolchain%-%abi%\src\" md build\%toolchain%-%abi%\src
@IF %toolchain%==msvc if NOT EXIST build\%toolchain%-%abi%\src\git_sha1.h echo 0 > build\%toolchain%-%abi%\src\git_sha1.h

@rem Load MSVC environment if used.
@IF %toolchain%==msvc echo.
@IF %toolchain%==msvc call %vsenv% %vsabi%
@IF %toolchain%==msvc echo.

@rem Execute build configuration.
@echo Build configuration command: %buildconf%
@echo.
@IF /I "%cleanmesabld%"=="y" pause
@IF /I "%cleanmesabld%"=="y" echo.
@set CFLAGS=
@set LDFLAGS=
@%buildconf%
@echo.
@if /I NOT "%useninja%"=="y" cd build\%toolchain%-%abi%
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
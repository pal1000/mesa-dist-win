@setlocal
@rem Check environment
@IF %flexstate%==0 echo Flex and bison are required to build Mesa3D.
@IF %flexstate%==0 echo.
@IF %flexstate%==0 GOTO skipmesa

@cd "%devroot%\"
@if NOT EXIST "mesa\" if %gitstate%==0 echo Fatal: Both Mesa3D code and Git are missing. At least one is required. Execution halted.
@if NOT EXIST "mesa\" if %gitstate%==0 echo.
@if NOT EXIST "mesa\" if %gitstate%==0 GOTO skipmesa

@IF %pkgconfigstate%==0 echo No suitable pkg-config implementation found. pkgconf or pkg-config-lite is required to build Mesa3D with Meson and MSVC.
@IF %pkgconfigstate%==0 echo.
@IF %pkgconfigstate%==0 GOTO skipmesa

@rem Ask for starting Mesa3D build and aquire source code if missing
@if EXIST "mesa\" call "%devroot%\%projectname%\bin\modules\prompt.cmd" buildmesa "Begin mesa build. Proceed - y/n :"
@if NOT EXIST "mesa\" echo Warning: Mesa3D source code not found.
@if NOT EXIST "mesa\" echo.
@if NOT EXIST "mesa\" call "%devroot%\%projectname%\bin\modules\prompt.cmd" buildmesa "Download mesa code and build (y/n):"
@if /i NOT "%buildmesa%"=="y" GOTO skipmesa
@if NOT EXIST "mesa\" if %cimode% EQU 0 set branch=main
@if NOT EXIST "mesa\" call "%devroot%\%projectname%\bin\modules\prompt.cmd" branch "Enter Mesa source code branch name - defaults to main:"
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
@IF %intmesaver% LSS 22100 IF %disableootpatch%==1 IF /I "%useclang%"=="y" echo Building Mesa3D prior to 22.1 with clang requires out of tree patches.
@IF %intmesaver% LSS 22100 IF %disableootpatch%==1 IF /I "%useclang%"=="y" echo.
@IF %intmesaver% LSS 22100 IF %disableootpatch%==1 IF /I "%useclang%"=="y" GOTO skipmesa
@IF %intmesaver% LSS 21254 IF /I "%useclang%"=="y" echo Only Mesa3D 21.2.4 and newer is known to work with clang toolchain.
@IF %intmesaver% LSS 21254 IF /I "%useclang%"=="y" echo.
@IF %intmesaver% LSS 21254 IF /I "%useclang%"=="y" GOTO skipmesa
@IF %intmesaver% GEQ 21300 IF %intmesaver% LSS 22200 IF %disableootpatch%==1 IF %abi%==x86 IF %toolchain%==gcc echo Building 32-bit Mesa3D 21.3 through 22.1 using MSYS2 MinGW-W64 GCC requires out of tree patches.
@IF %intmesaver% GEQ 21300 IF %intmesaver% LSS 22200 IF %disableootpatch%==1 IF %abi%==x86 IF %toolchain%==gcc echo.
@IF %intmesaver% GEQ 21300 IF %intmesaver% LSS 22200 IF %disableootpatch%==1 IF %abi%==x86 IF %toolchain%==gcc GOTO skipmesa
@IF %intmesaver% GEQ 22003 IF %intmesaver% LSS 22051 IF %disableootpatch%==1 IF %abi%==x86 IF %toolchain%==msvc echo Building 32-bit Mesa3D 22.0.0-rc3 through 22.0.0 stable using MSVC requires out of tree patches.
@IF %intmesaver% GEQ 22003 IF %intmesaver% LSS 22051 IF %disableootpatch%==1 IF %abi%==x86 IF %toolchain%==msvc echo.
@IF %intmesaver% GEQ 22003 IF %intmesaver% LSS 22051 IF %disableootpatch%==1 IF %abi%==x86 IF %toolchain%==msvc GOTO skipmesa
@IF %disableootpatch%==1 GOTO configmesabuild

@REM Collect information about Mesa3D code. Apply out of tree patches.

@rem Enable S3TC texture cache
@IF %intmesaver% NEQ 23200 IF %intmesaver% NEQ 23201 IF %intmesaver% NEQ 23202 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" s3tc

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

@rem Fix llvmpipe build on ARM64
@IF %intmesaver% LSS 23100 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" mcjit-arm64

@rem Fix lavapipe crash when built with MinGW
@IF %intmesaver:~0,3% EQU 211 IF %intmesaver% LSS 21151 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" lavapipe-mingw-crashfix

@rem Fix lavapipe build with MSVC 32-bit
@IF %intmesaver:~0,3% EQU 211 IF %intmesaver% LSS 21151 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" lavapipe-32-bit-msvc-buildfix

@rem Fix dozen build with clang
@IF %intmesaver% LSS 22356 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" dzn-clang

@rem Fix radv MinGW build
@IF %intmesaver% GEQ 21200 IF %intmesaver% LSS 21251 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" radv-mingw
@IF %intmesaver% GEQ 23100 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" addrlib-workaround-old-cpu-target

@rem Fix radv MSVC build with LLVM 13
@IF %intmesaver:~0,3% EQU 213 IF %intmesaver% LSS 21306 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" radv-msvc-llvm13
@IF %intmesaver:~0,3% EQU 212 IF %intmesaver% LSS 21256 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" radv-msvc-llvm13-2

@rem Fix vulkan util build with MSVC 32-bit
@IF %intmesaver% GEQ 21301 IF %intmesaver% LSS 21303 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" vulkan-core-msvc-32-bit

@rem Fix d3d10sw MSVC build
@IF %intmesaver% GEQ 21200 IF %intmesaver% LSS 22000 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" d3d10sw
@IF %intmesaver% GEQ 21300 IF %intmesaver% LSS 22000 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" d3d10sw-2
@IF %intmesaver% GEQ 23300 IF %intmesaver% LSS 23354 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" d3d10sw-3

@rem Clover build on Windows
@rem IF %intmesaver% GEQ 21300 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" clover

@rem Fix OpenCL stack link with LLVM targets
@IF %intmesaver% GEQ 21300 IF %intmesaver% LSS 22203 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" mclc-all-targets
@IF %intmesaver:~0,3% EQU 213 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" clover-all-targets

@rem Link clang like LLVM
@IF %intmesaver% LSS 22252 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" link-clang-like-llvm

@rem Fix link with LLVM and Clang 15
@IF %intmesaver% LSS 22352 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" fix-llvm-clang15-link

@rem Fix Microsoft CLC runtime compilation with LLVM and clang 15
@IF %intmesaver% LSS 23050 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" mclc-clang15

@rem Fix Microsoft CLC build with LLVM and clang 16
@IF %intmesaver% LSS 23104 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" mclc-clang16

@rem LLVM+clang 17 linking compatibility
@IF %intmesaver% LSS 23300 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" clover_llvm-move-to-modern-pass-manager

@rem LLVM+clang 18 linking compatibility
@IF %intmesaver% LSS 24055 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" mclc-llvm+clang18

@rem Fix vaon12 filename
@IF %intmesaver% LSS 23200 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" vaon12-strip-lib-prefix

@rem Fix vaon12 build regression on 24.3 with MinGW
@IF %intmesaver:~0,3% EQU 243 IF %intmesaver% LSS 24352 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" va-include-missing-header

:configmesabuild
@rem Configure Mesa build.
@set buildconf=%mesonloc% setup
@if EXIST "build\%toolchain%-%abi%\" call "%devroot%\%projectname%\bin\modules\prompt.cmd" cleanmesabld "Perform clean build (y/n):"
@if NOT EXIST "build\%toolchain%-%abi%\" set cleanmesabld=y
@if EXIST "build\%toolchain%-%abi%\" IF /I "%cleanmesabld%"=="y" RD /S /Q build\%toolchain%-%abi%
@IF /I NOT "%cleanmesabld%"=="y" set buildconf=%mesonloc% configure

@call "%devroot%\%projectname%\bin\modules\prompt.cmd" experimental "Enable experimental/non-production ready components (y/n):"

@call "%devroot%\%projectname%\buildscript\modules\useninja.cmd"
@set buildconf=%buildconf% build/%toolchain%-%abi% --libdir="lib/%abi%" --bindir="bin/%abi%" --pkgconfig.relocatable

@IF %intmesaver% GEQ 21200 IF %intmesaver% LSS 22100 set buildconf=%buildconf% -Dc_std=c17
@IF %intmesaver% GEQ 22000 set RTTI=true

@IF %toolchain%==msvc set buildconf=%buildconf% --prefix="%devroot:\=/%/%projectname%" -Db_vscrt=mt -Dzlib:default_library=static
@IF %toolchain%==msvc IF %intmesaver% GEQ 21200 IF %intmesaver% LSS 22100 set buildconf=%buildconf% -Dcpp_std=vc++latest
@IF %toolchain%==msvc set CFLAGS=

@rem Use default stability and security cflags and ldflags from MSYS2 makeppkg-mingw tool configuration - https://github.com/msys2/MSYS2-packages/blob/master/pacman/makepkg_mingw.conf
@IF NOT %toolchain%==msvc set CFLAGS=-pipe -Wp,-D_FORTIFY_SOURCE^=2 -fstack-protector-strong -Wp,-D__USE_MINGW_ANSI_STDIO^=1
@IF NOT %toolchain%==msvc IF %abi%==arm64 set CFLAGS=%CFLAGS% -march^=armv8-a
@IF NOT %toolchain%==msvc IF NOT %abi%==arm64 set CFLAGS=%CFLAGS% -march^=core2
@IF NOT %toolchain%==msvc set LDFLAGS=
@IF NOT %toolchain%==msvc IF %abi%==x86 set LDFLAGS=%LDFLAGS% -Wl,--no-seh -Wl,--large-address-aware
@IF NOT %toolchain%==msvc set buildcmd=%runmsys% /%LMSYSTEM%/bin/ninja -C "%devroot%\mesa\build\%toolchain%-%abi%" -j %throttle% -k 0

@if /I "%useninja%"=="y" set buildconf=%buildconf% --backend=ninja
@if /I "%useninja%"=="y" IF %toolchain%==msvc set buildcmd=ninja -C "%devroot%\mesa\build\%toolchain%-%abi%" -j %throttle% -k 0

@if /I NOT "%useninja%"=="y" set buildconf=%buildconf% --backend=vs
@if /I NOT "%useninja%"=="y" set buildcmd=msbuild mesa.sln /m^:%throttle% /v^:m

@rem Add flags tracking PKG_CONFIG search PATH adjustment needs
@set PKG_CONFIG_LIBCLC=0
@set PKG_CONFIG_SPV=0
@set "PKG_CONFIG_PATH="

@if %cimode% EQU 0 set usezstd=n
@IF %intmesaver% GTR 20000 call "%devroot%\%projectname%\bin\modules\prompt.cmd" usezstd "Use ZSTD compression (y/n):"
@IF /I "%usezstd%"=="y" set buildconf=%buildconf% -Dzstd=%mesonbooltrue%
@IF %intmesaver% GTR 20000 IF /I NOT "%usezstd%"=="y" set buildconf=%buildconf% -Dzstd=%mesonboolfalse%

@if %cimode% EQU 0 set mesadbgbld=n
@if %cimode% EQU 0 set mesadbgoptim=n
@if %cimode% EQU 0 set nodebugprintf=n
@IF %toolchain%==msvc call "%devroot%\%projectname%\bin\modules\prompt.cmd" mesadbgbld "Debug friendly binaries (require a lot of RAM) (y/n):"
@IF NOT %toolchain%==msvc call "%devroot%\%projectname%\bin\modules\prompt.cmd" mesadbgbld "Debug friendly binaries (y/n):"
@if /I NOT "%mesadbgbld%"=="y" set buildconf=%buildconf% --buildtype=release
@if /I NOT "%mesadbgbld%"=="y" IF NOT %toolchain%==msvc set LDFLAGS=%LDFLAGS% -s
@if /I "%mesadbgbld%"=="y" call "%devroot%\%projectname%\bin\modules\prompt.cmd" mesadbgoptim "Optimize debug binaries (y/n):"
@if /I "%mesadbgbld%"=="y" if /I NOT "%mesadbgoptim%"=="y" set buildconf=%buildconf% --buildtype=debug
@if /I "%mesadbgoptim%"=="y" IF NOT %toolchain%==msvc set buildconf=%buildconf% --buildtype=debugoptimized
@if /I "%mesadbgoptim%"=="y" IF %toolchain%==msvc set buildconf=%buildconf% -Ddebug=true -Doptimization=3
@rem Keep MSVC debug printf enabled until we find another way to disable it without relying on Meson undefined behavior. Behavior changed unexpectedly in Meson 1.8.0 breaking debug info activation. 25.0.5 is first affected release
@rem if /I "%mesadbgoptim%"=="y" IF %toolchain%==msvc call "%devroot%\%projectname%\bin\modules\prompt.cmd" nodebugprintf "Disable debug printf (y/n):"
@if /I "%nodebugprintf%"=="y" set buildconf=%buildconf:~0,-17% --buildtype=release

@if %cimode% EQU 0 set mesaenableasserts=n
@call "%devroot%\%projectname%\bin\modules\prompt.cmd" mesaenableasserts "Enable asserts (y/n):"
@if /I "%mesaenableasserts%"=="y" set buildconf=%buildconf% -Db_ndebug=false
@if /I NOT "%mesaenableasserts%"=="y" set buildconf=%buildconf% -Db_ndebug=true
@if /I NOT "%mesaenableasserts%"=="y" IF %toolchain%==msvc set CFLAGS=%CFLAGS% /wd4189

@if %cimode% EQU 0 set linkmingwdynamic=n
@IF NOT %toolchain%==msvc call "%devroot%\%projectname%\bin\modules\prompt.cmd" linkmingwdynamic "Link dependencies dynamically for debuggging purposes (y/n):"
@IF NOT %toolchain%==msvc IF /I NOT "%linkmingwdynamic%"=="y" set LDFLAGS=%LDFLAGS% -static
@IF NOT %toolchain%==msvc IF /I NOT "%linkmingwdynamic%"=="y" set buildconf=%buildconf% --prefer-static

@set havellvm=1
@set llvmmethod=configtool
@IF %toolchain%==msvc IF NOT EXIST "%llvminstloc%\%abi%\lib\" set havellvm=0
@IF %toolchain%==msvc IF NOT EXIST "%llvminstloc%\%abi%\bin\llvm-config.exe" IF %cmakestate% EQU 0 set havellvm=0
@IF %toolchain%==msvc IF NOT EXIST "%llvminstloc%\%abi%\bin\llvm-config.exe" IF %cmakestate% GTR 0 set llvmmethod=cmake

@rem Workaround https://github.com/pal1000/mesa-dist-win/issues/156 - disable LLVM for GCC static build
@IF %toolchain%==gcc IF /I NOT "%linkmingwdynamic%"=="y" set havellvm=0

@if %cimode% EQU 0 set llvmless=n
@if %havellvm%==0 set llvmless=y
@if %havellvm%==1 call "%devroot%\%projectname%\bin\modules\prompt.cmd" llvmless "Build Mesa without LLVM (y/n). llvmpipe, swr, RADV, lavapipe and all OpenCL drivers won't be available and high performance JIT won't be available for softpipe, osmesa and graw:"
@call "%devroot%\%projectname%\buildscript\modules\mesonsubprojects.cmd"
@IF NOT %toolchain%==msvc set buildconf=%buildconf% --force-fallback-for=
@IF "%vksdkselect%"=="1" IF %toolchain%==clang set buildconf=%buildconf%vulkan,
@if /I NOT "%llvmless%"=="y" IF %llvmconfigbusted% EQU 1 set buildconf=%buildconf%llvm,
@if "%buildconf:~-1%"=="," set buildconf=%buildconf:~0,-1%
@if /I NOT "%llvmless%"=="y" IF %intmesaver% GEQ 22000 IF %intmesaver% LSS 22200 IF NOT %toolchain%==msvc set RTTI=%LLVMRTTI%
@IF %intmesaver% GEQ 22000 set buildconf=%buildconf% -Dcpp_rtti=%RTTI%
@if /I NOT "%llvmless%"=="y" set buildconf=%buildconf% -Dllvm=%mesonbooltrue%
@if /I NOT "%llvmless%"=="y" IF /I NOT "%linkmingwdynamic%"=="y" set buildconf=%buildconf% -Dshared-llvm=%mesonboolfalse%
@if /I NOT "%llvmless%"=="y" IF /I "%linkmingwdynamic%"=="y" set buildconf=%buildconf% -Dshared-llvm=%mesonbooltrue%
@if /I NOT "%llvmless%"=="y" IF %llvmmethod%==cmake set buildconf=%buildconf% --cmake-prefix-path="%llvminstloc:\=/%/%abi%"
@if /I NOT "%llvmless%"=="y" IF %llvmmethod%==cmake IF %cmakestate% EQU 1 SET PATH=%devroot%\cmake\bin\;%PATH%
@if /I NOT "%llvmless%"=="y" IF NOT %llvmmethod%==cmake set buildconf=%buildconf% --cmake-prefix-path=
@if /I NOT "%llvmless%"=="y" IF NOT %llvmmethod%==cmake IF %toolchain%==msvc if %llvmalreadyloaded% EQU 0 SET PATH=%llvminstloc%\%abi%\bin\;%PATH%
@if /I "%llvmless%"=="y" set buildconf=%buildconf% -Dllvm=%mesonboolfalse%

@set galliumcount=0
@set msysregex=0
@if NOT %toolchain%==msvc IF %intmesaver% GEQ 21300 set msysregex=1

@set canglswrast=1
@IF %abi%==arm64 if /I NOT "%llvmless%"=="y" IF %disableootpatch%==1 set canglswrast=0
@if %cimode% EQU 0 set glswrast=n
@if /I NOT "%llvmless%"=="y" IF %canglswrast% EQU 1 call "%devroot%\%projectname%\bin\modules\prompt.cmd" glswrast "Do you want to build Mesa3D softpipe and llvmpipe drivers (y/n):"
@if /I "%llvmless%"=="y" call "%devroot%\%projectname%\bin\modules\prompt.cmd" glswrast "Do you want to build Mesa3D softpipe driver (y/n):"
@if /I "%glswrast%"=="y" set /a galliumcount+=1
@if /I NOT "%llvmless%"=="y" IF /I "%glswrast%"=="y" IF %intmesaver% GEQ 24200 IF /I "%experimental%"=="y" call "%devroot%\%projectname%\bin\modules\prompt.cmd" orcjit "Use orcjit with llvmpipe (experimental)(y/n):"
@IF /I "%orcjit%"=="y" set buildconf=%buildconf% -Dllvm-orcjit=true
@IF /I NOT "%orcjit%"=="y" IF %intmesaver% GEQ 24200 set buildconf=%buildconf% -Dllvm-orcjit=false

@if %cimode% EQU 0 set zink=n
@set canzink=0
@IF NOT %toolchain%==msvc IF %intmesaver% GEQ 21000 set canzink=1
@IF %toolchain%==msvc IF %intmesaver% GEQ 21200 set canzink=1
@IF %toolchain%==msvc IF %intmesaver% GEQ 21301 IF %intmesaver% LSS 21303 IF %abi%==x86 IF %disableootpatch%==1 set canzink=0
@IF %toolchain%==msvc IF NOT EXIST "%VK_SDK_PATH%" IF NOT EXIST "%VULKAN_SDK%" IF %intmesaver% LSS 22200 set canzink=0
@IF %canzink% EQU 1 call "%devroot%\%projectname%\bin\modules\prompt.cmd" zink "Do you want to build Mesa3D OpenGL driver over Vulkan - zink (y/n):"
@IF %toolchain%==msvc IF /I "%zink%"=="y" IF %intmesaver% LSS 22200 set LDFLAGS=-ldelayimp /DELAYLOAD^:vulkan-1.dll
@IF /I "%zink%"=="y" set /a galliumcount+=1

@rem Prerequisites for all Microsoft components in Mesa3D
@set canmcrdrvcom=1
@for /f delims^=^ eol^= %%a in ('dir /b /a:d "%devroot%\mesa\subprojects\DirectX-Header*" 2^>^&1') do @IF NOT EXIST "%devroot%\mesa\subprojects\%%~nxa\" IF %gitstate% EQU 0 set canmcrdrvcom=0
@IF %intmesaver% LSS 21000 set canmcrdrvcom=0
@IF NOT %toolchain%==msvc IF %intmesaver% LSS 22200 set canmcrdrvcom=0

@rem Building GLonD3D12 with MinGW requires Mesa 22.2.0-rc2 and up
@if %cimode% EQU 0 set d3d12=n
@set cand3d12=1
@IF %canmcrdrvcom% EQU 0 set cand3d12=0
@IF NOT %toolchain%==msvc IF %intmesaver% LSS 22202 set cand3d12=0
@IF %cand3d12% EQU 1 call "%devroot%\%projectname%\bin\modules\prompt.cmd" d3d12 "Do you want to build Mesa3D OpenGL driver over D3D12 - GLonD3D12 (y/n):"
@IF /I "%d3d12%"=="y" IF %intmesaver% LSS 24100 set gfxd3d12=y
@IF %intmesaver% GEQ 24100 set buildconf=%buildconf% -Dgallium-d3d12-graphics=auto
@IF /I "%d3d12%"=="y" IF %intmesaver% GEQ 24100 call "%devroot%\%projectname%\bin\modules\prompt.cmd" gfxd3d12 "Enable d3d12 graphics pipeline (y=default/n):"
@IF /I "%gfxd3d12%"=="n" set buildconf=%buildconf:~0,-4%%mesonboolfalse%
@IF /I "%d3d12%"=="y" IF /I NOT "%gfxd3d12%"=="n" set /a galliumcount+=1

@if %cimode% EQU 0 set swrdrv=n
@set canswr=0
@if /I NOT "%llvmless%"=="y" if %abi%==x64 IF %disableootpatch%==0 IF EXIST "%devroot%\mesa\src\gallium\drivers\swr\meson.build" if /I "%glswrast%"=="y" set canswr=1
@if %canswr% EQU 1 call "%devroot%\%projectname%\bin\modules\prompt.cmd" swrdrv "Do you want to build swr drivers? (y=yes):"
@if /I "%swrdrv%"=="y" set buildconf=%buildconf% -Dswr-arches=avx,avx2,skx,knl
@if /I "%swrdrv%"=="y" set /a galliumcount+=1

@set buildconf=%buildconf% -Dgallium-drivers=
@IF /I "%glswrast%"=="y" IF %intmesaver% LSS 24200 set buildconf=%buildconf%swrast,
@IF /I "%glswrast%"=="y" IF %intmesaver% GEQ 24200 set buildconf=%buildconf%softpipe,
@IF /I "%glswrast%"=="y" IF %intmesaver% GEQ 24200 if /I NOT "%llvmless%"=="y" set buildconf=%buildconf%llvmpipe,
@IF /I "%zink%"=="y" set buildconf=%buildconf%zink,
@IF /I "%d3d12%"=="y" set buildconf=%buildconf%d3d12,
@if /I "%swrdrv%"=="y" set buildconf=%buildconf%swr,
@IF "%buildconf:~-1%"=="," set buildconf=%buildconf:~0,-1%

@set mesavkcount=0

@if %cimode% EQU 0 set lavapipe=n
@set canlavapipe=1
@if /I "%llvmless%"=="y" set canlavapipe=0
@IF %intmesaver% LSS 21100 set canlavapipe=0
@if /I NOT "%glswrast%"=="y" set canlavapipe=0
@IF %intmesaver:~0,3% EQU 211 IF %intmesaver% LSS 21151 IF %toolchain%==msvc if %abi%==x86 IF %disableootpatch%==1 set canlavapipe=0
@IF %toolchain%==msvc IF %intmesaver% GEQ 21301 IF %intmesaver% LSS 21303 IF %abi%==x86 IF %disableootpatch%==1 set canlavapipe=0
@IF %toolchain%==msvc IF NOT EXIST "%VK_SDK_PATH%" IF NOT EXIST "%VULKAN_SDK%" IF %intmesaver% GEQ 25000 set canlavapipe=0
@IF %canlavapipe% EQU 1 call "%devroot%\%projectname%\bin\modules\prompt.cmd" lavapipe "Build Mesa3D Vulkan software renderer (y/n):"
@if NOT %toolchain%==msvc if /I "%lavapipe%"=="y" set msysregex=1
@if /I "%lavapipe%"=="y" set /a mesavkcount+=1

@if %cimode% EQU 0 set radv=n
@set canradv=1
@if /I "%llvmless%"=="y" set canradv=0
@IF %intmesaver% LSS 21200 set canradv=0
@IF %abi%==x86 IF %intmesaver% LSS 22000 set canradv=0
@IF %toolchain%==msvc IF NOT EXIST "%llvminstloc%\%abi%\lib\LLVMAMDGPU*.lib" set canradv=0
@IF %toolchain%==msvc IF NOT EXIST "%devroot%\mesa\subprojects\libelf-lfg-win32\" IF %gitstate% EQU 0 set canradv=0
@IF %toolchain%==msvc IF %disableootpatch%==1 IF %intmesaver% LSS 21256 set canradv=0
@IF %toolchain%==msvc IF %disableootpatch%==1 IF %intmesaver% GEQ 21300 IF %intmesaver% LSS 21306 set canradv=0
@IF %toolchain%==msvc IF NOT EXIST "%VK_SDK_PATH%" IF NOT EXIST "%VULKAN_SDK%" IF %intmesaver% GEQ 22200 set canradv=0
@IF NOT %toolchain%==msvc IF %disableootpatch%==1 IF %intmesaver% LSS 21251 set canradv=0
@rem Only enable RADV under experimental mode, see https://github.com/pal1000/mesa-dist-win/issues/103
@IF /I NOT "%experimental%"=="y" set canradv=0
@IF %canradv% EQU 1 call "%devroot%\%projectname%\bin\modules\prompt.cmd" radv "Build AMD Vulkan driver - radv (y/n):"
@IF NOT %toolchain%==msvc if /I "%radv%"=="y" set msysregex=1
@if /I "%radv%"=="y" set /a mesavkcount+=1

@set candzn=0
@IF %canmcrdrvcom% EQU 1 IF %intmesaver% GEQ 22100 set candzn=1
@IF /I "%useclang%"=="y" IF %disableootpatch%==1 IF %intmesaver% LSS 23000 set candzn=0
@IF %candzn% EQU 1 call "%devroot%\%projectname%\bin\modules\prompt.cmd" dozenmsvk "Build Microsoft Dozen Vulkan driver (y/n):"
@if /I "%dozenmsvk%"=="y" set /a mesavkcount+=1

@set cangfxstream=1
@IF %intmesaver% LSS 25000 set cangfxstream=0
@IF %toolchain%==msvc set cangfxstream=0
@IF /I NOT "%experimental%"=="y" set cangfxstream=0
@IF %cangfxstream% EQU 1 call "%devroot%\%projectname%\bin\modules\prompt.cmd" gfxstream "Build VirtIO GfxStream Vulkan driver (y/n):"

@set buildconf=%buildconf% -Dvulkan-drivers=
@if /I "%lavapipe%"=="y" set buildconf=%buildconf%swrast,
@if /I "%radv%"=="y" set buildconf=%buildconf%amd,
@if /I "%dozenmsvk%"=="y" set buildconf=%buildconf%microsoft-experimental,
@if /I "%gfxstream%"=="y" set buildconf=%buildconf%gfxstream,
@IF %mesavkcount% GTR 0 set buildconf=%buildconf:~0,-1%
@IF %mesavkcount% GTR 0 IF %intmesaver% GEQ 24100 set buildconf=%buildconf% -Dvulkan-icd-dir="bin/%abi%"

@IF %msysregex%==1 IF %disableootpatch% EQU 1 IF /I NOT "%linkmingwdynamic%"=="y" set LDFLAGS=%LDFLAGS% -ltre -lintl -liconv

@if %cimode% EQU 0 set d3d10umd=n
@set cand3d10umd=1
@IF %intmesaver% LSS 21200 set cand3d10umd=0
@if /I NOT "%glswrast%"=="y" set cand3d10umd=0
@IF NOT %toolchain%==msvc set cand3d10umd=0
@IF %intmesaver% LSS 22000 IF %disableootpatch% EQU 1 set cand3d10umd=0
@IF %intmesaver% GEQ 23300 IF %intmesaver% LSS 23354 IF %disableootpatch% EQU 1 set cand3d10umd=0
@IF %cand3d10umd% EQU 1 for /f delims^=^ eol^= %%a in ('@call "%devroot%\%projectname%\buildscript\modules\wdkcheck.cmd"') do @IF NOT "%%a"=="OK" set cand3d10umd=0
@IF %cand3d10umd% EQU 1 call "%devroot%\%projectname%\bin\modules\prompt.cmd" d3d10umd "Build Mesa3D D3D10 software renderer (y/n):"
@if /I "%d3d10umd%"=="y" set buildconf=%buildconf% -Dgallium-d3d10umd=true
@if /I "%d3d10umd%"=="y" IF %intmesaver% GEQ 24100 set buildconf=%buildconf% -Dgallium-d3d10-dll-name=d3d10warp
@if /I NOT "%d3d10umd%"=="y" IF %intmesaver% GEQ 21200 set buildconf=%buildconf% -Dgallium-d3d10umd=false

@if %cimode% EQU 0 set spirvtodxil=n
@if /I "%dozenmsvk%"=="y" set spirvtodxil=y
@IF %canmcrdrvcom% EQU 1 if /I NOT "%dozenmsvk%"=="y" call "%devroot%\%projectname%\bin\modules\prompt.cmd" spirvtodxil "Do you want to build SPIR-V to DXIL tool (y/n):"
@IF /I "%spirvtodxil%"=="y" set buildconf=%buildconf% -Dspirv-to-dxil=true
@IF /I NOT "%spirvtodxil%"=="y" IF %intmesaver% GEQ 21000 set buildconf=%buildconf% -Dspirv-to-dxil=false

@if %cimode% EQU 0 set gles=n
@set cangles=1
@IF %galliumcount% EQU 0 set cangles=0

@rem Workaround https://gitlab.freedesktop.org/mesa/mesa/-/issues/12573 by disabling EGL and GLES
@IF %intmesaver:~0,3% EQU 250 IF %toolchain%==gcc set cangles=0

@IF %intmesaver% LSS 21300 IF %cangles% EQU 1 call "%devroot%\%projectname%\bin\modules\prompt.cmd" gles "Do you want to build GLAPI as a shared library and standalone GLES drivers (y/n):"
@IF %intmesaver% GEQ 21300 IF %cangles% EQU 1 call "%devroot%\%projectname%\bin\modules\prompt.cmd" gles "Do you want to build standalone GLES drivers (y/n):"
@if /I "%gles%"=="y" set buildconf=%buildconf% -Dgles1=%mesonbooltrue% -Dgles2=%mesonbooltrue%
@if /I "%gles%"=="y" IF %intmesaver% GEQ 21300 set buildconf=%buildconf% -Degl=%mesonbooltrue%
@if /I "%gles%"=="y" IF %intmesaver% LSS 25100 set buildconf=%buildconf% -Dshared-glapi=%mesonbooltrue%
@if /I NOT "%gles%"=="y" set buildconf=%buildconf% -Dgles1=%mesonboolfalse% -Dgles2=%mesonboolfalse%
@if /I NOT "%gles%"=="y" IF %intmesaver% GEQ 21300 set buildconf=%buildconf% -Degl=%mesonboolfalse%
@if /I NOT "%gles%"=="y" IF %intmesaver% LSS 25100 set buildconf=%buildconf% -Dshared-glapi=auto
@if /I NOT "%gles%"=="y" IF %intmesaver% GEQ 21300 IF %intmesaver% LSS 25100 IF %cangles% EQU 1 set buildconf=%buildconf:~0,-4%%mesonbooltrue%

@if %cimode% EQU 0 set osmesa=n
@set canosmesa=1
@if /I NOT "%glswrast%"=="y" if /I NOT "%swrdrv%"=="y" set canosmesa=0
@IF %intmesaver% GEQ 25100 set canosmesa=0
@if %canosmesa% EQU 1 IF %intmesaver% LSS 21000 call "%devroot%\%projectname%\bin\modules\prompt.cmd" osmesa "Do you want to build off-screen rendering drivers (y/n):"
@if %canosmesa% EQU 1 IF %intmesaver% GEQ 21000 call "%devroot%\%projectname%\bin\modules\prompt.cmd" osmesa "Do you want to build off-screen rendering driver (y/n):"
@rem osmesa classic is gone in Mesa 21.0 and newer
@rem osmesa is gone in 25.1
@IF /I "%osmesa%"=="y" IF %intmesaver% GEQ 21000 set buildconf=%buildconf% -Dosmesa=true
@IF /I "%osmesa%"=="y" IF %intmesaver% LSS 21000 set buildconf=%buildconf% -Dosmesa=gallium,classic
@rem Building both osmesa gallium and classic requires out of tree patches
@IF /I "%osmesa%"=="y" IF %intmesaver% LSS 21000 IF %toolchain%==msvc IF %disableootpatch%==1 set buildconf=%buildconf:~0,-8%
@rem Disable osmesa classic when building with Meson and Mingw toolchains due to build failure
@IF /I "%osmesa%"=="y" IF %intmesaver% LSS 21000 IF NOT %toolchain%==msvc set buildconf=%buildconf:~0,-8%
@rem Explicitly disable osmesa when asked, for incremental build consistency
@IF /I NOT "%osmesa%"=="y" IF %intmesaver% LSS 21000 set buildconf=%buildconf% -Dosmesa=
@IF /I NOT "%osmesa%"=="y" IF %intmesaver% GEQ 21000 IF %intmesaver% LSS 25100 set buildconf=%buildconf% -Dosmesa=false

@rem Basic OpenCL requirements: Mesa 21.0+, LLVM and libclc
@set canopencl=1
@IF %intmesaver% LSS 21000 set canopencl=0
@if /I "%llvmless%"=="y" set canopencl=0
@IF NOT %toolchain%==msvc IF %intmesaver% LSS 22200 set canopencl=0
@IF NOT %toolchain%==msvc IF NOT EXIST "%msysloc%\%LMSYSTEM%\share\clc\*.spv" set canopencl=0
@IF %toolchain%==msvc IF NOT EXIST "%llvminstloc%\clc\share\pkgconfig\" set canopencl=0

@rem OpenCL SPIR-V requirements: basic OpenCL support + Clang, SPIRV LLVM translator, SPIRV tools
@set canclspv=1
@IF %canopencl% EQU 0 set canclspv=0
@IF %toolchain%==msvc IF NOT EXIST "%llvminstloc%\%abi%\lib\clang*.lib" set canclspv=0
@IF %toolchain%==msvc IF NOT EXIST "%llvminstloc%\spv-%abi%\lib\pkgconfig\" set canclspv=0
@IF %toolchain%==msvc IF NOT EXIST "%devroot%\spirv-tools\build\%abi%\lib\pkgconfig\" set canclspv=0
@IF %toolchain%==msvc IF %disableootpatch%==1 IF %intmesaver% LSS 23050 IF EXIST "%llvminstloc%\%abi%\lib\clang\" for /f tokens^=1^ delims^=.^ eol^= %%a IN ('dir /B /A:D "%llvminstloc%\%abi%\lib\clang\"') DO @IF %%a GEQ 15 set canclspv=0
@IF NOT %toolchain%==msvc IF %disableootpatch%==1 IF %intmesaver% LSS 23050 IF EXIST "%msysloc%\%LMSYSTEM%\lib\clang\" for /f tokens^=1^ delims^=.^ eol^= %%a IN ('dir /B /A:D "%msysloc%\%LMSYSTEM%\lib\clang\"') DO @IF %%a GEQ 15 set canclspv=0
@IF %toolchain%==msvc IF EXIST "%llvminstloc%\%abi%\lib\clang\" for /f tokens^=1^ delims^=.^ eol^= %%a IN ('dir /B /A:D "%llvminstloc%\%abi%\lib\clang\"') DO @IF %disableootpatch%==1 IF %intmesaver% LSS 23104 IF %%a GEQ 16 set canclspv=0
@IF NOT %toolchain%==msvc IF EXIST "%msysloc%\%LMSYSTEM%\lib\clang\" for /f tokens^=1^ delims^=.^ eol^= %%a IN ('dir /B /A:D "%msysloc%\%LMSYSTEM%\lib\clang\"') DO @IF %disableootpatch%==1 IF %intmesaver% LSS 23104 IF %%a GEQ 16 set canclspv=0
@IF %toolchain%==msvc IF EXIST "%llvminstloc%\%abi%\lib\clang\" for /f tokens^=1^ delims^=.^ eol^= %%a IN ('dir /B /A:D "%llvminstloc%\%abi%\lib\clang\"') DO @IF %disableootpatch%==1 IF %intmesaver% LSS 24055 IF %%a GEQ 18 set canclspv=0
@IF NOT %toolchain%==msvc IF EXIST "%msysloc%\%LMSYSTEM%\lib\clang\" for /f tokens^=1^ delims^=.^ eol^= %%a IN ('dir /B /A:D "%msysloc%\%LMSYSTEM%\lib\clang\"') DO @IF %disableootpatch%==1 IF %intmesaver% LSS 24055 IF %%a GEQ 18 set canclspv=0

@rem Microsoft OpenCL compiler requires OpenCL SPIR-V, DirectX Headers and out of tree patches [21.3-22.2]
@set canmclc=0
@IF %canclspv% EQU 1 IF %canmcrdrvcom% EQU 1 set canmclc=1
@IF %disableootpatch%==1 IF %intmesaver% GEQ 21300 IF %intmesaver% LSS 22203 set canmclc=0
@IF %canmclc% EQU 1 call "%devroot%\%projectname%\bin\modules\prompt.cmd" mclc "Build Mesa3D Microsoft OpenCL compiler (y/n):"
@IF /I "%mclc%"=="y" set PKG_CONFIG_LIBCLC=1
@IF /I "%mclc%"=="y" set PKG_CONFIG_SPV=1
@IF /I "%mclc%"=="y" set buildconf=%buildconf% -Dmicrosoft-clc=%mesonbooltrue%
@IF /I "%mclc%"=="y" IF %toolchain%==msvc IF EXIST "%llvminstloc%\%abi%\lib\clang\" for /f tokens^=1^ delims^=.^ eol^= %%a IN ('dir /B /A:D "%llvminstloc%\%abi%\lib\clang\"') DO @IF %%a GEQ 18 IF %intmesaver% LSS 25100 set CFLAGS=%CFLAGS% /Zc^:preprocessor
@IF /I NOT "%mclc%"=="y" IF %intmesaver% GEQ 21000 set buildconf=%buildconf% -Dmicrosoft-clc=%mesonboolfalse%

@rem Build clover
@rem Clover requirements: basic OpenCL support, Mesa 21.3 source code or newer, LLVM build with RTTI [Mesa 22.1 and older], gallium swrast and out of tree patches on 21.3.
@rem Enabled under experimental mode only as it doesn't work - https://github.com/pal1000/mesa-dist-win/issues/88
@set canclover=1
@IF /I NOT "%experimental%"=="y" set canclover=0
@IF %canopencl% EQU 0 set canclover=0
@IF %intmesaver% LSS 21300 set canclover=0
@IF %intmesaver% GEQ 25200 set canclover=0
@IF %RTTI%==false set canclover=0
@if /I NOT "%glswrast%"=="y" set canclover=0
@IF %intmesaver:~0,3% EQU 213 IF %disableootpatch%==1 set canclover=0
@if %canclover% EQU 1 call "%devroot%\%projectname%\bin\modules\prompt.cmd" buildclover "Build OpenCL clover driver (y/n):"
@IF /I NOT "%buildclover%"=="y" IF %intmesaver% LSS 25200 set buildconf=%buildconf% -Dgallium-opencl=%mesonboolfalse%
@IF /I "%buildclover%"=="y" set PKG_CONFIG_LIBCLC=1
@IF /I "%buildclover%"=="y" call "%devroot%\%projectname%\bin\modules\prompt.cmd" icdclover "Build clover in ICD format (y/n):"
@IF /I "%icdclover%"=="y" set buildconf=%buildconf% -Dgallium-opencl=icd
@IF /I "%buildclover%"=="y" IF /I NOT "%icdclover%"=="y" set buildconf=%buildconf% -Dgallium-opencl=standalone
@IF /I "%buildclover%"=="y" IF %canclspv% EQU 1 IF %intmesaver% LSS 25000 call "%devroot%\%projectname%\bin\modules\prompt.cmd" cloverspv "Build clover with SPIR-V binary support (y/n):"
@IF /I "%cloverspv%"=="y" set PKG_CONFIG_SPV=1
@IF /I "%cloverspv%"=="y" set buildconf=%buildconf% -Dopencl-spirv=true
@IF /I "%buildclover%"=="y" IF /I NOT "%cloverspv%"=="y" IF %intmesaver% LSS 25000 set buildconf=%buildconf% -Dopencl-spirv=false
@IF /I "%buildclover%"=="y" IF %intmesaver% LSS 22300 set buildconf=%buildconf% -Dopencl-native=false
@IF /I "%buildclover%"=="y" IF %intmesaver% GEQ 22100 IF %intmesaver% LSS 22300 set buildconf=%buildconf% -Dcpp_std=c++20

@IF %PKG_CONFIG_SPV% EQU 1 IF %intmesaver% GEQ 23200 IF %intmesaver% LSS 24100 IF /I NOT "%linkmingwdynamic%"=="y" set buildconf=%buildconf% -Dopencl-external-clang-headers=disabled

@rem Build VA-API D3D12 driver
@set canvaapi=0
@IF /I "%d3d12%"=="y" IF %intmesaver% GEQ 22300 set canvaapi=1
@IF %toolchain%==msvc IF NOT EXIST "%devroot%\libva\build\%abi%\lib\pkgconfig\" set canvaapi=0
@IF %canvaapi% EQU 1 call "%devroot%\%projectname%\bin\modules\prompt.cmd" buildvaapi "Build Mesa3D VA-API interface (y/n):"
@IF /I "%buildvaapi%"=="y" set buildconf=%buildconf% -Dgallium-va=%mesonbooltrue%
@IF /I NOT "%buildvaapi%"=="y" set buildconf=%buildconf% -Dgallium-va=%mesonboolfalse%
@IF %intmesaver% GEQ 22200 set buildconf=%buildconf% -Dgallium-d3d12-video=auto -Dvideo-codecs=
@IF %intmesaver% GEQ 24000 set buildconf=%buildconf%all_free

@rem Configure video acceleration codecs
@set canvideoaccel=0
@IF /I "%buildvaapi%"=="y" IF %intmesaver% GEQ 22200 set canvideoaccel=1
@IF %mesavkcount% GTR 0 IF %intmesaver% GEQ 22200 set canvideoaccel=1
@IF %canvideoaccel% EQU 1 call "%devroot%\%projectname%\bin\modules\prompt.cmd" buildpatentedcodecs "Build Mesa3D video acceleration patented codecs (y/n):"
@IF /I "%buildpatentedcodecs%"=="y" IF %intmesaver% LSS 24000 set buildconf=%buildconf%h264dec,h264enc,h265dec,h265enc,vc1dec
@IF /I "%buildpatentedcodecs%"=="y" IF %intmesaver% GEQ 24000 set buildconf=%buildconf:~0,-5%

@IF %intmesaver% GEQ 25200 set buildconf=%buildconf% -Dmediafoundation-codecs=all -Dmediafoundation-store-dll=false
@IF /I "%buildpatentedcodecs%"=="y" IF %intmesaver% GEQ 25200 IF /I "%d3d12%"=="y" call "%devroot%\%projectname%\bin\modules\prompt.cmd" buildmftcodecs "Build Microsoft Foundation Transform codecs (y/n):"
@if /I "%buildmftcodecs%"=="y" set buildconf=%buildconf% -Dgallium-mediafoundation=%mesonbooltrue%
@IF %intmesaver% GEQ 25200 if /I NOT "%buildmftcodecs%"=="y" set buildconf=%buildconf% -Dgallium-mediafoundation=%mesonboolfalse%

@rem Apply PKG_CONFIG search PATH adjustments on MSVC
@IF %PKG_CONFIG_LIBCLC% EQU 1 set buildconf=%buildconf% -Dstatic-libclc=all
@IF %PKG_CONFIG_LIBCLC% EQU 1 IF %toolchain%==msvc set PKG_CONFIG_PATH=%PKG_CONFIG_PATH%%llvminstloc:\=/%/clc/share/pkgconfig;
@IF %PKG_CONFIG_SPV% EQU 1 IF %toolchain%==msvc set PKG_CONFIG_PATH=%PKG_CONFIG_PATH%%llvminstloc:\=/%/spv-%abi%/lib/pkgconfig;%devroot:\=/%/spirv-tools/build/%abi%/lib/pkgconfig;
@IF /I "%buildvaapi%"=="y" IF %toolchain%==msvc set PKG_CONFIG_PATH=%PKG_CONFIG_PATH%%devroot:\=/%/libva/build/%abi%/lib/pkgconfig;
@IF /I "%usezstd%"=="y" IF %toolchain%==msvc set PKG_CONFIG_PATH=%PKG_CONFIG_PATH%%devroot:\=/%/zstd/zstd/%abi%/lib/pkgconfig;
@IF NOT defined PKG_CONFIG_PATH set PKG_CONFIG_PATH=;
@set buildconf=%buildconf% --pkg-config-path="%PKG_CONFIG_PATH:~0,-1%"
@set "PKG_CONFIG_LIBCLC="
@set "PKG_CONFIG_SPV="
@set "PKG_CONFIG_PATH="

@if %cimode% EQU 0 set mesatests=n
@set canmesatests=1
@IF %disableootpatch%==1 IF %intmesaver% GEQ 20100 IF %intmesaver% LSS 20103 IF NOT %toolchain%==msvc set canmesatests=0
@IF %canmesatests% EQU 1 IF %intmesaver% LSS 22300 call "%devroot%\%projectname%\bin\modules\prompt.cmd" mesatests "Do you want to build unit tests and gallium raw interface (y/n):"
@IF %canmesatests% EQU 1 IF %intmesaver% GEQ 22300 IF %intmesaver% LSS 24153 call "%devroot%\%projectname%\bin\modules\prompt.cmd" mesatests "Do you want to build unit tests (y/n):"
@IF %canmesatests% EQU 1 IF %intmesaver% GEQ 24153 call "%devroot%\%projectname%\bin\modules\prompt.cmd" mesatests "Do you want to build unit tests and dynamic pipe loader (y/n):"
@if /I NOT "%mesatests%"=="y" set buildconf=%buildconf% -Dbuild-tests=false
@if /I "%mesatests%"=="y" set buildconf=%buildconf% -Dbuild-tests=true
@set buildconf=%buildconf% -Dbuild-aco-tests=false
@if /I "%radv%"=="y" if /I "%mesatests%"=="y" set buildconf=%buildconf:~0,-5%true
@IF %intmesaver% GEQ 25100 set buildconf=%buildconf% -Dbuild-radv-tests=false
@IF %intmesaver% GEQ 25100 if /I "%radv%"=="y" if /I "%mesatests%"=="y" set buildconf=%buildconf:~0,-5%true
@IF %intmesaver% GEQ 25200 set buildconf=%buildconf% -Dgallium-mediafoundation-test=false
@if /I "%buildmftcodecs%"=="y" if /I "%mesatests%"=="y" set buildconf=%buildconf:~0,-5%true

@rem Workaround https://gitlab.freedesktop.org/mesa/mesa/-/issues/11462, see
@rem https://github.com/mpv-player/mpv/pull/15325/files
@rem https://developercommunity.visualstudio.com/t/NAN-is-no-longer-compile-time-constant-i/10688907
@if /I "%mesatests%"=="y" IF %toolchain%==msvc if /I NOT "%llvmless%"=="y" IF /I "%glswrast%"=="y" set CFLAGS=%CFLAGS% -D_UCRT_NOISY_NAN

@rem Pass additional compiler and linker flags
@if defined CFLAGS IF %toolchain%==msvc set CFLAGS=%CFLAGS:~1%
@if defined CFLAGS set buildconf=%buildconf% -Dc_args="%CFLAGS%" -Dcpp_args="%CFLAGS%"
@if defined LDFLAGS IF NOT %toolchain%==msvc set LDFLAGS=%LDFLAGS:~1%
@if defined LDFLAGS set buildconf=%buildconf% -Dc_link_args="%LDFLAGS%" -Dcpp_link_args="%LDFLAGS%"

@rem Control futex support - https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/17431
@IF %intmesaver% GEQ 22200 call "%devroot%\%projectname%\bin\modules\prompt.cmd" winfutex "Enable Futex (https://en.wikipedia.org/wiki/Futex) support, raises minimum requirements for Mesa3D overall to run to Windows 8/Server 2012 (y/n):"
@IF /I NOT "%winfutex%"=="y" IF %intmesaver% GEQ 22200 set buildconf=%buildconf% -Dmin-windows-version=7
@IF /I "%winfutex%"=="y" set buildconf=%buildconf% -Dmin-windows-version=8

@rem Disable draw with LLVM if LLVM native module ends being unused but needed
@rem workaround for https://gitlab.freedesktop.org/mesa/mesa/-/issues/6817
@rem Fixed in 22.2.0
@IF %intmesaver% GEQ 21100 if /I NOT "%llvmless%"=="y" set buildconf=%buildconf% -Ddraw-use-llvm=true
@IF %intmesaver% GEQ 21100 IF %intmesaver% LSS 22250 if /I NOT "%llvmless%"=="y" if /I NOT "%glswrast%"=="y" if /I NOT "%radv%"=="y" if /I NOT "%mesatests%"=="y" IF %galliumcount% GTR 0 set buildconf=%buildconf:~0,-4%false

@rem Also when using LLVM>=15, out of tree patches disabled and not building OpenCL
@rem workaround for https://gitlab.freedesktop.org/mesa/mesa/-/issues/7487
@rem Fix queued for 22.3.2
@IF %intmesaver% GEQ 21100 if /I NOT "%llvmless%"=="y" if "%buildconf:~-4%"=="true" IF %disableootpatch%==1 IF %intmesaver% LSS 22352 IF /I NOT "%buildclover%"=="y" IF /I NOT "%mclc%"=="y" IF %toolchain%==msvc IF EXIST "%llvminstloc%\%abi%\lib\cmake\llvm\LLVMConfig.cmake" FOR /F tokens^=^1^,2^ eol^= %%a IN ('type "%llvminstloc%\%abi%\lib\cmake\llvm\LLVMConfig.cmake"') DO @IF "%%a"=="set(LLVM_PACKAGE_VERSION" FOR /F tokens^=^1^ delims^=^.^ eol^= %%c IN ("%%b") DO @if %%c GEQ 15 set buildconf=%buildconf:~0,-4%false

@IF %intmesaver% GEQ 21100 if /I NOT "%llvmless%"=="y" if "%buildconf:~-4%"=="true" IF %disableootpatch%==1 IF %intmesaver% LSS 22352 IF /I NOT "%buildclover%"=="y" IF /I NOT "%mclc%"=="y" IF NOT %toolchain%==msvc IF EXIST "%msysloc%\%LMSYSTEM%\lib\cmake\llvm\LLVMConfig.cmake" FOR /F tokens^=^1^,2^ eol^= %%a IN ('type "%msysloc%\%LMSYSTEM%\lib\cmake\llvm\LLVMConfig.cmake"') DO @IF "%%a"=="set(LLVM_PACKAGE_VERSION" FOR /F tokens^=^1^ delims^=^.^ eol^= %%c IN ("%%b") DO @if %%c GEQ 15 set buildconf=%buildconf:~0,-4%false

@rem Load MSVC specific build dependencies
@IF %toolchain%==msvc IF %flexstate%==1 set PATH=%flexloc%\;%PATH%
@IF %toolchain%==msvc set PATH=%pkgconfigloc%\;%PATH%
@IF /I "%usezstd%"=="y" IF %toolchain%==msvc set PATH=%devroot%\zstd\zstd\%hostabi%\bin\;%PATH%

:build_mesa
@rem Generate dummy header for MSVC build when git is missing.
@IF %toolchain%==msvc if NOT EXIST "build\" md build
@IF %toolchain%==msvc if NOT EXIST "build\%toolchain%-%abi%\" md build\%toolchain%-%abi%
@IF %toolchain%==msvc if NOT EXIST "build\%toolchain%-%abi%\src\" md build\%toolchain%-%abi%\src
@IF %toolchain%==msvc if NOT EXIST build\%toolchain%-%abi%\src\git_sha1.h echo 0 > build\%toolchain%-%abi%\src\git_sha1.h

@rem Load MSVC environment if used.
@IF %toolchain%==msvc echo.
@IF %toolchain%==msvc call %vsenv% %vsabi%
@IF %toolchain%==msvc cd "%devroot%\mesa"
@IF %toolchain%==msvc echo.

@rem Execute build configuration.
@echo Build configuration command: %buildconf%
@IF %toolchain%==msvc echo %buildconf% >"%devroot%\%projectname%\buildinfo\%toolchain%-%abi%.txt"
@IF NOT %toolchain%==msvc if /I NOT "%mesadbgbld%"=="y" echo %buildconf% >"%devroot%\%projectname%\buildinfo\release-%toolchain%-%abi%.txt"
@IF NOT %toolchain%==msvc if /I "%mesadbgbld%"=="y" echo %buildconf% >"%devroot%\%projectname%\buildinfo\debug-%toolchain%-%abi%.txt"
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
@call "%devroot%\%projectname%\buildscript\modules\trybuild.cmd" %buildcmd%
@if /I NOT "%useninja%"=="y" cd ..\..\

:skipmesa
@rem Reset environment.
@endlocal
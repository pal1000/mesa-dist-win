@setlocal

@rem Check lf LLVM sources are available or obtainable
@set llvmsources=1
@if NOT EXIST "%devroot%\llvm\cmake\" if NOT EXIST "%devroot%\llvm-project\" IF %gitstate EQU 0 set llvmsources=0

@rem Ask to configure LLVM build
@IF %llvmsources% EQU 1 IF %cmakestate% GTR 0 set /p cfgllvmbuild=Generate LLVM build configuration command (y/n):
@IF %llvmsources% EQU 1 IF %cmakestate% GTR 0 echo.
@IF %llvmsources% EQU 0 IF %cmakestate% GTR 0 IF EXIST "%llvminstloc%\%abi%\lib\" set /p cfgllvmbuild=Generate LLVM build configuration command (y/n):
@IF %llvmsources% EQU 0 IF %cmakestate% GTR 0 IF EXIST "%llvminstloc%\%abi%\lib\" echo.
@if /I NOT "%cfgllvmbuild%"=="y" GOTO skipllvm

@rem Get/update LLVM source code
@set updllvmsrcver=18.1.1
@if /I "%legacyllvm%"=="y" set updllvmsrcver=17.0.6
@set llvmsrcver=0
@set llvmsrcloc="%devroot%\llvm-project\llvm\CMakeLists.txt"
@if NOT EXIST %llvmsrcloc% set llvmsrcloc="%devroot%\llvm\CMakeLists.txt"
@if NOT EXIST %llvmsrcloc% set llvmsrcloc=null
@if NOT %llvmsrcloc%==null for /f tokens^=2^ delims^=^(^)^ eol^= %%a IN ('type %llvmsrcloc%') DO @for /f tokens^=1^,2^ eol^= %%b IN ("%%a") DO @(
@IF /I "%%b"=="LLVM_VERSION_MAJOR" set /a llvmsrcver+=%%c*100
@IF /I "%%b"=="LLVM_VERSION_MINOR" set /a llvmsrcver+=%%c*10
@IF /I "%%b"=="LLVM_VERSION_PATCH" set /a llvmsrcver+=%%c
)
@IF %gitstate% GTR 0 if NOT %llvmsrcver%==%updllvmsrcver:.=% (
@if EXIST "%devroot%\llvm-project\" echo Updating LLVM source code...
@if NOT EXIST "%devroot%\llvm-project\" MD "%devroot%\llvm-project"
@if EXIST "%devroot%\llvm-project\.git\" RD /S /Q "%devroot%\llvm-project\.git"
@CD "%devroot%\llvm-project"
@git init
@git config --local core.autocrlf false
@git remote add origin https://github.com/llvm/llvm-project.git
@git fetch --depth=1 origin llvmorg-%updllvmsrcver%
@git checkout -f FETCH_HEAD
@git clean -df
@echo.
)

@rem Apply is_trivially_copyable patch
@if NOT EXIST "%devroot%\llvm-project\" cd "%devroot%\"
@if EXIST "%devroot%\llvm-project\" cd "%devroot%\llvm-project"

@rem Uncomment next line if still using LLVM<11 and build goes on fire
@rem IF %disableootpatch%==0 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" llvm-vs-16_7
@IF %disableootpatch%==1 if EXIST "%msysloc%\usr\bin\patch.exe" echo Reverting out of tree patches...
@IF %disableootpatch%==1 IF EXIST "%msysloc%\usr\bin\patch.exe" %runmsys% patch -Np1 --no-backup-if-mismatch -R -r - -i "%devroot%\%projectname%\patches\llvm-vs-16_7.patch"
@IF %disableootpatch%==1 if EXIST "%msysloc%\usr\bin\patch.exe" echo.

@rem Ask for Ninja use if exists. Load it if opted for it.
@call "%devroot%\%projectname%\buildscript\modules\useninja.cmd"

@rem AMDGPU target (disabled, see https://github.com/pal1000/mesa-dist-win/issues/103)
@rem set /p amdgpu=Build AMDGPU target - required by RADV (y/n):
@rem echo.

@rem Clang
@if EXIST "%devroot%\llvm-project\" set /p buildclang=Build clang - required for OpenCL (y/n):
@if EXIST "%devroot%\llvm-project\" echo.

@rem Load cmake into build environment.
@if %cmakestate%==1 set PATH=%devroot%\cmake\bin\;%PATH%

@rem Construct build configuration command.
@set buildconf=cmake -G
@if /I NOT "%useninja%"=="y" set buildconf=%buildconf% "Visual Studio %toolset%"
@if %abi%==x86 if /I NOT "%useninja%"=="y" set buildconf=%buildconf% -A Win32
@if %abi%==x64 if /I NOT "%useninja%"=="y" set buildconf=%buildconf% -A x64
@if %abi%==aarch64 if /I NOT "%useninja%"=="y" set buildconf=%buildconf% -A ARM64
@if /I NOT "%useninja%"=="y" IF /I %PROCESSOR_ARCHITECTURE%==AMD64 set buildconf=%buildconf% -Thost=x64
@if /I "%useninja%"=="y" set buildconf=%buildconf%Ninja
@set buildconf=%buildconf% -DCMAKE_BUILD_TYPE=Release
@if %llvmsrcver% LSS 1700 set buildconf=%buildconf% -DLLVM_USE_CRT_RELEASE=MT
@if %llvmsrcver% GEQ 1700 set buildconf=%buildconf% -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded
@if EXIST "%devroot%\llvm-project\" IF /I NOT "%buildclang%"=="y" set buildconf=%buildconf% -DLLVM_ENABLE_PROJECTS=""
@IF /I "%buildclang%"=="y" set buildconf=%buildconf% -DLLVM_ENABLE_PROJECTS="clang"
@set buildconf=%buildconf% -DLLVM_TARGETS_TO_BUILD=
@IF /I "%amdgpu%"=="y" set buildconf=%buildconf%AMDGPU;
@set buildconf=%buildconf%X86 -DLLVM_OPTIMIZED_TABLEGEN=TRUE -DLLVM_INCLUDE_UTILS=OFF -DLLVM_INCLUDE_RUNTIMES=OFF -DLLVM_INCLUDE_TESTS=OFF -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_INCLUDE_BENCHMARKS=OFF -DLLVM_BUILD_LLVM_C_DYLIB=OFF -DLLVM_ENABLE_DIA_SDK=OFF
@if EXIST "%devroot%\llvm-project\" IF /I NOT "%buildclang%"=="y" set buildconf=%buildconf% -DLLVM_BUILD_TOOLS=OFF
@IF /I "%buildclang%"=="y" set buildconf=%buildconf% -DCLANG_BUILD_TOOLS=ON
@set buildconf=%buildconf% -DLLVM_ENABLE_RTTI=ON -DLLVM_ENABLE_TERMINFO=OFF

@if NOT EXIST "%devroot%\llvm-project\" echo LLVM build configuration command^: %buildconf% -DCMAKE_INSTALL_PREFIX="%llvminstloc%\%abi%" "%devroot%\llvm"
@if EXIST "%devroot%\llvm-project\" echo LLVM build configuration command^: %buildconf% -DCMAKE_INSTALL_PREFIX="%llvminstloc%\%abi%" "%devroot%\llvm-project\llvm"
@echo.

@rem Ask to do LLVM build
@if EXIST "%devroot%\llvm-project\" set /p buildllvm=Begin LLVM build (y/n):
@if EXIST "%devroot%\llvm-project\" echo.
@if NOT EXIST "%devroot%\llvm-project\" if EXIST "%devroot%\llvm\cmake\" set /p buildllvm=Begin LLVM build (y/n):
@if NOT EXIST "%devroot%\llvm-project\" if EXIST "%devroot%\llvm\cmake\" echo.
@IF /I NOT "%buildllvm%"=="y" GOTO skipllvm

@rem Always clean build
@echo Cleanning LLVM build. Please wait...
@echo.
@if EXIST "%llvminstloc%\%abi%\" RD /S /Q "%llvminstloc%\%abi%"
@if NOT EXIST "%devroot%\llvm-project\" cd "%devroot%\llvm"
@if EXIST "%devroot%\llvm-project\" cd "%devroot%\llvm-project"
@if EXIST "build\buildsys-%abi%\" RD /S /Q build\buildsys-%abi%
@if NOT EXIST "build\" MD build
@cd build
@if NOT EXIST "buildsys-%abi%\" md buildsys-%abi%
@cd buildsys-%abi%
@pause
@echo.

@rem Load Visual Studio environment. Can only be loaded in the background when using MsBuild.
@if /I "%useninja%"=="y" call %vsenv% %vsabi%
@if /I "%useninja%"=="y" if NOT EXIST "%devroot%\llvm-project\" cd "%devroot%\llvm\build\buildsys-%abi%"
@if /I "%useninja%"=="y" if EXIST "%devroot%\llvm-project\" cd "%devroot%\llvm-project\build\buildsys-%abi%"
@if /I "%useninja%"=="y" echo.

@rem Configure and execute the build with the configuration made above.
@if NOT EXIST "%devroot%\llvm-project\" %buildconf% -DCMAKE_INSTALL_PREFIX="%llvminstloc%\%abi%" "%devroot%\llvm"
@if EXIST "%devroot%\llvm-project\" %buildconf% -DCMAKE_INSTALL_PREFIX="%llvminstloc%\%abi%" "%devroot%\llvm-project\llvm"
@echo.
@pause
@echo.
@For /f "tokens=1-3 delims=/ " %%a in ('date /t') do @For /f "tokens=1-2 delims=/:" %%d in ('time /t') do @echo Build started at %%a-%%b-%%c_%%d%%e.
@if /I NOT "%useninja%"=="y" cmake --build . -j %throttle% --config Release --target install
@if /I NOT "%useninja%"=="y" IF /I NOT "%buildclang%"=="y" cmake --build . -j %throttle% --config Release --target llvm-config
@if /I NOT "%useninja%"=="y" IF /I NOT "%buildclang%"=="y" copy .\Release\bin\llvm-config.exe "%llvminstloc%\%abi%\bin\"
@if /I "%useninja%"=="y" ninja -j %throttle% install
@if /I "%useninja%"=="y" IF /I NOT "%buildclang%"=="y" ninja -j %throttle% llvm-config
@if /I "%useninja%"=="y" IF /I NOT "%buildclang%"=="y" copy .\bin\llvm-config.exe "%llvminstloc%\%abi%\bin\"
@For /f "tokens=1-3 delims=/ " %%a in ('date /t') do @For /f "tokens=1-2 delims=/:" %%d in ('time /t') do @echo Build finished at %%a-%%b-%%c_%%d%%e.
@echo.

@rem Avoid race condition in SPIRV LLVM translator sources checkout.
@pause
@echo.

:skipllvm
@IF %llvmsources% EQU 0 echo WARNING: LLVM source code not found and it couldn't be obtained.
@IF %cmakestate% EQU 0 echo WARNING: LLVM requires CMake to build.
@IF NOT EXIST "%llvminstloc%\%abi%\lib\" echo WARNING: LLVM binaries not found. If you want to build Mesa3D anyway it will be without llvmpipe, swr, RADV, lavapipe and all OpenCL drivers and high performance JIT won't be available for softpipe, osmesa and graw.
@IF %llvmsources% EQU 0 echo.
@IF %llvmsources% EQU 1 IF %cmakestate% EQU 0 echo.
@IF %llvmsources% EQU 1 IF %cmakestate% GTR 0 IF NOT EXIST "%llvminstloc%\%abi%\lib\" echo.
@IF EXIST "%llvminstloc%\%abi%\lib\cmake\llvm\LLVMConfig.cmake" if /I "%cfgllvmbuild%"=="y" call "%devroot%\%projectname%\buildscript\modules\llvmspv.cmd"

@rem Reset environment after LLVM build.
@endlocal
@cd "%devroot%\"
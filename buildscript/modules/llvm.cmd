@setlocal

@rem Check lf LLVM sources are available or obtainable
@set llvmsources=1
@if NOT EXIST "%devroot%\llvm\cmake\" if NOT EXIST "%devroot%\llvm-project\" IF %gitstate EQU 0 set llvmsources=0

@rem Ask to configure LLVM build
@IF %llvmsources% EQU 1 IF %cmakestate% GTR 0 set /p cfgllvmbuild=Generate LLVM build configuration command (y/n):
@IF %llvmsources% EQU 1 IF %cmakestate% GTR 0 echo.
@if /I NOT "%cfgllvmbuild%"=="y" GOTO skipllvm

@rem Get/update LLVM source code
@if NOT EXIST "%devroot%\llvm\cmake\" if NOT EXIST "%devroot%\llvm-project\" set updllvmsrc=y
@if EXIST "%devroot%\llvm-project\" set /p updllvmsrc=Update LLVM source code (y/n):
@if EXIST "%devroot%\llvm-project\" echo.
@if /I "%updllvmsrc%"=="y" if EXIST "%devroot%\llvm-project\" echo Updating LLVM source code...
@if /I "%updllvmsrc%"=="y" (
@if NOT EXIST "%devroot%\llvm-project\" MD "%devroot%\llvm-project"
@if EXIST "%devroot%\llvm-project\.git\" RD /S /Q "%devroot%\llvm-project\.git"
@CD "%devroot%\llvm-project"
@git init
@git config --local core.autocrlf false
@git remote add origin https://github.com/llvm/llvm-project.git
@git fetch --depth=1 origin llvmorg-14.0.6
@git checkout -f FETCH_HEAD
)

@rem Apply is_trivially_copyable patch
@if NOT EXIST "%devroot%\llvm-project\" cd "%devroot%"
@if NOT EXIST "%devroot%\llvm-project\" set msyspatchdir=%devroot%
@if EXIST "%devroot%\llvm-project\" cd "%devroot%\llvm-project"
@if EXIST "%devroot%\llvm-project\" set msyspatchdir=%devroot%\llvm-project

@rem Uncomment next line if still using LLVM<11 and build goes on fire
@rem IF %disableootpatch%==0 call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" llvm-vs-16_7
@IF %disableootpatch%==1 if EXIST "%msysloc%\usr\bin\patch.exe" echo Reverting out of tree patches...
@IF %disableootpatch%==1 IF EXIST "%msysloc%\usr\bin\patch.exe" %runmsys% cd "%msyspatchdir%";patch -Np1 --no-backup-if-mismatch -R -r - -i "%devroot%\%projectname%\patches\llvm-vs-16_7.patch"
@IF %disableootpatch%==1 if EXIST "%msysloc%\usr\bin\patch.exe" echo.

@rem Ask for Ninja use if exists. Load it if opted for it.
@set ninja=n
@if NOT %ninjastate%==0 set /p ninja=Use Ninja build system instead of MsBuild (y/n); less storage device strain, faster and more efficient build:
@if NOT %ninjastate%==0 echo.
@if /I "%ninja%"=="y" if %ninjastate%==1 set PATH=%devroot%\ninja\;%PATH%

@rem AMDGPU target (disabled, see https://github.com/pal1000/mesa-dist-win/issues/103)
@rem set /p amdgpu=Build AMDGPU target - required by RADV (y/n):
@rem echo.

@rem Clang and LLD
@if EXIST "%devroot%\llvm-project\" set /p buildclang=Build clang and LLD - required for OpenCL (y/n):
@if EXIST "%devroot%\llvm-project\" echo.

@rem Load cmake into build environment.
@if %cmakestate%==1 set PATH=%devroot%\cmake\bin\;%PATH%

@rem Construct build configuration command.
@set buildconf=cmake "%devroot%\llvm
@if EXIST "%devroot%\llvm-project\" set buildconf=%buildconf%-project\llvm
@set buildconf=%buildconf%" -G
@if /I NOT "%ninja%"=="y" set buildconf=%buildconf% "Visual Studio %toolset%"
@if %abi%==x86 if /I NOT "%ninja%"=="y" set buildconf=%buildconf% -A Win32
@if %abi%==x64 if /I NOT "%ninja%"=="y" set buildconf=%buildconf% -A x64
@if /I NOT "%ninja%"=="y" IF /I %PROCESSOR_ARCHITECTURE%==AMD64 set buildconf=%buildconf% -Thost=x64
@if /I "%ninja%"=="y" set buildconf=%buildconf%Ninja
@set buildconf=%buildconf% -DCMAKE_BUILD_TYPE=Release -DLLVM_USE_CRT_RELEASE=MT
@if EXIST "%devroot%\llvm-project\" IF /I NOT "%buildclang%"=="y" set buildconf=%buildconf% -DLLVM_ENABLE_PROJECTS=""
@IF /I "%buildclang%"=="y" set buildconf=%buildconf% -DLLVM_ENABLE_PROJECTS="clang;lld"
@set buildconf=%buildconf% -DLLVM_TARGETS_TO_BUILD=
@IF /I "%amdgpu%"=="y" set buildconf=%buildconf%AMDGPU;
@set buildconf=%buildconf%X86 -DLLVM_OPTIMIZED_TABLEGEN=TRUE -DLLVM_INCLUDE_UTILS=OFF -DLLVM_INCLUDE_RUNTIMES=OFF -DLLVM_INCLUDE_TESTS=OFF -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_INCLUDE_GO_TESTS=OFF -DLLVM_INCLUDE_BENCHMARKS=OFF -DLLVM_BUILD_LLVM_C_DYLIB=OFF -DLLVM_ENABLE_DIA_SDK=OFF
@if EXIST "%devroot%\llvm-project\" IF /I NOT "%buildclang%"=="y" set buildconf=%buildconf% -DLLVM_BUILD_TOOLS=OFF
@IF /I "%buildclang%"=="y" set buildconf=%buildconf% -DCLANG_BUILD_TOOLS=ON
@set buildconf=%buildconf% -DLLVM_ENABLE_RTTI=ON -DLLVM_ENABLE_TERMINFO=OFF

@echo LLVM build configuration command^: %buildconf% -DCMAKE_INSTALL_PREFIX="%devroot%\llvm\build\%abi%"
@echo.

@rem Ask to do LLVM build
@set /p buildllvm=Begin LLVM build (y/n):
@echo.
@IF /I NOT "%buildllvm%"=="y" GOTO skipllvm

@rem Always clean build and remove LLVM SPIRV translator
@echo Cleanning LLVM build. Please wait...
@echo.
@if EXIST "%devroot%\llvm-project\llvm\projects\SPIRV-LLVM-Translator\" RD /S /Q "%devroot%\llvm-project\llvm\projects\SPIRV-LLVM-Translator"
@if EXIST "%devroot%\llvm-project\llvm\projects\SPIRV-Headers\" RD /S /Q "%devroot%\llvm-project\llvm\projects\SPIRV-Headers"
@if EXIST "%devroot%\llvm\build\%abi%\" RD /S /Q "%devroot%\llvm\build\%abi%"
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
@if /I "%ninja%"=="y" call %vsenv% %vsabi%
@if /I "%ninja%"=="y" if NOT EXIST "%devroot%\llvm-project\" cd "%devroot%\llvm\build\buildsys-%abi%"
@if /I "%ninja%"=="y" if EXIST "%devroot%\llvm-project\" cd "%devroot%\llvm-project\build\buildsys-%abi%"
@if /I "%ninja%"=="y" echo.

@rem Configure and execute the build with the configuration made above.
@%buildconf% -DCMAKE_INSTALL_PREFIX="%devroot%\llvm\build\%abi%"
@echo.
@pause
@echo.
@if /I NOT "%ninja%"=="y" cmake --build . -j %throttle% --config Release --target install
@if /I NOT "%ninja%"=="y" IF /I NOT "%buildclang%"=="y" cmake --build . -j %throttle% --config Release --target llvm-config
@if /I NOT "%ninja%"=="y" IF /I NOT "%buildclang%"=="y" copy .\Release\bin\llvm-config.exe "%devroot%\llvm\build\%abi%\bin\"
@if /I "%ninja%"=="y" ninja -j %throttle% install
@if /I "%ninja%"=="y" IF /I NOT "%buildclang%"=="y" ninja -j %throttle% llvm-config
@if /I "%ninja%"=="y" IF /I NOT "%buildclang%"=="y" copy .\bin\llvm-config.exe "%devroot%\llvm\build\%abi%\bin\"
@IF EXIST "%devroot%\llvm\build\%abi%\bin\llvm-config.exe" if NOT EXIST "%devroot%\llvm\build\%abi%\llvmconfig\" md "%devroot%\llvm\build\%abi%\llvmconfig"
@IF EXIST "%devroot%\llvm\build\%abi%\bin\llvm-config.exe" copy "%devroot%\llvm\build\%abi%\bin\llvm-config.exe" "%devroot%\llvm\build\%abi%\llvmconfig\"
@echo.

@rem Avoid race condition in LLVM SPIRV translator sources checkout.
@pause
@echo.

:skipllvm
@IF %llvmsources% EQU 0 echo WARNING: LLVM source code not found and it couldn't be obtained.
@IF %cmakestate% EQU 0 echo WARNING: LLVM requires CMake to build.
@IF NOT EXIST "%devroot%\llvm\build\%abi%\lib\" echo WARNING: LLVM binaries not found. If you want to build Mesa3D anyway it will be without llvmpipe, swr, RADV, lavapipe and all OpenCL drivers and high performance JIT won't be available for softpipe, osmesa and graw.
@IF %llvmsources% EQU 0 echo.
@IF %llvmsources% EQU 1 IF %cmakestate% EQU 0 echo.
@IF %llvmsources% EQU 1 IF %cmakestate% GTR 0 IF NOT EXIST "%devroot%\llvm\build\%abi%\lib\" echo.
@IF /I "%buildclang%"=="y" call "%devroot%\%projectname%\buildscript\modules\llvmspv.cmd"

@rem Reset environment after LLVM build.
@endlocal
@cd "%devroot%"
@setlocal

@rem Check lf LLVM binaries are available
@set llvmbinaries=0
@IF EXIST %devroot%\llvm\%abi%\bin IF EXIST %devroot%\llvm\%abi%\include IF EXIST %devroot%\llvm\%abi%\lib set llvmbinaries=1

@rem Check lf LLVM sources are available or obtainable
@set llvmsources=1
@if NOT EXIST %devroot%\llvm\cmake if NOT EXIST %devroot%\llvm-project IF %gitstate EQU 0 set llvmsources=0

@rem Verify if LLVM can be used.
@IF %llvmbinaries% EQU 1 IF %llvmsources% EQU 0 echo LLVM source code not found but LLVM is already built. Skipping LLVM build.
@IF %llvmbinaries% EQU 1 IF %llvmsources% EQU 0 GOTO skipllvm
@IF %cmakestate%==0 IF %llvmbinaries% EQU 1 echo CMake not found but LLVM is already built. Skipping LLVM build.
@IF %cmakestate%==0 IF %llvmbinaries% EQU 1 GOTO skipllvm
@IF %cmakestate%==0 echo CMake is required for LLVM build. If you want to build Mesa3D anyway it will be without llvmpipe and swr drivers and high performance JIT won't be available for other drivers and libraries.
@IF %cmakestate%==0 GOTO skipllvm
@IF %llvmbinaries% EQU 0 IF %llvmsources% EQU 0 echo WARNING: Both LLVM source code and binaries not found. If you want to build Mesa3D anyway it will be without llvmpipe and swr drivers and high performance JIT won't be available for other drivers and libraries.
@IF %llvmbinaries% EQU 0 IF %llvmsources% EQU 0 GOTO skipllvm

@rem Ask to do LLVM build
@set /p buildllvm=Begin LLVM build. Only needs to run once for each ABI and version. Proceed (y/n):
@echo.

@rem LLVM source is found or is obtainable, binaries not found and LLVM build is refused.
@IF %llvmsources% EQU 1 IF %llvmbinaries% EQU 0 if /I NOT "%buildllvm%"=="y" echo WARNING: Not building LLVM. If you want to build Mesa3D anyway it will be without swr and llvmpipe drivers and high performance JIT won't be available for other drivers and libraries.
@if /I NOT "%buildllvm%"=="y" GOTO skipllvm

@rem Getting LLVM monorepo if LLVM source is missing
@if NOT EXIST %devroot%\llvm\cmake if NOT EXIST %devroot%\llvm-project (
@echo Getting LLVM source code...
@git clone https://github.com/llvm/llvm-project.git --branch=llvmorg-11.0.1 --depth=1 %devroot%\llvm-project
@echo.
)

@rem Apply is_trivially_copyable patch
@if NOT EXIST %devroot%\llvm-project cd %devroot%
@if NOT EXIST %devroot%\llvm-project set msyspatchdir=%devroot%
@if EXIST %devroot%\llvm-project cd %devroot%\llvm-project
@if EXIST %devroot%\llvm-project set msyspatchdir=%devroot%\llvm-project

@rem Uncomment next line if still using LLVM<11 and build goes on fire
@rem IF %disableootpatch%==0 call %devroot%\%projectname%\buildscript\modules\applypatch.cmd llvm-vs-16_7
@IF %disableootpatch%==1 if EXIST %msysloc%\usr\bin\patch.exe echo Reverting out of tree patches...
@IF %disableootpatch%==1 IF EXIST %msysloc%\usr\bin\patch.exe %msysloc%\usr\bin\bash --login -c "cd $(/usr/bin/cygpath -m ${msyspatchdir});patch -Np1 --no-backup-if-mismatch -R -r - -i $(/usr/bin/cygpath -m ${devroot})/${projectname}/patches/llvm-vs-16_7.patch"
@IF %disableootpatch%==1 if EXIST %msysloc%\usr\bin\patch.exe echo.

@rem Always clean build
@if NOT EXIST %devroot%\llvm-project cd %devroot%\llvm
@if EXIST %devroot%\llvm-project cd %devroot%\llvm-project
@echo Cleanning LLVM build. Please wait...
@echo.
@if EXIST %devroot%\llvm\%abi% RD /S /Q %devroot%\llvm\%abi%
@if EXIST buildsys-%abi% RD /S /Q buildsys-%abi%
@md buildsys-%abi%
@cd buildsys-%abi%

@rem Ask for Ninja use if exists. Load it if opted for it.
@set ninja=n
@if NOT %ninjastate%==0 set /p ninja=Use Ninja build system instead of MsBuild (y/n); less storage device strain, faster and more efficient build:
@if NOT %ninjastate%==0 echo.
@if /I "%ninja%"=="y" if %ninjastate%==1 set PATH=%devroot%\ninja\;%PATH%

@rem Load cmake into build environment.
@if %cmakestate%==1 set PATH=%devroot%\cmake\bin\;%PATH%

@rem Construct build configuration command.
@set buildconf=cmake -G
@if /I NOT "%ninja%"=="y" set buildconf=%buildconf% "Visual Studio %toolset%"
@if %abi%==x86 if /I NOT "%ninja%"=="y" set buildconf=%buildconf% -A Win32
@if %abi%==x64 if /I NOT "%ninja%"=="y" set buildconf=%buildconf% -A x64
@if /I NOT "%ninja%"=="y" IF /I %PROCESSOR_ARCHITECTURE%==AMD64 set buildconf=%buildconf% -Thost=x64
@if /I "%ninja%"=="y" set buildconf=%buildconf% "Ninja"
@set buildconf=%buildconf% -DLLVM_TARGETS_TO_BUILD=X86 -DCMAKE_BUILD_TYPE=Release -DLLVM_USE_CRT_RELEASE=MT -DLLVM_ENABLE_RTTI=1 -DLLVM_ENABLE_TERMINFO=OFF -DLLVM_OPTIMIZED_TABLEGEN=TRUE -DLLVM_INCLUDE_UTILS=OFF -DLLVM_INCLUDE_RUNTIMES=OFF -DLLVM_INCLUDE_TESTS=OFF -DLLVM_INCLUDE_GO_TESTS=OFF -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_INCLUDE_BENCHMARKS=OFF -DLLVM_BUILD_LLVM_C_DYLIB=OFF -DLLVM_ENABLE_DIA_SDK=OFF -DCMAKE_INSTALL_PREFIX=../../llvm/%abi%
@if EXIST %devroot%\llvm-project set /p buildclang=Build clang - required for OpenCL (y/n):
@if EXIST %devroot%\llvm-project echo.
@if EXIST %devroot%\llvm-project IF /I NOT "%buildclang%"=="y" set buildconf=%buildconf% -DLLVM_ENABLE_PROJECTS=""
@IF /I "%buildclang%"=="y" set buildconf=%buildconf% -DLLVM_ENABLE_PROJECTS="clang;lld"
@set buildconf=%buildconf% ..
@if EXIST %devroot%\llvm-project set buildconf=%buildconf%/llvm

@rem Load Visual Studio environment. Can only be loaded in the background when using MsBuild.
@if /I "%ninja%"=="y" call %vsenv% %vsabi%
@if /I "%ninja%"=="y" if NOT EXIST %devroot%\llvm-project cd %devroot%\llvm\buildsys-%abi%
@if /I "%ninja%"=="y" if EXIST %devroot%\llvm-project cd %devroot%\llvm-project\buildsys-%abi%
@if /I "%ninja%"=="y" echo.

@rem Configure and execute the build with the configuration made above.
@echo LLVM build configuration command^: %buildconf%
@echo.
@%buildconf%
@echo.
@pause
@echo.
@if /I NOT "%ninja%"=="y" cmake --build . -j %throttle% --config Release --target install
@if /I "%ninja%"=="y" call %devroot%\%projectname%\buildscript\modules\ninjallvmbuild.cmd

:skipllvm
@echo.
@rem Reset environment after LLVM build.
@endlocal
@cd %devroot%
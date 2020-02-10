@setlocal
@rem Look for CMake build generator.
@IF %cmakestate%==0 IF EXIST %devroot%\llvm\%abi%\bin IF EXIST %devroot%\llvm\%abi%\include IF EXIST %devroot%\llvm\%abi%\lib echo CMake not found but LLVM is already built. Skipping LLVM build.
@IF %cmakestate%==0 IF EXIST %devroot%\llvm\%abi%\bin IF EXIST %devroot%\llvm\%abi%\include IF EXIST %devroot%\llvm\%abi%\lib GOTO skipllvm
@IF %cmakestate%==0 echo CMake is required for LLVM build. If you want to build Mesa3D anyway it will be without llvmpipe and swr drivers and high performance JIT won't be available for other drivers and libraries.
@IF %cmakestate%==0 GOTO skipllvm

@rem Look for LLVM source code and binaries.
@if NOT EXIST %devroot%\llvm echo WARNING: Both LLVM source code and binaries not found. If you want to build Mesa3D anyway it will be without llvmpipe and swr drivers and high performance JIT won't be available for other drivers and libraries.
@if NOT EXIST %devroot%\llvm GOTO skipllvm

@rem Ask to do LLVM build
@if EXIST %devroot%\llvm\cmake set /p buildllvm=Begin LLVM build. Only needs to run once for each ABI and version. Proceed (y/n):
@if EXIST %devroot%\llvm\cmake echo.

@rem LLVM source is found, binaries not found and LLVM build is refused.
@if /I NOT "%buildllvm%"=="y" if EXIST %devroot%\llvm\cmake IF NOT EXIST %devroot%\llvm\%abi%\include echo WARNING: Not building LLVM. If you want to build Mesa3D anyway it will be without swr and llvmpipe drivers and high performance JIT won't be available for other drivers and libraries.
@if /I NOT "%buildllvm%"=="y" GOTO skipllvm

@rem Always clean build
@cd %devroot%\llvm
@echo Cleanning LLVM build. Please wait...
@echo.
@if EXIST %abi% RD /S /Q %abi%
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
@set buildconf=%buildconf% -DLLVM_TARGETS_TO_BUILD=X86 -DCMAKE_BUILD_TYPE=Release -DLLVM_USE_CRT_RELEASE=MT -DLLVM_ENABLE_RTTI=1 -DLLVM_ENABLE_TERMINFO=OFF -DCMAKE_INSTALL_PREFIX=../%abi% ..

@rem Load Visual Studio environment. Can only be loaded in the background when using MsBuild.
@if /I "%ninja%"=="y" call %vsenv% %vsabi%
@if /I "%ninja%"=="y" cd %devroot%\llvm\buildsys-%abi%
@if /I "%ninja%"=="y" echo.

@rem Configure and execute the build with the configuration made above.
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
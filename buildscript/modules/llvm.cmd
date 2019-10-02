@rem Select MSVC CRT to use as quickly as possible even if LLVM can't be built as we need this information later.
@rem Currently using CRT MT, but it can be changed if necessary.
@IF %mesabldsys%==scons set llvmlink=MT
@set mesonver=0.00.0
@IF %mesabldsys%==meson FOR /F "tokens=* USEBACKQ" %%a IN (`%mesonloc% --version`) DO @set mesonver=%%~a
@IF %mesabldsys%==meson set llvmlink=MT
@IF %mesabldsys%==meson IF %mesonver:~0,1%==0 IF %mesonver:~2,-2% LSS 48 set llvmlink=MT
@echo Using CRT %llvmlink% Release...
@echo.

@rem Look for CMake build generator.
@IF %cmakestate%==0 IF EXIST %mesa%\llvm\%abi%-%llvmlink%\bin IF EXIST %mesa%\llvm\%abi%-%llvmlink%\include IF EXIST %mesa%\llvm\%abi%-%llvmlink%\lib echo CMake not found but LLVM is already built. Skipping LLVM build.
@IF %cmakestate%==0 IF EXIST %mesa%\llvm\%abi%-%llvmlink%\bin IF EXIST %mesa%\llvm\%abi%-%llvmlink%\include IF EXIST %mesa%\llvm\%abi%-%llvmlink%\lib GOTO skipllvm
@IF %cmakestate%==0 echo CMake is required for LLVM build. If you want to build Mesa3D anyway it will be without llvmpipe and swr drivers and high performance JIT won't be available for other drivers and libraries.
@IF %cmakestate%==0 GOTO skipllvm

@rem Look for LLVM source code and binaries.
@if NOT EXIST %mesa%\llvm echo WARNING: Both LLVM source code and binaries not found. If you want to build Mesa3D anyway it will be without llvmpipe and swr drivers and high performance JIT won't be available for other drivers and libraries.
@if NOT EXIST %mesa%\llvm GOTO skipllvm

@rem Ask to do LLVM build
@if EXIST %mesa%\llvm\cmake set /p buildllvm=Begin LLVM build. Only needs to run once for each ABI and version. Proceed (y/n):
@if EXIST %mesa%\llvm\cmake echo.

@rem LLVM source is found, binaries not found and LLVM build is refused.
@if /I NOT "%buildllvm%"=="y" if EXIST %mesa%\llvm\cmake IF NOT EXIST %mesa%\llvm\%abi%-%llvmlink%\include echo WARNING: Not building LLVM. If you want to build Mesa3D anyway it will be without swr and llvmpipe drivers and high performance JIT won't be available for other drivers and libraries.
@if /I NOT "%buildllvm%"=="y" GOTO skipllvm

@rem Always clean build
@cd %mesa%\llvm
@echo Cleanning LLVM build. Please wait...
@echo.
@if EXIST %abi%-%llvmlink% RD /S /Q %abi%-%llvmlink%
@if EXIST buildsys-%abi%-%llvmlink% RD /S /Q buildsys-%abi%-%llvmlink%
@md buildsys-%abi%-%llvmlink%
@cd buildsys-%abi%-%llvmlink%

@rem Ask for Ninja use if exists. Load it if opted for it.
@set ninja=n
@if NOT %ninjastate%==0 set /p ninja=Use Ninja build system instead of MsBuild (y/n); less storage device strain, faster and more efficient build:
@if NOT %ninjastate%==0 echo.
@if /I "%ninja%"=="y" if %ninjastate%==1 set PATH=%mesa%\ninja\;%PATH%

@rem Load cmake into build environment.
@if %cmakestate%==1 set PATH=%mesa%\cmake\bin\;%PATH%

@rem Construct build configuration command.
@set buildconf=cmake -G
@if /I NOT "%ninja%"=="y" set buildconf=%buildconf% "Visual Studio %toolset%"
@if %abi%==x64 if /I NOT "%ninja%"=="y" set buildconf=%buildconf% -A x64
@if /I NOT "%ninja%"=="y" IF /I %PROCESSOR_ARCHITECTURE%==AMD64 set buildconf=%buildconf% -Thost=x64
@if /I "%ninja%"=="y" set buildconf=%buildconf% "Ninja"
@set buildconf=%buildconf% -DLLVM_TARGETS_TO_BUILD=X86 -DCMAKE_BUILD_TYPE=Release -DLLVM_USE_CRT_RELEASE=%llvmlink% -DLLVM_ENABLE_RTTI=1 -DLLVM_ENABLE_TERMINFO=OFF -DCMAKE_INSTALL_PREFIX=../%abi%-%llvmlink% ..

@rem Load Visual Studio environment. Can only be loaded in the background when using MsBuild.
@if /I "%ninja%"=="y" call %vsenv% %vsabi%
@if /I "%ninja%"=="y" cd %mesa%\llvm\buildsys-%abi%-%llvmlink%
@if /I "%ninja%"=="y" echo.

@rem Configure and execute the build with the configuration made above.
@%buildconf%
@echo.
@pause
@echo.
@if /I NOT "%ninja%"=="y" cmake --build . -j %throttle% --config Release --target install
@if /I "%ninja%"=="y" call %mesa%\mesa-dist-win\buildscript\modules\ninjallvmbuild.cmd

:skipllvm
@echo.
@rem Reset PATH and current folder after LLVM build.
@set PATH=%oldpath%
@cd %mesa%
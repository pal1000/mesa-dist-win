@rem Backup PATH before LLVM build to easily keep environment clean.
@set oldpath=%PATH%

@rem Look for CMake build generator.
@IF %cmakestate%==0 (
@echo CMake is required for LLVM build.
@GOTO skipllvm
)

@rem LLVM build getting started.
@if NOT EXIST %mesa%\llvm echo WARNING: Both LLVM source code and binaries not found. If you want to build Mesa3D anyway it will be without swr and llvmpipe drivers and osmesa will run with performance penalty.
@if EXIST %mesa%\llvm\cmake set /p buildllvm=Begin LLVM build. Only needs to run once for each ABI and version. Proceed (y/n):
@if EXIST %mesa%\llvm\cmake echo.

@rem Select CRT to use. MT when using Python 2.7. MD when using Python 3 with Meson 0.48 and up.
@rem MT when using Python 3 with Meson 0.47 or older.
@IF %pythonver%==2 set llvmlink=MT
@set mesonver=0.00.0
@IF %pythonver% GEQ 3 FOR /F "tokens=* USEBACKQ" %%a IN (`%mesonloc% --version`) DO @set mesonver=%%~a
@IF %pythonver% GEQ 3 set llvmlink=MT
@IF %pythonver% GEQ 3 IF %mesonver:~0,1%==0 IF %mesonver:~2,-2% LSS 48 set llvmlink=MT
@echo Using CRT %llvmlink% Release...
@echo.

@rem Always clean build
@if /I NOT "%buildllvm%"=="y" if EXIST %mesa%\llvm\cmake IF NOT EXIST %mesa%\llvm\%abi%-%llvmlink% echo WARNING: Not building LLVM. If you want to build Mesa3D anyway it will be without swr and llvmpipe drivers and osmesa will run with performance penalty.
@if /I NOT "%buildllvm%"=="y" GOTO skipllvm
@cd %mesa%\llvm
@echo Cleanning LLVM build. Please wait...
@echo.
@if EXIST %abi%-%llvmlink% RD /S /Q %abi%-%llvmlink%
@if EXIST buildsys-%abi%-%llvmlink% RD /S /Q buildsys-%abi%-%llvmlink%
@md buildsys-%abi%-%llvmlink%
@cd buildsys-%abi%-%llvmlink%

@rem Ask for Ninja use if exists. Load it if opted for it.
@set ninja=n
@if NOT %ninjastate%==0 set /p ninja=Use Ninja build system instead of MsBuild (y/n); less storage device strain and maybe faster build:
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
@if /I "%ninja%"=="y" ninja -j %throttle% install-llvm-headers install-llvm-libraries install-llvm-config

:skipllvm
@echo.
@rem Reset PATH and current folder after LLVM build.
@set PATH=%oldpath%
@cd %mesa%
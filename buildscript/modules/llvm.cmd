@rem Look for build generators.
@IF %cmakestate%==0 IF %mesonstate%==0 (
@echo There is no build system generator suitable for LLVM build.
@GOTO skipllvm
)

@rem Disable Meson build for now.
@if NOT %mesonstate%==0 if %cmakestate%==0 (
@echo LLVM build: Meson build support is not implemented.
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
@IF %pythonver% GEQ 3 FOR /F "tokens=* USEBACKQ" %%p IN (`%mesonloc% --version`) DO @set mesonver=%%~p
@IF %pythonver% GEQ 3 set llvmlink=MT
@IF %pythonver% GEQ 3 IF %mesonver:~0,1%==0 IF %mesonver:~2,-2% LSS 48 set llvmlink=MT
@echo Using CRT %llvmlink% Release...
@echo.

@if /I NOT "%buildllvm%"=="y" if EXIST %mesa%\llvm\cmake IF NOT EXIST %mesa%\llvm\%abi%-%llvmlink% echo WARNING: Not building LLVM. If you want to build Mesa3D anyway it will be without swr and llvmpipe drivers and osmesa will run with performance penalty.
@if /I NOT "%buildllvm%"=="y" GOTO skipllvm
@cd %mesa%\llvm
@if EXIST %abi%-%llvmlink% RD /S /Q %abi%-%llvmlink%
@if EXIST buildsys-%abi%-%llvmlink% RD /S /Q buildsys-%abi%-%llvmlink%
@md buildsys-%abi%-%llvmlink%
@cd buildsys-%abi%-%llvmlink%
@set ninja=n
@set meson=n
@if NOT %mesonstate%==0 if %cmakestate%==0 set meson=y

@rem Ask for Ninja use if exists. Load it if opted for it.
@if NOT %ninjastate%==0 set /p ninja=Use Ninja build system instead of MsBuild (y/n); less storage device strain and maybe faster build:
@if NOT %ninjastate%==0 echo.
@if /I "%ninja%"=="y" if %ninjastate%==1 set PATH=%mesa%\ninja\;%PATH%

@rem Ask for Meson use if both CMake and Meson are present (commented out since Meson support is just stubbed for now).
@rem if NOT %mesonstate%==0 if NOT %cmakestate%==0 set /p meson=Use Meson build generator instead of CMake (y/n):
@rem if NOT %mesonstate%==0 if NOT %cmakestate%==0 echo.

@rem Load cmake into build environment if used.
@if /I NOT "%meson%"=="y" if %cmakestate%==1 set PATH=%mesa%\cmake\bin\;%PATH%

@rem Construct build configuration command based on choices made above.
@set buildconf=cmake -G
@if /I NOT "%meson%"=="y" if /I NOT "%ninja%"=="y" set buildconf=%buildconf% "Visual Studio %toolset%
@if /I NOT "%meson%"=="y" if NOT %abi%==x64 if /I NOT "%ninja%"=="y" set buildconf=%buildconf%"
@if /I NOT "%meson%"=="y" if %abi%==x64 if /I NOT "%ninja%"=="y" set buildconf=%buildconf% Win64"
@if /I NOT "%meson%"=="y" if /I NOT "%ninja%"=="y" IF /I %PROCESSOR_ARCHITECTURE%==AMD64 set buildconf=%buildconf% -Thost=x64
@if /I NOT "%meson%"=="y" if /I "%ninja%"=="y" set buildconf=%buildconf% "Ninja"
@if /I NOT "%meson%"=="y" set buildconf=%buildconf% -DLLVM_TARGETS_TO_BUILD=X86 -DCMAKE_BUILD_TYPE=Release -DLLVM_USE_CRT_RELEASE=%llvmlink% -DLLVM_ENABLE_RTTI=1 -DLLVM_ENABLE_TERMINFO=OFF -DCMAKE_INSTALL_PREFIX=../%abi%-%llvmlink% ..
@if /I "%meson%"=="y" set buildconf=echo LLVM Build aborted. Unimplemented build configuration.

@rem Load Visual Studio environment. Only cmake can load it in the background and only when using MsBuild.
@if /I NOT "%meson%"=="y" if /I "%ninja%"=="y" call %vsenv% %vsabi%
@if /I NOT "%meson%"=="y" if /I "%ninja%"=="y" cd %mesa%\llvm\buildsys-%abi%-%llvmlink%
@if /I "%meson%"=="y" call %vsenv% %vsabi%
@if /I "%meson%"=="y" cd %mesa%\llvm\buildsys-%abi%-%llvmlink%

@rem Configure and execute the build with the configuration made above.
@echo.
@%buildconf%
@echo.
@pause
@echo.
@if /I NOT "%meson%"=="y" if /I NOT "%ninja%"=="y" cmake --build . -j %throttle% --config Release --target install
@if /I NOT "%meson%"=="y" if /I "%ninja%"=="y" ninja -j %throttle% install
@if /I "%meson%"=="y" echo LLVM build: Unimplemented code path.

:skipllvm
@echo.

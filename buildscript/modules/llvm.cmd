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
@if EXIST %mesa%\llvm set /p buildllvm=Begin LLVM build. Only needs to run once for each ABI and version. Proceed (y/n):
@if /I "%buildllvm%"=="y" echo.
@if /I NOT "%buildllvm%"=="y" GOTO skipllvm
@cd %mesa%\llvm
@if EXIST %abi% RD /S /Q %abi%
@if EXIST buildsys-%abi% RD /S /Q buildsys-%abi%
@md buildsys-%abi%
@cd buildsys-%abi%
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
@if /I NOT "%meson%"=="y" set buildconf=%buildconf% -DLLVM_TARGETS_TO_BUILD=X86 -DCMAKE_BUILD_TYPE=Release -DLLVM_USE_CRT_RELEASE=MT -DLLVM_ENABLE_RTTI=1 -DLLVM_ENABLE_TERMINFO=OFF -DCMAKE_INSTALL_PREFIX=../%abi% ..
@if /I "%meson%"=="y" set buildconf=echo LLVM Build aborted. Unimplemented build configuration.

@rem Load Visual Studio environment. Only cmake can load it in the background and only when using MsBuild.
@if /I NOT "%meson%"=="y" if /I "%ninja%"=="y" call %vsenv%
@if /I NOT "%meson%"=="y" if /I "%ninja%"=="y" cd %mesa%\llvm\buildsys-%abi%
@if /I "%meson%"=="y" call %vsenv%
@if /I "%meson%"=="y" cd %mesa%\llvm\buildsys-%abi%

@rem Configure and execute the build with the configuration made above.
@echo.
@%buildconf%
@echo.
@pause
@echo.
@if /I NOT "%meson%"=="y" if /I NOT "%ninja%"=="y" cmake --build . --config Release --target install
@if /I NOT "%meson%"=="y" if /I "%ninja%"=="y" ninja install
@if /I "%meson%"=="y" echo LLVM build: Unimplemented code path.

:skipllvm
@echo.

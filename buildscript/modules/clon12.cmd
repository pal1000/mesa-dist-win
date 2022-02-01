@setlocal
@set canclon12=1
@IF %gitstate% EQU 0 set canclon12=0
@if %cmakestate% EQU 0 set canclon12=0
@IF %canclon12% EQU 1 set /p buildclon12=Build Microsoft OpenCL over D3D12 driver (y/n):
@IF %canclon12% EQU 1 echo.
@IF /I NOT "%buildclon12%"=="y" GOTO skipclon12
@IF EXIST "%devroot%\clon12\" (
@echo Updating CLonD3D12 ICD source code...
@cd %devroot%\clon12
@git pull -v --progress --recurse-submodules origin
)
@IF NOT EXIST "%devroot%\clon12\" (
@echo Getting CLonD3D12 ICD source code...
@git clone https://github.com/microsoft/OpenCLOn12 %devroot%\clon12
)
@echo.

@rem Ask for Ninja use if exists. Load it if opted for it.
@set ninja=n
@if NOT %ninjastate%==0 set /p ninja=Use Ninja build system instead of MsBuild (y/n); less storage device strain, faster and more efficient build:
@if NOT %ninjastate%==0 echo.
@if /I "%ninja%"=="y" if %ninjastate%==1 set PATH=%devroot%\ninja\;%PATH%

@rem Load cmake into build environment.
@if %cmakestate%==1 set PATH=%devroot%\cmake\bin\;%PATH%

@rem Construct build configuration command.
@set buildconf=cmake %devroot:\=/%/clon12 -G
@if /I NOT "%ninja%"=="y" set buildconf=%buildconf% "Visual Studio %toolset%"
@if %abi%==x86 if /I NOT "%ninja%"=="y" set buildconf=%buildconf% -A Win32
@if %abi%==x64 if /I NOT "%ninja%"=="y" set buildconf=%buildconf% -A x64
@if /I NOT "%ninja%"=="y" IF /I %PROCESSOR_ARCHITECTURE%==AMD64 set buildconf=%buildconf% -Thost=x64
@if /I "%ninja%"=="y" set buildconf=%buildconf%Ninja -DCMAKE_BUILD_TYPE=Release
@set buildconf=%buildconf% -DBUILD_TESTS=OFF -DCMAKE_INSTALL_PREFIX="%devroot:\=/%/clon12/build/%abi%"

@echo CLonD3D12 build configuration command^: %buildconf%
@echo.

@rem Always clean build
@cd %devroot%\clon12
@pause
@echo.
@echo Cleanning CLonD3D12 build. Please wait...
@echo.
@if EXIST "build\%abi%\" RD /S /Q build\%abi%
@if EXIST "out\%abi%\" RD /S /Q out\%abi%
@if NOT EXIST "out\" md out
@md out\%abi%
@cd out\%abi%
@pause
@echo.

@rem Load Visual Studio environment. Can only be loaded in the background when using MsBuild.
@if /I "%ninja%"=="y" call %vsenv% %vsabi%
@if /I "%ninja%"=="y" cd %devroot%\clon12\out\%abi%
@if /I "%ninja%"=="y" echo.

@rem Configure and execute the build with the configuration made above.
@%buildconf%
@echo.
@pause
@echo.
@if /I NOT "%ninja%"=="y" cmake --build . -j %throttle% --config Release
@if /I "%ninja%"=="y" ninja -j %throttle%
@echo.

@rem Avoid race condition in SPIRV Tools sources checkout.
@pause
@echo.

:skipclon12
@rem Reset environment after CLonD3D12 build.
@endlocal
@cd %devroot%
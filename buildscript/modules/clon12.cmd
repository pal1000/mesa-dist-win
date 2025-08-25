@setlocal
@set canclon12=1
@IF NOT EXIST "%devroot%\clon12\" IF %gitstate% EQU 0 set canclon12=0
@if %cmakestate% EQU 0 set canclon12=0
@set haswdk=0
@for /f delims^=^ eol^= %%a IN ('REG QUERY HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer /s /d /f "Windows Driver Kit" /e 2^>nul ^| find "HKEY_"') DO @for /f delims^=^ eol^= %%b IN ('REG QUERY %%a /s /v DisplayVersion 2^>nul ^| find "DisplayVersion"') DO @for /f tokens^=3^ eol^= %%c IN ("%%b") DO @for /f tokens^=3^ delims^=.^ eol^= %%d IN ("%%c") DO @for /f tokens^=3^ delims^=.^ eol^= %%e IN ("%WINSDK_VER%") DO @IF "%%d"=="%%e" set haswdk=1
@IF EXIST "%devroot%\clon12\" IF %gitstate% GTR 0 (
@echo Updating CLonD3D12 ICD source code...
@cd "%devroot%\clon12"
@git pull --progress --tags --recurse-submodules origin
@echo.
)
@IF NOT EXIST "%devroot%\clon12\" IF %gitstate% GTR 0 (
@echo Getting CLonD3D12 ICD source code...
@git clone https://github.com/microsoft/OpenCLOn12 "%devroot%\clon12"
@echo.
)
@cmd /c exit 0
@find /i /c "t/d3d12t" "%devroot%\clon12\cmakelists.txt" >nul 2>&1
@if %ERRORLEVEL%==0 (
@if %haswdk%==0 set canclon12=0
@if %nugetstate%==0 set canclon12=0
)

@IF %canclon12% EQU 1 call "%devroot%\%projectname%\bin\modules\prompt.cmd" buildclon12 "Build Microsoft OpenCL over D3D12 driver (y/n):"
@IF /I NOT "%buildclon12%"=="y" GOTO skipclon12

@rem Ask for Ninja use if exists and nuget packages are unused. Load it if opted for it.
@cmd /c exit 0
@find /i /c "t/d3d12t" "%devroot%\clon12\cmakelists.txt" >nul 2>&1
@if NOT %ERRORLEVEL%==0 call "%devroot%\%projectname%\buildscript\modules\useninja.cmd"

@rem Load cmake into build environment.
@if %cmakestate%==1 set PATH=%devroot%\cmake\bin\;%PATH%

@rem Load Nuget into build environment.
@if %nugetstate%==1 set PATH=%devroot%\nuget\;%PATH%

@rem Construct build configuration command.
@set buildconf=cmake "%devroot%\clon12" -G
@if /I NOT "%useninja%"=="y" set buildconf=%buildconf% "Visual Studio %toolset%"
@if %abi%==x86 if /I NOT "%useninja%"=="y" set buildconf=%buildconf% -A Win32,version=%WINSDK_VER%
@if %abi%==x64 if /I NOT "%useninja%"=="y" set buildconf=%buildconf% -A x64,version=%WINSDK_VER%
@if %abi%==arm64 if /I NOT "%useninja%"=="y" set buildconf=%buildconf% -A ARM64,version=%WINSDK_VER%
@if /I NOT "%useninja%"=="y" IF /I %PROCESSOR_ARCHITECTURE%==AMD64 set buildconf=%buildconf% -Thost=x64
@if /I "%useninja%"=="y" set buildconf=%buildconf%Ninja
@set buildconf=%buildconf% -DBUILD_TESTS=OFF -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DCMAKE_INSTALL_PREFIX="%devroot%\clon12\build\%abi%"

@echo CLonD3D12 build configuration command^: %buildconf%
@echo.

@rem Always clean build
@cd "%devroot%\clon12"
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
@if /I "%useninja%"=="y" call %vsenv% %WINSDK_VER% %vsabi%
@if /I "%useninja%"=="y" cd "%devroot%\clon12\out\%abi%"
@if /I "%useninja%"=="y" echo.

@rem Configure and execute the build with the configuration made above.
@%buildconf%
@cmd /c exit 0
@find /i /c "t/d3d12t" "%devroot%\clon12\cmakelists.txt" >nul 2>&1
@if %ERRORLEVEL%==0 nuget restore openclon12.sln -Source https://api.nuget.org/v3/index.json
@echo.
@pause
@echo.
@if /I NOT "%useninja%"=="y" call "%devroot%\%projectname%\buildscript\modules\trybuild.cmd" cmake --build . -j %throttle% --config Release
@if /I "%useninja%"=="y" call "%devroot%\%projectname%\buildscript\modules\trybuild.cmd" ninja -j %throttle%
@echo.

@rem Avoid race condition in SPIRV Tools sources checkout.
@pause
@echo.

:skipclon12
@rem Reset environment after CLonD3D12 build.
@endlocal
@cd "%devroot%\"
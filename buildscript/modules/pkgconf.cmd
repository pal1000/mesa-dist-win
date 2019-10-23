@setlocal
@rem Get and build pkgconf as best pkg-config implementation for Mesa3D Meson build.
@if NOT EXIST %mesa%\pkgconf IF %gitstate%==0 echo Couldn't get pkgconf. Falling back to pkg-config...
@if NOT EXIST %mesa%\pkgconf IF %gitstate%==0 echo.
@if NOT EXIST %mesa%\pkgconf IF %gitstate%==0 GOTO missingpkgconf
@cd %mesa%
@if NOT EXIST %mesa%\pkgconf IF %gitstate% GTR 0 echo Getting pkgconf...
@if NOT EXIST %mesa%\pkgconf IF %gitstate% GTR 0 echo.
@if NOT EXIST %mesa%\pkgconf IF %gitstate% GTR 0 git clone https://github.com/pkgconf/pkgconf.git --recurse-submodules pkgconf
@if NOT EXIST %mesa%\pkgconf IF %gitstate% GTR 0 echo.
@cd pkgconf
@IF EXIST build\pkg-config.exe set buildpkgconf=n
@IF NOT EXIST build\pkg-config.exe set buildpkgconf=y
@IF NOT EXIST build\pkg-config.exe echo Begin pkgconf build...
@IF NOT EXIST build\pkg-config.exe echo.
@IF EXIST build\pkg-config.exe set /p buildpkgconf=Do you want to rebuild pkgconf (y/n):
@IF EXIST build\pkg-config.exe echo.
@IF /I "%buildpkgconf%"=="y" IF /I %PROCESSOR_ARCHITECTURE%==AMD64 call %vsenv% x64
@IF /I "%buildpkgconf%"=="y" IF /I %PROCESSOR_ARCHITECTURE%==x86 call %vsenv% x86
@IF /I "%buildpkgconf%"=="y" echo.
@IF /I "%buildpkgconf%"=="y" IF EXIST build RD /S /Q build
@set useninja=n
@IF /I "%buildpkgconf%"=="y" IF %ninjastate% GTR 0 set /p useninja=Use Ninja build system instead of MsBuild (y/n):
@IF /I "%buildpkgconf%"=="y" IF %ninjastate% GTR 0 echo.
@IF /I "%useninja%"=="y" IF %ninjastate%==1 set PATH=%mesa%\ninja\;%PATH%
@IF /I "%buildpkgconf%"=="y" IF /I NOT "%useninja%"=="y" echo Configuring pkgconf build with : %mesonloc% build --backend=vs --buildtype=release -Dtests=false
@IF /I "%buildpkgconf%"=="y" IF /I NOT "%useninja%"=="y" echo.
@IF /I "%buildpkgconf%"=="y" IF /I NOT "%useninja%"=="y" %mesonloc% build --backend=vs --buildtype=release -Dtests=false
@IF /I "%useninja%"=="y" echo Configuring pkgconf build with : %mesonloc% build --backend=ninja --buildtype=release -Dtests=false
@IF /I "%useninja%"=="y" echo.
@IF /I "%useninja%"=="y" %mesonloc% build --backend=ninja --buildtype=release -Dtests=false
@IF /I "%buildpkgconf%"=="y" echo.
@IF /I "%buildpkgconf%"=="y" pause
@IF /I "%buildpkgconf%"=="y" echo.
@IF /I "%buildpkgconf%"=="y" cd build
@IF /I "%buildpkgconf%"=="y" IF /I NOT "%useninja%"=="y" IF /I %PROCESSOR_ARCHITECTURE%==AMD64 echo Performing pkgconf build with : msbuild /p^:Configuration=release,Platform=x64 pkgconf.sln /m^:%throttle%
@IF /I "%buildpkgconf%"=="y" IF /I NOT "%useninja%"=="y" IF /I %PROCESSOR_ARCHITECTURE%==x86 echo Performing pkgconf build with : msbuild /p^:Configuration=release,Platform=Win32 pkgconf.sln /m^:%throttle%
@IF /I "%buildpkgconf%"=="y" IF /I NOT "%useninja%"=="y" echo.
@IF /I "%buildpkgconf%"=="y" IF /I NOT "%useninja%"=="y" IF /I %PROCESSOR_ARCHITECTURE%==AMD64 msbuild /p^:Configuration=release,Platform=x64 pkgconf.sln /m^:%throttle%
@IF /I "%buildpkgconf%"=="y" IF /I NOT "%useninja%"=="y" IF /I %PROCESSOR_ARCHITECTURE%==x86 msbuild /p^:Configuration=release,Platform=Win32 pkgconf.sln /m^:%throttle%
@IF /I "%useninja%"=="y" echo Performing pkgconf build with : ninja
@IF /I "%useninja%"=="y" echo.
@IF /I "%useninja%"=="y" ninja
@IF /I "%buildpkgconf%"=="y" echo.
@IF /I "%buildpkgconf%"=="y" IF EXIST pkgconf.exe REN pkgconf.exe pkg-config.exe

:missingpkgconf
@endlocal
@cd %mesa%
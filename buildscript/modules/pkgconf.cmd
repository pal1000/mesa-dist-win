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
@set ninja=n
@rem IF /I "%buildpkgconf%"=="y" IF %ninjastate% GTR 0 set /p ninja=Use Ninja build system instead of MsBuild (y/n):
@rem IF /I "%buildpkgconf%"=="y" IF %ninjastate% GTR 0 echo.
@IF /I "%ninja%"=="y" IF %ninjastate%==1 set PATH=%mesa%\ninja\;%PATH%
@IF /I "%buildpkgconf%"=="y" IF /I NOT "%ninja%"=="y" echo Configuring pkgconf build with : meson build --backend=vs --buildtype=release -Dtests=false
@IF /I "%buildpkgconf%"=="y" IF /I NOT "%ninja%"=="y" echo.
@IF /I "%buildpkgconf%"=="y" IF /I NOT "%ninja%"=="y" meson build --backend=vs --buildtype=release -Dtests=false
@IF /I "%ninja%"=="y" echo Configuring pkgconf build with : meson build --backend=ninja --buildtype=release -Dtests=false
@IF /I "%ninja%"=="y" echo.
@IF /I "%ninja%"=="y" meson build --backend=ninja --buildtype=release -Dtests=false
@IF /I "%buildpkgconf%"=="y" echo.
@IF /I "%buildpkgconf%"=="y" pause
@IF /I "%buildpkgconf%"=="y" echo.
@IF /I "%buildpkgconf%"=="y" cd build
@IF /I "%buildpkgconf%"=="y" IF /I NOT "%ninja%"=="y" IF /I %PROCESSOR_ARCHITECTURE%==AMD64 echo Performing pkgconf build with : msbuild /p^:Configuration=release,Platform=x64 pkgconf.sln /m^:%throttle%
@IF /I "%buildpkgconf%"=="y" IF /I NOT "%ninja%"=="y" IF /I %PROCESSOR_ARCHITECTURE%==x86 echo Performing pkgconf build with : msbuild /p^:Configuration=release,Platform=Win32 pkgconf.sln /m^:%throttle%
@IF /I "%buildpkgconf%"=="y" IF /I NOT "%ninja%"=="y" echo.
@IF /I "%buildpkgconf%"=="y" IF /I NOT "%ninja%"=="y" IF /I %PROCESSOR_ARCHITECTURE%==AMD64 msbuild /p^:Configuration=release,Platform=x64 pkgconf.sln /m^:%throttle%
@IF /I "%buildpkgconf%"=="y" IF /I NOT "%ninja%"=="y" IF /I %PROCESSOR_ARCHITECTURE%==x86 msbuild /p^:Configuration=release,Platform=Win32 pkgconf.sln /m^:%throttle%
@IF /I "%ninja%"=="y" echo Performing pkgconf build with : ninja
@IF /I "%ninja%"=="y" echo.
@IF /I "%ninja%"=="y" ninja
@IF /I "%buildpkgconf%"=="y" echo.
@IF /I "%buildpkgconf%"=="y" IF EXIST pkgconf.exe REN pkgconf.exe pkg-config.exe

:missingpkgconf
@endlocal
@cd %mesa%
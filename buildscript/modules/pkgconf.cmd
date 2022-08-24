@setlocal
@rem Get and build pkgconf as best pkg-config implementation for Mesa3D Meson build.
@if NOT EXIST "%devroot%\pkgconf\" IF %gitstate%==0 echo Couldn't get pkgconf. Falling back to pkg-config...
@if NOT EXIST "%devroot%\pkgconf\" IF %gitstate%==0 echo.
@if NOT EXIST "%devroot%\pkgconf\" IF %gitstate%==0 GOTO missingpkgconf
@cd "%devroot%"
@if EXIST "%devroot%\pkgconf\" IF %gitstate% GTR 0 (
@echo Updating pkgconf source code...
@cd pkgconf
@for /f tokens^=2^ delims^=/^ eol^= %%a in ('git symbolic-ref --short refs/remotes/origin/HEAD 2^>^&^1') do @git checkout %%a
@git pull --progress --tags --recurse-submodules origin
)
@if NOT EXIST "%devroot%\pkgconf\" IF %gitstate% GTR 0 (
@echo Getting pkgconf source code...
@git clone https://gitea.treehouse.systems/ariadne/pkgconf.git --recurse-submodules pkgconf
@cd pkgconf
)
@IF %gitstate% GTR 0 (
@git checkout bddf1641f82b62fc4b4fc2be761194647bb820b1
@echo.
)
@IF EXIST pkgconf\pkg-config.exe set buildpkgconf=n
@IF EXIST pkgconf\pkg-config.exe set /p buildpkgconf=Do you want to rebuild pkgconf (y/n):
@IF NOT EXIST pkgconf\pkg-config.exe set buildpkgconf=y
@IF NOT EXIST pkgconf\pkg-config.exe echo Begin pkgconf build...
@echo.
@IF /I NOT "%buildpkgconf%"=="y" GOTO missingpkgconf
@call %vsenv% %hostabi%
@echo.
@IF EXIST "pkgconf\" RD /S /Q pkgconf
@set useninja=n
@IF %ninjastate% GTR 0 set /p useninja=Use Ninja build system instead of MsBuild (y/n):
@IF %ninjastate% GTR 0 echo.
@IF /I "%useninja%"=="y" IF %ninjastate%==1 set PATH=%devroot%\ninja\;%PATH%
@IF /I NOT "%useninja%"=="y" echo Configuring pkgconf build with : %mesonloc% pkgconf --backend=vs --buildtype=release -Dtests=false
@IF /I NOT "%useninja%"=="y" echo.
@IF /I NOT "%useninja%"=="y" %mesonloc% pkgconf --backend=vs --buildtype=release -Dtests=false
@IF /I "%useninja%"=="y" echo Configuring pkgconf build with : %mesonloc% pkgconf --backend=ninja --buildtype=release -Dtests=false
@IF /I "%useninja%"=="y" echo.
@IF /I "%useninja%"=="y" %mesonloc% pkgconf --backend=ninja --buildtype=release -Dtests=false
@echo.
@pause
@echo.
@cd pkgconf
@IF /I NOT "%useninja%"=="y" IF /I %PROCESSOR_ARCHITECTURE%==AMD64 echo Performing pkgconf build with : msbuild /p^:Configuration=release,Platform=x64 pkgconf.sln /m^:%throttle%
@IF /I NOT "%useninja%"=="y" IF /I %PROCESSOR_ARCHITECTURE%==x86 echo Performing pkgconf build with : msbuild /p^:Configuration=release,Platform=Win32 pkgconf.sln /m^:%throttle%
@IF /I NOT "%useninja%"=="y" echo.
@IF /I NOT "%useninja%"=="y" IF /I %PROCESSOR_ARCHITECTURE%==AMD64 msbuild /p^:Configuration=release,Platform=x64 pkgconf.sln /m^:%throttle%
@IF /I NOT "%useninja%"=="y" IF /I %PROCESSOR_ARCHITECTURE%==x86 msbuild /p^:Configuration=release,Platform=Win32 pkgconf.sln /m^:%throttle%
@IF /I "%useninja%"=="y" echo Performing pkgconf build with : ninja
@IF /I "%useninja%"=="y" echo.
@IF /I "%useninja%"=="y" ninja
@echo.
@IF EXIST pkgconf.exe REN pkgconf.exe pkg-config.exe

:missingpkgconf
@endlocal
@cd "%devroot%"
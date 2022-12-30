@setlocal
@rem Get and build VA-API library.
@if NOT EXIST "%devroot%\libva\" IF %gitstate%==0 GOTO nolibva
@cd "%devroot%"
@if NOT EXIST "%devroot%\libva\" IF %gitstate% GTR 0 (
@echo Getting VA-API source code...
@git clone https://github.com/intel/libva.git --recurse-submodules libva
)
@if EXIST "%devroot%\libva\" IF %gitstate% GTR 0 (
@echo Switching VA-API source code to stable release...
@cd libva
@for /f tokens^=2^ delims^=/^ eol^= %%a in ('git symbolic-ref --short refs/remotes/origin/HEAD 2^>^&^1') do @git checkout %%a
@git pull --progress --tags --recurse-submodules origin
@git checkout 2.17.0
)
@IF %gitstate% GTR 0 echo.
@IF %toolchain%==msvc IF "%pkgconfigstate%"=="0" GOTO nolibva
@set /p buildlibva=Do you want to build VA-API library (y/n):
@echo.
@IF /I NOT "%buildlibva%"=="y" GOTO nolibva

@IF %toolchain%==msvc call %vsenv% %vsabi%
@IF %toolchain%==msvc cd "%devroot%\libva"
@IF %toolchain%==msvc echo.
@IF NOT EXIST "build\" MD build
@echo Cleanning VA-API library build...
@echo.
@IF EXIST "build\%toolchain%-%abi%" RD /S /Q build\%toolchain%-%abi%
@IF EXIST "build\buildsys-%toolchain%-%abi%" RD /S /Q build\buildsys-%toolchain%-%abi%

@call "%devroot%\%projectname%\buildscript\modules\useninja.cmd"
@IF %toolchain%==msvc IF NOT "%pkgconfigstate%"=="0" set PATH=%pkgconfigloc%\;%PATH%

@IF NOT %toolchain%==msvc IF %abi%==aarch64 set CFLAGS=-march^=armv8-a -pipe
@IF NOT %toolchain%==msvc IF NOT %abi%==aarch64 set CFLAGS=-march^=core2 -pipe

@set buildconf=%mesonloc% setup build/buildsys-%toolchain%-%abi% --buildtype=release --pkgconfig.relocatable --prefix="%devroot:\=/%/libva/build/%toolchain%-%abi%"
@IF /I NOT "%useninja%"=="y" set buildconf=%buildconf% --backend=vs
@IF /I "%useninja%"=="y" set buildconf=%buildconf% --backend=ninja
@IF NOT %toolchain%==msvc set /p dynamiclink=Link binaries dynamically (y/n):
@IF NOT %toolchain%==msvc echo.
@IF NOT %toolchain%==msvc set buildconf=%buildconf% -Dc_args="%CFLAGS%" -Dcpp_args="%CFLAGS%"
@IF /I "%dynamiclink%"=="y" set buildconf=%buildconf% -Dc_link_args="-s" -Dcpp_link_args="-s"
@IF NOT %toolchain%==msvc IF /I NOT "%dynamiclink%"=="y" set buildconf=%buildconf% --prefer-static -Dc_link_args="-s -static" -Dcpp_link_args="-s -static"
@IF %toolchain%==msvc set buildconf=%buildconf% -Db_vscrt=mt
@IF NOT %toolchain%==msvc set CFLAGS=

@echo Configuring VA-API build with : %buildconf%
@echo.
@%buildconf%
@echo.
@pause
@echo.
@cd build\buildsys-%toolchain%-%abi%

@IF /I NOT "%useninja%"=="y" IF %abi%==x64 set buildcmd=msbuild /p^:Configuration=release,Platform=x64 libva.sln /m^:%throttle% ^&^& msbuild /p^:Configuration=release,Platform=x64 RUN_INSTALL.vcxproj /m^:%throttle%
@IF /I NOT "%useninja%"=="y" IF %abi%==x86 set buildcmd=msbuild /p^:Configuration=release,Platform=Win32 libva.sln /m^:%throttle% ^&^& msbuild /p^:Configuration=release,Platform=Win32 RUN_INSTALL.vcxproj /m^:%throttle%
@IF /I NOT "%useninja%"=="y" IF %abi%==aarch64 set buildcmd=msbuild /p^:Configuration=release,Platform=ARM64 libva.sln /m^:%throttle% ^&^& msbuild /p^:Configuration=release,Platform=ARM64 RUN_INSTALL.vcxproj /m^:%throttle%
@IF /I "%useninja%"=="y" IF %toolchain%==msvc set buildcmd=ninja -j %throttle% install
@IF NOT %toolchain%==msvc set buildcmd=%runmsys% /%LMSYSTEM%/bin/ninja -j %throttle% install
@echo Performing VA-API build with ^: %buildcmd%
@echo.
@%buildcmd%
@echo.

:nolibva
@endlocal
@cd "%devroot%"
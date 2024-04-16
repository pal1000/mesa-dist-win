@setlocal
@rem Get and build zstd compressor.
@if NOT EXIST "%devroot%\zstd\" IF %gitstate%==0 GOTO nozstd
@cd "%devroot%\"
@if NOT EXIST "%devroot%\zstd\" IF %gitstate% GTR 0 (
@echo Getting zstd source code...
@git clone https://github.com/facebook/zstd.git --recurse-submodules zstd
)
@if EXIST "%devroot%\zstd\" IF %gitstate% GTR 0 (
@echo Switching zstd source code to stable release...
@cd zstd
@for /f tokens^=2^ delims^=/^ eol^= %%a in ('git symbolic-ref --short refs/remotes/origin/HEAD 2^>^&^1') do @git checkout %%a
@git pull --progress --tags --recurse-submodules origin
@git checkout v1.5.6
)
@IF %gitstate% GTR 0 echo.
@IF "%pkgconfigstate%"=="0" GOTO nozstd
@set /p buildzstd=Do you want to build zstd compressor (y/n):
@echo.
@IF /I NOT "%buildzstd%"=="y" GOTO nozstd

@call %vsenv% %vsabi%
@cd "%devroot%\zstd"
@echo.
@IF NOT EXIST "zstd\" MD zstd
@echo Cleanning zstd compressor build...
@echo.
@IF EXIST "zstd\%abi%\" RD /S /Q zstd\%abi%
@IF EXIST "zstd\buildsys-%abi%\" RD /S /Q zstd\buildsys-%abi%
@cd build\meson

@call "%devroot%\%projectname%\buildscript\modules\useninja.cmd"
@IF NOT "%pkgconfigstate%"=="0" set PATH=%pkgconfigloc%\;%PATH%

@set buildconf=%mesonloc% setup "%devroot:\=/%/zstd/zstd/buildsys-%abi%" --buildtype=release --pkgconfig.relocatable --prefix="%devroot:\=/%/zstd/zstd/%abi%" -Db_vscrt=mt
@IF /I NOT "%useninja%"=="y" set buildconf=%buildconf% --backend=vs
@IF /I "%useninja%"=="y" set buildconf=%buildconf% --backend=ninja

@echo Configuring zstd build with : %buildconf%
@echo.
@pause
@echo.
@%buildconf%
@echo.
@pause
@echo.
@cd "%devroot%\zstd\zstd\buildsys-%abi%"

@IF /I NOT "%useninja%"=="y" IF %abi%==x64 set buildcmd=msbuild /p^:Configuration=release,Platform=x64 zstd.sln /m^:%throttle% ^&^& msbuild /p^:Configuration=release,Platform=x64 RUN_INSTALL.vcxproj /m^:%throttle%
@IF /I NOT "%useninja%"=="y" IF %abi%==x86 set buildcmd=msbuild /p^:Configuration=release,Platform=Win32 zstd.sln /m^:%throttle% ^&^& msbuild /p^:Configuration=release,Platform=Win32 RUN_INSTALL.vcxproj /m^:%throttle%
@IF /I NOT "%useninja%"=="y" IF %abi%==aarch64 set buildcmd=msbuild /p^:Configuration=release,Platform=ARM64 zstd.sln /m^:%throttle% ^&^& msbuild /p^:Configuration=release,Platform=ARM64 RUN_INSTALL.vcxproj /m^:%throttle%
@IF /I "%useninja%"=="y" set buildcmd=ninja -j %throttle% install
@echo Performing zstd build with ^: %buildcmd%
@echo.
@%buildcmd%
@echo.

:nozstd
@endlocal
@cd "%devroot%\"
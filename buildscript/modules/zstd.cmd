@setlocal
@rem Get and build zstd compressor.
@if NOT EXIST "%devroot%\zstd\" IF %gitstate%==0 GOTO nozstd
@IF "%pkgconfigstate%"=="0" GOTO nozstd

@set zstd_ver=v1.5.7-kernel
@if EXIST "%devroot%\zstd\" IF %gitstate% GTR 0 (
@echo Switching zstd source code to stable release...
@cd "%devroot%\zstd"
@for /f tokens^=2^ delims^=/^ eol^= %%a in ('git symbolic-ref --short refs/remotes/origin/HEAD 2^>^&^1') do @git checkout %%a
@git pull --progress --tags --recurse-submodules origin
@git checkout %zstd_ver%
@echo.
)

@call "%devroot%\%projectname%\bin\modules\prompt.cmd" buildzstd "Do you want to build zstd compressor (y/n):"
@IF /I NOT "%buildzstd%"=="y" GOTO nozstd

@if NOT EXIST "%devroot%\zstd\" IF %gitstate% GTR 0 (
@echo Getting zstd source code...
@cd "%devroot%\"
@git clone https://github.com/facebook/zstd.git --recurse-submodules zstd
@cd zstd
@git checkout %zstd_ver%
@echo.
)

@call %vsenv% %WINSDK_VER% %vsabi%
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

@set buildconf=%mesonloc% setup "%devroot:\=/%/zstd/zstd/buildsys-%abi%" --buildtype=release --pkgconfig.relocatable --prefix="%devroot:\=/%/zstd/zstd/%abi%" -Db_vscrt=mt -Dstatic_runtime=true
@IF /I NOT "%useninja%"=="y" set buildconf=%buildconf% --backend=vs
@IF /I "%useninja%"=="y" set buildconf=%buildconf% --backend=ninja

@echo Configuring zstd build with : %buildconf%
@echo.
@call "%devroot%\%projectname%\bin\modules\break.cmd"
@%buildconf%
@echo.
@cd "%devroot%\zstd\zstd\buildsys-%abi%"

@IF /I "%useninja%"=="y" echo Performing zstd build with ^: ninja -j %throttle% install
@IF /I NOT "%useninja%"=="y" echo Performing zstd build with ^: msbuild zstd.sln /m^:%throttle% /v^:m and msbuild RUN_INSTALL.vcxproj
@echo.
@call "%devroot%\%projectname%\bin\modules\break.cmd"

@IF /I "%useninja%"=="y" call "%devroot%\%projectname%\buildscript\modules\trybuild.cmd" ninja -j %throttle% install
@IF /I NOT "%useninja%"=="y" call "%devroot%\%projectname%\buildscript\modules\trybuild.cmd" msbuild zstd.sln /m^:%throttle% /v^:m
@IF /I NOT "%useninja%"=="y" msbuild RUN_INSTALL.vcxproj
@echo.

@rem Avoid race condition in LLVM sources checkout.
@call "%devroot%\%projectname%\bin\modules\break.cmd"

:nozstd
@endlocal
@cd "%devroot%\"
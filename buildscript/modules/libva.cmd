@setlocal
@rem Get and build VA-API library.
@if NOT EXIST "%devroot%\libva\" IF %gitstate%==0 GOTO nolibva
@IF "%pkgconfigstate%"=="0" GOTO nolibva

@set libva_ver=2.23.0
@if EXIST "%devroot%\libva\" IF %gitstate% GTR 0 (
@echo Switching VA-API source code to stable release...
@cd "%devroot%\libva"
@for /f tokens^=2^ delims^=/^ eol^= %%a in ('git symbolic-ref --short refs/remotes/origin/HEAD 2^>^&^1') do @git checkout %%a
@git pull --progress --tags --recurse-submodules origin
@git checkout %libva_ver%
@echo.
)

@call "%devroot%\%projectname%\bin\modules\prompt.cmd" buildlibva "Do you want to build VA-API library (y/n):"
@IF /I NOT "%buildlibva%"=="y" GOTO nolibva

@if NOT EXIST "%devroot%\libva\" IF %gitstate% GTR 0 (
@echo Getting VA-API source code...
@cd "%devroot%\"
@git clone https://github.com/intel/libva.git --recurse-submodules libva
@cd libva
@git checkout %libva_ver%
@echo.
)

@call %vsenv% %WINSDK_VER% %vsabi%
@cd "%devroot%\libva"
@echo.
@IF NOT EXIST "build\" MD build
@echo Cleanning VA-API library build...
@echo.
@IF EXIST "build\%abi%\" RD /S /Q build\%abi%
@IF EXIST "build\buildsys-%abi%\" RD /S /Q build\buildsys-%abi%

@call "%devroot%\%projectname%\buildscript\modules\useninja.cmd"
@IF NOT "%pkgconfigstate%"=="0" set PATH=%pkgconfigloc%\;%PATH%

@set buildconf=%mesonloc% setup build/buildsys-%abi% --buildtype=release --pkgconfig.relocatable --prefix="%devroot:\=/%/libva/build/%abi%" -Db_vscrt=mt
@IF /I NOT "%useninja%"=="y" set buildconf=%buildconf% --backend=vs
@IF /I "%useninja%"=="y" set buildconf=%buildconf% --backend=ninja

@echo Configuring VA-API build with : %buildconf%
@echo.
@call "%devroot%\%projectname%\bin\modules\break.cmd"
@%buildconf%
@echo.
@cd build\buildsys-%abi%

@IF /I "%useninja%"=="y" echo Performing VA-API build with ^: ninja -j %throttle% install
@IF /I NOT "%useninja%"=="y" echo Performing VA-API build with ^: msbuild libva.sln /m^:%throttle% /v^:m and msbuild RUN_INSTALL.vcxproj
@echo.
@call "%devroot%\%projectname%\bin\modules\break.cmd"
@IF /I "%useninja%"=="y" call "%devroot%\%projectname%\buildscript\modules\trybuild.cmd" ninja -j %throttle% install
@IF /I NOT "%useninja%"=="y" call "%devroot%\%projectname%\buildscript\modules\trybuild.cmd" msbuild libva.sln /m^:%throttle% /v^:m
@IF /I NOT "%useninja%"=="y" msbuild RUN_INSTALL.vcxproj
@echo.

@rem Avoid race condition in MSYS2 packages install.
@call "%devroot%\%projectname%\bin\modules\break.cmd"

:nolibva
@endlocal
@cd "%devroot%\"
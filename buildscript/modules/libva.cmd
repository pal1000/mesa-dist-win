@setlocal
@rem Get and build VA-API library.
@if NOT EXIST "%devroot%\libva\" IF %gitstate%==0 GOTO nolibva
@IF "%pkgconfigstate%"=="0" GOTO nolibva

@set libva_ver=2.22.0
@if EXIST "%devroot%\libva\" IF %gitstate% GTR 0 (
@echo Switching VA-API source code to stable release...
@cd "%devroot%\libva"
@for /f tokens^=2^ delims^=/^ eol^= %%a in ('git symbolic-ref --short refs/remotes/origin/HEAD 2^>^&^1') do @git checkout %%a
@git pull --progress --tags --recurse-submodules origin
@git checkout %libva_ver%
@echo.
)

@set /p buildlibva=Do you want to build VA-API library (y/n):
@echo.
@IF /I NOT "%buildlibva%"=="y" GOTO nolibva

@if NOT EXIST "%devroot%\libva\" IF %gitstate% GTR 0 (
@echo Getting VA-API source code...
@cd "%devroot%\"
@git clone https://github.com/intel/libva.git --recurse-submodules libva
@cd libva
@git checkout %libva_ver%
@echo.
)

@call %vsenv% %vsabi%
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
@pause
@echo.
@%buildconf%
@echo.
@pause
@echo.
@cd build\buildsys-%abi%

@IF /I NOT "%useninja%"=="y" IF %abi%==x64 set buildcmd=msbuild /p^:Configuration=release,Platform=x64 libva.sln /m^:%throttle% ^&^& msbuild /p^:Configuration=release,Platform=x64 RUN_INSTALL.vcxproj /m^:%throttle%
@IF /I NOT "%useninja%"=="y" IF %abi%==x86 set buildcmd=msbuild /p^:Configuration=release,Platform=Win32 libva.sln /m^:%throttle% ^&^& msbuild /p^:Configuration=release,Platform=Win32 RUN_INSTALL.vcxproj /m^:%throttle%
@IF /I NOT "%useninja%"=="y" IF %abi%==aarch64 set buildcmd=msbuild /p^:Configuration=release,Platform=ARM64 libva.sln /m^:%throttle% ^&^& msbuild /p^:Configuration=release,Platform=ARM64 RUN_INSTALL.vcxproj /m^:%throttle%
@IF /I "%useninja%"=="y" set buildcmd=ninja -j %throttle% install
@echo Performing VA-API build with ^: %buildcmd%
@echo.
@%buildcmd%
@echo.

:nolibva
@endlocal
@cd "%devroot%\"
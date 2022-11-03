@setlocal
@rem Get and build VA-API library.
@if NOT EXIST "%devroot%\libva\" IF %gitstate%==0 GOTO nolibva
@cd "%devroot%"
@if EXIST "%devroot%\libva\" IF %gitstate% GTR 0 (
@echo Updating VA-API source code...
@cd libva
@for /f tokens^=2^ delims^=/^ eol^= %%a in ('git symbolic-ref --short refs/remotes/origin/HEAD 2^>^&^1') do @git checkout %%a
@git pull --progress --tags --recurse-submodules origin
)
@if NOT EXIST "%devroot%\libva\" IF %gitstate% GTR 0 (
@echo Getting VA-API source code...
@git clone https://github.com/intel/libva.git --recurse-submodules libva
@cd libva
)
@IF %gitstate% GTR 0 echo.

@set /p buildlibva=Do you want to build VA-API library (y/n):
@echo.
@IF /I NOT "%buildlibva%"=="y" GOTO nolibva
@call %vsenv% %vsabi%
@cd "%devroot%\libva"

@echo.
@IF NOT EXIST "build\" MD build
@echo Cleanning VA-API library build...
@echo.
@IF EXIST "build\%abi%" RD /S /Q build\%abi%
@IF EXIST "build\buildsys-%abi%" RD /S /Q build\buildsys-%abi%
@call "%devroot%\%projectname%\buildscript\modules\useninja.cmd"
@IF /I "%useninja%"=="y" IF %ninjastate%==1 set PATH=%devroot%\ninja\;%PATH%
@IF %pkgconfigstate% GTR 0 set PATH=%pkgconfigloc%\;%PATH%
@IF /I NOT "%useninja%"=="y" echo Configuring VA-API build with : %mesonloc% setup build\buildsys-%abi% --backend=vs --buildtype=release --prefix="%devroot:\=/%/libva/build/%abi%"
@IF /I "%useninja%"=="y" echo Configuring VA-API build with : %mesonloc% setup build\buildsys-%abi% --backend=ninja --buildtype=release --prefix="%devroot:\=/%/libva/build/%abi%"
@echo.
@IF /I NOT "%useninja%"=="y" %mesonloc% setup build\buildsys-%abi% --backend=vs --buildtype=release --prefix="%devroot:\=/%/libva/build/%abi%"
@IF /I "%useninja%"=="y" %mesonloc% setup build\buildsys-%abi% --backend=ninja --buildtype=release --prefix="%devroot:\=/%/libva/build/%abi%"
@echo.
@pause
@echo.
@cd build\buildsys-%abi%
@IF /I NOT "%useninja%"=="y" IF %abi%==x64 echo Performing VA-API build with ^: msbuild /p^:Configuration=release,Platform=x64 libva.sln /m^:%throttle% ^&^& msbuild /p^:Configuration=release,Platform=x64 RUN_INSTALL.vcxproj /m^:%throttle%
@IF /I NOT "%useninja%"=="y" IF %abi%==x86 echo Performing VA-API build with ^: msbuild /p^:Configuration=release,Platform=Win32 libva.sln /m^:%throttle% ^&^& msbuild /p^:Configuration=release,Platform=Win32 RUN_INSTALL.vcxproj /m^:%throttle%
@IF /I "%useninja%"=="y" echo Performing VA-API build with : ninja -j %throttle% install
@echo.
@IF /I NOT "%useninja%"=="y" IF %abi%==x64 msbuild /p^:Configuration=release,Platform=x64 libva.sln /m^:%throttle%
@IF /I NOT "%useninja%"=="y" IF %abi%==x64 msbuild /p^:Configuration=release,Platform=x64 RUN_INSTALL.vcxproj /m^:%throttle%
@IF /I NOT "%useninja%"=="y" IF %abi%==x86 msbuild /p^:Configuration=release,Platform=Win32 libva.sln /m^:%throttle%
@IF /I NOT "%useninja%"=="y" IF %abi%==x86 msbuild /p^:Configuration=release,Platform=Win32 RUN_INSTALL.vcxproj /m^:%throttle%
@IF /I "%useninja%"=="y" ninja -j %throttle% install
@echo.

@rem Avoid race condition in LLVM sources checkout.
@pause
@echo.

:nolibva
@endlocal
@cd "%devroot%"
@setlocal

:msmesabldsys
@IF %toolchain%==gcc GOTO gccmesabldsys
@IF %pythonver:~0,1%==2 set selectmesabld=1
@IF %pythonver:~0,1% GEQ 3 set selectmesabld=2
@GOTO donemesabldsys

@IF %pythonver:~0,1% GEQ 3 echo Select Mesa3D build system
@IF %pythonver:~0,1% GEQ 3 echo --------------------------
@IF %pythonver:~0,1% GEQ 3 echo 1. Scons (deprecated)
@IF %pythonver:~0,1% GEQ 3 IF NOT EXIST %devroot%\mesa echo 2. Meson (recommended)
@IF %pythonver:~0,1% GEQ 3 IF EXIST %devroot%\mesa\subprojects\.gitignore echo 2. Meson (recommended)
@IF %pythonver:~0,1% GEQ 3 echo.
@IF %pythonver:~0,1% GEQ 3 set /p selectmesabld=Select Mesa3D build system:
@IF %pythonver:~0,1% GEQ 3 echo.
@GOTO donemesabldsys

:gccmesabldsys
@echo Select Mesa3D build system
@echo --------------------------
@echo 1. Scons (recommended)
@IF NOT EXIST %devroot%\mesa echo 2. Meson (experimental)
@IF EXIST %devroot%\mesa\subprojects\.gitignore echo 2. Meson (experimental)
@echo.
@set /p selectmesabld=Select Mesa3D build system:
@echo.

:donemesabldsys
@IF NOT "%selectmesabld%"=="1" IF NOT "%selectmesabld%"=="2" (
@echo Invalid entry.
@echo.
@pause
@cls
@GOTO msmesabldsys
)
@IF "%selectmesabld%"=="2" IF EXIST %devroot%\mesa IF NOT EXIST %devroot%\mesa\subprojects\.gitignore (
@echo Invalid entry.
@echo.
@pause
@cls
@GOTO msmesabldsys
)
@IF "%selectmesabld%"=="1" set mesabldsys=scons
@IF "%selectmesabld%"=="2" set mesabldsys=meson
@endlocal&set mesabldsys=%mesabldsys%
@set TITLE=%TITLE% and %mesabldsys%
@TITLE %TITLE%
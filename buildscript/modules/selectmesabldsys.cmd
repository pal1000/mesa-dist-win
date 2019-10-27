@setlocal

:msmesabldsys
@set selectmesabld=1
@IF %toolchain%==gcc GOTO gccmesabldsys
@IF %pythonver:~0,1% GEQ 3 set selectmesabld=2
@GOTO donemesabldsys

@IF %pythonver:~0,1% GEQ 3 echo Select Mesa3D build system
@IF %pythonver:~0,1% GEQ 3 echo --------------------------
@IF %pythonver:~0,1% GEQ 3 echo 1. Scons (recommended)
@IF %pythonver:~0,1% GEQ 3 IF NOT EXIST %mesa%\mesa echo 2. Meson (experimental)
@IF %pythonver:~0,1% GEQ 3 IF EXIST %mesa%\mesa IF EXIST %mesa%\mesa\subprojects\.gitignore echo 2. Meson (experimental)
@IF %pythonver:~0,1% GEQ 3 echo.
@IF %pythonver:~0,1% GEQ 3 set /p selectmesabld=Select Mesa3D build system:
@IF %pythonver:~0,1% GEQ 3 echo.

:gccmesabldsys
@echo Select Mesa3D build system
@echo --------------------------
@echo 1. Scons (recommended)
@IF NOT EXIST %mesa%\mesa echo 2. Meson (experimental)
@IF EXIST %mesa%\mesa IF EXIST %mesa%\mesa\subprojects\.gitignore echo 2. Meson (experimental)
@echo.
@set /p selectmesabld=Select Mesa3D build system:
@echo.

:donemesabldsys
@IF "%selectmesabld%"=="1" set mesabldsys=scons
@IF "%selectmesabld%"=="2" set mesabldsys=meson
@IF NOT "%selectmesabld%"=="1" IF NOT "%selectmesabld%"=="2" (
@echo Invalid entry.
@echo.
@puse
@cls
@GOTO msmesabldsys
)
@IF "%selectmesabld%"=="2" IF EXIST %mesa%\mesa IF NOT EXIST %mesa%\mesa\subprojects\.gitignore (
@echo Invalid entry.
@echo.
@puse
@cls
@GOTO msmesabldsys
)
@endlocal&set mesabldsys=%mesabldsys%
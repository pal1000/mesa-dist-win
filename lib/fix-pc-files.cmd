@setlocal
@cd /d "%~dp0"
@set CD=
@set prefix=%CD%
@IF %prefix:~0,1%%prefix:~-1%=="" set prefix=%prefix:~1,-1%
@IF "%prefix:~-1%"=="\" set prefix=%prefix:~0,-1%
@set prefix=%prefix:~0,-4%

@echo Fixing libdir and prefix in pkg config files...
@for /R "%prefix%\lib" %%a IN (*.pc) do @call modules\fixlibdirandprefix.cmd "%%~a"
@echo Done.
@echo.
@pause
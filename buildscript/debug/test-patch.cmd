@cd /d "%~dp0"
@cd ..\..\..\
@set CD=
@set devroot=%CD%
@IF %devroot:~0,1%%devroot:~-1%=="" set devroot=%devroot:~1,-1%
@IF "%devroot:~-1%"=="\" set devroot=%devroot:~0,-1%
@set projectname=mesa-dist-win
@call "%devroot%\mesa-dist-win\buildscript\modules\git.cmd"
@call "%devroot%\mesa-dist-win\buildscript\modules\msys.cmd"
@call "%devroot%\mesa-dist-win\buildscript\modules\msysupdate.cmd"
@IF EXIST "%msysloc%" (
@%runmsys% pacman -S patch --needed --noconfirm
@echo.
)
@if %gitstate%==0 IF NOT EXIST "%msysloc%\usr\bin\patch.exe" (
@echo Fatal error: No patch tool found.
@pause
@exit
)
@cd "%devroot%\mesa"

:command
@set ptstcmd=
@set /p ptstcmd=Enter patch testing command:
@echo.
@IF /I "%ptstcmd%"=="exit" exit
@IF /I "%ptstcmd:~0,3%"=="cd " %ptstcmd%
@IF /I "%ptstcmd:~0,3%"=="cd " echo.
@IF %gitstate% GTR 0 IF EXIST "%CD%\.git\" IF /I "%ptstcmd:~0,4%"=="git " %ptstcmd%
@IF %gitstate% GTR 0 IF EXIST "%CD%\.git\" IF /I "%ptstcmd:~0,4%"=="git " echo.
@IF /I "%ptstcmd%"=="cd" echo %CD%
@IF /I "%ptstcmd%"=="cd" echo.
@IF %gitstate% GTR 0 IF EXIST "%CD%\.git\" IF /I "%ptstcmd%"=="clean" git checkout .
@IF %gitstate% GTR 0 IF EXIST "%CD%\.git\" IF /I "%ptstcmd%"=="clean" git clean -fd
@IF %gitstate% GTR 0 IF EXIST "%CD%\.git\" IF /I "%ptstcmd%"=="clean" echo.
@IF /I "%ptstcmd%"=="patch" for /R "%devroot%\%projectname%\patches\test" %%i in (*.patch) do @call "%devroot%\%projectname%\buildscript\modules\applypatch.cmd" test\%%~ni
@GOTO command
@cd "%~dp0"
@cd ..\..\
@for %%a in ("%cd%") do @set devroot=%%~sa
@set abi=x86
@call %devroot%\mesa-dist-win\buildscript\modules\msys.cmd
@call %devroot%\mesa-dist-win\buildscript\modules\msysupdate.cmd
@call %devroot%\mesa-dist-win\buildscript\modules\git.cmd
@set /p clean=Clear MSYS2 cache (y/n):
@echo.
@IF /I "%clean%"=="y" %msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -Sc --noconfirm"
@IF /I "%clean%"=="y" echo.

:command
@set msyscmd=
@set /p msyscmd=Enter MSYS2 command:
@echo.
@IF /I "%msyscmd%"=="exit" exit

@IF %gitstate% GTR 0 %msysloc%\usr\bin\bash --login -c "PATH=${PATH}:${gitloc};%msyscmd%"
@IF %gitstate% EQU 0 %msysloc%\usr\bin\bash --login -c "%msyscmd%"
@echo.
@GOTO command
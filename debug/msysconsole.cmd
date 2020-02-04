@cd "%~dp0"
@cd ..\..\
@for %%a in ("%cd%") do @set devroot=%%~sa
@set abi=x86
@set longabi=%abi%
@if %abi%==x64 set longabi=x86_64
@call %devroot%\mesa-dist-win\buildscript\modules\msys.cmd
@%msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -Syu --noconfirm --disable-download-timeout"
@echo.
@%msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -Syu --noconfirm --disable-download-timeout"
@echo.
@set /p clean=Clear MSYS2 cache (y/n):
@echo.
@IF /I "%clean%"=="y" %msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -Sc --noconfirm"
@IF /I "%clean%"=="y" echo.

:command
@set /p msyscmd=Enter MSYS2 command:
@echo.
@IF /I NOT "%msyscmd%"=="exit" %msysloc%\usr\bin\bash --login -c "%msyscmd%"
@IF /I NOT "%msyscmd%"=="exit" echo.
@IF /I NOT "%msyscmd%"=="exit" GOTO command
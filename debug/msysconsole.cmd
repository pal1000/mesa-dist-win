@cd "%~dp0"
@cd ..\..\
@for %%a in ("%cd%") do @set mesa=%%~sa
@set abi=x86
@set longabi=%abi%
@if %abi%==x64 set longabi=x86_64
@call %mesa%\mesa-dist-win\buildscript\modules\msys.cmd
@%msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -Syu --noconfirm --disable-download-timeout"
@echo.
@%msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -Syu --noconfirm --disable-download-timeout"
@echo.
@set MSYSTEM=MINGW32
@set /p clean=Clear MSYS2 cache (y/n):
@IF /I "%clean%"=="y" %msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -Sc --noconfirm"
@cmd /k echo.
@cd "%~dp0"
@cd ..\..\
@for %%a in ("%cd%") do @set devroot=%%~sa
@call %devroot%\mesa-dist-win\buildscript\modules\msys.cmd
@call %devroot%\mesa-dist-win\buildscript\modules\msysupdate.cmd
@call %devroot%\mesa-dist-win\buildscript\modules\git.cmd
@IF %msysstate% EQU 0 (
@echo Fatal error: MSYS2 is missing.
@pause
@exit
)

@set /p clean=Clear MSYS2 cache (y/n):
@echo.
@IF /I "%clean%"=="y" %msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -Sc --noconfirm"
@IF /I "%clean%"=="y" echo.

:selectshell
@echo Select shell:
@echo 1. MSYS2 (default)
@echo 2 MINGW32
@echo 3 MINGW64
@set /p shell=Enter choice:
@echo.
@IF "%shell%"=="2" set MSYSTEM=MINGW32
@IF "%shell%"=="3" set MSYSTEM=MINGW64
@IF NOT "%shell%"=="" IF NOT "%shell%"=="1" IF NOT "%shell%"=="2" IF NOT "%shell%"=="3" GOTO selectshell

:command
@set msyscmd=
@set /p msyscmd=Enter MSYS2 command:
@echo.
@IF /I "%msyscmd%"=="exit" exit
@IF /I "%msyscmd%"=="setup" set msyscmd=pacman -S flex bison patch tar mingw-w64-i686-{python-mako,meson,pkgconf,clang,vulkan-devel} mingw-w64-x86_64-{python-mako,meson,pkgconf,clang,vulkan-devel} --needed;echo;pacman -Sc --noconfirm

@IF %gitstate% GTR 0 %msysloc%\usr\bin\bash --login -c "PATH=${PATH}:${gitloc};%msyscmd%"
@IF %gitstate% EQU 0 %msysloc%\usr\bin\bash --login -c "%msyscmd%"
@echo.
@GOTO command
@cd /d "%~dp0"
@cd ..\..\..\
@set CD=
@set devroot=%CD%
@IF %devroot:~0,1%%devroot:~-1%=="" set devroot=%devroot:~1,-1%
@IF "%devroot:~-1%"=="\" set devroot=%devroot:~0,-1%
@set projectname=mesa-dist-win
@set cimode=0

@rem Create folder to store generated resource files and MSYS2 shell scripts
@IF NOT EXIST "%devroot%\%projectname%\buildscript\assets\" md "%devroot%\%projectname%\buildscript\assets"

@call "%devroot%\%projectname%\buildscript\modules\git.cmd"
@call "%devroot%\%projectname%\buildscript\modules\msys.cmd"
@call "%devroot%\%projectname%\buildscript\modules\msysupdate.cmd"
@IF NOT EXIST "%msysloc%" (
@echo Fatal error: MSYS2 is missing.
@pause
@exit
)

:selectshell
@echo Select shell:
@echo 1. MSYS2 (default)
@echo 2. MINGW32
@echo 3. MINGW64
@echo 4. CLANG32
@echo 5. CLANG64
@echo 6. UCRT64
@if %cimode% EQU 0 set "shell="
@call "%devroot%\%projectname%\bin\modules\prompt.cmd" shell "Enter choice:"
@if "%shell%"=="" set shell=1
@IF "%shell%"=="1" set "MSYSTEM="
@IF "%shell%"=="2" set MSYSTEM=MINGW32
@IF "%shell%"=="3" set MSYSTEM=MINGW64
@IF "%shell%"=="4" set MSYSTEM=CLANG32
@IF "%shell%"=="5" set MSYSTEM=CLANG64
@IF "%shell%"=="6" set MSYSTEM=UCRT64
@IF NOT "%shell%"=="1" IF NOT "%shell%"=="2" IF NOT "%shell%"=="3" IF NOT "%shell%"=="4" IF NOT "%shell%"=="5" IF NOT "%shell%"=="6" GOTO selectshell

:command
@if %cimode% EQU 0 set msyscmd=
@call "%devroot%\%projectname%\bin\modules\prompt.cmd" msyscmd "Enter MSYS2 command:"
@IF /I "%msyscmd%"=="exit" exit
@IF /I "%msyscmd%"=="shell" GOTO selectshell
@IF /I "%msyscmd%"=="clearcache" call "%devroot%\%projectname%\buildscript\modules\msyspkgclean.cmd"
@IF /I "%msyscmd%"=="cleancache" call "%devroot%\%projectname%\buildscript\modules\msyspkgclean.cmd"
@IF /I "%msyscmd%"=="setup" IF %shell% EQU 1 %runmsys% pacman -S flex bison patch tar --needed
@IF /I "%msyscmd%"=="setup" IF %shell% GTR 1 for /f tokens^=1-22^ delims^={^,}^ eol^= %%a IN ("%mingwpkglst%") DO @(
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%a --needed
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%b --needed
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%c --needed
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%d --needed
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%e --needed
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%f --needed
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%g --needed
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%h --needed
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%i --needed
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%j --needed
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%k --needed
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%l --needed
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%m --needed
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%n --needed
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%o --needed
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%p --needed
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%q --needed
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%r --needed
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%s --needed
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%t --needed
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%u --needed
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%v --needed
)
@IF /I NOT "%msyscmd%"=="clearcache" IF /I NOT "%msyscmd%"=="cleancache" IF /I NOT "%msyscmd%"=="setup" %runmsys% %msyscmd%
@echo.
@GOTO command
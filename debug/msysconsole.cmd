@cd /d "%~dp0"
@cd ..\..\
@set CD=
@set devroot=%CD%
@IF %devroot:~0,1%%devroot:~-1%=="" set devroot=%devroot:~1,-1%
@IF "%devroot:~-1%"=="\" set devroot=%devroot:~0,-1%
@set projectname=mesa-dist-win
@call "%devroot%\%projectname%\buildscript\modules\git.cmd"
@call "%devroot%\%projectname%\buildscript\modules\msys.cmd"
@call "%devroot%\%projectname%\buildscript\modules\msysupdate.cmd"
@IF %msysstate% EQU 0 (
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
@set "shell="
@set /p shell=Enter choice:
@echo.
@if "%shell%"=="" set shell=1
@IF "%shell%"=="1" set "MSYSTEM="
@IF "%shell%"=="2" set MSYSTEM=MINGW32
@IF "%shell%"=="3" set MSYSTEM=MINGW64
@IF "%shell%"=="4" set MSYSTEM=CLANG32
@IF "%shell%"=="5" set MSYSTEM=CLANG64
@IF "%shell%"=="6" set MSYSTEM=UCRT64
@IF NOT "%shell%"=="1" IF NOT "%shell%"=="2" IF NOT "%shell%"=="3" IF NOT "%shell%"=="4" IF NOT "%shell%"=="5" IF NOT "%shell%"=="6" GOTO selectshell

:command
@set msyscmd=
@set /p msyscmd=Enter MSYS2 command:
@echo.
@IF /I "%msyscmd%"=="exit" exit
@IF /I "%msyscmd%"=="shell" GOTO selectshell
@IF /I "%msyscmd%"=="clearcache" call "%devroot%\%projectname%\buildscript\modules\msyspkgclean.cmd"
@IF /I "%msyscmd%"=="cleancache" call "%devroot%\%projectname%\buildscript\modules\msyspkgclean.cmd"
@IF /I "%msyscmd%"=="setup" IF %shell% EQU 1 %runmsys% pacman -S flex bison patch tar mingw-w64-i686-%mingwpkglst% mingw-w64-x86_64-%mingwpkglst% --needed
@IF /I "%msyscmd%"=="setup" IF %shell% GTR 1 %runmsys% pacman -S flex bison patch tar ${MINGW_PACKAGE_PREFIX}-%mingwpkglst% --needed
@IF /I NOT "%msyscmd%"=="clearcache" IF /I NOT "%msyscmd%"=="cleancache" IF /I NOT "%msyscmd%"=="setup" %runmsys% %msyscmd%
@echo.
@GOTO command
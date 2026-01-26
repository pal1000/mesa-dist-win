@setlocal ENABLEDELAYEDEXPANSION
@set msvcpp=0
@for /f delims^= %%a IN ('dir /B /A^:D %vsenv:~0,-30%Tools\MSVC" 2^>nul') Do @IF EXIST %vsenv:~0,-30%Tools\MSVC\%%a\bin\" (
@set /a msvcpp+=1
@if !msvcpp! EQU 1 echo Select Visual Studio C/C++ toolset:
@echo !msvcpp!. %%a
@set msvcpp[!msvcpp!]=%%a
)
@if %msvcpp% GTR 0 echo.
@if %msvcpp% GTR 0 echo Note: Visual Studio C/C++ toolset 14.50 and newer dropped Windows 7/Server 2008 R2 support - https://github.com/pal1000/mesa-dist-win/issues/233.

:selectvcpp
@if %msvcpp% GTR 0 echo.
@if %msvcpp% GTR 0 call "%devroot%\%projectname%\bin\modules\prompt.cmd" selectvcpp "Enter choice:"
@if %msvcpp% GTR 0 IF "%selectvcpp%"=="" echo Invalid choice.
@if %msvcpp% GTR 0 IF "%selectvcpp%"=="" GOTO selectvcpp
@if %msvcpp% GTR 0 IF %selectvcpp% LEQ 0 echo Invalid choice.
@if %msvcpp% GTR 0 IF %selectvcpp% LEQ 0 GOTO selectvcpp
@if %msvcpp% GTR 0 IF %selectvcpp% GTR %msvcpp% echo Invalid choice.
@if %msvcpp% GTR 0 IF %selectvcpp% GTR %msvcpp% GOTO selectvcpp
@for /f %%a IN ("%selectvcpp%") DO @set msvcpp=!msvcpp[%%a]!
@endlocal&set msvcpp=%msvcpp%
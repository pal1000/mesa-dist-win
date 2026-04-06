@setlocal ENABLEDELAYEDEXPANSION
@set wdkcount=0
@set WDK_VER=
@for /f tokens^=* %%a IN ('dir /B /A^:D "%winsdkloc%\bin" 2^>nul') DO @IF EXIST "%winsdkloc%\include\%%a\um\d3d10umd*.h" (
@set /a wdkcount+=1
@if !wdkcount! EQU 1 echo Select Windows Driver Kit installation
@echo !wdkcount!. %%a
@set wdk[!wdkcount!]=%%a
)
@if %wdkcount% GTR 0 echo.

:selectwdk
@if %wdkcount% GTR 0 call "%devroot%\%projectname%\bin\modules\prompt.cmd" selectwdk "Enter choice:"
@if %wdkcount% GTR 0 set WDK_VER=!wdk[%selectwdk%]!
@endlocal&set WDK_VER=%WDK_VER%

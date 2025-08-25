@setlocal ENABLEDELAYEDEXPANSION
@set winsdkloc=null
@for /f tokens^=2* %%a IN ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Kits\Installed Roots" /v KitsRoot10 2^>nul ^| find "REG_"') DO @set winsdkloc=%%b
@if "%winsdkloc:~-1%"=="\" set winsdkloc=%winsdkloc:~0,-1%
@set winsdkcount=0
@set WINSDK_VER=
@for /f tokens^=* %%a IN ('dir /B /A^:D "%winsdkloc%\bin" 2^>nul') DO @IF EXIST "%winsdkloc%\include\%%a\um\Windows.h" (
@set /a winsdkcount+=1
@if !winsdkcount! EQU 1 echo Select Windows SDK installation
@echo !winsdkcount!. %%a
@set winsdk[!winsdkcount!]=%%a
)
@if %winsdkcount% GTR 0 echo.
@if %winsdkcount% GTR 1 echo Note: This wom't work with Meson Visual Studio backend - https://github.com/mesonbuild/meson/issues/3202
@if %winsdkcount% GTR 1 echo.

:selectwinsdk
@if %winsdkcount% GTR 0 call "%devroot%\%projectname%\bin\modules\prompt.cmd" selectwinsdk "Enter choice:"
@if %winsdkcount% GTR 0 IF NOT EXIST "%winsdkloc%\Include\!winsdk[%selectwinsdk%]!\um\Windows.h" GOTO selectwinsdk
@if %winsdkcount% GTR 0 set WINSDK_VER=!winsdk[%selectwinsdk%]!
@endlocal&set winsdkloc=%winsdkloc%&set WINSDK_VER=%WINSDK_VER%

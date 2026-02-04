@IF NOT defined botmode set botmode=0
@if NOT EXIST "%~dp0..\..\buildscript\bots\" md "%~dp0..\..\buildscript\bots"
@if %botmode% EQU 0 set /p %1=%~2
@setlocal ENABLEDELAYEDEXPANSION
@if %botmode% EQU 0 echo @set %1=!%1!>>"%~dp0..\..\buildscript\bots\bot-%bottimestamp%.cmd"
@if %botmode% EQU 1 IF NOT "!%1!"=="" echo %~2!%1!
@if %botmode% EQU 1 IF "!%1!"=="" echo WARNING: Variable '%1' is undefined in build bot configuration script.
@echo.

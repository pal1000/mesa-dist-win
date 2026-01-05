@IF NOT defined botmode set botmode=0
@if %botmode% EQU 0 set /p %1=%~2
@setlocal ENABLEDELAYEDEXPANSION
@if %botmode% EQU 1 IF NOT "!%1!"=="" echo %~2!%1!
@if %botmode% EQU 1 IF "!%1!"=="" echo WARNING: Variable '%1' is undefined in CI build configuration script.
@echo.

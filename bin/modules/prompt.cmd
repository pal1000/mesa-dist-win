@IF NOT defined cimode set cimode=0
@if %cimode% EQU 0 set /p %1=%~2
@setlocal ENABLEDELAYEDEXPANSION
@if %cimode% EQU 1 IF NOT "!%1!"=="" echo %~2!%1!
@echo.

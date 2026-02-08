@IF %botmode% EQU 0 set retrybld=1

:execbld
@set "ERRORLEVEL="
@CMD /C EXIT 0
@%*
@if "%ERRORLEVEL%"=="0" set retrybld=0
@echo.

:retrybld
@if "%retrybld%"=="1" call "%devroot%\%projectname%\bin\modules\prompt.cmd" retrybld "Number of build retries (0=end, 1=ask again, greater than 1 automatically retry n-1 times):"
@if "%retrybld%"=="1" GOTO retrybld
@if %retrybld% GTR 1 (
@set /a retrybld-=1
@GOTO execbld
)
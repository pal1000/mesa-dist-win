@IF %botmode% LEQ 0 set retrybld=1

@rem Assume vaon12 GCC build only suceeds on second try.
@IF %botmode% LEQ 0 IF %toolchain%==gcc set retrybld=2

:execbld
@set "ERRORLEVEL="
@CMD /C EXIT 0
@%*
@if "%ERRORLEVEL%"=="0" set retrybld=0
@echo.

:retrybld
@if "%retrybld%"=="1" IF %botmode% LEQ 0 call "%devroot%\%projectname%\bin\modules\prompt.cmd" retrybld "Number of build retries (0=end, 1=ask again, greater than 1 automatically retry n-1 times):"
@if "%retrybld%"=="1" IF %botmode% LEQ 0 GOTO retrybld
@if "%retrybld%"=="1" IF %botmode% GTR 0 set /a retrybld-=1
@if %retrybld% GTR 1 (
@set /a retrybld-=1
@GOTO execbld
)
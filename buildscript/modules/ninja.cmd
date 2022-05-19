@setlocal
@rem Ninja build system. Can have all states.
@set ninjastate=2
@CMD /C EXIT 0
@where /q ninja.exe
@if NOT "%ERRORLEVEL%"=="0" set ninjastate=1
@IF %ninjastate%==1 IF NOT EXIST "%devroot%\ninja\ninja.exe" set ninjastate=0
@endlocal&set ninjastate=%ninjastate%
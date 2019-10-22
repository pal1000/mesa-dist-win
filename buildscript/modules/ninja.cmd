@setlocal
@rem Ninja build system. Can have all states.
@set ninjastate=2
@SET ERRORLEVEL=0
@where /q ninja.exe
@IF ERRORLEVEL 1 set ninjastate=1
@IF %ninjastate%==1 IF NOT EXIST %mesa%\ninja\ninja.exe set ninjastate=0
@endlocal&set ninjastate=%ninjastate%
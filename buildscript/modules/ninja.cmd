@rem Ninja build system. Can have all states.
@SET ERRORLEVEL=0
@SET ninjaloc=ninja.exe
@set ninjastate=2
@where /q ninja.exe
@IF ERRORLEVEL 1 set ninjaloc=%mesa%\ninja\ninja.exe
@IF %ninjaloc%==%mesa%\ninja\ninja.exe set ninjastate=1
@IF %ninjastate%==1 IF NOT EXIST %ninjaloc% set ninjastate=0
@setlocal EnableDelayedExpansion
@rem Ninja build system. Can have all states.
@set ninjastate=1
@set mlpath=!PATH:;=^

!
@for /f tokens^=*^ eol^= %%a IN ("!mlpath!") DO @IF EXIST "%%~a\ninja.exe" set ninjastate=2
@IF %ninjastate%==1 IF NOT EXIST "%devroot%\ninja.exe" IF NOT EXIST "%devroot%\ninja\ninja.exe" set ninjastate=0
@endlocal&set ninjastate=%ninjastate%
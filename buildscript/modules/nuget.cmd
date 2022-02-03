@setlocal
@rem Nuget package manager CLI. Can have all states.
@set nugetstate=2
@CMD /C EXIT 0
@where /q nuget.exe
@if NOT "%ERRORLEVEL%"=="0" set nugetstate=1
@IF %nugetstate%==1 IF NOT EXIST %devroot%\nuget\nuget.exe set nugetstate=0
@endlocal&set nugetstate=%nugetstate%
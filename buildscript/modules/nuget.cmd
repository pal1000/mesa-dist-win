@setlocal
@rem Nuget package manager CLI. Can have all states.
@set nugetstate=2
@CMD /C EXIT 0
@where /q nuget.exe
@if NOT "%ERRORLEVEL%"=="0" set nugetstate=1
@set updnuget=n
@IF %nugetstate%==1 IF EXIST "%devroot%\nuget\nuget.exe" set /p updnuget=Update Nuget CLI tool (y/n):
@IF %nugetstate%==1 IF NOT EXIST "%devroot%\nuget\nuget.exe" echo Getting Nuget CLI tool...
@IF %nugetstate%==1 echo.
@if /I "%updnuget%"=="y" powershell -NoLogo "Invoke-WebRequest -Uri 'https://dist.nuget.org/win-x86-commandline/latest/nuget.exe' -OutFile '%devroot%\nuget\nuget.exe'" 2>nul
@IF %nugetstate%==1 IF NOT EXIST "%devroot%\nuget\" MD "%devroot%\nuget"
@IF %nugetstate%==1 IF NOT EXIST "%devroot%\nuget\nuget.exe" powershell -NoLogo "Invoke-WebRequest -Uri 'https://dist.nuget.org/win-x86-commandline/latest/nuget.exe' -OutFile '%devroot%\nuget\nuget.exe'" 2>nul
@IF %nugetstate%==1 IF NOT EXIST "%devroot%\nuget\nuget.exe" set nugetstate=0
@endlocal&set nugetstate=%nugetstate%
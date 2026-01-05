@setlocal
@set rhstate=2
@CMD /C EXIT 0
@where /q ResourceHacker.exe
@if NOT "%ERRORLEVEL%"=="0" set rhstate=1
@if %botmode% EQU 0 set updrh=n
@IF %rhstate%==1 IF EXIST "%devroot%\resource-hacker\ResourceHacker.exe" call "%devroot%\%projectname%\bin\modules\prompt.cmd" updrh "Update Resource Hacker (y/n):"
@IF %rhstate%==1 IF NOT EXIST "%devroot%\resource-hacker\" MD "%devroot%\resource-hacker"
@IF %rhstate%==1 IF NOT EXIST "%devroot%\resource-hacker\ResourceHacker.exe" echo Getting Resource Hacker...
@IF %rhstate%==1 IF NOT EXIST "%devroot%\resource-hacker\ResourceHacker.exe" set updrh=y
@IF %rhstate%==1 IF NOT EXIST "%%devroot%\resource-hacker\ResourceHacker.exe" echo.
@if /I "%updrh%"=="y" powershell -NoLogo "Invoke-WebRequest -Uri 'https://angusj.com/resourcehacker/resource_hacker.zip' -OutFile '%devroot%\%projectname%\buildscript\assets\resource_hacker.zip'" 2>nul
@if /I "%updrh%"=="y" IF EXIST "%devroot%\resource-hacker\ResourceHacker.exe" RD /S /Q "%devroot%\resource-hacker"
@if /I "%updrh%"=="y" IF EXIST "%devroot%\%projectname%\buildscript\assets\resource_hacker.zip" powershell -NoLogo "Expand-Archive -Path '%devroot%\%projectname%\buildscript\assets\resource_hacker.zip' -Destination '%devroot%\resource-hacker'" 2>nul
@if /I "%updrh%"=="y" IF EXIST "%devroot%\%projectname%\buildscript\assets\resource_hacker.zip" del "%devroot%\%projectname%\buildscript\assets\resource_hacker.zip"
@IF %rhstate%==1 IF NOT EXIST "%devroot%\resource-hacker\ResourceHacker.exe" set rhstate=0
@endlocal&set rhstate=%rhstate%
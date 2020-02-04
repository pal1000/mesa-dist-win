@setlocal
@set rhstate=2
@set ERRORLEVEL=0
@where /q ResourceHacker.exe
@IF ERRORLEVEL 1 set rhstate=1
@IF %rhstate%==1 IF NOT EXIST %devroot%\resource-hacker\ResourceHacker.exe set rhstate=0
@endlocal&set rhstate=%rhstate%
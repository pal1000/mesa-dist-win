@setlocal
@set rhstate=2
@CMD /C EXIT 0
@where /q ResourceHacker.exe
@if NOT "%ERRORLEVEL%"=="0" set rhstate=1
@IF %rhstate%==1 IF NOT EXIST %devroot%\resource-hacker\ResourceHacker.exe set rhstate=0
@endlocal&set rhstate=%rhstate%
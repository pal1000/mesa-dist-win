@setlocal
@rem winflexbison. Can have all states.
@set flexstate=2
@SET ERRORLEVEL=0
@where /q win_flex.exe
@IF ERRORLEVEL 1 set flexstate=1
@IF %flexstate%==1 IF NOT EXIST %devroot%\flexbison\win_flex.exe set flexstate=0
@endlocal&set flexstate=%flexstate%
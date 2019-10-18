@rem winflexbison. Can have all states.
@SET ERRORLEVEL=0
@SET flexloc=win_flex.exe
@set flexstate=2
@where /q win_flex.exe
@IF ERRORLEVEL 1 set flexloc=%mesa%\flexbison\win_flex.exe
@IF %flexloc%==%mesa%\flexbison\win_flex.exe set flexstate=1
@IF %flexstate%==1 IF NOT EXIST %flexloc% set flexstate=0
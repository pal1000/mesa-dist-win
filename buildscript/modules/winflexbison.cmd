@setlocal
@rem winflexbison. Can have all states.
@set flexstate=2
@CMD /C EXIT 0
@where /q win_flex.exe
@if NOT "%ERRORLEVEL%"=="0" set flexstate=1
@IF %flexstate%==1 IF NOT EXIST "%devroot%\flexbison\win_flex.exe" set flexstate=0
@endlocal&set flexstate=%flexstate%
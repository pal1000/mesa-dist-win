@setlocal
@rem flex and bison. Can have all states.
@set flexstate=2
@CMD /C EXIT 0
@where /q win_flex.exe
@if NOT "%ERRORLEVEL%"=="0" set flexstate=1
@set flexloc=%devroot%\flexbison
@IF %flexstate%==1 IF NOT EXIST "%devroot%\flexbison\win_flex.exe" set flexloc=%msysloc%\usr\bin
@IF %flexstate%==1 IF NOT EXIST "%devroot%\flexbison\win_flex.exe" IF NOT EXIST "%msysloc%\usr\bin\flex.exe" set flexstate=0
@endlocal&set flexstate=%flexstate%&set flexloc=%flexloc%
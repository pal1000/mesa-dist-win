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
@IF %flexstate%==1 IF "%flexloc%"=="%msysloc%\usr\bin" IF EXIST "%msysloc%\flexbison\" RD /S /Q "%msysloc%\flexbison"
@IF %flexstate%==1 IF "%flexloc%"=="%msysloc%\usr\bin" ROBOCOPY "%msysloc%\usr" "%msysloc%\flexbison" /E
@IF %flexstate%==1 IF "%flexloc%"=="%msysloc%\usr\bin" IF EXIST "%msysloc%\flexbison\bin\zstd.exe" del "%msysloc%\flexbison\bin\zstd.exe"
@IF %flexstate%==1 IF "%flexloc%"=="%msysloc%\usr\bin" set flexloc=%msysloc%\flexbison\bin
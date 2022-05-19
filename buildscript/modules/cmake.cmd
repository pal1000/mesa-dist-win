@setlocal
@rem CMake build generator. Can have all states.
@set cmakestate=2
@CMD /C EXIT 0
@where /q cmake.exe
@if NOT "%ERRORLEVEL%"=="0" set cmakestate=1
@IF %cmakestate%==1 IF NOT EXIST "%devroot%\cmake\bin\cmake.exe" set cmakestate=0
@endlocal&set cmakestate=%cmakestate%
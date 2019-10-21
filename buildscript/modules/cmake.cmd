@setlocal
@rem CMake build generator. Can have all states.
@set cmakestate=2
@SET ERRORLEVEL=0
@where /q cmake.exe
@IF ERRORLEVEL 1 set cmakestate=1
@IF %cmakestate%==1 IF NOT EXIST %mesa%\cmake\bin\cmake.exe set cmakestate=0
@endlocal&set cmakestate=%cmakestate%
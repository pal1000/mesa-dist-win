@rem CMake build generator. Can have all states.
@SET ERRORLEVEL=0
@SET cmakeloc=cmake.exe
@set cmakestate=2
@where /q cmake.exe
@IF ERRORLEVEL 1 set cmakeloc=%mesa%\cmake\bin\cmake.exe
@IF %cmakeloc%==%mesa%\cmake\bin\cmake.exe set cmakestate=1
@IF %cmakestate%==1 IF NOT EXIST %cmakeloc% set cmakestate=0
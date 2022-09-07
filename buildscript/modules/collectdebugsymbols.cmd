@set /p getdebuginfo=Collect debug symbols (y/n):
@echo.
@if /I "%getdebuginfo%"=="y" if EXIST "%devroot%\%projectname%\debug\%abi%\" RD /S /Q "%devroot%\%projectname%\debug\%abi%"
@if /I "%getdebuginfo%"=="y" IF %toolchain%==msvc MD "%devroot%\%projectname%\debug\%abi%"
@if /I "%getdebuginfo%"=="y" IF %toolchain%==msvc ROBOCOPY "%devroot%\mesa\build\%toolchain%-%abi%" "%devroot%\%projectname%\debug\%abi%" *.pdb /E
@if /I "%getdebuginfo%"=="y" IF NOT %toolchain%==msvc IF EXIST "%msysloc%\%LMSYSTEM%\bin\objcopy.exe" for /R "%devroot%\mesa\build\%toolchain%-%abi%\src" %%a IN (*.dll) do @IF EXIST "%%a" (
@echo Extracting debug information from %abi%\%%~nxa into %%~nxa-%abi%.debug...
@%runmsys% /%LMSYSTEM%/bin/objcopy.exe --only-keep-debug "%%a" "%devroot%\%projectname%\debug\%%~nxa-%abi%.debug"
@IF EXIST "%devroot%\%projectname%\bin\%abi%\%%~nxa" IF EXIST "%msysloc%\%LMSYSTEM%\bin\strip.exe" %runmsys% /%LMSYSTEM%/bin/strip -g "%devroot%\%projectname%\bin\%abi%\%%~nxa"
@IF EXIST "%devroot%\%projectname%\bin\%abi%\%%~nxa" %runmsys% /%LMSYSTEM%/bin/objcopy --add-gnu-debuglink=%%~nxa-%abi%.debug "%devroot%\%projectname%\bin\%abi%\%%~nxa"
)
@if /I "%getdebuginfo%"=="y" IF NOT %toolchain%==msvc IF EXIST "%msysloc%\%LMSYSTEM%\bin\objcopy.exe" for /R "%devroot%\mesa\build\%toolchain%-%abi%\src" %%a IN (*.exe) do @IF EXIST "%%a" (
@echo Extracting debug information from %abi%\%%~nxa into %%~nxa-%abi%.debug...
@%runmsys% /%LMSYSTEM%/bin/objcopy.exe --only-keep-debug "%%a" "%devroot%\%projectname%\debug\%%~nxa-%abi%.debug"
@IF EXIST "%devroot%\%projectname%\bin\%abi%\%%~nxa" IF EXIST "%msysloc%\%LMSYSTEM%\bin\strip.exe" %runmsys% /%LMSYSTEM%/bin/strip -g "%devroot%\%projectname%\bin\%abi%\%%~nxa"
@IF EXIST "%devroot%\%projectname%\bin\%abi%\%%~nxa" %runmsys% /%LMSYSTEM%/bin/objcopy --add-gnu-debuglink=%%~nxa-%abi%.debug "%devroot%\%projectname%\bin\%abi%\%%~nxa"
)
@echo.
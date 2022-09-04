@set /p getdebuginfo=Collect debug symbols (y/n):
@echo.
@if /I "%getdebuginfo%"=="y" if EXIST "%devroot%\%projectname%\debug\%abi%\" RD /S /Q "%devroot%\%projectname%\debug\%abi%"
@if /I "%getdebuginfo%"=="y" MD "%devroot%\%projectname%\debug\%abi%"
@if /I "%getdebuginfo%"=="y" IF %toolchain%==msvc ROBOCOPY "%devroot%\mesa\build\%toolchain%-%abi%" "%devroot%\%projectname%\debug\%abi%" *.pdb /E
@if /I "%getdebuginfo%"=="y" IF NOT %toolchain%==msvc IF EXIST "%msysloc%\%LMSYSTEM%\bin\objcopy.exe" for /R "%devroot%\mesa\build\%toolchain%-%abi%\src" %%a IN (*.dll) do @IF EXIST "%%a" (
@echo Extracting debug information from %%~nxa into %%~nxa.debug...
@%runmsys% /%LMSYSTEM%/bin/objcopy.exe --only-keep-debug "%%a" "%devroot%\%projectname%\debug\%abi%\%%~nxa.debug"
)
@if /I "%getdebuginfo%"=="y" IF NOT %toolchain%==msvc IF EXIST "%msysloc%\%LMSYSTEM%\bin\objcopy.exe" for /R "%devroot%\mesa\build\%toolchain%-%abi%\src" %%a IN (*.exe) do @IF EXIST "%%a" (
@echo Extracting debug information from %%~nxa into %%~nxa.debug...
@%runmsys% /%LMSYSTEM%/bin/objcopy.exe" --only-keep-debug "%%a" "%devroot%\%projectname%\debug\%abi%\%%~nxa.debug"
)
@echo.
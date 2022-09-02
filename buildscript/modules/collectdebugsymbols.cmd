@set /p getdebuginfo=Collect debug symbols (y/n):
@echo.
@if /I "%getdebuginfo%"=="y" if EXIST "%devroot%\%projectname%\debugsymbols\%abi%\" RD /S /Q "%devroot%\%projectname%\debugsymbols\%abi%"
@if /I "%getdebuginfo%"=="y" MD "%devroot%\%projectname%\debugsymbols\%abi%"
@if /I "%getdebuginfo%"=="y" IF %toolchain%==msvc ROBOCOPY "%devroot%\mesa\build\%toolchain%-%abi%" "%devroot%\%projectname%\debugsymbols\%abi%" *.pdb /E
@if /I "%getdebuginfo%"=="y" IF NOT %toolchain%==msvc IF EXIST "%msysloc%\%LMSYSTEM%\bin\objcopy.exe" for /R "%devroot%\mesa\build\%toolchain%-%abi%\src" %%a IN (*.dll) do @IF EXIST "%%a" (
@echo Extracting debug information from %%~nxa into %%~nxa.sym...
@%runmsys% /%LMSYSTEM%/bin/objcopy.exe --only-keep-debug "%%a" "%devroot%\%projectname%\debugsymbols\%abi%\%%~nxa.sym"
)
@if /I "%getdebuginfo%"=="y" IF NOT %toolchain%==msvc IF EXIST "%msysloc%\%LMSYSTEM%\bin\objcopy.exe" for /R "%devroot%\mesa\build\%toolchain%-%abi%\src" %%a IN (*.exe) do @IF EXIST "%%a" (
@echo Extracting debug information from %%~nxa into %%~nxa.sym...
@%runmsys% /%LMSYSTEM%/bin/objcopy.exe" --only-keep-debug "%%a" "%devroot%\%projectname%\debugsymbols\%abi%\%%~nxa.sym"
)
@echo.
@set /p getdebuginfo=Collect debug information (y/n):
@echo.
@if /I "%getdebuginfo%"=="y" if EXIST "%devroot%\%projectname%\debug\%abi%\" RD /S /Q "%devroot%\%projectname%\debug\%abi%"
@if /I "%getdebuginfo%"=="y" MD "%devroot%\%projectname%\debug\%abi%"
@if /I "%getdebuginfo%"=="y" IF %toolchain%==msvc ROBOCOPY "%devroot%\mesa\build\%toolchain%-%abi%" "%devroot%\%projectname%\debug\%abi%" *.pdb /E
@if /I "%getdebuginfo%"=="y" IF NOT %toolchain%==msvc for /R "%devroot%\mesa\build\%toolchain%-%abi%\src" %%a IN (*.dll) do @IF EXIST "%%a" (
@echo Moving debug binary %%~nxa to distinct location...
@IF EXIST "%devroot%\%projectname%\bin\%abi%\%%~nxa" MOVE "%devroot%\%projectname%\bin\%abi%\%%~nxa" "%devroot%\%projectname%\debug\%abi%\%%~nxa"
)
@if /I "%getdebuginfo%"=="y" IF NOT %toolchain%==msvc for /R "%devroot%\mesa\build\%toolchain%-%abi%\src" %%a IN (*.exe) do @IF EXIST "%%a" (
@echo Moving debug binary %%~nxa to distinct location...
@IF EXIST "%devroot%\%projectname%\bin\%abi%\%%~nxa" MOVE "%devroot%\%projectname%\bin\%abi%\%%~nxa" "%devroot%\%projectname%\debug\%abi%\%%~nxa"
)
@echo.
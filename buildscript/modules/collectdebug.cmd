@setlocal
@set /p getdebuginfo=Collect debug information (y/n):
@echo.
@if /I "%getdebuginfo%"=="y" IF /I NOT "%keeplastbuild%"=="y" if EXIST "%devroot%\%projectname%\debug\%abi%\" RD /S /Q "%devroot%\%projectname%\debug\%abi%"
@if /I "%getdebuginfo%"=="y" if NOT EXIST "%devroot%\%projectname%\debug\%abi%\" MD "%devroot%\%projectname%\debug\%abi%"
@if /I "%getdebuginfo%"=="y" IF %toolchain%==msvc ROBOCOPY "%devroot%\mesa\build\%toolchain%-%abi%" "%devroot%\%projectname%\debug\%abi%" *.pdb /E
@if /I "%getdebuginfo%"=="y" IF NOT %toolchain%==msvc IF EXIST "%devroot%\%projectname%\bin\%abi%\*.*" echo Moving debug binaries to distinct location...
@if /I "%getdebuginfo%"=="y" IF NOT %toolchain%==msvc IF EXIST "%devroot%\%projectname%\bin\%abi%\*.*" MOVE "%devroot%\%projectname%\bin\%abi%\*.*" "%devroot%\%projectname%\debug\%abi%\"
@if /I "%getdebuginfo%"=="y" echo.
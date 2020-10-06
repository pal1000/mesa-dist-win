@setlocal
@set abi=x86
@set /p x64=Do you want to build for x64? (y/n) Otherwise build for x86:
@echo.
@if /I "%x64%"=="y" set abi=x64

@rem Select MinGW shell based on ABI
@set MSYSTEM=MINGW64
@IF %abi%==x86 set MSYSTEM=MINGW32

@rem Select MSVC shell based on ABI
@set vsabi=%abi%
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF %abi%==x86 set vsabi=x64_x86
@IF /I %PROCESSOR_ARCHITECTURE%==x86 IF %abi%==x64 set vsabi=x86_x64

@set TITLE=%TITLE% targeting %abi%
@TITLE %TITLE%
@endlocal&set abi=%abi%&set vsabi=%vsabi%&set MSYSTEM=%MSYSTEM%&set TITLE=%TITLE%
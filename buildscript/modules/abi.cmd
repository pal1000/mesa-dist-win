@setlocal
@set abi=x86
@set /p x64=Do you want to build for x64? (y/n) Otherwise build for x86:
@echo.
@if /I "%x64%"=="y" set abi=x64

@rem Select MinGW shell based on ABI
@set MSYSTEM=MINGW64
@set LMSYSTEM=mingw64
@IF %abi%==x86 set MSYSTEM=MINGW32
@IF %abi%==x86 set LMSYSTEM=mingw32

@rem Select MSVC shell based on ABI
@set vsabi=%abi%
@IF /I %PROCESSOR_ARCHITECTURE%==x86 set hostabi=x86
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 set hostabi=x64
@IF NOT %abi%==%hostabi% set vsabi=%hostabi%_%abi%

@set TITLE=%TITLE% targeting %abi%
@TITLE %TITLE%
@endlocal&set abi=%abi%&set vsabi=%vsabi%&set hostabi=%hostabi%&set MSYSTEM=%MSYSTEM%&set LMSYSTEM=%LMSYSTEM%&set TITLE=%TITLE%
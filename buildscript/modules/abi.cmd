@setlocal
@set abi=x86
@set /p aarch64=Do you want to build for ARM64? (y/n) Otherwise build for x86:
@echo.
@if /I "%aarch64%"=="y" set abi=aarch64

@rem Select MinGW shell based on ABI
@IF %abi%==x64 set MSYSTEM=UCRT64
@IF %abi%==x64 set LMSYSTEM=ucrt64
@IF %abi%==x86 set MSYSTEM=MINGW32
@IF %abi%==x86 set LMSYSTEM=mingw32
@IF %abi%==aarch64 set MSYSTEM=CLANGARM64
@IF %abi%==aarch64 set LMSYSTEM=clangarm64

@rem Select MSVC shell based on ABI
@set vsabi=%abi%
@IF /I %PROCESSOR_ARCHITECTURE%==x86 set hostabi=x86
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 set hostabi=x64
@IF NOT %abi%==%hostabi% set vsabi=%hostabi%_%abi%

@set TITLE=%TITLE% targeting %abi%
@TITLE %TITLE%
@endlocal&set abi=%abi%&set vsabi=%vsabi%&set hostabi=%hostabi%&set MSYSTEM=%MSYSTEM%&set LMSYSTEM=%LMSYSTEM%&set TITLE=%TITLE%

@echo %abi%
@echo %MSYSTEM%
@echo %LMSYSTEM%
@echo %vsabi%
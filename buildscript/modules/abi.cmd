@setlocal
@set abi=x86
@echo Select CPU processor architecture to build for
@echo 1. x86 32-bit (Default)
@echo 2. x64 (x86 64-bit)
@if /I %PROCESSOR_ARCHITECTURE%==ARM64 echo 3. ARM64
@set /p cpuchoice=Enter choice:
@echo.
@if %cpuchoice% EQU 2 set abi=x64
@if %cpuchoice% EQU 3 set abi=aarch64

@rem Select MinGW shell based on ABI
@set MSYSTEM=UCRT64
@set LMSYSTEM=ucrt64
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

:cpuchoice
@if /I NOT %PROCESSOR_ARCHITECTURE%==X86 echo 1. x86 32-bit (Default)
@if /I NOT %PROCESSOR_ARCHITECTURE%==X86 echo 2. x64 (x86 64-bit)
@if /I %PROCESSOR_ARCHITECTURE%==ARM64 echo 3. ARM64
@if /I NOT %PROCESSOR_ARCHITECTURE%==X86 call "%~dp0prompt.cmd" cpuchoice "Enter choice:"
@set invalidcpuchoice=0
@if /I %PROCESSOR_ARCHITECTURE%==X86 set cpuchoice=1
@if /I %PROCESSOR_ARCHITECTURE%==AMD64 IF NOT "%cpuchoice%"=="1" IF NOT "%cpuchoice%"=="2" set invalidcpuchoice=1
@if /I %PROCESSOR_ARCHITECTURE%==ARM64 IF NOT "%cpuchoice%"=="1" IF NOT "%cpuchoice%"=="2" IF NOT "%cpuchoice%"=="3" set invalidcpuchoice=1
@if %invalidcpuchoice% EQU 1 echo Invalid choice.
@if %invalidcpuchoice% EQU 1 echo.
@if %invalidcpuchoice% EQU 1 GOTO cpuchoice
@set invalidcpuchoice=

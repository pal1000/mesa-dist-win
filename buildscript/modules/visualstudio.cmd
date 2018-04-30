@set abi=x86
@set /p x64=Do you want to build for x64? (y/n) Otherwise build for x86:
@echo.
@if /I "%x64%"=="y" set abi=x64
@set longabi=%abi%
@if %abi%==x64 set longabi=x86_64
@set vsabi=%abi%
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF %abi%==x86 set vsabi=x64_x86
@IF /I %PROCESSOR_ARCHITECTURE%==x86 IF %abi%==x64 set vsabi=x86_x64
@set vsenv="%ProgramFiles%
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 set vsenv=%vsenv% (x86)
@set vsenv=%vsenv%\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat"
@set toolset=0
@if EXIST %vsenv% set toolset=15
@if %toolset% EQU 0 (
@echo Error: No Visual Studio installed.
@pause
@exit
)
@set vsenv=%vsenv% %vsabi% %*
@TITLE Building Mesa3D %abi%
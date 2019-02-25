@set toolchain=msvc
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
@echo.
@pause
@exit
)

@set toolchain=msvc
@set vsabi=%abi%
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF %abi%==x86 set vsabi=x64_x86
@IF /I %PROCESSOR_ARCHITECTURE%==x86 IF %abi%==x64 set vsabi=x86_x64
@set vswhere="%ProgramFiles%
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 set vswhere=%vswhere% (x86)
@set vswhere=%vswhere%\Microsoft Visual Studio\Installer\vswhere.exe"
@if NOT EXIST %vswhere% (
@echo Error: No Visual Studio installed.
@echo.
@pause
@exit
)
@set vswhere=%vswhere% -prerelease -property installationPath
@set vs15c=null
@set vs15e=null
@set vs15p=null
@set vs15bc=null
@set vs15be=null
@set vs15bp=null
@set vs16bc=null
@set vs16be=null
@set vs16bp=null
@set vsenvfound=null
@FOR /F "tokens=* USEBACKQ" %%a IN (`%vswhere%`) DO @SET vsenvfound="%%~a"&&call :vswhere
@GOTO donevswhere

:vswhere
@IF /I "%vsenvfound:~-2,1%"=="y" IF "%vsenvfound:~-15,4%"=="2017" set vs15c=%vsenvfound%
@IF /I "%vsenvfound:~-2,1%"=="y" IF "%vsenvfound:~-15,4%"=="view" IF "%vsenvfound:~-23,4%"=="2017" set vs15bc=%vsenvfound%
@IF /I "%vsenvfound:~-2,1%"=="e" IF "%vsenvfound:~-16,4%"=="2017" set vs15e=%vsenvfound%
@IF /I "%vsenvfound:~-2,1%"=="e" IF "%vsenvfound:~-16,4%"=="view" IF "%vsenvfound:~-24,4%"=="2017" set vs15be=%vsenvfound%
@IF /I "%vsenvfound:~-2,1%"=="l" IF "%vsenvfound:~-18,4%"=="2017" set vs15p=%vsenvfound%
@IF /I "%vsenvfound:~-2,1%"=="l" IF "%vsenvfound:~-18,4%"=="view" IF "%vsenvfound:~-26,4%"=="2017" set vs15bp=%vsenvfound%
@IF /I "%vsenvfound:~-2,1%"=="y" IF "%vsenvfound:~-15,4%"=="view" IF "%vsenvfound:~-23,4%"=="2019" set vs16bc=%vsenvfound%
@IF /I "%vsenvfound:~-2,1%"=="e" IF "%vsenvfound:~-16,4%"=="view" IF "%vsenvfound:~-24,4%"=="2019" set vs16be=%vsenvfound%
@IF /I "%vsenvfound:~-2,1%"=="l" IF "%vsenvfound:~-18,4%"=="view" IF "%vsenvfound:~-26,4%"=="2019" set vs16bp=%vsenvfound%

:donevswhere
@set vsenv=%vs15c:~0,-1%\VC\Auxiliary\Build\vcvarsall.bat"
@set toolset=0
@if EXIST %vsenv% set toolset=15

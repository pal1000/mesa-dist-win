@rem Find vswhere tool.
@set toolchain=msvc
@set vsabi=%abi%
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF %abi%==x86 set vsabi=x64_x86
@IF /I %PROCESSOR_ARCHITECTURE%==x86 IF %abi%==x64 set vsabi=x86_x64
@set vswhere="%ProgramFiles%
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 set vswhere=%vswhere% (x86)
@set vswhere=%vswhere%\Microsoft Visual Studio\Installer\vswhere.exe" -prerelease -property

:findcompilers
@set vsenv=%vswhere%
@set totaltoolchains=0
@set totalmsvc=0
@for /F "USEBACKQ tokens=*" %%a IN (`%vswhere% catalog_productDisplayVersion`) do @set /a totalmsvc+=1
@IF NOT %msysstate%==0 set /a totaltoolchains=%totalmsvc%+1
@cls
@setlocal ENABLEDELAYEDEXPANSION
@set msvccount=0
@for /F "USEBACKQ tokens=*" %%a IN (`%vswhere% catalog_productDisplayVersion`) do @set /a msvccount+=1&echo !msvccount!. Visual Studio %%a
@endlocal
@IF NOT %msysstate%==0 echo %totaltoolchains%. MSYS2 Mingw-w64 GCC
@echo.
@IF %totaltoolchains%==0 (
@echo Error: No compiler found. Cannot continue.
@echo.
@pause
@exit
)

@rem Select compiler
@set selecttoolchain=0
@set toolset=0
@set /p selecttoolchain=Select compiler:
@echo.
@IF "%selecttoolchain%"=="%totaltoolchains%" IF NOT %msysstate%==0 (
@set toolchain=gcc
@GOTO selectedcompiler
)
@IF %selecttoolchain% LEQ 0 (
@echo Invalid entry
@pause
@GOTO findcompilers
)
@IF %selecttoolchain% GTR %totaltoolchains% (
@echo Invalid entry
@pause
@GOTO findcompilers
)

@rem Determine toolset version and build enviroment launcher PATH for selected Visual Studio installation
@setlocal ENABLEDELAYEDEXPANSION
@set msvccount=0
@for /F "USEBACKQ tokens=*" %%a IN (`%vswhere% installationPath`) do @set /a msvccount+=1&IF !msvccount!==%selecttoolchain% set vsenv="%%a\VC\Auxiliary\Build\vcvarsall.bat"
@set msvccount=0
@for /F "USEBACKQ tokens=*" %%a IN (`%vswhere% catalog_productDisplayVersion`) do @set /a msvccount+=1&IF !msvccount!==%selecttoolchain% set toolset=%%a
@set toolset=%toolset:~0,2%
@endlocal&set vsenv=%vsenv%&set toolset=%toolset%

:novcpp
@IF NOT EXIST %vsenv% echo Error: Selected Visual Studio installation lacks Desktop Development with C++ workload necesarry to build Mesa3D.
@IF NOT EXIST %vsenv% set /p addvcpp=Add Development with C++ workload - y/n:
@IF NOT EXIST %vsenv% echo.
@IF NOT EXIST %vsenv% IF /I NOT "%addvcpp%"=="y" pause
@IF NOT EXIST %vsenv% IF /I NOT "%addvcpp%"=="y" GOTO findcompilers
@IF NOT EXIST %vsenv% %vswhere:~0,-34%vs_installer.exe"
@IF NOT EXIST %vsenv% GOTO findcompilers

:selectedcompiler
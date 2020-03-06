@setlocal ENABLEDELAYEDEXPANSION
@rem Find vswhere tool.
@set toolchain=msvc
@set msvcver=null
@set msvcname=null
@set vsabi=%abi%
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF %abi%==x86 set vsabi=x64_x86
@IF /I %PROCESSOR_ARCHITECTURE%==x86 IF %abi%==x64 set vsabi=x86_x64
@set vswhere="%ProgramFiles%
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 set vswhere=%vswhere% (x86)
@set vswhere=%vswhere%\Microsoft Visual Studio\Installer\vswhere.exe"

:findcompilers
@set vsenv=null
@set toolset=0

@set totaltoolchains=0
@set totalmsvc=0
@IF EXIST %vswhere% for /F "USEBACKQ tokens=*" %%a IN (`%vswhere% -prerelease -property catalog_productDisplayVersion`) do @set /a totalmsvc+=1&set /a totaltoolchains+=1&set msvcversions[!totalmsvc!]=%%a
@IF NOT %msysstate%==0 set /a totaltoolchains+=1
@set msvccount=0
@IF EXIST %vswhere% for /F "USEBACKQ tokens=*" %%a IN (`%vswhere% -prerelease -property displayName`) do @set /a msvccount+=1&set msvcnames[!msvccount!]=%%a
@cls
@echo Available compilers
@IF %totalmsvc% GTR 0 FOR /L %%a IN (1,1,%totalmsvc%) do @echo %%a.!msvcnames[%%a]! v!msvcversions[%%a]!
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
@set /p selecttoolchain=Select compiler:
@echo.
@IF "%selecttoolchain%"=="%totaltoolchains%" IF NOT %msysstate%==0 (
@set toolchain=gcc
@GOTO selectedgcc
)
@set validtoolchain=1
@IF "%selecttoolchain%"=="" (
@echo Invalid entry
@pause
@GOTO findcompilers
)
@IF %selecttoolchain% LEQ 0 set validtoolchain=0
@IF %selecttoolchain% GTR %totaltoolchains% set validtoolchain=0
@IF %validtoolchain%==0 (
@echo Invalid entry
@pause
@GOTO findcompilers
)

@rem Determine version and build enviroment launcher PATH for selected Visual Studio installation
@set msvccount=0
@for /F "USEBACKQ tokens=*" %%a IN (`%vswhere% -prerelease -property installationPath`) do @set /a msvccount+=1&IF !msvccount!==%selecttoolchain% set vsenv="%%a\VC\Auxiliary\Build\vcvarsall.bat"
@FOR /L %%a IN (1,1,%totalmsvc%) do @IF "%%a"=="%selecttoolchain%" set msvcname=!msvcnames[%%a]!&IF "%%a"=="%selecttoolchain%" set msvcver=!msvcversions[%%a]!

:novcpp
@IF NOT EXIST %vsenv% echo Error: Selected Visual Studio installation lacks Desktop development with C++ workload necessary to build Mesa3D.
@IF NOT EXIST %vsenv% set /p addvcpp=Add Desktop development with C++ workload - y/n:
@IF NOT EXIST %vsenv% echo.
@IF NOT EXIST %vsenv% IF /I NOT "%addvcpp%"=="y" pause
@IF NOT EXIST %vsenv% IF /I NOT "%addvcpp%"=="y" GOTO findcompilers
@IF NOT EXIST %vsenv% %vswhere:~0,-12%vs_installer.exe"
@IF NOT EXIST %vsenv% GOTO findcompilers

:selectedmsvc
@set TITLE=%TITLE% using Visual Studio
@set toolset=%msvcver:~0,2%
@GOTO selectedcompiler

:selectedgcc
@set TITLE=%TITLE% using MSYS2 Mingw-w64 GCC

:selectedcompiler
@TITLE %TITLE%
@endlocal&set toolchain=%toolchain%&set vsabi=%vsabi%&set vsenv=%vsenv%&set toolset=%toolset%&set msvcname=%msvcname%&set msvcver=%msvcver%&set TITLE=%TITLE%
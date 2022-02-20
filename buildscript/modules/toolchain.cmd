@setlocal ENABLEDELAYEDEXPANSION
@rem Find vswhere tool.
@set toolchain=msvc
@set msvcver=null
@set msvcname=null
@set vswhere="%ProgramFiles%
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 set vswhere=%vswhere% (x86)
@set vswhere=%vswhere%\Microsoft Visual Studio\Installer\vswhere.exe"

:findcompilers
@set vsenv=null
@set toolset=0
@set totaltoolchains=0
@set totalmsvc=0
@IF EXIST %vswhere% for /F "USEBACKQ tokens=*" %%a IN (`%vswhere% -prerelease -products * -property catalog_productDisplayVersion 2^>^&1`) do @(
set /a totalmsvc+=1
set /a totaltoolchains+=1
set msvcversions[!totalmsvc!]=%%a
)
@IF NOT %msysstate%==0 set /a totaltoolchains+=1
@IF %totaltoolchains%==0 (
@echo Error: No compiler found. Cannot continue.
@echo.
@pause
@exit
)
@set msvccount=0
@IF EXIST %vswhere% for /F "USEBACKQ tokens=*" %%a IN (`%vswhere% -prerelease -products * -property displayName 2^>^&1`) do @(
set /a msvccount+=1
set msvcnames[!msvccount!]=%%a
)
@cls
@echo Available compile toolchains
@IF %totalmsvc% GTR 0 FOR /L %%a IN (1,1,%totalmsvc%) do @echo %%a.!msvcnames[%%a]! v!msvcversions[%%a]!
@IF NOT %msysstate%==0 echo %totaltoolchains%. MSYS2 Mingw-w64
@echo.

@rem Select toolchain
@set selecttoolchain=0
@set /p selecttoolchain=Select toolchain:
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
@for /F "USEBACKQ tokens=*" %%a IN (`%vswhere% -prerelease -products * -property installationPath 2^>^&1`) do @(
set /a msvccount+=1
IF !msvccount!==%selecttoolchain% set vsenv="%%a\VC\Auxiliary\Build\vcvarsall.bat"
)
@FOR /L %%a IN (1,1,%totalmsvc%) do @(
IF "%%a"=="%selecttoolchain%" set msvcname=!msvcnames[%%a]!
IF "%%a"=="%selecttoolchain%" set msvcver=!msvcversions[%%a]!
)

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
@set TITLE=%TITLE% using MSYS2 Mingw-w64
@GOTO selectedcompiler

:selectedcompiler
@TITLE %TITLE%
@endlocal&set toolchain=%toolchain%&set vsenv=%vsenv%&set toolset=%toolset%&set msvcname=%msvcname%&set msvcver=%msvcver%&set TITLE=%TITLE%
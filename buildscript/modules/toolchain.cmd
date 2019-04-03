@set toolchain=msvc
@set vsabi=%abi%
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF %abi%==x86 set vsabi=x64_x86
@IF /I %PROCESSOR_ARCHITECTURE%==x86 IF %abi%==x64 set vsabi=x86_x64
@set vsenv="%ProgramFiles%
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 set vsenv=%vsenv% (x86)
@set vsenv=%vsenv%\Microsoft Visual Studio

:selectcompiler
@set toolchains=20000000
@echo Select compiler
@echo ---------------
@IF EXIST %vsenv%\2017\Community" echo 1. Visual Studio 2017 Community
@IF EXIST %vsenv%\2017\Community" set /a toolchains=%toolchains%+1000000
@IF EXIST %vsenv%\2017\Professional" echo 2. Visual Studio 2017 Professional
@IF EXIST %vsenv%\2017\Professional" set /a toolchains=%toolchains%+100000
@IF EXIST %vsenv%\2017\Enterprise" echo 3. Visual Studio 2017 Enterprise
@IF EXIST %vsenv%\2017\Enterprise" set /a toolchains=%toolchains%+10000
@IF EXIST %vsenv%\2019\Community" echo 4. Visual Studio 2019 Community
@IF EXIST %vsenv%\2019\Community" set /a toolchains=%toolchains%+1000
@IF EXIST %vsenv%\2019\Professional" echo 5. Visual Studio 2019 Professional
@IF EXIST %vsenv%\2019\Professional" set /a toolchains=%toolchains%+100
@IF EXIST %vsenv%\2019\Enterprise" echo 6. Visual Studio 2019 Enterprise
@IF EXIST %vsenv%\2019\Enterprise" set /a toolchains=%toolchains%+10
@IF NOT %msysstate%==0 echo 7. MSYS2 Mingw-w64 GCC
@IF NOT %msysstate%==0 set /a toolchains=%toolchains%+1
@if %toolchains%==20000000 (
@echo Error: No compiler found. Cannot continue.
@echo.
@pause
@exit
)
@set selecttoolchain=0
@set toolset=0
@set /p selecttoolchain=Select compiler:
@echo.
@IF "%selecttoolchain%"=="1" IF %toolchains:~1,1%==1 set vsenv=%vsenv%\2017\Community\VC\Auxiliary\Build\vcvarsall.bat"&&set toolset=15&&GOTO selectedcompiler
@IF "%selecttoolchain%"=="2" IF %toolchains:~2,1%==1 set vsenv=%vsenv%\2017\Professional\VC\Auxiliary\Build\vcvarsall.bat"&&set toolset=15&&GOTO selectedcompiler
@IF "%selecttoolchain%"=="3" IF %toolchains:~3,1%==1 set vsenv=%vsenv%\2017\Enterprise\VC\Auxiliary\Build\vcvarsall.bat"&&set toolset=15&&GOTO selectedcompiler
@IF "%selecttoolchain%"=="4" IF %toolchains:~4,1%==1 set vsenv=%vsenv%\2019\Community\VC\Auxiliary\Build\vcvarsall.bat"&&set toolset=16&&GOTO selectedcompiler
@IF "%selecttoolchain%"=="5" IF %toolchains:~5,1%==1 set vsenv=%vsenv%\2019\Professional\VC\Auxiliary\Build\vcvarsall.bat"&&set toolset=16&&GOTO selectedcompiler
@IF "%selecttoolchain%"=="6" IF %toolchains:~6,1%==1 set vsenv=%vsenv%\2019\Enterprise\VC\Auxiliary\Build\vcvarsall.bat"&&set toolset=16&&GOTO selectedcompiler
@IF "%selecttoolchain%"=="7" IF %toolchains:~7,1%==1 set toolchain=gcc&&GOTO selectedcompiler
@echo Invalid entry
@pause
@cls
@GOTO selectcompiler

:selectedcompiler
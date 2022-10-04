@cd /d "%~dp0"
@cd ..\..\..\
@set format=pythonlist
@set llvmmodules=engine coroutines
@set CD=
@set devroot=%CD%
@IF %devroot:~0,1%%devroot:~-1%=="" set devroot=%devroot:~1,-1%
@IF "%devroot:~-1%"=="\" set devroot=%devroot:~0,-1%
@call "%devroot%\mesa-dist-win\buildscript\modules\selectllvm.cmd"
@IF NOT EXIST "%llvminstloc%\" GOTO error
@cd %llvminstloc%
@if NOT EXIST x64 if NOT EXIST x86 GOTO error
@if EXIST x64 cd x64
@if EXIST x86 cd x86

:writedebugoutput
@IF NOT EXIST bin GOTO error
@cd bin
@if EXIST "%devroot%\mesa-dist-win\debug\llvm-config-old.txt" del "%devroot%\mesa-dist-win\debug\llvm-config-old.txt"
@if EXIST "%devroot%\mesa-dist-win\debug\llvm-config.txt" REN "%devroot%\mesa-dist-win\debug\llvm-config.txt" llvm-config-old.txt
@set "llvmlibs="
@setlocal ENABLEDELAYEDEXPANSION
@FOR /F delims^=^ eol^= %%a IN ('llvm-config --link-static --libnames %llvmmodules% 2^>^&1') DO @(
SET libname=%%~na
IF NOT "!libname:~0,5!"=="llvm-" SET llvmlibs=!llvmlibs! !libname!
)
@endlocal&set llvmlibs=%llvmlibs:~1%
@set llvmlibs=%llvmlibs:.lib=%
@IF %format%==pythonlist set llvmlibs='%llvmlibs: =', '%'
@if %format%==ninjatargets set llvmlibs=install-%llvmlibs: = install-%
@echo LLVM config output updated.
@echo %llvmlibs%>"%devroot%\mesa-dist-win\debug\llvm-config.txt"
@GOTO finished

:error
@echo LLVM is not built yet. Cannot determine required libraries for requested configuration.

:finished
@pause
@"%devroot%\mesa-dist-win\debug\llvm-config.txt"
@exit
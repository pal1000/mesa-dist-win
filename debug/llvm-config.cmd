@cd ../../
@set format=pythonlist
@set llvmmodules=engine coroutines
@for %%a in ("%cd%") do @set mesa=%%~sa
@IF NOT EXIST llvm GOTO error
@cd llvm
@if NOT EXIST x64 if NOT EXIST x86 GOTO error
@if EXIST x64 cd x64
@if EXIST x86 cd x86

:writedebugoutput
@IF NOT EXIST bin GOTO error
@cd bin
@if EXIST %mesa%\mesa-dist-win\debug\llvm-config-old.txt del %mesa%\mesa-dist-win\debug\llvm-config-old.txt
@if EXIST %mesa%\mesa-dist-win\debug\llvm-config.txt REN %mesa%\mesa-dist-win\debug\llvm-config.txt llvm-config-old.txt
@set llvmlibs=
@setlocal ENABLEDELAYEDEXPANSION
@FOR /F "tokens=* USEBACKQ" %%a IN (`llvm-config --libnames %llvmmodules% 2^>^&1`) DO @SET libname=%%~na&IF NOT "!libname:~0,5!"=="llvm-" SET llvmlibs=!llvmlibs! !libname!
@endlocal&set llvmlibs=%llvmlibs:~1%
@set llvmlibs=%llvmlibs:.lib=%
@IF %format%==pythonlist set llvmlibs='%llvmlibs: =', '%'
@if %format%==ninjatargets set llvmlibs=install-%llvmlibs: = install-%
@echo LLVM config output updated.
@echo %llvmlibs%>%mesa%\mesa-dist-win\debug\llvm-config.txt
@GOTO finished

:error
@echo LLVM is not built yet. Cannot determine required libraries for requested configuration.

:finished
@pause
@%mesa%\mesa-dist-win\debug\llvm-config.txt
@exit
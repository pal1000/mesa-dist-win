@cd ../../
@set llvmlink=MT
@set llvmmeson=engine
@set llvmscons=engine irreader
@set format=pythonlist
@set compiler=%llvmscons%
@for %%a in ("%cd%") do @set mesa=%%~sa
@IF NOT EXIST llvm GOTO error
@cd llvm
@if NOT EXIST x64-%llvmlink% if NOT EXIST x86-%llvmlink% GOTO error
@if EXIST x64-%llvmlink% cd x64-%llvmlink%
@if EXIST x86-%llvmlink% cd x86-%llvmlink%

:writedebugoutput
@IF NOT EXIST bin GOTO error
@set skipper=
@IF NOT EXIST lib set skipper=skip=1 
@cd bin
@if EXIST %mesa%\mesa-dist-win\debug\llvm-config-old.txt del %mesa%\mesa-dist-win\debug\llvm-config-old.txt
@if EXIST %mesa%\mesa-dist-win\debug\llvm-config.txt REN %mesa%\mesa-dist-win\debug\llvm-config.txt llvm-config-old.txt
@set llvmlibs=
@setlocal ENABLEDELAYEDEXPANSION
@FOR /F "tokens=* %skipper%USEBACKQ" %%a IN (`llvm-config --libnames %compiler% 2^>^&1`) DO @SET llvmlibs=!llvmlibs! %%~na
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
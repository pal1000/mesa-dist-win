@cd ../../
@set llvmlink=mt
@set llvmmeson=bitwriter engine mcdisassembler mcjit
@set llvmscons=engine mcjit bitwriter x86asmprinter irreader
@set llvm7=bitwriter engine mcdisassembler mcjit ipo objcarcopts
@for %%a in ("%cd%") do @set mesa=%%~sa
@IF NOT EXIST llvm GOTO error
@cd llvm
@if NOT EXIST x64-%llvmlink% if NOT EXIST x86-%llvmlink% GOTO error
@if EXIST x64-%llvmlink% cd x64-%llvmlink%
@if EXIST x86-%llvmlink% cd x86-%llvmlink%

:writedebugoutput
@IF NOT EXIST bin GOTO error
@cd bin
@if EXIST %mesa%\mesa-dist-win\debug\llvm-config-old.txt del %mesa%\mesa-dist-win\debug\llvm-config-old.txt
@if EXIST %mesa%\mesa-dist-win\debug\llvm-config.txt REN %mesa%\mesa-dist-win\debug\llvm-config.txt llvm-config-old.txt
@FOR /F "tokens=* USEBACKQ" %%b IN (`llvm-config --libnames %llvm7%`) DO @SET llvmlibs=%%~b
@set llvmlibs=%llvmlibs:.lib=%
@set llvmlibs='%llvmlibs: =', '%'
@echo LLVM config output updated.
@echo %llvmlibs% > %mesa%\mesa-dist-win\debug\llvm-config.txt
@GOTO finished

:error
@echo LLVM is not built yet. Cannot determine required libraries for requested configuration.

:finished
@pause
@%mesa%\mesa-dist-win\debug\llvm-config.txt
@exit
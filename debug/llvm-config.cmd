@cd ../../
@for %%a in ("%cd%") do @set mesa=%%~sa
@IF NOT EXIST llvm GOTO error
@cd llvm
@if EXIST x64 (
@cd x64
@GOTO writedebugoutput
)
@if EXIST x86 (
@cd x86
@GOTO writedebugoutput
)
@GOTO error

:writedebugoutput
@IF EXIST bin (
@cd bin
@if EXIST %mesa%\mesa-dist-win\debug\llvm-config-old.txt del %mesa%\mesa-dist-win\debug\llvm-config-old.txt
@if EXIST %mesa%\mesa-dist-win\debug\llvm-config.txt REN %mesa%\mesa-dist-win\debug\llvm-config.txt %mesa%\mesa-dist-win\debug\llvm-config-old.txt
@llvm-config --libs engine mcjit bitwriter x86asmprinter irreader > %mesa%\mesa-dist-win\debug\llvm-config.txt
@echo LLVM config output updated.
@GOTO finished
)

:error
@echo LLVM is not built yet. Cannot determine required libraries for requested configuration.

:finished
@pause
@exit
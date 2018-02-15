@if EXIST llvm-config-old.txt del llvm-config-old.txt
@if EXIST llvm-config.txt REN llvm-config.txt llvm-config-old.txt
@cd ../../
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
@llvm-config --libs engine mcjit bitwriter x86asmprinter irreader > "..\..\..\mesa-dist-win\debug\llvm-config.txt"
@echo LLVM config output updated.
@GOTO finished
)

:error
@echo LLVM is not built yet. Cannot determine required libraries for requested configuration.

:finished
@pause
@exit
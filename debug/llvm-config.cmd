@cd ../../llvm
@if EXIST x64 (
@cd x64
@GOTO writedebugoutput
)
@if EXIST x86 (
@cd x86
@GOTO writedebugoutput
)

:writedebugoutput
@cd bin
@del "..\..\..\mesa-dist-win\debug\llvm-config.txt"
@llvm-config --libs engine mcjit bitwriter x86asmprinter irreader > "..\..\..\mesa-dist-win\debug\llvm-config.txt"
@echo LLVM config output updated
@pause
@exit
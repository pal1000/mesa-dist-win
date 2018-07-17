@FOR /F "tokens=* USEBACKQ" %%n IN (`%mesa%\llvm\%abi%\bin\llvm-config --libs engine mcjit bitwriter x86asmprinter irreader`) DO @SET llvmlibs=%%~n
@FOR /F "tokens=* USEBACKQ" %%o IN (`%mesa%\llvm\%abi%\bin\llvm-config --version`) DO @SET llvmver=%%~o
@set llvmlibs='%llvmlibs:.lib=',%
@set llvmlibs=%llvmlibs:~0,-1%
@IF NOT EXIST %mesa%\mesa\subprojects\llvm md %mesa%\mesa\subprojects\llvm
@echo project('llvm', ['cpp']) > %mesa%\mesa\subprojects\llvm\meson.build
@echo. >> %mesa%\mesa\subprojects\llvm\meson.build
@echo cpp = meson.get_compiler('cpp') >> %mesa%\mesa\subprojects\llvm\meson.build
@echo. >> %mesa%\mesa\subprojects\llvm\meson.build
@echo _deps = [] >> %mesa%\mesa\subprojects\llvm\meson.build
@echo _deps += cpp.find_library([%llvmlibs%]) >> %mesa%\mesa\subprojects\llvm\meson.build
@echo. >> %mesa%\mesa\subprojects\llvm\meson.build
@echo ext_llvm = declare_dependency( >> %mesa%\mesa\subprojects\llvm\meson.build
@echo   include_directories : include_directories('%mesa%\llvm\%abi%\include')), >> %mesa%\mesa\subprojects\llvm\meson.build
@echo   dependencies : _deps, >> %mesa%\mesa\subprojects\llvm\meson.build
@echo   version : '%llvmver%', >> %mesa%\mesa\subprojects\llvm\meson.build
@echo ) >> %mesa%\mesa\subprojects\llvm\meson.build
@echo. >> %mesa%\mesa\subprojects\llvm\meson.build
@echo irbuilder_h = files('%mesa%\llvm\%abi%\include\llvm\IR\IRBuilder.h') >> %mesa%\mesa\subprojects\llvm\meson.build
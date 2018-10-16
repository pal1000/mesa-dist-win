@FOR /F "tokens=* USEBACKQ" %%n IN (`%mesa%\llvm\%abi%-%llvmlink%\bin\llvm-config --libnames bitwriter engine mcdisassembler mcjit`) DO @SET llvmlibs=%%~n
@FOR /F "tokens=* USEBACKQ" %%o IN (`%mesa%\llvm\%abi%-%llvmlink%\bin\llvm-config --version`) DO @SET llvmver=%%~o
@set llvmlibs=%llvmlibs:.lib=%
@set llvmlibs='%llvmlibs: =', '%'
@IF NOT EXIST %mesa%\mesa\subprojects\llvm md %mesa%\mesa\subprojects\llvm
@echo project('llvm', ['cpp']) > %mesa%\mesa\subprojects\llvm\meson.build
@echo. >> %mesa%\mesa\subprojects\llvm\meson.build
@echo cpp = meson.get_compiler('cpp') >> %mesa%\mesa\subprojects\llvm\meson.build
@echo. >> %mesa%\mesa\subprojects\llvm\meson.build
@echo _deps = [] >> %mesa%\mesa\subprojects\llvm\meson.build
@echo _search = '%LLVM:\=/%/lib' >> %mesa%\mesa\subprojects\llvm\meson.build
@echo foreach d : [%llvmlibs%] >> %mesa%\mesa\subprojects\llvm\meson.build
@echo   _deps += cpp.find_library(d, dirs : _search) >> %mesa%\mesa\subprojects\llvm\meson.build
@echo endforeach >> %mesa%\mesa\subprojects\llvm\meson.build
@echo. >> %mesa%\mesa\subprojects\llvm\meson.build
@echo ext_llvm = declare_dependency( >> %mesa%\mesa\subprojects\llvm\meson.build
@echo   include_directories : include_directories('%LLVM:\=/%/include'), >> %mesa%\mesa\subprojects\llvm\meson.build
@echo   dependencies : _deps, >> %mesa%\mesa\subprojects\llvm\meson.build
@echo   version : '%llvmver%', >> %mesa%\mesa\subprojects\llvm\meson.build
@echo ) >> %mesa%\mesa\subprojects\llvm\meson.build
@echo. >> %mesa%\mesa\subprojects\llvm\meson.build
@echo irbuilder_h = files('%LLVM:\=/%/include/llvm/IR/IRBuilder.h') >> %mesa%\mesa\subprojects\llvm\meson.build
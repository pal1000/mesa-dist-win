@setlocal
@IF %toolchain%==msvc FOR /F "tokens=* USEBACKQ" %%a IN (`%LLVM%\bin\llvm-config --libnames engine coroutines`) DO @SET llvmlibs=%%~a
@IF %toolchain%==msvc FOR /F "tokens=* USEBACKQ" %%a IN (`%LLVM%\bin\llvm-config --version`) DO @SET llvmver=%%~a
@IF %toolchain%==gcc FOR /F "tokens=* USEBACKQ" %%a IN (`%msysloc%\usr\bin\bash --login -c "%LLVM%/bin/llvm-config --libnames engine coroutines"`) DO @SET llvmlibs=%%~a
@IF %toolchain%==gcc FOR /F "tokens=* USEBACKQ" %%a IN (`%msysloc%\usr\bin\bash --login -c "%LLVM%/bin/llvm-config --version"`) DO @SET llvmver=%%~a
@IF %toolchain%==gcc set llvmlibs=%llvmlibs:.a=%
@IF %toolchain%==msvc set llvmlibs=%llvmlibs:.lib=%
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
@echo dep_llvm = declare_dependency( >> %mesa%\mesa\subprojects\llvm\meson.build
@echo   include_directories : include_directories('%LLVM:\=/%/include'), >> %mesa%\mesa\subprojects\llvm\meson.build
@echo   dependencies : _deps, >> %mesa%\mesa\subprojects\llvm\meson.build
@echo   version : '%llvmver%', >> %mesa%\mesa\subprojects\llvm\meson.build
@echo ) >> %mesa%\mesa\subprojects\llvm\meson.build
@echo. >> %mesa%\mesa\subprojects\llvm\meson.build
@echo has_rtti = true >> %mesa%\mesa\subprojects\llvm\meson.build
@echo irbuilder_h = files('%LLVM:\=/%/include/llvm/IR/IRBuilder.h') >> %mesa%\mesa\subprojects\llvm\meson.build
@endlocal
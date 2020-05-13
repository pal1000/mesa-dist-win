@setlocal
@set RTTI=false
@IF %toolchain%==msvc FOR /F "tokens=* USEBACKQ" %%a IN (`%devroot%\llvm\%abi%\bin\llvm-config --link-static --libnames engine coroutines`) DO @SET llvmlibs=%%~a
@IF %toolchain%==msvc FOR /F "tokens=* USEBACKQ" %%a IN (`%devroot%\llvm\%abi%\bin\llvm-config --version`) DO @SET llvmver=%%~a
@IF %toolchain%==msvc FOR /F "tokens=* USEBACKQ" %%a IN (`%devroot%\llvm\%abi%\bin\llvm-config --has-rtti`) DO @IF /I "%%a"=="YES" SET RTTI=true
@IF NOT %toolchain%==msvc FOR /F "tokens=* USEBACKQ" %%a IN (`%msysloc%\usr\bin\bash --login -c "${MINGW_PREFIX}/bin/llvm-config --link-static --libnames engine coroutines" 2^>^&1`) DO @SET llvmlibs=%%~a
@IF NOT %toolchain%==msvc FOR /F USEBACKQ^ tokens^=5^ delims^=-^  %%a IN (`%msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -Q ${MINGW_PACKAGE_PREFIX}-llvm"`) DO @SET llvmver=%%~a
@IF NOT %toolchain%==msvc FOR /F "tokens=* USEBACKQ" %%a IN (`%msysloc%\usr\bin\bash --login -c "${MINGW_PREFIX}/bin/llvm-config --has-rtti" 2^>^&1`) DO @IF /I "%%a"=="YES" SET RTTI=true
@IF %toolchain%==msvc set llvmlibs=%llvmlibs:.lib=%
@IF NOT %toolchain%==msvc set llvmlibs=%llvmlibs:.a=%
@set llvmlibs='%llvmlibs: =', '%'
@set llvmconfigbusted=0
@IF NOT %toolchain%==msvc IF %llvmconfigbusted%==1 set llvmlibs='libLLVMCoroutines', 'libLLVMipo', 'libLLVMInstrumentation', 'libLLVMVectorize', 'libLLVMLinker', 'libLLVMIRReader', 'libLLVMAsmParser', 'libLLVMX86Disassembler', 'libLLVMX86AsmParser', 'libLLVMX86CodeGen', 'libLLVMCFGuard', 'libLLVMGlobalISel', 'libLLVMSelectionDAG', 'libLLVMAsmPrinter', 'libLLVMDebugInfoDWARF', 'libLLVMCodeGen', 'libLLVMScalarOpts', 'libLLVMInstCombine', 'libLLVMAggressiveInstCombine', 'libLLVMTransformUtils', 'libLLVMBitWriter', 'libLLVMX86Desc', 'libLLVMMCDisassembler', 'libLLVMX86Utils', 'libLLVMX86Info', 'libLLVMMCJIT', 'libLLVMExecutionEngine', 'libLLVMTarget', 'libLLVMAnalysis', 'libLLVMProfileData', 'libLLVMRuntimeDyld', 'libLLVMObject', 'libLLVMTextAPI', 'libLLVMMCParser', 'libLLVMBitReader', 'libLLVMMC', 'libLLVMDebugInfoCodeView', 'libLLVMDebugInfoMSF', 'libLLVMCore', 'libLLVMRemarks', 'libLLVMBitstreamReader', 'libLLVMBinaryFormat', 'libLLVMSupport', 'libLLVMDemangle'
@IF NOT EXIST "%devroot%\mesa\subprojects\llvm\" md %devroot%\mesa\subprojects\llvm
@IF NOT EXIST "%devroot%\%projectname%\buildscript\assets\" md %devroot%\%projectname%\buildscript\assets
@(echo project^('llvm', ['cpp']^)
echo.
echo cpp = meson.get_compiler^('cpp'^)
echo.
echo _deps = []
IF %toolchain%==msvc echo llvmloc = run_command^('cmd', '/c', 'echo %devroot:\=/%/llvm/%%abi%%'^).stdout^(^).strip^(^)
IF NOT %toolchain%==msvc echo llvmloc = run_command^('%devroot:\=/%/%projectname%/buildscript/modules/msysmingwruntimeloc.cmd'^).stdout^(^).strip^(^)
echo _search = llvmloc + '/lib'
echo foreach d ^: [%llvmlibs%]
echo   _deps += cpp.find_library^(d, dirs ^: _search, static ^: true^)
echo endforeach
echo.
echo dep_llvm = declare_dependency^(
echo   include_directories ^: include_directories^(llvmloc + '/include'^),
echo   dependencies ^: _deps,
echo   version ^: '%llvmver%',
echo ^)
echo.
echo has_rtti = %RTTI%
echo irbuilder_h = files^(llvmloc + '/include/llvm/IR/IRBuilder.h'^)
)>%devroot%\%projectname%\buildscript\assets\llvm-wrap.txt
@CMD /C EXIT 0
@FC /B %devroot%\%projectname%\buildscript\assets\llvm-wrap.txt %devroot%\mesa\subprojects\llvm\meson.build>NUL 2>&1
@if NOT "%ERRORLEVEL%"=="0" (
@copy /Y %devroot%\%projectname%\buildscript\assets\llvm-wrap.txt %devroot%\mesa\subprojects\llvm\meson.build
@echo.
)
@endlocal
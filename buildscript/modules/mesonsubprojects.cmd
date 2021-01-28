@setlocal

:llvmwrap
@set RTTI=false
@set llvmconfigbusted=0
@IF %toolchain%==msvc if /I NOT "%llvmless%"=="y" FOR /F "tokens=* USEBACKQ" %%a IN (`%devroot%\llvm\%abi%\bin\llvm-config --has-rtti`) DO @IF /I "%%a"=="YES" SET RTTI=true
@IF NOT %toolchain%==msvc if /I NOT "%llvmless%"=="y" FOR /F "tokens=* USEBACKQ" %%a IN (`%msysloc%\usr\bin\bash --login -c "${MINGW_PREFIX}/bin/llvm-config --has-rtti" 2^>^&1`) DO @(
IF /I "%%a"=="YES" SET RTTI=true
IF /I NOT "%%a"=="YES" IF /I NOT "%%a"=="NO" set llvmconfigbusted=1
)
@IF %llvmconfigbusted% EQU 0 IF EXIST "%devroot%\mesa\subprojects\llvm\" RD /S /Q %devroot%\mesa\subprojects\llvm
@IF %llvmconfigbusted% EQU 0 GOTO zlibwrap

@rem llvmlibs must match the output of 'llvm-config --link-static --libnames engine coroutines' stripped of ending newline.
@rem Current llvmlibs is valid for LLVM 11.* series.
@set llvmlibs=libLLVMCoroutines.a libLLVMipo.a libLLVMInstrumentation.a libLLVMVectorize.a libLLVMLinker.a libLLVMIRReader.a libLLVMAsmParser.a libLLVMFrontendOpenMP.a libLLVMX86Disassembler.a libLLVMX86AsmParser.a libLLVMX86CodeGen.a libLLVMCFGuard.a libLLVMGlobalISel.a libLLVMSelectionDAG.a libLLVMAsmPrinter.a libLLVMDebugInfoDWARF.a libLLVMCodeGen.a libLLVMScalarOpts.a libLLVMInstCombine.a libLLVMAggressiveInstCombine.a libLLVMTransformUtils.a libLLVMBitWriter.a libLLVMX86Desc.a libLLVMMCDisassembler.a libLLVMX86Info.a libLLVMMCJIT.a libLLVMExecutionEngine.a libLLVMTarget.a libLLVMAnalysis.a libLLVMProfileData.a libLLVMRuntimeDyld.a libLLVMObject.a libLLVMTextAPI.a libLLVMMCParser.a libLLVMBitReader.a libLLVMMC.a libLLVMDebugInfoCodeView.a libLLVMDebugInfoMSF.a libLLVMCore.a libLLVMRemarks.a libLLVMBitstreamReader.a libLLVMBinaryFormat.a libLLVMSupport.a libLLVMDemangle.a
@set llvmlibs=%llvmlibs:.a=%
@set llvmlibs='%llvmlibs: =', '%'
@FOR /F USEBACKQ^ tokens^=5^ delims^=-^  %%a IN (`%msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -Q ${MINGW_PACKAGE_PREFIX}-llvm"`) DO @SET llvmver=%%~a
@IF NOT EXIST "%devroot%\mesa\subprojects\llvm\" md %devroot%\mesa\subprojects\llvm
@(
echo project^('llvm', ['cpp']^)
echo.
echo cpp ^= meson.get_compiler^('cpp'^)
echo.
echo _deps ^= []
echo llvmloc ^= run_command^('%devroot:\=/%/%projectname%/buildscript/modules/msysmingwruntimeloc.cmd'^).stdout^(^).strip^(^)
echo _search ^= llvmloc + '/lib'
echo foreach d ^: [%llvmlibs%]
echo   _deps ^+^= cpp.find_library^(d, dirs ^: _search, static ^: true^)
echo endforeach
echo.
echo dep_llvm ^= declare_dependency^(
echo   include_directories ^: include_directories^(llvmloc + '/include'^),
echo   dependencies ^: _deps,
echo   version ^: '%llvmver%',
echo ^)
echo.
echo has_rtti ^= %RTTI%
echo irbuilder_h ^= files^(llvmloc + '/include/llvm/IR/IRBuilder.h'^)
)>%devroot%\%projectname%\buildscript\mesonsubprojects\llvm-meson.build
@CMD /C EXIT 0
@FC /B %devroot%\%projectname%\buildscript\mesonsubprojects\llvm-meson.build %devroot%\mesa\subprojects\llvm\meson.build>NUL 2>&1
@if NOT "%ERRORLEVEL%"=="0" (
@echo Using binary wrap to find LLVM...
@copy /Y %devroot%\%projectname%\buildscript\mesonsubprojects\llvm-meson.build %devroot%\mesa\subprojects\llvm\meson.build
@echo.
)

:zlibwrap
@IF EXIST "%devroot%\mesa\subprojects\zlib\" RD /S /Q %devroot%\mesa\subprojects\zlib
@CMD /C EXIT 0
@IF %toolchain%==msvc FC /B %devroot%\%projectname%\buildscript\mesonsubprojects\zlib.wrap %devroot%\mesa\subprojects\zlib.wrap>NUL 2>&1
@if NOT "%ERRORLEVEL%"=="0" (
@echo Using wrap file version 1.2.11-5 from Meson wrapdb to build zlib...
@copy /Y %devroot%\%projectname%\buildscript\mesonsubprojects\zlib.wrap %devroot%\mesa\subprojects\zlib.wrap
@echo.
)
@IF %toolchain%==msvc GOTO dxheaderswrap
@for /d %%a in ("%devroot%\mesa\subprojects\zlib-*") do @RD /S /Q "%%~a"
@IF EXIST %devroot%\mesa\subprojects\zlib.wrap del %devroot%\mesa\subprojects\zlib.wrap
@IF EXIST %msysloc%\%MSYSTEM%\lib\libz.dll.a del %msysloc%\%MSYSTEM%\lib\libz.dll.a

:zstdwrap
@IF EXIST %msysloc%\%MSYSTEM%\lib\libzstd.dll.a del %msysloc%\%MSYSTEM%\lib\libzstd.dll.a

:dxheaderswrap
@for /d %%a in ("%devroot%\mesa\subprojects\DirectX-Headers-*") do @IF EXIST "%%~a" IF %gitstate% GTR 0 (
cd /D "%%~a"
echo Refreshing DirectX-Headers...
git pull -v --progress --recurse-submodules origin
echo.
cd /D %devroot%\mesa
)

:donewrap
@endlocal&set RTTI=%RTTI%&set llvmconfigbusted=%llvmconfigbusted%
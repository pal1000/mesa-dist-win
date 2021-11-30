@setlocal

@rem Refreshing DirectX-Headers if found
@for /d %%a in ("%devroot%\mesa\subprojects\DirectX-Headers-*") do @IF EXIST "%%~a" IF %gitstate% GTR 0 (
cd /D "%%~a"
echo Refreshing DirectX-Headers...
git pull -v --progress --recurse-submodules origin
echo.
cd /D %devroot%\mesa
)

@rem Find LLVM dependency
@set RTTI=false
@set llvmconfigbusted=0
@IF %toolchain%==msvc IF EXIST %devroot%\llvm\build\%abi%\lib\cmake\llvm\LLVMConfig.cmake FOR /F "tokens=* delims=" %%a IN ('type %devroot%\llvm\build\%abi%\lib\cmake\llvm\LLVMConfig.cmake') DO @IF "%%a"=="set(LLVM_ENABLE_RTTI ON)" SET RTTI=true
@IF NOT %toolchain%==msvc IF EXIST %msysloc%\%LMSYSTEM%\lib\cmake\llvm\LLVMConfig.cmake FOR /F "tokens=* delims=" %%a IN ('type %msysloc%\%LMSYSTEM%\lib\cmake\llvm\LLVMConfig.cmake') DO @IF "%%a"=="set(LLVM_ENABLE_RTTI ON)" SET RTTI=true
@IF NOT %toolchain%==msvc if /I NOT "%llvmless%"=="y" FOR /F "tokens=* USEBACKQ" %%a IN (`%msysloc%\usr\bin\bash --login -c "${MINGW_PREFIX}/bin/llvm-config --has-rtti" 2^>^&1`) DO @IF /I NOT "%%a"=="YES" IF /I NOT "%%a"=="NO" set llvmconfigbusted=1
@IF %llvmconfigbusted% EQU 0 IF EXIST "%devroot%\mesa\subprojects\llvm\" RD /S /Q %devroot%\mesa\subprojects\llvm
@IF %llvmconfigbusted% EQU 0 GOTO msvcwraps

@rem llvmlibs must match the output of 'llvm-config --link-static --libnames engine coroutines' stripped of ending newline.
@rem Current llvmlibs is valid for LLVM 13.* series.
@set llvmlibs=libLLVMCoroutines.a libLLVMipo.a libLLVMInstrumentation.a libLLVMVectorize.a libLLVMLinker.a libLLVMIRReader.a libLLVMAsmParser.a libLLVMFrontendOpenMP.a libLLVMInterpreter.a libLLVMExecutionEngine.a libLLVMRuntimeDyld.a libLLVMOrcTargetProcess.a libLLVMOrcShared.a libLLVMCodeGen.a libLLVMTarget.a libLLVMScalarOpts.a libLLVMInstCombine.a libLLVMAggressiveInstCombine.a libLLVMTransformUtils.a libLLVMBitWriter.a libLLVMAnalysis.a libLLVMProfileData.a libLLVMObject.a libLLVMTextAPI.a libLLVMMCParser.a libLLVMMC.a libLLVMDebugInfoCodeView.a libLLVMBitReader.a libLLVMCore.a libLLVMRemarks.a libLLVMBitstreamReader.a libLLVMBinaryFormat.a libLLVMSupport.a libLLVMDemangle.a
@set llvmlibs=%llvmlibs:.a=%
@set llvmlibs='%llvmlibs: =', '%'
@FOR /F USEBACKQ^ tokens^=2^ delims^=^  %%a IN (`%msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -Q ${MINGW_PACKAGE_PREFIX}-llvm"`) DO @FOR /F tokens^=1^ delims^=- %%b IN ("%%~a") DO @SET llvmver=%%b
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

:msvcwraps
@IF NOT %toolchain%==msvc GOTO mingwwraps
@IF EXIST "%devroot%\mesa\subprojects\zlib\" RD /S /Q %devroot%\mesa\subprojects\zlib
@IF EXIST "%devroot%\mesa\subprojects\libzstd\" RD /S /Q %devroot%\mesa\subprojects\libzstd
@IF EXIST "%devroot%\mesa\subprojects\vulkan\" RD /S /Q %devroot%\mesa\subprojects\vulkan

@rem Use updated zlib wrap
@CMD /C EXIT 0
@FC /B %devroot%\%projectname%\buildscript\mesonsubprojects\zlib.wrap %devroot%\mesa\subprojects\zlib.wrap>NUL 2>&1
@if NOT "%ERRORLEVEL%"=="0" (
@echo Using wrap file version 1.2.11-5 from Meson wrapdb to build zlib...
@copy /Y %devroot%\%projectname%\buildscript\mesonsubprojects\zlib.wrap %devroot%\mesa\subprojects\zlib.wrap
@echo.
)

@rem Use up-to-date libelf-lfg-win32
@CMD /C EXIT 0
@FC /B %devroot%\%projectname%\buildscript\mesonsubprojects\libelf.wrap %devroot%\mesa\subprojects\libelf.wrap>NUL 2>&1
@if NOT "%ERRORLEVEL%"=="0" (
@echo Switching libelf to full clone with master branch pre-fetched...
@copy /Y %devroot%\%projectname%\buildscript\mesonsubprojects\libelf.wrap %devroot%\mesa\subprojects\libelf.wrap
@echo.
)
@IF EXIST %devroot%\mesa\subprojects\libelf-lfg-win32 IF %gitstate% GTR 0 (
@cd /D %devroot%\mesa\subprojects\libelf-lfg-win32
echo Refreshing libelf for Windows...
git pull -v --progress --recurse-submodules origin
echo.
cd /D %devroot%\mesa
)

:mingwwraps
@IF %toolchain%==msvc GOTO donewrap
@rem Use runtime MinGW libelf dependency
@for /d %%a in ("%devroot%\mesa\subprojects\libelf-*") do @RD /S /Q "%%~a"
@IF EXIST %devroot%\mesa\subprojects\libelf.wrap del %devroot%\mesa\subprojects\libelf.wrap

@rem Override zlib dependency
@for /d %%a in ("%devroot%\mesa\subprojects\zlib-*") do @RD /S /Q "%%~a"
@IF EXIST %devroot%\mesa\subprojects\zlib.wrap del %devroot%\mesa\subprojects\zlib.wrap
@FOR /F USEBACKQ^ tokens^=2^ delims^=^  %%a IN (`%msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -Q ${MINGW_PACKAGE_PREFIX}-zlib"`) DO @FOR /F tokens^=1^ delims^=- %%b IN ("%%~a") DO @SET zlibver=%%b
@IF NOT EXIST "%devroot%\mesa\subprojects\zlib\" MD %devroot%\mesa\subprojects\zlib
@(
echo project^('zlib', ['cpp'], version ^: '%zlibver%'^)
echo.
echo _deps ^= meson.get_compiler^('cpp'^).find_library^('libz', static ^: true^)
echo.
echo zlib_dep ^= declare_dependency^(
echo   dependencies ^: _deps,
echo   version ^: '%zlibver%'
echo ^)
)>%devroot%\%projectname%\buildscript\mesonsubprojects\zlib-meson.build
@CMD /C EXIT 0
@FC /B %devroot%\%projectname%\buildscript\mesonsubprojects\zlib-meson.build %devroot%\mesa\subprojects\zlib\meson.build>NUL 2>&1
@if NOT "%ERRORLEVEL%"=="0" (
@echo Overriding zlib dependency...
@copy /Y %devroot%\%projectname%\buildscript\mesonsubprojects\zlib-meson.build %devroot%\mesa\subprojects\zlib\meson.build
@echo.
)

@rem Override ZSTD dependency
@FOR /F USEBACKQ^ tokens^=2^ delims^=^  %%a IN (`%msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -Q ${MINGW_PACKAGE_PREFIX}-zstd"`) DO @FOR /F tokens^=1^ delims^=- %%b IN ("%%~a") DO @SET zstdver=%%b
@IF NOT EXIST "%devroot%\mesa\subprojects\libzstd\" MD %devroot%\mesa\subprojects\libzstd
@(
echo project^('libzstd', ['cpp'], version ^: '%zstdver%'^)
echo.
echo _deps ^= meson.get_compiler^('cpp'^).find_library^('libzstd', static ^: true^)
echo.
echo zstd_override ^= declare_dependency^(
echo   dependencies ^: _deps,
echo   version ^: '%zstdver%'
echo ^)
echo.
echo meson.override_dependency^('libzstd', zstd_override^)
)>%devroot%\%projectname%\buildscript\mesonsubprojects\zstd-meson.build
@CMD /C EXIT 0
@FC /B %devroot%\%projectname%\buildscript\mesonsubprojects\zstd-meson.build %devroot%\mesa\subprojects\libzstd\meson.build>NUL 2>&1
@if NOT "%ERRORLEVEL%"=="0" (
@echo Overriding ZSTD dependency...
@copy /Y %devroot%\%projectname%\buildscript\mesonsubprojects\zstd-meson.build %devroot%\mesa\subprojects\libzstd\meson.build
@echo.
)

@rem Vulkan dependency
@IF "%vksdkselect%"=="2" (
@set "VULKAN_SDK="
@set "VK_SDK_PATH="
@%msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -S ${MINGW_PACKAGE_PREFIX}-vulkan-loader --noconfirm"
@echo.
@IF EXIST "%devroot%\mesa\subprojects\vulkan\" RD /S /Q %devroot%\mesa\subprojects\vulkan
@GOTO donewrap
)
@IF NOT EXIST "%devroot%\mesa\subprojects\vulkan\" md %devroot%\mesa\subprojects\vulkan
@(
echo project^('vulkan', ['cpp']^)
echo.
echo cpp ^= meson.get_compiler^('cpp'^)
echo.
echo _deps ^= []
echo _search ^= '%windir:\=/%/'
if /I %PROCESSOR_ARCHITECTURE%==AMD64 IF %abi%==x86 echo _search ^+^= 'SysWOW64'
if /I %PROCESSOR_ARCHITECTURE%==AMD64 IF %abi%==x64 echo _search ^+^= 'system32'
if /I %PROCESSOR_ARCHITECTURE%==%abi% echo _search ^+^= 'system32'
echo foreach d ^: ['vulkan-1']
echo   _deps ^+^= cpp.find_library^(d, dirs ^: _search^)
echo endforeach
echo.
echo dep_vk_override ^= declare_dependency^(
IF EXIST "%VULKAN_SDK%" IF "%VULKAN_SDK%"=="%VK_SDK_PATH%" echo   include_directories ^: include_directories^('%VULKAN_SDK:\=/%/Include/vulkan'^),
IF EXIST "%VULKAN_SDK%" IF NOT EXIST "%VK_SDK_PATH%" echo   include_directories ^: include_directories^('%VULKAN_SDK:\=/%/Include/vulkan'^),
IF NOT EXIST "%VULKAN_SDK%" IF EXIST "%VK_SDK_PATH%" echo   include_directories ^: include_directories^('%VK_SDK_PATH:\=/%/Include/vulkan'^),
echo   dependencies ^: _deps
echo ^)
echo.
echo meson.override_dependency^('vulkan', dep_vk_override^)
)>%devroot%\%projectname%\buildscript\mesonsubprojects\vulkan-meson.build
@CMD /C EXIT 0
@FC /B %devroot%\%projectname%\buildscript\mesonsubprojects\vulkan-meson.build %devroot%\mesa\subprojects\vulkan\meson.build>NUL 2>&1
@if NOT "%ERRORLEVEL%"=="0" (
@echo Using binary wrap to find Vulkan...
@copy /Y %devroot%\%projectname%\buildscript\mesonsubprojects\vulkan-meson.build %devroot%\mesa\subprojects\vulkan\meson.build
@echo.
)

:donewrap
@endlocal&set RTTI=%RTTI%&set llvmconfigbusted=%llvmconfigbusted%
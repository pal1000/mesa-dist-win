@setlocal

@rem Remove zlib and zstd binary wraps as they are no longer used
@IF EXIST "%devroot%\mesa\subprojects\zlib\" RD /S /Q "%devroot%\mesa\subprojects\zlib"
@IF EXIST "%devroot%\mesa\subprojects\libzstd\" RD /S /Q "%devroot%\mesa\subprojects\libzstd"

@rem Refreshing DirectX-Headers if found
@if %gitstate% GTR 0 set /p refreshdxheaders=Update DirectX headers (y/n):
@if %gitstate% GTR 0 echo.
@IF /I "%refreshdxheaders%"=="y" for /f delims^=^ eol^= %%a in ('dir /b /a:d "%devroot%\mesa\subprojects\DirectX-Header*" 2^>nul') do @IF EXIST "%devroot%\mesa\subprojects\%%~nxa" RD /S /Q "%devroot%\mesa\subprojects\%%~nxa"
@IF /I "%refreshdxheaders%"=="y" git clone -b v1.606.3 --recurse-submodules https://github.com/microsoft/DirectX-Headers.git "%devroot%\mesa\subprojects\DirectX-Headers"
@rem IF /I "%refreshdxheaders%"=="y" cd /d "%devroot%\mesa\subprojects\DirectX-Headers"
@rem IF /I "%refreshdxheaders%"=="y" git remote add upstream https://github.com/lygstate/DirectX-Headers.git
@rem IF /I "%refreshdxheaders%"=="y" git fetch upstream
@rem IF /I "%refreshdxheaders%"=="y" git rebase upstream/main
@rem IF /I "%refreshdxheaders%"=="y" cd /d "%devroot%\mesa"
@IF /I "%refreshdxheaders%"=="y" echo.

@rem Find LLVM dependency
@set RTTI=false
@set llvmconfigbusted=0
@IF %toolchain%==msvc IF EXIST "%devroot%\llvm\build\%abi%\lib\cmake\llvm\LLVMConfig.cmake" FOR /F delims^=^ eol^= %%a IN ('type "%devroot%\llvm\build\%abi%\lib\cmake\llvm\LLVMConfig.cmake"') DO @IF "%%a"=="set(LLVM_ENABLE_RTTI ON)" SET RTTI=true
@IF NOT %toolchain%==msvc IF EXIST "%msysloc%\%LMSYSTEM%\lib\cmake\llvm\LLVMConfig.cmake" FOR /F delims^=^ eol^= %%a IN ('type "%msysloc%\%LMSYSTEM%\lib\cmake\llvm\LLVMConfig.cmake"') DO @IF "%%a"=="set(LLVM_ENABLE_RTTI ON)" SET RTTI=true
@IF NOT %toolchain%==msvc if /I NOT "%llvmless%"=="y" FOR /F delims^=^ eol^= %%a IN ('%runmsys% /%LMSYSTEM%/bin/llvm-config --has-rtti 2^>^&1') DO @IF /I NOT "%%a"=="YES" IF /I NOT "%%a"=="NO" set llvmconfigbusted=1
@IF %llvmconfigbusted% EQU 0 IF EXIST "%devroot%\mesa\subprojects\llvm\" RD /S /Q "%devroot%\mesa\subprojects\llvm"
@IF %llvmconfigbusted% EQU 0 GOTO msvcwraps

@rem llvmlibs must match the output of 'llvm-config --link-static --libnames engine coroutines' stripped of ending newline.
@rem Current llvmlibs is valid for LLVM 14.* series.
@set llvmlibs=libLLVMCoroutines.a libLLVMipo.a libLLVMInstrumentation.a libLLVMVectorize.a libLLVMLinker.a libLLVMIRReader.a libLLVMAsmParser.a libLLVMFrontendOpenMP.a libLLVMInterpreter.a libLLVMExecutionEngine.a libLLVMRuntimeDyld.a libLLVMOrcTargetProcess.a libLLVMOrcShared.a libLLVMCodeGen.a libLLVMTarget.a libLLVMScalarOpts.a libLLVMInstCombine.a libLLVMAggressiveInstCombine.a libLLVMTransformUtils.a libLLVMBitWriter.a libLLVMAnalysis.a libLLVMProfileData.a libLLVMDebugInfoDWARF.a libLLVMObject.a libLLVMTextAPI.a libLLVMMCParser.a libLLVMMC.a libLLVMDebugInfoCodeView.a libLLVMBitReader.a libLLVMCore.a libLLVMRemarks.a libLLVMBitstreamReader.a libLLVMBinaryFormat.a libLLVMSupport.a libLLVMDemangle.a
@set llvmlibs=%llvmlibs:.a=%
@set llvmlibs='%llvmlibs: =', '%'
@FOR /F tokens^=2^ eol^= %%a IN ('%runmsys% /usr/bin/pacman -Q ${MINGW_PACKAGE_PREFIX}-llvm') DO @FOR /F tokens^=1^ delims=^-^ eol^= %%b IN ("%%~a") DO @SET llvmver=%%b
@IF NOT EXIST "%devroot%\mesa\subprojects\llvm\" md "%devroot%\mesa\subprojects\llvm"
@(
echo project^('llvm', ['cpp']^)
echo.
echo cpp ^= meson.get_compiler^('cpp'^)
echo.
echo _deps ^= []
echo llvmloc ^= run_command^('%devroot:\=/%/%projectname%/buildscript/modules/msysmingwruntimeloc.cmd', check^: true^).stdout^(^).strip^(^)
echo foreach d ^: [%llvmlibs%]
echo   _deps ^+^= cpp.find_library^(d, static ^: true^)
echo endforeach
echo.
echo dep_llvm ^= declare_dependency^(
echo   dependencies ^: _deps,
echo   version ^: '%llvmver%',
echo ^)
echo.
echo has_rtti ^= %RTTI%
echo irbuilder_h ^= files^(llvmloc + '/include/llvm/IR/IRBuilder.h'^)
)>"%devroot%\%projectname%\buildscript\mesonsubprojects\llvm-meson.build"
@CMD /C EXIT 0
@FC /B "%devroot%\%projectname%\buildscript\mesonsubprojects\llvm-meson.build" "%devroot%\mesa\subprojects\llvm\meson.build">NUL 2>&1
@if NOT "%ERRORLEVEL%"=="0" (
@echo Using binary wrap to find LLVM...
@copy /Y "%devroot%\%projectname%\buildscript\mesonsubprojects\llvm-meson.build" "%devroot%\mesa\subprojects\llvm\meson.build"
@echo.
)

:msvcwraps
@IF NOT %toolchain%==msvc GOTO mingwwraps
@IF EXIST "%devroot%\mesa\subprojects\vulkan\" RD /S /Q "%devroot%\mesa\subprojects\vulkan"

@rem Use updated zlib wrap
@CMD /C EXIT 0
@FC /B "%devroot%\%projectname%\buildscript\mesonsubprojects\zlib.wrap" "%devroot%\mesa\subprojects\zlib.wrap">NUL 2>&1
@if NOT "%ERRORLEVEL%"=="0" (
@echo Using wrap file version 1.2.12-1 from Meson wrapdb to build zlib...
@copy /Y "%devroot%\%projectname%\buildscript\mesonsubprojects\zlib.wrap" "%devroot%\mesa\subprojects\zlib.wrap"
@echo.
)

@rem Use up-to-date libelf-lfg-win32
@CMD /C EXIT 0
@FC /B "%devroot%\%projectname%\buildscript\mesonsubprojects\libelf.wrap" "%devroot%\mesa\subprojects\libelf.wrap">NUL 2>&1
@if NOT "%ERRORLEVEL%"=="0" (
@echo Switching libelf to full clone with master branch pre-fetched...
@copy /Y "%devroot%\%projectname%\buildscript\mesonsubprojects\libelf.wrap" "%devroot%\mesa\subprojects\libelf.wrap"
@echo.
)
@IF EXIST "%devroot%\mesa\subprojects\libelf-lfg-win32\" IF %gitstate% GTR 0 (
@cd /D "%devroot%\mesa\subprojects\libelf-lfg-win32"
echo Refreshing libelf for Windows...
git pull --progress --tags --recurse-submodules origin
echo.
cd /D "%devroot%\mesa"
)

:mingwwraps
@IF %toolchain%==msvc GOTO donewrap
@rem Use runtime MinGW libelf, zlib and zstd dependencies
@for /f delims^=^ eol^= %%a in ('dir /b /a:d "%devroot%\mesa\subprojects\libelf-*" 2^>nul') do @RD /S /Q "%devroot%\mesa\subprojects\%%~nxa"
@IF EXIST "%devroot%\mesa\subprojects\libelf.wrap" del "%devroot%\mesa\subprojects\libelf.wrap"
@for /f delims^=^ eol^= %%a in ('dir /b /a:d "%devroot%\mesa\subprojects\zlib-*" 2^>nul') do @RD /S /Q "%devroot%\mesa\subprojects\%%~nxa"
@IF EXIST "%devroot%\mesa\subprojects\zlib.wrap" del "%devroot%\mesa\subprojects\zlib.wrap"

@rem Vulkan dependency
@IF "%vksdkselect%"=="2" (
@set "VULKAN_SDK="
@set "VK_SDK_PATH="
@%runmsys% /usr/bin/pacman -S ${MINGW_PACKAGE_PREFIX}-vulkan-loader --noconfirm
@echo.
@IF EXIST "%devroot%\mesa\subprojects\vulkan\" RD /S /Q "%devroot%\mesa\subprojects\vulkan"
@GOTO donewrap
)
@(
echo project^('vulkan', ['cpp']^)
echo.
echo cpp ^= meson.get_compiler^('cpp'^)
echo.
echo _deps ^= []
echo _search ^= run_command^('%devroot:\=/%/%projectname%/buildscript/modules/vulkanruntimeloc.cmd', check^: true^).stdout^(^).strip^(^)
echo foreach d ^: ['vulkan-1']
echo   _deps ^+^= cpp.find_library^(d, dirs ^: _search^)
echo endforeach
echo.
echo dep_vk_override ^= declare_dependency^(
IF EXIST "%VULKAN_SDK%" IF "%VULKAN_SDK%"=="%VK_SDK_PATH%" echo   include_directories ^: include_directories^('%VULKAN_SDK:\=/%/Include'^),
IF EXIST "%VULKAN_SDK%" IF NOT EXIST "%VK_SDK_PATH%" echo   include_directories ^: include_directories^('%VULKAN_SDK:\=/%/Include'^),
IF NOT EXIST "%VULKAN_SDK%" IF EXIST "%VK_SDK_PATH%" echo   include_directories ^: include_directories^('%VK_SDK_PATH:\=/%/Include'^),
echo   dependencies ^: _deps
echo ^)
echo.
echo meson.override_dependency^('vulkan', dep_vk_override^)
)>"%devroot%\%projectname%\buildscript\mesonsubprojects\vulkan-meson.build"
@CMD /C EXIT 0
@FC /B "%devroot%\%projectname%\buildscript\mesonsubprojects\vulkan-meson.build" "%devroot%\mesa\subprojects\vulkan\meson.build">NUL 2>&1
@if NOT "%ERRORLEVEL%"=="0" (
@IF %toolchain%==clang echo Using binary wrap to find Vulkan...
@IF %toolchain%==clang IF NOT EXIST "%devroot%\mesa\subprojects\vulkan\" md "%devroot%\mesa\subprojects\vulkan"
@IF %toolchain%==clang copy /Y "%devroot%\%projectname%\buildscript\mesonsubprojects\vulkan-meson.build" "%devroot%\mesa\subprojects\vulkan\meson.build"
@IF %toolchain%==clang echo.
)
@IF %toolchain%==gcc IF EXIST "%devroot%\mesa\subprojects\vulkan\" RD /S /Q "%devroot%\mesa\subprojects\vulkan"
@IF %toolchain%==gcc IF EXIST "%msysloc%\%LMSYSTEM%\lib\libvulkan.dll.a" del "%msysloc%\%LMSYSTEM%\lib\libvulkan.dll.a"
@IF %toolchain%==gcc IF EXIST "%msysloc%\%LMSYSTEM%\lib\pkgconfig\vulkan.pc" del "%msysloc%\%LMSYSTEM%\lib\pkgconfig\vulkan.pc"
@IF %toolchain%==gcc IF EXIST "%msysloc%\%LMSYSTEM%\bin\libvulkan-1.dll" del "%msysloc%\%LMSYSTEM%\bin\libvulkan-1.dll"

:donewrap
@endlocal&set RTTI=%RTTI%&set llvmconfigbusted=%llvmconfigbusted%&set "VK_SDK_PATH=%VK_SDK_PATH%"&set "VULKAN_SDK=%VULKAN_SDK%"
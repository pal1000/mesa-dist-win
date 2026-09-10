@setlocal
@set canclc=1
@IF %cmakestate% EQU 0 set canclc=0
@IF %cmakestate% EQU 1 set PATH=%devroot%\cmake\bin\;%PATH%
@if %ninjastate% EQU 0 set canclc=0
@if %ninjastate% EQU 1 call "%devroot%\%projectname%\buildscript\modules\useninja.cmd" noprompt
@if NOT EXIST "%llvminstloc%\spv-%hostabi%\bin\llvm-spirv.exe" set canclc=0
@if NOT EXIST "%llvminstloc%\%hostabi%\bin\clang.exe" set canclc=0
@IF NOT EXIST "%devroot%\llvm-project\llvm\CMakeLists.txt" set canclc=0
@if NOT EXIST "%devroot%\mesalibclc\" IF %gitstate% EQU 0 set canclc=0
@if %canclc% EQU 0 echo Mesa-libclc requires cmake, ninja and %hostabi% LLVM build with clang and SPIRV translator.
@if %canclc% EQU 0 echo.
@if %canclc% EQU 0 GOTO finishmesaclc
@if %canclc% EQU 1 call "%devroot%\%projectname%\bin\modules\prompt.cmd" buildclc "Build Mesa libclc fork (y/n):"
@if /I NOT "%buildclc%"=="y" GOTO finishmesaclc
@call %vsenv% %WINSDK_VER% %hostabi% -vcvars_ver=%msvcpp%
@echo.
@IF NOT EXIST "%devroot%\mesalibclc\" git clone https://gitlab.freedesktop.org/karolherbst/mesa-libclc.git "%devroot%\mesalibclc"
@cd "%devroot%\mesalibclc"
@git pull -v --progress origin
@FOR /F tokens^=^1^,2^ eol^= %%a IN ('type "%llvminstloc%\%abi%\lib\cmake\llvm\LLVMConfig.cmake"') DO @IF "%%a"=="set(LLVM_VERSION_MAJOR" FOR /F tokens^=^1^ delims^=^)^ eol^= %%c IN ("%%b") DO @git checkout llvm_%%c
@git pull -v --progress origin
@echo.
@echo Cleanning Mesa libclc fork build...
@echo.
@IF NOT EXIST "build\" MD build
@cd build
@if EXIST "buildsys-clc\" RD /S /Q buildsys-clc
@if EXIST "%llvminstloc%\clc\" RD /S /Q "%llvminstloc%\clc"
@md buildsys-clc
@cd buildsys-clc
@set buildconf=cmake "%devroot%\mesalibclc" -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="-m64" -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded -DCMAKE_INSTALL_PREFIX="%llvminstloc%\clc" -DLIBCLC_TARGETS_TO_BUILD="spirv-mesa3d-;spirv64-mesa3d-" -DCMAKE_PREFIX_PATH="%llvminstloc%\%hostabi%" -DLLVM_SPIRV="%llvminstloc%\spv-%hostabi%\bin\llvm-spirv.exe"
@FOR /F tokens^=^1^,2^ eol^= %%a IN ('type "%llvminstloc%\%abi%\lib\cmake\llvm\LLVMConfig.cmake"') DO @IF "%%a"=="set(LLVM_VERSION_MAJOR" FOR /F tokens^=^1^ delims^=^)^ eol^= %%c IN ("%%b") DO @IF %%c LSS 17 set buildconf=%buildconf% -DCMAKE_POLICY_DEFAULT_CMP0091=NEW
@echo Build configuration command: %buildconf%
@echo.
@call "%devroot%\%projectname%\bin\modules\break.cmd"
@%buildconf%
@echo.
@call "%devroot%\%projectname%\bin\modules\break.cmd"
@call "%devroot%\%projectname%\buildscript\modules\trybuild.cmd" ninja -j %throttle% install
@echo.

:finishmesaclc
@rem Reset environment after Mesa-libclc build.
@endlocal
@cd "%devroot%\"
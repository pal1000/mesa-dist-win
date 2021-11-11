@setlocal
@set canclc=1
@IF %cmakestate% EQU 0 set canclc=0
@IF %cmakestate% EQU 1 set PATH=%devroot%\cmake\bin\;%PATH%
@if %ninjastate% EQU 0 set canclc=0
@if %ninjastate% EQU 1 set PATH=%devroot%\ninja\;%PATH%
@if NOT EXIST %devroot%\llvm\%abi%\bin\llvm-spirv.exe set canclc=0
@if NOT EXIST %devroot%\llvm\%abi%\bin\clang.exe set canclc=0
@if NOT EXIST %devroot%\llvm\%abi%\bin\lld.exe set canclc=0
@if NOT EXIST %devroot%\llvm-project set canclc=0
@if %canclc% EQU 0 echo libclc requires cmake, ninja and LLVM built with clang, LLD and SPIRV translator.
@if %canclc% EQU 0 echo.
@if %canclc% EQU 0 GOTO finishclc
@if %canclc% EQU 1 set /p buildclc=Build LLVM libclc project (y/n):
@if %canclc% EQU 1 echo.
@if /I NOT "%buildclc%"=="y" GOTO finishclc
@call %vsenv% %vsabi%
@echo.
@cd %devroot%\llvm-project
@echo Cleanning libclc build...
@echo.
@if EXIST buildsys-clc RD /S /Q buildsys-clc
@if EXIST %devroot%\llvm\clc RD /S /Q %devroot%\llvm\clc
@md buildsys-clc
@cd buildsys-clc
@set buildconf=cmake ../libclc -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="-m%MSYSTEM:~-2%" -DCMAKE_POLICY_DEFAULT_CMP0091=NEW -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded -DCMAKE_INSTALL_PREFIX="../../llvm/clc" -DLIBCLC_TARGETS_TO_BUILD="spirv-mesa3d-;spirv64-mesa3d-" -DCMAKE_PREFIX_PATH="../../llvm/%abi%"
@echo Build configuration command: %buildconf%
@echo.
@%buildconf%
@echo.
@pause
@echo.
@ninja -j %throttle% install
@echo.

:finishclc
@rem Reset environment after libclc build.
@endlocal
@cd %devroot%
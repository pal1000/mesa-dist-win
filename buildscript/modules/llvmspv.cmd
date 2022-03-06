@setlocal

@rem Updating LLVM SPIRV translator source code
@IF EXIST %devroot%\SPIRV-LLVM-Translator IF %gitstate% GTR 0 (
@cd %devroot%\SPIRV-LLVM-Translator
@echo Updating LLVM SPIRV translator...
@git pull -v --progress --recurse-submodules origin
@echo.
)
@IF EXIST %devroot%\SPIRV-LLVM-Translator\spirv-headers-tag.conf IF EXIST %devroot%\SPIRV-LLVM-Translator\projects\SPIRV-Headers IF %gitstate% GTR 0 for /f tokens^=* %%a IN ('type %devroot%\SPIRV-LLVM-Translator\spirv-headers-tag.conf') do @for /f tokens^=* %%b IN ('type %devroot%\SPIRV-LLVM-Translator\projects\SPIRV-Headers\.git\HEAD') do @IF NOT %%a==%%b (
@echo Updating SPIRV headers used by LLVM SPIRV translator...
@cd %devroot%\SPIRV-LLVM-Translator\projects\SPIRV-Headers
@git checkout master
@git pull -v --progress --recurse-submodules origin
@git checkout %%a
@echo.
)

@set canllvmspirv=1
@if NOT EXIST "%devroot%\llvm\build\%abi%\lib\cmake\" set canllvmspirv=0
@IF %cmakestate%==0 set canllvmspirv=0
@IF NOT EXIST "%devroot%\SPIRV-LLVM-Translator\" IF %gitstate% EQU 0 set canllvmspirv=0
@IF EXIST %devroot%\SPIRV-LLVM-Translator\spirv-headers-tag.conf IF NOT EXIST "%devroot%\SPIRV-LLVM-Translator\projects\SPIRV-Headers\" IF %gitstate% EQU 0 set canllvmspirv=0
@IF %canllvmspirv% EQU 1 set /p buildllvmspirv=Build SPIRV LLVM Translator - required for OpenCL (y/n):
@IF %canllvmspirv% EQU 1 echo.
@if /I NOT "%buildllvmspirv%"=="y" GOTO skipspvllvm

@IF NOT EXIST "%devroot%\SPIRV-LLVM-Translator\" (
@echo Getting LLVM SPIRV translator source code...
@git clone -b llvm_release_130 https://github.com/KhronosGroup/SPIRV-LLVM-Translator %devroot%\SPIRV-LLVM-Translator
@echo.
)
@IF EXIST %devroot%\SPIRV-LLVM-Translator\spirv-headers-tag.conf IF NOT EXIST "%devroot%\SPIRV-LLVM-Translator\projects\" MD %devroot%\SPIRV-LLVM-Translator\projects
@IF EXIST %devroot%\SPIRV-LLVM-Translator\spirv-headers-tag.conf IF NOT EXIST "%devroot%\SPIRV-LLVM-Translator\projects\SPIRV-Headers\" (
@echo Getting source code of SPIRV headers used by LLVM SPIRV translator...
@git clone https://github.com/KhronosGroup/SPIRV-Headers %devroot%\SPIRV-LLVM-Translator\projects\SPIRV-Headers
@cd %devroot%\SPIRV-LLVM-Translator\projects\SPIRV-Headers
@for /f tokens^=* %%a IN ('type %devroot%\SPIRV-LLVM-Translator\spirv-headers-tag.conf') do @git checkout %%a
@echo.
)

@rem SPIRV Tools integration for LLVM SPIRV translator. LLVM SPIRV translator 14 feature.
@IF %canllvmspirv% EQU 1 IF EXIST %devroot%\spirv-tools\build\%abi% IF EXIST %devroot%\SPIRV-LLVM-Translator IF %pkgconfigstate% GTR 0 set PKG_CONFIG_PATH=%devroot:\=/%/spirv-tools/build/%abi%/lib/pkgconfig
@IF %canllvmspirv% EQU 1 IF EXIST %devroot%\spirv-tools\build\%abi% IF EXIST %devroot%\SPIRV-LLVM-Translator IF %pkgconfigstate% GTR 0 set PATH=%pkgconfigloc%\;%PATH%

@rem Ask for Ninja use if exists. Load it if opted for it.
@set ninja=n
@if NOT %ninjastate%==0 set /p ninja=Use Ninja build system instead of MsBuild for less storage device strain, faster and more efficient build (y/n):
@if NOT %ninjastate%==0 echo.
@if /I "%ninja%"=="y" if %ninjastate%==1 set PATH=%devroot%\ninja\;%PATH%

@rem Load cmake into build environment.
@if %cmakestate%==1 set PATH=%devroot%\cmake\bin\;%PATH%

@rem Construct build configuration command.
@set buildconf=cmake %devroot:\=/%/SPIRV-LLVM-Translator -G
@if /I NOT "%ninja%"=="y" set buildconf=%buildconf% "Visual Studio %toolset%"
@if %abi%==x86 if /I NOT "%ninja%"=="y" set buildconf=%buildconf% -A Win32
@if %abi%==x64 if /I NOT "%ninja%"=="y" set buildconf=%buildconf% -A x64
@if /I NOT "%ninja%"=="y" IF /I %PROCESSOR_ARCHITECTURE%==AMD64 set buildconf=%buildconf% -Thost=x64
@if /I "%ninja%"=="y" set buildconf=%buildconf%Ninja
@set buildconf=%buildconf% -DLLVM_USE_CRT_RELEASE=MT -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="%devroot:\=/%/llvm/build/%abi%" -DCMAKE_INSTALL_PREFIX="%devroot:\=/%/llvm/build/spv-%abi%" -DLLVM_ENABLE_DIA_SDK=OFF -DLLVM_BUILD_TOOLS=ON -DLLVM_SPIRV_INCLUDE_TESTS=OFF -DLLVM_ENABLE_RTTI=ON -DLLVM_ENABLE_TERMINFO=OFF -DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR="%devroot:\=/%/SPIRV-LLVM-Translator/projects/SPIRV-Headers" -DLLVM_SPIRV_BUILD_EXTERNAL=YES

@echo SPIRV LLVM translator build configuration command^: %buildconf%
@echo.
@pause
@echo.
@echo Cleanning SPIRV LLVM translator build. Please wait...
@echo.
@if EXIST %devroot%\llvm\build\spv-%abi% RD /S /Q %devroot%\llvm\build\spv-%abi%
@if EXIST build\buildsys-%abi% RD /S /Q build\buildsys-%abi%
@if NOT EXIST "build\" MD build
@cd build
@if NOT EXIST "buildsys-%abi%\" md buildsys-%abi%
@cd buildsys-%abi%

@rem Load Visual Studio environment. Can only be loaded in the background when using MsBuild.
@if /I "%ninja%"=="y" call %vsenv% %vsabi%
@if /I "%ninja%"=="y" cd %devroot%\SPIRV-LLVM-Translator\build\buildsys-%abi%
@if /I "%ninja%"=="y" echo.

@rem Configure and execute the build with the configuration made above.
@%buildconf%
@echo.
@pause
@echo.
@if /I NOT "%ninja%"=="y" cmake --build . -j %throttle% --config Release --target install
@if /I "%ninja%"=="y" ninja -j %throttle% install
@echo.

:skipspvllvm
@rem Reset environment after LLVM build.
@endlocal
@cd %devroot%
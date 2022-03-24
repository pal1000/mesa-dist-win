@setlocal

@rem Updating LLVM SPIRV translator source code
@IF EXIST %devroot%\llvm-project\llvm\projects\SPIRV-LLVM-Translator IF %gitstate% GTR 0 (
@cd %devroot%\llvm-project\llvm\projects\SPIRV-LLVM-Translator
@echo Updating LLVM SPIRV translator...
@git pull -v --progress --recurse-submodules origin
@echo.
)
@IF EXIST %devroot%\llvm-project\llvm\projects\SPIRV-LLVM-Translator\spirv-headers-tag.conf IF EXIST %devroot%\llvm-project\llvm\projects\SPIRV-Headers IF %gitstate% GTR 0 for /f delims^=^ eol^= %%a IN ('type %devroot%\llvm-project\llvm\projects\SPIRV-LLVM-Translator\spirv-headers-tag.conf') do @for /f delims^=^ eol^= %%b IN ('type %devroot%\llvm-project\llvm\projects\SPIRV-Headers\.git\HEAD') do @IF NOT %%a==%%b (
@echo Updating SPIRV headers used by LLVM SPIRV translator...
@cd %devroot%\llvm-project\llvm\projects\SPIRV-Headers
@git checkout master
@git pull -v --progress --recurse-submodules origin
@git checkout %%a
@echo.
)

@set canllvmspirv=1
@if NOT EXIST "%devroot%\llvm-project\llvm\projects\" set canllvmspirv=0
@IF %cmakestate%==0 set canllvmspirv=0
@IF NOT EXIST "%devroot%\llvm-project\llvm\projects\SPIRV-LLVM-Translator\" IF %gitstate% EQU 0 set canllvmspirv=0
@IF EXIST %devroot%\llvm-project\llvm\projects\SPIRV-LLVM-Translator\spirv-headers-tag.conf IF NOT EXIST "%devroot%\llvm-project\llvm\projects\SPIRV-Headers\" IF %gitstate% EQU 0 set canllvmspirv=0
@IF %canllvmspirv% EQU 1 set /p buildllvmspirv=Build SPIRV LLVM Translator - required for OpenCL (y/n):
@IF %canllvmspirv% EQU 1 echo.
@if /I NOT "%buildllvmspirv%"=="y" GOTO skipspvllvm

@IF NOT EXIST "%devroot%\llvm-project\llvm\projects\SPIRV-LLVM-Translator\" (
@echo Getting LLVM SPIRV translator source code...
@git clone -b llvm_release_140 https://github.com/KhronosGroup/SPIRV-LLVM-Translator %devroot%\llvm-project\llvm\projects\SPIRV-LLVM-Translator
@echo.
)
@IF EXIST %devroot%\llvm-project\llvm\projects\SPIRV-LLVM-Translator\spirv-headers-tag.conf IF NOT EXIST "%devroot%\llvm-project\llvm\projects\SPIRV-Headers\" (
@echo Getting source code of SPIRV headers used by LLVM SPIRV translator...
@git clone https://github.com/KhronosGroup/SPIRV-Headers %devroot%\llvm-project\llvm\projects\SPIRV-Headers
@cd %devroot%\llvm-project\llvm\projects\SPIRV-Headers
@for /f delims^=^ eol^= %%a IN ('type %devroot%\llvm-project\llvm\projects\SPIRV-LLVM-Translator\spirv-headers-tag.conf') do @git checkout %%a
@echo.
)

@rem SPIRV Tools integration for LLVM SPIRV translator. LLVM SPIRV translator 14 feature.
@IF %canllvmspirv% EQU 1 IF EXIST %devroot%\spirv-tools\build\%abi% IF %pkgconfigstate% GTR 0 set PKG_CONFIG_PATH=%devroot:\=/%/spirv-tools/build/%abi%/lib/pkgconfig
@IF %canllvmspirv% EQU 1 IF EXIST %devroot%\spirv-tools\build\%abi% IF %pkgconfigstate% GTR 0 set PATH=%pkgconfigloc%\;%PATH%

@echo SPIRV LLVM translator build configuration command^: %buildconf% -DCMAKE_INSTALL_PREFIX="%devroot:\=/%/llvm/build/spv-%abi%" -DLLVM_SPIRV_INCLUDE_TESTS=OFF
@echo.
@pause
@echo.
@echo Cleanning SPIRV LLVM translator build. Please wait...
@echo.
@if EXIST %devroot%\llvm\build\spv-%abi% RD /S /Q %devroot%\llvm\build\spv-%abi%
@if EXIST %devroot%\llvm-project\build\bldspv-%abi% RD /S /Q %devroot%\llvm-project\build\bldspv-%abi%
@if NOT EXIST "%devroot%\llvm-project\build\" MD %devroot%\llvm-project\build
@cd %devroot%\llvm-project\build
@if NOT EXIST "%devroot%\llvm-project\build\bldspv-%abi%\" md %devroot%\llvm-project\build\bldspv-%abi%
@cd %devroot%\llvm-project\build\bldspv-%abi%

@rem Load Visual Studio environment. Can only be loaded in the background when using MsBuild.
@if /I "%ninja%"=="y" call %vsenv% %vsabi%
@if /I "%ninja%"=="y" cd %devroot%\llvm-project\build\bldspv-%abi%
@if /I "%ninja%"=="y" echo.

@rem Configure and execute the build with the configuration made above.
@%buildconf% -DCMAKE_INSTALL_PREFIX="%devroot:\=/%/llvm/build/spv-%abi%" -DLLVM_SPIRV_INCLUDE_TESTS=OFF
@echo.
@pause
@echo.
@if /I NOT "%ninja%"=="y" cmake --build . -j %throttle% --config Release --target install
@if /I "%ninja%"=="y" ninja -j %throttle% projects/SPIRV-LLVM-Translator/install
@echo.

:skipspvllvm
@rem Reset environment after LLVM build.
@endlocal
@cd %devroot%
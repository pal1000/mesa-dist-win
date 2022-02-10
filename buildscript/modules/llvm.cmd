@setlocal

@rem Updating LLVM SPIRV translator
@IF EXIST %devroot%\llvm-project\llvm\projects\SPIRV-LLVM-Translator IF %gitstate% GTR 0 (
@cd %devroot%\llvm-project\llvm\projects\SPIRV-LLVM-Translator
@echo Updating LLVM SPIRV translator...
@git pull -v --progress --recurse-submodules origin
@echo.
)
@IF EXIST %devroot%\llvm-project\llvm\projects\SPIRV-LLVM-Translator\spirv-headers-tag.conf IF EXIST %devroot%\llvm-project\llvm\projects\SPIRV-Headers IF %gitstate% GTR 0 for /f tokens^=* %%a IN ('type %devroot%\llvm-project\llvm\projects\SPIRV-LLVM-Translator\spirv-headers-tag.conf') do @for /f tokens^=* %%b IN ('type %devroot%\llvm-project\llvm\projects\SPIRV-Headers\.git\HEAD') do @IF NOT %%a==%%b (
@echo Updating SPIRV headers used by LLVM SPIRV translator...
@cd %devroot%\llvm-project\llvm\projects\SPIRV-Headers
@git checkout master
@git pull -v --progress --recurse-submodules origin
@git checkout %%a
@echo.
)
@cd %devroot%

@rem Check lf LLVM binaries are available
@set llvmbinaries=0
@IF EXIST %devroot%\llvm\build\%abi%\include IF EXIST %devroot%\llvm\build\%abi%\lib set llvmbinaries=1

@rem Check lf LLVM sources are available or obtainable
@set llvmsources=1
@if NOT EXIST %devroot%\llvm\cmake if NOT EXIST %devroot%\llvm-project IF %gitstate EQU 0 set llvmsources=0

@rem Verify if LLVM can be used.
@IF %llvmbinaries% EQU 1 IF %llvmsources% EQU 0 echo LLVM source code not found but LLVM is already built. Skipping LLVM build.
@IF %llvmbinaries% EQU 1 IF %llvmsources% EQU 0 echo.
@IF %llvmbinaries% EQU 1 IF %llvmsources% EQU 0 GOTO skipllvm
@IF %cmakestate%==0 IF %llvmbinaries% EQU 1 echo CMake not found but LLVM is already built. Skipping LLVM build.
@IF %cmakestate%==0 IF %llvmbinaries% EQU 1 echo.
@IF %cmakestate%==0 IF %llvmbinaries% EQU 1 GOTO skipllvm
@IF %cmakestate%==0 echo CMake is required for LLVM build. If you want to build Mesa3D anyway it will be without llvmpipe, swr, RADV, lavapipe and all OpenCL drivers and high performance JIT won't be available for softpipe, osmesa and graw.
@IF %cmakestate%==0 echo.
@IF %cmakestate%==0 GOTO skipllvm
@IF %llvmbinaries% EQU 0 IF %llvmsources% EQU 0 echo WARNING: Both LLVM source code and binaries not found. If you want to build Mesa3D anyway it will be without llvmpipe, swr, RADV, lavapipe and all OpenCL drivers and high performance JIT won't be available for softpipe, osmesa and graw.
@IF %llvmbinaries% EQU 0 IF %llvmsources% EQU 0 echo.
@IF %llvmbinaries% EQU 0 IF %llvmsources% EQU 0 GOTO skipllvm

@rem Ask to do LLVM build
@set /p buildllvm=Begin LLVM build (y/n):
@echo.

@rem LLVM source is found or is obtainable, binaries not found and LLVM build is refused.
@IF %llvmsources% EQU 1 IF %llvmbinaries% EQU 0 if /I NOT "%buildllvm%"=="y" echo WARNING: Not building LLVM. If you want to build Mesa3D anyway it will be without llvmpipe, swr, RADV, lavapipe and all OpenCL drivers and high performance JIT won't be available for softpipe, osmesa and graw.
@IF %llvmsources% EQU 1 IF %llvmbinaries% EQU 0 if /I NOT "%buildllvm%"=="y" echo.
@if /I NOT "%buildllvm%"=="y" GOTO skipllvm

@rem Getting LLVM monorepo if LLVM source is missing
@if NOT EXIST %devroot%\llvm\cmake if NOT EXIST %devroot%\llvm-project (
@echo Getting LLVM source code...
@git clone https://github.com/llvm/llvm-project.git --branch=llvmorg-13.0.1 --depth=1 %devroot%\llvm-project
@echo.
)

@rem Apply is_trivially_copyable patch
@if NOT EXIST %devroot%\llvm-project cd %devroot%
@if NOT EXIST %devroot%\llvm-project set msyspatchdir=%devroot%
@if EXIST %devroot%\llvm-project cd %devroot%\llvm-project
@if EXIST %devroot%\llvm-project set msyspatchdir=%devroot%\llvm-project

@rem Uncomment next line if still using LLVM<11 and build goes on fire
@rem IF %disableootpatch%==0 call %devroot%\%projectname%\buildscript\modules\applypatch.cmd llvm-vs-16_7
@IF %disableootpatch%==1 if EXIST %msysloc%\usr\bin\patch.exe echo Reverting out of tree patches...
@IF %disableootpatch%==1 IF EXIST %msysloc%\usr\bin\patch.exe %msysloc%\usr\bin\bash --login -c "cd $(/usr/bin/cygpath -m ${msyspatchdir});patch -Np1 --no-backup-if-mismatch -R -r - -i $(/usr/bin/cygpath -m ${devroot})/${projectname}/patches/llvm-vs-16_7.patch"
@IF %disableootpatch%==1 if EXIST %msysloc%\usr\bin\patch.exe echo.

@rem Clean or incremental build
@set cleanbuild=y
@set /p cleanbuild=Perform clean build (y/n, y-default):
@echo.

@rem Ask for Ninja use if exists. Load it if opted for it.
@set ninja=n
@if NOT %ninjastate%==0 IF /I NOT "%cleanbuild%"=="n" set /p ninja=Use Ninja build system instead of MsBuild (y/n); less storage device strain, faster and more efficient build:
@if NOT %ninjastate%==0 IF /I NOT "%cleanbuild%"=="n" echo.
@if NOT %ninjastate%==0 IF /I "%cleanbuild%"=="n" IF EXIST %devroot%\llvm-project\build\buildsys-%abi%\build.ninja set ninja=y
@if NOT %ninjastate%==0 IF /I "%cleanbuild%"=="n" IF EXIST %devroot%\llvm\build\buildsys-%abi%\build.ninja set ninja=y
@if /I "%ninja%"=="y" if %ninjastate%==1 set PATH=%devroot%\ninja\;%PATH%

@rem AMDGPU target
@IF /I NOT "%cleanbuild%"=="n" set /p amdgpu=Build AMDGPU target - required by RADV (y/n):
@IF /I NOT "%cleanbuild%"=="n" echo.

@rem Clang and LLD
@if EXIST %devroot%\llvm-project IF /I NOT "%cleanbuild%"=="n" set /p buildclang=Build clang and LLD - required for OpenCL (y/n):
@if EXIST %devroot%\llvm-project IF /I NOT "%cleanbuild%"=="n" echo.

@rem SPIRV-LLVM-Translator
@set canllvmspirv=1
@if NOT EXIST %devroot%\llvm-project set canllvmspirv=0
@IF NOT EXIST %devroot%\llvm-project\llvm\projects\SPIRV-LLVM-Translator IF %gitstate% EQU 0 set canllvmspirv=0
@IF EXIST %devroot%\llvm-project\llvm\projects\SPIRV-LLVM-Translator\spirv-headers-tag.conf IF NOT EXIST %devroot%\llvm-project\llvm\projects\SPIRV-Headers IF %gitstate% EQU 0 set canllvmspirv=0
@if /I "%buildllvmspirv%"=="y" IF NOT EXIST %devroot%\llvm-project\llvm\projects\SPIRV-LLVM-Translator (
@echo Getting LLVM SPIRV translator source code...
@git clone -b llvm_release_130 https://github.com/KhronosGroup/SPIRV-LLVM-Translator %devroot%\llvm-project\llvm\projects\SPIRV-LLVM-Translator
@echo.
)
@if /I "%buildllvmspirv%"=="y" IF EXIST %devroot%\llvm-project\llvm\projects\SPIRV-LLVM-Translator\spirv-headers-tag.conf IF NOT EXIST %devroot%\llvm-project\llvm\projects\SPIRV-Headers (
@echo Getting source code of SPIRV headers used by LLVM SPIRV translator...
@git clone https://github.com/KhronosGroup/SPIRV-Headers %devroot%\llvm-project\llvm\projects\SPIRV-Headers
@cd %devroot%\llvm-project\llvm\projects\SPIRV-Headers
@for /f tokens^=* %%a IN ('type %devroot%\llvm-project\llvm\projects\SPIRV-LLVM-Translator\spirv-headers-tag.conf') do @git checkout %%a
@echo.
)
@if /I "%buildllvmspirv%"=="y" IF NOT EXIST %devroot%\llvm-project\llvm\projects\SPIRV-LLVM-Translator\spirv-headers-tag.conf IF EXIST %devroot%\llvm-project\llvm\projects\SPIRV-Headers RD /S /Q %devroot%\llvm-project\llvm\projects\SPIRV-Headers
@if /I NOT "%buildllvmspirv%"=="y" IF /I NOT "%cleanbuild%"=="n" IF EXIST %devroot%\llvm-project\llvm\projects\SPIRV-LLVM-Translator RD /S /Q %devroot%\llvm-project\llvm\projects\SPIRV-LLVM-Translator
@if /I NOT "%buildllvmspirv%"=="y" IF /I NOT "%cleanbuild%"=="n" IF EXIST %devroot%\llvm-project\llvm\projects\SPIRV-Headers RD /S /Q %devroot%\llvm-project\llvm\projects\SPIRV-Headers

@rem SPIRV Tools integration for LLVM SPIRV translator
@IF %canllvmspirv% EQU 1 IF EXIST %devroot%\spirv-tools\build\%abi% IF EXIST %devroot%\llvm-project\llvm\projects\SPIRV-LLVM-Translator IF %pkgconfigstate% GTR 0 set PKG_CONFIG_PATH=%devroot:\=/%/spirv-tools/build/%abi%/lib/pkgconfig
@IF %canllvmspirv% EQU 1 IF EXIST %devroot%\spirv-tools\build\%abi% IF EXIST %devroot%\llvm-project\llvm\projects\SPIRV-LLVM-Translator IF %pkgconfigstate% GTR 0 set PATH=%pkgconfigloc%\;%PATH%

@rem Load cmake into build environment.
@if %cmakestate%==1 set PATH=%devroot%\cmake\bin\;%PATH%

@rem Construct build configuration command.
@set buildconf=cmake ../..
@if EXIST %devroot%\llvm-project set buildconf=%buildconf%/llvm
@set buildconf=%buildconf% -G
@if /I NOT "%ninja%"=="y" set buildconf=%buildconf% "Visual Studio %toolset%"
@if %abi%==x86 if /I NOT "%ninja%"=="y" set buildconf=%buildconf% -A Win32
@if %abi%==x64 if /I NOT "%ninja%"=="y" set buildconf=%buildconf% -A x64
@if /I NOT "%ninja%"=="y" IF /I %PROCESSOR_ARCHITECTURE%==AMD64 set buildconf=%buildconf% -Thost=x64
@if /I "%ninja%"=="y" set buildconf=%buildconf%Ninja
@set buildconf=%buildconf% -DCMAKE_BUILD_TYPE=Release -DLLVM_USE_CRT_RELEASE=MT -DCMAKE_INSTALL_PREFIX="%devroot:\=/%/llvm/build/%abi%"
@if EXIST %devroot%\llvm-project IF /I NOT "%buildclang%"=="y" set buildconf=%buildconf% -DLLVM_ENABLE_PROJECTS=""
@IF /I "%buildclang%"=="y" set buildconf=%buildconf% -DLLVM_ENABLE_PROJECTS="clang;lld"
@set buildconf=%buildconf% -DLLVM_TARGETS_TO_BUILD=
@IF /I "%amdgpu%"=="y" set buildconf=%buildconf%AMDGPU;
@set buildconf=%buildconf%X86 -DLLVM_OPTIMIZED_TABLEGEN=TRUE -DLLVM_INCLUDE_UTILS=OFF -DLLVM_INCLUDE_RUNTIMES=OFF -DLLVM_INCLUDE_TESTS=OFF -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_INCLUDE_GO_TESTS=OFF -DLLVM_INCLUDE_BENCHMARKS=OFF -DLLVM_BUILD_LLVM_C_DYLIB=OFF -DLLVM_ENABLE_DIA_SDK=OFF
@if EXIST %devroot%\llvm-project IF /I NOT "%buildclang%"=="y" set buildconf=%buildconf% -DLLVM_BUILD_TOOLS=OFF
@if EXIST %devroot%\llvm-project IF /I NOT "%buildclang%"=="y" IF NOT %abi%==%hostabi% set buildconf=%buildconf% -DLLVM_INCLUDE_TOOLS=OFF
@IF /I "%buildclang%"=="y" set buildconf=%buildconf% -DCLANG_BUILD_TOOLS=ON
@if /I "%buildllvmspirv%"=="y" set buildconf=%buildconf% -DLLVM_SPIRV_INCLUDE_TESTS=OFF
@set buildconf=%buildconf% -DLLVM_ENABLE_RTTI=ON -DLLVM_ENABLE_TERMINFO=OFF

@IF /I NOT "%cleanbuild%"=="n" echo LLVM build configuration command^: %buildconf%
@IF /I NOT "%cleanbuild%"=="n" echo.

@rem Clean build
@if NOT EXIST %devroot%\llvm-project cd %devroot%\llvm
@if EXIST %devroot%\llvm-project cd %devroot%\llvm-project
@pause
@echo.
@IF /I NOT "%cleanbuild%"=="n" echo Cleanning LLVM build. Please wait...
@IF /I NOT "%cleanbuild%"=="n" echo.
@IF /I NOT "%cleanbuild%"=="n" if EXIST %devroot%\llvm\build\%abi% RD /S /Q %devroot%\llvm\build\%abi%
@IF /I NOT "%cleanbuild%"=="n" if EXIST build\buildsys-%abi% RD /S /Q build\buildsys-%abi%
@if NOT EXIST "build\" MD build
@cd build
@if NOT EXIST "buildsys-%abi%\" md buildsys-%abi%
@cd buildsys-%abi%
@IF /I NOT "%cleanbuild%"=="n" pause
@IF /I NOT "%cleanbuild%"=="n" echo.

@rem Load Visual Studio environment. Can only be loaded in the background when using MsBuild.
@if /I "%ninja%"=="y" call %vsenv% %vsabi%
@if /I "%ninja%"=="y" if NOT EXIST %devroot%\llvm-project cd %devroot%\llvm\build\buildsys-%abi%
@if /I "%ninja%"=="y" if EXIST %devroot%\llvm-project cd %devroot%\llvm-project\build\buildsys-%abi%
@if /I "%ninja%"=="y" echo.

@rem Configure and execute the build with the configuration made above.
@IF /I NOT "%cleanbuild%"=="n" %buildconf%
@IF /I NOT "%cleanbuild%"=="n" echo.
@IF /I NOT "%cleanbuild%"=="n" pause
@IF /I NOT "%cleanbuild%"=="n" echo.
@if /I NOT "%ninja%"=="y" cmake --build . -j %throttle% --config Release --target install
@if /I NOT "%ninja%"=="y" IF /I NOT "%buildclang%"=="y" IF %abi%==%hostabi% cmake --build . -j %throttle% --config Release --target llvm-config
@if /I NOT "%ninja%"=="y" IF /I NOT "%buildclang%"=="y" IF %abi%==%hostabi% copy .\Release\bin\llvm-config.exe %devroot%\llvm\build\%abi%\bin\
@if /I "%ninja%"=="y" ninja -j %throttle% install
@if /I "%ninja%"=="y" IF /I NOT "%buildclang%"=="y" IF %abi%==%hostabi% ninja -j %throttle% llvm-config
@if /I "%ninja%"=="y" IF /I NOT "%buildclang%"=="y" IF %abi%==%hostabi% copy .\bin\llvm-config.exe %devroot%\llvm\build\%abi%\bin\
@echo.

@rem Avoid race condition in LLVM SPIRV translator sources checkout.
@pause
@echo.

:skipllvm
@rem Reset environment after LLVM build.
@endlocal
@cd %devroot%
@IF NOT EXIST %mesa%\mesa-dist-win\buildinfo md %mesa%\mesa-dist-win\buildinfo
@echo Dumping build environment information. This will take a short while...
@echo.

@rem Dump Windows version
@FOR /F "USEBACKQ tokens=4" %%a IN (`ver`) DO @set winver=%%a
@set winver=%winver:~0,-1%
@IF %toolchain%==msvc FOR /F "USEBACKQ" %%a IN (`%pythonloc% -c "print('.'.join('%winver%'.split('.')[:3]))"`) do @set winver=%%a
@IF %toolchain%==gcc echo python2 -c "print('.'.join('%winver%'.split('.')[:3]))">%mesa%\mesa-dist-win\buildinfo\temp.sh
@IF %toolchain%==gcc FOR /F "USEBACKQ" %%a IN (`%msysloc%\usr\bin\bash --login %mesa%\mesa-dist-win\buildinfo\temp.sh`) do @set winver=%%a
@IF %toolchain%==gcc del %mesa%\mesa-dist-win\buildinfo\temp.sh
@IF %toolchain%==gcc echo Windows %winver%>%mesa%\mesa-dist-win\buildinfo\mingw.txt
@IF %toolchain%==msvc echo Windows %winver%>%mesa%\mesa-dist-win\buildinfo\msvc.txt

@rem Dump Resource Hacker version
@set rhstate=2
@set ERRORLEVEL=0
@where /q ResourceHacker.exe
@IF ERRORLEVEL 1 set rhstate=1
@IF %rhstate%==1 IF NOT EXIST %mesa%\resource-hacker\ResourceHacker.exe set rhstate=0
@IF %rhstate%==1 SET PATH=%mesa%\resource-hacker\;%PATH%
@IF %rhstate% GTR 0 FOR /F "USEBACKQ tokens=*" %%a IN (`where ResourceHacker.exe`) do @set rhloc="%%a"
@IF %rhstate% GTR 0 ResourceHacker.exe -open %rhloc% -action extract -mask VERSIONINFO,, -save %mesa%\mesa-dist-win\buildscript\assets\temp.rc -log NUL
@IF %rhstate% GTR 0 set PATH=%oldpath%
@IF %rhstate% GTR 0 set exitloop=1&FOR /F "tokens=2 skip=2 USEBACKQ" %%a IN (`type %mesa%\mesa-dist-win\buildscript\assets\temp.rc`) do @IF defined exitloop set "exitloop="&set rhver=%%a
@IF %rhstate% GTR 0 IF %toolchain%==gcc echo Ressource Hacker %rhver:,=.%>>%mesa%\mesa-dist-win\buildinfo\mingw.txt
@IF %rhstate% GTR 0 IF %toolchain%==msvc echo Ressource Hacker %rhver:,=.%>>%mesa%\mesa-dist-win\buildinfo\msvc.txt

@rem Dump 7-Zip version
@IF EXIST %mesa%\mesa-dist-win\buildscript\assets\sevenzip.txt set /p sevenzipver=<%mesa%\mesa-dist-win\buildscript\assets\sevenzip.txt
@IF %toolchain%==gcc IF defined sevenzipver echo 7-Zip %sevenzipver%>>%mesa%\mesa-dist-win\buildinfo\mingw.txt
@IF %toolchain%==msvc IF defined sevenzipver echo 7-Zip %sevenzipver%>>%mesa%\mesa-dist-win\buildinfo\msvc.txt

@rem Get Git version
@SET ERRORLEVEL=0
@set gitstate=2
@where /q git.exe
@IF ERRORLEVEL 1 set gitstate=0
@IF NOT %gitstate%==0 FOR /F "USEBACKQ tokens=3" %%a IN (`git --version`) do @set gitver=%%a
@IF NOT %gitstate%==0 set "gitver=%gitver:.windows=%"
@IF defined gitver IF %toolchain%==gcc echo Git %gitver%>>%mesa%\mesa-dist-win\buildinfo\mingw.txt
@IF defined gitver IF %toolchain%==msvc echo Git %gitver%>>%mesa%\mesa-dist-win\buildinfo\msvc.txt

@rem Dump MSYS2 environment
@IF %toolchain%==gcc echo.>>%mesa%\mesa-dist-win\buildinfo\mingw.txt
@IF %toolchain%==gcc echo MSYS2 environment>>%mesa%\mesa-dist-win\buildinfo\mingw.txt
@IF %toolchain%==gcc echo ----------------->>%mesa%\mesa-dist-win\buildinfo\mingw.txt
@IF %toolchain%==gcc %msysloc%\usr\bin\bash --login -c "pacman -Q">>%mesa%\mesa-dist-win\buildinfo\mingw.txt

@rem Dump Visual Studio environment
@IF %toolchain%==msvc echo Visual Studio %msvcver%>>%mesa%\mesa-dist-win\buildinfo\msvc.txt
@IF %toolchain%==msvc call %vsenv% %vsabi%>nul 2>&1
@IF %toolchain%==msvc set PATH=%oldpath%
@IF %toolchain%==msvc echo Windows SDK %WindowsSDKVersion:~0,-1%>>%mesa%\mesa-dist-win\buildinfo\msvc.txt

@rem Dump Python environment
@IF %toolchain%==msvc echo Python %fpythonver%>>%mesa%\mesa-dist-win\buildinfo\msvc.txt
@IF %toolchain%==msvc echo.>>%mesa%\mesa-dist-win\buildinfo\msvc.txt
@IF %toolchain%==msvc echo Python packages>>%mesa%\mesa-dist-win\buildinfo\msvc.txt
@IF %toolchain%==msvc echo --------------->>%mesa%\mesa-dist-win\buildinfo\msvc.txt
@IF %toolchain%==msvc FOR /F "USEBACKQ skip=2 tokens=*" %%a IN (`%pythonloc% -W ignore -m pip list --disable-pip-version-check`) do @echo %%a>>%mesa%\mesa-dist-win\buildinfo\msvc.txt
@IF %toolchain%==msvc echo.>>%mesa%\mesa-dist-win\buildinfo\msvc.txt

@rem Get CMake version
@IF %toolchain%==msvc IF "%cmakestate%"=="1" set PATH=%mesa%\cmake\bin\;%PATH%
@IF %toolchain%==msvc IF NOT "%cmakestate%"=="0" IF NOT "%cmakestate%"=="" set exitloop=1&for /f "tokens=3 USEBACKQ" %%a IN (`cmake --version`) do @if defined exitloop set "exitloop="&echo CMake %%a>>%mesa%\mesa-dist-win\buildinfo\msvc.txt
@IF %toolchain%==msvc IF "%cmakestate%"=="1" set PATH=%oldpath%

@rem Get Ninja version
@IF %toolchain%==msvc IF "%ninjastate%"=="1" set PATH=%mesa%\ninja\;%PATH%
@IF %toolchain%==msvc IF NOT "%ninjastate%"=="0" IF NOT "%ninjastate%"=="" for /f "USEBACKQ" %%a IN (`ninja --version`) do @echo Ninja %%a>>%mesa%\mesa-dist-win\buildinfo\msvc.txt
@IF %toolchain%==msvc IF "%ninjastate%"=="1" set PATH=%oldpath%

@rem Get LLVM version
@IF %toolchain%==msvc IF EXIST %mesa%\llvm\%abi%-%llvmlink%\bin\llvm-config.exe FOR /F "USEBACKQ" %%a IN (`%mesa%\llvm\%abi%-%llvmlink%\bin\llvm-config.exe --version`) do @set llvmver=%%a
@IF %toolchain%==msvc IF EXIST %mesa%\llvm\%abi%-%llvmlink%\bin\llvm-config.exe echo LLVM %llvmver%>>%mesa%\mesa-dist-win\buildinfo\msvc.txt

@rem Get flex and bison version
@IF %toolchain%==msvc IF "%flexstate%"=="1" set PATH=%mesa%\flexbison\;%PATH%
@IF %toolchain%==msvc IF NOT "%flexstate%"=="0" IF NOT "%flexstate%"=="" set exitloop=1&for /f "tokens=* USEBACKQ" %%a IN (`where changelog.md`) do @for /f "tokens=3 skip=6 USEBACKQ" %%b IN (`type %%a`) do @if defined exitloop set "exitloop="&echo Winflexbison package %%b>>%mesa%\mesa-dist-win\buildinfo\msvc.txt
@IF %toolchain%==msvc IF NOT "%flexstate%"=="0" IF NOT "%flexstate%"=="" for /f "tokens=2 USEBACKQ" %%a IN (`win_flex --version`) do @echo flex %%a>>%mesa%\mesa-dist-win\buildinfo\msvc.txt
@IF %toolchain%==msvc IF NOT "%flexstate%"=="0" IF NOT "%flexstate%"=="" set exitloop=1&for /f "tokens=4 USEBACKQ" %%a IN (`win_bison --version`) do @if defined exitloop set "exitloop="&echo Bison %%a>>%mesa%\mesa-dist-win\buildinfo\msvc.txt
@IF %toolchain%==msvc IF "%flexstate%"=="1" set PATH=%oldpath%

@rem Build comands
@IF %toolchain%==gcc echo.>>%mesa%\mesa-dist-win\buildinfo\mingw.txt
@IF %toolchain%==gcc echo Build commands>>%mesa%\mesa-dist-win\buildinfo\mingw.txt
@IF %toolchain%==gcc echo -------------->>%mesa%\mesa-dist-win\buildinfo\mingw.txt
@IF %toolchain%==msvc echo.>>%mesa%\mesa-dist-win\buildinfo\msvc.txt
@IF %toolchain%==msvc echo Build commands>>%mesa%\mesa-dist-win\buildinfo\msvc.txt
@IF %toolchain%==msvc echo -------------->>%mesa%\mesa-dist-win\buildinfo\msvc.txt

@IF %toolchain%==gcc echo [2] scons build=release platform=windows machine=x86 toolchain=mingw libgl-gdi osmesa graw-gdi>>%mesa%\mesa-dist-win\buildinfo\mingw.txt
@IF %toolchain%==gcc echo [3] scons build=release platform=windows machine=x86_64 toolchain=mingw libgl-gdi osmesa graw-gdi>>%mesa%\mesa-dist-win\buildinfo\mingw.txt
@IF %toolchain%==gcc echo.>>%mesa%\mesa-dist-win\buildinfo\mingw.txt
@IF %toolchain%==gcc echo Notes>>%mesa%\mesa-dist-win\buildinfo\mingw.txt
@IF %toolchain%==gcc echo ----->>%mesa%\mesa-dist-win\buildinfo\mingw.txt
@IF %toolchain%==gcc echo [0] Apply mesa-dist-win\patches\msys2-mingw_w64-fixes.patch before building Mesa.>>%mesa%\mesa-dist-win\buildinfo\mingw.txt
@IF %toolchain%==gcc echo [1] Apply mesa-dist-win\patches\s3tc.patch to enable S3TC texture cache.>>%mesa%\mesa-dist-win\buildinfo\mingw.txt
@IF %toolchain%==gcc echo [2] Navigate to Mesa3D source code in a MSYS2 MINGW32 shell and execute this command.>>%mesa%\mesa-dist-win\buildinfo\mingw.txt
@IF %toolchain%==gcc echo [3] Navigate to Mesa3D source code in a MSYS2 MINGW64 shell and execute this command.>>%mesa%\mesa-dist-win\buildinfo\mingw.txt

@IF %toolchain%==msvc echo [1] md buildsys-x86-%llvmlink%^&cd buildsys-x86-%llvmlink%^&cmake -G "Ninja" -DLLVM_TARGETS_TO_BUILD=X86 -DCMAKE_BUILD_TYPE=Release -DLLVM_USE_CRT_RELEASE=%llvmlink% -DLLVM_ENABLE_RTTI=1 -DLLVM_ENABLE_TERMINFO=OFF -DCMAKE_INSTALL_PREFIX=../x86-%llvmlink% ..>>%mesa%\mesa-dist-win\buildinfo\msvc.txt
@IF %toolchain%==msvc echo [2] md buildsys-x64-%llvmlink%^&cd buildsys-x64-%llvmlink%^&cmake -G "Ninja" -DLLVM_TARGETS_TO_BUILD=X86 -DCMAKE_BUILD_TYPE=Release -DLLVM_USE_CRT_RELEASE=%llvmlink% -DLLVM_ENABLE_RTTI=1 -DLLVM_ENABLE_TERMINFO=OFF -DCMAKE_INSTALL_PREFIX=../x64-%llvmlink% ..>>%mesa%\mesa-dist-win\buildinfo\msvc.txt
@IF %toolchain%==msvc echo [3] ninja install>>%mesa%\mesa-dist-win\buildinfo\msvc.txt
@IF %toolchain%==msvc echo [4] scons build=release platform=windows machine=x86 libgl-gdi osmesa graw-gdi>>%mesa%\mesa-dist-win\buildinfo\msvc.txt
@IF %toolchain%==msvc echo [4] scons build=release platform=windows machine=x86_64 libgl-gdi osmesa graw-gdi>>%mesa%\mesa-dist-win\buildinfo\msvc.txt
@IF %toolchain%==msvc echo.>>%mesa%\mesa-dist-win\buildinfo\msvc.txt
@IF %toolchain%==msvc echo Notes>>%mesa%\mesa-dist-win\buildinfo\msvc.txt
@IF %toolchain%==msvc echo ----->>%mesa%\mesa-dist-win\buildinfo\msvc.txt
@IF %toolchain%==msvc echo [0] Apply mesa-dist-win\patches\s3tc.patch to enable S3TC texture cache.>>%mesa%\mesa-dist-win\buildinfo\msvc.txt
@IF %toolchain%==msvc echo [1] Natigate to LLVM source code in a Visual Studio x64_x86 Cross Tools Command Prompt and execute this command.>>%mesa%\mesa-dist-win\buildinfo\msvc.txt
@IF %toolchain%==msvc echo [2] Natigate to LLVM source code in a Visual Studio x64 Native Tools Command Prompt and execute this command.>>%mesa%\mesa-dist-win\buildinfo\msvc.txt
@IF %toolchain%==msvc echo [3] Execute this command after [1] and [2] respectively on same Visual Studio command line console.>>%mesa%\mesa-dist-win\buildinfo\msvc.txt
@IF %toolchain%==msvc echo [4] Navigate to Mesa3D source code in a standard Windows Command Prompt and execute any or both these commands.>>%mesa%\mesa-dist-win\buildinfo\msvc.txt

@rem Finished environment information dump.
@echo Done.
@IF %toolchain%==gcc echo Environment information has been written to %mesa%\mesa-dist-win\buildinfo\mingw.txt.
@IF %toolchain%==msvc echo Environment information has been written to %mesa%\mesa-dist-win\buildinfo\msvc.txt.
@echo.

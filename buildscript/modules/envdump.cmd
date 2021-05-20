@setlocal
@IF NOT EXIST %devroot%\%projectname%\buildinfo md %devroot%\%projectname%\buildinfo
@set /p enableenvdump=Do you want to dump build environment information to a text file (y/n):
@echo.
@IF /I NOT "%enableenvdump%"=="y" GOTO skipenvdump
@echo Dumping build environment information. This will take a short while...
@echo.
@IF NOT %toolchain%==msvc echo Build environment>%devroot%\%projectname%\buildinfo\mingw.txt
@IF NOT %toolchain%==msvc echo ----------------->>%devroot%\%projectname%\buildinfo\mingw.txt
@IF %toolchain%==msvc echo Build environment>%devroot%\%projectname%\buildinfo\msvc.txt
@IF %toolchain%==msvc echo ----------------->>%devroot%\%projectname%\buildinfo\msvc.txt

@rem Dump Windows version
@FOR /F "USEBACKQ tokens=2 delims=[" %%a IN (`ver`) DO @set winver=%%a
@set winver=%winver:~0,-1%
@FOR /F "USEBACKQ tokens=2 delims= " %%a IN (`echo %winver%`) DO @set winver=%%a
@FOR /F "USEBACKQ tokens=1-3 delims=." %%a IN (`echo %winver%`) DO @set winver=%%a.%%b.%%c
@IF NOT %toolchain%==msvc echo Windows %winver%>>%devroot%\%projectname%\buildinfo\mingw.txt
@IF %toolchain%==msvc echo Windows %winver%>>%devroot%\%projectname%\buildinfo\msvc.txt

@rem Dump Resource Hacker version
@IF %rhstate%==1 SET PATH=%devroot%\resource-hacker\;%PATH%
@IF %rhstate% GTR 0 FOR /F "USEBACKQ tokens=*" %%a IN (`where ResourceHacker.exe`) do @set rhloc="%%a"
@IF %rhstate% GTR 0 ResourceHacker.exe -open %rhloc% -action extract -mask VERSIONINFO,, -save %devroot%\%projectname%\buildscript\assets\temp.rc -log NUL
@IF %rhstate% GTR 0 set exitloop=1
@IF %rhstate% GTR 0 FOR /F "tokens=2 skip=2 USEBACKQ" %%a IN (`type %devroot%\%projectname%\buildscript\assets\temp.rc`) do @IF defined exitloop (
set "exitloop="
set rhver=%%a
)
@IF %rhstate% GTR 0 IF NOT %toolchain%==msvc echo Ressource Hacker %rhver:,=.%>>%devroot%\%projectname%\buildinfo\mingw.txt
@IF %rhstate% GTR 0 IF %toolchain%==msvc echo Ressource Hacker %rhver:,=.%>>%devroot%\%projectname%\buildinfo\msvc.txt

@rem Dump 7-Zip version and compression level
@set sevenzipver=21.02
@IF NOT %toolchain%==msvc echo 7-Zip %sevenzipver% ultra compression>>%devroot%\%projectname%\buildinfo\mingw.txt
@IF %toolchain%==msvc echo 7-Zip %sevenzipver% ultra compression>>%devroot%\%projectname%\buildinfo\msvc.txt

@rem Get Git version
@IF NOT %gitstate%==0 FOR /F "USEBACKQ tokens=3" %%a IN (`git --version`) do @set gitver=%%a
@IF NOT %gitstate%==0 set "gitver=%gitver:.windows=%"
@IF defined gitver IF NOT %toolchain%==msvc echo Git %gitver%>>%devroot%\%projectname%\buildinfo\mingw.txt
@IF defined gitver IF %toolchain%==msvc echo Git %gitver%>>%devroot%\%projectname%\buildinfo\msvc.txt

@rem Get Vulkan SDK version
@set vksdkstd=1
@IF NOT defined VULKAN_SDK IF NOT defined VK_SDK_PATH set vksdkstd=0
@IF %vksdkstd% EQU 1 IF NOT %toolchain%==msvc echo Vulkan SDK 1.2.176.1 (LunarG)>>%devroot%\%projectname%\buildinfo\mingw.txt

@rem Dump MSYS2 environment
@IF NOT %toolchain%==msvc echo.>>%devroot%\%projectname%\buildinfo\mingw.txt
@IF NOT %toolchain%==msvc echo MSYS2 environment>>%devroot%\%projectname%\buildinfo\mingw.txt
@IF NOT %toolchain%==msvc echo ----------------->>%devroot%\%projectname%\buildinfo\mingw.txt
@IF NOT %toolchain%==msvc %msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -Q">>%devroot%\%projectname%\buildinfo\mingw.txt

@rem Dump Visual Studio environment
@IF %toolchain%==msvc echo %msvcname% v%msvcver%>>%devroot%\%projectname%\buildinfo\msvc.txt
@IF %toolchain%==msvc call %vsenv% %vsabi%>nul 2>&1
@IF %toolchain%==msvc echo Windows SDK %WindowsSDKVersion:~0,-1%>>%devroot%\%projectname%\buildinfo\msvc.txt

@rem Dump Python environment
@IF %toolchain%==msvc echo Python %pythonver%>>%devroot%\%projectname%\buildinfo\msvc.txt
@IF %toolchain%==msvc echo.>>%devroot%\%projectname%\buildinfo\msvc.txt
@IF %toolchain%==msvc echo Python packages>>%devroot%\%projectname%\buildinfo\msvc.txt
@IF %toolchain%==msvc echo --------------->>%devroot%\%projectname%\buildinfo\msvc.txt
@IF %toolchain%==msvc FOR /F "USEBACKQ skip=2 tokens=*" %%a IN (`%pythonloc% -W ignore -m pip list --disable-pip-version-check`) do @echo %%a>>%devroot%\%projectname%\buildinfo\msvc.txt
@IF %toolchain%==msvc echo.>>%devroot%\%projectname%\buildinfo\msvc.txt

@rem Get CMake version
@IF %toolchain%==msvc IF "%cmakestate%"=="1" set PATH=%devroot%\cmake\bin\;%PATH%
@IF %toolchain%==msvc IF NOT "%cmakestate%"=="0" IF NOT "%cmakestate%"=="" set exitloop=1
@IF %toolchain%==msvc IF NOT "%cmakestate%"=="0" IF NOT "%cmakestate%"=="" for /f "tokens=3 USEBACKQ" %%a IN (`cmake --version`) do @if defined exitloop (
set "exitloop="
echo CMake %%a>>%devroot%\%projectname%\buildinfo\msvc.txt
)

@rem Get Ninja version
@IF %toolchain%==msvc IF "%ninjastate%"=="1" set PATH=%devroot%\ninja\;%PATH%
@IF %toolchain%==msvc IF NOT "%ninjastate%"=="0" IF NOT "%ninjastate%"=="" for /f "USEBACKQ" %%a IN (`ninja --version`) do @echo Ninja %%a>>%devroot%\%projectname%\buildinfo\msvc.txt

@rem Get LLVM version
@IF %toolchain%==msvc IF EXIST %devroot%\llvm\x64\bin\llvm-config.exe FOR /F "USEBACKQ" %%a IN (`%devroot%\llvm\x64\bin\llvm-config.exe --version`) do @set llvmver=%%a
@IF %toolchain%==msvc IF EXIST %devroot%\llvm\x64\bin\llvm-config.exe echo LLVM %llvmver%>>%devroot%\%projectname%\buildinfo\msvc.txt

@rem Get flex and bison version
@IF %toolchain%==msvc IF "%flexstate%"=="1" set PATH=%devroot%\flexbison\;%PATH%
@IF %toolchain%==msvc IF NOT "%flexstate%"=="0" IF NOT "%flexstate%"=="" set exitloop=1
@IF %toolchain%==msvc IF NOT "%flexstate%"=="0" IF NOT "%flexstate%"=="" for /f "tokens=* USEBACKQ" %%a IN (`where changelog.md`) do @for /f "tokens=3 skip=6 USEBACKQ" %%b IN (`type %%a`) do @if defined exitloop (
set "exitloop="
echo Winflexbison package %%b>>%devroot%\%projectname%\buildinfo\msvc.txt
)
@IF %toolchain%==msvc IF NOT "%flexstate%"=="0" IF NOT "%flexstate%"=="" for /f "tokens=2 USEBACKQ" %%a IN (`win_flex --version`) do @echo flex %%a>>%devroot%\%projectname%\buildinfo\msvc.txt
@IF %toolchain%==msvc IF NOT "%flexstate%"=="0" IF NOT "%flexstate%"=="" set exitloop=1
@IF %toolchain%==msvc IF NOT "%flexstate%"=="0" IF NOT "%flexstate%"=="" for /f "tokens=4 USEBACKQ" %%a IN (`win_bison --version`) do @if defined exitloop (
set "exitloop="
echo Bison %%a>>%devroot%\%projectname%\buildinfo\msvc.txt
)

@rem Get pkgconf/pkg-config version
@set pkgconfigver=null
@IF %toolchain%==msvc IF %pkgconfigstate% GTR 0 FOR /F "USEBACKQ" %%a IN (`%pkgconfigloc%\pkg-config.exe --version`) do @set pkgconfigver=%%a
@IF NOT "%pkgconfigver%"=="null" IF %pkgconfigver:~0,1%==0 set pkgconfigver=pkg-config %pkgconfigver%
@IF NOT "%pkgconfigver%"=="null" IF NOT %pkgconfigver:~0,1%==0 set pkgconfigver=pkgconf %pkgconfigver%
@IF NOT "%pkgconfigver%"=="null" echo %pkgconfigver%>>%devroot%\%projectname%\buildinfo\msvc.txt

@rem Finished environment information dump.
@echo Done.
@IF NOT %toolchain%==msvc echo Environment information has been written to %devroot%\%projectname%\buildinfo\mingw.txt.
@IF %toolchain%==msvc echo Environment information has been written to %devroot%\%projectname%\buildinfo\msvc.txt.
@echo.

:skipenvdump
@endlocal
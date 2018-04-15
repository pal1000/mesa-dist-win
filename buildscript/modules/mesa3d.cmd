@REM Aquire Mesa3D source code and enable S3TC texture cache automatically if possible.
@set PATH=%oldpath%
@if %pythonver%==2 IF %flexstate%==0 (
@echo winflexbison is required to build Mesa3D.
GOTO skipmesa
)
@if %pythonver% GEQ 3 GOTO skipmesa
@cd %mesa%
@if NOT EXIST mesa if %gitstate%==0 (
@echo Fatal: Both Mesa code and Git are missing. At least one is required. Execution halted.
@GOTO skipmesa
)
@set buildmesa=n
@if %gitstate%==0 echo Error: Git not found. Auto-patching disabled.
@if NOT EXIST mesa echo Warning: Mesa3D source code not found.
@if NOT EXIST mesa set /p buildmesa=Download mesa code and build (y/n):
@if NOT EXIST mesa if /i NOT "%buildmesa%"=="y" GOTO skipmesa
@if NOT EXIST mesa set branch=master
@if NOT EXIST mesa set /p branch=Enter Mesa source code branch name - defaults to master:
@if NOT EXIST mesa echo.
@if NOT EXIST mesa git clone --recurse-submodules --depth=1 --branch=%branch% git://anongit.freedesktop.org/mesa/mesa mesa
@echo.
@if EXIST mesa if /i NOT "%buildmesa%"=="y" set /p buildmesa=Begin mesa build. Proceed (y/n):
@if /i NOT "%buildmesa%"=="y" GOTO skipmesa
@cd mesa
@set LLVM=%mesa%\llvm\%abi%
@set /p mesaver=<VERSION
@if "%mesaver:~-7%"=="0-devel" set /a intmesaver=%mesaver:~0,2%%mesaver:~3,1%00
@if "%mesaver:~5,4%"=="0-rc" set /a intmesaver=%mesaver:~0,2%%mesaver:~3,1%00+%mesaver:~9%
@if NOT "%mesaver:~5,2%"=="0-" set /a intmesaver=%mesaver:~0,2%%mesaver:~3,1%50+%mesaver:~5%
@if EXIST mesapatched.ini GOTO configmesabuild
@if %gitstate%==0 GOTO configmesabuild
@git apply -v ..\mesa-dist-win\patches\s3tc.patch
@echo 1 > mesapatched.ini
@echo.

:configmesabuild
@cd %mesa%\mesa
@if %pythonver%==2 set buildcmd=%pythonloc% %pythonloc:~0,-11%Scripts\scons.py" build=release platform=windows machine=%longabi% libgl-gdi
@if %pythonver% GEQ 3 set buildcmd=%mesonloc% . .\build\windows-%longabi% -Dplatforms=windows
@set /p osmesa=Do you want to build off-screen rendering drivers (y/n):
@echo.
@if %pythonver%==2 if /I "%osmesa%"=="y" set buildcmd=%buildcmd% osmesa
@set llvmless=n
@if EXIST %LLVM% set /p llvmless=Build Mesa without LLVM (y/n). Only softpipe and osmesa will be available:
@if EXIST %LLVM% echo.
@if NOT EXIST %LLVM% set /p llvmless=Build Mesa without LLVM (y=yes/n=quit). Only softpipe and osmesa will be available:
@if NOT EXIST %LLVM% echo.
@if %pythonver%==2 if /I "%llvmless%"=="y" set buildcmd=%buildcmd% llvm=no
@if /I "%llvmless%"=="y" GOTO build_mesa
@if /I NOT "%llvmless%"=="y" if NOT EXIST %LLVM% echo User refused to build Mesa without LLVM.
@if /I NOT "%llvmless%"=="y" if NOT EXIST %LLVM% echo.
@if /I NOT "%llvmless%"=="y" if NOT EXIST %LLVM% GOTO skipmesa
@set swrdrv=n
@if %abi%==x64 set /p swrdrv=Do you want to build swr drivers? (y=yes):
@if %abi%==x64 echo.
@if %pythonver%==2 if /I "%swrdrv%"=="y" set buildcmd=%buildcmd% swr=1
@set /p graw=Do you want to build graw library (y/n):
@echo.
@if %pythonver%==2 if /I "%graw%"=="y" set buildcmd=%buildcmd% graw-gdi

:build_mesa
@if %pythonver%==2 IF %flexstate%==1 set PATH=%mesa%\flexbison\;%PATH%
@cd %mesa%\mesa
@set cleanbuild=n
@if EXIST build\windows-%longabi% set /p cleanbuild=Do you want to clean build (y/n):
@if EXIST build\windows-%longabi% echo.
@if /I "%cleanbuild%"=="y" RD /S /Q build\windows-%longabi%
@if NOT EXIST build md build
@if NOT EXIST build\windows-%longabi% md build\windows-%longabi%
@if NOT EXIST build\windows-%longabi%\git_sha1.h echo 0 > build\windows-%longabi%\git_sha1.h
@echo.
@if %pythonver% GEQ 3 call %vsenv%
@if %pythonver% GEQ 3 echo.
@%buildcmd%
@echo.
@if %pythonver% GEQ 3 cmd

:skipmesa
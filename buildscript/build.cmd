@TITLE Building Mesa3D
@cd "%~dp0"
@cd ..\..\
@for %%I in ("%cd%") do @set mesa=%%~sI
@set mesa=%mesa%\
@where /q cmake.exe
@IF ERRORLEVEL 1 set PATH=%mesa%cmake\bin\;%PATH%
@set ERRORLEVEL=0
@where /q python.exe
@IF ERRORLEVEL 1 set PATH=%mesa%Python\;%mesa%Python\Scripts\;%PATH%
@set ERRORLEVEL=0
@set pyupd=n
@where python.exe>pyupd.ini
@set /p pythonloc=<pyupd.ini
@set makoloc="%pythonloc:python.exe=%Lib\site-packages\mako"
@set sconsloc="%pythonloc:python.exe=%Scripts\scons.py"
@if NOT EXIST %makoloc% set pyupd=y
@if EXIST %makoloc% set /p pyupd=Install/update python modules (y/n):
@if "%pyupd%"=="y" (
@python -m pip install -U mako
@python -m pip freeze > requirements.txt
@python -m pip install -r requirements.txt --upgrade
@del requirements.txt
@echo.
)
@set abi=x86
@set /p x64=Do you want to build for x64? (y/n) Otherwise build for x86:
@if /I "%x64%"=="y" set abi=x64
@set longabi=%abi%
@if %abi%==x64 set longabi=x86_64
@set altabi=i686
@if %abi%==x64 set altabi=%longabi%
@set minabi=32
@if %abi%==x64 set minabi=64
@set targetabi=x86
@if %abi%==x64 set targetabi=amd64
@set hostabi=x86
@set vsenv="%ProgramFiles%
@if NOT "%ProgramW6432%"=="" set hostabi=amd64
@set vsabi=%minabi%
@if NOT %targetabi%==%hostabi% set vsabi=%hostabi%_%targetabi%
@if NOT "%ProgramW6432%"=="" set vsenv=%vsenv% (x86)
@set vsenv15=%vsenv%\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvars%vsabi%.bat"
@if %vsabi%==32 set vsenv14=%VS140COMNTOOLS%..\..\VC\bin\vcvars%vsabi%.bat"
@if %vsabi%==64 set vsenv14=%VS140COMNTOOLS%..\..\VC\bin\%targetabi%\vcvars%vsabi%.bat"
@if NOT %targetabi%==%hostabi% set vsenv14=%VS140COMNTOOLS%..\..\VC\bin\%vsabi%\vcvars%vsabi%.bat"
@set gcc=%mesa%mingw-w64\%abi%\mingw%minabi%\bin
@set vsenvloaded=0
@set toolset=14
@if EXIST %vsenv15% set toolset=15
@if EXIST toolset-%abi%.ini set /p toolset=<toolset-%abi%.ini
@set vsenv=%vsenv14%
@if %toolset%==15 set vsenv=%vsenv15%
@set PATH=%mesa%flexbison\;%PATH%
@TITLE Building Mesa3D %abi%

:build_llvm
@set /p buildllvm=Begin LLVM build. Only needs to run once for each ABI and version. Proceed (y/n):
@if /I NOT "%buildllvm%"=="y" GOTO prep_mesa
@echo.
@cd %mesa%llvm
@if EXIST %abi% RD /S /Q %abi%
@if EXIST cmake-%abi% RD /S /Q cmake-%abi%
@md cmake-%abi%
@cd cmake-%abi%
@set toolchain=Visual Studio 14
@set toolset=14
@if EXIST %vsenv15% set toolchain=Visual Studio 15 2017
@if EXIST %vsenv15% set toolset=15
@set ninja=n
@set oldtoolset=n
@set x64compiler= -Thost=x64
@if EXIST %mesa%ninja set ninja=1
@if EXIST %vsenv15% set ninja=%ninja%2
@if %ninja%==12 set /p oldtoolset=Build with MSVC 2015 backward compatibility toolset, alternative solution for LLVM 3.9.1 build with Visual Studio 2017 (y/n):
@if %ninja%==12 echo.
@if /I "%oldtoolset%"=="y" set ninja=y
@if /I "%oldtoolset%"=="y" set toolset=14
@if %ninja%==12 set ninja=2
@if %ninja%==1 set ninja=2
@if %ninja%==2 set /p ninja=Use Ninja build system instead of MsBuild, there is no requirement to do this with the primary toolset though (y/n):
@echo.
@if /I "%ninja%"=="y" set toolchain=Ninja
@if /I "%ninja%"=="y" set x64compiler=
@if "%toolchain%"=="Ninja" set PATH=%mesa%ninja\;%PATH%
@set vsenv=%vsenv14%
@if %toolset%==15 set vsenv=%vsenv15%
@set llvmbuildsys=%CD%
@call %vsenv%
@set vsenvloaded=1
@echo.
@set modtoolchainabi=0
@if NOT "%toolchain%"=="Ninja" set modtoolchainabi=1
@if %abi%==x64 set modtoolchainabi=%modtoolchainabi%2
@if %modtoolchainabi%==12 set toolchain=%toolchain% Win64
@cd %llvmbuildsys%
@if NOT %hostabi%==amd64 set x64compiler=
@cmake -G "%toolchain%"%x64compiler% -DLLVM_TARGETS_TO_BUILD=X86 -DCMAKE_BUILD_TYPE=Release -DLLVM_USE_CRT_RELEASE=MT -DLLVM_ENABLE_RTTI=1 -DLLVM_ENABLE_TERMINFO=OFF -DCMAKE_INSTALL_PREFIX=../%abi% ..
@echo.
@pause
@echo.
@if NOT "%toolchain%"=="Ninja" cmake --build . --config Release --target install
@if "%toolchain%"=="Ninja" ninja install
@echo.
@echo %toolset% > %mesa%toolset-%abi%.ini

:prep_mesa
@cd %mesa%
@set mesapatched=0
@set branch=none
@set haltmesabuild=n
@set prepfail=0
@where /q git.exe
@IF ERRORLEVEL 1 (
@set ERRORLEVEL=0
@echo Error: Git not found. Patching disabled.
@set prepfail=1
)
@if NOT EXIST mesa set mesapatched=0
@if NOT EXIST mesa echo Warning: Mesa3D source code not found.
@if NOT EXIST mesa set prepfail=%prepfail%2
@if %prepfail%==12 echo Fatal: Both Mesa code and Git are missing. At least one is required. Execution halted.
@if %prepfail%==12 GOTO distcreate
@if NOT EXIST mesa set /p haltmesabuild=Press Y to abort execution. Press any other key to download Mesa via Git:
@if /I "%haltmesabuild%"=="y" GOTO distcreate
@if NOT EXIST mesa set /p branch=Enter Mesa source code branch name - defaults to master:
@if "%branch%"=="" set branch=master
@if "%branch%"=="none" set branch=master
@if NOT EXIST mesa echo.
@if NOT EXIST mesa git clone --depth=1 --branch=%branch% git://anongit.freedesktop.org/mesa/mesa mesa
@cd mesa
@set /p mesaver=<VERSION
@set branch=%mesaver:~0,4%
@if EXIST mesapatched.ini GOTO build_mesa
@if "%branch%"=="17.2" git apply -v ..\mesa-dist-win\patches\scons-llvm5.patch
@git apply -v ..\mesa-dist-win\patches\s3tc.patch
@if NOT "%mesaver:~-5%"=="devel" git apply -v ..\mesa-dist-win\patches\scons3.patch
@set mesapatched=1
@echo %mesapatched% > mesapatched.ini
@echo.

:build_mesa
@set /p buildmesa=Begin mesa build. Proceed (y/n):
@if /i NOT "%buildmesa%"=="y" GOTO build_dxtn
@echo.
@set LLVM=%mesa%llvm\%abi%
@if NOT EXIST %LLVM% (
@echo Could not find LLVM, aborting mesa build.
@echo.
@pause
@GOTO build_dxtn
)
@cd %mesa%mesa
@set openswr=n
@set sconscmd=python %sconsloc% build=release platform=windows machine=%longabi% libgl-gdi
@if %abi%==x64 set /p openswr=Do you want to build OpenSWR drivers? (y=yes):
@echo.
@if /I "%openswr%"=="y" set sconscmd=%sconscmd% swr=1
@set /p osmesa=Do you want to build off-screen rendering drivers (y/n):
@echo.
@if /I "%osmesa%"=="y" set sconscmd=%sconscmd% osmesa
@set /p graw=Do you want to build graw library (y/n):
@echo.
@if /I "%graw%"=="y" set sconscmd=%sconscmd% graw-gdi
@GOTO build_with_vs

:build_with_mingw
@set mingw=n
@set mingwtest=0
@if EXIST %gcc% set mingwtest=1
@set msys2=%mesa%msys64\msys2_shell.cmd
@if EXIST %msys2% set mingwtest=%mingwtest%2
@if %mingwtest%==12 set /p mingw=Do you want to build with MinGW-W64 instead of Visual Studio (y=yes):
@set ERRORLEVEL=0
@where /q gcc.exe
@IF ERRORLEVEL 1 set PATH=%gcc%\;%PATH%
@set ERRORLEVEL=0
@if /I "%mingw%"=="y" set sconscmd=%sconscmd% toolchain=crossmingw
@if /I "%mingw%"=="y" copy %gcc%\%altabi%-w64-mingw32-gcc-ar.exe %gcc%\%altabi%-w64-mingw32-ar.exe
@if /I "%mingw%"=="y" copy %gcc%\%altabi%-w64-mingw32-gcc-ranlib.exe %gcc%\%altabi%-w64-mingw32-ranlib.exe
@if /I "%mingw%"=="y" call "%msys2%" -use-full-path
@if /I "%mingw%"=="y" (
pacman -Syu
pacman -S python2
wget https://bootstrap.pypa.io/get-pip.py
python2 get-pip.py
pip install -U mako
pip install -U scons
pip freeze > requirements.txt
pip install -r requirements.txt --upgrade
cd $mesa
cd mesa
GOTO build_mesa_exec
)

:build_with_vs
@set cleanbuild=n
@if EXIST build\windows-%longabi% set /p cleanbuild=Do you want to clean build (y/n):
@if EXIST build\windows-%longabi% echo.
@if /I "%cleanbuild%"=="y" RD /S /Q build\windows-%longabi%
@if %vsenvloaded%==0 (
@call %vsenv%
@cd %mesa%mesa
@echo.
)

:build_mesa_exec
@%sconscmd%
@echo.

:build_dxtn
@if NOT EXIST %gcc% GOTO distcreate
@if NOT EXIST %mesa%dxtn GOTO distcreate
@set /p builddxtn=Do you want to build S3 texture compression library? (y/n):
@if /i NOT "%builddxtn%"=="y" GOTO distcreate
@set PATH=%gcc%\;%PATH%
@cd %mesa%dxtn
@echo.
@if EXIST %abi% RD /S /Q %abi%
@MD %abi%
@set dxtn=gcc -shared -m%minabi% -v *.c *.h -I ..\mesa\include -Wl,--dll,--dynamicbase,--enable-auto-image-base,--nxcompat -o %abi%\dxtn.dll
@%dxtn%
@echo.

:distcreate
@set /p dist=Create or update Mesa3D distribution package (y/n):
@echo.
@if /I NOT "%dist%"=="y" GOTO exit
@cd %mesa%
@if NOT EXIST mesa-dist-win MD mesa-dist-win
@cd mesa-dist-win
@if NOT EXIST bin MD bin
@cd bin
@if EXIST %abi% RD /S /Q %abi%
@MD %abi%
@cd %abi%
@copy %mesa%mesa\build\windows-%longabi%\gallium\targets\libgl-gdi\opengl32.dll opengl32.dll
@if %abi%==x64 copy %mesa%mesa\build\windows-%longabi%\gallium\drivers\swr\swrAVX.dll swrAVX.dll
@if %abi%==x64 copy %mesa%mesa\build\windows-%longabi%\gallium\drivers\swr\swrAVX2.dll swrAVX2.dll
@copy %mesa%mesa\build\windows-%longabi%\mesa\drivers\osmesa\osmesa.dll osmesa-swrast.dll
@copy %mesa%mesa\build\windows-%longabi%\gallium\targets\osmesa\osmesa.dll osmesa-gallium.dll
@copy %mesa%mesa\build\windows-%longabi%\gallium\targets\graw-gdi\graw.dll graw.dll
@copy %mesa%dxtn\%abi%\dxtn.dll dxtn.dll
@echo.
@pause

:exit
exit
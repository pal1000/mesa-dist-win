@set mesa=%cd%\
@set abi=x86
@set /p x64=Do you want to build for x64?(y/n) Otherwise build for x86: 
@if /I %x64%==y @set abi=x64
@set longabi=%abi%
@if %abi%==x64 @set longabi=x86_64
@set altabi=i686
@if %abi%==x64 @set altabi=%longabi%
@set minabi=32
@if %abi%==x64 set minabi=64
@set vsenv=%ProgramFiles%
@if NOT "%ProgramW6432%"=="" set vsenv=%vsenv% (x86)
@set vsenv15=%vsenv%\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvars%minabi%.bat
@set vsenv14=%VS140COMNTOOLS%..\..\VC\bin\vcvars%minabi%.bat
@set gcc=%mesa%mingw-w64-%abi%\mingw%minabi%\bin
@set vsenvloaded=0
@set dxtnbuilt=0

:build_llvm
@set /p buildllvm=Begin LLVM build. Only needs to run once for each ABI and version. Proceed (y/n):
@if /I NOT %buildllvm%==y GOTO build_dxtn
@echo.
@cd "%mesa%llvm"
@RD /S /Q %abi%
@echo.
@RD /S /Q cmake-%abi%
@echo.
@md cmake-%abi%
@cd cmake-%abi%
@if EXIST "%vsenv15%" (
@set vsenvloaded=%vsenvloaded%15
@set toolchain=Visual Studio 15 2017
@call "%vsenv15%"
)
@if NOT EXIST "%vsenv15%" (
@set vsenvloaded=%vsenvloaded%14
@set toolchain=Visual Studio 14
@call "%vsenv14%"
)
@if %abi%==x64 @set toolchain=%toolchain% Win64
@set PATH=%mesa%cmake\%abi%\bin\;%PATH%
@echo.
@cmake -G "%toolchain%" -DLLVM_TARGETS_TO_BUILD=X86 -DLLVM_ENABLE_RTTI=1 -DLLVM_USE_CRT_RELEASE=MT -DLLVM_ENABLE_TERMINFO=OFF -DCMAKE_INSTALL_PREFIX=%mesa:\=/%llvm/%abi% ..
@echo.
@pause
@echo.
@msbuild /p:Configuration=Release INSTALL.vcxproj
@echo.
@pause
@echo.

:build_dxtn
@if NOT EXIST "%gcc%" GOTO build_mesa
@if NOT EXIST "%mesa%dxtn" GOTO build_mesa
@set /p builddxtn=Do you want to build S3 texture compression library? (y/n):
@if /i NOT %builddxtn%==y GOTO build_mesa
@set PATH=%gcc%\;%PATH%
@cd "%mesa%dxtn"
@echo.
@RD /S /Q %abi%
@echo.
@MD %abi%
@set dxtn=gcc -shared
@if %abi%==x86 set dxtn=%dxtn% -m32
@set dxtn=%dxtn% -v *.c *.h -I ..\mesa\include -Wl,--dll,--dynamicbase,--enable-auto-image-base,--nxcompat -o %abi%\dxtn.dll
@%dxtn%
@echo.
@set dxtnbuilt=1

:build_mesa
@set /p buildmesa=Begin mesa build. Proceed (y/n):
@if /i NOT %buildmesa%==y GOTO exit
@set LLVM=%mesa:\=/%llvm/%abi%
@cd "%mesa%mesa"
@set /p openswr=Do you want to build OpenSWR drivers? (y=yes):
@set buildswr=0
@if /i %openswr%==y @set buildswr=1
@set mesatoolchain=default
@echo.
@GOTO build_with_vs

:build_with_mingw
@set mingw=n
@set mingwtest=0
@if EXIST "%gcc%" @set mingwtest=1
@set msys2=%mesa%msys64\msys2_shell.cmd
@if EXIST "%msys2%" @set mingwtest=%mingwtest%2
@if %mingwtest%==12 @set /p mingw=Do you want to build with MinGW-W64 instead of Visual Studio (y=yes):
@if %dxtnbuilt%==0 @set PATH=%gcc%\;%PATH%
@set mesatoolchain=crossmingw
@copy "%gcc%\%altabi%-w64-mingw32-gcc-ar.exe" "%gcc%\%altabi%-w64-mingw32-ar.exe"
@copy "%gcc%\%altabi%-w64-mingw32-gcc-ranlib.exe" "%gcc%\%altabi%-w64-mingw32-ranlib.exe"
@call "%msys2%" -use-full-path
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


:build_with_vs
@RD /S /Q build\windows-%longabi%
@echo.
@set PATH=%mesa%Python\%abi%\;%mesa%Python\%abi%\Scripts\;%mesa%flexbison\;%mesa%m4\%abi%\usr\bin\;%PATH%
@pip install -U mako
@pip freeze > requirements.txt
@pip install -r requirements.txt --upgrade
@del requirements.txt
@set restartcond=0
@set vs2017toolset=n
@echo.
@if EXIST "%vsenv15%" set /p vs2017toolset=Do you want to build with Visual Studio 2017 toolset (y/n) - WARNING, this is a hack, it will break if Mesa MSVC build gets support for LLVM 4.0 before Scons gets support for MSVC 2017:
@if /i %vs2017toolset%==y @set vsenvloaded=%vsenvloaded%15
@if /i NOT %vs2017toolset%==y @set vsenvloaded=%vsenvloaded%14
@if %vsenvloaded%==01514 set restartcond=1
@echo.
@if %vsenvloaded%==015 call "%vsenv15%"
@if %vsenvloaded%==014 call "%vsenv14%"
@if %restartcond%==1 (
@echo.
@echo A Visual Studio build environment is already loaded. The script will now restart to flush loaded environment.
@pause
@GOTO exit
)
@echo.

:build_mesa_exec
@python "%mesa%Python\%abi%\Scripts\scons.py" build=release platform=windows machine=%longabi% toolchain=%mesatoolchain% swr=%buildswr% libgl-gdi
@echo.
@pause

:exit
exit
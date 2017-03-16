@set mesa=%cd%/
@set mesa=%mesa:\=/%
@set abi=x86
@set /p x64=Do you want to build for x64?(y/n) Otherwise build for x86: 
@if /I %x64%==y @set abi=x64
@set longabi=%abi%
@if %abi%==x64 @set longabi=x86_64
@set toolchain=Visual Studio 15 2017
@if %abi%==x64 @set toolchain=%toolchain% Win64
@set altabi=i686
@if %abi%==x64 @set altabi=%longabi%
@set minabi=32
@if %abi%==x64 set minabi=64
@set vsenv=%ProgramFiles:\=/%
@if NOT "%ProgramW6432%"=="" set vsenv=%vsenv% (x86)
@set vsenv=%vsenv%/Microsoft Visual Studio/2017/Community/VC/Auxiliary/Build/vcvars%minabi%.bat
@set gcc=%mesa%mingw-w64-%abi%
@set PATH=%mesa%flexbison/;%mesa%m4/%abi%/bin/;%mesa%Python/%abi%/;%mesa%Python/%abi%/Scripts/;%mesa%cmake/%abi%/bin/;%PATH%
@if EXIST "%gcc%" set PATH=%gcc%/mingw%minabi%/bin/;%PATH%
@if EXIST "%gcc%" set gcc=%gcc%/mingw%minabi%/bin

@pip install -U mako
@pip freeze > requirements.txt
@pip install -r requirements.txt --upgrade
@del requirements.txt

@set /p buildllvm=Begin LLVM build. Only needs to run once for each ABI and version. Proceed y/n? 
@if /I NOT %buildllvm%==y GOTO build_dxtn

:build_llvm
@cd %mesa%llvm
@RD /S /Q %abi%
@RD /S /Q cmake-%abi%
@md cmake-%abi%
@cd cmake-%abi%
@set vsenvloaded=1
@call "%vsenv%"
@cmake -G "%toolchain%" -DLLVM_TARGETS_TO_BUILD=X86 -DLLVM_ENABLE_RTTI=1 -DLLVM_USE_CRT_RELEASE=MT -DLLVM_ENABLE_TERMINFO=OFF -DCMAKE_INSTALL_PREFIX=%mesa%llvm/%abi% ..
@pause
@msbuild /p:Configuration=Release INSTALL.vcxproj
@pause

:build_dxtn
@if NOT EXIST "%gcc%" GOTO build_mesa
@if NOT EXIST "%mesa%dxtn" GOTO build_mesa
@set /p builddxtn=Do you want to build S3 texture compression library? (y/n):
@if /i NOT %builddxtn%==y GOTO build_mesa
@cd %mesa%dxtn
@RD /S /Q %abi%
@MD %abi%
@set dxtn=gcc -shared
@if %abi%==x86 set dxtn=%dxtn% -m32
@set dxtn=%dxtn% -v *.c *.h -I ../mesa/include -Wl,--dll,--dynamicbase,--enable-auto-image-base,--nxcompat -o %abi%/dxtn.dll
@echo.
@%dxtn%
@echo.

:build_mesa
@set /p buildmesa=Begin mesa build. Proceed (y/n):
@if /i NOT %buildmesa%==y GOTO exit
@set LLVM=%mesa%llvm/%abi%
@cd %mesa%mesa
@set mingw=n
@rem if EXIST "%gcc%" set /p mingw=Do you want to build with MinGW-W64 instead of Visual Studio? (y=yes):
@set buildmingw=
@if /i %mingw%==y (
@set buildmingw=toolchain=crossmingw
@mklink /H "%gcc%/%altabi%-w64-mingw32-ar.exe" "%gcc%/ar.exe"
@mklink /H "%gcc%/%altabi%-w64-mingw32-ranlib.exe" "%gcc%/ranlib.exe"
)
@if /i NOT %mingw%==y (
@if NOT %vsenvloaded==1 (
@call "%vsenv%"
)
)
@set /p openswr=Do you want to build OpenSWR drivers? (y=yes):
@set buildswr=
@if /i %openswr%==y @set buildswr=swr=1
@cmd /k "scons build=release platform=windows machine=%longabi% %buildmingw% %buildswr% libgl-gdi"
:exit
exit
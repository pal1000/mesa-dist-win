@for /F "delims=" %%I in ("%~dp0") do @set cdir=%%~fI
@rem Specify Visual Studio version in vsver
@set vsver=14
@set vsvar=vs%vsver%0COMNTOOLS
@setlocal enabledelayedexpansion
@set vsct=!%vsvar%!
@setlocal disabledelayedexpansion
@set vstudio=%vsct%\..\..\VC\bin
@set mesa=%cdir%projects\mesa\
@set mesaunix=%mesa:\=/%
@set abi=x86
@set /p x64=Do you want to build for x64?(y/n) Otherwise build for x86: 
@if /I %x64%==y @set abi=x64
@set longabi=%abi%
@if %abi%==x64 @set longabi=x86_64
@set toolchain=Visual Studio %vsver%
@if %abi%==x64 @set toolchain=%toolchain% Win64
@set caller="%vstudio%
@if %abi%==x86 set caller=%caller%\vcvars32.bat"
@if %abi%==x64 set caller=%caller%\amd64\vcvars64.bat"
@call %caller%
@set PATH=%mesa%flexbison\;%mesa%m4\%abi%\bin\;%mesa%Python\%abi%\;%mesa%Python\%abi%\Scripts\;%mesa%cmake\%abi%\bin\;%PATH%

@pip install -U mako
@pip freeze > requirements.txt
@pip install -r requirements.txt --upgrade
@del requirements.txt

@set /p buildllvm=Begin LLVM build. Only needs to run once for each ABI and version. Proceed y/n? 
@if /I %buildllvm%==y GOTO build_llvm
@if /I NOT %buildllvm%==y GOTO Next

:build_llvm
@cd %mesa%llvm
@RD /S /Q %abi%
@RD /S /Q cmake-%abi%
@md cmake-%abi%
@cd cmake-%abi% 
@cmake -G "%toolchain%" -DLLVM_TARGETS_TO_BUILD=X86 -DLLVM_ENABLE_RTTI=1 -DLLVM_USE_CRT_RELEASE=MT -DLLVM_ENABLE_TERMINFO=OFF -DCMAKE_INSTALL_PREFIX=%mesaunix%llvm/%abi% ..
@pause
@msbuild /p:Configuration=Release INSTALL.vcxproj
@pause

:Next
@set /p buildmesa=Begin mesa build. Proceed y/n? 
@if /i %buildmesa%==y GOTO build_mesa
@if /i NOT %buildmesa%==y @exit

:build_mesa
@set LLVM=%mesaunix%llvm/%abi%
@cd %mesa%mesa
@cmd /k "scons build=release platform=windows machine=%longabi% swr=1 libgl-gdi"

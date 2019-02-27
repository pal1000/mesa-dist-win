@set abi=x86
@set longabi=%abi%
@set mingwabi=i686
@set minabi=32
@IF %abi%==x64 set longabi=x86_64
@IF %abi%==x64 set mingwabi=%longabi%
@IF %abi%==x64 set minabi=%abi:~1%

@cd ../..
@set msys=64
@IF NOT EXIST msys64 set msys=32
@IF %msys%==32 IF NOT EXIST msys32 exit
@SET PATH=%CD%\msys%msys%\usr\bin\;%PATH%
@set mesa=%CD:\=/%
@set mesa=/%mesa:~0,1%%mesa:~2%
@cd mesa
@IF EXIST build RD /S /Q build
@pacman -S python2-mako scons mingw-w64-%mingwabi%-clang flex bison patch --needed --noconfirm
@echo.
@set MSYSTEM=MINGW%minabi%
@set buildcmd=scons -j3 build=release platform=windows toolchain=mingw machine=%abi%
@set LLVM=/mingw%minabi%
@set CFLAGS=-march=core2 -pipe -D_USE_MATH_DEFINES
@set CXXFLAGS=-march=core2 -pipe -std=c++11 -D_USE_MATH_DEFINES
@set LDFLAGS=-static -s
@IF NOT EXIST mesapatched.ini patch -Nbp1 -i "%mesa%/mesa-dist-win/patches/s3tc.patch"
@IF NOT EXIST mesapatched.ini echo.
@IF NOT EXIST mesapatched.ini patch -Nbp1 -i "%mesa%/mesa-dist-win/patches/link-ole32.patch"
@IF NOT EXIST mesapatched.ini echo.
@echo 1 > mesapatched.ini
@echo cd $mesa/mesa > ..\mesa-dist-win\debug\build.sh
@echo $buildcmd >> ..\mesa-dist-win\debug\build.sh
@bash --login %mesa%/mesa-dist-win/debug/build.sh
@del ..\mesa-dist-win\debug\build.sh
@cmd


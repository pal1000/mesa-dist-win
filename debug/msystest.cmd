@set abi=x64
@set longabi=%abi%
@set mingwabi=i686
@set minabi=32
@IF %abi%==x64 set longabi=x86_64
@IF %abi%==x64 set mingwabi=%longabi%
@IF %abi%==x64 set minabi=%abi:~1%

@cd "%~dp0"
@cd ..\..\
@set msys=64
@IF NOT EXIST msys64 set msys=32
@IF %msys%==32 IF NOT EXIST msys32 exit
@SET msysloc=%CD%\msys%msys%
@for %%a IN ("%CD%") do @set mesa=%%~sa
@cd mesa
@rem IF EXIST build\windows-%longabi% RD /S /Q build\windows-%longabi%
@set runmsys=call %mesa%\mesa-dist-win\buildscript\modules\runmsys.cmd
@set MSYSTEM=MSYS
@%runmsys% pacman -Syu --noconfirm
@IF NOT EXIST %msysloc%\mingw%minabi%\bin\llvm-ar.exe %runmsys% pacman -Syu --noconfirm
@%runmsys% pacman -S python2-mako scons mingw-w64-%mingwabi%-gcc mingw-w64-%mingwabi%-zlib mingw-w64-%mingwabi%-llvm flex bison patch --needed --noconfirm
@set buildcmd=cd $mesa/mesa;scons -j3 build=release platform=windows machine=%longabi% toolchain=mingw
@rem IF %abi%==x64 set buildcmd=%buildcmd% swr=1
@set LLVM=/mingw%minabi%
@set CFLAGS=-march=core2
@set CXXFLAGS=-march=core2
@rem set CFLAGS=-march=core2 -pipe -D_USE_MATH_DEFINES
@rem set CXXFLAGS=-march=core2 -pipe -std=c++11 -D_USE_MATH_DEFINES
@set LDFLAGS=-static -s
@rem %runmsys% cd $mesa/mesa;patch -Np1 -i "%mesa%\mesa-dist-win\patches\s3tc.patch"
@rem %runmsys% cd $mesa/mesa;patch -Np1 -i "%mesa%\mesa-dist-win\patches\link-ole32.patch"
@set MSYSTEM=MINGW%minabi%
@%runmsys% %buildcmd%
@cmd
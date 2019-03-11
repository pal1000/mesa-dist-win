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
@IF EXIST build RD /S /Q build
@set runmsys=call %mesa%\mesa-dist-win\buildscript\modules\runmsys.cmd
@set MSYSTEM=MSYS
@%runmsys% pacman -Syu --noconfirm
@echo.
@%runmsys% pacman -S python2-mako scons mingw-w64-%mingwabi%-clang flex bison patch --needed --noconfirm
@echo.
@set buildcmd=scons -C $mesa/mesa -j3 build=release platform=windows toolchain=mingw machine=%longabi%
@rem IF %abi%==x64 set buildcmd=%buildcmd% swr=1
@set LLVM=/mingw%minabi%
@set CFLAGS=-march=core2 -pipe -D_USE_MATH_DEFINES
@set CXXFLAGS=-march=core2 -pipe -std=c++11 -D_USE_MATH_DEFINES
@set LDFLAGS=-static -s
@rem %runmsys% cd $mesa/mesa;patch -Np1 -i "%mesa%\mesa-dist-win\patches\s3tc.patch"
@rem echo.
@rem %runmsys% cd $mesa/mesa;patch -Np1 -i "%mesa%\mesa-dist-win\patches\link-ole32.patch"
@rem echo.
@echo %buildcmd%
@echo.
@set MSYSTEM=MINGW%minabi%
@%runmsys% %buildcmd%
@cmd
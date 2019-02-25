@rem ABI format conversions for Mingw
@set mingwabi=%longabi%
@set minabi=%abi:~1%
@IF %abi%==x86 set minabi=32
@IF %abi%==x86 set mingwabi=i686

@rem Load MSYS2 environment
@set msysstate=1
@set msysloc=%mesa%\msys64
@IF NOT EXIST %msysloc% set msysloc=%mesa%\msys32
@IF NOT EXIST %msysloc% set msysstate=0
@IF NOT %msysstate%==0 set PATH=%msysloc%\usr\bin\;%msysloc%\mingw%minabi%\bin\;%PATH%

@rem Check for updates
@IF NOT %msysstate%==0 set /p msysupdate=Update MSYS2 packages (y/n):
@IF NOT %msysstate%==0 echo.
@IF /I "%msysupdate%"=="y" pacman -Syu
@IF /I "%msysupdate%"=="y" echo.

@rem Get dependencies
@IF %toolchain%==gcc IF NOT %msysstate%==0 pacman -S python2-mako scons mingw-w64-%mingwabi%-clang --needed --noconfirm
@IF %toolchain%==gcc IF NOT %msysstate%==0 echo.

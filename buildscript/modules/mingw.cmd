@rem Harcode some stuff to ease integration later
@set longabi=x86
@set abi=x86
@set mesa=C:\Software\Development\projects\mesa

@rem ABI format conversions for Mingw
@set mingwabi=%longabi%
@set minabi=%abi:~1%
@IF %abi%==x86 set minabi=32
@IF %abi%==x86 set mingwabi=i686

@rem Look in PATH for pacman
@set msysstate=2
@SET ERRORLEVEL=0
@where /q pacman.exe
@IF ERRORLEVEL 1 GOTO nopathmsys
@FOR /F "tokens=* USEBACKQ" %%a IN (`where pacman.exe`) DO @SET msysloc=%%~sa
@set msysloc=%msysloc:~0,-19%
@GOTO loadedmsys

:nopathmsys
@set msysstate=1
@set msysloc=%mesa%\msys64
@IF NOT EXIST %msysloc% set msysloc=%mesa%\msys32
@IF NOT EXIST %msysloc% set msysstate=0

:loadedmsys
@IF %msysstate%==1 set PATH=%msysloc%\usr\bin\;%msysloc%\migw%minabi%\bin\;%PATH%
@cmd



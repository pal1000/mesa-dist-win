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
@set runmsys=call %mesa%\mesa-dist-win\buildscript\modules\runmsys.cmd
@set MSYSTEM=MSYS

@setlocal
@rem ABI format conversions for Mingw
@set mingwabi=%longabi%
@IF %abi%==x86 set mingwabi=i686

@rem Load MSYS2 environment
@set msysstate=1
@set msysloc=%mesa%\msys64
@IF NOT EXIST %msysloc% set msysloc=%mesa%\msys32
@IF NOT EXIST %msysloc% set msysstate=0
@endlocal&set mingwabi=%mingwabi%&set msysstate=%msysstate%&set msysloc=%msysloc%

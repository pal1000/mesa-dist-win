@setlocal
@rem ABI format conversions for Mingw
@set MSYSTEM=MINGW64
@IF %abi%==x86 set MSYSTEM=MINGW32

@rem Load MSYS2 environment
@set msysstate=1
@set msysloc=%devroot%\msys64
@IF NOT EXIST %msysloc% set msysloc=%devroot%\msys32
@IF NOT EXIST %msysloc% set msysstate=0
@endlocal&set MSYSTEM=%MSYSTEM%&set msysstate=%msysstate%&set msysloc=%msysloc%

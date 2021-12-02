@setlocal
@rem Load MSYS2 environment
@set msysstate=1
@set msysloc=%devroot%\msys64
@IF NOT EXIST %msysloc% set msysloc=%devroot%\msys32
@IF NOT EXIST %msysloc% set msysstate=0
@endlocal&set msysstate=%msysstate%&set msysloc=%msysloc%

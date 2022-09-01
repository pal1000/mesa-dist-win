@setlocal
@set regglkey="HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\OpenGLDrivers\MSOGL"
@set regglwowkey="HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion\OpenGLDrivers\MSOGL"
@IF EXIST "%windir%\System32\%1.dll" REG ADD %regglkey% /v DLL /t REG_SZ /d %1.dll /f
@IF EXIST "%windir%\System32\%1.dll" REG ADD %regglkey% /v DriverVersion /t REG_DWORD /d 1 /f
@IF EXIST "%windir%\System32\%1.dll" REG ADD %regglkey% /v Flags /t REG_DWORD /d 1 /f
@IF EXIST "%windir%\System32\%1.dll" REG ADD %regglkey% /v Version /t REG_DWORD /d 2 /f
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%windir%\SysWOW64\%1.dll" REG ADD %regglwowkey% /v DLL /t REG_SZ /d %1.dll /f
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%windir%\SysWOW64\%1.dll" REG ADD %regglwowkey% /v DriverVersion /t REG_DWORD /d 1 /f
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%windir%\SysWOW64\%1.dll" REG ADD %regglwowkey% /v Flags /t REG_DWORD /d 1 /f
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%windir%\SysWOW64\%1.dll" REG ADD %regglwowkey% /v Version /t REG_DWORD /d 2 /f
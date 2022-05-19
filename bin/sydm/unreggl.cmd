@set "ERRORLEVEL="
@CMD /C EXIT 0
@REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\OpenGLDrivers\MSOGL" /d /f %1.dll >nul 2>&1
@if "%ERRORLEVEL%"=="0" REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\OpenGLDrivers\MSOGL" /f
@CMD /C EXIT 0
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion\OpenGLDrivers\MSOGL" /d /f %1.dll >nul 2>&1
@if "%ERRORLEVEL%"=="0" IF /I %PROCESSOR_ARCHITECTURE%==AMD64 REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion\OpenGLDrivers\MSOGL" /f
@CMD /C EXIT 0
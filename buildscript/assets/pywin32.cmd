@set pylocinfo=%~dp0
@IF "%pylocinfo:~-1%"=="\" set pylocinfo=%pylocinfo:~0,-1%
@set /p pythonloc=<"%pylocinfo%\pythonloc.txt"
@%pythonloc% %pythonloc:~0,-10%Scripts\pywin32_postinstall.py -install
@del "%pylocinfo%\pythonloc.txt"
@pause
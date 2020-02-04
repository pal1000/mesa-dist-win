@setlocal
@rem Install missing python packages.
@rem State tracking is irrelevant for Python packages as they can easily be added via Pypi if missing.
@rem Meson is the exception because its a Python 3 only package and as a result it can be missing.

@set pypack=0
@set firstpyinstall=1
@set pywin32com=n

:pypackmissing
@rem Check for Python packages availability.
@IF NOT EXIST %pythonloc:~0,-10%Lib\site-packages\markupsafe (
@set pypack=MarkupSafe
@GOTO pypackinstall
)
@IF NOT EXIST %pythonloc:~0,-10%Lib\site-packages\mako (
@set pypack=Mako
@GOTO pypackinstall
)
@IF %mesabldsys%==scons if %pythonver:~0,1%==2 if NOT EXIST %pythonloc:~0,-10%Scripts\pywin32_postinstall.py (
@set pypack=pywin32
@GOTO pypackinstall
)
@set sconspypi=0
@IF %mesabldsys%==scons for /F "skip=2 delims= " %%a in ('%pythonloc% -W ignore -m pip list --disable-pip-version-check') do @IF /I "%%a"=="scons" set sconspypi=1
@IF %mesabldsys%==scons IF NOT "%sconspypi%"=="1" IF NOT EXIST %devroot%\scons (
@set pypack=scons
@GOTO pypackinstall
)
@if %mesabldsys%==scons set mesonstate=0
@if %mesabldsys%==scons GOTO pyupdate

@set mesonstate=2
@SET ERRORLEVEL=0
@where /q meson.exe
@IF ERRORLEVEL 1 set mesonstate=1
@IF NOT EXIST %pythonloc:~0,-10%Scripts\meson.py IF NOT EXIST %pythonloc:~0,-10%Scripts\meson.exe (
@set pypack=meson
@GOTO pypackinstall
)
@GOTO pyupdate

:pypackinstall
@rem Found a missing package. Install it.
@IF %firstpyinstall%==1 IF NOT %pypack%==0 if EXIST "%LOCALAPPDATA%\pip" RD /S /Q "%LOCALAPPDATA%\pip"
@IF %firstpyinstall%==1 IF NOT %pypack%==0 (
@%pythonloc% -W ignore -m pip install -U pip
@echo.
@%pythonloc% -W ignore -m pip install -U setuptools
@echo.
@set firstpyinstall=0
)
@IF NOT %pypack%==0 %pythonloc% -W ignore -m pip install -U %pypack%
@IF NOT %pypack%==0 echo.
@IF %pypack%==pywin32 set /p pywin32com=Do you want to install COM and services support - y/n. You'll be asked for admin privileges:
@IF %pypack%==pywin32 echo.
@IF %pypack%==pywin32 IF /I "%pywin32com%"=="y" powershell -Command Start-Process "%devroot%\mesa-dist-win\buildscript\modules\pywin32.cmd" -Args "%pythonloc%" -Verb runAs 2>nul
@set pypack=0
@GOTO pypackmissing

:pyupdate
@rem Check for python packages updates.
@set pyupd=n
@set /p pyupd=Update python packages (y/n):
@echo.
@set pywinsetup=2
@set ERRORLEVEL=0
@REG QUERY HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\pywin32-py2.7 >nul 2>&1
@IF ERRORLEVEL 1 set pywinsetup=1
@IF NOT EXIST "%windir%\system32\pythoncom27.dll" IF NOT EXIST "%windir%\syswow64\pythoncom27.dll" set pywinsetup=0
@if /I NOT "%pyupd%"=="y" GOTO endpython
@if EXIST "%LOCALAPPDATA%\pip" RD /S /Q "%LOCALAPPDATA%\pip"
@for /F "skip=2 delims= " %%a in ('%pythonloc% -W ignore -m pip list -o --disable-pip-version-check') do @(
IF NOT "%%a"=="pywin32" %pythonloc% -W ignore -m pip install -U "%%a"&echo.
IF "%%a"=="pywin32" IF %pywinsetup% LSS 2 %pythonloc% -W ignore -m pip install -U "%%a"&echo.
IF "%%a"=="pywin32" IF %pywinsetup% EQU 1 powershell -Command Start-Process "%devroot%\mesa-dist-win\buildscript\modules\pywin32.cmd" -Args "%pythonloc%" -Verb runAs 2>nul
IF "%%a"=="pywin32" IF %pywinsetup% EQU 2 echo New version of pywin32 is available.&echo Visit https://github.com/mhammond/pywin32/releases to download it.&echo.
)

:endpython
@echo.
@endlocal&set sconspypi=%sconspypi%&set mesonstate=%mesonstate%
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

@set mesonstate=2
@CMD /C EXIT 0
@where /q meson.exe
@if NOT "%ERRORLEVEL%"=="0" set mesonstate=1
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
@IF %pypack%==pywin32 IF /I "%pywin32com%"=="y" powershell -Command Start-Process "%devroot%\%projectname%\buildscript\modules\pywin32.cmd" -Args "%pythonloc%" -Verb runAs 2>nul
@set pypack=0
@GOTO pypackmissing

:pyupdate
@rem Check for python packages updates.
@set pyupd=n
@set /p pyupd=Update python packages (y/n):
@echo.
@if /I NOT "%pyupd%"=="y" GOTO endpython
@set pywinsetup=2
@for /f "tokens=1,2 delims=." %%a IN ("%pythonver%") DO @set spyver=%%a%%b
@IF NOT EXIST %pythonloc:~0,-10%Removepywin32.exe set pywinsetup=1
@IF NOT EXIST "%windir%\system32\pythoncom%spyver%.dll" IF NOT EXIST "%windir%\syswow64\pythoncom%spyver%.dll" set pywinsetup=0
@if EXIST "%LOCALAPPDATA%\pip" RD /S /Q "%LOCALAPPDATA%\pip"
@for /F "skip=2 delims= " %%a in ('%pythonloc% -W ignore -m pip list -o --disable-pip-version-check') do @(
IF NOT "%%a"=="pywin32" (
%pythonloc% -W ignore -m pip install -U "%%a"
echo.
)
IF "%%a"=="pywin32" IF %pywinsetup% LSS 2 (
%pythonloc% -W ignore -m pip install -U "%%a"
echo.
)
IF "%%a"=="pywin32" IF %pywinsetup% EQU 1 powershell -Command Start-Process "%devroot%\%projectname%\buildscript\modules\pywin32.cmd" -Args "%pythonloc%" -Verb runAs 2>nul
IF "%%a"=="pywin32" IF %pywinsetup% EQU 2 (
echo New version of pywin32 is available.
echo Visit https://github.com/mhammond/pywin32/releases to download it.
echo.
)
)

:endpython
@echo.
@endlocal&set mesonstate=%mesonstate%
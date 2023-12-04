@setlocal ENABLEDELAYEDEXPANSION
@rem First remove Python UWP loader from PATH (see https://github.com/pal1000/mesa-dist-win/issues/23)
@SET PATH=!PATH:;%LOCALAPPDATA%\Microsoft\WindowsApps=!

@REM Try locating all Python versions via Python Launcher.
@SET pythonloc=python.exe

@rem Check if Python launcher is installed.
@CMD /C EXIT 0
@where /q py.exe
@if NOT "%ERRORLEVEL%"=="0" GOTO nopylauncher

@rem Count and list supported python installations
@set pythontotal=0
@FOR /F delims^=^ eol^= %%a IN ('py -0 2^>nul') do @IF NOT "%%a"=="" FOR /F tokens^=1^ eol^= %%b IN ("%%a") do @FOR /F "tokens=1-2 delims=. " %%c IN ('py %%b -c "import sys; print(sys.version)"') DO @(
@set goodpython=1
@if %%c LSS 3 set goodpython=0
@if %%c EQU 3 if %%d LSS 7 set goodpython=0
@IF !goodpython!==1 set /a pythontotal+=1
@IF !pythontotal!==1 echo Select Python installation
@IF !goodpython!==1 echo !pythontotal!. %%a
@IF !goodpython!==1 set pyl[!pythontotal!]=%%b
)
@IF %pythontotal%==0 echo WARNING: No suitable Python installation found by Python launcher.
@IF %pythontotal%==0 echo Python 3.7 and newer is required.
@IF %pythontotal%==0 echo.
@IF %pythontotal%==0 GOTO nopylauncher
@IF %pythontotal% GTR 0 echo.

:pyselect
@set /p pyselect=Select Python version by entering its index from the table above:
@echo.
@IF "%pyselect%"=="" echo Invalid entry.
@IF "%pyselect%"=="" pause
@IF "%pyselect%"=="" echo.
@IF "%pyselect%"=="" GOTO pyselect
@IF %pyselect% LEQ 0 echo Invalid entry.
@IF %pyselect% LEQ 0 pause
@IF %pyselect% LEQ 0 echo.
@IF %pyselect% LEQ 0 GOTO pyselect
@IF %pyselect% GTR %pythontotal% echo Invalid entry.
@IF %pyselect% GTR %pythontotal% pause
@IF %pyselect% GTR %pythontotal% echo.
@IF %pyselect% GTR %pythontotal% GOTO pyselect

@rem Locate selected Python installation
@FOR /F delims^=^ eol^= %%a IN ('py !pyl[%pyselect%]! -c "import sys; print(sys.executable)"') DO @set pythonloc="%%~a"
@FOR /F tokens^=1^ eol^= %%a IN ('py !pyl[%pyselect%]! -c "import sys; print(sys.version)"') DO @SET fpythonver=%%a
@GOTO loadpypath

:nopylauncher
@rem Missing Python launcher fallback code path.
@rem Check if Python is in PATH or if it is provided as a local depedency.
@CMD /C EXIT 0
@IF %pythonloc%==python.exe where /q python.exe
@if NOT "%ERRORLEVEL%"=="0" set pythonloc="%devroot%\python\python.exe"
@IF %pythonloc%=="%devroot%\python\python.exe" IF NOT EXIST %pythonloc% (
@echo Python is unreachable. Cannot continue.
@echo.
@pause
@exit
)
@IF %pythonloc%==python.exe set exitloop=1
@IF %pythonloc%==python.exe FOR /F delims^=^ eol^= %%a IN ('where python.exe 2^>nul') DO @IF defined exitloop (
set "exitloop="
SET pythonloc="%%~a"
)
@if EXIST "%pythonloc:~1,-11%pyvenv.cfg" (
@echo Python virtual environments are ignored by this discovery tool. Cannot continue.
@echo.
@pause
@exit
)

@rem Identify Python version.
@cd "%devroot%\"
@FOR /F tokens^=1^ eol^= %%a IN ('%pythonloc% %projectname%\buildscript\modules\pyver.py') DO @SET fpythonver=%%a
@rem Check if Python version is not too old.
@set goodpython=1
@FOR /F tokens^=1-2^ delims^=.^ eol^= %%a IN ("%fpythonver%") DO @(
@if %%a LSS 3 set goodpython=0
@if %%a EQU 3 if %%b LSS 7 set goodpython=0
)
@IF %goodpython% EQU 0 (
@echo Your Python version is too old. Only Python 3.7 and newer is supported.
@echo.
@pause
@exit
)

:loadpypath
@REM Load Python in PATH to convince CMake to use the selected version and avoid other potential problems.
@CMD /C EXIT 0
@set pypath=1
@where /q python.exe
@if NOT "%ERRORLEVEL%"=="0" set pypath=0
@IF %pypath%==1 set exitloop=1
@IF %pypath%==1 FOR /F delims^=^ eol^= %%a IN ('where python.exe 2^>nul') DO @IF defined exitloop (
set "exitloop="
SET pypath="%%~a"
)
@IF NOT %pypath%==%pythonloc% set PATH=%pythonloc:~1,-11%;%PATH%

@echo Using Python %fpythonver% from %pythonloc%.
@echo.
@endlocal&SET PATH=%PATH%&set pythonver=%fpythonver%&set pythonloc=%pythonloc%
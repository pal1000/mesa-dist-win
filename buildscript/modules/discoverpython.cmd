@setlocal ENABLEDELAYEDEXPANSION
@rem First remove Python UWP loader from PATH (see https://github.com/pal1000/mesa-dist-win/issues/23)
@SET PATH=!PATH:;%LOCALAPPDATA%\Microsoft\WindowsApps=!

@REM Try locating all Python versions via Python Launcher.
@SET pythonloc=python.exe

@rem Check if Python launcher is installed.
@set ERRORLEVEL=0
@where /q py.exe
@IF ERRORLEVEL 1 GOTO nopylauncher

:pylist
@set pythontotal=0
@cls

@rem Count supported python installations
@FOR /F "USEBACKQ tokens=1 skip=1" %%a IN (`py -0 2^>nul`) do @(
@set pythoninstance=%%a
@set goodpython=0
@IF !pythoninstance^:^~1^,-3! EQU 2.7 set goodpython=1
@IF !pythoninstance^:^~1^,-3! GEQ 3.5 IF NOT EXIST %devroot%\mesa set goodpython=1
@IF !pythoninstance^:^~1^,-3! GEQ 3.5 IF EXIST %devroot%\mesa\subprojects\.gitignore set goodpython=1
@IF !pythoninstance^:^~1^,-3! GEQ 3.5 IF EXIST %devroot%\mesa IF NOT EXIST %devroot%\mesa\subprojects\.gitignore echo Hiding Python !pythoninstance^:^~1! due to Mesa3D source code not having Meson Windows support.
@IF !pythoninstance^:^~1^,-3! GEQ 3.5 IF EXIST %devroot%\mesa IF NOT EXIST %devroot%\mesa\subprojects\.gitignore echo Note that Mesa3D 19.3 is required for Meson Windows support.
@IF !pythoninstance^:^~1^,-3! GEQ 3.5 IF EXIST %devroot%\mesa IF NOT EXIST %devroot%\mesa\subprojects\.gitignore echo.
@IF !goodpython!==1 set /a pythontotal+=1
)
@IF %pythontotal%==0 echo WARNING: No suitable Python installation found by Python launcher.
@IF %pythontotal%==0 echo Note that for Scons build Python 2.7 or for Meson build Python 3.5 and newer is required.
@IF %pythontotal%==0 echo Also Meson build only works with Mesa3D 19.3. This is verified and if check fails Python 3.x detection is suppressed.
@IF %pythontotal%==0 echo.
@IF %pythontotal%==0 GOTO nopylauncher

@echo Select Python installation
@set pythoncount=0
@FOR /F "USEBACKQ tokens=1 skip=1" %%a IN (`py -0 2^>nul`) do @(
@set pythoninstance=%%a
@set goodpython=0
@IF !pythoninstance^:^~1^,-3! EQU 2.7 set goodpython=1
@IF !pythoninstance^:^~1^,-3! GEQ 3.5 IF NOT EXIST %devroot%\mesa set goodpython=1
@IF !pythoninstance^:^~1^,-3! GEQ 3.5 IF EXIST %devroot%\mesa\subprojects\.gitignore set goodpython=1
@IF !goodpython!==1 set /a pythoncount+=1
@IF !goodpython!==1 echo !pythoncount!. Python !pythoninstance:~1,-3! !pythoninstance:~-2! bit
)
@echo.
@set /p pyselect=Select Python version by entering its index from the table above:
@echo.
@IF "%pyselect%"=="" echo Invalid entry.
@IF "%pyselect%"=="" pause
@IF "%pyselect%"=="" GOTO pylist
@IF %pyselect% LEQ 0 echo Invalid entry.
@IF %pyselect% LEQ 0 pause
@IF %pyselect% LEQ 0 GOTO pylist
@IF %pyselect% GTR %pythontotal% echo Invalid entry.
@IF %pyselect% GTR %pythontotal% pause
@IF %pyselect% GTR %pythontotal% GOTO pylist

@rem Locate selected Python installation
@set pythoncount=0
@FOR /F "USEBACKQ tokens=1 skip=1" %%a IN (`py -0 2^>nul`) do @(
@set pythoninstance=%%a
@set goodpython=0
@IF !pythoninstance^:^~1^,-3! EQU 2.7 set goodpython=1
@IF !pythoninstance^:^~1^,-3! GEQ 3.5 IF NOT EXIST %devroot%\mesa set goodpython=1
@IF !pythoninstance^:^~1^,-3! GEQ 3.5 IF EXIST %devroot%\mesa\subprojects\.gitignore set goodpython=1
@IF !goodpython!==1 set /a pythoncount+=1
@IF !pythoncount!==%pyselect% set selectedpython=%%a
)
@FOR /F "tokens=* USEBACKQ" %%a IN (`py %selectedpython%  -c "import sys; print(sys.executable)"`) DO @set pythonloc=%%~sa
@GOTO loadpypath

:nopylauncher
@rem Missing Python launcher fallback code path.
@rem Check if Python is in PATH or if it is provided as a local depedency.
@SET ERRORLEVEL=0
@IF %pythonloc%==python.exe where /q python.exe
@IF ERRORLEVEL 1 set pythonloc=%devroot%\python\python.exe
@IF %pythonloc%==%devroot%\python\python.exe IF NOT EXIST %pythonloc% (
@echo Python is unreachable. Cannot continue.
@echo.
@pause
@exit
)
@IF %pythonloc%==python.exe set exitloop=1&FOR /F "tokens=* USEBACKQ" %%a IN (`where /f python.exe`) DO @IF defined exitloop set "exitloop="&SET pythonloc=%%~sa

:loadpypath
@REM Load Python in PATH to convince CMake to use the selected version and avoid other potential problems.
@SET ERRORLEVEL=0
@set pypath=1
@where /q python.exe
@IF ERRORLEVEL 1 set pypath=0
@IF %pypath%==1 set exitloop=1&FOR /F "tokens=* USEBACKQ" %%a IN (`where /f python.exe`) DO @IF defined exitloop set "exitloop="&SET pypath=%%~sa
@IF NOT %pypath%==%pythonloc% set PATH=%pythonloc:~0,-10%;%pythonloc:~0,-10%Scripts\;%PATH%

:pyver
@rem Identify Python version.
@FOR /F "USEBACKQ delims= " %%a IN (`%pythonloc% -c "import sys; print(sys.version)"`) DO @SET fpythonver=%%a

@rem Check if Python version is not too old.
@FOR /F "USEBACKQ delims= " %%a IN (`%pythonloc% -c "import sys; print(str(sys.version_info[0])+'.'+str(sys.version_info[1]))"`) DO @SET pythonver=%%a
@IF %pythonver% NEQ 2.7 IF %pythonver% LSS 3.5 (
@echo Your Python version is too old. Only Python 2.7 or 3.5 and newer are supported.
@echo.
@pause
@exit
)
@IF %pythonver% GEQ 3.5 IF EXIST %devroot%\mesa IF NOT EXIST %devroot%\mesa\subprojects\.gitignore (
@echo Mesa3D source code you are using lacks Meson build support. Update Mesa3D source code to 19.3 or newer.
@echo.
@pause
@exit
)

@echo Using Python %fpythonver% from %pythonloc%.
@echo.
@endlocal&SET PATH=%PATH%&set pythonver=%fpythonver%&set pythonloc=%pythonloc%
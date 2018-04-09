@REM Try locating all Python versions via Py Launcher.

@SET pythonloc="python.exe"

@REM Disable Py launcher support until we get some Meson support completed.
@GOTO nopylauncher

@set ERRORLEVEL=0
@where /q py.exe
@IF ERRORLEVEL 1 GOTO nopylauncher
@FOR /F "tokens=* USEBACKQ" %%a IN (`py -2.7 -c "import sys; print(sys.executable)"`) DO @SET py2_7loc=%%a
@FOR /F "tokens=* USEBACKQ" %%b IN (`py -3.5 -c "import sys; print(sys.executable)"`) DO @SET py3_5loc=%%b
@FOR /F "tokens=* USEBACKQ" %%c IN (`py -3.6 -c "import sys; print(sys.executable)"`) DO @SET py3_6loc=%%c
@FOR /F "tokens=* USEBACKQ" %%d IN (`py -3.7 -c "import sys; print(sys.executable)"`) DO @SET py3_7loc=%%d
@FOR /F "tokens=* USEBACKQ" %%e IN (`py -3 -c "import sys; print(sys.executable)"`) DO @SET py3latestloc=%%e
@cls
@echo The following Python versions were detected:

@if EXIST "%py2_7loc%" echo Python 2.7
@if EXIST "%py3_5loc%" echo Python 3.5
@if EXIST "%py3_6loc%" echo Python 3.6
@if EXIST "%py3_7loc%" echo Python 3.7
@if EXIST "%py3latestloc%" echo Latest Python 3.x version
@echo.
@set /p pyselect=Please input Python version you want to use with Meson or Scons build system in Major.Minor format or Major only for latest version (ex: 3, 3.5, 2.7):
@echo.

@if EXIST "%py2_7loc%" if "%pyselect%"=="2.7" set pythonloc="%py2_7loc%"
@if EXIST "%py3_5loc%" if "%pyselect%"=="3.5" set pythonloc="%py3_5loc%"
@if EXIST "%py3_6loc%" if "%pyselect%"=="3.6" set pythonloc="%py3_6loc%"
@if EXIST "%py3_7loc%" if "%pyselect%"=="3.7" set pythonloc="%py3_7loc%"
@if EXIST "%py3latestloc%" if "%pyselect%"=="3" set pythonloc="%py3latestloc%"

@IF %pythonloc%=="python.exe" echo Invalid entry. You may close and relaunch this build script or continue as if Py launcher is not installed.
@IF %pythonloc%=="python.exe" pause
@IF %pythonloc%=="python.exe" echo.

:nopylauncher
@SET ERRORLEVEL=0
@IF %pythonloc%=="python.exe" where /q python.exe
@IF ERRORLEVEL 1 set pythonloc="%mesa%\python\python.exe"
@IF %pythonloc%=="%mesa%\python\python.exe" IF NOT EXIST %pythonloc% (
@echo Python is unreachable. Cannot continue.
@GOTO exit
)
@IF %pythonloc%=="python.exe" FOR /F "tokens=* USEBACKQ" %%f IN (`where python.exe`) DO @SET pythonloc=%%f
@if NOT %pythonloc:~-11,-1%==python.exe set pythonloc="%pythonloc%"

@REM Load Python in PATH to convince CMake to use the selected version
@SET ERRORLEVEL=0
@where /q python.exe
@IF ERRORLEVEL 1 set PATH=%pythonloc:~1,-11%;%PATH%

@rem Identify Python version
@set pythonver=2.7
@FOR /F "tokens=* USEBACKQ" %%g IN (`%pythonloc% --version`) DO @SET pythonver=%%g
@cls
@echo Using Python %pythonver% from %pythonloc%.
@echo.
@set pythonver=%pythonver:~0,1%
@if %pythonver% GEQ 3 echo WARNING: Python 3.x support is experimental.
@if %pythonver% GEQ 3 echo.
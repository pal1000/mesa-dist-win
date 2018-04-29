:pydiscover
@REM Try locating all Python versions via Python Launcher.
@SET pythonloc=python.exe

@REM Disable Python launcher support until we get some Meson working.
@GOTO nopylauncher

@rem Query Python launcher for supported Python versions. Hard fail if none found.
@set ERRORLEVEL=0
@where /q py.exe
@IF ERRORLEVEL 1 GOTO nopylauncher
@FOR /F "tokens=* USEBACKQ" %%a IN (`py -2.7 -c "import sys; print(sys.executable)"`) DO @SET py2_7loc=%%~sa
@FOR /F "tokens=* USEBACKQ" %%b IN (`py -3.5 -c "import sys; print(sys.executable)"`) DO @SET py3_5loc=%%~sb
@FOR /F "tokens=* USEBACKQ" %%c IN (`py -3.6 -c "import sys; print(sys.executable)"`) DO @SET py3_6loc=%%~sc
@FOR /F "tokens=* USEBACKQ" %%d IN (`py -3.7 -c "import sys; print(sys.executable)"`) DO @SET py3_7loc=%%~sd
@if NOT EXIST "%py2_7loc%" if NOT EXIST "%py3_5loc%" if NOT EXIST "%py3_6loc%" if NOT EXIST "%py3_7loc%" (
@cls
@echo Your Python version is too old. Only Python 2.7 or 3.5 through 3.7 are supported.
@echo.
@pause
@exit
)

@rem Get latest Python versions in order to support picking a Python version via major version only.
@FOR /F "tokens=* USEBACKQ" %%e IN (`py -3 -c "import sys; print(sys.executable)"`) DO @SET py3latestloc=%%~se
@FOR /F "tokens=* USEBACKQ" %%f IN (`py -2 -c "import sys; print(sys.executable)"`) DO @SET py2latestloc=%%~sf
@cls

@rem List found Python versions and ask the user to pick one.
@echo The following Python versions were detected:
@if EXIST "%py2_7loc%" echo Python 2.7
@if EXIST "%py3_5loc%" echo Python 3.5
@if EXIST "%py3_6loc%" echo Python 3.6
@if EXIST "%py3_7loc%" echo Python 3.7
@echo.
@set /p pyselect=Please input Python version you want to use with Meson or Scons build system in Major.Minor format or Major only for latest version (ex: 3, 3.5, 2.7):
@echo.

@rem Retrieve the location of the selected Python version.
@if EXIST "%py2_7loc%" if "%pyselect%"=="2.7" set pythonloc=%py2_7loc%
@if EXIST "%py3_5loc%" if "%pyselect%"=="3.5" set pythonloc=%py3_5loc%
@if EXIST "%py3_6loc%" if "%pyselect%"=="3.6" set pythonloc=%py3_6loc%
@if EXIST "%py3_7loc%" if "%pyselect%"=="3.7" set pythonloc=%py3_7loc%
@if EXIST "%py3latestloc%" if "%pyselect%"=="3" set pythonloc=%py3latestloc%
@if EXIST "%py2latestloc%" if "%pyselect%"=="2" set pythonloc=%py2latestloc%

@rem User invalid input error checking.
@IF %pythonloc%==python.exe echo Invalid entry.
@IF %pythonloc%==python.exe pause
@IF %pythonloc%==python.exe cls
@IF %pythonloc%==python.exe GOTO pydiscover
@GOTO loadpypath

:nopylauncher
@rem Missing Python launcher fallback code path.
@SET ERRORLEVEL=0
@IF %pythonloc%==python.exe where /q python.exe
@IF ERRORLEVEL 1 set pythonloc=%mesa%\python\python.exe
@IF %pythonloc%==%mesa%\python\python.exe IF NOT EXIST %pythonloc% (
@echo Python is unreachable. Cannot continue.
@pause
@exit
)
@IF %pythonloc%==python.exe FOR /F "tokens=* USEBACKQ" %%g IN (`where /f python.exe`) DO @SET pythonloc=%%~sg & GOTO loadpypath

:loadpypath
@REM Load Python in PATH to convince CMake to use the selected version.
@SET ERRORLEVEL=0
@set pypath=1
@where /q python.exe
@IF ERRORLEVEL 1 set pypath=0
@IF %pypath%==1 FOR /F "tokens=* USEBACKQ" %%h IN (`where /f python.exe`) DO @SET pypath=%%~sh & GOTO doloadpy

:doloadpy
@IF NOT %pypath%==%pythonloc% set PATH=%pythonloc:~0,-10%;%PATH%

:pyver
@rem Identify Python version.
@set pythonver=Python 2.7
@FOR /F "tokens=* USEBACKQ" %%k IN (`%pythonloc% --version`) DO @SET pythonver=%%k
@cls
@echo Using %pythonver% from %pythonloc%.
@echo.
@set pythonver=%pythonver:~7,1%
@if %pythonver% GEQ 3 echo WARNING: Python 3.x support is experimental.
@if %pythonver% GEQ 3 echo.
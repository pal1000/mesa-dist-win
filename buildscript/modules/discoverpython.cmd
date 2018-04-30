:pydiscover
@REM Try locating all Python versions via Python Launcher.
@SET pythonloc=python.exe

@rem Check if Python launcher is installed.
@set ERRORLEVEL=0
@where /q py.exe
@IF ERRORLEVEL 1 GOTO nopylauncher

@rem Query Python launcher for supported Python versions. Hard fail if none found.
@FOR /F "tokens=* USEBACKQ" %%b IN (`py -2.7 -c "import sys; print(sys.executable)"`) DO @SET py2_7loc=%%~sb
@FOR /F "tokens=* USEBACKQ" %%c IN (`py -2.7-32 -c "import sys; print(sys.executable)"`) DO @SET py2_7wowloc=%%~sc
@IF %enablemeson%==1 FOR /F "tokens=* USEBACKQ" %%d IN (`py -3.5 -c "import sys; print(sys.executable)"`) DO @SET py3_5loc=%%~sd
@IF %enablemeson%==1 FOR /F "tokens=* USEBACKQ" %%e IN (`py -3.5-32 -c "import sys; print(sys.executable)"`) DO @SET py3_5wowloc=%%~se
@IF %enablemeson%==1 FOR /F "tokens=* USEBACKQ" %%f IN (`py -3.6 -c "import sys; print(sys.executable)"`) DO @SET py3_6loc=%%~sf
@IF %enablemeson%==1 FOR /F "tokens=* USEBACKQ" %%g IN (`py -3.6-32 -c "import sys; print(sys.executable)"`) DO @SET py3_6wowloc=%%~sg
@IF %enablemeson%==1 FOR /F "tokens=* USEBACKQ" %%h IN (`py -3.7 -c "import sys; print(sys.executable)"`) DO @SET py3_7loc=%%~sh
@IF %enablemeson%==1 FOR /F "tokens=* USEBACKQ" %%i IN (`py -3.7-32 -c "import sys; print(sys.executable)"`) DO @SET py3_7wowloc=%%~si
@cls
@echo Notice: Experimental features disabled. Python launcher interface won't look for Python 3.x.
@echo.
@if NOT EXIST "%py2_7loc%" if NOT EXIST "%py3_5loc%" if NOT EXIST "%py3_6loc%" if NOT EXIST "%py3_7loc%" if NOT EXIST "%py2_7wowloc%" if NOT EXIST "%py3_5wowloc%" if NOT EXIST "%py3_6wowloc%" if NOT EXIST "%py3_7wowloc%" (
@echo Your Python version is too old. Only Python 2.7 or 3.5 through 3.7 are supported.
@echo.
@pause
@exit
)

@rem List found Python versions and ask the user to pick one.
@echo The following Python versions were detected:
@if EXIST "%py2_7loc%" echo 1. Python 2.7
@if EXIST "%py3_5loc%" echo 2. Python 3.5
@if EXIST "%py3_6loc%" echo 3. Python 3.6
@if EXIST "%py3_7loc%" echo 4. Python 3.7
@if EXIST "%py2_7wowloc%" echo 5. Python 2.7 (32-bit)
@if EXIST "%py3_5wowloc%" echo 6. Python 3.5 (32-bit)
@if EXIST "%py3_6wowloc%" echo 7. Python 3.6 (32-bit)
@if EXIST "%py3_7wowloc%" echo 8. Python 3.7 (32-bit)
@echo.
@set /p pyselect=Select Python version by entering it's index from the table above:
@echo.

@rem Retrieve the location of the selected Python version.
@if EXIST "%py2_7loc%" if "%pyselect%"=="1" set pythonloc=%py2_7loc%
@if EXIST "%py3_5loc%" if "%pyselect%"=="2" set pythonloc=%py3_5loc%
@if EXIST "%py3_6loc%" if "%pyselect%"=="3" set pythonloc=%py3_6loc%
@if EXIST "%py3_7loc%" if "%pyselect%"=="4" set pythonloc=%py3_7loc%
@if EXIST "%py2_7wowloc%" if "%pyselect%"=="5" set pythonloc=%py2_7wowloc%
@if EXIST "%py3_5wowloc%" if "%pyselect%"=="6" set pythonloc=%py3_5wowloc%
@if EXIST "%py3_6wowloc%" if "%pyselect%"=="7" set pythonloc=%py3_6wowloc%
@if EXIST "%py3_7wowloc%" if "%pyselect%"=="8" set pythonloc=%py3_7wowloc%

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
@IF %pythonloc%==python.exe FOR /F "tokens=* USEBACKQ" %%j IN (`where /f python.exe`) DO @SET pythonloc=%%~sj & GOTO loadpypath

:loadpypath
@REM Load Python in PATH to convince CMake to use the selected version.
@SET ERRORLEVEL=0
@set pypath=1
@where /q python.exe
@IF ERRORLEVEL 1 set pypath=0
@IF %pypath%==1 FOR /F "tokens=* USEBACKQ" %%k IN (`where /f python.exe`) DO @SET pypath=%%~sk & GOTO doloadpy

:doloadpy
@IF NOT %pypath%==%pythonloc% set PATH=%pythonloc:~0,-10%;%PATH%

:pyver
@rem Identify Python version.
@FOR /F "USEBACKQ delims= " %%l IN (`%pythonloc% -c "import sys; print(sys.version)"`) DO @SET pythonver=%%l

@rem Check if Python version is not too old.
@IF NOT %pythonver:~0,3%==2.7 IF NOT %pythonver:~0,3%==3.5 IF NOT %pythonver:~0,3%==3.6 IF NOT %pythonver:~0,3%==3.7 (
@echo Your Python version is too old. Only Python 2.7 or 3.5 through 3.7 are supported.
@echo.
@pause
@exit
)

@echo Using Python %pythonver% from %pythonloc%.
@echo.
@set pythonver=%pythonver:~0,1%
@if %pythonver% GEQ 3 echo WARNING: Python 3.x support is experimental.
@if %pythonver% GEQ 3 echo.
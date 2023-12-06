@rem Virtual environment setup
@CMD /C EXIT 0
@FC /B %pythonloc% "%devroot%\%projectname%\buildscript\assets\venv\python.exe.orig">NUL 2>&1
@if NOT "%ERRORLEVEL%"=="0" IF EXIST "%devroot%\%projectname%\buildscript\assets\venv\pyvenv.cfg" RD /S /Q "%devroot%\%projectname%\buildscript\assets\venv\"

:mkvenv
@IF NOT EXIST "%devroot%\%projectname%\buildscript\assets\venv\pyvenv.cfg" %pythonloc% -m venv "%devroot%\%projectname%\buildscript\assets\venv">nul 2>&1
@IF NOT EXIST "%devroot%\%projectname%\buildscript\assets\venv\pyvenv.cfg" (
@%pythonloc% -W ignore -m pip install --user -U setuptools
@echo.
)
@IF NOT EXIST "%devroot%\%projectname%\buildscript\assets\venv\pyvenv.cfg" GOTO mkvenv
@IF NOT EXIST "%devroot%\%projectname%\buildscript\assets\venv\python.exe.orig" (
@echo Creating virtual environment...
@copy %pythonloc% "%devroot%\%projectname%\buildscript\assets\venv\python.exe.orig"
@echo.
)
@call "%devroot%\%projectname%\buildscript\assets\venv\Scripts\activate.bat"

@setlocal
@rem Install missing python packages.
@rem State tracking is irrelevant for Python packages as they can easily be added via Pypi if missing.
@rem Meson is the exception because it can be provided as an embedded Python distribution.

@set pypack=0
@set firstpyinstall=1

:pypackmissing
@rem Check for Python packages availability.
@IF NOT EXIST "%devroot%\%projectname%\buildscript\assets\venv\Lib\site-packages\markupsafe\" (
@set pypack=MarkupSafe
@GOTO pypackinstall
)
@IF NOT EXIST "%devroot%\%projectname%\buildscript\assets\venv\Lib\site-packages\mako\" (
@set pypack=Mako
@GOTO pypackinstall
)

@set mesonstate=2
@CMD /C EXIT 0
@where /q meson.exe
@if NOT "%ERRORLEVEL%"=="0" set mesonstate=1
@IF NOT EXIST "%devroot%\%projectname%\buildscript\assets\venv\Scripts\meson.py" IF NOT EXIST "%devroot%\%projectname%\buildscript\assets\venv\Scripts\meson.exe" (
@set pypack=meson
@GOTO pypackinstall
)
@GOTO pyupdate

:pypackinstall
@rem Found a missing package. Install it.
@IF %firstpyinstall%==1 IF NOT %pypack%==0 if EXIST "%LOCALAPPDATA%\pip" RD /S /Q "%LOCALAPPDATA%\pip"
@IF %firstpyinstall%==1 IF NOT %pypack%==0 (
@"%devroot%\%projectname%\buildscript\assets\venv\Scripts\python.exe" -W ignore -m pip install -U pip
@echo.
@"%devroot%\%projectname%\buildscript\assets\venv\Scripts\python.exe" -W ignore -m pip install -U setuptools
@echo.
)
@set firstpyinstall=0
@IF NOT %pypack%==0 "%devroot%\%projectname%\buildscript\assets\venv\Scripts\python.exe" -W ignore -m pip install -U %pypack%
@IF NOT %pypack%==0 echo.
@set pypack=0
@GOTO pypackmissing

:pyupdate
@rem Check for python packages updates.
@set pyupd=n
@set /p pyupd=Update python packages (y/n):
@echo.
@if /I NOT "%pyupd%"=="y" GOTO endpython
@if EXIST "%LOCALAPPDATA%\pip" RD /S /Q "%LOCALAPPDATA%\pip"
@for /F skip^=2^ eol^= %%a in ('"%devroot%\%projectname%\buildscript\assets\venv\Scripts\python.exe" -W ignore -m pip list -o --disable-pip-version-check') do @(
"%devroot%\%projectname%\buildscript\assets\venv\Scripts\python.exe" -W ignore -m pip install -U "%%a"
echo.
)

:endpython
@endlocal&set mesonstate=%mesonstate%
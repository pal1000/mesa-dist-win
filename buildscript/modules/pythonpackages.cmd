@rem Virtual environment setup
@CMD /C EXIT 0
@FC /B %pythonloc% "%devroot%\%projectname%\buildscript\assets\venv\python.exe.orig">NUL 2>&1
@if NOT "%ERRORLEVEL%"=="0" IF EXIST "%devroot%\%projectname%\buildscript\assets\venv\pyvenv.cfg" RD /S /Q "%devroot%\%projectname%\buildscript\assets\venv\"
@IF NOT EXIST "%devroot%\%projectname%\buildscript\assets\venv\pyvenv.cfg" echo Creating virtual environment...
@IF NOT EXIST "%devroot%\%projectname%\buildscript\assets\venv\pyvenv.cfg" echo.

:mkvenv
@IF NOT EXIST "%devroot%\%projectname%\buildscript\assets\venv\pyvenv.cfg" %pythonloc% -m venv "%devroot%\%projectname%\buildscript\assets\venv">nul 2>&1
@IF NOT EXIST "%devroot%\%projectname%\buildscript\assets\venv\pyvenv.cfg" (
@%pythonloc% -W ignore -m pip install --user -U setuptools
@echo.
)
@IF NOT EXIST "%devroot%\%projectname%\buildscript\assets\venv\pyvenv.cfg" GOTO mkvenv
@IF NOT EXIST "%devroot%\%projectname%\buildscript\assets\venv\python.exe.orig" (
@copy %pythonloc% "%devroot%\%projectname%\buildscript\assets\venv\python.exe.orig"
@echo.
)
@call "%devroot%\%projectname%\buildscript\assets\venv\Scripts\activate.bat"

@echo Ensure Python virtual environment compatibility...
@copy /Y "%devroot%\%projectname%\buildscript\assets\venv\Scripts\python.exe" "%devroot%\%projectname%\buildscript\assets\venv\Scripts\python3.exe"
@echo.

@setlocal
@rem Install missing python packages.
@rem State tracking is irrelevant for Python packages as they can easily be added via Pypi if missing.
@rem Meson also provides an alternative Windows installer that adds it to PATH but supporting it is totally not worth it.

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
@IF NOT EXIST "%devroot%\%projectname%\buildscript\assets\venv\Lib\site-packages\yaml\" (
@set pypack=pyyaml
@GOTO pypackinstall
)
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
@"%devroot%\%projectname%\buildscript\assets\venv\Scripts\python.exe" -W ignore -m pip install -U pip setuptools meson Mako MarkupSafe pyyaml
echo.

:endpython
@endlocal
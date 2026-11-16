@setlocal
@rem Get dependencies
@%runmsys% /usr/bin/pacman -S flex bison patch tar --needed --noconfirm --disable-download-timeout
@echo.
@IF NOT %toolchain%==msvc call "%devroot%\%projectname%\buildscript\modules\mingwpackages.cmd" --noconfirm
@IF NOT %toolchain%==msvc %runmsys% /usr/bin/pacman -Rs ${MINGW_PACKAGE_PREFIX}-libclc --noconfirm
@IF NOT %toolchain%==msvc echo.
@IF EXIST "%msysloc%\usr\bin\git.exe" IF %gitstate% GTR 0 (
@%runmsys% /usr/bin/pacman -Rs git --noconfirm
@echo.
)
@IF EXIST "%msysloc%\usr\bin\git" IF %gitstate% GTR 0 (
@%runmsys% /usr/bin/pacman -Rs git --noconfirm
@echo.
)
@set pyyaml=1
@set pythonpip=1
@set pythonmako=1
@IF %LMSYSTEM%==mingw32 IF NOT %toolchain%==msvc for /f delims^= %%a IN ('dir /b "%msysloc%\%LMSYSTEM%\lib\python*" 2^>nul') do @(
@IF NOT EXIST "%msysloc%\%LMSYSTEM%\lib\%%~a\site-packages\mako\" set pythonmako=0
@IF NOT EXIST "%msysloc%\%LMSYSTEM%\lib\%%~a\site-packages\pip\" set pythonpip=0
@IF NOT EXIST "%msysloc%\%LMSYSTEM%\lib\%%~a\site-packages\yaml\" set pyyaml=0
)
@IF %pythonpip% EQU 0 IF EXIST "%devroot%\%projectname%\buildscript\assets\get-pip.py" del "%devroot%\%projectname%\buildscript\assets\get-pip.py"
@IF %pythonpip% EQU 0 IF EXIST "%msysloc%\usr\bin\curl.exe" %runmsys% curl -L --retry 5 --retry-delay 2 --max-time 30 --retry-all-errors https://bootstrap.pypa.io/pip/get-pip.py -o "%devroot%\%projectname%\buildscript\assets\get-pip.py"
@IF %pythonpip% EQU 0 %runmsys% python3 "%devroot%\%projectname%\buildscript\assets\get-pip.py" --break-system-packages
@IF %pythonpip% EQU 0 echo.
@IF %pyyaml% EQU 0 %runmsys% pip install pyyaml --break-system-packages
@IF %pyyaml% EQU 0 echo.
@IF %pythonmako% EQU 0 %runmsys% pip install mako --break-system-packages
@IF %pythonmako% EQU 0 echo.
@endlocal
@IF NOT %toolchain%==msvc set flexstate=2
@IF NOT %toolchain%==msvc set ninjastate=2
@IF NOT %toolchain%==msvc set pkgconfigstate=1
@IF NOT %toolchain%==msvc set cmakestate=2

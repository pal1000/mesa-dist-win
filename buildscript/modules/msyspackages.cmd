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
@for /f delims^= %%a IN ('dir /b "%msysloc%\%LMSYSTEM%\lib\python*"') do @(
@set pyyaml=1
@set pythonpip=1
@IF NOT EXIST "%msysloc%\%LMSYSTEM%\lib\%%~a\site-packages\yaml\" set pyyaml=0
@IF NOT EXIST "%msysloc%\%LMSYSTEM%\lib\%%~a\site-packages\pip\" set pythonpip=0
)
@IF %pyyaml% EQU 0 IF %pythonpip% EQU 0 (
@%rumsys% pacman -S ${MINGW_PACKAGE_PREFIX}-python-pip --needed --noconfirm
@echo.
)
@IF %pyyaml% EQU 0 (
@%rumsys% pip install pyyaml --break-system-packages
@echo.
)
@endlocal
@IF NOT %toolchain%==msvc set flexstate=2
@IF NOT %toolchain%==msvc set ninjastate=2
@IF NOT %toolchain%==msvc set pkgconfigstate=1
@IF NOT %toolchain%==msvc set cmakestate=2

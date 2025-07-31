@setlocal
@rem Get dependencies
@%runmsys% /usr/bin/pacman -S flex bison patch tar --needed --noconfirm --disable-download-timeout
@echo.
@IF NOT %toolchain%==msvc call "%devroot%\%projectname%\buildscript\modules\mingwpackages.cmd" --noconfirm
@IF NOT %toolchain%==msvc echo.
@IF EXIST "%msysloc%\usr\bin\git.exe" IF %gitstate% GTR 0 (
@%runmsys% /usr/bin/pacman -Rs git --noconfirm
@echo.
)
@IF EXIST "%msysloc%\usr\bin\git" IF %gitstate% GTR 0 (
@%runmsys% /usr/bin/pacman -Rs git --noconfirm
@echo.
)
@endlocal
@IF NOT %toolchain%==msvc set flexstate=2
@IF NOT %toolchain%==msvc set ninjastate=2
@IF NOT %toolchain%==msvc set pkgconfigstate=1
@IF NOT %toolchain%==msvc set cmakestate=2

@setlocal
@rem Get dependencies
@%runmsys% /usr/bin/pacman -S ${MINGW_PACKAGE_PREFIX}-%mingwpkglst% flex bison patch tar --needed --noconfirm --disable-download-timeout
@echo.
@IF EXIST "%msysloc%\usr\bin\git.exe" IF %gitstate% GTR 0 (
@%runmsys% /usr/bin/pacman -Rs git --noconfirm
@echo.
)
@IF EXIST "%msysloc%\usr\bin\git" IF %gitstate% GTR 0 (
@%runmsys% /usr/bin/pacman -Rs git --noconfirm
@echo.
)
@endlocal&set flexstate=2&set ninjastate=2&set pkgconfigstate=1&set cmakestate=0
@setlocal
@rem Get dependencies
@%runmsys% /usr/bin/pacman -S ${MINGW_PACKAGE_PREFIX}-%mingwpkglst% flex bison patch tar --needed --noconfirm --disable-download-timeout
@echo.
@FOR /F tokens^=1^ delims^=^:^ eol^= %%a IN ('%runmsys% /usr/bin/pacman -Q git 2^>^&1') do @(
IF /I "%%a"=="error" IF %gitstate% EQU 0 %runmsys% /usr/bin/pacman -S git --noconfirm --disable-download-timeout
IF /I "%%a"=="error" IF %gitstate% EQU 0 echo.
IF /I NOT "%%a"=="error" IF %gitstate% GTR 0 %runmsys% /usr/bin/pacman -Rs git --noconfirm
IF /I NOT "%%a"=="error" IF %gitstate% GTR 0 echo.
)
@set /p msyspkgclear=Clear MSYS2 package cache (y/n):
@echo.
@IF /I "%msyspkgclear%"=="y" call "%devroot%\%projectname%\buildscript\modules\msyspkgclean.cmd"
@IF /I "%msyspkgclear%"=="y" echo.
@endlocal&set flexstate=2&set ninjastate=2&set pkgconfigstate=1&set cmakestate=0
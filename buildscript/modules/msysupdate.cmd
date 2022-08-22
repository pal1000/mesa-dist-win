@setlocal
@rem Check for updates
@rem Initial upgrade
@IF %msysstate% GTR 0 IF NOT EXIST "%msysloc%\usr\bin\bison.exe" set msysupdate=y
@IF EXIST "%msysloc%\usr\bin\bison.exe" set /p msysupdate=Update MSYS2 packages (y/n):
@IF EXIST "%msysloc%\usr\bin\bison.exe" echo.
@IF /I "%msysupdate%"=="y" %runmsys% /usr/bin/pacman -Sy --noconfirm --disable-download-timeout
@IF /I "%msysupdate%"=="y" %runmsys% /usr/bin/pacman -Su --noconfirm --disable-download-timeout
@IF /I "%msysupdate%"=="y" echo.
@IF /I "%msysupdate%"=="y" %runmsys% /usr/bin/pacman -Su --noconfirm --disable-download-timeout
@IF /I "%msysupdate%"=="y" echo.
@IF /I "%msysupdate%"=="y" set /p msyspkgclear=Clear MSYS2 package cache (y/n):
@IF /I "%msysupdate%"=="y" echo.
@IF /I "%msyspkgclear%"=="y" call "%devroot%\%projectname%\buildscript\modules\msyspkgclean.cmd"
@IF /I "%msyspkgclear%"=="y" echo.
@endlocal
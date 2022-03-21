@setlocal
@rem Check for updates
@rem Initial upgrade
@IF %msysstate% GTR 0 IF NOT EXIST %msysloc%\usr\bin\bison.exe (
@%runmsys% /usr/bin/pacman -Sy --noconfirm --disable-download-timeout
@%runmsys% /usr/bin/pacman -Su --noconfirm --disable-download-timeout
@echo.
@%runmsys% /usr/bin/pacman -Su --noconfirm --disable-download-timeout
@echo.
)

@IF EXIST %msysloc%\usr\bin\bison.exe set /p msysupdate=Update MSYS2 packages (y/n):
@IF EXIST %msysloc%\usr\bin\bison.exe echo.
@IF /I "%msysupdate%"=="y" %runmsys% /usr/bin/pacman -Sy --noconfirm --disable-download-timeout
@IF /I "%msysupdate%"=="y" %runmsys% /usr/bin/pacman -Su --noconfirm --disable-download-timeout
@IF /I "%msysupdate%"=="y" echo.
@IF /I "%msysupdate%"=="y" %runmsys% /usr/bin/pacman -Su --noconfirm --disable-download-timeout
@IF /I "%msysupdate%"=="y" echo.
@endlocal
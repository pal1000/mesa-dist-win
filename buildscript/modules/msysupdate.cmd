@rem Check for updates
@rem Initial upgrade
@IF NOT EXIST %msysloc%\usr\bin\bison.exe (
@%runmsys% pacman -Syu --noconfirm --disable-download-timeout
@%runmsys% pacman -Syu --noconfirm --disable-download-timeout
)

@IF EXIST %msysloc%\usr\bin\bison.exe set /p msysupdate=Update MSYS2 packages (y/n):
@IF EXIST %msysloc%\usr\bin\bison.exe echo.
@IF /I "%msysupdate%"=="y" %runmsys% pacman -Syu --noconfirm --disable-download-timeout

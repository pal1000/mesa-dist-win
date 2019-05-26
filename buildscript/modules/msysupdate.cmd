@rem Check for updates
@rem Initial upgrade
@IF NOT EXIST %msysloc%\usr\bin\bison.exe (
@%runmsys% pacman -Syu --noconfirm --disable-download-timeout
@%runmsys% pacman -Syu --noconfirm --disable-download-timeout
)

@set /p msysupdate=Update MSYS2 packages (y/n):
@echo.
@IF /I "%msysupdate%"=="y" %runmsys% pacman -Syu --noconfirm --disable-download-timeout

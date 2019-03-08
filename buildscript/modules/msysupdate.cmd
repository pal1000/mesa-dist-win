@rem Check for updates
@set /p msysupdate=Update MSYS2 packages (y/n):
@echo.
@IF /I "%msysupdate%"=="y" %msysloc%\usr\bin\pacman -Syu --noconfirm
@IF /I "%msysupdate%"=="y" echo.

@set /p msysupdate=Update MSYS2 packages (y/n):
@echo.
@IF /I "%msysupdate%"=="y" pacman -Syu
@echo.
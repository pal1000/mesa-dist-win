@rem Check for updates
@rem Initial upgrade
@IF NOT EXIST %msysloc%\mingw%minabi%\bin\libwinpthread-1.dll (
@%runmsys% pacman -Syu --noconfirm
@%runmsys% pacman -Syu --noconfirm
)

@set /p msysupdate=Update MSYS2 packages (y/n):
@echo.
@IF /I "%msysupdate%"=="y" %runmsys% pacman -Syu --noconfirm

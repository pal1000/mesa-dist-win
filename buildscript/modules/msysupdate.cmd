@setlocal
@rem Check for updates
@rem Initial upgrade
@set MSYSTEM=MSYS
@IF NOT EXIST %msysloc%\usr\bin\bison.exe (
@%msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -Syu --noconfirm --disable-download-timeout"
@echo.
@%msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -Syu --noconfirm --disable-download-timeout"
@echo.
@%msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -Sc --noconfirm"
@echo.
)

@IF EXIST %msysloc%\usr\bin\bison.exe set /p msysupdate=Update MSYS2 packages (y/n):
@IF EXIST %msysloc%\usr\bin\bison.exe echo.
@IF /I "%msysupdate%"=="y" %msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -Syu --noconfirm --disable-download-timeout"
@IF /I "%msysupdate%"=="y" echo.
@IF /I "%msysupdate%"=="y" %msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -Syu --noconfirm --disable-download-timeout"
@IF /I "%msysupdate%"=="y" echo.
@IF /I "%msysupdate%"=="y" %msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -Sc --noconfirm"
@IF /I "%msysupdate%"=="y" echo.
@endlocal
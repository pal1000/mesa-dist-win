@setlocal
@rem Check for updates
@call "%devroot%\%projectname%\bin\modules\prompt.cmd" msysupdate "Update MSYS2 packages (y/n):"
@IF /I "%msysupdate%"=="y" %runmsys% /usr/bin/pacman -Sy --noconfirm --disable-download-timeout
@IF /I "%msysupdate%"=="y" %runmsys% /usr/bin/pacman -Su --noconfirm --disable-download-timeout
@IF /I "%msysupdate%"=="y" echo.
@IF /I "%msysupdate%"=="y" %runmsys% /usr/bin/pacman -Su --noconfirm --disable-download-timeout
@IF /I "%msysupdate%"=="y" echo.
@IF /I "%msysupdate%"=="y" IF EXIST "%msysloc%\%LMSYSTEM%\bin\pip.exe" %rumsys% pip install -U pyyaml --break-system-packages
@IF /I "%msysupdate%"=="y" IF EXIST "%msysloc%\%LMSYSTEM%\bin\pip.exe" echo.
@IF /I "%msysupdate%"=="y" call "%devroot%\%projectname%\bin\modules\prompt.cmd" msyspkgclear "Clear MSYS2 package cache (y/n):"
@IF /I "%msyspkgclear%"=="y" call "%devroot%\%projectname%\buildscript\modules\msyspkgclean.cmd"
@IF /I "%msyspkgclear%"=="y" echo.
@endlocal
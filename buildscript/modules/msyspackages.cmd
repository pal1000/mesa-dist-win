@setlocal
@rem Get dependencies
@set MSYSTEM=MSYS
@IF %mesabldsys%==scons %msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -S python-mako %mingwabi%-llvm %mingwabi%-gcc flex bison patch scons tar --needed --noconfirm --disable-download-timeout"
@IF %mesabldsys%==meson %msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -S %mingwabi%-python-mako %mingwabi%-llvm %mingwabi%-gcc %mingwabi%-meson %mingwabi%-pkg-config flex bison patch tar git --needed --noconfirm --disable-download-timeout"
@echo.
@%msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -Sc --noconfirm"
@echo.
@endlocal&set mesabldsys=%mesabldsys%&set flexstate=2&set ninjastate=2&set pkgconfigstate=1
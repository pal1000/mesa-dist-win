@setlocal
@rem Get dependencies
@set MSYSTEM=MSYS
@IF %mesabldsys%==scons %msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -S python2-mako %mingwabi%-llvm %mingwabi%-gcc %mingwabi%-zlib flex bison patch scons --needed --noconfirm --disable-download-timeout"
@IF %mesabldsys%==meson %msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -S %mingwabi%-python3-mako %mingwabi%-llvm %mingwabi%-gcc %mingwabi%-zlib %mingwabi%-meson %mingwabi%-pkg-config flex bison patch --needed --noconfirm --disable-download-timeout"
@echo.
@%msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -Sc --noconfirm"
@echo.
@endlocal&set mesabldsys=%mesabldsys%&set flexstate=2&set ninjastate=2&set pkgconfigstate=1

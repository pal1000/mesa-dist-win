@setlocal
@rem Get dependencies
@set MSYSTEM=MSYS
@%msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -S %mingwabi%-python-mako %mingwabi%-llvm %mingwabi%-gcc %mingwabi%-meson %mingwabi%-pkg-config flex bison patch tar git --needed --noconfirm --disable-download-timeout"
@echo.
@%msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -Sc --noconfirm"
@echo.
@endlocal&set flexstate=2&set ninjastate=2&set pkgconfigstate=1
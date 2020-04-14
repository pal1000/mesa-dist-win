@setlocal
@rem Get dependencies
@%msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -S ${MINGW_PACKAGE_PREFIX}-python-mako ${MINGW_PACKAGE_PREFIX}-llvm ${MINGW_PACKAGE_PREFIX}-gcc ${MINGW_PACKAGE_PREFIX}-meson ${MINGW_PACKAGE_PREFIX}-pkg-config flex bison patch tar --needed --noconfirm --disable-download-timeout"
@echo.
@%msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -Sc --noconfirm"
@echo.
@endlocal&set flexstate=2&set ninjastate=2&set pkgconfigstate=1
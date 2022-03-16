@setlocal
@rem Get dependencies
@%msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -S ${MINGW_PACKAGE_PREFIX}-{python-mako,meson,pkgconf,vulkan-devel,libelf,zstd,gdb,llvm,cc} flex bison patch tar --needed --noconfirm --disable-download-timeout"
@echo.
@FOR /F "tokens=1 delims=:" %%a IN ('%msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -Q git" 2^>^&1') do @(
IF /I "%%a"=="error" IF %gitstate% EQU 0 %msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -S git --noconfirm --disable-download-timeout"
IF /I "%%a"=="error" IF %gitstate% EQU 0 echo.
IF /I NOT "%%a"=="error" IF %gitstate% GTR 0 %msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -Rs git --noconfirm"
IF /I NOT "%%a"=="error" IF %gitstate% GTR 0 echo.
)
@endlocal&set flexstate=2&set ninjastate=2&set pkgconfigstate=1&set cmakestate=0
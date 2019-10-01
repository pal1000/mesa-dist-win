@rem Select build system for Mesa3D build
@set selectmesabld=1

:msyspython
@rem echo Select build system for Mesa3D
@rem echo ------------------------------
@rem echo 1. Scons build with Python 2.7
@rem echo 2. Meson build with Python 3
@rem set /p selectmesabld=Select build system for Mesa3D build:
@rem echo.
@IF NOT "%selectmesabld%"=="1" IF NOT "%selectmesabld%"=="2" (
@echo Invalid entry.
@pause
@cls
@GOTO msyspython
)
@IF %selectmesabld%==1 set mesabldsys=scons
@IF %selectmesabld%==2 set mesabldsys=meson

@rem Get dependencies
@IF %mesabldsys%==scons %msysloc%\usr\bin\bash --login -c "pacman -S python2-mako mingw-w64-%mingwabi%-llvm mingw-w64-%mingwabi%-gcc mingw-w64-%mingwabi%-zlib flex bison patch scons --needed --noconfirm --disable-download-timeout"
@IF %mesabldsys%==meson %msysloc%\usr\bin\bash --login -c "pacman -S mingw-w64-%mingwabi%-python3-mako mingw-w64-%mingwabi%-llvm mingw-w64-%mingwabi%-gcc mingw-w64-%mingwabi%-zlib mingw-w64-%mingwabi%-meson flex bison patch --needed --noconfirm --disable-download-timeout"
@echo.
@set flexstate=2
@set ninjastate=2
@set pkgconfigstate=1
@set gitstate=2
@SET ERRORLEVEL=0
@where /q git.exe
@IF ERRORLEVEL 1 set gitstate=0


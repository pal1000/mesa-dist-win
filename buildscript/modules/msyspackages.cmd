@rem Select build system for Mesa3D build
@set pythonver=2

:msyspython
@rem IF %enablemeson%==1 echo Select build system for Mesa3D build
@rem IF %enablemeson%==1 echo ------------------------------------
@rem IF %enablemeson%==1 echo 2. Scons build with Python 2.7
@rem IF %enablemeson%==1 echo 3. Meson build with Python 3
@rem IF %enablemeson%==1 set /p pythonver=Select Python version:
@rem IF %enablemeson%==1 echo.
@IF NOT "%pythonver%"=="2" IF NOT "%pythonver%"=="3" (
@echo Invalid entry.
@pause
@cls
@GOTO msyspython
)

@rem Get dependencies
@IF %pythonver%==2 %runmsys% pacman -S python2-mako mingw-w64-%mingwabi%-llvm mingw-w64-%mingwabi%-gcc mingw-w64-%mingwabi%-zlib flex bison patch scons --needed --noconfirm --disable-download-timeout
@IF %pythonver% GEQ 3 %runmsys% pacman -S mingw-w64-%mingwabi%-python3-mako mingw-w64-%mingwabi%-llvm mingw-w64-%mingwabi%-gcc mingw-w64-%mingwabi%-zlib mingw-w64-%mingwabi%-meson flex bison patch --needed --noconfirm --disable-download-timeout
@set flexstate=2
@set ninjastate=2
@set pkgconfigstate=1
@set gitstate=2
@SET ERRORLEVEL=0
@where /q git.exe
@IF ERRORLEVEL 1 set gitstate=0


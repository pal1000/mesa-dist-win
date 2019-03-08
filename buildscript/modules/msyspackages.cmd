@rem Select build system for Mesa3D build
@set pythonver=2
@set mesaunix=%mesa:\=/%
@set mesaunix=/%mesa:~0,1%%mesa:~2%

:msyspython
@IF %enablemeson%==1 echo Select build system for Mesa3D build
@IF %enablemeson%==1 echo ------------------------------------
@IF %enablemeson%==1 echo 2. Scons build with Python 2.7
@IF %enablemeson%==1 echo 3. Meson build with Python 3
@IF %enablemeson%==1 set /p pythonver=Select Python version:
@IF %enablemeson%==1 echo.
@IF NOT "%pythonver%"=="2" IF NOT "%pythonver%"=="3" (
@echo Invalid entry.
@pause
@cls
@GOTO msyspython


@rem Get dependencies
@%msysloc%\usr\bin\pacman -S python%pythonver%-mako mingw-w64-%mingwabi%-clang flex bison patch --needed --noconfirm
@echo.
@IF %pythonver%==2 %msysloc%\usr\bin\pacman -S scons --needed --noconfirm
@IF %pythonver%==3 %msysloc%\usr\bin\pacman -S meson ninja --needed --noconfirm
@echo.
@set flexstate=2
@set ninjastate=2
@set pkgconfigstate=1
@set gitstate=2
@SET ERRORLEVEL=0
@where /q git.exe
@IF ERRORLEVEL 1 (
@%msysloc%\usr\bin\pacman -S git --needed --noconfirm
@echo.
)
@set git=%msysloc%\usr\bin\git.exe


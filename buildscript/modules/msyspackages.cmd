@setlocal
@rem Get dependencies
@%runmsys% /usr/bin/pacman -S flex bison patch tar --needed --noconfirm --disable-download-timeout
@echo.
@IF NOT %toolchain%==msvc for /f tokens^=1-23^ delims^={^,}^ eol^= %%a IN ("%mingwpkglst%") DO @(
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%a --needed --noconfirm --disable-download-timeout
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%b --needed --noconfirm --disable-download-timeout
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%c --needed --noconfirm --disable-download-timeout
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%d --needed --noconfirm --disable-download-timeout
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%e --needed --noconfirm --disable-download-timeout
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%f --needed --noconfirm --disable-download-timeout
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%g --needed --noconfirm --disable-download-timeout
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%h --needed --noconfirm --disable-download-timeout
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%i --needed --noconfirm --disable-download-timeout
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%j --needed --noconfirm --disable-download-timeout
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%k --needed --noconfirm --disable-download-timeout
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%l --needed --noconfirm --disable-download-timeout
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%m --needed --noconfirm --disable-download-timeout
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%n --needed --noconfirm --disable-download-timeout
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%o --needed --noconfirm --disable-download-timeout
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%p --needed --noconfirm --disable-download-timeout
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%q --needed --noconfirm --disable-download-timeout
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%r --needed --noconfirm --disable-download-timeout
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%s --needed --noconfirm --disable-download-timeout
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%t --needed --noconfirm --disable-download-timeout
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%u --needed --noconfirm --disable-download-timeout
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%v --needed --noconfirm --disable-download-timeout
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%w --needed --noconfirm --disable-download-timeout
)
@IF NOT %toolchain%==msvc echo.
@IF EXIST "%msysloc%\usr\bin\git.exe" IF %gitstate% GTR 0 (
@%runmsys% /usr/bin/pacman -Rs git --noconfirm
@echo.
)
@IF EXIST "%msysloc%\usr\bin\git" IF %gitstate% GTR 0 (
@%runmsys% /usr/bin/pacman -Rs git --noconfirm
@echo.
)
@endlocal
@set glslang=1
@IF NOT %toolchain%==msvc set flexstate=2
@IF NOT %toolchain%==msvc set ninjastate=2
@IF NOT %toolchain%==msvc set pkgconfigstate=1
@IF NOT %toolchain%==msvc set cmakestate=2
@IF NOT %toolchain%==msvc IF NOT EXIST "%msysloc%\%LMSYSTEM%\bin\glslangValidator.exe" set glslang=0
@for /f tokens^=1-25^ delims^={^,}^ eol^= %%a IN ("%mingwpkglst%") DO @(
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%a --needed --disable-download-timeout %*
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%b --needed --disable-download-timeout %*
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%c --needed --disable-download-timeout %*
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%d --needed --disable-download-timeout %*
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%e --needed --disable-download-timeout %*
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%f --needed --disable-download-timeout %*
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%g --needed --disable-download-timeout %*
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%h --needed --disable-download-timeout %*
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%i --needed --disable-download-timeout %*
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%j --needed --disable-download-timeout %*
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%k --needed --disable-download-timeout %*
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%l --needed --disable-download-timeout %*
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%m --needed --disable-download-timeout %*
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%n --needed --disable-download-timeout %*
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%o --needed --disable-download-timeout %*
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%p --needed --disable-download-timeout %*
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%q --needed --disable-download-timeout %*
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%r --needed --disable-download-timeout %*
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%s --needed --disable-download-timeout %*
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%t --needed --disable-download-timeout %*
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%u --needed --disable-download-timeout %*
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%v --needed --disable-download-timeout %*
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%w --needed --disable-download-timeout %*
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%x --needed --disable-download-timeout %*
%runmsys% pacman -S ${MINGW_PACKAGE_PREFIX}-%%y --needed --disable-download-timeout %*
)
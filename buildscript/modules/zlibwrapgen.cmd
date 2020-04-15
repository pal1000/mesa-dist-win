@setlocal
@FOR /F USEBACKQ^ tokens^=5^ delims^=-^  %%a IN (`%msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -Q ${MINGW_PACKAGE_PREFIX}-zlib"`) DO @SET zlibver=%%~a
@IF NOT EXIST %devroot%\mesa\subprojects\zlib md %devroot%\mesa\subprojects\zlib
@(echo project^('zlib', ['cpp']^)
echo.
echo cpp = meson.get_compiler^('cpp'^)
echo.
echo _deps = []
echo zlibloc = run_command^('%devroot:\=/%/%projectname%/buildscript/modules/msysmingwruntimeloc.cmd'^).stdout^(^).strip^(^)
echo _search = zlibloc + '/lib'
echo foreach d ^: ['libz']
echo   _deps += cpp.find_library^(d, dirs ^: _search, static ^: true^)
echo endforeach
echo.
echo zlib_dep = declare_dependency^(
echo   include_directories ^: include_directories^(zlibloc + '/include'^),
echo   dependencies ^: _deps,
echo   version ^: '%zlibver%',
echo ^)
)>%devroot%\mesa\subprojects\zlib\meson.build
@endlocal
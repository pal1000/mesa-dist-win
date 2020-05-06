@setlocal
@CMD /C EXIT 0
@IF %toolchain%==msvc FC /B %devroot%\%projectname%\patches\zlib.wrap %devroot%\mesa\subprojects\zlib.wrap>NUL 2>&1
@if NOT "%ERRORLEVEL%"=="0" (
@copy /Y %devroot%\%projectname%\patches\zlib.wrap %devroot%\mesa\subprojects\zlib.wrap
@echo.
)
@IF %toolchain%==msvc IF EXIST "%devroot%\mesa\subprojects\zlib\" RD /S /Q %devroot%\mesa\subprojects\zlib
@IF %toolchain%==msvc SET zlibver=none
@IF %toolchain%==gcc for /d %%a in ("%devroot%\mesa\subprojects\zlib-*") do @RD /S /Q "%%~a"
@IF %toolchain%==gcc IF EXIST %devroot%\mesa\subprojects\zlib.wrap del %devroot%\mesa\subprojects\zlib.wrap
@IF %toolchain%==gcc FOR /F USEBACKQ^ tokens^=5^ delims^=-^  %%a IN (`%msysloc%\usr\bin\bash --login -c "/usr/bin/pacman -Q ${MINGW_PACKAGE_PREFIX}-zlib"`) DO @SET zlibver=%%~a
@IF %toolchain%==gcc IF NOT EXIST "%devroot%\mesa\subprojects\zlib\" md %devroot%\mesa\subprojects\zlib
@IF %toolchain%==gcc IF NOT EXIST "%devroot%\%projectname%\buildscript\assets\" md %devroot%\%projectname%\buildscript\assets
@IF %toolchain%==gcc (
echo project^('zlib', ['cpp']^)
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
)>%devroot%\%projectname%\buildscript\assets\zlib-wrap.txt
@CMD /C EXIT 0
@IF %toolchain%==gcc FC /B %devroot%\%projectname%\buildscript\assets\zlib-wrap.txt %devroot%\mesa\subprojects\zlib\meson.build>NUL 2>&1
@if NOT "%ERRORLEVEL%"=="0" (
@copy /Y %devroot%\%projectname%\buildscript\assets\zlib-wrap.txt %devroot%\mesa\subprojects\zlib\meson.build
@echo.
)
@endlocal
@setlocal
@CMD /C EXIT 0
@IF %toolchain%==msvc FC /B %devroot%\%projectname%\patches\zlib.wrap %devroot%\mesa\subprojects\zlib.wrap>NUL 2>&1
@if NOT "%ERRORLEVEL%"=="0" (
@copy /Y %devroot%\%projectname%\patches\zlib.wrap %devroot%\mesa\subprojects\zlib.wrap
@echo.
)
@IF %toolchain%==msvc IF EXIST "%devroot%\mesa\subprojects\zlib\" RD /S /Q %devroot%\mesa\subprojects\zlib
@IF NOT %toolchain%==msvc for /d %%a in ("%devroot%\mesa\subprojects\zlib-*") do @RD /S /Q "%%~a"
@IF NOT %toolchain%==msvc IF EXIST %devroot%\mesa\subprojects\zlib.wrap del %devroot%\mesa\subprojects\zlib.wrap
@IF NOT %toolchain%==msvc IF NOT EXIST "%devroot%\mesa\subprojects\zlib\" md %devroot%\mesa\subprojects\zlib
@IF NOT %toolchain%==msvc IF NOT EXIST "%devroot%\%projectname%\buildscript\assets\" md %devroot%\%projectname%\buildscript\assets
@IF NOT %toolchain%==msvc (
echo project^('zlib', ['cpp']^)
echo.
echo cpp = meson.get_compiler^('cpp'^)
echo.
echo zlib_dep ^= dependency^('zlib', static ^: true^)
)>%devroot%\%projectname%\buildscript\assets\zlib-wrap.txt
@CMD /C EXIT 0
@IF NOT %toolchain%==msvc FC /B %devroot%\%projectname%\buildscript\assets\zlib-wrap.txt %devroot%\mesa\subprojects\zlib\meson.build>NUL 2>&1
@if NOT "%ERRORLEVEL%"=="0" (
@copy /Y %devroot%\%projectname%\buildscript\assets\zlib-wrap.txt %devroot%\mesa\subprojects\zlib\meson.build
@echo.
)
@endlocal
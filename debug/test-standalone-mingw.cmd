@cd "%~dp0"
@cd ..\..\
@for %%a in ("%cd%") do @set devroot=%%~sa
@set abi=x86
@set PATH=%devroot%\mingw32\bin\;%devroot%\flexbison\;%devroot%\ninja\;%devroot%\pkgconf\pkgconf\;%PATH%
@call %devroot%\mesa-dist-win\buildscript\modules\discoverpython.cmd
@call %devroot%\mesa-dist-win\buildscript\modules\pythonpackages.cmd
@cd mesa
@git checkout .
@echo.
@set buildconf=meson build/%abi% --buildtype=release -Dllvm=false -Dzlib:default_library=static
@set LDFLAGS=-static
@set buildcmd=ninja -C build/%abi% -j 3
@for /d %%a in ("%devroot%\mesa\subprojects\zlib-*") do @RD /S /Q "%%~a"
@IF EXIST "%devroot%\mesa\subprojects\zlib\" RD /S /Q %devroot%\mesa\subprojects\zlib
@IF EXIST build\%abi% RD /S /Q build\%abi%
@IF EXIST %devroot%\mesa-dist-win\bin\%abi% RD /S /Q %devroot%\mesa-dist-win\bin\%abi%
@md %devroot%\mesa-dist-win\bin\%abi%
@set inst=copy %devroot%\mesa\build\%abi%\src\gallium\targets\libgl-gdi\opengl32.dll %devroot%\mesa-dist-win\bin\%abi%
@cmd

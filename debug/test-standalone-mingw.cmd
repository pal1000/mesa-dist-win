@cd "%~dp0"
@cd ..\..\
@for %%a in ("%cd%") do @set devroot=%%~sa
@set abi=x64
@set minabi=64
@IF %abi%==x86 set minabi=32
@set PATH=%devroot%\flexbison\;%devroot%\TDM-GCC-64\bin\;%devroot%\ninja\;%devroot%\pkgconf\build\;%PATH%
@call %devroot%\mesa-dist-win\buildscript\modules\discoverpython.cmd
@echo.
@cd mesa
@git checkout .
@set buildconf=meson build/%abi% --default-library=static --buildtype=release -Dllvm=false -Dbuild-tests=true
@set buildcmd=ninja -C build/%abi%
@for /d %%a in ("%devroot%\mesa\subprojects\zlib-*") do @RD /S /Q "%%~a"
@IF EXIST "%devroot%\mesa\subprojects\zlib\" RD /S /Q %devroot%\mesa\subprojects\zlib
@IF EXIST build\%abi% RD /S /Q build\%abi%
@IF EXIST %devroot%\mesa-dist-win\bin\%abi% RD /S /Q %devroot%\mesa-dist-win\bin\%abi%
@md %devroot%\mesa-dist-win\bin\%abi%
@set inst=copy %devroot%\mesa\build\%abi%\src\gallium\targets\libgl-gdi\opengl32.dll %devroot%\mesa-dist-win\bin\%abi%
@cmd

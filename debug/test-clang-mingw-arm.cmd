@cd "%~dp0"
@cd ..\..\
@for %%a in ("%cd%") do @set devroot=%%~sa
@set abi=aarch64
@set PATH=%devroot%\flexbison\;%devroot%\llvm-mingw\bin\;%devroot%\ninja\;%devroot%\pkgconf\pkgconf\;%PATH%
@call %devroot%\mesa-dist-win\buildscript\modules\discoverpython.cmd
@call %devroot%\mesa-dist-win\buildscript\modules\pythonpackages.cmd
@cd mesa
@echo Undoing out of tree patches...
@git checkout .
@git clean -fd
@echo.
@set buildconf=meson build/clang-%abi% --buildtype=release --cross-file=%devroot:\=/%/mesa-dist-win/buildscript/mesonconffiles/%abi%-clang.txt -Dllvm=false
@set buildcmd=ninja -C build/clang-%abi% -j 2
@for /d %%a in ("%devroot%\mesa\subprojects\zlib-*") do @RD /S /Q "%%~a"
@IF EXIST "%devroot%\mesa\subprojects\zlib\" RD /S /Q %devroot%\mesa\subprojects\zlib
@IF EXIST build\clang-%abi% RD /S /Q build\clang-%abi%
@IF EXIST %devroot%\mesa-dist-win\bin\%abi% RD /S /Q %devroot%\mesa-dist-win\bin\%abi%
@md %devroot%\mesa-dist-win\bin\%abi%
@set inst=copy %devroot%\mesa\build\clang-%abi%\src\gallium\targets\libgl-gdi\opengl32.dll %devroot%\mesa-dist-win\bin\%abi%
@cmd

@set projectname=mesa-dist-win
@cd "%~dp0"
@cd ..\..\
@set CD=
@set devroot=%CD%
@IF %devroot:~0,1%%devroot:~-1%=="" set devroot=%devroot:~1,-1%
@IF "%devroot:~-1%"=="\" set devroot=%devroot:~0,-1%
@set abi=aarch64
@set PATH=%devroot%\flexbison\;%devroot%\llvm-mingw\bin\;%devroot%\ninja\;%devroot%\pkgconf\pkgconf\;%PATH%
@call "%devroot%\%projectname%\buildscript\modules\discoverpython.cmd"
@call "%devroot%\%projectname%\buildscript\modules\pythonpackages.cmd"
@cd mesa
@echo Undoing out of tree patches...
@git checkout .
@git clean -fd
@echo.
@set buildconf=meson build/clang-%abi% --buildtype=release --cross-file="%devroot:\=/%/%projectname%/buildscript/mesonconffiles/%abi%-clang.txt" -Dllvm=false
@set buildcmd=ninja -C build/clang-%abi% -j 2
@for /f delims^=^ eol^= %%a in ('dir /b /a:d "%devroot%\mesa\subprojects\zlib-*"') do @RD /S /Q "%devroot%\mesa\subprojects\%%~a"
@IF EXIST "%devroot%\mesa\subprojects\zlib\" RD /S /Q "%devroot%\mesa\subprojects\zlib"
@IF EXIST "build\clang-%abi%\" RD /S /Q build\clang-%abi%
@IF EXIST "%devroot%\%projectname%\bin\%abi%\" RD /S /Q "%devroot%\%projectname%\bin\%abi%"
@md "%devroot%\%projectname%\bin\%abi%"
@set inst=copy "%devroot%\mesa\build\clang-%abi%\src\gallium\targets\libgl-gdi\opengl32.dll" "%devroot%\%projectname%\bin\%abi%"
@cmd

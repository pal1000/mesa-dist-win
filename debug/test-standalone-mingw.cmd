@set projectname=mesa-dist-win
@cd "%~dp0"
@cd ..\..\
@set CD=
@set devroot=%CD%
@IF %devroot:~0,1%%devroot:~-1%=="" set devroot=%devroot:~1,-1%
@IF "%devroot:~-1%"=="\" set devroot=%devroot:~0,-1%
@set PATH=%devroot%\flexbison\;%devroot%\ninja\;%devroot%\pkgconf\pkgconf\;%PATH%
@call "%devroot%\%projectname%\buildscript\modules\abi.cmd"
@set multilib=0
@IF NOT "%multilib%"=="1" set PATH=%devroot%\%LMSYSTEM%\bin\;%PATH%
@IF "%multilib%"=="1" set PATH=%devroot%\mingw64\bin\;%PATH%
@call "%devroot%\%projectname%\buildscript\modules\discoverpython.cmd"
@call "%devroot%\%projectname%\buildscript\modules\pythonpackages.cmd"
@cd mesa
@echo Undoing out of tree patches...
@git checkout .
@git clean -fd
@copy /Y "%devroot%\%projectname%\buildscript\mesonsubprojects\zlib.wrap" "%devroot%\mesa\subprojects\zlib.wrap"
@echo.
@set buildconf=meson build/gcc-%abi% -Dbuildtype=debugoptimized -Dllvm=disabled -Dzlib:default_library=static -Dgallium-drivers=swrast,zink
@IF NOT EXIST "%VK_SDK_PATH%" IF NOT EXIST "%VULKAN_SDK%" set buildconf=%buildconf:~0,-5%
@set LDFLAGS=-static
@IF "%multilib%"=="1" set CFLAGS=-m32
@IF "%multilib%"=="1" set CXXFLAGS=-m32
@IF "%multilib%"=="1" set LDFLAGS=%LDFLAGS% -m32
@set buildcmd=ninja -C build/gcc-%abi% -j 2
@for /f delims^=^ eol^= %%a in ('dir /b /a:d "%devroot%\mesa\subprojects\zlib-*" 2^>^&1') do @IF EXIST "%devroot%\mesa\subprojects\%%~nxa\" RD /S /Q "%devroot%\mesa\subprojects\%%~nxa"
@IF EXIST "%devroot%\mesa\subprojects\zlib\" RD /S /Q "%devroot%\mesa\subprojects\zlib"
@IF EXIST "build\gcc-%abi%\" RD /S /Q build\gcc-%abi%
@IF EXIST "%devroot%\%projectname%\bin\%abi%\" RD /S /Q "%devroot%\%projectname%\bin\%abi%"
@md "%devroot%\%projectname%\bin\%abi%"
@set inst=copy /Y "%devroot%\mesa\build\gcc-%abi%\src\gallium\targets\libgl-gdi\opengl32.dll" "%devroot%\%projectname%\bin\%abi%"
@cmd

@cd "%~dp0"
@cd ..\..\
@for %%a in ("%cd%") do @set devroot=%%~sa
@set PATH=%devroot%\flexbison\;%devroot%\ninja\;%devroot%\pkgconf\pkgconf\;%PATH%
@call %devroot%\mesa-dist-win\buildscript\modules\abi.cmd
@set multilib=0
@IF NOT "%multilib%"=="1" set PATH=%devroot%\%MSYSTEM%\bin\;%PATH%
@IF "%multilib%"=="1" set PATH=%devroot%\mingw64\bin\;%PATH%
@call %devroot%\mesa-dist-win\buildscript\modules\discoverpython.cmd
@call %devroot%\mesa-dist-win\buildscript\modules\pythonpackages.cmd
@cd mesa
@git checkout .
@echo.
@set buildconf=meson build/%abi% --buildtype=debugoptimized -Dllvm=disabled -Dzlib:default_library=static -Dgallium-drivers=swrast,zink
@IF NOT EXIST "%VK_SDK_PATH%" IF NOT EXIST "%VULKAN_SDK%" set buildconf=%buildconf:~0,-5%
@set LDFLAGS=-static
@IF "%multilib%"=="1" set CFLAGS=-m32
@IF "%multilib%"=="1" set CXXFLAGS=-m32
@IF "%multilib%"=="1" set LDFLAGS=%LDFLAGS% -m32
@set buildcmd=ninja -C build/%abi% -j 2
@for /d %%a in ("%devroot%\mesa\subprojects\zlib-*") do @RD /S /Q "%%~a"
@IF EXIST "%devroot%\mesa\subprojects\zlib\" RD /S /Q %devroot%\mesa\subprojects\zlib
@IF EXIST build\%abi% RD /S /Q build\%abi%
@IF EXIST %devroot%\mesa-dist-win\bin\%abi% RD /S /Q %devroot%\mesa-dist-win\bin\%abi%
@md %devroot%\mesa-dist-win\bin\%abi%
@set inst=copy /Y %devroot%\mesa\build\%abi%\src\gallium\targets\libgl-gdi\opengl32.dll %devroot%\mesa-dist-win\bin\%abi%
@cmd

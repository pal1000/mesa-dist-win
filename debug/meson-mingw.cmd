@setlocal ENABLEDELAYEDEXPANSION
@cd ..\..\
@set mesa=%CD%
@set PATH=%mesa%\ninja\;%PATH%
@set PATH=%mesa%\flexbison\;%PATH%
@set PATH=%mesa%\pkgconf\build\;%PATH%
@set buildconf=meson build/x64 --default-library=static --buildtype=release -Dllvm=false
@IF EXIST %mesa%\mesa\subprojects\zlib-1.2.11\ RD /S /Q %mesa%\mesa\subprojects\zlib-1.2.11\
@IF EXIST %mesa%\mesa\build\x64\ RD /S /Q %mesa%\mesa\build\x64\
@set PATH=%LOCALAPPDATA%\Programs\Python\Python38\;%LOCALAPPDATA%\Programs\Python\Python38\Scripts\;%PATH%
@SET PATH=!PATH:%LOCALAPPDATA%\Microsoft\WindowsApps;=!
@set PATH=%mesa%\mingw64\bin;%PATH%
@cd %mesa%\mesa
@cmd

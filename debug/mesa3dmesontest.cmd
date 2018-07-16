@set mesa=C:\Software\Development\projects\mesa
@SET PATH=C:\Software\Development\Git\cmd\;%mesa%\Python\;%mesa%\flexbison\;%mesa%\ninja\;%mesa%\pkgconfig\;%PATH%
@call "%ProgramFiles% (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" x64
@cd %mesa%
@IF NOT EXIST mesa git clone --recurse-submodules https://gitlab.freedesktop.org/dbaker/mesa.git mesa
@set meson=%mesa%\Py3\python.exe %mesa%\Py3\Scripts\meson.py
@set buildcmd=%meson% .\build\windows-x86_64 -Dosmesa=gallium
@IF EXIST %mesa%\mesa\build\windows-x86_64 RD /S /Q %mesa%\mesa\build\windows-x86_64
@cmd

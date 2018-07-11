@set mesa=C:\Software\Development\projects\mesa
@SET PATH=C:\Software\Development\Git\cmd\;%mesa%\Python\;%mesa%\flexbison\;%mesa%\ninja\;%mesa%\pkgconfig\;%PATH%
@call "%ProgramFiles% (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" x64
@cd %mesa%\mesa
@set meson==%mesa%\Py3\python.exe %mesa%\Py3\Scripts\meson.py
@set buildcmd=%meson% .\build\windows-x86_64 -Dosmesa=gallium
@RD /S /Q %mesa%\mesa\build\windows-x86_64
@cmd

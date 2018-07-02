@set mesa=C:\Software\Development\projects\mesa
@SET PATH=C:\Software\Development\Git\cmd\;%mesa%\Python\;%mesa%\Py3\;%mesa%\Py3\Scripts\;%mesa%\flexbison\;%mesa%\ninja\;%mesa%\pkgconfig\;%PATH%
@call "%ProgramFiles% (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" x64
@cd %mesa%\mesa
@set buildcmd=%mesa%\Py3\python.exe %mesa%\Py3\Scripts\meson.py . .\build\windows-x86_64
@RD /S /Q %mesa%\mesa\build\windows-x86_64
@cmd

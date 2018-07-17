@set mesa=C:\Software\Development\projects\mesa
@set abi=x64
@SET PATH=C:\Software\Development\Git\cmd\;%mesa%\Python\;%mesa%\flexbison\;%mesa%\ninja\;%mesa%\pkgconfig\;%PATH%
@call "%ProgramFiles% (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" x64
@cd %mesa%
@IF NOT EXIST mesa git clone --recurse-submodules --branch=meson-windows https://gitlab.freedesktop.org/dbaker/mesa.git mesa
@set meson=%mesa%\Py3\python.exe %mesa%\Py3\Scripts\meson.py
@set buildconf=%meson% .\%abi%
@set buildcmd=ninja -C .\%abi%
@IF EXIST %mesa%\mesa\%abi% RD /S /Q %mesa%\mesa\%abi%
@cd mesa
@rem IF EXIST %mesa%\llvm\%abi% SET PATH=%mesa%\llvm\%abi%\bin\;%PATH%
@cmd

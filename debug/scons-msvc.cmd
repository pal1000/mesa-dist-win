@cd "%~dp0"
@cd ..\..\
@for %%a in ("%cd%") do @set devroot=%%~sa
@set msysstate=0
@set projectname=mesa-dist-win
@call %devroot%\%projectname%\buildscript\modules\toolchain.cmd
@call %devroot%\%projectname%\buildscript\modules\abi.cmd
@call %devroot%\%projectname%\buildscript\modules\discoverpython.cmd
@python -m pip install -U pip setuptools MarkupSafe Mako pywin32 scons
@echo.
@call %devroot%\%projectname%\buildscript\modules\throttle.cmd
@set LLVM=%devroot%\llvm\%abi%
@IF EXIST "%devroot%\mesa\build\" RD /S /Q %devroot%\mesa\build
@call %devroot%\%projectname%\buildscript\modules\winflexbison.cmd
@IF %flexstate% EQU 1 SET PATH=%devroot%\flexbison\;%PATH%
@cd %devroot%\mesa
@set buildcmd=scons -j%throttle% build=release machine=x86
@IF %abi%==x64 set buildcmd=%buildcmd%_64
@echo Build command: %buildcmd%
@echo.
@cmd

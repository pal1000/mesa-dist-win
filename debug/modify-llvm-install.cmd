@cd "%~dp0"
@cd ..\..\
@for %%a in ("%cd%") do @set devroot=%%~sa
@set msysstate=0
@set projectname=mesa-dist-win
@call %devroot%\%projectname%\buildscript\modules\toolchain.cmd
@call %devroot%\%projectname%\buildscript\modules\abi.cmd
@call %devroot%\%projectname%\buildscript\modules\discoverpython.cmd
@call %devroot%\%projectname%\buildscript\modules\pythonpackages.cmd
@call %devroot%\%projectname%\buildscript\modules\throttle.cmd
@IF %toolchain%==msvc call %devroot%\%projectname%\buildscript\modules\cmake.cmd
@IF %toolchain%==msvc call %devroot%\%projectname%\buildscript\modules\ninja.cmd
@call %vsenv% %vsabi%
@IF NOT EXIST %devroot%\llvm\buildsys-%abi% echo FATAL^: LLVM build is not configured.
@IF NOT EXIST %devroot%\llvm\buildsys-%abi% echo.
@IF NOT EXIST %devroot%\llvm\buildsys-%abi% pause
@IF NOT EXIST %devroot%\llvm\buildsys-%abi% exit
@cd %devroot%\llvm\buildsys-%abi%
@cmd

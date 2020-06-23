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
@call %devroot%\%projectname%\buildscript\modules\cmake.cmd
@call %devroot%\%projectname%\buildscript\modules\ninja.cmd
@IF %ninjastate% EQU 1 SET PATH=%devroot%\ninja\;%PATH%
@IF %cmakestate% EQU 1 SET PATH=%devroot%\cmake\bin\;%PATH%
@call %vsenv% %vsabi%
@set llvmloc=%devroot%\llvm-project
@IF NOT EXIST %llvmloc%\buildsys-%abi% set llvmloc=%devroot%\llvm
@IF NOT EXIST %llvmloc%\buildsys-%abi% echo FATAL^: LLVM build is not configured.
@IF NOT EXIST %llvmloc%\buildsys-%abi% echo.
@IF NOT EXIST %llvmloc%\buildsys-%abi% pause
@IF NOT EXIST %llvmloc%\buildsys-%abi% exit
@cd %llvmloc%\buildsys-%abi%
@cmd

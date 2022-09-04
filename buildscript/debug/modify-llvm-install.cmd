@cd /d "%~dp0"
@cd ..\..\..\
@set CD=
@set devroot=%CD%
@IF %devroot:~0,1%%devroot:~-1%=="" set devroot=%devroot:~1,-1%
@IF "%devroot:~-1%"=="\" set devroot=%devroot:~0,-1%
@set msysstate=0
@set projectname=mesa-dist-win
@set TITLE=Modify LLVM build
@call "%devroot%\%projectname%\buildscript\modules\toolchain.cmd"
@call "%devroot%\%projectname%\buildscript\modules\abi.cmd"
@call "%devroot%\%projectname%\buildscript\modules\discoverpython.cmd"
@call "%devroot%\%projectname%\buildscript\modules\pythonpackages.cmd"
@call "%devroot%\%projectname%\buildscript\modules\throttle.cmd"
@call "%devroot%\%projectname%\buildscript\modules\cmake.cmd"
@call "%devroot%\%projectname%\buildscript\modules\ninja.cmd"
@IF %ninjastate% EQU 1 SET PATH=%devroot%\ninja\;%PATH%
@IF %cmakestate% EQU 1 SET PATH=%devroot%\cmake\bin\;%PATH%
@call %vsenv% %vsabi%
@set llvmloc=%devroot%\llvm-project
@IF NOT EXIST "%llvmloc%\build\buildsys-%abi%\" set llvmloc=%devroot%\llvm
@IF NOT EXIST "%llvmloc%\build\buildsys-%abi%\" echo FATAL^: LLVM build is not configured.
@IF NOT EXIST "%llvmloc%\build\buildsys-%abi%\" echo.
@IF NOT EXIST "%llvmloc%\build\buildsys-%abi%\" pause
@IF NOT EXIST "%llvmloc%\build\buildsys-%abi%\" exit
@cd "%llvmloc%\build\buildsys-%abi%"
@cmd

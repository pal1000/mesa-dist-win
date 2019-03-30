@cd "%~dp0"
@cd ..\..\
@for %%a in ("%cd%") do @set mesa=%%~sa
@set abi=x86
@set longabi=%abi%
@if %abi%==x64 set longabi=x86_64
@call %mesa%\mesa-dist-win\buildscript\modules\msys.cmd
@set MSYSTEM=MINGW64
@cmd /k echo.
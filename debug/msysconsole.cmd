@cd "%~dp0"
@cd ..\..\
@for %%a in ("%cd%") do @set mesa=%%~sa
@set abi=x86
@set longabi=%abi%
@if %abi%==x64 set longabi=x86_64
@call %mesa%\mesa-dist-win\buildscript\modules\msys.cmd
@set MSYSTEM=MINGW32
@set /p clean=Clear MSYS2 cache (y/n):
@IF /I "%clean%"=="y" RD /S /Q %msysloc%\var\cache\pacman\pkg
@IF /I "%clean%"=="y" MD %msysloc%\var\cache\pacman\pkg
@cmd /k echo.
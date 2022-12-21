@setlocal ENABLEDELAYEDEXPANSION
@set dxilloc=null
@for /f delims^=^ eol^= %%a in ('@call "%devroot%\%projectname%\buildscript\modules\winsdkloc.cmd"') do @IF EXIST "%%a" for /R "%%a\bin" %%b in (dxil.dl?) do @if "%%~nxb"=="dxil.dll" (
@set dxilloc=%%~dpb
@IF "!dxilloc:~-1!"=="\" set dxilloc=!dxilloc:~0,-1!
@IF !dxilloc:~-3!==%abi% echo "!dxilloc!\dxil.dll"
)
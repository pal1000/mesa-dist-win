@setlocal ENABLEDELAYEDEXPANSION
@set dxilloc=null
@IF %dxilloc%==null for /f delims^=^ eol^= %%a in ('@call "%devroot%\%projectname%\buildscript\modules\winsdkloc.cmd"') do @IF EXIST "%%a" for /R "%%a\bin" %%b in (dxil.dl?) do @if "%%~nxb"=="dxil.dll" (
@set dxilloc="%%~fb"
@IF NOT "!dxilloc:~-13,3!"=="%abi%" set dxilloc=null
)
@echo %dxilloc%
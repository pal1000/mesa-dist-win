@setlocal ENABLEDELAYEDEXPANSION
@set dxilloc=null
@if EXIST "%devroot%\dxc\bin\%abi%\dxil.dll" set dxilloc="%devroot%\dxc\bin\%abi%\dxil.dll"
@IF %dxilloc%==null for /f delims^=^ eol^= %%a in ('dir /b /s "%winsdkloc%\dxil.dll" 2^>nul ^| find /V "\bin\" ^| find "\%abi%\"') do @if EXIST "%%~a" set dxilloc="%%~a"
@echo %dxilloc%
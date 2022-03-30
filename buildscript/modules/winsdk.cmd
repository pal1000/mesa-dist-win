@setlocal ENABLEDELAYEDEXPANSION
@set winsdk=null
@IF /I NOT %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%ProgramFiles%\Windows Kits\10\Redist" set winsdk=%ProgramFiles%\Windows Kits\10
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%ProgramFiles% (x86)\Windows Kits\10\Redist" set winsdk=%ProgramFiles% (x86)\Windows Kits\10
@IF NOT "%winsdk%"=="null" IF "%1"=="dxil" for /R "%winsdk%\bin" %%a in (dxil.dl?) do @if "%%~nxa"=="dxil.dll" (
@set dxilloc=%%~dpa
@IF "!dxilloc:~-1!"=="\" set dxilloc=!dxilloc:~0,-1!
@IF !dxilloc:~-3!==%abi% echo "!dxilloc!\dxil.dll"
)
@IF NOT "%winsdk%"=="null" IF "%1"=="wdk" IF EXIST "%devroot%\mesa\include\winddk\.gitignore" set winwdkcount=0
@IF NOT "%winsdk%"=="null" IF "%1"=="wdk" IF EXIST "%devroot%\mesa\include\winddk\.gitignore" for /f delims^=^ eol^= %%a in ('type "%devroot%\mesa\include\winddk\.gitignore"') do @(
set /a winwdkcount-=1
for /f delims^=^ eol^= %%b in ('dir /b /s "%winsdk%\%%a" 2^>nul') do @if /I "%%~nxa"=="%%~nxb" set /a winwdkcount+=1
)
@IF "%winwdkcount%"=="0" echo OK
@IF "%winsdk%"=="null" IF NOT "%1"=="" echo null
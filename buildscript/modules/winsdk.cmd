@setlocal ENABLEDELAYEDEXPANSION
@set winsdk=null
@IF /I NOT %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%ProgramFiles%\Windows Kits\10\Redist" set winsdk=%ProgramFiles%\Windows Kits\10
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%ProgramFiles% (x86)\Windows Kits\10\Redist" set winsdk=%ProgramFiles% (x86)\Windows Kits\10
@IF NOT "%winsdk%"=="null" IF "%1"=="dxil" for /f tokens^=^* %%a in ('dir /b /s "%winsdk%\bin"') do @if "%%~nxa"=="dxil.dll" (
@set dxilloc=%%~dpa
@IF "!dxilloc:~-1!"=="\" set dxilloc=!dxilloc:~0,-1!
@IF !dxilloc:~-3!==%abi% echo "!dxilloc!\dxil.dll"
)
@IF "%winsdk%"=="null" IF "%1"=="dxil" echo null
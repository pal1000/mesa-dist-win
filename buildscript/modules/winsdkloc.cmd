@setlocal
@set winsdk=null
@IF EXIST "%ProgramFiles%\Windows Kits\10\Redist" set winsdk=%ProgramFiles%\Windows Kits\10
@IF "%winsdk%"=="null" IF EXIST "%ProgramFiles% (x86)\Windows Kits\10\Redist" set winsdk=%ProgramFiles% (x86)\Windows Kits\10
@echo %winsdk%
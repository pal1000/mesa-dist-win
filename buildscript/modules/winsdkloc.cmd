@setlocal
@set winsdk=null
@IF /I NOT %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%ProgramFiles%\Windows Kits\10\Redist" set winsdk=%ProgramFiles%\Windows Kits\10
@IF /I %PROCESSOR_ARCHITECTURE%==AMD64 IF EXIST "%ProgramFiles% (x86)\Windows Kits\10\Redist" set winsdk=%ProgramFiles% (x86)\Windows Kits\10
@echo %winsdk%

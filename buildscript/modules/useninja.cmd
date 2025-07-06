@if %cimode% EQU 0 set useninja=n
@IF NOT %toolchain%==msvc set useninja=y
@IF %toolchain%==msvc if %ninjastate% GTR 0 IF "%*"=="" call "%devroot%\%projectname%\bin\modules\prompt.cmd" useninja "Use Ninja build system for less storage device strain and faster build than MsBuild (y/n):"
@IF %toolchain%==msvc if /I "%useninja%"=="y" if %ninjastate%==1 set PATH=%devroot%\ninja\;%PATH%

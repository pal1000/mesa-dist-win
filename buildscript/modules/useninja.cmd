@set useninja=n
@IF %toolchain%==msvc if %ninjastate% GTR 0 IF "%*"=="" set /p useninja=Use Ninja build system instead of MsBuild for less storage device strain and faster build (y/n):
@IF %toolchain%==msvc if %ninjastate% GTR 0 IF "%*"=="" echo.
@IF NOT %toolchain%==msvc set useninja=y
@IF %toolchain%==msvc if /I "%useninja%"=="y" if %ninjastate%==1 set PATH=%devroot%\ninja\;%PATH%

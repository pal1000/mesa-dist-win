@setlocal
@IF NOT %toolchain%==msvc set mesonloc=%runmsys% cd "%devroot%\mesa";/%LMSYSTEM%/bin/meson
@IF NOT %toolchain%==msvc GOTO foundmeson
@IF %mesonstate%==2 set mesonloc=meson.exe
@IF %mesonstate%==2 GOTO foundmeson

@set mesonloc=%pythonloc:~0,-11%Scripts\meson.exe"
@IF NOT EXIST %mesonloc% set mesonloc=%pythonloc% %mesonloc:~0,-4%py"

:foundmeson
@endlocal&set mesonloc=%mesonloc%

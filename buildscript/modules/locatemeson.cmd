@setlocal
@IF NOT %toolchain%==msvc set mesonloc=%runmsys% cd "%devroot%\mesa";
@IF NOT %toolchain%==msvc IF %gitstate% GTR 0 set mesonloc=%mesonloc%PATH=${PATH}:${gitloc};
@IF NOT %toolchain%==msvc set mesonloc=%mesonloc%${MINGW_PREFIX}/bin/meson
@IF NOT %toolchain%==msvc GOTO foundmeson
@IF %mesonstate%==2 set mesonloc=meson.exe
@IF %mesonstate%==2 GOTO foundmeson

@set mesonloc=%pythonloc:~0,-10%Scripts\meson.exe
@IF NOT EXIST %mesonloc% set mesonloc=%pythonloc% %mesonloc:~0,-3%py

:foundmeson
@endlocal&set mesonloc=%mesonloc%
